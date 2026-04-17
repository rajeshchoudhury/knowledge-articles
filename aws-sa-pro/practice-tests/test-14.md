# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 14

**Focus Areas:** Hybrid Connectivity (Direct Connect + VPN), DNS Resolution, Directory Services, Storage Gateway
**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain Distribution
- Domain 1 – Organizational Complexity: Questions 1–20
- Domain 2 – Design New Solutions: Questions 21–42
- Domain 3 – Continuous Improvement: Questions 43–53
- Domain 4 – Migration: Questions 54–62
- Domain 5 – Cost Optimization: Questions 63–75

---

### Question 1

A financial services company has a primary data center in New York and a disaster recovery site in Chicago. They need to establish connectivity to their AWS us-east-1 workloads. The compliance team mandates that all traffic between on-premises and AWS must be encrypted, and the architecture must sustain the failure of any single connectivity component without downtime. The company currently has no AWS connectivity and needs a solution operational within 8 weeks.

Which architecture provides the MOST resilient encrypted connectivity while meeting the timeline?

A. Order two AWS Direct Connect dedicated connections from separate DX locations to separate VGWs, and configure MACsec encryption on both connections. Set up an on-premises router at each data center to terminate the DX connections.

B. Set up a Transit Gateway with two VPN attachments from the New York data center and two VPN attachments from the Chicago data center, using ECMP for load balancing. After connectivity is verified, order Direct Connect connections as a longer-term solution.

C. Order a single Direct Connect connection from a DX location near New York and configure a site-to-site VPN over the DX connection using a public VIF. Establish an additional standalone VPN connection over the internet as backup.

D. Order two Direct Connect connections from the same DX location for cost efficiency, configure private VIFs on both connections, and establish IPsec VPN tunnels over each private VIF for encryption.

**Correct Answer: B**

**Explanation:** Given the 8-week timeline, Direct Connect provisioning (which typically takes 4-12 weeks) is risky. VPN connections over the internet (B) can be established quickly and provide encrypted connectivity by default. Using Transit Gateway with ECMP across 4 VPN connections (2 per site) provides high availability and bandwidth aggregation. This meets all requirements immediately while DX can be ordered in parallel. Option A requires DX provisioning which may exceed the timeline. Option C has a single point of failure with one DX connection. Option D uses the same DX location, creating a location-level single point of failure.

---

### Question 2

A multinational company operates workloads in us-east-1 and eu-west-1 using a Transit Gateway in each region with inter-region peering. They have a Direct Connect gateway attached to both Transit Gateways. Their on-premises data center connects via a single 10 Gbps dedicated Direct Connect connection with transit VIFs. Users report intermittent connectivity issues when accessing eu-west-1 resources from on-premises.

Which is the MOST likely root cause?

A. Transit Gateway inter-region peering does not support routing traffic from Direct Connect through one region to reach another region via peering.

B. The Direct Connect gateway does not support attaching to multiple Transit Gateways in different regions simultaneously.

C. The transit VIF is configured with incorrect BGP communities for regional routing preference.

D. The CIDR blocks advertised from the two Transit Gateways to the Direct Connect gateway have overlapping allowed prefixes configured.

**Correct Answer: A**

**Explanation:** AWS Direct Connect Gateway associated with Transit Gateways does NOT support routing traffic from an on-premises network through one Transit Gateway, across a peering connection, to a Transit Gateway in another region. This is a known architectural limitation. To reach eu-west-1 from on-premises, you would need a separate transit VIF (or a separate DX connection) associated with the eu-west-1 Transit Gateway via the DX gateway. Option B is incorrect because DX gateways do support multiple TGW associations across regions. Option C is plausible but not the root cause for complete intermittent failures. Option D could cause issues but wouldn't explain the cross-region routing problem.

---

### Question 3

A company uses AWS Managed Microsoft AD in us-east-1 as their directory service for 5,000 users. They are expanding to eu-west-1 and need authentication for EC2 instances and Amazon WorkSpaces in both regions. Users should authenticate with the same credentials in both regions. The company wants to minimize operational overhead and maintain centralized user management.

Which approach BEST meets these requirements?

A. Create a new AWS Managed Microsoft AD in eu-west-1 and configure a two-way forest trust with the us-east-1 directory. Manually sync users between directories using a Lambda function.

B. Configure multi-Region replication for the existing AWS Managed Microsoft AD to eu-west-1. Join EC2 instances and WorkSpaces in eu-west-1 to the replicated directory.

C. Deploy an AD Connector in eu-west-1 that points to the us-east-1 AWS Managed Microsoft AD over a VPN or Direct Connect connection between the regions.

D. Create a new AWS Managed Microsoft AD in eu-west-1, establish a two-way trust with us-east-1, and use the eu-west-1 directory for local authentication while user management remains in us-east-1.

**Correct Answer: B**

**Explanation:** AWS Managed Microsoft AD supports multi-Region replication, allowing you to deploy the directory data to additional regions. This provides local authentication in eu-west-1 with automatic replication of users, groups, and policies — no manual sync needed. It minimizes operational overhead and keeps centralized management in the primary region. Option A requires manual user synchronization which adds overhead. Option C would work but introduces cross-region latency for every authentication request, degrading user experience. Option D requires managing trusts and two separate directories, increasing operational complexity compared to native multi-Region replication.

---

### Question 4

A healthcare organization uses Amazon FSx for Windows File Server integrated with their on-premises Active Directory via AWS Direct Connect. They notice that Windows clients in AWS can join the domain but cannot resolve the names of on-premises domain controllers or file servers. On-premises clients can resolve all AWS resources correctly. The VPC has a DHCP option set configured with AmazonProvidedDNS.

What should the solutions architect do to resolve the DNS issue with MINIMAL operational changes?

A. Create Amazon Route 53 Resolver outbound endpoints in the VPC. Configure forwarding rules to forward the on-premises domain DNS queries to the on-premises DNS servers.

B. Replace the DHCP option set to point to on-premises DNS server IP addresses instead of AmazonProvidedDNS.

C. Deploy custom EC2-based DNS servers in the VPC that forward queries to both AmazonProvidedDNS and on-premises DNS servers.

D. Configure conditional forwarding on the on-premises DNS servers to forward AWS private hosted zone queries to the Route 53 Resolver inbound endpoints.

**Correct Answer: A**

**Explanation:** Route 53 Resolver outbound endpoints (A) allow the VPC's DNS resolver (AmazonProvidedDNS) to forward specific domain queries to on-premises DNS servers. By creating forwarding rules for the on-premises domain, AWS resources can resolve on-premises names while still using Route 53 for AWS resources. This is the minimal-change, AWS-native approach. Option B would break resolution of AWS resources (like S3 endpoints, private hosted zones) since on-premises DNS servers may not forward to Route 53. Option C adds operational overhead of managing EC2 instances. Option D solves on-premises-to-AWS resolution (which already works), not the AWS-to-on-premises direction.

---

### Question 5

A company is deploying AWS Storage Gateway (File Gateway) to provide on-premises applications access to S3 storage. The File Gateway must support NFS and SMB protocols, authenticate SMB users against the company's on-premises Active Directory, and serve frequently accessed files with low latency. The total dataset is 50 TB, but only about 5 TB is actively used.

Which combination of configurations is CORRECT? (Choose TWO.)

A. Deploy the File Gateway as a VM on-premises with at least 150 GiB of local cache disk to cache the active working set of 5 TB.

B. Configure the File Gateway to join the on-premises Active Directory domain for SMB authentication and set up file share access controls using AD users and groups.

C. Deploy the File Gateway as an EC2 instance in AWS to leverage the high-speed connection between the gateway and S3.

D. Configure S3 Intelligent-Tiering on the target bucket to automatically optimize storage costs for the 50 TB dataset.

E. Deploy the File Gateway with a 50 TB cache disk to ensure the entire dataset is cached locally.

**Correct Answer: A, B**

**Explanation:** The File Gateway should be deployed on-premises (A) to provide low-latency access to frequently accessed data. The cache disk doesn't need to hold the entire dataset — only the active working set. AWS recommends sizing the cache to accommodate your working set. For SMB authentication (B), File Gateway natively supports joining an Active Directory domain. Option C defeats the purpose since the gateway should be close to the on-premises applications for low latency. Option D is about S3 storage classes, which is independent of File Gateway caching. Option E is wasteful — the cache only needs to hold the active working set, not the entire 50 TB dataset.

---

### Question 6

A company has established a 10 Gbps dedicated Direct Connect connection. They use a private VIF to access VPC resources and a public VIF for accessing AWS public services like S3. The network team notices that large S3 data transfers are consuming most of the bandwidth, impacting VPC traffic performance.

Which solution provides the MOST effective bandwidth management?

A. Create a second Direct Connect connection dedicated to S3 traffic and use BGP route manipulation to direct S3 traffic over the new connection.

B. Enable S3 Transfer Acceleration to route S3 traffic through CloudFront edge locations instead of the Direct Connect connection.

C. Configure a VPC interface endpoint for S3 and route S3 traffic through the private VIF instead of the public VIF, then remove the public VIF.

D. Implement a hosted connection with a smaller bandwidth allocation for the public VIF traffic, and keep the dedicated connection for private VIF traffic.

**Correct Answer: C**

**Explanation:** Creating a VPC interface endpoint (powered by PrivateLink) for S3 allows S3 traffic to flow through the private VIF as private traffic. You can then apply Transit Gateway or VPC route table policies to manage traffic flows. However, the most effective approach is to use the interface endpoint which gives a private IP within the VPC for S3 access. This consolidates all traffic onto the private VIF where you can use Link Aggregation Group (LAG) or QoS policies at the network layer. Option A is expensive. Option B routes traffic over the internet, not Direct Connect. Option D doesn't directly solve bandwidth contention as hosted connections share the same physical connection.

---

### Question 7

An enterprise is migrating from on-premises to AWS and needs to maintain their existing Microsoft Active Directory for authentication. They have 15,000 users and 500 applications. The AD schema has been extended with custom attributes for several applications. They need seamless SSO to both on-premises and AWS resources during the migration period.

Which directory strategy BEST supports this migration?

A. Deploy AWS Managed Microsoft AD in AWS and create a two-way forest trust with the on-premises AD. Keep custom schema extensions on-premises and configure applications to query the appropriate directory.

B. Deploy AD Connector to proxy authentication requests to the on-premises AD. Migrate applications to use AD Connector as their LDAP endpoint.

C. Extend the on-premises Active Directory to AWS by deploying domain controllers on EC2 instances in the same AD forest. Use these for AWS-based application authentication.

D. Replace the on-premises AD with AWS Managed Microsoft AD and use the AWS Directory Service schema extension capability to replicate all custom schema attributes.

**Correct Answer: C**

**Explanation:** Deploying domain controllers on EC2 instances within the same AD forest (C) provides full schema compatibility including all custom attributes, seamless SSO through native AD replication, and the lowest migration risk. This approach maintains a single forest/domain, so all 500 applications continue working without changes. Option A creates a separate forest, meaning custom schema extensions won't replicate across the trust, breaking applications that depend on them. Option B only proxies requests back to on-premises, creating latency for AWS workloads and a dependency on connectivity. Option D is high-risk — replacing the AD during migration could break authentication for all 500 applications.

---

### Question 8

A company has a Direct Connect connection with a private VIF attached to a VGW associated with VPC-A. They also have VPC-B, VPC-C, and VPC-D peered with VPC-A. On-premises users report they can access resources in VPC-A but not in VPC-B, VPC-C, or VPC-D.

What is the root cause and solution?

A. VPC peering does not support transitive routing. Replace the VGW with a Transit Gateway, attach all VPCs, and associate the Direct Connect gateway with the Transit Gateway using a transit VIF.

B. The route tables in VPC-B, VPC-C, and VPC-D are missing routes to the on-premises CIDR via the peering connections. Add the appropriate routes.

C. The VGW does not propagate on-premises routes to peered VPCs. Enable route propagation in VPC-B, VPC-C, and VPC-D route tables.

D. The private VIF bandwidth is insufficient for traffic to all four VPCs. Increase the Direct Connect connection bandwidth.

**Correct Answer: A**

**Explanation:** VPC peering is non-transitive — traffic entering VPC-A via the VGW (Direct Connect) cannot traverse VPC peering connections to reach VPC-B, C, or D. This is a fundamental VPC peering limitation. The solution is to use Transit Gateway (A) which supports transitive routing. By attaching all VPCs to the Transit Gateway and associating the Direct Connect gateway (via a transit VIF), on-premises traffic can reach all VPCs. Option B is incorrect because even with correct routes, VPC peering doesn't allow transitive routing. Option C is incorrect for the same reason — route propagation can't overcome the non-transitive limitation. Option D is irrelevant to the routing issue.

---

### Question 9

A company needs to resolve DNS names between their on-premises data center and multiple VPCs. They have VPCs in us-east-1, us-west-2, and eu-west-1, each with private hosted zones. The on-premises data center should be able to resolve records in all three private hosted zones, and all VPCs should be able to resolve on-premises DNS names. The company uses a single Direct Connect gateway with transit VIFs to each region's Transit Gateway.

Which architecture meets these requirements with the LEAST operational overhead?

A. Create Route 53 Resolver inbound endpoints in each VPC across all three regions. Configure on-premises DNS servers with conditional forwarding rules pointing to the inbound endpoints in each region for the corresponding hosted zone.

B. Create Route 53 Resolver inbound and outbound endpoints in one VPC in us-east-1. Associate all three private hosted zones with this VPC. Configure outbound forwarding rules for the on-premises domain. Point on-premises DNS servers to the us-east-1 inbound endpoints.

C. Deploy EC2-based DNS forwarders in each VPC that consolidate and forward queries between all parties.

D. Create Route 53 Resolver inbound and outbound endpoints in each of the three VPCs. Configure forwarding rules in each region for the on-premises domain and configure on-premises servers to forward to all three sets of inbound endpoints.

**Correct Answer: B**

**Explanation:** Centralizing Route 53 Resolver endpoints in one VPC (B) minimizes the number of endpoints to manage. You can associate private hosted zones from any region with a VPC in us-east-1, enabling the Resolver to answer queries for all three hosted zones. The outbound endpoint handles forwarding to on-premises, and the inbound endpoint handles queries from on-premises. This requires cross-region VPC connectivity (already available via Transit Gateway) but significantly reduces operational overhead compared to deploying endpoints in every region. Option A deploys inbound endpoints everywhere but doesn't address AWS-to-on-premises resolution. Option C adds significant operational burden. Option D works but triples the infrastructure and configuration overhead.

---

### Question 10

An organization uses AWS Storage Gateway (Volume Gateway) in cached mode to provide iSCSI storage to on-premises applications. They need to ensure business continuity in case the on-premises gateway appliance fails. The RTO is 2 hours and RPO is 15 minutes. The total volume size is 20 TB.

Which disaster recovery strategy BEST meets these requirements?

A. Take EBS snapshots of the Volume Gateway volumes every 15 minutes. In the event of failure, deploy a new Volume Gateway appliance, create volumes from the latest snapshots, and mount them.

B. Deploy a second Volume Gateway appliance at a secondary on-premises site with cloned volumes. Use Storage Gateway's built-in replication to keep volumes synchronized.

C. Take EBS snapshots every 15 minutes using a scheduled Lambda function. In case of failure, create EBS volumes from snapshots, attach them to an EC2 instance, and provide iSCSI access via an EC2-hosted iSCSI target.

D. Configure the Volume Gateway to create snapshots on a 15-minute schedule. If the gateway fails, deploy a new File Gateway appliance and restore the data from S3 directly.

**Correct Answer: A**

**Explanation:** Volume Gateway cached mode stores data in S3 with local cache. EBS snapshots can be created from gateway volumes on a schedule (A). When the appliance fails, deploying a new Volume Gateway (VM or hardware) and creating new volumes from the latest snapshots meets the 2-hour RTO. Since snapshots are taken every 15 minutes, RPO is met. The new gateway populates its cache as data is accessed. Option B is incorrect because Volume Gateway doesn't have built-in cross-gateway replication. Option C works but introduces complexity of managing an EC2 iSCSI target that on-premises applications might not easily connect to. Option D incorrectly suggests using a File Gateway (NFS/SMB) to restore Volume Gateway (iSCSI) data — these are different gateway types with incompatible protocols.

---

### Question 11

A company's on-premises DNS infrastructure uses BIND servers. They are deploying a hybrid DNS architecture with AWS. They need the following: on-premises clients must resolve *.aws.example.com (hosted in a Route 53 private hosted zone), and AWS EC2 instances must resolve *.corp.example.com (hosted on the on-premises BIND servers). The VPC uses the default AmazonProvidedDNS.

Which configuration correctly enables bidirectional DNS resolution?

A. Create Route 53 Resolver inbound endpoints and outbound endpoints in the VPC. Configure outbound forwarding rules for corp.example.com pointing to the on-premises BIND servers. Configure on-premises BIND servers with conditional forwarding for aws.example.com pointing to the inbound endpoint IP addresses.

B. Modify the VPC DHCP option set to use the on-premises BIND servers. Configure the BIND servers to forward aws.example.com queries to the Route 53 Resolver.

C. Create Route 53 Resolver outbound endpoints only. Configure forwarding rules for both corp.example.com (to on-premises) and aws.example.com (to Route 53 Resolver inbound). Configure BIND servers with forwarding for aws.example.com.

D. Deploy a Route 53 public hosted zone for aws.example.com so that on-premises clients can resolve it via public DNS without any special configuration.

**Correct Answer: A**

**Explanation:** Bidirectional DNS resolution requires both inbound and outbound Route 53 Resolver endpoints (A). Outbound endpoints forward queries from the VPC to on-premises BIND servers for corp.example.com. Inbound endpoints accept queries from on-premises BIND servers for aws.example.com (the private hosted zone). The BIND servers need conditional forwarding configured to send aws.example.com queries to the inbound endpoint IPs. Option B would break AWS-native DNS resolution for VPC resources. Option C is incorrect — outbound endpoints forward queries FROM the VPC, not TO the VPC; you need inbound endpoints for on-premises to query Route 53. Option D exposes private resources publicly, which is a security concern.

---

### Question 12

A company has two AWS Direct Connect locations providing redundant 10 Gbps connections. They want to implement an active/active configuration for maximum throughput while ensuring automatic failover. All traffic goes to a single VPC through a VGW. Currently, on-premises routers send traffic over only one connection despite both being healthy.

What should the solutions architect recommend?

A. Configure both Direct Connect connections in a Link Aggregation Group (LAG) to create a single 20 Gbps logical connection with automatic failover.

B. Adjust the BGP AS-PATH prepending on the underutilized connection's on-premises router to make both paths equally preferred. Ensure both connections advertise and receive the same prefixes.

C. Replace the VGW with a Transit Gateway and configure ECMP routing. Establish the Direct Connect connections via transit VIFs through a Direct Connect gateway to the Transit Gateway.

D. Create two separate private VIFs on two separate VGWs and split the VPC subnets across the two VGWs for load distribution.

**Correct Answer: C**

**Explanation:** VGW does NOT support ECMP — it uses a single best path for routing, which is why traffic flows over only one connection. Transit Gateway supports ECMP for Direct Connect connections using transit VIFs, enabling active/active traffic distribution across both connections. Option A is incorrect because LAG requires connections from the same DX location — the connections are in two different locations. Option B won't achieve ECMP with a VGW since VGW always selects a single best path regardless of AS-PATH equivalence. Option D is architecturally incorrect — you can only associate one VGW per VPC.

---

### Question 13

A media company stores 500 TB of video content on-premises and needs to provide content editors in AWS with low-latency access to this data. The editors use Linux-based EC2 instances. Only about 20 TB is actively being edited at any time, but any file might be needed. New content is generated on-premises and must be available in AWS within minutes. Modified content in AWS must be written back to on-premises storage.

Which solution provides the BEST performance for this use case?

A. Deploy an Amazon S3 File Gateway on-premises. Editors in AWS access the S3 bucket directly. Use S3 event notifications to trigger Lambda functions for synchronization back to on-premises.

B. Deploy Amazon FSx for Lustre linked to an S3 bucket. Use AWS DataSync to continuously replicate on-premises data to S3. Editors access FSx for Lustre from EC2 instances.

C. Deploy Amazon FSx for NetApp ONTAP with a FlexCache volume in AWS. Configure SnapMirror replication from the on-premises NetApp storage to FSx.

D. Use AWS Transfer Family with SFTP endpoints. Editors upload and download files as needed. Automate transfers with scheduled scripts.

**Correct Answer: B**

**Explanation:** FSx for Lustre (B) provides high-performance POSIX-compatible file system access for Linux instances, ideal for media editing workloads. Linking it to an S3 bucket that receives continuous replication from on-premises via DataSync ensures new content is available within minutes. FSx for Lustre can lazy-load files from S3 when first accessed and write modified files back to S3. DataSync can then replicate changes back to on-premises. Option A doesn't provide the high-throughput parallel access needed for video editing. Option C would work well if the company uses NetApp on-premises, but the question doesn't state this and it's more expensive. Option D has poor user experience for interactive editing workflows.

---

### Question 14

A government agency requires that all DNS queries from their VPCs be logged for security audit purposes. They have 30 VPCs across 5 AWS accounts in a single region. The logs must be retained for 7 years, queryable within the last 90 days, and archived afterward. The logging solution must be centralized and automated for new VPCs.

Which solution MOST efficiently meets these requirements?

A. Enable VPC Flow Logs on all VPCs with a filter for DNS traffic (port 53) and send logs to a centralized S3 bucket with lifecycle policies.

B. Enable Route 53 Resolver query logging on each VPC. Use AWS RAM to share the query logging configuration across accounts. Send logs to a centralized CloudWatch Logs log group with a 90-day retention policy and a subscription filter to stream older logs to S3 with Glacier lifecycle rules.

C. Enable Route 53 Resolver query logging using an organizational configuration in a delegated administrator account. Send logs to a centralized S3 bucket. Use Amazon Athena for querying recent logs and configure S3 Lifecycle rules to transition to Glacier Deep Archive after 90 days.

D. Deploy custom DNS forwarders on EC2 instances in each VPC that log all queries to a centralized Elasticsearch cluster.

**Correct Answer: C**

**Explanation:** Route 53 Resolver query logging (C) captures all DNS queries made within a VPC. Using organizational configuration with a delegated administrator automates deployment across all existing and new VPCs in the organization. Sending logs directly to S3 with Athena provides cost-effective querying for recent logs, and lifecycle rules handle the 7-year retention by transitioning to Glacier Deep Archive after 90 days. Option A captures network flow data, not actual DNS query details (domain names, response codes). Option B could work but is more expensive for long-term storage starting with CloudWatch Logs, and RAM sharing requires per-account configuration. Option D introduces significant operational overhead.

---

### Question 15

A company has a VPN connection between their on-premises data center and AWS Transit Gateway. They need to ensure that only specific on-premises subnets (10.1.0.0/16 and 10.2.0.0/16) can communicate with specific VPCs, while blocking all other on-premises subnets from reaching AWS resources. The Transit Gateway has 8 VPCs attached.

Which method provides the MOST granular and manageable access control?

A. Configure Transit Gateway route tables with blackhole routes for unauthorized on-premises subnets in each VPC's Transit Gateway route table association.

B. Configure network ACLs on each VPC's subnets to deny traffic from unauthorized on-premises CIDR ranges.

C. Create separate Transit Gateway route tables. Associate authorized VPCs with a route table that has routes to the VPN attachment. Associate unauthorized VPCs with a route table that has no route to the VPN attachment. Configure firewall rules on the on-premises VPN device to restrict source subnets.

D. Implement AWS Network Firewall attached to the Transit Gateway to inspect and filter traffic between on-premises and VPCs based on source and destination IPs.

**Correct Answer: C**

**Explanation:** Using separate Transit Gateway route tables (C) provides clean network segmentation. The authorized VPCs' route table includes the VPN attachment with propagated on-premises routes, while unauthorized VPCs' route table omits the VPN attachment entirely, preventing any connectivity. Combined with on-premises firewall rules to restrict which subnets (10.1.0.0/16 and 10.2.0.0/16) can route to the VPN, this provides defense in depth. Option A requires maintaining blackhole routes for every unauthorized subnet, which is harder to manage. Option B requires managing NACLs across every subnet in 8 VPCs. Option D works but introduces significant cost and complexity for what is fundamentally a routing decision.

---

### Question 16

A company uses AD Connector to integrate their on-premises Active Directory with AWS for SSO to the AWS Management Console. They are expanding their AWS footprint and now need to support Amazon WorkSpaces, Amazon RDS for SQL Server with Windows Authentication, and AWS Client VPN with AD-based authentication. AD Connector currently works well for console SSO.

Which directory service changes are needed?

A. No changes needed — AD Connector supports all listed services natively.

B. Replace AD Connector with AWS Managed Microsoft AD. Establish a trust relationship with the on-premises AD. Configure all services to use the AWS Managed Microsoft AD.

C. Keep AD Connector for console SSO and deploy an additional AWS Managed Microsoft AD for services that require a full AD (RDS for SQL Server Windows Auth). Configure a trust between AWS Managed Microsoft AD and on-premises AD.

D. Deploy Simple AD to supplement AD Connector for the additional service integrations, as Simple AD is compatible with all listed services.

**Correct Answer: B**

**Explanation:** RDS for SQL Server Windows Authentication requires AWS Managed Microsoft AD — it does not support AD Connector. Similarly, some features of Amazon WorkSpaces and AWS Client VPN work better with or require AWS Managed Microsoft AD. The cleanest solution is to replace AD Connector with AWS Managed Microsoft AD (B) and establish a trust with on-premises AD, providing a single directory service for all needs. Option A is incorrect because AD Connector doesn't support RDS SQL Server Windows Auth. Option C adds unnecessary complexity with two directory services when one (AWS Managed Microsoft AD) can handle everything. Option D is incorrect because Simple AD doesn't support trusts and has limited service integration.

---

### Question 17

A multinational company has Direct Connect connections in three regions (us-east-1, eu-west-1, ap-southeast-1). Each region has a Transit Gateway, and all three Transit Gateways are peered with each other. The company wants any on-premises office (connected to the nearest regional DX) to access resources in any region with minimal latency.

After configuring everything, they find that traffic from the Singapore office to us-east-1 VPCs is routing through the public internet instead of the AWS backbone.

What is the MOST likely cause?

A. The Transit Gateway peering connections don't support transitive routing from Direct Connect attachments through peered Transit Gateways.

B. The Direct Connect gateway in ap-southeast-1 is not associated with the us-east-1 Transit Gateway, so no route exists on the AWS side.

C. The BGP advertisements from the us-east-1 Transit Gateway are not propagated to the ap-southeast-1 Transit Gateway peering route table.

D. The CIDR ranges allowed on the Direct Connect gateway association for ap-southeast-1 do not include the us-east-1 VPC CIDRs.

**Correct Answer: A**

**Explanation:** This is the same fundamental limitation as Question 2. AWS does not support routing traffic from a Direct Connect connection through one Transit Gateway, across a TGW peering connection, to another Transit Gateway. Traffic arriving at the ap-southeast-1 TGW via DX cannot traverse the peering to us-east-1. The Singapore office would need either a DX gateway association directly to the us-east-1 TGW (via the same or different DX connection) or a VPN connection that terminates at the us-east-1 TGW. Option B would cause no route, not internet routing. Options C and D would cause routing failures, not fallback to internet.

---

### Question 18

A company is deploying Storage Gateway (Tape Gateway) for backup modernization. They have 200 TB of on-premises tape backups managed by Veritas NetBackup. The requirements are: the backup software must work with the gateway without modification, archived tapes must be retrievable within 12 hours, and the solution must reduce annual storage costs by at least 60% compared to physical tape infrastructure.

Which configuration meets ALL requirements?

A. Deploy Tape Gateway with virtual tapes stored in S3. Configure archived virtual tapes to use S3 Glacier Deep Archive. Integrate with NetBackup using the Tape Gateway's iSCSI VTL interface.

B. Deploy Tape Gateway with virtual tapes stored in S3. Configure archived virtual tapes to use S3 Glacier Flexible Retrieval. Integrate with NetBackup using the Tape Gateway's iSCSI VTL interface.

C. Deploy File Gateway and migrate backup data from tapes to NFS shares. Reconfigure NetBackup to write backups to the NFS mount point.

D. Deploy Volume Gateway in stored mode and use NetBackup's disk-based backup target configuration. Archive snapshots to S3 Glacier.

**Correct Answer: B**

**Explanation:** Tape Gateway presents an iSCSI-based Virtual Tape Library (VTL) interface that NetBackup supports natively without modification. Archived virtual tapes in S3 Glacier Flexible Retrieval provide retrieval within 3-5 hours (standard) or 5-12 hours (bulk), meeting the 12-hour requirement. This is significantly cheaper than physical tapes. Option A uses Glacier Deep Archive which has a standard retrieval time of 12 hours but can take up to 48 hours, potentially violating the requirement. Option C requires modifying the backup software configuration (NFS instead of tape), violating the "no modification" requirement. Option D requires reconfiguring NetBackup for disk-based backups.

---

### Question 19

A company uses AWS Organizations with 50 accounts. Each account has a VPC with private hosted zones in Route 53. They need a solution where any EC2 instance in any account can resolve the private hosted zones of all other accounts. The company wants centralized management with minimal per-account configuration.

Which approach BEST meets these requirements?

A. Create a central shared-services VPC and associate all private hosted zones from all accounts with this VPC using cross-account authorization. Deploy Route 53 Resolver endpoints in the shared-services VPC and configure all other VPCs to forward DNS queries to these endpoints.

B. In each account, authorize and associate every other account's private hosted zone with the local VPC. This creates a full mesh of hosted zone associations.

C. Deploy Route 53 Resolver rules using AWS RAM to share forwarding rules across all accounts via the organization. Create resolver rules that forward each domain to the appropriate VPC's Resolver inbound endpoint.

D. Deploy a centralized DNS server cluster on EC2 instances that aggregates all zone data and configure all VPCs' DHCP option sets to use these servers.

**Correct Answer: A**

**Explanation:** Centralizing DNS resolution through a shared-services VPC (A) is the most scalable and manageable approach. By associating all private hosted zones with the shared-services VPC, the Route 53 Resolver in that VPC can answer queries for all zones. Other VPCs forward queries to the shared-services Resolver endpoints. This requires one-time cross-account authorization per hosted zone (which can be automated) and minimal per-account configuration. Option B creates an n² mesh of associations (50×50), which is unmanageable. Option C requires individual forwarding rules per domain per account — complex and hard to maintain. Option D adds operational overhead and creates a single point of failure.

---

### Question 20

A company has a hybrid environment with an on-premises data center connected to AWS via Direct Connect. They use Simple AD for basic LDAP authentication of Linux-based applications in AWS. The company is now deploying Windows-based applications that require Kerberos authentication and Group Policy support. They also need to implement MFA for AWS Management Console access.

What should the solutions architect recommend?

A. Keep Simple AD and deploy a third-party MFA solution integrated with Simple AD for console access. Use Simple AD's Kerberos support for Windows applications.

B. Migrate from Simple AD to AWS Managed Microsoft AD. Configure MFA using RADIUS integration with an on-premises or AWS-hosted MFA server. Join Windows instances to the domain for Kerberos and Group Policy.

C. Keep Simple AD and deploy a separate AWS Managed Microsoft AD for the Windows workloads. Configure each directory for its respective applications.

D. Replace Simple AD with AD Connector pointing to the on-premises AD. Implement MFA through the on-premises AD's MFA solution.

**Correct Answer: B**

**Explanation:** AWS Managed Microsoft AD (B) provides full Kerberos authentication, Group Policy support, and native MFA support through RADIUS integration. It's a superset of Simple AD capabilities and supports all the new requirements. Migrating from Simple AD consolidates to a single directory service. Option A is incorrect because Simple AD is Samba-based and has limited Kerberos and no Group Policy support. Option C introduces two directories, increasing complexity. Option D works for existing on-premises AD integration but doesn't provide an AWS-hosted directory, and AD Connector doesn't support Group Policy Objects for AWS instances as robustly as Managed Microsoft AD.

---

### Question 21

A company is designing a new multi-region application architecture. The application will be deployed in us-east-1 (primary) and eu-west-1 (DR). Each region has a VPC connected to the on-premises data center via Direct Connect through a Direct Connect gateway. The application requires that failover between regions happen automatically with minimal DNS propagation delay.

Which combination of services provides automated failover with the FASTEST DNS convergence? (Choose TWO.)

A. Use Route 53 health checks with failover routing policy, setting the us-east-1 endpoint as primary and eu-west-1 as secondary. Set the TTL to 60 seconds.

B. Use AWS Global Accelerator with endpoint groups in both regions. Configure health checks to automatically shift traffic to the healthy region.

C. Deploy Route 53 Resolver endpoints in both regions to ensure DNS queries from on-premises are resolved with region-aware responses.

D. Configure CloudFront with origin failover to automatically switch between regional origins.

E. Use Global Accelerator's static anycast IP addresses to provide a fixed entry point that automatically routes to the healthy region, bypassing DNS TTL delays entirely.

**Correct Answer: B, E**

**Explanation:** AWS Global Accelerator (B, E) provides static anycast IP addresses that don't change during failover, eliminating DNS TTL propagation delays. Health checks automatically detect regional failures and reroute traffic to the healthy region within seconds. This is faster than Route 53 failover (A) which depends on DNS TTL (even at 60 seconds, clients and resolvers may cache longer). Option C handles DNS resolution but not application failover. Option D is for CloudFront distributions, not the application endpoints described.

---

### Question 22

A company has an on-premises NAS (Network Attached Storage) with 100 TB of data that they want to make available in AWS for analytics. The data is actively updated on-premises and analytics workloads in AWS need near-real-time access. The on-premises NAS exports NFS shares. The company has a 1 Gbps Direct Connect connection.

Which architecture provides near-real-time data availability in AWS with MINIMAL disruption to on-premises operations?

A. Use AWS DataSync to perform an initial full transfer followed by incremental transfers on a 15-minute schedule. Store data in S3 and use Athena for analytics.

B. Deploy an S3 File Gateway on-premises. Reconfigure applications to write to the File Gateway NFS share instead of the NAS. AWS analytics tools access the S3 bucket.

C. Deploy AWS DataSync with a DataSync agent on-premises. Schedule continuous incremental transfers to an Amazon EFS file system in AWS. Analytics workloads mount the EFS file system.

D. Set up AWS Storage Gateway Volume Gateway in cached mode. Present volumes as iSCSI targets and mount them on the NAS server for data migration.

**Correct Answer: A**

**Explanation:** DataSync (A) can perform incremental transfers from the on-premises NFS NAS to S3 without disrupting existing on-premises operations — it reads from the NAS without requiring application changes. Scheduling transfers every 15 minutes provides near-real-time availability. Athena can query data directly in S3. Option B requires modifying on-premises applications to write to a different endpoint, causing disruption. Option C could work but EFS is more expensive than S3 for 100 TB of analytics data, and DataSync to EFS transfers are slower than to S3. Option D is designed for block storage, not NAS file-based workloads.

---

### Question 23

A company has a Direct Connect connection and is using a public VIF to access S3. Their security team mandates that all S3 access must go through the Direct Connect connection and never traverse the internet. They need to ensure that even if the Direct Connect connection fails, S3 access is denied rather than falling back to internet access.

Which combination of controls enforces this requirement? (Choose TWO.)

A. Configure the S3 bucket policy with a condition that denies all access unless the request comes through a specific VPC endpoint (aws:sourceVpce).

B. Configure the S3 bucket policy with a condition that restricts access to the company's public IP range used on the Direct Connect public VIF.

C. Remove the default internet gateway route in all VPC route tables and ensure no NAT gateway exists, forcing all traffic through Direct Connect.

D. Use an S3 gateway endpoint in the VPC and configure the endpoint policy to allow access only to the required buckets. Add a bucket policy condition that requires the VPC endpoint as the source.

E. Configure the on-premises firewall to block S3 endpoint IP ranges on the internet-facing interface.

**Correct Answer: C, D**

**Explanation:** Combining an S3 gateway endpoint (D) with removal of internet routes (C) ensures that S3 traffic stays within the AWS network. The gateway endpoint routes S3 traffic through the VPC's private network. Removing internet gateway routes and NAT gateways ensures no fallback path to the internet exists. The bucket policy condition on the VPC endpoint (in D) ensures only authorized access. Option A would work if the VPC endpoint exists but doesn't prevent internet access on its own. Option B is fragile and can be spoofed or bypassed. Option E doesn't protect against traffic originating from within AWS.

---

### Question 24

A company is extending their on-premises Microsoft Active Directory to AWS using domain controllers on EC2 instances. They have a Direct Connect connection and need to ensure AD replication traffic between on-premises domain controllers and AWS domain controllers is resilient to connectivity interruptions.

Which architecture consideration is MOST critical for AD replication reliability?

A. Place the EC2 domain controllers in different Availability Zones and configure AD Sites and Services to define the AWS VPC as a separate AD site with appropriate site links and replication schedules.

B. Ensure the security group for the EC2 domain controllers allows all traffic from the on-premises domain controller IPs.

C. Use Amazon FSx for Windows File Server for SYSVOL and NETLOGON share replication instead of the native AD replication mechanism.

D. Configure Global Catalog servers only on-premises to reduce cross-connection replication traffic.

**Correct Answer: A**

**Explanation:** Configuring AD Sites and Services (A) is critical for hybrid AD architectures. By defining the AWS VPC as a separate AD site, you control replication topology and scheduling. AD uses site links to determine replication frequency and cost, and the Knowledge Consistency Checker (KCC) builds an efficient replication topology. This ensures replication is optimized for the WAN link (Direct Connect) and can tolerate brief interruptions through automatic retry. Multi-AZ placement protects against AZ failure. Option B is a basic requirement but not the most critical architectural decision. Option C is incorrect — SYSVOL replication should use DFSR (native AD mechanism), not FSx. Option D would actually harm availability in AWS by forcing all GC queries over the WAN link.

---

### Question 25

A company is deploying a hybrid DNS solution. They have a Route 53 private hosted zone (internal.company.com) associated with their VPC and an on-premises DNS zone (corp.company.com). They have configured Route 53 Resolver inbound and outbound endpoints. After setup, on-premises clients can resolve internal.company.com, but AWS EC2 instances get NXDOMAIN when querying corp.company.com.

Which is the MOST likely cause?

A. The outbound endpoint security group does not allow outbound DNS traffic (UDP/TCP port 53) to the on-premises DNS server IP addresses.

B. The Route 53 Resolver forwarding rule for corp.company.com is associated with the wrong VPC.

C. The on-premises DNS servers are configured to reject queries from the Route 53 Resolver outbound endpoint IP addresses.

D. The forwarding rule for corp.company.com has the target IP addresses set to the inbound endpoint IPs instead of the on-premises DNS server IPs.

**Correct Answer: A**

**Explanation:** The most common cause of outbound DNS resolution failure is security group misconfiguration (A). The outbound endpoint's ENIs need security groups that allow outbound traffic on port 53 (TCP and UDP) to the on-premises DNS servers. Since inbound resolution works (on-premises can resolve internal.company.com), the network connectivity (Direct Connect/VPN) and inbound endpoints are correctly configured. The outbound direction has its own security group that must be checked. Option B would cause all EC2 instances in the wrong VPC to fail, but the question says EC2 instances get NXDOMAIN, suggesting the forwarding rules are in the right VPC but the queries can't reach the target. Option C is possible but less likely than A since security groups are the first common misconfiguration. Option D is a configuration error that would be caught during setup.

---

### Question 26

A large enterprise has 200+ VPCs across 20 AWS accounts connected through a Transit Gateway. They need to implement network segmentation so that production VPCs can only communicate with other production VPCs, development VPCs can only communicate with other development VPCs, and a shared-services VPC (containing DNS, monitoring, and patching resources) is accessible from both production and development VPCs.

Which Transit Gateway configuration achieves this with the LEAST ongoing maintenance?

A. Create three Transit Gateway route tables: production, development, and shared-services. Associate production VPCs with the production route table, development with the development route table, and shared-services with its own. Propagate routes from shared-services to both production and development route tables, and propagate production routes only to the production and shared-services route tables. Apply the same logic for development.

B. Use Transit Gateway with a single route table and implement security groups and NACLs in each VPC to control inter-VPC traffic.

C. Create separate Transit Gateways for production and development, and peer them with a third Transit Gateway hosting the shared-services VPC.

D. Use VPC peering between VPCs within the same environment and Transit Gateway only for shared-services access.

**Correct Answer: A**

**Explanation:** Transit Gateway route table segmentation (A) is the standard approach for network domain isolation. By creating separate route tables and controlling route propagation and associations, you achieve clean segmentation. Production VPCs see routes to other production VPCs and shared-services only. Development VPCs see routes to other development VPCs and shared-services only. New VPCs simply need to be associated with the correct route table. Option B doesn't provide network-level isolation and requires managing rules across 200+ VPCs. Option C is overly complex and expensive with multiple Transit Gateways. Option D doesn't scale — VPC peering for 200+ VPCs creates an unmanageable mesh.

---

### Question 27

A company is migrating a file server to AWS using Storage Gateway. The file server hosts 30 TB of data, and users access files via SMB shares. The company needs to maintain on-premises access during migration while simultaneously enabling EC2 instances to access the same data. After migration, on-premises access will be phased out over 3 months.

Which migration strategy MINIMIZES disruption?

A. Deploy a File Gateway on-premises and create SMB shares pointing to S3 buckets. Use robocopy to migrate data from the file server to the File Gateway shares. EC2 instances access the same S3 bucket via another File Gateway or S3 directly.

B. Use AWS DataSync to copy data from the file server to Amazon FSx for Windows File Server. Configure FSx with a DNS alias matching the old file server name. Point on-premises clients to FSx via Direct Connect.

C. Deploy a Volume Gateway in cached mode and present iSCSI volumes. Copy file server data to these volumes. On-premises clients access data via the Volume Gateway, and EC2 instances access the underlying EBS volumes.

D. Use AWS Snow Family to ship the data to S3. Deploy File Gateways both on-premises and in AWS for access during the transition period.

**Correct Answer: A**

**Explanation:** The File Gateway approach (A) provides the smoothest transition. Deploying on-premises, it presents familiar SMB shares to users. Data copied to the gateway is uploaded to S3, which EC2 instances can access via another File Gateway or the S3 API. During the 3-month transition, both on-premises users (via File Gateway) and EC2 instances (via S3/another gateway) have access. After phasing out on-premises access, the on-premises gateway is decommissioned. Option B works but requires Direct Connect bandwidth for all on-premises file access, introducing latency. Option C uses iSCSI (block storage), not SMB (file shares), changing the access pattern. Option D involves physical shipping delay, and Snow devices can't provide ongoing on-premises access.

---

### Question 28

A company has a hybrid architecture where on-premises applications write logs to an NFS share. They want to centralize log analysis in AWS using Amazon OpenSearch Service. The logs must be available in OpenSearch within 5 minutes of being written. The total daily log volume is 500 GB. A 10 Gbps Direct Connect connection is available.

Which architecture provides the MOST reliable near-real-time log ingestion?

A. Deploy a File Gateway on-premises. Applications write logs to the File Gateway NFS share. Use S3 event notifications to trigger a Lambda function that ingests logs into OpenSearch.

B. Deploy a DataSync agent on-premises. Schedule DataSync tasks to transfer new logs every 5 minutes from the NFS share to S3. Use an S3-to-OpenSearch ingestion pipeline.

C. Deploy Kinesis Data Firehose with a Kinesis agent on the on-premises servers. The agent monitors the log directory and streams data to Firehose, which delivers to OpenSearch.

D. Deploy a Fluentd/Fluent Bit agent on on-premises servers to read logs from the NFS share and send them directly to OpenSearch via the REST API over Direct Connect.

**Correct Answer: C**

**Explanation:** Kinesis Data Firehose with the Kinesis agent (C) provides true near-real-time streaming. The Kinesis agent monitors log files and sends records continuously to Firehose, which buffers briefly and delivers to OpenSearch. This is the most reliable approach with built-in retry, buffering, and delivery guarantees. Option A introduces latency — File Gateway batches uploads to S3, and the cache-to-S3 upload is not guaranteed within 5 minutes. Option B's minimum practical schedule is 5 minutes, but DataSync task startup overhead and transfer time may exceed the window for 500 GB daily volume. Option D works but lacks the buffering, retry, and delivery guarantees of Firehose, and direct OpenSearch ingestion can overwhelm the cluster during log spikes.

---

### Question 29

A financial services company operates a hybrid infrastructure with multiple Direct Connect connections. They need to implement a network monitoring solution that detects when a Direct Connect connection degrades (increased latency, packet loss) BEFORE it completely fails, allowing proactive failover to a backup VPN connection.

Which monitoring approach provides the EARLIEST warning of Direct Connect degradation?

A. Monitor the AWS Direct Connect CloudWatch metrics ConnectionBpsEgress, ConnectionBpsIngress, ConnectionPpsEgress, and ConnectionPpsIngress. Set alarms for anomaly detection on throughput metrics.

B. Configure BFD (Bidirectional Forwarding Detection) on the Direct Connect BGP sessions for sub-second failure detection. Additionally, deploy EC2 instances that run continuous ping and traceroute tests through the Direct Connect connection to on-premises endpoints, publishing custom CloudWatch metrics.

C. Use AWS Network Manager with Direct Connect integration. Configure Network Manager events to trigger SNS notifications when connection state changes occur.

D. Monitor the ConnectionState CloudWatch metric for the Direct Connect connection and set an alarm when the state changes from "up" to "down."

**Correct Answer: B**

**Explanation:** BFD provides sub-second detection of connectivity failures, while continuous synthetic monitoring (ping/traceroute tests from EC2 instances) detects degradation patterns (increasing latency, intermittent packet loss) before a complete failure occurs. Custom CloudWatch metrics from these probes can trigger alarms based on latency thresholds or packet loss percentages, enabling proactive failover. Option A monitors throughput but not latency or packet loss — throughput can remain normal even as latency increases. Option C detects state changes but not gradual degradation. Option D only detects complete failures, not degradation.

---

### Question 30

A company is implementing AWS Directory Service for their hybrid environment. They have a strict requirement that no directory data (user credentials, group memberships) should ever leave their on-premises data center, but AWS applications need to authenticate users against the on-premises AD. The company also needs to use AWS SSO (IAM Identity Center) for console access.

Which directory solution meets the data residency requirement?

A. AWS Managed Microsoft AD with a one-way outgoing trust to the on-premises AD, so the on-premises AD trusts the AWS directory but not vice versa.

B. AD Connector configured to forward all authentication requests to the on-premises Active Directory. Configure IAM Identity Center to use AD Connector as its identity source.

C. AWS Managed Microsoft AD with multi-Region replication disabled and encryption at rest enabled.

D. Simple AD with LDAP synchronization from the on-premises AD, filtering to sync only non-sensitive attributes.

**Correct Answer: B**

**Explanation:** AD Connector (B) is a proxy that forwards authentication requests to the on-premises AD without storing any directory data in AWS. It acts as a transparent relay — no user credentials, group memberships, or other directory data is replicated to AWS. IAM Identity Center supports AD Connector as an identity source. This meets the strict data residency requirement. Option A creates a full AD in AWS that would contain its own directory data, even with a trust. Option C still stores directory data in AWS (the Managed Microsoft AD itself contains user/group data). Option D would synchronize data to AWS, violating the requirement.

---

### Question 31

A company has a primary Direct Connect connection (10 Gbps) and a backup VPN connection. They want traffic to use the DX connection when available and automatically fail over to VPN when DX is unavailable. However, they notice that after a DX failover event, when DX recovers, traffic doesn't fail back to DX and continues using the VPN.

What is the MOST likely cause and fix?

A. The BGP MED (Multi-Exit Discriminator) values are the same for both connections. Configure a lower MED value on the DX BGP session to make it preferred.

B. The on-premises router has BGP route dampening configured, which suppresses the DX route after it flaps. Reduce the dampening penalty or disable dampening for the DX route.

C. The VGW prefers VPN over Direct Connect. Reconfigure the VGW to prefer DX by adjusting the route priority.

D. The DX connection's BGP session requires a manual reset after recovery. Configure automated BGP session monitoring to perform the reset.

**Correct Answer: B**

**Explanation:** BGP route dampening (B) is a common cause of failback failure. When a route flaps (DX goes down then comes back up), the dampening algorithm applies a penalty that suppresses the route for a configurable period. This prevents route flapping from destabilizing the network but can delay failback. The fix is to reduce the dampening parameters or exempt the DX route from dampening. Option A is incorrect because AWS VGW and TGW already prefer DX over VPN by default based on the routing preference order (longest prefix > static > BGP, and DX BGP is preferred over VPN BGP). Option C is wrong — VGW inherently prefers DX over VPN. Option D is unlikely as BGP sessions auto-recover.

---

### Question 32

A company is designing a Storage Gateway architecture for a distributed organization with 20 branch offices. Each office needs local access to shared files stored in S3, and changes made at one office must be visible to all other offices within 1 hour. The total shared dataset is 10 TB per office.

What is the MOST effective architecture?

A. Deploy a File Gateway at each branch office connected to the same S3 bucket. Use S3 event notifications to trigger RefreshCache API calls on all other File Gateways when any gateway writes new data.

B. Deploy a File Gateway at each branch office, each connected to its own S3 bucket. Use S3 Cross-Region Replication to sync data between all buckets.

C. Deploy a single File Gateway at headquarters and have branch offices access it over the WAN. Configure a large local cache to minimize latency.

D. Deploy a Volume Gateway at each branch office with EBS snapshots shared across offices. Each office restores snapshots periodically to see changes.

**Correct Answer: A**

**Explanation:** Multiple File Gateways can connect to the same S3 bucket (A). When one gateway writes data, an S3 event notification triggers the RefreshCache API on the other gateways, making changes visible. This architecture provides local low-latency access at each office while maintaining a single source of truth in S3. The RefreshCache API can complete well within the 1-hour window. Option B creates 20 separate buckets, and Cross-Region Replication doesn't support many-to-many sync — it's one-directional. Option C introduces WAN latency for all file operations at branch offices. Option D is designed for block storage, not file sharing, and periodic snapshot restoration is disruptive.

---

### Question 33

A company uses Route 53 private hosted zones for their internal DNS. They are implementing a microservices architecture where services in different VPCs need to discover each other using DNS names. They have 50 microservices across 10 VPCs. Services are frequently added and removed as part of CI/CD deployments.

Which DNS service discovery approach provides the MOST automated solution?

A. Use Route 53 private hosted zones with CloudWatch Events rules that trigger Lambda functions to update DNS records when ECS tasks or EC2 instances are launched or terminated.

B. Use AWS Cloud Map with DNS-based service discovery. Register services in Cloud Map namespaces. Configure ECS services or EC2 instances to automatically register and deregister with Cloud Map.

C. Deploy HashiCorp Consul on EC2 instances as a service mesh for service discovery. Configure all microservices to register with Consul.

D. Create a central Route 53 private hosted zone and use Route 53 Auto Naming API to manage service records. Manually update records during deployments.

**Correct Answer: B**

**Explanation:** AWS Cloud Map (B) is purpose-built for service discovery and integrates natively with ECS, EKS, and EC2. It automatically manages DNS records in Route 53 when services are registered or deregistered. ECS services can be configured to auto-register instances with Cloud Map, providing fully automated service discovery. Health checks can auto-deregister unhealthy instances. Option A requires custom Lambda functions and is more complex to maintain. Option C adds operational overhead of managing Consul infrastructure. Option D's "Auto Naming API" is actually Cloud Map's API — and the question says "manually update," which contradicts the automation goal.

---

### Question 34

A company's AWS environment spans three Availability Zones. They are deploying an Active Directory architecture on EC2 instances that needs to meet the following requirements: survive the loss of any single AZ, provide sub-3-second authentication failover, and support 10,000 concurrent LDAP queries per second.

Which AD architecture BEST meets these requirements?

A. Deploy two domain controllers, one in AZ-A and one in AZ-B. Use Route 53 health checks with failover routing to redirect clients to the surviving DC.

B. Deploy three domain controllers, one in each AZ, configured as Global Catalog servers. Use AD Sites and Services to configure the VPC as a single AD site. Let Windows clients' native DC locator find the nearest available DC.

C. Deploy one domain controller in each AZ with a Network Load Balancer distributing LDAP traffic across all three DCs.

D. Deploy two domain controllers in AZ-A and one in AZ-B for majority quorum. Use EC2 Auto Scaling to replace failed instances automatically.

**Correct Answer: B**

**Explanation:** Three domain controllers across three AZs (B) ensures survival of any single AZ failure with two remaining DCs. Configuring all as Global Catalog servers ensures any DC can handle authentication and LDAP queries without referrals. Windows native DC locator process (via DNS SRV records) automatically discovers available DCs and fails over within seconds when a DC becomes unavailable. Defining the VPC as a single AD site ensures all DCs replicate promptly. Option A only survives one specific AZ failure and Route 53 failover is slower than native DC locator. Option C is problematic — NLB with LDAP doesn't handle AD's multi-master replication semantics and can cause issues with Kerberos. Option D has uneven distribution and Auto Scaling doesn't work well for domain controllers (which need proper demotion/promotion).

---

### Question 35

A company has a Direct Connect gateway associated with three Transit Gateways across three regions. Their on-premises data center advertises 150 prefixes via BGP. They notice that only 100 prefixes are being learned by the Transit Gateways.

What is causing this limitation?

A. Direct Connect gateway associations with Transit Gateways have a limit of 100 prefixes that can be advertised from on-premises. The company needs to summarize routes to reduce the prefix count.

B. The BGP session on the transit VIF has a maximum receive limit of 100 prefixes. The company needs to request a limit increase.

C. Transit Gateway route tables have a maximum of 100 routes per route table. The company needs to use multiple route tables.

D. The on-premises router's BGP configuration has a maximum prefix advertisement limit set to 100. The company needs to adjust the router configuration.

**Correct Answer: A**

**Explanation:** When a Direct Connect gateway is associated with a Transit Gateway, there is a limit of 100 prefixes that can be advertised from on-premises over the transit VIF BGP session. This is an AWS-documented limit. The solution is to summarize (aggregate) the 150 specific routes into fewer, broader CIDR blocks that stay within the 100-prefix limit. Option B is incorrect — this is a hard DX gateway-to-TGW limit, not a configurable BGP session limit. Option C is about TGW route tables which have a 10,000 route limit. Option D could be an issue but the limit described is an AWS-side limitation.

---

### Question 36

A company is setting up DNS resolution for a multi-account environment. They have a centralized networking account with a Transit Gateway, and 50 application accounts each with VPCs. They want all VPCs to be able to resolve a common private hosted zone (shared.internal.company.com) without requiring individual hosted zone associations per VPC.

Which approach BEST achieves this?

A. Create the private hosted zone in the networking account and associate it with every VPC in all 50 accounts using cross-account hosted zone association.

B. Create the private hosted zone in the networking account, associate it with the networking VPC, create Route 53 Resolver rules that forward shared.internal.company.com to the networking VPC's Resolver inbound endpoints, and share these rules with all accounts via AWS RAM.

C. Create a public hosted zone for shared.internal.company.com and use Route 53 health checks to ensure internal-only resolution.

D. Deploy EC2-based DNS servers in the networking account that host the shared.internal.company.com zone and configure all VPCs' DHCP option sets to use these servers.

**Correct Answer: B**

**Explanation:** Using Route 53 Resolver forwarding rules shared via RAM (B) is the most scalable approach. The hosted zone is associated with the networking VPC only. Forwarding rules direct queries from all other VPCs to the Resolver inbound endpoints in the networking VPC, which can then resolve the private hosted zone. RAM sharing means new accounts in the organization automatically get the forwarding rules. Option A requires individual cross-account authorizations and VPC associations for every VPC, which is operationally heavy and must be repeated for each new VPC. Option C exposes internal DNS records publicly. Option D introduces operational overhead and single points of failure.

---

### Question 37

A company runs a hybrid application where the web tier is in AWS and the database is on-premises. The on-premises database server's IP address occasionally changes due to DHCP. Application servers in AWS currently have the database IP hardcoded in configuration files. The company wants a dynamic solution so that when the database IP changes, AWS application servers can connect without manual intervention.

Which solution is MOST reliable and requires the LEAST modification to the application?

A. Create a Route 53 private hosted zone with an A record for the database (db.corp.internal). Use a Lambda function triggered by a CloudWatch scheduled event that queries the on-premises DHCP server and updates the Route 53 record. Configure the application to use the DNS name instead of the IP.

B. Use Route 53 Resolver with a forwarding rule that sends queries for corp.internal to the on-premises DNS server, which has a dynamic DNS entry for the database.

C. Assign a static IP to the on-premises database server to eliminate the need for dynamic resolution.

D. Deploy an on-premises Network Load Balancer (or HAProxy) with a static IP that proxies connections to the database, regardless of its IP changes.

**Correct Answer: B**

**Explanation:** If the on-premises DNS server already maintains dynamic DNS entries (or can be configured to do so through DHCP-DNS integration), Route 53 Resolver forwarding (B) provides the cleanest solution. The on-premises DNS server always has the current IP via dynamic DNS updates from the DHCP server. AWS applications query the Resolver, which forwards to on-premises DNS and gets the current IP. The only application change is using the DNS name. Option A requires building and maintaining a custom Lambda function to query DHCP servers, which is more complex. Option C solves the problem but may not be feasible for the database server due to network policies. Option D adds infrastructure but works as a fallback approach.

---

### Question 38

A company has two Direct Connect connections from different providers for redundancy. They recently tested failover by disconnecting the primary connection. While failover to the secondary connection worked, they observed a 90-second traffic disruption during the failover.

Which combination of changes will MINIMIZE the failover disruption time? (Choose TWO.)

A. Enable Bidirectional Forwarding Detection (BFD) on both Direct Connect BGP sessions to reduce failure detection time to sub-second.

B. Increase the BGP keepalive timer to 120 seconds to prevent false positive failure detections.

C. Pre-configure the secondary connection with equal BGP route preferences so that traffic uses both connections in active/active mode, eliminating the concept of failover entirely.

D. Reduce the BGP hold timer to 10 seconds on both the AWS and on-premises routers.

E. Configure route dampening with aggressive parameters to ensure faster route convergence.

**Correct Answer: A, C**

**Explanation:** BFD (A) reduces failure detection from the default BGP hold timer (typically 90 seconds — matching the observed disruption) to sub-second. This is the primary improvement for failover speed. Running active/active (C) means traffic is already flowing on both connections; when one fails, only the traffic on that connection needs to reconverge, reducing the blast radius. Option B would increase the failover time, not decrease it. Option D helps but BFD is far superior for failure detection speed. Option E would actually delay route recovery by damping routes that flap.

---

### Question 39

A company is deploying AWS Storage Gateway (File Gateway) in a VPC instead of on-premises. The gateway needs to access S3, communicate with the Storage Gateway service endpoints, and allow NFS/SMB access from EC2 instances in the same and peered VPCs. The company's security policy requires that no traffic traverse the public internet.

Which combination of network configurations is required? (Choose THREE.)

A. Create an S3 gateway VPC endpoint in the VPC where the File Gateway is deployed.

B. Create VPC interface endpoints (PrivateLink) for the Storage Gateway service.

C. Configure the File Gateway's security group to allow inbound NFS (TCP 2049) and SMB (TCP 445) from the CIDR ranges of the same and peered VPCs.

D. Attach an internet gateway to the VPC and configure a NAT gateway for the File Gateway to reach AWS service endpoints.

E. Configure VPC peering route tables to include routes to the File Gateway's subnet CIDR.

F. Create a public VIF on a Direct Connect connection for Storage Gateway service access.

**Correct Answer: A, B, C**

**Explanation:** Without internet access, the File Gateway needs VPC endpoints to communicate privately with AWS services. An S3 gateway endpoint (A) enables private access to S3. Storage Gateway interface endpoints via PrivateLink (B) enable the gateway to communicate with the Storage Gateway service without internet access. Security group configuration (C) allows NFS/SMB clients in the same and peered VPCs to connect to the gateway. Option D introduces internet access, violating the security policy. Option E is important but is a standard VPC peering configuration, not specific to the gateway setup. Option F is not needed when using VPC endpoints.

---

### Question 40

A company operates an AWS Managed Microsoft AD in the Enterprise Edition for 50,000 users. They need to enforce password policies that differ by department — the finance department requires 16-character passwords with 90-day rotation, while the engineering department requires 12-character passwords with no rotation policy. The company uses OUs (Organizational Units) to separate departments.

How should the solutions architect implement this?

A. Create fine-grained password policies (Password Settings Objects / PSOs) within AWS Managed Microsoft AD, and apply them to the finance and engineering security groups with different password complexity and rotation settings.

B. Create separate OUs for each department within AWS Managed Microsoft AD and apply different Group Policy Objects (GPOs) with the desired password policies to each OU.

C. Create two separate AWS Managed Microsoft AD directories — one for finance and one for engineering — each with different default password policies.

D. Use IAM Identity Center password policies to enforce different requirements based on group membership.

**Correct Answer: A**

**Explanation:** Fine-grained password policies (PSOs) in Active Directory allow different password policies to be applied to different security groups or users within the same domain. AWS Managed Microsoft AD supports fine-grained password policies. You create PSOs with different settings (minimum length, maximum age, complexity) and link them to the appropriate security groups. Option B is incorrect because GPO-based domain password policies apply domain-wide — you cannot have different domain password policies per OU in AD. Option C is unnecessarily complex and expensive, creating two separate directories. Option D applies to IAM Identity Center, not AD-joined resources and applications.

---

### Question 41

A global company has on-premises data centers in the US, Europe, and Asia, each connected to the nearest AWS region via Direct Connect. They are deploying a centralized data lake in us-east-1 S3. All data centers need to upload data to this S3 bucket. The total daily upload volume is 2 TB per data center. They want to maximize upload throughput while using their Direct Connect connections.

Which approach provides the HIGHEST throughput for S3 uploads from all data centers?

A. Upload from each data center through their regional Direct Connect connections using S3 public VIFs, targeting the us-east-1 S3 endpoint directly.

B. Deploy VPC interface endpoints for S3 in each regional VPC. Upload from each data center through their regional Direct Connect private VIF to the regional VPC, and use S3 cross-region access through the interface endpoint targeting the us-east-1 bucket.

C. Use S3 Transfer Acceleration from each data center by uploading to the nearest CloudFront edge location over the internet.

D. Upload from each data center through their regional Direct Connect to regional VPCs. Use S3 Multi-Region Access Points to route uploads to the us-east-1 bucket via the AWS global network.

**Correct Answer: D**

**Explanation:** S3 Multi-Region Access Points (D) use the AWS global network to intelligently route requests to S3 buckets. Uploading from each data center through their nearest DX connection to a regional VPC, then through a Multi-Region Access Point, leverages both the DX bandwidth and the AWS backbone network for optimal throughput to the us-east-1 bucket. Option A works but cross-region traffic through a public VIF targeting us-east-1 endpoint may not be as efficient as using the AWS backbone. Option B is similar but interface endpoints don't natively handle cross-region S3 access. Option C doesn't use Direct Connect — it goes over the public internet, wasting the DX investment.

---

### Question 42

A company wants to use AWS Client VPN to allow remote employees to access resources in multiple VPCs connected through a Transit Gateway. The Client VPN endpoint is deployed in a shared-services VPC attached to the Transit Gateway. Employees should be able to access resources in VPC-A (10.1.0.0/16), VPC-B (10.2.0.0/16), and the shared-services VPC (10.0.0.0/16).

After setup, employees can access the shared-services VPC but cannot reach VPC-A or VPC-B.

What is the MOST likely cause?

A. The Client VPN authorization rules only allow access to the shared-services VPC CIDR. Authorization rules for VPC-A and VPC-B CIDRs must be added.

B. The Client VPN route table doesn't have routes to VPC-A and VPC-B. Routes pointing to the Transit Gateway-attached subnet must be added for 10.1.0.0/16 and 10.2.0.0/16.

C. The Transit Gateway route tables for VPC-A and VPC-B don't have return routes to the Client VPN CIDR via the shared-services VPC attachment.

D. Split-tunnel is enabled on the Client VPN endpoint, and the 10.1.0.0/16 and 10.2.0.0/16 routes are not included in the split-tunnel configuration.

**Correct Answer: B**

**Explanation:** The Client VPN endpoint has its own route table that determines where traffic is sent. By default, it only has a route for the associated subnet. To reach VPC-A and VPC-B through the Transit Gateway, you must add routes in the Client VPN route table for 10.1.0.0/16 and 10.2.0.0/16 pointing to the subnet association in the shared-services VPC (which then routes through the TGW). Option A would result in access denied errors, not connectivity failures. Option C could be an issue but the shared-services VPC connectivity works, suggesting TGW routing is functional. Option D would cause the client to route traffic over the internet instead, not failing to connect.

---

### Question 43

A company has been running a File Gateway for 18 months. Users report that file access has become increasingly slow for files not in the local cache. Investigation reveals the S3 bucket backing the File Gateway has grown to 200 TB with 500 million objects. The gateway's cache disk is 5 TB.

What should the solutions architect recommend to improve performance?

A. Increase the File Gateway cache disk from 5 TB to 20 TB to accommodate a larger portion of the working set.

B. Add S3 Intelligent-Tiering to the bucket to optimize storage costs and access patterns for the 200 TB dataset.

C. Deploy multiple File Gateways, each mapping to a different S3 prefix, to distribute the object listing and retrieval load.

D. Enable S3 Transfer Acceleration on the bucket to speed up cache-miss retrievals.

**Correct Answer: C**

**Explanation:** With 500 million objects, S3 listing operations (which File Gateway uses for cache management and file browsing) become slow regardless of cache size. Splitting the data across multiple gateways with different S3 prefixes (C) reduces the per-gateway object count, improving listing performance and metadata operations. Each gateway manages a smaller namespace, leading to faster file browsing and cache-miss retrievals. Option A helps if the working set exceeds cache but doesn't address the listing/metadata overhead of 500 million objects. Option B optimizes storage costs, not access latency. Option D doesn't help since the gateway is already in the same AWS region as the bucket.

---

### Question 44

A company established a Direct Connect connection 2 years ago. They now need to enable MACsec encryption on the connection for compliance. Their current connection is a 10 Gbps dedicated connection using a private VIF.

What steps are required to enable MACsec?

A. MACsec can be enabled on the existing connection by configuring MACsec keys in the Direct Connect console and coordinating with the on-premises router to enable MACsec on the same port.

B. MACsec requires a new Direct Connect connection provisioned from a MACsec-capable port. The company must order a new connection, migrate traffic, and then decommission the old connection.

C. MACsec is only available on hosted connections, not dedicated connections. The company must switch to a hosted connection model.

D. MACsec is automatically enabled on all Direct Connect connections provisioned after 2020. Since the connection is from 2 years ago, it already has MACsec.

**Correct Answer: B**

**Explanation:** MACsec requires the physical port to support it. Existing DX connections provisioned before MACsec support was available on that port/location cannot have MACsec retroactively enabled — you need a new connection from a MACsec-capable port (B). The migration involves creating a new DX connection, setting up VIFs, configuring MACsec keys, testing, migrating traffic, and decommissioning the old connection. Option A is incorrect because MACsec must be configured at the time of connection creation on a compatible port. Option C is wrong — MACsec is supported on 10 Gbps and 100 Gbps dedicated connections. Option D is incorrect — MACsec is not automatically enabled.

---

### Question 45

A company uses AWS Managed Microsoft AD and needs to implement a secure LDAPS (LDAP over SSL/TLS) connection between their applications in AWS and the directory. The applications use port 636 for LDAPS communication.

Which approach enables LDAPS with the LEAST operational effort?

A. Deploy an AWS Certificate Manager (ACM) Private CA and issue certificates to the AWS Managed Microsoft AD domain controllers. Enable server-side LDAPS on the directory.

B. Generate self-signed certificates on each domain controller and configure the applications to trust these certificates.

C. Deploy a third-party certificate authority on EC2, issue certificates for the domain controllers, and manually install them.

D. Use AWS Managed Microsoft AD's client-side LDAPS feature by configuring certificates on the client applications.

**Correct Answer: A**

**Explanation:** AWS Managed Microsoft AD supports server-side LDAPS by registering certificates from a trusted CA. Using ACM Private CA (A) is the least operational effort approach — you create a private CA, issue certificates for the domain controllers, and register them with the directory through the AWS console or API. AWS handles certificate installation on the managed domain controllers. Option B requires managing self-signed certificates and distributing trust to all applications — high effort. Option C involves running a separate CA infrastructure. Option D (client-side LDAPS) encrypts LDAP traffic between AWS Managed Microsoft AD and applications, but the question asks about server-side LDAPS which is more commonly needed and simpler to configure.

---

### Question 46

A company has a Transit Gateway connected to 15 VPCs and an on-premises network via Direct Connect. They want to implement centralized traffic inspection for all traffic flowing between VPCs and between VPCs and on-premises. They choose AWS Network Firewall.

Which architecture deploys centralized inspection MOST effectively?

A. Deploy Network Firewall in every VPC and configure each VPC's route table to send inter-VPC traffic through the local firewall.

B. Deploy Network Firewall in a dedicated inspection VPC. Configure Transit Gateway route tables so that all inter-VPC and VPC-to-on-premises traffic routes through the inspection VPC's Transit Gateway attachment. Use appliance mode on the inspection VPC attachment.

C. Deploy Network Firewall endpoints in the Transit Gateway VPC attachment subnets of each VPC to inspect traffic at the TGW entry/exit point.

D. Use Transit Gateway's built-in packet inspection capability with Network Firewall rule groups applied directly to the TGW.

**Correct Answer: B**

**Explanation:** A centralized inspection VPC (B) with Network Firewall is the recommended architecture. All traffic routes through the inspection VPC via Transit Gateway route table manipulation. Enabling appliance mode on the inspection VPC attachment ensures symmetric routing (traffic in both directions passes through the same firewall endpoint). This provides a single point of inspection for all inter-VPC and VPC-to-on-premises traffic. Option A is decentralized and requires managing firewalls in every VPC — expensive and complex. Option C is not how Network Firewall works; it doesn't deploy into TGW attachment subnets. Option D is incorrect — Transit Gateway doesn't have built-in packet inspection.

---

### Question 47

A company runs a File Gateway with SMB shares for 500 Windows users. The gateway authenticates users against AWS Managed Microsoft AD. Users in the "Finance" AD group should have read/write access to the "finance-data" share, while all other users should have read-only access. The security team wants to manage these permissions centrally without modifying individual file-level ACLs.

How should this be configured?

A. Configure the SMB file share access control list (ACL) on the File Gateway to grant read/write to the Finance AD group and read-only to the Domain Users group.

B. Configure an S3 bucket policy that uses IAM conditions to check AD group membership and grant appropriate S3 permissions.

C. Configure Windows NTFS permissions on the File Gateway's cache by mounting the share from a domain-joined EC2 instance and setting permissions.

D. Create two separate SMB shares on the File Gateway for the same S3 prefix — one with read/write for Finance and one with read-only for all users.

**Correct Answer: A**

**Explanation:** File Gateway SMB shares support Active Directory-based access control lists (A). You can configure share-level permissions through the Storage Gateway console or API, specifying AD groups that get read/write or read-only access. The Finance group gets read/write, and Domain Users (or Authenticated Users) get read-only. This is centrally managed without touching individual file ACLs. Option B doesn't work because S3 bucket policies are not aware of AD group membership from File Gateway access. Option C manages file-level NTFS ACLs which is more granular than needed and operationally heavy. Option D creates an unnecessary dual-share setup and could cause confusion.

---

### Question 48

A company is troubleshooting DNS resolution in their hybrid environment. EC2 instances in a VPC can resolve Route 53 private hosted zone records and public DNS names but CANNOT resolve on-premises domain names. Route 53 Resolver outbound endpoints are configured with forwarding rules for the on-premises domain. The outbound endpoints are in subnets with route table entries pointing to a Transit Gateway for on-premises connectivity.

Which troubleshooting steps should be performed FIRST? (Choose TWO.)

A. Verify that the outbound endpoint security group allows outbound DNS traffic (UDP and TCP port 53) to the on-premises DNS server IPs.

B. Verify that the forwarding rule is associated with the correct VPC where the EC2 instances reside.

C. Check if the on-premises DNS servers are responding by testing from an EC2 instance using nslookup/dig directly to the on-premises DNS server IPs.

D. Verify that the inbound endpoints are configured correctly to receive responses from on-premises.

E. Check the Route 53 Resolver query logs for the outbound endpoint to see if queries are being forwarded.

**Correct Answer: A, B**

**Explanation:** The two most common issues with outbound forwarding are security group rules (A) and VPC association (B). If the outbound endpoint security group blocks port 53 outbound, queries can't reach the on-premises DNS servers. If the forwarding rule isn't associated with the VPC where the EC2 instances are, the Resolver won't apply the rule to those instances' queries. These should be checked first as they're quick to verify and account for most outbound resolution failures. Option C is a valid troubleshooting step but comes after verifying configuration. Option D is incorrect — inbound endpoints receive queries from on-premises, not responses; the outbound endpoint handles the full query/response cycle. Option E is useful but more of a secondary diagnostic.

---

### Question 49

A company needs to migrate 50 TB of data from their on-premises NFS server to Amazon S3 with the following requirements: minimize transfer time, validate data integrity, preserve file metadata (permissions, timestamps), and transfer data over their 1 Gbps Direct Connect connection without impacting production traffic during business hours.

Which approach BEST meets ALL requirements?

A. Use AWS DataSync with a scheduled task window. Configure the DataSync agent on-premises, create a task from the NFS source to an S3 destination, enable data verification, and schedule the task to run only during non-business hours. Use bandwidth throttling to limit DataSync consumption to 50% of the DX capacity.

B. Use S3 multipart upload with a custom script that reads files from NFS and uploads during off-peak hours. Implement MD5 checksums for integrity validation.

C. Use AWS Transfer Family with SFTP protocol. Develop scripts to transfer files during non-business hours and verify integrity manually.

D. Order an AWS Snowball Edge device, load data from the NFS server, and ship it to AWS. Verify data in S3 after ingestion.

**Correct Answer: A**

**Explanation:** AWS DataSync (A) is purpose-built for this scenario. It handles NFS source natively, preserves metadata (permissions, timestamps, ownership), performs automatic data integrity verification (checksums during and after transfer), supports bandwidth throttling to avoid impacting production traffic, and supports scheduling to restrict transfers to non-business hours. Over 1 Gbps DX at 50% utilization, 50 TB would transfer in approximately 9-10 days of nightly transfers. Option B loses metadata and requires custom integrity validation. Option C requires significant custom development and doesn't preserve NFS metadata. Option D works but introduces physical shipping delay and doesn't leverage the existing DX connection.

---

### Question 50

A company has a hybrid environment with AWS Managed Microsoft AD trusted with their on-premises AD forest. Users authenticate via the on-premises AD, and the trust allows them to access AWS resources. The company notices that authentication for on-premises users accessing AWS resources is significantly slower than for users in the AWS Managed AD.

What is the MOST effective way to improve authentication performance for on-premises users?

A. Increase the size of the AWS Managed Microsoft AD from Standard to Enterprise edition to handle more authentication requests.

B. Configure shortcut trusts (external trusts) between specific on-premises domains and AWS Managed Microsoft AD to reduce the trust traversal path.

C. Deploy additional domain controllers for the AWS Managed Microsoft AD in additional Availability Zones.

D. Enable Global Catalog on the on-premises domain controllers to speed up cross-forest lookups.

**Correct Answer: B**

**Explanation:** In a forest trust, authentication requests may traverse the full trust path through the forest root domains, adding latency. Shortcut trusts (external trusts) (B) create direct trust relationships between specific domains, bypassing the forest root traversal. This significantly reduces the authentication path length and improves performance. Option A increases capacity but doesn't address the trust traversal latency. Option C adds availability but not trust path optimization. Option D — Global Catalog is typically already enabled on-premises and doesn't address the cross-forest trust path issue.

---

### Question 51

A company has been using a Volume Gateway (cached mode) for 2 years. They want to migrate the workload entirely to AWS and eliminate the on-premises gateway. The volumes contain a 10 TB database and a 5 TB file system that on-premises applications access via iSCSI.

Which migration approach causes the LEAST downtime?

A. Create EBS snapshots from the Volume Gateway volumes. Create EBS volumes from the snapshots. Attach them to EC2 instances. Re-point applications to the EC2 instances.

B. Deploy new Volume Gateways on EC2 instances in AWS. Clone the on-premises gateway volumes to the EC2-based gateways. Switch iSCSI initiators to the EC2-hosted gateways.

C. Use AWS Server Migration Service to migrate the on-premises servers that use the Volume Gateway to EC2 instances with their data intact.

D. Create EBS snapshots from the Volume Gateway. Deploy an Amazon FSx for Windows File Server from the file system snapshot and an RDS instance restored from the database snapshot.

**Correct Answer: A**

**Explanation:** Volume Gateway cached mode already stores the full dataset in S3 as EBS snapshots (A). Creating EBS volumes from these snapshots is fast and doesn't require data transfer. You then attach the EBS volumes to EC2 instances, configure the applications on the EC2 instances, and cut over. The downtime is limited to the application cutover — the data is already in AWS. Option B introduces unnecessary complexity with EC2-based Volume Gateways when you're trying to eliminate gateways. Option C doesn't migrate Volume Gateway data — SMS migrates server workloads. Option D assumes the snapshots can be directly used by FSx and RDS, which isn't the case — they're raw EBS volume snapshots.

---

### Question 52

A company has a multi-region Route 53 DNS architecture with private hosted zones in us-east-1 and eu-west-1. After a recent change, they notice that DNS resolution for a record in the us-east-1 private hosted zone returns NXDOMAIN from EC2 instances in eu-west-1, although the same query works from us-east-1 instances.

What is the MOST likely cause?

A. The us-east-1 private hosted zone is not associated with the eu-west-1 VPC.

B. Route 53 private hosted zones do not support cross-region DNS resolution.

C. The EC2 instances in eu-west-1 are using a custom DHCP option set that doesn't include AmazonProvidedDNS.

D. There is a conflicting private hosted zone in eu-west-1 with the same domain name that has a higher priority.

**Correct Answer: A**

**Explanation:** Route 53 private hosted zones must be explicitly associated with each VPC that needs to resolve records in that zone (A). If the us-east-1 hosted zone is not associated with the eu-west-1 VPC, instances in eu-west-1 cannot resolve records from it — they get NXDOMAIN. Cross-region VPC association is supported and is required for this to work. Option B is incorrect — cross-region resolution is supported with VPC association. Option C would break all DNS resolution, not just for one hosted zone. Option D would result in wrong answers, not NXDOMAIN (Route 53 would return records from the conflicting zone rather than NXDOMAIN if it existed).

---

### Question 53

A company is using AWS Storage Gateway (File Gateway) in a VPC. They notice that the gateway's CloudWatch metrics show increasing CachePercentDirty values and users report slow write performance. The gateway cache disk is 500 GiB on an EBS gp2 volume.

What should the solutions architect do to improve write performance?

A. Increase the cache disk size and switch from gp2 to io2 EBS volume type for the cache disk to provide higher IOPS and throughput.

B. Increase the File Gateway instance size to get more network bandwidth for uploading dirty cache data to S3.

C. Enable S3 Transfer Acceleration on the target bucket to speed up cache-to-S3 uploads.

D. Add a second File Gateway and split the workload across two gateways to halve the write load on each cache.

**Correct Answer: A**

**Explanation:** High CachePercentDirty indicates the gateway is writing to cache faster than it can upload to S3. This bottleneck is often caused by insufficient cache disk IOPS. gp2 volumes provide limited IOPS (3 IOPS/GiB, max 16,000). Switching to io2 (A) provides provisioned IOPS up to 64,000, dramatically improving the gateway's ability to manage cache writes and uploads. Increasing the cache size also helps by providing more buffer space. Option B might help if the network is the bottleneck, but the question points to cache disk performance (CachePercentDirty). Option C doesn't apply — the gateway is already in a VPC with direct access to S3. Option D adds complexity without addressing the root cause.

---

### Question 54

A company is migrating 500 TB of data from an on-premises NetApp filer to Amazon FSx for NetApp ONTAP. They have a 10 Gbps Direct Connect connection. The migration must complete within 30 days with minimal impact on production workloads accessing the NetApp filer during migration.

Which migration strategy is MOST efficient?

A. Use NetApp SnapMirror replication from the on-premises NetApp filer to FSx for NetApp ONTAP over the Direct Connect connection. Perform incremental SnapMirror updates until the final cutover, then break the SnapMirror relationship.

B. Use AWS DataSync to copy data from the NFS exports on the NetApp filer to FSx for NetApp ONTAP.

C. Use AWS Snowball Edge devices to transfer the initial data, then use DataSync for incremental synchronization.

D. Use robocopy over the Direct Connect connection to mirror the data from the on-premises filer to FSx.

**Correct Answer: A**

**Explanation:** SnapMirror (A) is the native NetApp replication technology and provides the most efficient migration path between NetApp systems. It performs block-level replication, which is more efficient than file-level copying. The initial baseline transfer is followed by incremental transfers that only replicate changed blocks, minimizing bandwidth usage and migration time. SnapMirror has minimal impact on production workloads. At 10 Gbps, 500 TB can transfer in approximately 5 days at full utilization. Incremental syncs keep the FSx system current until the final cutover. Option B works but is file-level and less efficient for NetApp-to-NetApp transfers. Option C introduces physical shipping delays. Option D is extremely slow and has no incremental/differential capability.

---

### Question 55

A company is migrating their DNS infrastructure from on-premises BIND servers to AWS. They have 200 DNS zones with 50,000 records total. The migration must be performed with zero downtime and needs to support a rollback plan.

Which migration approach provides zero downtime with a rollback capability?

A. Export all zones from BIND as zone files. Create Route 53 hosted zones and import records using the Route 53 API. Lower TTLs on all records 48 hours before migration. During cutover, update the domain registrar's NS records to point to Route 53 name servers. For rollback, revert the NS records.

B. Use Route 53 Resolver with forwarding rules during the transition. Forward all queries to the on-premises BIND servers. Gradually migrate zones to Route 53 by removing forwarding rules one zone at a time.

C. Deploy BIND on EC2 instances as an intermediate step. Migrate on-premises BIND to EC2, verify, then migrate from EC2 to Route 53.

D. Use AWS Migration Hub to discover and migrate DNS configurations automatically.

**Correct Answer: A**

**Explanation:** The standard DNS migration approach (A) involves: 1) Creating all zones and records in Route 53 in parallel with the existing BIND servers, 2) Lowering TTLs 48 hours before cutover so cached records expire quickly, 3) Switching NS delegation to Route 53 name servers, 4) Monitoring for issues. Rollback simply involves reverting NS records to the BIND servers (which continue running until the migration is fully verified). This provides zero downtime because both systems serve correct answers during the transition. Option B doesn't actually migrate to Route 53 — it just forwards. Option C adds an unnecessary intermediate step. Option D — Migration Hub doesn't support DNS migration.

---

### Question 56

A company is migrating from an on-premises Samba-based file server to AWS. The file server provides CIFS/SMB shares to 200 Windows clients. The migration requirements are: maintain SMB protocol, preserve NTFS permissions, support DFS (Distributed File System) namespaces, and provide multi-AZ availability.

Which AWS service is the BEST migration target?

A. Amazon FSx for Windows File Server (Multi-AZ deployment) with DFS namespace support.

B. Amazon EFS with Windows-compatible mount using the EFS NFS client.

C. AWS Storage Gateway File Gateway with SMB shares backed by S3.

D. Amazon FSx for NetApp ONTAP configured with CIFS shares.

**Correct Answer: A**

**Explanation:** Amazon FSx for Windows File Server (A) is built on Windows Server and provides native support for SMB protocol, NTFS permissions, DFS namespaces, and Multi-AZ deployment for high availability. It's the most natural migration target for a Windows file server. Option B doesn't support SMB natively — EFS uses NFS protocol. Option C supports SMB but doesn't support DFS namespaces or native NTFS ACLs at the same fidelity. Option D supports CIFS but DFS namespace support is limited compared to native Windows File Server.

---

### Question 57

A company has 100 on-premises servers that need to access AWS services during a phased migration. They are setting up a hybrid DNS architecture and need to ensure that all on-premises servers can resolve AWS private endpoints (e.g., S3 interface endpoints, RDS endpoints) using their private IP addresses.

During testing, on-premises servers resolve S3 VPC endpoint DNS names to public IP addresses instead of the private endpoint IPs.

What is the root cause?

A. The on-premises DNS servers are resolving S3 endpoint DNS names via public DNS, which returns public IPs. Route 53 Resolver inbound endpoints need to be configured, and on-premises DNS servers must conditionally forward S3 endpoint DNS queries to the Resolver inbound endpoints.

B. The VPC endpoint has private DNS disabled. Enable private DNS on the S3 interface endpoint.

C. The on-premises servers are not using the correct VPC endpoint DNS names. They should use the regional endpoint format (bucket.vpce-xxx.s3.us-east-1.vpce.amazonaws.com).

D. S3 gateway endpoints don't support DNS resolution from on-premises. Switch to an S3 interface endpoint.

**Correct Answer: A**

**Explanation:** On-premises DNS servers query public DNS resolvers by default, which return the public IP addresses for AWS service endpoints. To resolve VPC endpoints' private IPs from on-premises, you need Route 53 Resolver inbound endpoints (A) that on-premises DNS servers can forward queries to. The Route 53 Resolver, running within the VPC context, returns the private IP addresses of the VPC endpoints. Option B — even with private DNS enabled, on-premises servers querying public DNS won't get private IPs. Option C — using specific endpoint DNS names works but requires application changes. Option D is partly correct (gateway endpoints don't support DNS from on-premises) but the question mentions interface endpoints being used.

---

### Question 58

A company is migrating a large Oracle database (20 TB) from on-premises to Amazon RDS for Oracle. They have a 10 Gbps Direct Connect connection. The database must remain operational during migration with minimal downtime for the final cutover.

Which migration strategy provides the SHORTEST cutover downtime?

A. Use AWS Database Migration Service (DMS) with full load plus Change Data Capture (CDC). Start with a full load migration to RDS, then enable CDC to replicate ongoing changes. When the replication lag approaches zero, perform the cutover by redirecting applications to RDS.

B. Use Oracle Data Pump to export the database, transfer the dump file to S3 via Direct Connect, and import into RDS. Then use DMS CDC to capture changes made during the import.

C. Use Oracle RMAN backup, restore to an EC2 instance running Oracle, then use Oracle Data Guard to replicate to RDS.

D. Use AWS Snowball to physically transfer the database, then use DMS CDC to capture changes made during the shipping period.

**Correct Answer: A**

**Explanation:** DMS with full load plus CDC (A) provides the shortest cutover downtime. DMS performs the initial full load while the source remains operational, then enters CDC mode to continuously replicate changes from the Oracle redo logs. When the replication lag is minimal (near zero), applications are briefly stopped, the final changes replicate, and applications are redirected to RDS. Downtime is limited to the final switchover (minutes). Option B involves export/import time during which changes accumulate, though DMS CDC can catch up. Option C is complex, and Oracle Data Guard to RDS is not directly supported. Option D introduces shipping delays.

---

### Question 59

A company is migrating from an on-premises LDAP directory (OpenLDAP) to AWS. Applications use LDAP for authentication and authorization. They have 10,000 users with custom LDAP schemas. The company does not use Microsoft Active Directory on-premises.

Which migration path is MOST appropriate?

A. Deploy AWS Managed Microsoft AD and migrate users using the LDAP Data Interchange Format (LDIF). Reconfigure applications to use LDAP bind against the AWS Managed Microsoft AD.

B. Deploy Simple AD and import users using LDIF files. Applications continue using LDAP protocol with minimal changes.

C. Deploy OpenLDAP on EC2 instances. Migrate the directory data and schema using LDIF export/import. Applications connect to the EC2-based LDAP servers.

D. Use Amazon Cognito user pools as a replacement for LDAP. Migrate users to Cognito and reconfigure applications to use Cognito's API.

**Correct Answer: C**

**Explanation:** Given the custom LDAP schemas, deploying OpenLDAP on EC2 (C) provides the highest schema compatibility and least application modification. Custom LDAP schemas may not map directly to Microsoft AD or Simple AD schema. LDIF export/import preserves the schema extensions, attributes, and data. Applications continue using LDAP protocol against the same directory structure. Option A may not support custom OpenLDAP schemas in the Microsoft AD schema. Option B — Simple AD is Samba-based and has limited schema extension support. Option D requires significant application refactoring from LDAP to Cognito APIs.

---

### Question 60

A company is migrating a distributed application that uses multicast networking for cluster communication. The application runs on 10 servers in an on-premises data center. They want to migrate to EC2 instances while preserving the multicast functionality.

Which AWS networking solution supports this requirement?

A. Deploy the EC2 instances in a placement group with cluster strategy. Multicast is supported within cluster placement groups.

B. Deploy the EC2 instances in a VPC and use Transit Gateway with multicast enabled. Create a Transit Gateway multicast domain and register the EC2 instances as multicast sources and group members.

C. Deploy the EC2 instances in a VPC and implement a software overlay network (e.g., VXLAN) to emulate multicast over unicast.

D. Use Elastic Fabric Adapter (EFA) on the EC2 instances to support multicast traffic.

**Correct Answer: B**

**Explanation:** AWS Transit Gateway supports multicast (B) through Transit Gateway multicast domains. You can create a multicast domain, add VPC subnets, and register EC2 instances as multicast group members and sources using IGMP or static configuration. This is the native AWS solution for multicast networking. Option A is incorrect — cluster placement groups don't enable multicast; they optimize for low latency and high throughput unicast traffic. Option C works but adds complexity with a software overlay. Option D — EFA is for HPC and MPI traffic, not standard IP multicast.

---

### Question 61

A company is performing a phased migration from on-premises to AWS. During the transition (estimated 12 months), both environments need to share a common Active Directory for authentication. The on-premises AD has 30,000 users with complex Group Policy configurations. The company needs AWS resources to be domain-joined and fully managed by Group Policy.

Which directory approach provides the SMOOTHEST transition?

A. Deploy AWS Managed Microsoft AD and create a two-way forest trust with the on-premises AD. Apply separate Group Policies for AWS resources through the AWS Managed AD.

B. Extend the on-premises AD to AWS by deploying additional domain controllers on EC2 instances in the same domain. AWS resources join the existing domain and receive the same Group Policies.

C. Deploy AD Connector to relay authentication to on-premises. Create local Group Policies on each EC2 instance manually.

D. Use IAM Identity Center with SAML integration to the on-premises AD for AWS console access, and deploy a separate Simple AD for EC2 instance domain joins.

**Correct Answer: B**

**Explanation:** Extending the existing AD to EC2-based domain controllers (B) provides the smoothest transition because: 1) All existing Group Policies, OUs, and configurations apply to AWS resources automatically, 2) No trust relationships to manage — it's the same domain, 3) Users authenticate with the same credentials against local (AWS-hosted) DCs for low latency, 4) Replication keeps everything synchronized. After migration completes, on-premises DCs can be decommissioned. Option A requires recreating or creating new Group Policies in the AWS Managed AD forest. Option C doesn't support Group Policy application. Option D is overly complex and doesn't provide Group Policy support via Simple AD.

---

### Question 62

A company is migrating their DNS from on-premises split-horizon DNS to Route 53. They have the domain example.com with different records served internally (on-premises) versus externally (internet). Internal clients resolve app.example.com to 10.0.1.50, while external clients resolve it to 203.0.113.50.

How should they implement split-horizon DNS in Route 53?

A. Create one Route 53 public hosted zone for example.com with the external IP. Create a Route 53 private hosted zone for example.com associated with the VPCs, containing the internal IP records. Internal VPC clients automatically get private hosted zone answers.

B. Create a Route 53 public hosted zone with weighted routing — weight 100 for internal and weight 0 for external, with the health check controlling which record is served.

C. Create a Route 53 public hosted zone and use geolocation routing to serve internal IPs to the company's IP ranges and external IPs to everyone else.

D. Create a Route 53 private hosted zone only. Internal clients use it, and external clients use the existing on-premises DNS for public resolution.

**Correct Answer: A**

**Explanation:** Route 53 natively supports split-horizon DNS (A) through the combination of public and private hosted zones with the same domain name. VPC resources (using AmazonProvidedDNS) automatically query the private hosted zone first, getting the internal 10.0.1.50 record. External internet clients query the public hosted zone, getting 203.0.113.50. No special routing policy is needed — the hosted zone type determines which response is served. Option B doesn't achieve split-horizon — weighted routing distributes traffic proportionally, not by client location. Option C relies on geolocation which maps by geographic region, not by internal/external network. Option D doesn't handle external DNS resolution in Route 53.

---

### Question 63

A company has a 10 Gbps dedicated Direct Connect connection that is currently 30% utilized on average. They are considering whether to keep the dedicated connection, switch to hosted connections, or use VPN. The company needs to reduce costs while maintaining at least 3 Gbps of sustained throughput during peak hours.

Which option provides the MOST cost-effective connectivity?

A. Keep the 10 Gbps dedicated connection as the cost per Gbps is optimal at this capacity.

B. Replace with two 1 Gbps hosted connections in a LAG for redundancy, using a Site-to-Site VPN as a backup for peak capacity overflow.

C. Replace with a single 5 Gbps hosted connection from a Direct Connect partner, matching the peak utilization more closely.

D. Replace the Direct Connect connection entirely with multiple Site-to-Site VPN connections using Transit Gateway ECMP for bandwidth aggregation.

**Correct Answer: C**

**Explanation:** A 5 Gbps hosted connection (C) right-sizes the connection for the actual usage pattern. At 30% average utilization of 10 Gbps = 3 Gbps average, a 5 Gbps connection accommodates the peak (3 Gbps sustained) with headroom. Hosted connections typically have lower port-hour charges than dedicated connections and can be provisioned from DX partners. Option A maintains overprovisioned capacity — the 10 Gbps connection at 30% utilization means 70% is wasted capacity being paid for. Option B — two 1 Gbps connections in a LAG only provides 2 Gbps, insufficient for 3 Gbps peak. Option D — VPN has lower bandwidth per tunnel (1.25 Gbps) and less predictable latency than DX.

---

### Question 64

A company uses Storage Gateway (File Gateway) with multiple file shares, each backed by a different S3 bucket. They notice their monthly S3 costs are higher than expected. Analysis shows that File Gateway writes objects using the S3 Standard storage class, but 80% of files are accessed less than once per month.

Which approach reduces S3 costs with the LEAST disruption to users?

A. Configure the File Gateway file shares to use S3 Intelligent-Tiering as the default storage class. Existing objects will continue with S3 Standard but new objects will use Intelligent-Tiering.

B. Create S3 Lifecycle rules on each bucket to transition objects from S3 Standard to S3 Infrequent Access (S3 Standard-IA) after 30 days.

C. Change the file share configuration to use S3 Standard-IA as the default storage class. Enable an S3 Lifecycle rule to transition objects to S3 Glacier after 90 days.

D. Enable S3 Intelligent-Tiering at the bucket level with an S3 Lifecycle rule and configure File Gateway RefreshCache to update the gateway's metadata.

**Correct Answer: A**

**Explanation:** File Gateway allows configuring the default storage class for each file share (A). Setting it to S3 Intelligent-Tiering automatically optimizes costs based on access patterns without performance impact — frequently accessed files stay in the frequent access tier, while infrequently accessed files automatically move to lower-cost tiers. This is the least disruptive because Intelligent-Tiering has no retrieval fees and the same millisecond access latency. Option B introduces retrieval fees when users access files that have been transitioned to IA. Option C uses IA which has a minimum 30-day storage charge and Glacier adds retrieval latency. Option D — Intelligent-Tiering is applied per-object at upload time via the file share config, not at the bucket level.

---

### Question 65

A company has a Direct Connect connection with both a private VIF and a public VIF. The public VIF is used exclusively for S3 data transfers. The company wants to eliminate the public VIF to simplify their architecture and reduce their attack surface, but they still need private access to S3 over Direct Connect.

Which approach replaces the public VIF for S3 access?

A. Create an S3 VPC gateway endpoint in the VPC. Traffic from on-premises will route through the private VIF to the VPC and then through the gateway endpoint to S3.

B. Create an S3 VPC interface endpoint (PrivateLink) in the VPC. Configure on-premises DNS to resolve S3 endpoint names to the interface endpoint's private IPs. Route S3 traffic from on-premises through the private VIF to the VPC and out through the interface endpoint.

C. Configure S3 Transfer Acceleration to route traffic through CloudFront edge locations instead of the public VIF.

D. Use the private VIF to access S3 directly, as S3 is accessible through private VIFs without any additional configuration.

**Correct Answer: B**

**Explanation:** An S3 VPC interface endpoint (PrivateLink) (B) provides private IP addresses within the VPC subnet for S3 access. On-premises traffic routes through the Direct Connect private VIF to the VPC, then to the S3 interface endpoint. By configuring on-premises DNS to resolve S3 endpoint names to these private IPs (or using the VPC endpoint-specific DNS names), S3 traffic flows entirely over private connectivity. Option A — S3 gateway endpoints only work for traffic originating within the VPC; they don't handle traffic from on-premises transiting through the VPC. Option C uses the public internet, not Direct Connect. Option D is incorrect — S3 is not accessible through private VIFs without an endpoint.

---

### Question 66

A company has 15 branch offices, each with a File Gateway providing local access to shared files in S3. They are paying for 15 separate File Gateway VM instances on-premises. The branch offices are small (5-10 users each) and only need access during business hours.

How can the company MOST effectively reduce File Gateway operational costs?

A. Consolidate all File Gateways into a single File Gateway deployed on a large EC2 instance in AWS, and have branch offices access it over VPN.

B. Replace File Gateways with a direct S3 browser-based interface (AWS Management Console) for each branch office.

C. Deploy File Gateways on AWS as EC2 instances (one per branch) and use scheduled start/stop to run them only during business hours. Branch offices access them via Direct Connect or VPN.

D. Replace File Gateways with Amazon WorkDocs for file sharing across branch offices.

**Correct Answer: C**

**Explanation:** Deploying File Gateways on EC2 with scheduled start/stop (C) eliminates on-premises hardware maintenance costs and allows the company to only pay for compute during business hours. Each branch office maintains its own gateway for caching and performance, but the gateway runs in AWS. Scheduled start/stop (via Lambda or EC2 Auto Scaling scheduled actions) reduces EC2 costs by ~65% (running 10 hours/day instead of 24). Option A loses the local caching benefit — branch office users would experience WAN latency for every file operation. Option B changes the user experience significantly and is not suitable for SMB/NFS file access workflows. Option D changes the file sharing paradigm entirely and may not support existing workflows.

---

### Question 67

A company operates a Direct Connect connection that costs $10,000/month (port charges + data transfer). They transfer 20 TB/month to AWS and 5 TB/month from AWS. A network audit reveals that 15 TB of the inbound transfer is log data that could tolerate higher latency and occasional packet loss.

Which approach provides the MOST significant cost reduction?

A. Transfer the 15 TB of log data over a Site-to-Site VPN connection instead of Direct Connect. Keep the remaining 5 TB inbound and all outbound traffic on Direct Connect.

B. Downgrade the Direct Connect connection to a lower bandwidth and use S3 Transfer Acceleration for log data uploads.

C. Compress log data before transferring over Direct Connect to reduce data transfer volume.

D. Use a smaller Direct Connect hosted connection for all traffic and queue log transfers during off-peak hours.

**Correct Answer: A**

**Explanation:** Separating latency-tolerant log data (15 TB) to VPN (A) significantly reduces Direct Connect data transfer charges. AWS doesn't charge for data transfer IN over the internet (VPN), while Direct Connect charges for data transfer. Moving 15 TB of inbound traffic off DX eliminates 75% of inbound data transfer charges. The remaining 5 TB of latency-sensitive inbound traffic stays on DX for reliability. This may also allow downgrading the DX connection capacity. Option B adds Transfer Acceleration costs and still uses internet bandwidth. Option C reduces volume but adds processing overhead and doesn't change the connection model. Option D still pays DX data transfer for all traffic.

---

### Question 68

A company uses AWS Managed Microsoft AD (Enterprise Edition) with 500 EC2 instances domain-joined across 5 VPCs. They are concerned about the cost of Enterprise Edition ($345/month) when they only have 8,000 users. Standard Edition ($109/month) supports up to 30,000 users.

Should they downgrade to Standard Edition, and what factors should they consider?

A. Yes, downgrade to Standard Edition. Standard supports 30,000 users, which is more than adequate. The functional capabilities are identical between editions.

B. No, keep Enterprise Edition. Standard Edition only supports 5,000 objects (users, computers, groups combined). With 500 EC2 instances plus 8,000 users, they likely exceed Standard Edition's object limit.

C. Yes, downgrade to Standard Edition. However, they should first verify that their total object count (users + computers + groups + other objects) does not exceed 30,000, and that they don't need more than 2 domain controllers.

D. No, keep Enterprise Edition. Enterprise is required for multi-region replication and trust relationships, which the company might need in the future.

**Correct Answer: C**

**Explanation:** Standard Edition supports approximately 30,000 objects and is suitable for small to medium environments. The company should verify total object count — 8,000 users + 500 computers + groups + other objects must stay below the Standard limit. Standard provides 2 domain controllers (vs Enterprise's larger/higher-performance DCs). The cost savings of $236/month ($2,832/year) is meaningful if the environment fits within Standard Edition limits. Option A incorrectly states capabilities are identical — Enterprise has higher throughput and supports more objects. Option B incorrectly states 5,000 object limit — Standard supports ~30,000 objects. Option D — Standard also supports trusts and multi-region replication.

---

### Question 69

A company has a hybrid DNS architecture with Route 53 Resolver inbound and outbound endpoints. They are paying $0.125/hour per ENI for the Resolver endpoints. Each endpoint requires a minimum of 2 ENIs. The company has endpoints deployed in 5 VPCs, resulting in 20 ENIs (10 inbound + 10 outbound).

How can they reduce Resolver endpoint costs while maintaining functionality?

A. Consolidate Resolver endpoints into a single shared-services VPC. Use Transit Gateway or VPC peering to route DNS traffic from all VPCs to the centralized endpoints. Share forwarding rules via AWS RAM.

B. Reduce the number of ENIs per endpoint from 2 to 1 by modifying the endpoint configuration.

C. Replace Route 53 Resolver with EC2-based DNS forwarders that are cheaper to operate.

D. Disable Resolver endpoints during non-business hours using Lambda-based automation.

**Correct Answer: A**

**Explanation:** Centralizing Resolver endpoints (A) in one VPC reduces from 20 ENIs to 4 ENIs (2 inbound + 2 outbound), saving 80% on endpoint costs. With Transit Gateway or VPC peering, DNS traffic from other VPCs routes to the centralized endpoints. RAM-shared forwarding rules ensure all VPCs still have outbound resolution configured. This saves approximately $1,752/month (16 ENIs × $0.125/hour × 730 hours). Option B is incorrect — 2 ENIs is the minimum for HA; you can't reduce to 1. Option C likely costs more when factoring in EC2 instance costs, management overhead, and doesn't provide the same integration. Option D breaks DNS resolution during off-hours, which is unacceptable for most workloads.

---

### Question 70

A company has been using a Tape Gateway sending virtual tapes to S3 Glacier Flexible Retrieval. Their annual tape storage cost is $50,000. They want to reduce costs for tapes older than 1 year that are retained only for compliance (7-year retention, rarely accessed).

Which approach provides the GREATEST cost reduction?

A. Move archived tapes older than 1 year to S3 Glacier Deep Archive using the Storage Gateway console to change the archive pool.

B. Create a new Tape Gateway configured to archive to S3 Glacier Deep Archive. Move all new tapes to the new gateway and leave existing tapes in Glacier Flexible Retrieval.

C. Delete tapes older than 1 year since they are no longer needed for operational purposes.

D. Reduce the number of virtual tapes created by increasing the backup full/incremental ratio.

**Correct Answer: A**

**Explanation:** Moving archived tapes from Glacier Flexible Retrieval to Glacier Deep Archive (A) provides approximately 75% storage cost reduction ($0.0036/GB/month vs $0.00099/GB/month). For compliance-only tapes that are rarely accessed, the slower retrieval time (12-48 hours for Deep Archive vs 3-5 hours for Flexible Retrieval) is acceptable. Storage Gateway supports moving tapes between archive pools through the console. Option B doesn't address the existing tapes which are the bulk of the cost. Option C violates the 7-year compliance retention requirement. Option D reduces future storage growth but doesn't address existing costs.

---

### Question 71

A company has a 10 Gbps Direct Connect connection with data transfer charges averaging $15,000/month. Analysis shows that 60% of data transfer is S3 data being accessed by on-premises applications, and this data could alternatively be cached locally.

Which approach provides the MOST significant data transfer cost reduction?

A. Deploy a Storage Gateway File Gateway on-premises to cache frequently accessed S3 data locally, reducing repetitive S3 data retrieval over Direct Connect.

B. Enable S3 Intelligent-Tiering to reduce storage costs, which indirectly reduces data transfer.

C. Use CloudFront with a custom origin pointing to S3 to cache data closer to on-premises users.

D. Implement client-side caching in the on-premises applications to reduce repeated S3 API calls.

**Correct Answer: A**

**Explanation:** File Gateway (A) caches frequently accessed S3 data on-premises, eliminating repetitive data transfer over Direct Connect for the same files. If 60% of the $15,000 ($9,000) is S3 data transfer, and the local cache satisfies 80% of repeated requests, the company saves approximately $7,200/month in data transfer. The gateway's local cache serves repeated reads without traversing DX. Option B reduces storage costs, not data transfer. Option C introduces CloudFront costs and the data still needs to reach on-premises over DX or internet. Option D requires application changes and may not be feasible for all applications.

---

### Question 72

A company uses AWS Managed Microsoft AD for 200 EC2 instances. They are paying for EC2 instances running as domain controllers in addition to the Managed AD. Upon investigation, the EC2 domain controllers were deployed by a previous architect "for redundancy."

What should the solutions architect recommend to optimize costs?

A. Decommission the EC2-based domain controllers. AWS Managed Microsoft AD already provides highly available domain controllers across multiple AZs. The EC2 instances are redundant.

B. Keep the EC2 domain controllers but switch them to smaller instance types to reduce costs.

C. Replace AWS Managed Microsoft AD with the EC2-based domain controllers to eliminate the Managed AD monthly charge.

D. Keep both for maximum redundancy and implement Reserved Instances for the EC2 domain controllers.

**Correct Answer: A**

**Explanation:** AWS Managed Microsoft AD (A) already deploys and manages multiple domain controllers across two AZs for high availability. Additional EC2-based domain controllers in the same domain are unnecessary unless there's a specific requirement (like additional AD sites or custom DCs for specific workloads). Decommissioning them eliminates EC2 compute costs while maintaining the same level of availability. Option B reduces but doesn't eliminate unnecessary cost. Option C increases operational burden significantly. Option D wastes money on redundant infrastructure.

---

### Question 73

A company has three Direct Connect connections: 10 Gbps in us-east-1, 10 Gbps in eu-west-1, and 10 Gbps in ap-southeast-1. Each connection is used by the nearest regional office. Analysis shows that the eu-west-1 connection averages only 1 Gbps utilization and the ap-southeast-1 connection averages 500 Mbps.

Which approach optimizes costs while maintaining regional connectivity?

A. Replace the eu-west-1 and ap-southeast-1 dedicated connections with hosted connections matching their actual utilization (1 Gbps and 500 Mbps respectively). Keep the us-east-1 connection as-is.

B. Consolidate all traffic to the us-east-1 connection and use AWS backbone for inter-region traffic.

C. Replace all three connections with VPN connections over the internet.

D. Keep all three dedicated connections but negotiate lower port-hour charges with the DX partners.

**Correct Answer: A**

**Explanation:** Right-sizing the underutilized connections (A) to hosted connections matching actual usage saves significantly on port-hour charges. A 10 Gbps dedicated connection has a much higher port-hour rate than a 1 Gbps or 500 Mbps hosted connection. The eu-west-1 office gets a 1 Gbps hosted connection (matching their usage), and ap-southeast-1 gets a 500 Mbps hosted connection. Regional connectivity and latency characteristics are maintained. Option B routes all traffic through us-east-1, significantly increasing latency for European and Asian offices. Option C sacrifices the consistent network performance DX provides. Option D — port-hour charges are set by AWS, not negotiable with partners (though partner charges may be negotiable).

---

### Question 74

A company uses Route 53 Resolver for hybrid DNS. They process 50 million DNS queries per month through the Resolver endpoints. Route 53 Resolver charges $0.40 per million queries processed through endpoints. The monthly DNS cost is $20.

Which approach could reduce DNS query costs?

A. Implement DNS caching on the on-premises DNS servers to reduce the number of queries forwarded to Route 53 Resolver endpoints.

B. Increase DNS record TTLs across all hosted zones to reduce the frequency of re-queries.

C. Replace Route 53 Resolver with EC2-based Unbound DNS resolvers that cache aggressively.

D. Both A and B are effective approaches that can be combined for maximum cost reduction.

**Correct Answer: D**

**Explanation:** Both caching on on-premises DNS servers (A) and increasing TTLs (B) reduce query volume reaching the Resolver endpoints. On-premises DNS caching means repeated queries for the same records are served locally without forwarding to Route 53. Higher TTLs mean records are cached longer before re-querying. Combined (D), these approaches can significantly reduce the 50 million queries — potentially by 50-80%, saving $10-16/month. While $20/month may seem small, for larger organizations processing billions of queries, these optimizations scale proportionally. Option C introduces operational complexity for minimal savings at this scale.

---

### Question 75

A company is evaluating the total cost of ownership for their hybrid connectivity. They currently have: one 10 Gbps Direct Connect dedicated connection ($1,800/month port + $5,000/month data transfer), one backup Site-to-Site VPN ($73/month), Route 53 Resolver endpoints (4 ENIs at $365/month), and a Storage Gateway File Gateway on an EC2 m5.xlarge ($140/month).

The company's IT budget is being cut by 30%. Which combination of changes achieves the MOST significant cost reduction while maintaining acceptable service levels? (Choose TWO.)

A. Replace the 10 Gbps dedicated Direct Connect with a 5 Gbps hosted connection if utilization analysis supports it. This could reduce the port charge by approximately 50%.

B. Reduce Route 53 Resolver from 4 ENIs to the minimum 2 ENIs per endpoint, accepting reduced DNS query throughput.

C. Switch the File Gateway EC2 instance to a smaller instance type (m5.large) or use a Graviton-based instance (m6g.xlarge) for better price-performance.

D. Eliminate the backup VPN connection and rely solely on Direct Connect for connectivity.

E. Move the Storage Gateway to an on-premises VM to eliminate the EC2 cost entirely.

**Correct Answer: A, C**

**Explanation:** The DX port charge ($1,800/month) is the largest single cost. Right-sizing to a 5 Gbps hosted connection (A) could save approximately $900/month on port charges. The File Gateway EC2 instance (C) can be optimized by using Graviton instances (20% cheaper) or downsizing if the workload allows, saving $30-70/month. Together these changes save approximately $1,000/month — a meaningful reduction. Option B saves $365/month but the 4 ENIs are likely already the minimum (2 per endpoint for inbound + outbound). Option D eliminates the $73 backup, but losing redundancy is a poor trade-off. Option E shifts cost from AWS to on-premises hardware/power/cooling, which may not be cheaper.

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer | Q | Answer | Q | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B | 31 | B | 46 | B | 61 | B |
| 2 | A | 17 | A | 32 | A | 47 | A | 62 | A |
| 3 | B | 18 | B | 33 | B | 48 | A, B | 63 | C |
| 4 | A | 19 | A | 34 | B | 49 | A | 64 | A |
| 5 | A, B | 20 | B | 35 | A | 50 | B | 65 | B |
| 6 | C | 21 | B, E | 36 | B | 51 | A | 66 | C |
| 7 | C | 22 | A | 37 | B | 52 | A | 67 | A |
| 8 | A | 23 | C, D | 38 | A, C | 53 | A | 68 | C |
| 9 | B | 24 | A | 39 | A, B, C | 54 | A | 69 | A |
| 10 | A | 25 | A | 40 | A | 55 | A | 70 | A |
| 11 | A | 26 | A | 41 | D | 56 | A | 71 | A |
| 12 | C | 27 | A | 42 | B | 57 | A | 72 | A |
| 13 | B | 28 | C | 43 | C | 58 | A | 73 | A |
| 14 | C | 29 | B | 44 | B | 59 | C | 74 | D |
| 15 | C | 30 | B | 45 | A | 60 | B | 75 | A, C |

---

## Topic Distribution

| Topic | Questions |
|-------|-----------|
| Direct Connect Architecture & Redundancy | 1, 2, 6, 8, 12, 17, 29, 31, 35, 38, 44 |
| VPN & Hybrid Connectivity | 15, 21, 42 |
| DNS Resolution (Route 53 Resolver) | 4, 9, 11, 14, 19, 25, 33, 36, 37, 48, 52 |
| Directory Services (AD, Simple AD, AD Connector) | 3, 7, 16, 20, 24, 30, 34, 40, 45, 50, 59, 61 |
| Storage Gateway (File, Volume, Tape) | 5, 10, 13, 18, 22, 27, 28, 32, 43, 47, 51, 53 |
| Migration Scenarios | 54, 55, 56, 57, 58, 60, 62 |
| Cost Optimization | 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75 |
| Network Architecture (TGW, Segmentation) | 23, 26, 39, 41, 46 |
