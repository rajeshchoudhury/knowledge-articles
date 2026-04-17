# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 7

**Focus Areas:** Transit Gateway, PrivateLink, Network Firewall, EKS Advanced, SageMaker, Bedrock

**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain 1: Design Solutions for Organizational Complexity (Questions 1–20)

### Question 1
A global enterprise has 200 AWS accounts organized under AWS Organizations with separate OUs for production, staging, and development. The networking team manages a central networking account with a Transit Gateway that interconnects 50 VPCs. The company is expanding to a second AWS Region and needs to establish inter-region connectivity for all VPCs while maintaining centralized traffic inspection using AWS Network Firewall. The solution must minimize the number of Transit Gateway attachments and support future growth to 500 VPCs.

A) Create a Transit Gateway in each region and establish Transit Gateway peering between them. Deploy AWS Network Firewall in a dedicated inspection VPC attached to each regional Transit Gateway. Use Transit Gateway route tables to route inter-region traffic through the inspection VPC before forwarding to the peered Transit Gateway.
B) Create a single Transit Gateway in the primary region and attach all VPCs from both regions using cross-region VPC attachments. Deploy Network Firewall in the primary region's inspection VPC for centralized inspection.
C) Use AWS Cloud WAN to replace Transit Gateway. Cloud WAN natively supports multi-region networking with segment-based routing policies and integrates with Network Firewall for inspection. Define core and edge segments for traffic isolation.
D) Create Transit Gateways in both regions with peering. Use VPN connections between regions instead of Transit Gateway peering for encrypted inter-region traffic. Deploy Network Firewall at each regional Transit Gateway.

**Correct Answer: C**

**Explanation:** AWS Cloud WAN is designed for managing global networks at scale. It provides centralized management of multi-region connectivity with policy-based routing through segments, which naturally isolates traffic between production, staging, and development environments. Cloud WAN integrates with Network Firewall for centralized or distributed inspection patterns. It scales beyond Transit Gateway's limits and simplifies operations for 500+ VPCs across regions. Option A works but requires manual route management across two Transit Gateways. Option B is incorrect — Transit Gateway doesn't support cross-region VPC attachments; VPCs must be in the same region as the TGW. Option D using VPN adds encryption overhead and complexity when Transit Gateway peering already uses the AWS backbone.

---

### Question 2
A financial services company has deployed AWS PrivateLink to expose internal microservices across 30 VPCs in the same region. The shared services team manages an API Gateway, authentication service, and logging service that all application VPCs consume via PrivateLink. The company now needs to extend these services to 20 VPCs in a second region and 10 VPCs in a partner's AWS account in a third region. The solution must maintain private connectivity without exposing services to the internet.

A) Create new Network Load Balancers and VPC endpoint services in each additional region. Deploy service replicas in each region. Consumer VPCs in partner accounts use cross-account interface VPC endpoints.
B) Use Transit Gateway inter-region peering to extend network connectivity from the primary region to the other two regions. Consumer VPCs access services through the existing PrivateLink endpoints via Transit Gateway routing.
C) Deploy service replicas in each region behind NLBs. Create VPC endpoint services in each region. For the partner account, use PrivateLink with cross-account endpoint access by adding the partner's AWS account principal to the endpoint service's allowed principals list.
D) Use AWS Global Accelerator with custom routing to expose the services globally. Consumer VPCs in all regions use the Global Accelerator endpoint. Traffic routes over the AWS backbone to the primary region's services.

**Correct Answer: C**

**Explanation:** PrivateLink is region-scoped — endpoint services and interface endpoints must be in the same region. Therefore, service replicas with NLBs and endpoint services are needed in each region. For the partner account, PrivateLink natively supports cross-account access by adding the partner's AWS account ID to the VPC endpoint service's allowed principals. This maintains private connectivity (no internet exposure) across regions and accounts. Option A is partially correct but doesn't explicitly address the cross-account mechanism. Option B is incorrect because PrivateLink endpoints are not accessible through Transit Gateway routing — they use DNS-based resolution within the VPC. Option D exposes services through a public endpoint (Global Accelerator), violating the private connectivity requirement.

---

### Question 3
A company operates a multi-account AWS environment with a shared services VPC that hosts monitoring, logging, and CI/CD tools. Application teams in 50 spoke accounts need to access these tools. Currently, VPC peering connects all spoke VPCs to the shared services VPC, creating 50 peering connections. The networking team wants to reduce the operational burden while adding the ability to inspect traffic between spoke VPCs and the shared services VPC. Some spoke VPCs have overlapping CIDR ranges.

A) Replace VPC peering with Transit Gateway. Attach all spoke VPCs and the shared services VPC to the Transit Gateway. Use Transit Gateway route tables for traffic control and attach a Network Firewall inspection VPC for traffic inspection.
B) Replace VPC peering with AWS PrivateLink. Create VPC endpoint services for each shared tool (monitoring, logging, CI/CD) behind NLBs. Spoke VPCs create interface endpoints to consume these services. No CIDR overlap issues with PrivateLink.
C) Keep VPC peering for non-overlapping VPCs. For overlapping CIDR VPCs, use PrivateLink to access shared services. Deploy Network Firewall in the shared services VPC for traffic inspection.
D) Migrate to AWS Cloud WAN with a shared services segment and spoke segments. Use Cloud WAN attachment policies for automatic VPC onboarding. Integrate Network Firewall for inspection between segments.

**Correct Answer: B**

**Explanation:** AWS PrivateLink is the optimal solution because it addresses all requirements: it reduces operational burden by eliminating VPC peering connections, it works regardless of overlapping CIDR ranges (PrivateLink uses private DNS resolution, not IP routing), and it provides a clean service-oriented access model. Each shared tool becomes a VPC endpoint service behind an NLB, and spoke VPCs create interface endpoints. This scales well beyond 50 accounts. Option A's Transit Gateway doesn't support overlapping CIDRs — attached VPCs must have non-overlapping CIDRs for routing to work. Option C is a hybrid approach that doesn't fully solve the problem. Option D is over-engineered for what is essentially a service access pattern.

---

### Question 4
A healthcare company runs an EKS cluster in a private subnet with no internet access. The cluster needs to pull container images from Amazon ECR, send logs to CloudWatch, and access Secrets Manager for application secrets. The security team mandates that no traffic from the EKS cluster should traverse the internet or a NAT Gateway. The cluster also needs to communicate with an on-premises PACS (medical imaging) system through an existing Direct Connect connection.

A) Create interface VPC endpoints for ECR API, ECR Docker, CloudWatch Logs, Secrets Manager, and STS. Create a gateway endpoint for S3 (ECR image layers are stored in S3). Configure EKS cluster endpoint to be private. Use Direct Connect for on-premises connectivity via the VPC.
B) Create a NAT Gateway in a public subnet for AWS service access. Use security groups to restrict outbound traffic to only AWS service IP ranges. Use Direct Connect for on-premises connectivity.
C) Deploy a proxy server (Squid) in the VPC that allows outbound connections only to AWS service endpoints. Route all EKS traffic through the proxy. Use Direct Connect for on-premises connectivity.
D) Use AWS PrivateLink for ECR and CloudWatch. Configure EKS pods with IAM Roles for Service Accounts (IRSA) to access Secrets Manager. The IRSA mechanism handles VPC endpoint-less access through the EKS control plane.

**Correct Answer: A**

**Explanation:** For a fully private EKS cluster with no internet access, VPC endpoints are required for all AWS service dependencies. ECR requires three endpoints: ECR API (com.amazonaws.region.ecr.api), ECR Docker (com.amazonaws.region.ecr.dkr), and S3 Gateway endpoint (ECR stores image layers in S3). CloudWatch Logs endpoint (com.amazonaws.region.logs) handles log delivery. Secrets Manager endpoint (com.amazonaws.region.secretsmanager) provides secret access. STS endpoint is needed for IAM role assumption by pods. Direct Connect provides on-premises connectivity through the VPC. Option B uses NAT Gateway which violates the no-internet requirement. Option C adds unnecessary complexity with a proxy server. Option D is incorrect — IRSA still requires VPC endpoints for the actual API calls to AWS services; IRSA only provides the credentials.

---

### Question 5
A multinational company wants to implement a centralized DNS resolution architecture across 100 AWS accounts and their on-premises data centers in 5 countries. Requirements include: on-premises servers must resolve AWS private hosted zone records, AWS resources must resolve on-premises DNS records, all DNS queries must be logged for security analysis, and the solution must handle 50,000 DNS queries per second across all locations.

A) Deploy Route 53 Resolver inbound endpoints in the central networking VPC for on-premises-to-AWS resolution. Deploy outbound endpoints for AWS-to-on-premises resolution. Share Resolver rules across accounts using AWS RAM. Enable Route 53 Resolver Query Logging and send logs to a centralized CloudWatch log group via cross-account log delivery.
B) Deploy BIND DNS servers on EC2 instances in each region as forwarders. Configure on-premises DNS servers to forward AWS queries to these BIND servers. Use Transit Gateway for DNS traffic routing between VPCs.
C) Use Route 53 Resolver DNS Firewall for all DNS resolution and logging. Share DNS Firewall rules across the organization. Configure bidirectional DNS resolution using DNS Firewall policies.
D) Create Route 53 private hosted zones associated with all VPCs across accounts. Configure on-premises DNS servers to forward to the Route 53 Resolver inbound endpoint IP addresses. Use VPC DNS query logging in each account.

**Correct Answer: A**

**Explanation:** Route 53 Resolver with inbound and outbound endpoints provides the managed hybrid DNS solution. Inbound endpoints allow on-premises DNS servers to forward queries for AWS domains to Route 53 for resolution against private hosted zones. Outbound endpoints forward queries from AWS to on-premises DNS servers for on-premises domain resolution. RAM sharing of Resolver rules ensures all 100 accounts use consistent forwarding rules. Resolver Query Logging captures all DNS queries for security analysis. Each endpoint supports thousands of queries per second, and multiple endpoints across regions handle the 50,000 QPS requirement. Option B's BIND servers add operational overhead. Option C's DNS Firewall is for filtering/blocking DNS queries, not for DNS resolution or forwarding. Option D doesn't address AWS-to-on-premises resolution or centralized logging.

---

### Question 6
A company operates an EKS cluster that runs 200 microservices. The platform team wants to implement fine-grained network policies that control which pods can communicate with each other based on namespace and label selectors. Additionally, they need to encrypt all pod-to-pod traffic within the cluster and log all denied connection attempts to a SIEM system. The cluster uses the Amazon VPC CNI plugin.

A) Install Calico CNI as a replacement for the VPC CNI. Use Calico NetworkPolicy resources for fine-grained pod-to-pod traffic control. Enable Calico's WireGuard encryption for pod-to-pod traffic. Export Calico flow logs to CloudWatch and then to the SIEM.
B) Use Amazon VPC CNI with the NetworkPolicy support enabled. Define Kubernetes NetworkPolicy resources for pod-to-pod traffic control. Use AWS App Mesh with mTLS for pod-to-pod encryption. Export VPC Flow Logs enriched with pod metadata for denied connection logging.
C) Install Calico as a network policy engine alongside the VPC CNI (not replacing it). Define Calico NetworkPolicy and GlobalNetworkPolicy resources for fine-grained control. Enable pod-to-pod encryption using the VPC CNI's network policy feature with encryption. Use Calico's flow log export to send denied connections to CloudWatch Logs, then forward to SIEM.
D) Use AWS Network Firewall deployed in the EKS VPC to inspect pod-to-pod traffic. Create stateful firewall rules based on pod IP ranges. Enable TLS inspection for encryption validation. Export firewall logs to the SIEM.

**Correct Answer: C**

**Explanation:** Amazon VPC CNI now supports native NetworkPolicy enforcement, but Calico alongside VPC CNI provides richer policy capabilities including GlobalNetworkPolicy (cluster-wide rules), DNS-based policies, and more granular logging of denied connections. The VPC CNI remains the primary CNI (preserving native VPC networking), while Calico runs as a policy engine. Pod-to-pod encryption is supported through the VPC CNI's built-in encryption capability. Calico's flow log export captures denied connections with rich metadata (source/destination pod, namespace, policy that denied) for SIEM integration. Option A replaces VPC CNI entirely, losing native VPC networking features. Option B's VPC Flow Logs don't natively include pod-level metadata for denied connections at the NetworkPolicy level. Option D's Network Firewall operates at the VPC level, not the pod level — it cannot inspect intra-node pod traffic.

---

### Question 7
A company uses Transit Gateway to connect 100 VPCs across two regions. They need to implement a centralized egress architecture where all internet-bound traffic from spoke VPCs routes through a dedicated egress VPC containing NAT Gateways and AWS Network Firewall for inspection. The architecture must be highly available across three AZs, and the egress VPC must handle 40 Gbps aggregate outbound traffic. The company also wants to block access to specific domains and detect malware in outbound HTTP/HTTPS traffic.

A) Deploy an egress VPC with three NAT Gateways (one per AZ) and Network Firewall with three endpoints (one per AZ). Configure Transit Gateway routing to send 0.0.0.0/0 traffic from spoke VPCs to the Network Firewall endpoints. Network Firewall routes inspected traffic to NAT Gateways. Use Suricata-compatible IPS rules for malware detection and domain filtering rules for domain blocking.
B) Deploy a shared NAT Gateway in one AZ of the egress VPC (single NAT Gateway supports up to 100 Gbps). Deploy Network Firewall in all three AZs. Use Transit Gateway route tables with a default route to the Network Firewall.
C) Deploy three NAT Gateways and three Network Firewall endpoints. Use Gateway Load Balancer to distribute traffic across Network Firewall endpoints. Route spoke VPC traffic through the GWLB endpoint for transparent inspection before NAT.
D) Deploy NAT Gateways in the egress VPC. Use AWS WAF on an ALB in the egress VPC for domain filtering and malware detection instead of Network Firewall. Route spoke VPC traffic through Transit Gateway to the ALB.

**Correct Answer: A**

**Explanation:** The centralized egress architecture with Network Firewall follows this traffic flow: spoke VPC → Transit Gateway → Network Firewall endpoint (in the egress VPC) → NAT Gateway → Internet. Three AZs ensure high availability for both Network Firewall and NAT Gateways. At 40 Gbps aggregate, distributing across three AZs keeps each AZ well within limits. Network Firewall supports Suricata-compatible IPS rules for deep packet inspection and malware detection, plus domain list rules for HTTP/HTTPS domain filtering (SNI-based for HTTPS). Option B's single NAT Gateway is a single point of failure. Option C's GWLB is unnecessary — Network Firewall endpoints already handle AZ-level distribution via Transit Gateway routing. Option D's WAF+ALB doesn't support VPC-level transparent traffic inspection.

---

### Question 8
A company runs a multi-tenant SaaS platform on EKS with 50 tenant namespaces. Each tenant's workload must be isolated at the network level (no cross-tenant communication), have dedicated compute resources (no noisy neighbor), use tenant-specific encryption keys for secrets, and be able to scale independently. The platform team needs to balance isolation with operational efficiency of managing a single cluster.

A) Use separate EKS node groups per tenant with taints and tolerations for compute isolation. Implement Kubernetes NetworkPolicy to deny all inter-namespace traffic. Use AWS KMS with separate keys per tenant integrated via the EKS Secrets Store CSI Driver. Set ResourceQuotas per namespace for independent scaling.
B) Deploy separate EKS clusters per tenant for maximum isolation. Use AWS Organizations with separate accounts per tenant. Manage clusters centrally using EKS Connector and ArgoCD.
C) Use EKS Pod Security Standards to isolate tenants. Deploy all tenants on shared node groups with pod anti-affinity rules. Use Kubernetes secrets with namespace-scoped RBAC for encryption key isolation.
D) Use EKS Fargate profiles per tenant namespace for compute isolation (each pod runs in its own microVM). Implement NetworkPolicy with the VPC CNI policy engine to deny inter-namespace traffic. Integrate AWS Secrets Manager with the Secrets Store CSI Driver using tenant-specific secrets and KMS keys. Use Karpenter for node provisioning when Fargate limits are reached.

**Correct Answer: D**

**Explanation:** EKS Fargate provides the strongest compute isolation within a single cluster — each pod runs in a dedicated microVM, eliminating noisy neighbor issues without managing separate node groups. Fargate profiles scoped to tenant namespaces ensure automatic placement. VPC CNI NetworkPolicy enforcement blocks cross-namespace traffic. The Secrets Store CSI Driver with AWS Secrets Manager allows tenant-specific KMS keys for secret encryption. Karpenter provides efficient node provisioning for workloads that exceed Fargate limits. This approach maintains single-cluster operational efficiency while providing strong isolation. Option A's dedicated node groups work but require managing node group scaling per tenant — more operationally complex. Option B's separate clusters per tenant is maximum isolation but operationally expensive at 50 tenants. Option C's anti-affinity doesn't guarantee compute isolation.

---

### Question 9
A retail company uses AWS Network Firewall to inspect all east-west traffic between VPCs connected via Transit Gateway. The company notices that Network Firewall is adding 2-3ms of latency to every inter-VPC request. For latency-sensitive applications (payment processing, real-time inventory), this additional latency is unacceptable. However, the security team requires that traffic from development and staging VPCs always be inspected. The company needs to selectively bypass inspection for specific traffic flows.

A) Create multiple Transit Gateway route tables: one for production VPCs (direct routing, bypassing inspection) and one for dev/staging VPCs (routing through Network Firewall). Production VPCs use the direct route table, while dev/staging VPCs use the inspection route table.
B) Increase Network Firewall capacity by adding more firewall endpoints to reduce per-endpoint load and latency. Use Network Firewall's stream exception policy to pass through traffic for known-good flows.
C) Replace Network Firewall with security groups and NACLs for production VPCs. Keep Network Firewall for dev/staging. Use Transit Gateway route tables to control which VPCs route through the firewall.
D) Use Network Firewall with stateless rules that pass through production VPC traffic without deep inspection (low latency) while applying stateful inspection only to dev/staging traffic. Create rule groups that match on source/destination CIDR ranges.

**Correct Answer: A**

**Explanation:** Transit Gateway route tables provide the cleanest way to selectively route traffic through or around Network Firewall. By creating separate route tables — one that routes through the inspection VPC (for dev/staging) and one with direct VPC-to-VPC routes (for production) — you selectively enforce inspection based on the source VPC's route table association. Production VPCs get zero additional latency since traffic bypasses the firewall entirely. This is a standard hub-and-spoke pattern where not all spokes require the same level of inspection. Option B doesn't eliminate the latency for production. Option C uses NACLs which are stateless and limited to IP/port rules, not equivalent to Network Firewall's capabilities. Option D's stateless pass-through still adds some latency from firewall endpoint traversal.

---

### Question 10
A company is deploying a machine learning inference workload on EKS using GPU-accelerated pods. The workload requires NVIDIA A100 GPUs for high-performance inference. Requirements include: automatic scaling based on GPU utilization and inference queue depth, cost optimization through Spot GPU instances, graceful handling of Spot interruptions (drain inference requests before termination), and efficient GPU utilization (multiple models on a single GPU using MIG).

A) Use Karpenter for node provisioning with GPU instance types (p4d.24xlarge). Configure Karpenter provisioners with Spot capacity type and instance diversification. Use the NVIDIA GPU Operator for GPU management and MIG configuration. Deploy KEDA for custom metric-based pod autoscaling (inference queue depth from SQS). Implement the AWS Node Termination Handler for graceful Spot interruption handling.
B) Use EKS managed node groups with p4d.24xlarge Spot instances. Configure Cluster Autoscaler for node scaling. Use the NVIDIA device plugin for GPU scheduling. Deploy Horizontal Pod Autoscaler with custom CloudWatch metrics for scaling.
C) Deploy inference workloads on SageMaker endpoints with auto-scaling instead of EKS. SageMaker handles GPU management, scaling, and Spot interruption natively. Use multi-model endpoints for GPU sharing.
D) Use EKS with AWS Inferentia instances (inf1/inf2) instead of NVIDIA GPUs for cost-optimized inference. Deploy the AWS Neuron SDK and device plugin. Use Karpenter for auto-scaling.

**Correct Answer: A**

**Explanation:** This architecture addresses all requirements comprehensively. Karpenter provides fast, efficient node provisioning with GPU awareness and Spot instance support across diversified instance types. The NVIDIA GPU Operator manages the full GPU software stack including MIG (Multi-Instance GPU) partitioning on A100s, allowing multiple models to share a single GPU. KEDA (Kubernetes Event Driven Autoscaling) scales pods based on external metrics like SQS queue depth, ideal for inference request queues. AWS Node Termination Handler detects Spot interruption notices (2-minute warning) and gracefully drains pods. Option B's Cluster Autoscaler is slower than Karpenter for GPU node provisioning. Option C moves off EKS which doesn't meet the stated EKS requirement. Option D changes the hardware platform which may not support all model architectures.

---

### Question 11
A large enterprise has acquired three companies, each with their own AWS environment. The parent company needs to unify networking across all four AWS Organizations (total of 400 accounts) while maintaining administrative separation. Requirements include: shared connectivity between organizations, centralized network security monitoring, ability to enforce network policies across all organizations, and private connectivity to on-premises data centers through a single Direct Connect connection.

A) Consolidate all accounts under a single AWS Organization. Use Transit Gateway for VPC connectivity. Deploy Network Firewall for centralized security.
B) Keep separate Organizations but establish Transit Gateway peering between each Organization's Transit Gateway. Share the Direct Connect gateway across Organizations using RAM. Deploy Network Firewall in each Organization's central networking account. Use AWS CloudTrail organization trails for centralized monitoring.
C) Use AWS Cloud WAN with a global network spanning all Organizations. Each Organization connects its VPCs via Cloud WAN attachments. Define network segments for isolation between organizations. Integrate Network Firewall for cross-organization traffic inspection. Connect the Direct Connect gateway to Cloud WAN for shared on-premises connectivity.
D) Create a dedicated shared networking account accessible to all Organizations. Deploy a Transit Gateway in this account. Each Organization's networking account establishes a peering connection to this central Transit Gateway.

**Correct Answer: C**

**Explanation:** AWS Cloud WAN provides a unified global network that can span multiple Organizations, making it ideal for post-acquisition unification. Segments provide isolation between each acquired company while enabling controlled connectivity. Cloud WAN's policy-based routing allows centralized enforcement of network policies across all Organizations. The integration with Network Firewall enables inspection of cross-organization traffic. Direct Connect connectivity through Cloud WAN serves all Organizations through a single connection. Option A requires consolidating Organizations, which may not be feasible due to administrative, compliance, or contractual requirements. Option B's Transit Gateway peering works but doesn't provide unified management or cross-organization policy enforcement. Option D doesn't exist as a native feature — Transit Gateway can't easily be shared across separate Organizations.

---

### Question 12
A company wants to expose a set of REST APIs running on ECS Fargate to specific partner companies without exposing them to the public internet. Each partner has their own AWS account. The APIs must be individually accessible (partners should only access authorized APIs), and the company needs to track usage per partner for billing purposes. Network traffic must remain entirely within the AWS network.

A) Create a Network Load Balancer for each API service. Create VPC Endpoint Services for each NLB. Partners create interface VPC endpoints. Use VPC endpoint policies to restrict which APIs each partner can access. Use VPC Flow Logs for usage tracking.
B) Deploy API Gateway with VPC Link to ECS Fargate. Create a single VPC Endpoint Service backed by the NLB that API Gateway VPC Link uses. Partners create interface endpoints to API Gateway. Use API keys and usage plans for per-partner access control and billing tracking.
C) Create a single NLB fronting all ECS services. Create a VPC Endpoint Service. Allow all partner accounts. Use NLB listener rules to route requests to different target groups based on host headers. Track usage via access logs.
D) Use AWS PrivateLink with API Gateway private endpoints. Each partner creates a private API Gateway endpoint in their VPC. Use resource policies on API Gateway to restrict access per partner. Use API Gateway usage plans with API keys for tracking.

**Correct Answer: D**

**Explanation:** API Gateway private endpoints exposed via PrivateLink provide the ideal combination of fine-grained access control, per-partner usage tracking, and private connectivity. Partners create interface VPC endpoints for the execute-api service to reach the private API Gateway. Resource policies control which VPC endpoints (and thus which partners) can access specific APIs. Usage plans with API keys enable per-partner rate limiting and usage tracking for billing. All traffic stays within the AWS network via PrivateLink. Option A requires separate endpoint services per API, increasing management overhead. Option B's architecture is valid but more complex than needed. Option C's single NLB with host headers doesn't provide granular per-partner access control or usage tracking natively.

---

### Question 13
A company has deployed Amazon SageMaker training jobs in a private VPC with no internet access. The training jobs need to access training data in S3, log metrics to CloudWatch, and download model artifacts from a private model registry also in S3. The data science team reports that training jobs fail with timeout errors when trying to access these AWS services. The VPC has been configured with VPC endpoints for S3 and CloudWatch, but the issue persists.

A) The S3 gateway endpoint is insufficient for SageMaker — create an interface endpoint for S3 (com.amazonaws.region.s3) in addition to the gateway endpoint. SageMaker training containers require the interface endpoint for S3 API calls.
B) Add VPC endpoints for the SageMaker API (com.amazonaws.region.sagemaker.api) and SageMaker Runtime (com.amazonaws.region.sagemaker.runtime). SageMaker training jobs need these endpoints to communicate with the SageMaker control plane.
C) SageMaker training in a VPC requires endpoints for: S3 (gateway), CloudWatch (interface), SageMaker API (interface), STS (interface for IAM role credential retrieval), ECR API and ECR Docker (interface, for pulling the training container image), and KMS (if using encrypted data). The missing STS and ECR endpoints are likely causing the failures.
D) Remove the VPC configuration from SageMaker training jobs. Instead, use SageMaker's built-in security features (encryption, IAM) without VPC isolation. SageMaker manages network security internally.

**Correct Answer: C**

**Explanation:** SageMaker training jobs in a VPC require a comprehensive set of VPC endpoints. The most commonly missed endpoints are: STS (needed for the training instance to assume the SageMaker execution role), ECR API and ECR Docker (needed to pull the training container image), and KMS (needed if data or volumes are encrypted). Without the STS endpoint, the training job cannot obtain IAM credentials. Without ECR endpoints, the container image cannot be pulled. The S3 gateway endpoint and CloudWatch endpoint are necessary but not sufficient. Option A's interface endpoint for S3 is not the root cause. Option B's SageMaker API/Runtime endpoints are for API calls from outside the VPC, not for training job internal communication. Option D removes security isolation, which doesn't solve the problem.

---

### Question 14
A company runs a production EKS cluster with 500 pods across 50 nodes. The cluster uses the Amazon VPC CNI plugin, and the team is running out of available IP addresses in the pod subnets (three /24 subnets, ~750 IPs total minus reserved addresses). The application deployment is blocked because new pods can't get IP addresses. The team cannot change the VPC CIDR or add new subnets immediately.

A) Enable prefix delegation on the VPC CNI plugin. This assigns /28 prefixes to ENIs instead of individual IPs, increasing the number of available IPs per node from tens to hundreds. Restart the DaemonSet to apply the change.
B) Switch from the VPC CNI to Calico CNI with overlay networking (VXLAN or IP-in-IP). This uses a separate IP space for pods independent of VPC IPs, eliminating the IP exhaustion issue.
C) Migrate to EKS Fargate, which manages pod networking independently and doesn't consume IPs from the pod subnets.
D) Enable custom networking on the VPC CNI to use a secondary CIDR range (100.64.0.0/16) for pod IP addresses. Add the secondary CIDR to the VPC and create new subnets.

**Correct Answer: A**

**Explanation:** VPC CNI prefix delegation is the fastest solution that doesn't require VPC or subnet changes. By enabling ENABLE_PREFIX_DELEGATION, the CNI assigns /28 prefixes (16 IPs each) to ENI slots instead of individual IPs. On an m5.large (which has 3 ENIs × 10 slots = 30 slots), this increases from 30 IPs to 30 × 16 = 480 IPs per node. Applied across 50 nodes, this provides far more than enough IPs using the existing subnets. The change requires updating the aws-node DaemonSet configuration and cycling nodes. Option B's CNI replacement is a major change with risk to a production cluster. Option C's Fargate migration is a significant architectural change. Option D requires adding a secondary CIDR and new subnets, which the question states cannot be done immediately.

---

### Question 15
A global media company operates EKS clusters in three regions. They need a service mesh to manage traffic between services across regions, implement canary deployments for cross-region services, enforce mTLS for all inter-service communication, and provide observability (distributed tracing, metrics, access logs) across the mesh. The solution should minimize operational overhead.

A) Deploy Istio as the service mesh across all three EKS clusters. Use Istio's multi-cluster mesh configuration with a shared control plane. Configure Istio for mTLS, traffic management (VirtualService for canary routing), and Envoy proxy for observability. Export telemetry to AWS X-Ray and CloudWatch.
B) Use AWS App Mesh spanning all three regions. Configure virtual services, virtual routers, and routes for traffic management. Enable mTLS with ACM certificates. Use Envoy proxies as sidecars managed by App Mesh. Integrate with CloudWatch and X-Ray for observability.
C) Deploy Linkerd as a lightweight service mesh. Use Linkerd's multi-cluster extension for cross-region communication. Enable Linkerd's automatic mTLS. Use Linkerd's built-in metrics with Prometheus and Grafana.
D) Use Amazon VPC Lattice for cross-region service-to-service communication. VPC Lattice provides built-in traffic management, authentication via IAM, and integration with CloudWatch for observability. No sidecar proxies needed.

**Correct Answer: B**

**Explanation:** AWS App Mesh is the AWS-native service mesh that integrates tightly with EKS and other AWS services. It supports multi-region mesh configurations, canary deployments through weighted routing in virtual router configurations, mTLS with certificates from ACM (managed certificate rotation), and deep integration with CloudWatch and X-Ray for observability. Being AWS-managed, it minimizes operational overhead compared to self-managed solutions. Option A's Istio is powerful but has significant operational complexity for a self-managed control plane. Option C's Linkerd is lightweight but has limited multi-cluster support compared to App Mesh. Option D's VPC Lattice is promising but uses IAM-based auth rather than mTLS and has more limited traffic management capabilities compared to a full service mesh.

---

### Question 16
A company wants to use Amazon Bedrock to build a customer service chatbot that can access company-specific product documentation and customer history. The chatbot must provide accurate answers based on the company's knowledge base (500,000 documents), handle multi-turn conversations with context retention, comply with PII data handling regulations by not including customer PII in prompts sent to the foundation model, and operate within a private VPC with no internet access.

A) Use Bedrock Knowledge Bases with an OpenSearch Serverless vector store for RAG (Retrieval Augmented Generation). Implement Amazon Bedrock Guardrails for PII redaction in prompts. Use Bedrock Agents for multi-turn conversation management. Deploy via VPC endpoint for private access.
B) Fine-tune a Bedrock foundation model with the company's product documentation. Use DynamoDB for conversation history. Implement custom Lambda functions for PII detection using Amazon Comprehend. Access Bedrock through API Gateway.
C) Use SageMaker to host a custom LLM fine-tuned on company data. Deploy in a private VPC with no Bedrock dependency. Use Amazon Kendra for document search and retrieval.
D) Use Bedrock with direct prompt engineering, including relevant documentation in each prompt. Store conversation history in ElastiCache. Use custom middleware for PII redaction before sending prompts to Bedrock.

**Correct Answer: A**

**Explanation:** Bedrock Knowledge Bases with RAG provides the optimal architecture. The 500,000 documents are embedded and stored in OpenSearch Serverless, enabling semantic search to retrieve relevant context for each query without fine-tuning. Bedrock Guardrails natively provide PII detection and redaction, ensuring customer PII is automatically removed from prompts. Bedrock Agents handle multi-turn conversations with built-in session management and context retention. VPC endpoints for Bedrock (com.amazonaws.region.bedrock and com.amazonaws.region.bedrock-runtime) provide private access. Option B's fine-tuning is expensive and not ideal for frequently changing documentation. Option C requires managing ML infrastructure. Option D's approach of including documentation in each prompt is limited by context window size and doesn't scale to 500,000 documents.

---

### Question 17
A biotech company uses SageMaker for drug discovery ML workflows. They need to share trained models across 10 research teams in different AWS accounts while maintaining model governance: tracking which team uses which model version, ensuring only approved models are deployed to production endpoints, maintaining an immutable audit trail of model lineage, and preventing teams from deploying models that haven't passed quality gates.

A) Use SageMaker Model Registry in a central account. Register all models with approval status (PendingApproval, Approved, Rejected). Share the registry across accounts using cross-account IAM roles. Implement a SageMaker Pipeline that includes quality gate steps and automatically transitions model approval status. Use EventBridge to notify teams of approval status changes.
B) Store models in a shared S3 bucket with versioning. Use S3 Object Lock for immutability. Implement a custom approval workflow using Step Functions. Share bucket access using bucket policies.
C) Create a SageMaker Model Registry in each team's account. Use a central Lambda function to synchronize registries across accounts. Implement approval workflows in each account.
D) Use AWS Service Catalog to create model deployment products. Only approved models are published as Service Catalog products. Teams deploy models by launching Service Catalog products.

**Correct Answer: A**

**Explanation:** SageMaker Model Registry is purpose-built for ML model governance. It provides: model versioning and lineage tracking, approval status workflow (PendingApproval → Approved/Rejected), model group organization, and metadata tracking. Cross-account sharing via IAM roles allows all 10 teams to access the central registry. SageMaker Pipelines automate the quality gate process — steps can evaluate model metrics and automatically set approval status. EventBridge integration provides real-time notifications. The approval status mechanism prevents teams from deploying unapproved models by configuring deployment pipelines to only accept Approved models. Option B lacks the model-specific governance features of Model Registry. Option C's distributed registries create synchronization challenges. Option D's Service Catalog is designed for infrastructure provisioning, not model governance.

---

### Question 18
A company has deployed SageMaker real-time inference endpoints across three regions for low-latency serving. They need to implement a deployment strategy that: rolls out new model versions to one region at a time, validates model accuracy on live traffic before proceeding to the next region, automatically rolls back if the new model's error rate exceeds 2%, and maintains at least two healthy regions at all times during deployment.

A) Use SageMaker deployment guardrails with canary traffic shifting on each endpoint. Deploy to region 1 first, shift 10% of traffic to the new model variant, monitor CloudWatch metrics for error rate, and promote to 100% or rollback. Repeat for regions 2 and 3. Orchestrate with Step Functions.
B) Use CodeDeploy with SageMaker endpoint deployment configurations. Implement a linear traffic shifting policy. Use CloudWatch alarms as deployment validation. Chain regional deployments sequentially using CodePipeline.
C) Implement blue-green deployments per region using SageMaker endpoint production variants. Direct 100% traffic to the new variant in region 1, validate for 1 hour, then proceed to region 2. Use Route 53 health checks to detect failures and route away from unhealthy regions.
D) Use SageMaker Inference Components with multiple model versions loaded on the same endpoint. Gradually shift invocations from the old model to the new model using inference component weights. Monitor per-component metrics.

**Correct Answer: A**

**Explanation:** SageMaker deployment guardrails provide native canary and linear traffic shifting for inference endpoints. By deploying to one region at a time with canary traffic (10% to new model), you validate on live traffic while limiting blast radius. CloudWatch alarms monitoring the error rate trigger automatic rollback if the 2% threshold is exceeded. Step Functions orchestrates the sequential regional deployment — it waits for region 1 validation to complete before proceeding to region 2, ensuring at least two regions remain on the stable version during any deployment phase. Option B's CodeDeploy doesn't natively integrate with SageMaker endpoint traffic shifting. Option C's 100% traffic shift to the new variant is risky — no canary validation. Option D's inference components are for multi-model hosting efficiency, not deployment strategy.

---

### Question 19
A company is building a generative AI application using Amazon Bedrock that generates marketing content. The application must: prevent the model from generating content that mentions competitor products, ensure generated content maintains brand-consistent tone, limit output length to 500 words, and log all prompts and responses for compliance review. The team wants to implement these controls without modifying application code for each policy change.

A) Implement Amazon Bedrock Guardrails with: a denied topic filter for competitor mentions, a word filter for competitor brand names, content filters for maintaining appropriate tone, and model invocation logging enabled. Attach guardrails to the Bedrock API invocations. Update guardrails configuration independently of application code.
B) Implement a Lambda middleware layer between the application and Bedrock. The Lambda function pre-processes prompts (adding instructions to avoid competitors), post-processes responses (filtering competitor mentions, enforcing word limits), and logs everything to CloudWatch. Update Lambda code for policy changes.
C) Use Bedrock's system prompt to instruct the model to avoid competitor mentions and maintain brand tone. Implement client-side response parsing for length limits. Use CloudTrail for logging model invocations.
D) Fine-tune a custom model on brand-approved content to inherently produce brand-consistent output. Use Bedrock's max_tokens parameter for length control. Implement response caching in ElastiCache to serve pre-approved responses.

**Correct Answer: A**

**Explanation:** Amazon Bedrock Guardrails provide declarative policy enforcement that's independent of application code. Denied topics and word filters catch competitor mentions in both prompts and responses. Content filters ensure appropriate tone. Guardrails are configured as a separate resource and attached at invocation time — policy changes don't require code deployment. Model invocation logging captures all prompts and responses to S3 or CloudWatch for compliance. The 500-word limit can be enforced via max_tokens in the API call. Option B's Lambda middleware requires code changes for each policy update, which the requirement explicitly wants to avoid. Option C's system prompts are suggestive, not enforceable — the model may still mention competitors. Option D's fine-tuning is expensive, inflexible, and doesn't guarantee competitor exclusion.

---

### Question 20
A company operates a Transit Gateway with 150 VPC attachments across 3 route tables (production, development, shared services). The networking team needs to implement traffic mirroring for security analysis — capturing all traffic between production VPCs and shared services VPCs without impacting application performance. The mirrored traffic must be analyzed in real-time by a third-party IDS running on EC2 instances in a security VPC. The solution must handle 20 Gbps of mirrored traffic.

A) Enable VPC Traffic Mirroring on the ENIs of EC2 instances in production VPCs. Configure mirror targets as NLB in the security VPC with the IDS instances as targets. Use mirror filters to capture only production-to-shared-services traffic. The NLB distributes mirrored traffic across IDS instances.
B) Use Transit Gateway Flow Logs to capture traffic metadata between production and shared services route tables. Analyze flow logs in real-time using Kinesis Data Streams and Lambda. Forward suspicious flows to the IDS for deep packet inspection.
C) Deploy AWS Network Firewall in alert mode between production and shared services VPCs. Network Firewall logs alert events and forwards full packet captures to S3. The IDS analyzes captured packets from S3.
D) Use VPC Flow Logs with enhanced metadata on all production VPCs. Stream flow logs to Kinesis Data Analytics for real-time analysis. Use custom ML models to detect anomalies.

**Correct Answer: A**

**Explanation:** VPC Traffic Mirroring captures actual packet data (not just metadata like Flow Logs) from ENIs, providing the full packet content needed for IDS analysis. Mirror targets can be an NLB, which distributes the 20 Gbps of mirrored traffic across multiple IDS instances for both load distribution and high availability. Mirror filters configure which traffic to capture (e.g., production CIDR to shared services CIDR), avoiding unnecessary mirroring of unrelated traffic. Traffic Mirroring operates at the hypervisor level with minimal performance impact on the source instances. Option B's Flow Logs only capture metadata (source/dest IP, ports, bytes, action), not packet content. Option C's Network Firewall in alert mode can log alerts but doesn't provide full packet mirroring to external systems. Option D's Flow Logs lack packet content for IDS analysis.

---

## Domain 2: Design for New Solutions (Questions 21–42)

### Question 21
A financial services company is designing a high-frequency trading data distribution system. Market data updates (stock prices) are generated 100,000 times per second and must be delivered to 500 subscriber applications across 10 VPCs within 1 millisecond. Each subscriber needs to receive all updates in order. The current on-premises system uses UDP multicast, which is not natively available in AWS VPCs.

A) Use Amazon Kinesis Data Streams with enhanced fan-out. Each subscriber application is a consumer with dedicated throughput. Partition data by stock symbol for ordering. Enhanced fan-out provides push-based delivery at 2 MB/s per consumer per shard.
B) Use Amazon ElastiCache for Redis with pub/sub. Publishers push updates to Redis channels organized by stock symbol. Subscribers listen on relevant channels. Redis pub/sub delivers messages with sub-millisecond latency within a single cluster.
C) Use Transit Gateway multicast to replicate the on-premises UDP multicast pattern. Register subscriber ENIs as multicast group members. Organize multicast groups by data feed category. Transit Gateway handles multicast replication across VPCs.
D) Use Amazon MQ (ActiveMQ) with multicast network of brokers across VPCs. Configure topic-based publishing for market data. Subscribe all applications to relevant topics.

**Correct Answer: C**

**Explanation:** Transit Gateway multicast directly addresses the UDP multicast requirement in AWS. Since the current system uses UDP multicast and the requirement is sub-millisecond latency with 500 subscribers, Transit Gateway multicast replicates this pattern natively. Multicast groups organized by data feed category allow efficient content-based subscription. Transit Gateway handles cross-VPC multicast delivery. The 1ms latency requirement eliminates most queue-based solutions. Option A's Kinesis has higher latency (typical 200ms get latency, 70ms with enhanced fan-out) exceeding the 1ms requirement. Option B's Redis pub/sub is fast but doesn't natively span 10 VPCs and would require complex proxy architectures. Option D's ActiveMQ introduces broker overhead exceeding 1ms latency.

---

### Question 22
A company is building a SageMaker ML pipeline for training computer vision models on medical imaging data. The training data is 50 TB of DICOM images stored in S3. Training jobs use 8 p4d.24xlarge instances (8 GPUs each, 64 GPUs total) for distributed training. The data science team reports that 60% of training time is spent loading data from S3, with the actual GPU computation taking only 40%. The team needs to reduce total training time by at least 50%.

A) Use SageMaker Pipe Mode to stream data directly from S3 to the training algorithm. Pipe Mode reads data sequentially from S3 and feeds it directly to the training container, eliminating the need to download the full dataset before training begins.
B) Create an Amazon FSx for Lustre file system linked to the S3 bucket. Use FSx for Lustre as the training input data source in SageMaker. FSx for Lustre provides high-throughput parallel file access (hundreds of GB/s), dramatically reducing data load time. Use lazy loading to only fetch data as needed during training.
C) Pre-process and convert DICOM images to TFRecord format (optimized for sequential reads). Store the converted dataset in S3. Use SageMaker's built-in data parallelism with Fast File Mode. Enable S3 Transfer Acceleration for faster downloads.
D) Deploy an EBS volume (io2 Block Express, 100,000 IOPS) per training instance. Pre-populate the volumes with the training data before launching training jobs. Use EBS snapshots to quickly provision pre-populated volumes.

**Correct Answer: B**

**Explanation:** FSx for Lustre is designed for high-performance computing workloads including ML training. When linked to an S3 bucket, it provides a POSIX-compatible file system with aggregate throughput of hundreds of GB/s and sub-millisecond latency. The 64 GPUs across 8 instances can read data in parallel at wire speed. Lazy loading fetches data from S3 transparently on first access, with subsequent reads served from the Lustre file system's cache. This eliminates the S3 data loading bottleneck, reducing the 60% data loading time to minutes. Option A's Pipe Mode provides sequential streaming which doesn't support random access patterns needed for shuffled training data. Option C improves format efficiency but doesn't address the fundamental S3 throughput limitation. Option D requires pre-population of 50 TB × 8 instances = 400 TB of EBS storage, which is impractical and expensive.

---

### Question 23
A company wants to deploy a real-time fraud detection system using Amazon SageMaker. The system must: process 50,000 transactions per second, return predictions within 5 milliseconds, use a model ensemble (3 models must agree for a fraud prediction), update models weekly without downtime, and handle 3x traffic spikes during holiday seasons.

A) Deploy three SageMaker real-time endpoints (one per model) behind an Application Load Balancer. Use a Lambda function to aggregate predictions from all three endpoints. Configure auto-scaling on each endpoint based on invocations per instance.
B) Use SageMaker Multi-Model Endpoints to host all three models on a single endpoint. Implement the ensemble logic within the inference container. Configure endpoint auto-scaling based on InvocationsPerInstance metric with target tracking.
C) Deploy a SageMaker Inference Pipeline that chains the three models sequentially. The pipeline returns the consensus prediction. Use auto-scaling with custom CloudWatch metrics for queue depth.
D) Use a single SageMaker endpoint with a custom inference container that loads all three models and implements the ensemble logic internally. Deploy with multiple production variants for A/B testing during weekly updates. Use auto-scaling with target tracking on InvocationsPerInstance.

**Correct Answer: D**

**Explanation:** A custom inference container hosting all three models eliminates inter-service latency that would make the 5ms SLA impossible with separate endpoints. Network round trips between services would add 1-3ms each, exhausting the 5ms budget. The custom container loads all three models in memory, runs them in parallel within the container, and implements the consensus logic (all 3 must agree) — all within a single invocation. Production variants enable zero-downtime model updates: deploy the new model ensemble as a new variant, shift traffic gradually, and remove the old variant. Auto-scaling handles 3x spikes. Option A's separate endpoints add network latency exceeding 5ms. Option B's Multi-Model Endpoints have model loading latency when switching between models. Option C's sequential pipeline multiplies latency (5ms × 3 = 15ms minimum).

---

### Question 24
A logistics company is designing a network architecture for a new AWS deployment spanning three regions. The requirements include: full mesh connectivity between all VPCs across regions, centralized internet egress through a single region for cost optimization and security compliance, on-premises connectivity through a single Direct Connect location with failover to VPN, and the ability to segment traffic between production and non-production workloads with different routing policies.

A) Deploy Transit Gateways in each region with inter-region peering. Use Transit Gateway route tables for production/non-production segmentation. Configure a centralized egress VPC with NAT Gateways and Network Firewall in the primary region. Connect Direct Connect gateway to the primary Transit Gateway with VPN as backup.
B) Use AWS Cloud WAN with a global network. Define production and non-production segments with different routing policies. Configure a centralized egress policy that routes all internet traffic through the primary region's service insertion VPC (with NAT Gateway and Network Firewall). Attach the Direct Connect gateway to Cloud WAN with VPN failover.
C) Deploy a VPN mesh between all VPCs using software VPN instances. Use BGP for dynamic routing. Centralize egress through a shared VPC with Squid proxy. Connect to on-premises via the existing Direct Connect.
D) Use VPC Peering for intra-region connectivity and Transit Gateway peering for inter-region. Deploy NAT Gateways in each VPC for distributed egress. Connect Direct Connect to one VPC and use it as a transit VPC.

**Correct Answer: B**

**Explanation:** AWS Cloud WAN provides a unified management plane for complex multi-region network architectures. Segments natively separate production and non-production traffic with different routing policies (e.g., production has direct routing, non-production routes through inspection). Service insertion VPCs enable centralized egress through one region with Network Firewall and NAT Gateways. Cloud WAN supports Direct Connect gateway attachment and VPN failover natively. The centralized policy-based management simplifies operations compared to managing individual Transit Gateways and their route tables. Option A works but requires manual management of Transit Gateway route tables across three regions and complex asymmetric routing for centralized egress. Option C's software VPN mesh is operationally complex and doesn't scale. Option D's VPC peering doesn't support transitive routing needed for centralized egress.

---

### Question 25
A company is designing a private API marketplace where internal teams can discover, subscribe to, and consume APIs built by other teams. Each API team manages their own AWS account. The marketplace must: provide a self-service portal for API discovery, enforce authentication and rate limiting per consumer, keep all traffic private (no internet exposure), provide usage analytics per consumer and per API, and support automatic API documentation.

A) Use Amazon API Gateway with private REST APIs in each API team's account. Deploy a custom portal on ECS with a DynamoDB backend for API catalog. Use API keys and usage plans for rate limiting. Connect consumer VPCs to API VPCs via PrivateLink interface endpoints.
B) Deploy a shared API Gateway account with HTTP APIs. API teams deploy their backends in their own accounts. Use VPC Links for private connectivity. Implement Amazon Cognito for authentication. Use CloudWatch for usage analytics.
C) Use Amazon API Gateway private REST APIs in each API team's account exposed via PrivateLink. Deploy a central Developer Portal using API Gateway's built-in developer portal feature (or Backstage on ECS). Use API keys and usage plans for per-consumer rate limiting and analytics. Automate documentation from OpenAPI specs stored in S3.
D) Deploy Amazon VPC Lattice services for each API. Use VPC Lattice service network for cross-account API sharing. VPC Lattice provides built-in authentication (IAM), rate limiting, and observability. Build a catalog UI on top of VPC Lattice service directory.

**Correct Answer: D**

**Explanation:** Amazon VPC Lattice is designed for cross-account service-to-service communication. Service networks provide the organizational layer for API sharing across accounts. VPC Lattice natively provides: private connectivity (no internet exposure) through service network VPC associations, IAM-based authentication for per-consumer access control, built-in observability with access logs and CloudWatch metrics for usage analytics, and a service directory that serves as the foundation for API discovery. The simplicity of VPC Lattice (no NLBs, no endpoint services, no API Gateway configuration) reduces operational overhead significantly. Option A requires managing PrivateLink endpoint services per API. Option B's shared account creates a bottleneck. Option C works but has more moving parts than VPC Lattice for this use case.

---

### Question 26
A research institution needs to design a system for running large-scale genomic analysis using Amazon SageMaker. The workflow involves: ingesting raw genomic data (FASTQ files, 100 GB each) from lab instruments, aligning sequences to a reference genome (CPU-intensive, 4 hours per sample), variant calling (GPU-accelerated, 1 hour per sample), annotation and reporting (light compute, 15 minutes). The institution processes 100 samples per day and needs the pipeline to scale elastically.

A) Use SageMaker Processing jobs for alignment (CPU instances), SageMaker Training jobs for variant calling (GPU instances), and SageMaker Processing for annotation. Orchestrate with SageMaker Pipelines. Use S3 for intermediate data. Use Spot instances for cost savings.
B) Use AWS Batch with custom containers for each step. Define three compute environments: CPU-optimized for alignment, GPU for variant calling, and general-purpose for annotation. Use multi-node parallel jobs for alignment. Orchestrate with Step Functions. Use Spot Instances with checkpointing.
C) Deploy a persistent EKS cluster with Karpenter for auto-scaling. Use specialized node pools for CPU and GPU workloads. Deploy Nextflow or Cromwell as workflow managers. Use FSx for Lustre for high-throughput data access.
D) Use AWS Step Functions with Lambda for orchestration. Launch EC2 instances on-demand for alignment and variant calling using Run Command. Terminate instances after job completion.

**Correct Answer: B**

**Explanation:** AWS Batch is purpose-built for batch computing workloads like genomic analysis. Multiple compute environments support different instance types: CPU-optimized (c5/c6i) for alignment, GPU (p3/g5) for variant calling, and general-purpose for annotation. Batch handles job scheduling, compute provisioning, and termination automatically. Multi-node parallel jobs distribute alignment across multiple instances for faster processing. Step Functions orchestrates the multi-step pipeline with error handling and retry logic. Spot Instances with Batch-managed checkpointing provide significant cost savings. Option A's SageMaker is designed for ML workflows, not general bioinformatics processing. Option C's persistent EKS cluster wastes resources during idle periods. Option D's manual EC2 management via Lambda doesn't scale efficiently.

---

### Question 27
A company wants to implement a real-time data enrichment pipeline using Amazon Bedrock. Customer support tickets are submitted through their portal and need to be: classified by urgency (critical, high, medium, low), sentiment analyzed, summarized to 2-3 sentences, routed to the appropriate team based on classification, and enriched with relevant knowledge base articles. The system handles 10,000 tickets per hour during peak and must process each ticket within 30 seconds.

A) Use Amazon EventBridge to receive ticket events. Trigger a Step Functions workflow that: (1) calls Bedrock with a prompt combining classification, sentiment, and summarization in a single request, (2) queries a Bedrock Knowledge Base for relevant articles, (3) publishes the enriched ticket to the appropriate team's SQS queue based on classification.
B) Use SQS to queue tickets. Lambda consumers process each ticket by making five separate Bedrock API calls (classification, sentiment, summary, routing, knowledge base search). Aggregate results and write to DynamoDB. SNS notifies the routing team.
C) Use Kinesis Data Streams for ticket ingestion. Amazon Comprehend for classification and sentiment analysis. Lambda calls Bedrock only for summarization. Amazon Kendra for knowledge base article retrieval. Step Functions for orchestration.
D) Use Amazon Bedrock batch inference for processing all tickets hourly. Batch inference handles large volumes efficiently. Store results in S3 and notify teams via EventBridge.

**Correct Answer: A**

**Explanation:** This architecture optimizes both latency and cost. A single Bedrock prompt can handle classification, sentiment analysis, and summarization simultaneously using a well-crafted prompt — reducing from multiple API calls to one. Bedrock Knowledge Bases handle the article retrieval using RAG. Step Functions orchestrates the workflow with built-in error handling and routing logic. EventBridge provides event-driven trigger architecture. At 10,000 tickets/hour (~3/second), Bedrock handles the throughput within the 30-second SLA. Option B's five separate API calls increase latency and cost per ticket. Option C uses Comprehend for tasks Bedrock handles better (especially with domain-specific classification), adding service complexity. Option D's batch processing runs hourly, not in real-time as required.

---

### Question 28
A media company is designing a video processing platform on EKS that must transcode uploaded videos into multiple formats. The processing requires GPU instances for hardware-accelerated transcoding. Requirements include: processing 500 videos per hour during peak, each video takes 5-20 minutes to transcode, GPU utilization must be above 80%, Spot Instance interruptions must not cause video re-processing from scratch, and the system must scale to zero during off-peak hours.

A) Deploy EKS with Karpenter provisioners configured for GPU Spot Instances (g4dn family). Use a Kubernetes Job queue (backed by SQS) for video processing. Implement checkpointing to S3 every 2 minutes. On Spot interruption, the AWS Node Termination Handler signals the pod, which saves the checkpoint and the job controller retries from the checkpoint on a new node.
B) Use EKS with Cluster Autoscaler and GPU-enabled managed node groups using Spot Instances. Deploy videos as Kubernetes CronJobs. Use EBS volumes for checkpointing. Scale based on pending pods.
C) Deploy on ECS Fargate with GPU task definitions. Fargate handles scaling automatically. Use SQS for job queuing. No Spot interruption concerns with Fargate.
D) Use AWS Batch with GPU compute environments and Spot Instances. Define job definitions for transcoding. Batch manages scheduling, Spot interruption handling, and scaling. Use S3 for input/output.

**Correct Answer: A**

**Explanation:** The EKS + Karpenter + SQS architecture provides the required capabilities. Karpenter provisions GPU nodes in seconds (faster than Cluster Autoscaler) and scales to zero by deprovisioning empty nodes. Spot Instances provide cost savings for GPU-intensive workloads. The checkpoint-to-S3 pattern (every 2 minutes) means Spot interruptions lose at most 2 minutes of work, not the entire 5-20 minute job. AWS Node Termination Handler detects the 2-minute Spot interruption warning and gracefully drains pods. The SQS-based job queue with Kubernetes controller ensures jobs are retried from checkpoints. 80% GPU utilization is achieved through proper pod resource requests and bin-packing. Option B's Cluster Autoscaler is slower than Karpenter. Option C's Fargate doesn't support GPU tasks. Option D works but doesn't leverage EKS as specified in the requirements.

---

### Question 29
A company needs to build an ML feature store for their data science team. The feature store must: provide sub-millisecond feature retrieval for real-time inference, support batch feature retrieval for training, maintain feature versioning and lineage, allow feature sharing across 20 data science teams in different accounts, and ensure consistency between online (real-time) and offline (batch) feature stores.

A) Use Amazon SageMaker Feature Store with both online (DynamoDB-backed) and offline (S3-backed) stores. Feature groups define schemas with versioning. Use cross-account IAM roles for feature sharing. SageMaker Feature Store automatically synchronizes online and offline stores.
B) Build a custom feature store using ElastiCache Redis for online serving and S3 Parquet files for offline. Use Glue Data Catalog for feature metadata and versioning. Share access via cross-account IAM.
C) Use Amazon DynamoDB for online feature serving with Global Tables for multi-region access. Use Athena for offline batch queries on DynamoDB exports to S3. Share tables using RAM.
D) Deploy Apache Feast on EKS as the feature store platform. Use Redis for online store and Redshift for offline store. Manage feature definitions in a Git repository.

**Correct Answer: A**

**Explanation:** SageMaker Feature Store is the managed AWS service purpose-built for ML feature management. It provides: sub-millisecond online feature retrieval (DynamoDB-backed), S3-based offline store for batch retrieval during training, automatic synchronization between online and offline stores ensuring consistency, feature group schemas with versioning, and built-in feature lineage tracking. Cross-account access is supported through IAM roles, enabling all 20 teams to share features. The managed service eliminates operational overhead. Option B requires building and maintaining custom synchronization logic between Redis and S3, which is error-prone. Option C doesn't provide feature versioning or lineage natively. Option D requires managing an open-source system on EKS.

---

### Question 30
A company wants to implement a secure, private connectivity solution for their SaaS customers to access the company's APIs. Each customer has their own AWS account and VPC. The company needs to: support 500+ customer connections, provide private connectivity without internet exposure, allow customers to use their own IP address ranges (no CIDR conflicts), charge customers based on data transfer, and maintain separate traffic isolation per customer.

A) Use AWS PrivateLink. Create a VPC Endpoint Service backed by NLB for each API. Customers create interface VPC endpoints. Enable CloudWatch metrics for per-endpoint data transfer tracking. PrivateLink handles CIDR overlap automatically.
B) Establish individual Site-to-Site VPN connections to each customer's VPC. Use unique BGP ASNs per customer. Track data transfer through VPN tunnel metrics.
C) Use Transit Gateway with VPC attachments from each customer account. Create per-customer route tables for isolation. Use Transit Gateway Flow Logs for data transfer tracking.
D) Deploy a shared API Gateway with private endpoints. Use VPC Lattice to create service networks that customers join. Use CloudWatch metrics for per-consumer data transfer tracking.

**Correct Answer: A**

**Explanation:** AWS PrivateLink is ideal for SaaS provider-to-customer private connectivity at scale. It supports hundreds of customers through a single endpoint service, each customer creates their own interface endpoint independently. PrivateLink is agnostic to CIDR ranges — it uses DNS-based resolution with private IP addresses from the consumer's VPC, eliminating CIDR conflicts. Traffic isolation is inherent because each customer's endpoint is a separate ENI in their VPC. CloudWatch metrics provide per-endpoint data transfer tracking for billing. Option B's individual VPN connections don't scale to 500+ customers. Option C's Transit Gateway creates routing complexity with 500+ VPCs and potential CIDR conflicts. Option D's VPC Lattice is designed for internal service communication, not SaaS customer connectivity at this scale.

---

### Question 31
A company is building an AI-powered code review system using Amazon Bedrock. The system must: analyze pull requests from GitHub, identify potential bugs, security vulnerabilities, and performance issues, generate detailed review comments, learn from feedback on its review comments (thumbs up/down), and operate within a VPC for security. The system processes 200 pull requests per hour.

A) Use GitHub webhooks to EventBridge API destination. EventBridge triggers a Step Functions workflow that: (1) fetches the PR diff via Lambda with GitHub API, (2) sends the code to Bedrock with a specialized code review prompt, (3) posts review comments back to GitHub via Lambda. Store feedback in DynamoDB. Periodically use feedback to refine prompts via Bedrock prompt management.
B) Use a scheduled Lambda function to poll GitHub for new PRs every minute. Process PRs through Bedrock. Store results in S3. Manually review and post comments.
C) Deploy a self-hosted code review tool (SonarQube) on EC2 for static analysis. Use Bedrock only for natural language comment generation based on SonarQube findings.
D) Use Amazon CodeGuru Reviewer integrated with GitHub for automated code reviews. Supplement with Bedrock for additional AI-powered review comments not covered by CodeGuru.

**Correct Answer: A**

**Explanation:** This event-driven architecture provides real-time PR processing. GitHub webhooks to EventBridge (via API destinations) trigger processing immediately on PR creation/update. Step Functions orchestrates the multi-step review process with error handling. Bedrock's foundation models excel at code analysis, bug detection, and generating natural language review comments. DynamoDB stores feedback for continuous improvement. The prompt management approach (refining review prompts based on feedback patterns) provides the learning capability without expensive model fine-tuning. Operating within a VPC with Bedrock VPC endpoints satisfies security requirements. Option B's polling adds latency and wasted invocations. Option C limits AI capabilities to comment formatting. Option D's CodeGuru has narrower language support and rule-based analysis compared to Bedrock's general code understanding.

---

### Question 32
A company needs to design a network architecture for a regulated environment where different application tiers must be isolated at the network level with mandatory traffic inspection between tiers. The architecture has three tiers: web (public-facing), application (internal), and database (restricted). Requirements include: web tier can communicate with application tier only through load balancers, application tier can communicate with database tier only through approved ports (5432/TCP), all cross-tier traffic must be logged and inspectable, and no direct communication between web and database tiers.

A) Deploy each tier in a separate VPC. Connect VPCs via Transit Gateway with three route tables (one per tier). Deploy AWS Network Firewall in an inspection VPC for all cross-tier traffic. Configure stateful rules: allow web-to-app on ports 80/443, allow app-to-db on port 5432, deny all other cross-tier traffic.
B) Use a single VPC with three subnet tiers. Use NACLs for inter-tier traffic control (web subnets to app subnets, app subnets to db subnets). Security groups for host-level filtering. VPC Flow Logs for logging.
C) Deploy each tier in a separate VPC connected via VPC peering. Use security groups on each tier's resources to restrict communication. No Transit Gateway or Network Firewall needed.
D) Use a single VPC with three tiers in separate subnets. Deploy AWS Network Firewall endpoints in each tier's subnet. Configure Network Firewall rules for inter-tier traffic. Use VPC Flow Logs for traffic logging.

**Correct Answer: A**

**Explanation:** Separate VPCs per tier with Transit Gateway provide the strongest isolation. Network Firewall in an inspection VPC acts as a mandatory chokepoint for all cross-tier traffic — packets physically traverse the firewall, ensuring no bypass is possible. Stateful rules precisely control what communication is allowed (web→app on HTTP/S, app→db on PostgreSQL). Transit Gateway route tables ensure traffic between tiers routes through the inspection VPC. Network Firewall logging provides detailed traffic inspection data. This architecture makes it technically impossible for web-tier resources to directly reach database-tier resources without passing through the firewall. Option B's NACLs are stateless and limited in rule count, and subnets in the same VPC can potentially bypass NACLs through local routes. Option C's VPC peering without inspection doesn't meet the mandatory inspection requirement. Option D's Network Firewall in the same VPC doesn't prevent intra-VPC traffic from bypassing the firewall through direct routing.

---

### Question 33
A company is deploying a multi-model AI inference platform on EKS that serves 50 different ML models. The models have varying resource requirements: some need GPUs, some need high memory, and some are CPU-only. Traffic patterns vary widely — popular models get thousands of requests per second while niche models get a few per minute. The platform must minimize cost while maintaining sub-100ms latency for all models.

A) Deploy each model in a separate EKS Deployment with Horizontal Pod Autoscaler (HPA). Use Karpenter with multiple provisioners for different instance types. Use KEDA for scaling based on custom metrics (request queue depth per model). Pack cold models (low traffic) onto shared CPU nodes.
B) Use SageMaker Multi-Model Endpoints to host all 50 models on a fleet of instances. SageMaker manages model loading/unloading based on traffic, optimizing instance utilization. Auto-scale the endpoint based on InvocationsPerInstance.
C) Deploy a Triton Inference Server on EKS that hosts multiple models per pod. Use GPU sharing (MPS/MIG) for GPU models. Implement request batching for efficiency. Scale Triton pods based on GPU utilization and request queue depth. Use Karpenter for node provisioning.
D) Deploy models on Lambda using container images. Each model gets its own Lambda function. Lambda auto-scales per model. Use provisioned concurrency for popular models to maintain low latency.

**Correct Answer: C**

**Explanation:** NVIDIA Triton Inference Server is designed for multi-model serving on shared infrastructure. It supports dynamic model loading, concurrent model execution, request batching for GPU efficiency, and models with different frameworks. GPU sharing via MPS (Multi-Process Service) or MIG maximizes GPU utilization across models. Scaling based on both GPU utilization and queue depth ensures performance while optimizing costs. Karpenter provisions the right mix of GPU and CPU nodes based on pod scheduling demands. This approach achieves high hardware utilization (reducing cost) while maintaining sub-100ms latency through efficient request batching and GPU sharing. Option A creates too many separate deployments, leading to resource fragmentation. Option B's SageMaker Multi-Model Endpoints add latency when loading cold models. Option D's Lambda has container size limits and cold start issues for ML models.

---

### Question 34
A healthcare organization needs to deploy an EKS cluster that processes PHI (Protected Health Information). The cluster must comply with HIPAA requirements including: encryption of all data at rest and in transit, audit logging of all API server access, network isolation of PHI workloads, secrets encryption using customer-managed KMS keys, and pod-level security controls preventing privilege escalation.

A) Enable EKS secrets encryption with a customer-managed KMS key. Enable control plane logging (API server, audit, authenticator, controller manager, scheduler) to CloudWatch Logs. Use the VPC CNI with NetworkPolicy for network isolation. Configure Pod Security Standards in enforce mode (restricted profile). Enable EBS CSI driver with encrypted volumes for persistent storage. Use service mesh mTLS for in-transit encryption.
B) Use EKS on Fargate for all PHI workloads. Fargate provides isolated compute. Enable cluster logging. Use AWS Secrets Manager instead of Kubernetes secrets. Configure pod security via Fargate profiles.
C) Deploy a self-managed Kubernetes cluster on EC2 with full control over encryption, logging, and security configurations. Use HashiCorp Vault for secrets management.
D) Enable basic EKS logging. Use AWS Managed encryption for EBS volumes. Deploy OPA Gatekeeper for pod security. Use Calico for network policies.

**Correct Answer: A**

**Explanation:** This configuration addresses every HIPAA requirement. KMS-encrypted EKS secrets ensure data at rest encryption for Kubernetes secrets containing PHI. Full control plane logging to CloudWatch provides audit trails for all API server interactions. NetworkPolicy with VPC CNI isolates PHI workloads from other namespaces. Pod Security Standards in restricted mode prevents privilege escalation, host namespace access, and other risky configurations. EBS CSI with encrypted volumes protects persistent data. Service mesh mTLS ensures all pod-to-pod communication is encrypted. Option B's Fargate doesn't support all workload types and has limitations on networking and storage. Option C adds unnecessary operational burden for a managed service. Option D uses AWS-managed encryption which doesn't satisfy customer-managed KMS key requirements.

---

### Question 35
A company needs to implement a Gateway Load Balancer (GWLB) architecture for transparent network security inspection. Inbound internet traffic to their web application must pass through third-party firewall appliances (Palo Alto Networks VMs) before reaching the application ALB. The solution must inspect all traffic including TLS, handle 10 Gbps of throughput, maintain session stickiness for stateful inspection, and support high availability across three AZs.

A) Deploy GWLB in the security VPC with Palo Alto firewall instances as targets across three AZs. Create GWLB endpoints in the application VPC's public subnets. Configure route tables to direct inbound traffic from the Internet Gateway to the GWLB endpoints. GWLB uses GENEVE encapsulation to pass traffic to firewalls with session stickiness (5-tuple hash). Firewalls perform TLS decryption/inspection and forward clean traffic back through GWLB to the ALB.
B) Deploy Palo Alto firewalls behind an NLB in the security VPC. Route traffic from the Internet Gateway to the NLB, which distributes to firewalls. Firewalls forward inspected traffic to the application ALB. Use NLB sticky sessions for stateful inspection.
C) Deploy AWS Network Firewall instead of third-party appliances. Network Firewall handles TLS inspection natively. Use Network Firewall endpoints in the application VPC for transparent inspection.
D) Use a Transit Gateway with firewall appliances. Route inbound traffic through Transit Gateway to the security VPC, inspect with Palo Alto firewalls, then route to the application VPC.

**Correct Answer: A**

**Explanation:** Gateway Load Balancer is specifically designed for transparent inline network appliance insertion. GWLB uses GENEVE encapsulation (port 6081) to pass original packet headers to appliances while handling load balancing. The 5-tuple hash ensures session stickiness for stateful firewalls. GWLB endpoints in the application VPC enable route table-based traffic steering — the Internet Gateway route table sends inbound traffic to GWLB endpoints before the ALB subnet. This is completely transparent to the application. Palo Alto firewalls perform TLS decryption/inspection (using imported certificates). Three AZ deployment provides high availability and 10 Gbps throughput distribution. Option B's NLB doesn't support the transparent insertion model (GENEVE encapsulation) needed for source IP preservation and bidirectional flow tracking. Option C's Network Firewall doesn't support full TLS decryption/inspection of inbound traffic with certificate management. Option D's Transit Gateway adds latency and complexity.

---

### Question 36
A company is building a document understanding platform using Amazon Bedrock and SageMaker. The platform must process scanned contracts, extract key terms and obligations, compare terms across multiple contracts, generate risk assessments, and allow users to ask questions about specific contracts. The contract corpus contains 100,000 documents totaling 2 TB of PDFs.

A) Use Amazon Textract to extract text from scanned PDFs. Store extracted text in S3. Create a Bedrock Knowledge Base backed by OpenSearch Serverless for the document corpus. Use Bedrock Agents to handle user questions with RAG retrieval, comparison queries, and risk assessment generation. Chain multiple Bedrock calls for complex analysis.
B) Fine-tune a Bedrock foundation model on the contract corpus for domain-specific understanding. Deploy as a custom model. Use the fine-tuned model for all tasks (extraction, comparison, risk assessment, Q&A).
C) Use Amazon Comprehend for document classification and entity extraction. Store structured data in Neptune as a knowledge graph. Use SageMaker for custom NLP models trained on contract language. Build a custom Q&A interface.
D) Upload all PDFs directly to Bedrock Knowledge Base. Bedrock handles OCR, extraction, and indexing automatically. Use Bedrock chat for all interactions.

**Correct Answer: A**

**Explanation:** This architecture optimally combines services for each capability. Textract handles OCR and structured extraction from scanned PDFs (tables, forms, text). Bedrock Knowledge Bases with OpenSearch Serverless provide vector-based semantic search over 100,000 documents for RAG-powered Q&A and comparison. Bedrock Agents orchestrate multi-step workflows: retrieve relevant contract sections, compare terms across documents, and generate risk assessments using foundation model reasoning. This separation of concerns ensures each service handles what it does best. Option B's fine-tuning doesn't help with extraction from scanned documents and is expensive for 2 TB of data. Option C uses older NLP approaches that lack the reasoning capabilities of foundation models. Option D is incorrect — Bedrock Knowledge Base doesn't perform OCR on scanned PDFs; it requires text-based documents.

---

### Question 37
A company is designing a multi-region EKS platform for a latency-sensitive API serving users globally. The platform must run in 5 regions with independent data planes, share a common set of Kubernetes configurations and policies, enable developers to deploy to all regions through a single interface, handle region failures automatically, and maintain consistent observability across all clusters.

A) Deploy independent EKS clusters in 5 regions. Use ArgoCD with an ApplicationSet controller for GitOps-based multi-cluster deployment. Use Global Accelerator for traffic routing and health-based failover. Deploy AWS Distro for OpenTelemetry (ADOT) on each cluster with centralized Amazon Managed Grafana for observability.
B) Use EKS Anywhere deployed in co-location facilities in 5 regions. Manage all clusters from a single control plane in one region. Use Route 53 for DNS-based routing.
C) Deploy a single EKS cluster with nodes in 5 regions using custom networking. Use Kubernetes federation for deployment management. Route 53 latency-based routing for traffic direction.
D) Deploy independent EKS clusters. Use Flux CD for GitOps deployments. Use CloudFront for global routing. Deploy Prometheus and Grafana per cluster.

**Correct Answer: A**

**Explanation:** This architecture addresses all requirements with proven tools. Independent EKS clusters per region provide isolation and independent data planes. ArgoCD with ApplicationSet generates deployments across all clusters from a single Git source, ensuring consistent configurations and policies. Global Accelerator provides instant health-based failover (seconds, not DNS TTL-dependent). ADOT (AWS Distro for OpenTelemetry) on each cluster collects metrics and traces, centralizing in Managed Grafana for unified observability. Option B's EKS Anywhere in colocations defeats the purpose of using regional AWS infrastructure. Option C's single cluster spanning regions isn't possible with EKS. Option D's CloudFront isn't ideal for API routing (it's a CDN), and per-cluster Prometheus/Grafana doesn't provide centralized observability.

---

### Question 38
A company needs to implement a secure data pipeline that moves sensitive data from on-premises to S3, processes it using SageMaker, and stores results back in S3. Requirements include: all data encrypted in transit and at rest with customer-managed keys, private connectivity (no internet), all API calls audited, data access restricted to specific IAM principals with MFA, and compliance with SOC 2 and ISO 27001.

A) Use Direct Connect with MACsec for encrypted transit. S3 buckets with SSE-KMS using customer-managed keys and bucket policies requiring MFA for access (aws:MultiFactorAuthAge condition). SageMaker in VPC with VPC endpoints. CloudTrail with S3 data events enabled. KMS key policies restricting usage to specific IAM roles.
B) Use Site-to-Site VPN for encrypted transit. S3 with SSE-S3 encryption. SageMaker in default networking mode. CloudTrail for management events only.
C) Use AWS Transfer Family for SFTP ingestion. S3 with SSE-KMS. SageMaker with internet access for AWS service calls. CloudTrail with all events.
D) Use Direct Connect (unencrypted). S3 with client-side encryption. SageMaker in VPC. CloudTrail with S3 data events.

**Correct Answer: A**

**Explanation:** This solution addresses every security and compliance requirement. Direct Connect with MACsec provides 256-bit AES encrypted private connectivity at line rate. SSE-KMS with customer-managed keys satisfies the encryption at rest and key management requirements. S3 bucket policies with the aws:MultiFactorAuthAge condition enforce MFA for data access. SageMaker in a VPC with VPC endpoints ensures all processing happens privately. CloudTrail with S3 data events captures all data access operations for the audit trail. KMS key policies with specific IAM principal restrictions limit who can encrypt/decrypt data. These controls map directly to SOC 2 (access control, encryption, audit logging) and ISO 27001 (information security management) requirements. Option B uses SSE-S3 (AWS-managed keys, not customer-managed) and lacks data event auditing. Option C uses internet access. Option D uses client-side encryption which complicates SageMaker processing.

---

### Question 39
A company is building a Kubernetes-native ML training platform on EKS. Data scientists submit training jobs as Kubernetes custom resources. The platform must: support distributed training across multiple nodes with GPU, automatically provision and deprovision GPU instances based on job queue, support multiple ML frameworks (PyTorch, TensorFlow, JAX), provide job scheduling with priorities and gang scheduling, and manage training data access from S3 with caching.

A) Deploy the Kubeflow Training Operator for multi-framework distributed training. Use Volcano scheduler for gang scheduling and priority queues. Deploy Karpenter for GPU node auto-provisioning. Use the Mountpoint for Amazon S3 CSI driver for direct S3 access. Deploy FSx for Lustre CSI driver for cached data access.
B) Use SageMaker Operators for Kubernetes to submit training jobs to SageMaker from EKS. SageMaker handles distributed training, GPU provisioning, and job scheduling. Use S3 natively through SageMaker.
C) Build custom Kubernetes operators for each ML framework. Implement a custom scheduler with priority support. Use Cluster Autoscaler for GPU nodes. Mount EBS volumes for training data.
D) Deploy Ray on EKS for distributed computing. Use Ray Train for distributed training. Use Ray's built-in scheduler. Access S3 data through Ray's data loading utilities.

**Correct Answer: A**

**Explanation:** This architecture leverages the Kubernetes-native ML ecosystem. Kubeflow Training Operator provides CRDs for PyTorchJob, TFJob, and XGBoostJob (multi-framework support) with built-in distributed training coordination. Volcano scheduler provides gang scheduling (all pods in a training job scheduled simultaneously or not at all) and priority-based queuing — critical for GPU training workloads. Karpenter provisions GPU nodes in seconds based on pending pod demands and deprovisions when empty. Mountpoint for S3 provides POSIX-compatible direct S3 access, while FSx for Lustre CSI driver provides cached access for training data hot sets. Option B offloads to SageMaker, losing the Kubernetes-native requirement. Option C requires building custom operators for each framework. Option D's Ray is powerful but doesn't integrate with Kubernetes scheduling as natively as Kubeflow+Volcano.

---

### Question 40
A company wants to implement a network security architecture where different security zones have different levels of traffic inspection. The zones are: DMZ (full Layer 7 inspection including TLS), internal production (Layer 4 stateful inspection), development (basic logging only), and management (full inspection with IDS/IPS). Each zone is implemented as a set of VPCs connected through Transit Gateway.

A) Deploy a single AWS Network Firewall with different rule groups applied based on source/destination. Use stateful rules for production, stateless rules for development, and TLS inspection rules for DMZ. Attach the Network Firewall to the Transit Gateway as an inspection VPC.
B) Deploy multiple Network Firewall instances — one per security zone with zone-appropriate rule configurations. Use Transit Gateway route tables to direct traffic through the appropriate firewall based on the source zone. DMZ firewall has TLS inspection enabled, production firewall has stateful rules, management firewall has IDS/IPS rules.
C) Use a single Network Firewall for all traffic but with different firewall policies per zone. Route all traffic through the firewall and use source/destination IP-based policy selection.
D) Use NACLs for development zone (basic logging via VPC Flow Logs), security groups for production (stateful), and Network Firewall only for DMZ and management zones. Minimize Network Firewall costs by using it only where needed.

**Correct Answer: B**

**Explanation:** Multiple Network Firewall deployments per zone provide the most precise and operationally clean architecture. Each firewall is configured specifically for its zone's requirements: DMZ firewall with TLS inspection rules for full Layer 7 analysis, production firewall with stateful rules for connection tracking, development with minimal logging rules, and management firewall with IDS/IPS Suricata rules. Transit Gateway route tables direct inter-zone traffic through the appropriate firewall — traffic from/to DMZ routes through the DMZ firewall, production traffic through the production firewall, etc. This prevents over-inspecting traffic that doesn't require it and ensures each zone gets its specific security level. Option A's single firewall becomes a bottleneck and makes policy management complex. Option C is similar to A with the same problems. Option D's NACLs don't provide logging at the same granularity as Network Firewall.

---

### Question 41
A company is deploying a Retrieval-Augmented Generation (RAG) system using Amazon Bedrock Knowledge Bases. The knowledge base contains 10 million technical documents. Users report that answers are sometimes inaccurate because the retriever returns marginally relevant documents. The company needs to improve answer accuracy while maintaining sub-3-second response times.

A) Increase the number of retrieved chunks from 5 to 20 in the Knowledge Base configuration. This gives the model more context to work with, improving answer accuracy.
B) Implement a hybrid retrieval strategy: configure the Knowledge Base with both semantic search (vector embeddings) and keyword search (BM25). Use Bedrock's reranking capability to re-score retrieved chunks before passing to the foundation model. Optimize chunk sizes during ingestion (smaller chunks for precise retrieval, with parent chunk reference for context).
C) Switch to a larger foundation model with a bigger context window. Include more retrieved documents in the prompt. The larger model better understands the relevant information.
D) Fine-tune the embedding model used by Knowledge Bases on domain-specific technical vocabulary. Use custom chunking strategies that align with document structure (chapters, sections).

**Correct Answer: B**

**Explanation:** Retrieval accuracy is the primary issue. Hybrid search combining semantic (vector) and keyword (BM25) retrieval captures both conceptually similar and keyword-exact matches, improving recall. Reranking uses a cross-encoder model to re-score retrieved chunks, dramatically improving precision (the most relevant chunks are ranked highest). Optimized chunking strategies (smaller chunks for retrieval precision with parent chunk references for context) ensure the foundation model receives focused, relevant content. These improvements address the root cause (poor retrieval) rather than compensating with larger models. Option A increases context but also increases noise if the additional chunks are irrelevant. Option C adds cost and latency without fixing retrieval quality. Option D improves embeddings but doesn't address the fundamental retrieval strategy.

---

### Question 42
A company needs to design a network architecture for running Windows-based applications on EKS. The applications require: Windows containers running on Windows Server nodes, Active Directory integration for authentication, SMB file share access from pods, connectivity to on-premises Windows services over Direct Connect, and group Managed Service Accounts (gMSA) for pod identity.

A) Deploy EKS with mixed node groups — Linux for system components and Windows for application workloads. Join Windows worker nodes to AWS Managed Microsoft AD. Configure gMSA on Windows pods using the gMSA webhook. Mount Amazon FSx for Windows File Server as SMB volumes using the SMB CSI driver. Connect to on-premises via Direct Connect with AD trust relationship.
B) Use EKS with all Windows nodes. Deploy the VPC CNI for Windows networking. Use Kerberos authentication via custom init containers. Mount EBS volumes for file storage.
C) Deploy Windows containers on ECS with EC2 launch type instead of EKS. ECS has better native Windows support. Use Active Directory Connector for AD integration.
D) Use EKS Anywhere on-premises for Windows workloads. This provides direct AD and file share access without cross-network complexity.

**Correct Answer: A**

**Explanation:** EKS supports Windows containers through mixed node groups — Linux nodes run core Kubernetes components (kube-proxy, CoreDNS, VPC CNI) while Windows nodes run application workloads. Windows worker nodes joined to AWS Managed Microsoft AD enable domain-based authentication. gMSA (group Managed Service Accounts) is supported on EKS through the gMSA webhook, which configures pods with AD identities. FSx for Windows File Server provides native SMB file shares accessible from Windows pods via the SMB CSI driver. Direct Connect provides on-premises connectivity, and AD trust relationships between Managed AD and on-premises AD enable seamless authentication. Option B's all-Windows cluster isn't possible — EKS requires Linux nodes for system components. Option C doesn't meet the EKS requirement. Option D avoids cloud migration which isn't the objective.

---

## Domain 3: Continuous Improvement for Existing Solutions (Questions 43–53)

### Question 43
A company's existing Transit Gateway architecture connects 80 VPCs with a single default route table where all VPCs can communicate with each other. Following a security audit, the company needs to implement network segmentation: production VPCs should only communicate with shared services VPCs, development VPCs should be isolated from production, and all inter-VPC traffic must be logged. The change must be implemented without downtime.

A) Create new Transit Gateway route tables for production, development, and shared services segments. Gradually associate VPCs with appropriate route tables (disassociate from default, associate with new). Add routes for allowed communication paths (production↔shared services, development↔shared services). Enable Transit Gateway Flow Logs. Move VPCs in batches during maintenance windows.
B) Replace Transit Gateway with VPC peering between allowed VPC pairs. Remove the Transit Gateway. This provides explicit connectivity without routing complexity.
C) Keep the single route table but add blackhole routes for production-to-development CIDR ranges in both directions. This prevents communication while maintaining existing routing for allowed paths.
D) Deploy Network Firewall between segments with deny rules for unauthorized traffic. Keep the single Transit Gateway route table unchanged.

**Correct Answer: A**

**Explanation:** Transit Gateway route tables enable segmentation through association and propagation controls. Creating separate route tables for each segment and gradually migrating VPC associations is the correct approach. When a VPC is moved from the default route table to its segment-specific table, it immediately adopts the new routing (only routes to allowed segments). The key to zero-downtime migration is moving VPCs in batches — if a production VPC is moved to the production route table before its shared services dependency is updated, the route to shared services must already exist in the production table. Transit Gateway Flow Logs capture all inter-VPC traffic for logging. Option B's VPC peering doesn't scale for 80 VPCs and requires managing O(n²) peering connections. Option C's blackhole routes are fragile and must be updated whenever CIDRs change. Option D doesn't achieve actual segmentation — traffic still flows through the same route table.

---

### Question 44
A company's EKS cluster has been experiencing increased pod startup times (from 10 seconds to 2 minutes) as the cluster has grown to 200 nodes and 5,000 pods. Investigation reveals that image pull times are the bottleneck — the same container images (2-5 GB each) are being pulled from ECR to every new node. The team needs to reduce pod startup times to under 30 seconds.

A) Implement image caching on each node using Bottlerocket OS with pre-cached base images. Configure Karpenter to pre-pull commonly used images using a DaemonSet that runs on each new node. Use ECR pull-through cache for third-party images.
B) Switch to EKS Fargate, which manages image pulling and caching internally, providing consistent startup times.
C) Deploy Harbor registry as a local in-cluster pull-through cache. Nodes pull images from Harbor (in the same VPC) instead of directly from ECR. Harbor caches images after the first pull, serving subsequent pulls locally.
D) Use SOCI (Seekable OCI) lazy-loading snapshotter with containerd on EKS nodes. SOCI creates an index that allows containers to start before the full image is downloaded, loading layers on demand. Store SOCI indexes alongside images in ECR.
E) Reduce image sizes by using multi-stage builds and Alpine-based images. This reduces pull times proportionally.

**Correct Answer: D**

**Explanation:** SOCI (Seekable OCI) snapshotter is the most effective solution for large images. Instead of downloading the entire 2-5 GB image before starting the container, SOCI lazily loads image layers on demand. The container starts almost immediately (within seconds), loading only the required layers and files as they're accessed. This is particularly effective for large images where only a fraction of the image content is needed at startup. SOCI indexes stored in ECR alongside images enable the snapshotter to make precise byte-range requests. This approach brings pod startup time well under 30 seconds regardless of image size. Option A's pre-pulling adds cache management complexity. Option B's Fargate has its own limitations and doesn't always reduce startup times for large images. Option C's Harbor cache still requires full image pulls on cache misses. Option E requires modifying all container images and may not reduce sufficiently.

---

### Question 45
A company has been using Amazon SageMaker endpoints for real-time inference. Their monthly SageMaker costs have grown to $50,000 for 20 endpoints. Analysis shows: 5 endpoints serve 90% of total traffic, 10 endpoints serve 9% of traffic, and 5 endpoints serve <1% of traffic (a few requests per day). All endpoints use ml.m5.xlarge instances with a minimum of 2 instances each. The company wants to reduce costs without increasing latency for high-traffic models.

A) Consolidate the 5 low-traffic models onto SageMaker Multi-Model Endpoints to share instances. Keep high-traffic models on dedicated endpoints. Use auto-scaling with scale-to-zero for the medium-traffic endpoints during off-hours.
B) Move all 20 models to a single SageMaker Multi-Model Endpoint. A shared instance pool serves all models, with dynamic model loading based on request patterns.
C) Migrate high-traffic models to SageMaker Inference Components on a shared endpoint with dedicated instance allocation. Migrate medium-traffic models to a shared Inference Component pool. Move low-traffic models to Lambda for serverless inference with on-demand pricing.
D) Keep all endpoints but reduce instance count to 1 per endpoint (remove the redundancy). Use smaller instance types (ml.m5.large) for low-traffic endpoints.

**Correct Answer: C**

**Explanation:** SageMaker Inference Components provide fine-grained resource allocation on shared endpoints. High-traffic models get dedicated compute allocation (guaranteed resources) on a shared endpoint, maintaining performance. Medium-traffic models share a resource pool on another endpoint, right-sizing automatically. Low-traffic models (few requests/day) are most cost-effective on Lambda — pay only per invocation with no idle cost. This tiered approach matches resource allocation to actual usage patterns. For 5 low-traffic models at a few requests per day, Lambda costs are negligible compared to running 10 instances (2 per endpoint). Option A's Multi-Model Endpoints add cold-loading latency for infrequently accessed models. Option B consolidating all models risks latency degradation for high-traffic models when low-traffic models cause cache evictions. Option D reduces availability by removing redundancy.

---

### Question 46
A company uses AWS Network Firewall for east-west traffic inspection between VPCs. After 6 months, the firewall rules have grown to over 200 stateful rules, and the network team reports that new rule additions occasionally break existing connectivity. The team needs to improve rule management, implement testing before deployment, and reduce the risk of misconfigurations.

A) Organize rules into separate rule groups by function (allow rules, deny rules, IPS rules). Implement a CI/CD pipeline using CodePipeline that: (1) stores firewall rules in CodeCommit as Terraform/CloudFormation, (2) runs automated rule conflict detection via Lambda, (3) deploys to a test Network Firewall, (4) runs connectivity tests against the test firewall, (5) requires manual approval before production deployment.
B) Use AWS Firewall Manager to manage Network Firewall policies centrally. Firewall Manager handles rule deployment and rollback across all firewalls.
C) Replace individual rules with IP set-based rules to reduce rule count. Use DynamoDB to store IP mappings and Lambda to update IP sets when changes are needed.
D) Implement rule versioning using S3 object versioning for firewall policy JSON exports. Manually review and apply changes. Rollback by restoring previous versions.

**Correct Answer: A**

**Explanation:** Infrastructure-as-code with CI/CD provides the governance needed for complex firewall rule management. Storing rules in CodeCommit enables version control, change tracking, and code review. Automated conflict detection (a Lambda function that analyzes new rules against existing ones for overlaps, shadows, or contradictions) catches issues before deployment. Testing against a non-production firewall verifies connectivity before production impact. Manual approval gates provide a final check. Rule groups organized by function (allow, deny, IPS) make the 200+ rules manageable and reduce the chance of unintended interactions. Option B's Firewall Manager manages deployment across accounts but doesn't solve the rule quality/testing problem. Option C reduces count but loses the specific matching granularity. Option D's manual approach doesn't prevent the misconfigurations that are the core issue.

---

### Question 47
A company's SageMaker model monitoring detects that their fraud detection model's accuracy has degraded from 95% to 82% over the past month. The data science team needs to: identify the root cause (data drift, concept drift, or upstream data quality issues), automatically retrain the model when drift is detected, validate the retrained model before production deployment, and maintain model governance through the lifecycle.

A) Use SageMaker Model Monitor with data quality, model quality, bias, and feature attribution monitors. Configure CloudWatch alarms on drift metrics. When alarms trigger, use EventBridge to initiate a SageMaker Pipeline that: (1) analyzes drift reports to identify root cause, (2) retrains the model on recent data, (3) evaluates the new model against holdout data, (4) registers the model in Model Registry with PendingApproval status, (5) requires human approval before deployment.
B) Implement a Lambda function that periodically queries the model endpoint with test data. If accuracy drops below threshold, trigger retraining on the latest data and deploy automatically.
C) Use CloudWatch anomaly detection on prediction confidence scores. When anomalies are detected, send alerts to the data science team for manual investigation and retraining.
D) Schedule weekly model retraining regardless of drift. Deploy the latest model automatically if its test accuracy exceeds 90%. Use Step Functions for orchestration.

**Correct Answer: A**

**Explanation:** SageMaker Model Monitor provides comprehensive drift detection: data quality monitor detects input data distribution changes (data drift), model quality monitor tracks prediction accuracy (concept drift), bias monitor detects fairness drift, and feature attribution monitor identifies which features are contributing to drift. These monitors pinpoint root causes. EventBridge integration enables automated pipeline triggering when drift is detected. SageMaker Pipelines automate the retraining workflow with proper evaluation gates. Model Registry enforces governance — the PendingApproval status prevents automatic production deployment without human review. Option B's simple accuracy check doesn't identify root causes (data vs. concept drift vs. data quality). Option C relies on manual intervention. Option D's weekly retraining is wasteful when no drift exists and risky when drift happens between retraining cycles.

---

### Question 48
A company runs a VPN-based connectivity solution to their on-premises data center with two AWS Site-to-Site VPN tunnels. They're experiencing intermittent connectivity issues, with packets being dropped during failover between tunnels. Application performance is also degraded because the VPN throughput is limited to 1.25 Gbps per tunnel. The company needs to improve reliability, throughput, and failover speed.

A) Enable Accelerated Site-to-Site VPN, which uses Global Accelerator to improve VPN performance and failover speed. Use ECMP (Equal Cost Multi-Path) over Transit Gateway with multiple VPN connections for increased throughput. Enable DPD (Dead Peer Detection) with short intervals for faster failure detection.
B) Replace Site-to-Site VPN with AWS Direct Connect for higher throughput and more reliable connectivity. Use Direct Connect with MACsec for encryption. Keep VPN as backup over the internet.
C) Add additional VPN connections (up to 10) to the Transit Gateway for increased aggregate throughput via ECMP. Enable VPN acceleration. Monitor tunnel health with CloudWatch metrics.
D) Replace Site-to-Site VPN with AWS Client VPN for better reliability. Client VPN uses OpenVPN protocol which handles failover more gracefully.

**Correct Answer: A**

**Explanation:** Three improvements address the stated issues. Accelerated VPN uses the AWS Global Accelerator network to route VPN traffic, improving reliability by avoiding internet congestion and reducing failover time. ECMP over Transit Gateway aggregates bandwidth across multiple VPN connections — each tunnel provides 1.25 Gbps, so 4 VPN connections provide 10 Gbps aggregate throughput. Short DPD intervals (10 seconds) ensure failed tunnels are detected and traffic is shifted quickly, reducing packet loss during failover. Option B's Direct Connect is a valid improvement but requires physical provisioning (weeks to months) and doesn't address the immediate VPN issues. Option C is similar to A but doesn't emphasize accelerated VPN for reliability improvement. Option D's Client VPN is for individual user access, not site-to-site connectivity.

---

### Question 49
A company's existing Bedrock-powered customer service chatbot has a response time of 8-12 seconds, which users find frustrating. The chatbot uses RAG with a Knowledge Base containing 50,000 documents. Profiling shows: Knowledge Base retrieval takes 2 seconds, Bedrock model inference takes 6-8 seconds, and application overhead is 0.5 seconds. The company wants to reduce response time to under 4 seconds.

A) Switch to a smaller, faster Bedrock model (e.g., Claude 3 Haiku instead of Claude 3 Sonnet). Reduce the number of retrieved chunks from 10 to 3 to decrease prompt size. Implement response streaming so users see output progressively. Use a prompt cache for common queries.
B) Deploy the Knowledge Base vector store on a larger OpenSearch Serverless instance for faster retrieval. Use a larger Bedrock model with better reasoning to reduce the need for multiple retrieved chunks.
C) Pre-compute answers for the top 1000 most common questions and cache them in ElastiCache. For other queries, use the existing Bedrock pipeline.
D) Switch to a self-hosted model on SageMaker with GPU instances for lower latency inference. Build a custom vector database on EC2 for faster retrieval.

**Correct Answer: A**

**Explanation:** This targets the biggest latency contributor (model inference at 6-8 seconds). Switching to a smaller model (Haiku is ~5x faster than Sonnet) dramatically reduces inference time to 1-2 seconds. Reducing retrieved chunks from 10 to 3 decreases the prompt tokens, further reducing inference time. Response streaming makes the user experience feel instant — users see the first tokens within seconds while the full response is being generated. Prompt caching for common queries eliminates both retrieval and inference latency for repeated questions. Combined, these optimizations bring total response time under 4 seconds. Option B's larger instances don't help if retrieval is already 2 seconds (OpenSearch is already fast). Option C's pre-computed answers don't handle the long tail of questions. Option D introduces significant operational overhead with self-hosted models.

---

### Question 50
A company operates an EKS cluster with 100 microservices. They've been using security groups at the node level for network security. A penetration test reveals that a compromised pod could access sensitive services in other namespaces because all pods on the same node share the same security group. The company needs to implement pod-level security isolation.

A) Enable Security Groups for Pods on EKS. This allows assigning different security groups to individual pods rather than nodes. Create specific security groups for sensitive services (databases, authentication) that only allow traffic from authorized pod security groups.
B) Implement Kubernetes NetworkPolicy using the VPC CNI network policy engine. Define default-deny policies in all namespaces, then create allow policies for specific pod-to-pod communication paths based on labels and namespaces.
C) Use both Security Groups for Pods (for VPC-level network isolation) AND Kubernetes NetworkPolicy (for Kubernetes-level traffic control). Security groups protect sensitive services at the VPC layer, while NetworkPolicies provide fine-grained pod-to-pod rules.
D) Move sensitive services to EKS Fargate profiles. Fargate pods run in isolated microVMs with their own ENIs and security groups, providing inherent isolation from pods on shared nodes.

**Correct Answer: C**

**Explanation:** Defense in depth requires layering both VPC-level and Kubernetes-level network controls. Security Groups for Pods (using the VPC CNI's ENABLE_POD_ENI feature) assign individual security groups to pods, enabling VPC-level isolation (e.g., only authorized pods can reach the RDS database security group). Kubernetes NetworkPolicies add fine-grained pod-to-pod rules within the cluster based on labels and namespaces. The combination ensures that even if one layer is misconfigured, the other layer provides protection. Option A's Security Groups for Pods alone don't provide granular intra-cluster policy. Option B's NetworkPolicies alone don't integrate with VPC-level resources (like RDS security groups). Option D moves services to Fargate which may not be suitable for all workloads.

---

### Question 51
A company's existing PrivateLink architecture has a VPC endpoint service backed by an NLB that distributes traffic to 20 backend instances. The backend team reports that some instances are receiving disproportionately more traffic than others, causing performance degradation. The NLB is configured with cross-zone load balancing disabled. The endpoint service has 3 Availability Zones enabled.

A) Enable cross-zone load balancing on the NLB. This distributes traffic evenly across all targets regardless of their AZ. This resolves the imbalance when consumer traffic is concentrated in certain AZs.
B) Replace the NLB with an ALB behind the endpoint service. ALBs have better load distribution algorithms including least-outstanding-requests routing.
C) Enable proxy protocol v2 on the NLB to preserve consumer information. Use this information for custom load balancing logic on the backend.
D) Add more targets in the underutilized AZs to balance capacity with the traffic distribution pattern. Monitor the traffic pattern before changing the NLB configuration.

**Correct Answer: A**

**Explanation:** The traffic imbalance is caused by uneven consumer traffic distribution across AZs combined with disabled cross-zone load balancing. When cross-zone is disabled, each AZ's NLB node distributes traffic only to targets in its AZ. If most consumer endpoints are in AZ-a, the AZ-a NLB node receives most traffic but only distributes to AZ-a targets, overloading them. Enabling cross-zone load balancing allows each AZ's NLB node to distribute to all targets across all AZs, evening out the load. Option B is incorrect — PrivateLink endpoint services require NLB, not ALB. Option C's proxy protocol doesn't solve load distribution. Option D's adding capacity addresses the symptom, not the cause, and wastes resources in underutilized AZs.

---

### Question 52
A company has a SageMaker real-time endpoint serving a recommendation model. During peak shopping events (Black Friday, Prime Day), the endpoint experiences cold start issues because auto-scaling can't add instances fast enough. The endpoint goes from 5 instances (baseline) to needing 50 instances within 10 minutes. Current auto-scaling uses target tracking on InvocationsPerInstance with a 5-minute warm-up time.

A) Configure scheduled scaling to pre-scale to 50 instances before known events. Set target tracking as a secondary policy for organic scaling. Reduce the warm-up time to 2 minutes by optimizing the container startup.
B) Set the endpoint's minimum instance count to 50 permanently to avoid scaling delays. Use Reserved Instances for cost optimization.
C) Implement a custom CloudWatch metric that predicts traffic based on website visitor count (a leading indicator). Create a step scaling policy based on this metric with aggressive scaling steps. Pre-warm the model container to reduce instance startup time.
D) Combine scheduled scaling for known events (pre-scale to 50 instances) with predictive scaling using a custom Lambda function that analyzes historical traffic patterns and adjusts the scheduled scaling actions. Use async inference for overflow traffic during scaling to prevent request failures.

**Correct Answer: D**

**Explanation:** This combines multiple strategies for comprehensive handling. Scheduled scaling pre-provisions for known events (Black Friday, Prime Day) based on historical data. The custom predictive scaling via Lambda analyzes patterns to automatically set appropriate scheduled actions, adapting to year-over-year growth. Async inference as a fallback during the scaling gap ensures no request failures — requests that can't be served in real-time are queued for processing when capacity catches up. This is critical for the window between demand spike and capacity availability. Option A's scheduled-only approach requires manual management for each event and doesn't handle unexpected spikes. Option B's permanent over-provisioning is wasteful (10x capacity maintained 24/7). Option C's leading indicator metric is creative but adds complexity and may not predict accurately.

---

### Question 53
A company operates a Network Firewall that inspects 5 Gbps of traffic. After enabling detailed stateful inspection logging, the team discovers that firewall costs have increased by 60% due to the logging data volume. The logs are sent to CloudWatch Logs at $0.50/GB and total 2 TB per month. The team needs comprehensive logs for security analysis but must reduce logging costs.

A) Switch from CloudWatch Logs to S3 as the log destination. S3 storage costs $0.023/GB vs CloudWatch's $0.50/GB ingestion. Use Athena for log analysis. Implement log filtering in Network Firewall to log only ALERT and DROP actions (skip PASS).
B) Reduce log verbosity by switching from detailed stateful inspection logs to summary flow logs. This reduces volume by 80% while maintaining visibility.
C) Keep CloudWatch Logs but add a Kinesis Data Firehose stream between Network Firewall and CloudWatch. Use Firehose data transformation (Lambda) to filter and compress logs before delivery.
D) Disable stateful logging and rely on VPC Flow Logs for network visibility. Flow Logs are less expensive and provide sufficient metadata for security analysis.

**Correct Answer: A**

**Explanation:** Two optimizations significantly reduce costs. First, sending logs to S3 instead of CloudWatch Logs reduces the per-GB cost from $0.50 to $0.023 (ingestion) — a 96% reduction on storage/ingestion costs for the same data. Second, filtering logs to capture only ALERT (suspicious traffic matched by rules) and DROP (blocked traffic) actions eliminates the high-volume PASS logs (permitted traffic) that are typically less useful for security analysis. This retains the security-relevant logs while dramatically reducing volume. Athena provides ad-hoc query capability on S3 logs. Option B's summary flow logs lose the detailed information needed for security incident investigation. Option C adds Firehose and Lambda costs. Option D's VPC Flow Logs lack the deep packet inspection information that Network Firewall provides.

---

## Domain 4: Accelerate Workload Migration and Modernization (Questions 54–62)

### Question 54
A company is migrating a self-managed Kubernetes cluster (1.24) from their data center to Amazon EKS (latest version). The cluster runs 150 microservices with custom admission controllers, custom scheduling, Istio service mesh, and Prometheus/Grafana monitoring. The migration must be completed within 3 months with zero downtime for production services.

A) Set up a new EKS cluster with equivalent configuration: VPC CNI, Istio, Prometheus Operator. Migrate workloads incrementally using GitOps (ArgoCD) to deploy to both clusters. Shift traffic gradually using Route 53 weighted routing. Decommission the old cluster after validation.
B) Use EKS Anywhere in the data center as an intermediate step. Migrate the self-managed cluster to EKS Anywhere (standardize on EKS APIs), then migrate from EKS Anywhere to EKS in AWS.
C) Use AWS Application Migration Service to lift-and-shift the Kubernetes nodes as EC2 instances. Reconfigure kubectl to manage the EC2-based cluster. Gradually refactor to use EKS.
D) Export all Kubernetes manifests from the existing cluster. Recreate the cluster in EKS using the exported manifests. Cut over DNS from the old cluster to EKS in a single step.

**Correct Answer: A**

**Explanation:** The incremental migration approach is the safest for zero-downtime requirements. ArgoCD as a GitOps tool can deploy the same workloads to both the on-premises cluster and EKS simultaneously, ensuring consistency. Weighted DNS routing gradually shifts traffic, allowing real-time validation of each service on EKS before full cutover. Custom admission controllers may need adaptation for EKS (e.g., using OPA Gatekeeper or Kyverno), and Istio configuration needs updating for VPC CNI networking. Prometheus Operator with Thanos or Amazon Managed Grafana provides continued monitoring. Option B's EKS Anywhere adds an unnecessary intermediate step. Option C's VM-level migration doesn't result in an EKS cluster. Option D's single-step cutover risks production outage.

---

### Question 55
A company wants to modernize their existing three-tier application running on EC2. The application consists of a React frontend, a Java Spring Boot API, and a PostgreSQL database. The company wants to containerize the application, implement CI/CD, and adopt infrastructure as code. They have no container experience but want to minimize operational overhead. The database is 500 GB with complex stored procedures.

A) Containerize frontend and backend using Docker. Deploy on ECS Fargate for zero infrastructure management. Use RDS PostgreSQL for the database (preserves stored procedures). Use CodePipeline with CodeBuild for CI/CD. Use CDK for infrastructure as code.
B) Containerize all components and deploy on EKS. Use Helm charts for deployment. Deploy PostgreSQL in a container for full portability. Use Jenkins for CI/CD. Use Terraform for IaC.
C) Containerize frontend and backend. Deploy on ECS with EC2 launch type for more control. Migrate PostgreSQL to Aurora PostgreSQL Serverless. Use GitHub Actions for CI/CD. Use CloudFormation for IaC.
D) Use AWS App Runner for the frontend and API. Migrate to Aurora PostgreSQL. Use Copilot CLI for deployment and infrastructure management. Use CodePipeline for CI/CD.

**Correct Answer: A**

**Explanation:** For a team with no container experience, minimizing operational overhead is critical. ECS Fargate eliminates cluster management — no nodes to provision, patch, or scale. RDS PostgreSQL preserves the existing stored procedures without migration effort (Aurora might require minor compatibility adjustments). CodePipeline with CodeBuild provides a fully managed CI/CD pipeline. CDK enables infrastructure as code with familiar programming languages (Java for this team). Option B's EKS has the highest operational complexity and a steep learning curve for teams new to containers. Containerized PostgreSQL loses the managed database benefits and risks data in container failures. Option C's EC2 launch type adds node management. Option D's App Runner is simpler but has limitations for complex Java applications.

---

### Question 56
A company operates a real-time bidding (RTB) platform that must respond to ad bid requests within 100 milliseconds. The platform currently runs on bare-metal servers with kernel-level optimizations. The migration to AWS must maintain the <100ms response time while handling 1 million requests per second. The application uses custom memory-mapped file I/O and requires precise CPU pinning.

A) Use EC2 bare metal instances (i3en.metal or c5.metal) with dedicated tenancy. Disable hyperthreading and configure CPU pinning using cgroups. Use ENA Express for ultra-low latency networking. Deploy NVMe instance store for memory-mapped file I/O. Use Placement Groups with cluster strategy for network proximity.
B) Use EC2 c6i.24xlarge instances with enhanced networking. Deploy in a cluster placement group. Use EBS io2 Block Express for storage. Application Load Balancer for traffic distribution.
C) Use ECS on EC2 with host networking mode for lowest latency. Pin containers to specific CPUs. Use EBS gp3 for storage. Network Load Balancer with cross-zone disabled for AZ-local traffic.
D) Use Lambda with provisioned concurrency for the bid processing. Lambda's managed infrastructure eliminates kernel optimization needs. Use Lambda response streaming for faster first-byte responses.

**Correct Answer: A**

**Explanation:** Bare metal instances provide the necessary control for this ultra-low-latency use case. CPU pinning via cgroups (or taskset/numactl) eliminates context switching overhead on critical processing cores. Disabling hyperthreading ensures dedicated physical core resources. NVMe instance store provides the fastest local I/O for memory-mapped files (microsecond latency vs milliseconds for EBS). ENA Express provides single-digit microsecond network latency between instances in the same placement group. Cluster placement groups ensure all instances are on physically proximate hardware. At 1 million req/s with <100ms latency, every microsecond matters. Option B's EBS adds storage latency. Option C's containerization adds a network namespace overhead. Option D's Lambda cannot meet the latency requirements at this scale.

---

### Question 57
A company wants to migrate their on-premises Apache Airflow-based data pipeline orchestration to AWS. They run 500 DAGs with complex dependencies, use custom Airflow operators for proprietary systems, and need to maintain Python package compatibility. The migration must preserve all existing DAGs with minimal modification.

A) Migrate to Amazon Managed Workflows for Apache Airflow (MWAA). Upload existing DAGs to S3. Install custom operators as plugins. Configure requirements.txt for Python packages. MWAA manages the Airflow infrastructure (web server, scheduler, workers).
B) Deploy Apache Airflow on ECS Fargate using the official Airflow Docker image. Use EFS for shared DAG storage. Configure auto-scaling for Celery workers.
C) Replace Airflow with AWS Step Functions. Convert DAGs to Step Functions state machines. Replace custom operators with Lambda functions calling proprietary systems.
D) Deploy Airflow on EC2 using the same configuration as on-premises. Use Auto Scaling groups for workers. Use RDS for the Airflow metadata database.

**Correct Answer: A**

**Explanation:** Amazon MWAA (Managed Workflows for Apache Airflow) is the managed Airflow service that preserves compatibility with existing DAGs. DAGs are stored in S3 and automatically loaded by MWAA. Custom operators can be installed as Airflow plugins via the plugins.zip file. Python dependencies are specified in requirements.txt, which MWAA installs in the Airflow environment. MWAA manages the infrastructure (web server, scheduler, Celery workers, metadata database) while supporting standard Airflow APIs. This approach requires minimal DAG modification. Option B requires managing Airflow infrastructure on ECS. Option C requires complete rewrite of 500 DAGs, which is impractical. Option D maintains operational overhead of self-managed Airflow.

---

### Question 58
A company has a large SageMaker notebook environment where 100 data scientists each run their own notebook instances. Costs are $40,000/month because instances run 24/7 even though scientists work standard business hours. The company wants to reduce costs while improving collaboration and standardization. Data scientists use both Python and R, and need GPU access for occasional model training.

A) Migrate to SageMaker Studio with JupyterLab. Use SageMaker Studio spaces (formerly apps) that automatically shut down after idle timeout. Configure lifecycle configurations to stop kernels after 1 hour of inactivity. Use shared spaces for collaboration. Use Studio's built-in Git integration for code management.
B) Replace SageMaker notebooks with EC2 instances running JupyterHub. Use Instance Scheduler to stop instances outside business hours. Share notebooks via S3.
C) Keep SageMaker notebook instances but implement auto-stop via lifecycle configurations that check idle time and stop instances. Reduce instance sizes and use on-demand GPU instances only when needed.
D) Migrate to Amazon EMR Notebooks for a shared notebook environment. EMR provides built-in Spark for distributed processing.

**Correct Answer: A**

**Explanation:** SageMaker Studio with its updated JupyterLab interface provides the optimal combination of cost savings and collaboration. Studio spaces automatically shut down after configurable idle timeout, eliminating the 24/7 running cost. Scientists launch sessions on-demand with instant access to their persistent storage. Shared spaces enable real-time collaboration. Studio supports multiple kernel types (Python, R) with different instance types per kernel — scientists can use CPU instances for exploration and switch to GPU instances for training, paying only for active time. Built-in Git integration improves code management. Option B requires managing EC2 infrastructure. Option C's auto-stop helps but notebook instances still have slower startup than Studio spaces. Option D's EMR Notebooks focus on Spark workloads, not general data science.

---

### Question 59
A company has an existing monolithic Java application running on Tomcat servers. They want to adopt a strangler fig pattern to gradually extract microservices. The first service to extract handles user authentication (currently embedded in the monolith). The new auth service must be accessible to both the monolith and new microservices. The migration must be reversible if issues arise.

A) Extract the auth module into a Spring Boot microservice deployed on ECS Fargate. Deploy behind an ALB with path-based routing: /auth/* routes to the new service, all other paths route to the monolith. Implement a feature flag in the monolith to toggle between internal auth and the external auth service. Use API Gateway as a facade in front of the ALB for additional traffic management.
B) Extract auth into a Lambda function behind API Gateway. The monolith calls the Lambda function via HTTPS. New microservices also call Lambda. No load balancer needed.
C) Create a shared library for authentication logic. Deploy the library in both the monolith and new microservices. This avoids the network overhead of a separate service.
D) Extract auth into a microservice on ECS. Use AWS App Mesh to manage traffic between the monolith and the auth service. Implement circuit breakers and retries in App Mesh for resilience. Use weighted routing in App Mesh to gradually shift auth traffic from the monolith's internal implementation to the new service.

**Correct Answer: D**

**Explanation:** App Mesh provides the traffic management capabilities ideal for a strangler fig migration. Weighted routing gradually shifts authentication traffic from the monolith's internal auth to the new service (e.g., start at 5%, increase to 100% over weeks). Circuit breakers and retries ensure resilience during the migration. If issues arise, shifting weight back to 0% (all traffic to monolith auth) provides instant rollback. App Mesh's observability features (distributed tracing via X-Ray, metrics via CloudWatch) enable monitoring of both paths. Option A's feature flag approach works but requires application code changes for routing, while App Mesh handles this at the infrastructure level. Option B's Lambda may add latency for the high-frequency auth calls. Option C doesn't decouple the auth service.

---

### Question 60
A company needs to migrate their on-premises Elasticsearch cluster (7.10) with 20 TB of indexed data to AWS. The cluster supports both a product search feature (customer-facing, latency-sensitive) and a log analytics platform (internal, batch queries). The company wants to optimize costs by separating these workloads. The migration must complete within 2 weeks.

A) Migrate to a single Amazon OpenSearch Service domain running Elasticsearch 7.10 compatibility mode. Use UltraWarm for log data and hot nodes for product search data. Use index lifecycle management (ISM) to migrate log indexes to UltraWarm.
B) Create two separate OpenSearch Service domains: one optimized for product search (hot-only nodes, small instance types with fast EBS) and one for log analytics (UltraWarm + cold storage for cost optimization). Use snapshot/restore from the existing Elasticsearch cluster to migrate data to S3, then restore to the appropriate OpenSearch domains.
C) Migrate product search to Amazon CloudSearch and log analytics to Amazon OpenSearch Service. CloudSearch is simpler and more cost-effective for search workloads.
D) Migrate to Amazon OpenSearch Serverless with two collections: one for search (configured for search workload type) and one for log analytics (configured for time series workload type). No infrastructure management required.

**Correct Answer: B**

**Explanation:** Separating workloads into two domains allows independent optimization. The product search domain needs fast response times: smaller hot-only instances with provisioned IOPS EBS volumes, tuned for search query performance. The log analytics domain uses UltraWarm for recent logs (30 days) and cold storage for older data, dramatically reducing costs for the bulk of 20 TB. Snapshot/restore is the standard Elasticsearch migration method: create a snapshot repository in S3, take snapshots from the source cluster, restore to each target domain. Two weeks is sufficient for 20 TB migration. Option A's single domain can't independently optimize for different access patterns as effectively. Option C's CloudSearch is limited and outdated. Option D's OpenSearch Serverless has collection limits and may be more expensive at 20 TB.

---

### Question 61
A company runs a legacy application that communicates with partner systems using SOAP/XML web services over HTTPS. The company wants to modernize their integration layer to use REST/JSON internally while maintaining SOAP compatibility with partners who cannot change. The solution must transform messages between formats, handle partner-specific message formats, and provide monitoring for all integrations.

A) Deploy Amazon API Gateway with a REST API for internal consumers. Use API Gateway request/response mapping templates (VTL) to transform between REST/JSON and SOAP/XML for partner-facing endpoints. Deploy Lambda functions for complex transformations that VTL cannot handle.
B) Use Amazon MQ with ActiveMQ for message transformation. ActiveMQ's message transformation plugin converts between JSON and XML. Use topics for partner routing.
C) Deploy AWS AppSync with resolver mapping templates for format transformation. Use AppSync's real-time subscriptions for partner notifications.
D) Deploy an integration layer on ECS Fargate using Apache Camel or MuleSoft. These integration frameworks have built-in SOAP-to-REST transformation capabilities. Use ALB for load balancing. Monitor with X-Ray.

**Correct Answer: D**

**Explanation:** Apache Camel (or similar integration frameworks) provides enterprise-grade SOAP-to-REST transformation with support for WSDL parsing, complex XML-to-JSON mapping, partner-specific message format handling, and routing. ECS Fargate provides the compute platform with zero server management. These frameworks handle the complexity of SOAP envelopes, WS-Security headers, XML namespaces, and partner-specific schemas that simpler solutions cannot. X-Ray provides distributed tracing across the integration layer. Option A's VTL templates are limited for complex SOAP transformations (nested namespaces, WS-Security, complex types). Option B's ActiveMQ transformation is limited to simple conversions. Option C's AppSync is designed for GraphQL, not SOAP integration.

---

### Question 62
A company is modernizing a batch processing system that currently runs on a dedicated mainframe during overnight hours. The batch processes 5 million financial transactions, performing validation, enrichment, fee calculation, and settlement. Processing must complete within a 6-hour batch window. Transactions have dependencies — settlement cannot run until all fee calculations are complete. The company wants to move to a serverless architecture on AWS.

A) Use Step Functions with a Distributed Map that processes transactions in parallel from an S3 file. Each iteration runs validation, enrichment, and fee calculation as Lambda functions. After the Map completes, a settlement Lambda processes the aggregated results. DynamoDB stores intermediate state.
B) Use AWS Batch with a compute environment sized for the workload. Define job dependencies: validation → enrichment → fee calculation → settlement. Use multi-node parallel jobs for each stage. S3 for intermediate data.
C) Use SQS queues to chain processing stages. Each stage (validation, enrichment, fee calculation) processes messages and sends to the next queue. Settlement triggers when the fee calculation queue is empty. Lambda consumers for each queue.
D) Use Kinesis Data Streams for transaction ingestion. Lambda consumers process each stage in sequence. Use Kinesis Data Analytics for aggregation before settlement. Store results in S3.

**Correct Answer: A**

**Explanation:** Step Functions Distributed Map is designed for large-scale batch processing. It can process millions of items in parallel (up to 10,000 concurrent Lambda executions), reading from S3 (where the 5 million transactions are stored as a file). Each transaction flows through validation → enrichment → fee calculation as Lambda steps within the Map iteration. The Map state completes only when ALL iterations finish (handling the dependency requirement), then the settlement step runs with aggregated results. DynamoDB provides fast intermediate state storage for enrichment lookups. The 6-hour window is easily achievable with parallel processing. This is truly serverless — no servers to manage. Option B's Batch requires managing compute environments. Option C's SQS "empty queue" detection is unreliable for triggering settlement. Option D's Kinesis is designed for streaming, not batch processing.

---

## Domain 5: Design for Cost Optimization (Questions 63–75)

### Question 63
A company runs 50 SageMaker training jobs per week, each using 8 ml.p4d.24xlarge instances for 4 hours. The on-demand cost is $37.688/hour/instance, totaling approximately $60,000/month. Training jobs can tolerate interruptions with checkpoint support. The company wants to reduce training costs by at least 60%.

A) Use SageMaker Managed Spot Training with checkpointing enabled. Spot pricing for p4d.24xlarge instances provides up to 90% discount. Configure max_wait_time to handle Spot capacity delays. Store checkpoints in S3 for automatic restart.
B) Purchase SageMaker Savings Plans for ml.p4d.24xlarge instances. 1-year commitment provides approximately 40% discount.
C) Use smaller instance types (ml.p3.16xlarge) with longer training times to reduce per-hour costs. Trade time for cost.
D) Consolidate training jobs to run fewer, larger jobs (16 instances for 2 hours instead of 8 for 4 hours) to reduce total instance-hours.

**Correct Answer: A**

**Explanation:** SageMaker Managed Spot Training provides 60-90% discounts on GPU instances. For p4d.24xlarge, Spot savings are typically 70-90%, easily exceeding the 60% target. Managed Spot Training handles the complexity of Spot interruptions automatically: it saves checkpoints to S3 at configurable intervals, and if interrupted, automatically acquires new Spot capacity and resumes from the last checkpoint. max_wait_time prevents jobs from waiting indefinitely for Spot capacity. At $60,000/month baseline, even 60% Spot savings reduces costs to $24,000/month. Option B's Savings Plans only save ~40%, not meeting the 60% target. Option C's smaller instances may actually increase costs due to longer training times (data parallelism efficiency decreases). Option D doesn't reduce costs — the same total instance-hours cost the same amount.

---

### Question 64
A company operates a Transit Gateway connecting 100 VPCs. The monthly Transit Gateway bill is $15,000, primarily from data processing charges ($0.02/GB). Analysis reveals that 60% of traffic is between VPCs in the same Availability Zone, and 25% is VPC-to-internet through a centralized egress VPC. The remaining 15% is genuine cross-VPC communication that requires Transit Gateway. The company wants to reduce networking costs.

A) For same-AZ VPC-to-VPC traffic, establish VPC peering connections (no data processing charges for same-AZ peered traffic). Keep Transit Gateway for cross-AZ and cross-VPC traffic. For egress traffic, evaluate whether a distributed NAT Gateway model (per-VPC) is cheaper than centralized egress through Transit Gateway.
B) Replace Transit Gateway entirely with VPC peering for all VPC-to-VPC communication. Use individual NAT Gateways per VPC for internet egress. This eliminates all Transit Gateway charges.
C) Keep the current architecture but negotiate volume discounts on Transit Gateway pricing through AWS Enterprise Support.
D) Migrate to AWS Cloud WAN which has different pricing that may be more cost-effective at this scale.

**Correct Answer: A**

**Explanation:** The targeted approach optimizes each traffic pattern. VPC peering for same-AZ traffic eliminates 60% of Transit Gateway data processing charges because VPC peering has no data processing charge for same-AZ traffic ($0/GB vs $0.02/GB). This saves 60% × $15,000 = $9,000/month. The egress traffic evaluation is important: centralized egress adds Transit Gateway data processing ($0.02/GB) on top of NAT Gateway data processing ($0.045/GB). Distributed NAT Gateways eliminate the Transit Gateway charge but add per-VPC NAT Gateway hourly costs. The math depends on traffic volume per VPC. Genuine cross-VPC traffic (15%) remains on Transit Gateway. Option B's full VPC peering replacement doesn't scale for 100 VPCs (4,950 peering connections) and loses Transit Gateway's routing features. Option C doesn't reduce architectural inefficiency. Option D's Cloud WAN pricing may not be cheaper for this specific pattern.

---

### Question 65
A company uses Amazon Bedrock extensively across multiple teams. Their monthly Bedrock bill has grown to $80,000. Analysis shows: 40% is from a customer service chatbot using Claude 3 Sonnet, 30% from content generation using Claude 3 Opus, 20% from code generation using Claude 3 Sonnet, and 10% from data extraction using Claude 3 Haiku. The company wants to reduce Bedrock costs by 40% without significantly impacting quality.

A) Purchase Provisioned Throughput for the customer service chatbot (highest volume). Switch content generation from Opus to Sonnet (sufficient quality for most content). Cache frequent chatbot responses using ElastiCache. Use Bedrock Batch Inference for non-time-sensitive content generation.
B) Switch all workloads to Claude 3 Haiku for maximum cost savings. Haiku is 25x cheaper than Opus and 12x cheaper than Sonnet.
C) Implement prompt engineering optimization: reduce prompt lengths by removing redundant instructions, use shorter system prompts, implement prompt caching for repetitive prefixes, and optimize output lengths with stop sequences. Additionally, evaluate switching content generation from Opus to Sonnet.
D) Build custom models on SageMaker to replace Bedrock. Self-hosted models have no per-token charges after the training investment.

**Correct Answer: C**

**Explanation:** Prompt engineering optimization provides the broadest cost reduction across all workloads. Reducing prompt token count directly reduces cost (Bedrock charges per input/output token). Prompt caching stores repeated prompt prefixes, avoiding re-processing costs on subsequent calls. Shorter system prompts reduce per-request costs across millions of calls. Stop sequences prevent unnecessary token generation. Switching content generation from Opus to Sonnet provides significant savings (Opus is ~5x more expensive) while Sonnet produces high-quality content for most use cases. These optimizations combined can achieve 40% reduction without impacting quality significantly. Option A's Provisioned Throughput saves money only at very high sustained volumes. Option B's Haiku would significantly degrade quality for chatbot and code generation. Option D's self-hosted models require ML engineering expertise and ongoing operational costs.

---

### Question 66
A company runs a data lake on S3 with heavy cross-region data transfer for a DR site. Their monthly data transfer costs are: $15,000 for S3 Cross-Region Replication (150 TB/month from us-east-1 to us-west-2), $5,000 for EC2 cross-region traffic (50 TB/month), and $3,000 for VPC endpoint traffic. The company wants to reduce cross-region data transfer costs.

A) Replace real-time CRR with S3 Batch Replication on a daily schedule for non-critical data. Keep CRR only for critical data needing <15-minute RPO. This reduces replication volume by 70%. Use S3 Intelligent-Tiering in the DR region to reduce storage costs.
B) Move the DR site to a different AZ in the same region instead of a different region. Intra-region data transfer is much cheaper ($0.01/GB vs $0.02/GB).
C) Implement compression on data before S3 replication to reduce transfer volume. Use S3 lifecycle policies to replicate only data less than 30 days old. Enable S3 Replication Time Control for critical data.
D) Use AWS Backup for DR instead of S3 CRR. AWS Backup can create cross-region backup copies at scheduled intervals, reducing continuous replication costs. Combine with S3 Glacier for DR storage.

**Correct Answer: A**

**Explanation:** Not all data in a data lake requires real-time cross-region replication. By analyzing data criticality, the company can apply tiered replication: real-time CRR for critical data (transactional data, customer records) requiring low RPO, and daily batch replication for non-critical data (logs, analytics, historical data). If 70% of the 150 TB is non-critical, daily batch replication reduces the peak transfer volume and can be scheduled during off-peak hours. This approach maintains DR capability while reducing the effective cross-region transfer cost. Option B compromises the DR strategy — same-region DR doesn't protect against regional outages. Option C's compression helps but doesn't address the fundamental volume issue. Option D's AWS Backup is for resource-level backups, not data lake replication.

---

### Question 67
A company has deployed AWS Network Firewall and Gateway Load Balancer for security inspection. The monthly costs are: Network Firewall $8,000 (data processing: 400 TB), GWLB $4,000 (data processing: 200 TB), and NAT Gateway $9,000 (data processing: 200 TB). The company wants to reduce network infrastructure costs without reducing security posture.

A) Analyze traffic patterns to identify traffic that doesn't require inspection (e.g., AWS API calls to VPC endpoints, health checks, internal monitoring). Create bypass rules or route exceptions for trusted internal traffic. This reduces Network Firewall data processing volume.
B) Replace Network Firewall and GWLB with open-source alternatives (iptables/Suricata) on EC2 instances. Eliminate the per-GB processing charges.
C) Consolidate Network Firewall and GWLB into a single inspection layer. Currently traffic traverses both, doubling data processing charges on 200 TB. If the GWLB-attached third-party firewall can provide the same rules as Network Firewall, eliminate the Network Firewall for that traffic flow.
D) Reduce NAT Gateway costs by implementing S3 and DynamoDB gateway endpoints (free) to divert traffic from NAT Gateway. Evaluate if other AWS services can use interface endpoints to reduce NAT Gateway data processing.

**Correct Answer: D**

**Explanation:** NAT Gateway at $9,000 is the highest cost component and often the easiest to optimize. S3 and DynamoDB gateway endpoints are free and remove traffic from the NAT Gateway processing path. At $0.045/GB, even diverting 100 TB of S3/DynamoDB traffic saves $4,500/month. Interface endpoints for other AWS services (ECR, CloudWatch, SQS, etc.) cost $0.01/GB vs NAT Gateway's $0.045/GB — a 78% reduction per GB. While Options A and C are also valid optimizations, Option D addresses the largest cost component with the simplest implementation and lowest risk to security posture. Option B introduces operational risk and maintenance burden.

---

### Question 68
A company runs an EKS cluster with 200 pods across 30 nodes (various instance types). The monthly EC2 cost for the cluster is $25,000. Kubernetes resource utilization data shows: average CPU utilization is 35% across all nodes, average memory utilization is 60%, and 20% of pods have resource requests set much higher than actual usage. The company wants to right-size the cluster.

A) Install Kubernetes Vertical Pod Autoscaler (VPA) in recommendation mode to analyze actual resource usage and suggest optimal requests/limits. Apply VPA recommendations to reduce over-provisioned pod requests. Then use Karpenter to consolidate pods onto fewer, right-sized nodes. This reduces node count by matching actual resource needs.
B) Reduce all pod resource requests by 50% across the board to improve bin-packing. Monitor for OOM kills and increase if needed.
C) Switch all instances to Spot Instances for 70% cost savings. Use diversified instance types with Karpenter.
D) Use AWS Compute Optimizer to analyze EC2 instance utilization and switch to recommended instance types. This doesn't require Kubernetes-level changes.

**Correct Answer: A**

**Explanation:** The root cause of cost inefficiency is two-fold: over-provisioned pod resource requests (pods request more CPU/memory than they use) and Kubernetes scheduling based on these inflated requests (nodes appear full while actual utilization is low). VPA in recommendation mode safely analyzes actual resource usage patterns and suggests optimal requests/limits without disrupting running pods. After applying VPA recommendations, pods' resource requests decrease, enabling better bin-packing. Karpenter then consolidates workloads onto fewer, appropriately-sized nodes (it considers the reduced resource requests when selecting instance types). This systematic approach can reduce node count by 30-50%. Option B's blind 50% reduction risks production outages. Option C addresses pricing but not the utilization problem. Option D's Compute Optimizer sees EC2 metrics, not Kubernetes-level resource allocation.

---

### Question 69
A company uses Amazon OpenSearch Service for log analytics with a 90-day retention period. The cluster has 20 r6g.2xlarge data nodes with 4 TB EBS each (80 TB total). Monthly cost is $22,000. Log volume is 1 TB/day, and queries mostly access the last 7 days. Occasional compliance queries access older data but accept 30-second response times.

A) Implement hot-warm-cold architecture: reduce hot nodes to 5 (r6g.2xlarge with gp3 EBS for 7 days of data), add 3 UltraWarm nodes for 8-30 day data, and use cold storage (S3-backed) for 31-90 day data. Index lifecycle policies automatically migrate data between tiers.
B) Reduce the cluster to 10 data nodes and lower the retention period to 30 days. Archive older logs to S3 and use Athena for compliance queries.
C) Switch to OpenSearch Serverless with time-series collection type. Serverless automatically manages capacity and storage tiering. Pay for indexed data and compute OCUs.
D) Compress older indices (enable best_compression codec) and merge segments to reduce storage. Force-merge old indices to single segments.

**Correct Answer: A**

**Explanation:** The hot-warm-cold architecture perfectly matches the access patterns. Hot nodes (r6g.2xlarge with fast gp3 EBS) serve the frequently queried last 7 days — only 5 hot nodes needed for 7 TB. UltraWarm nodes (S3-backed with local caching) store 8-30 day data at ~70% lower cost per GB than hot storage. Cold storage (S3-backed, attached on demand) handles 31-90 day data at the lowest cost — queries take longer but meet the 30-second compliance requirement. Index Lifecycle Management (ILM/ISM) automates data movement between tiers. This reduces costs by ~60% by matching storage tier to access frequency. Option B loses data that may be needed for compliance. Option C's Serverless may actually be more expensive at 1 TB/day ingestion. Option D reduces storage size but doesn't change the instance cost.

---

### Question 70
A company processes customer images using a SageMaker inference pipeline. Each image goes through three models sequentially: object detection, classification, and quality scoring. The current architecture uses three separate real-time endpoints (each with 4 ml.m5.xlarge instances). Total monthly cost is $10,000. Average request volume is 100 requests per minute with 5x spikes during events.

A) Consolidate all three models into a SageMaker Inference Pipeline on a single endpoint. This serves all three models sequentially in a single API call, reducing from 12 instances to 4 instances. Enable auto-scaling to handle 5x spikes.
B) Consolidate into a single endpoint with a custom container that hosts all three models. Use SageMaker Serverless Inference for automatic scaling to zero during idle periods and scaling up during events.
C) Keep separate endpoints but switch to SageMaker Serverless Inference for each. At 100 req/min baseline, serverless pricing may be cheaper than provisioned instances. Serverless handles spikes automatically.
D) Combine models into a single model with multi-task learning. Deploy on one endpoint with fewer instances. This eliminates inter-model latency as well.

**Correct Answer: C**

**Explanation:** At 100 requests per minute (1.67 req/s), the workload is light enough that provisioned instances (12 total) are significantly over-provisioned for the baseline load. SageMaker Serverless Inference charges per inference request (milliseconds of compute used) with no idle costs. At 100 req/min with average processing time, serverless costs are roughly $2-3 per hour vs $12/hour for 12 provisioned instances. During 5x spikes, serverless scales automatically with no pre-provisioning needed. The 3 separate serverless endpoints maintain architectural simplicity. For model pipeline scenarios at low-to-moderate traffic, serverless provides dramatic savings. Option A reduces instances but still pays for idle capacity. Option B's custom container with serverless works but adds container management complexity. Option D requires model retraining and may reduce accuracy.

---

### Question 71
A company has a multi-account AWS Organization with 100 accounts. Each account runs its own NAT Gateway for internet access, costing $500/month per account ($50,000/month total for NAT Gateway hourly charges alone, before data processing). Most accounts have minimal internet-bound traffic (less than 10 GB/month per account). The company wants to reduce NAT Gateway costs.

A) Centralize internet egress through a shared services VPC with NAT Gateways, connected via Transit Gateway. Replace individual NAT Gateways in spoke accounts with Transit Gateway routes to the centralized egress VPC. This reduces from 100+ NAT Gateways to 3-6 (multi-AZ in central VPC).
B) Replace NAT Gateways with NAT Instances (t3.nano) in each account. NAT instances cost $3.75/month vs $32.40/month for NAT Gateways.
C) Remove NAT Gateways from accounts that need only AWS API access. Use VPC endpoints for AWS services. Deploy NAT Gateways only in accounts that need third-party internet access.
D) Use IPv6 for all outbound internet traffic, eliminating the need for NAT Gateways. IPv6 addresses are publicly routable.

**Correct Answer: C**

**Explanation:** Many accounts use NAT Gateways primarily for AWS API access (ECR image pulls, CloudWatch, S3, etc.). VPC gateway and interface endpoints provide private connectivity to these services without internet access. For accounts that only need AWS service access, removing the NAT Gateway entirely and using VPC endpoints eliminates the $32.40/month hourly charge plus data processing charges. Only accounts requiring third-party internet access need NAT Gateways. This approach provides targeted cost reduction with minimal architectural change. At 10 GB/month per account, VPC endpoint data processing ($0.01/GB) is negligible. Option A's centralized egress adds Transit Gateway costs ($0.05/hour per attachment × 100 accounts = $360/month) plus data processing. Option B's NAT instances lack high availability and are operationally burdensome. Option D requires application and infrastructure changes for IPv6.

---

### Question 72
A company deploys ML models on SageMaker with the following endpoint configuration: 3 endpoints running 24/7, each with 4 ml.g5.2xlarge instances. The endpoints serve traffic only during US business hours (8 AM - 8 PM EST, Monday-Friday). Outside business hours, the endpoints receive zero traffic. Monthly cost is $35,000.

A) Implement scheduled auto-scaling: scale to 4 instances at 7:45 AM EST and scale to 1 instance at 8:15 PM EST on weekdays. Scale to 0 instances (delete endpoints) on weekends and recreate Monday morning using a Lambda function.
B) Switch to SageMaker Serverless Inference endpoints. They scale to zero when not in use and scale up during business hours. No traffic means no cost outside business hours.
C) Implement auto-scaling with a minimum of 1 instance and maximum of 4. Scale based on InvocationsPerInstance metric. During off-hours with zero traffic, the endpoint scales to minimum 1 instance.
D) Keep the current configuration but purchase SageMaker Savings Plans for ml.g5.2xlarge instances. The 1-year commitment provides approximately 40% discount.

**Correct Answer: B**

**Explanation:** SageMaker Serverless Inference is the optimal solution for workloads with clear idle periods. When no requests arrive (evenings, nights, weekends), serverless endpoints have zero cost. During business hours, they scale to handle traffic and charge per request duration. For this workload with 12 hours of active use per day on weekdays only (60 hours/week out of 168), the idle period is 64%. Serverless eliminates 100% of idle cost. At moderate request volumes during business hours, serverless per-request pricing is often cheaper than provisioned instances. Option A's scheduled scaling still pays for 1 instance minimum during off-hours and requires complex management for endpoint deletion/recreation. Option C's minimum 1 instance still incurs cost 24/7. Option D's 40% savings is less than the 64% idle elimination.

---

### Question 73
A company streams video content from S3 through CloudFront. Their monthly costs are: CloudFront data transfer $30,000 (300 TB/month), S3 GET requests $2,000, and origin data transfer $0 (same region S3). Analysis shows that 60% of video content is watched only once (long-tail niche content), while 40% is popular content watched repeatedly. The company wants to reduce content delivery costs.

A) Implement CloudFront Origin Shield in the origin region. Shield creates a caching layer that reduces origin fetches for popular content. For long-tail content accessed once, Shield doesn't help but doesn't hurt.
B) Use CloudFront price class 100 or 200 to restrict edge locations to lower-cost regions. This reduces per-GB data transfer pricing at the expense of higher latency for users in excluded regions.
C) Negotiate a CloudFront Security Savings Bundle (commit to monthly spend for up to 30% discount). Additionally, implement adaptive bitrate streaming to reduce video quality (and file size) for viewers on slower connections, reducing total data transfer.
D) Migrate long-tail content to a cheaper CDN (or serve it directly from S3 with Transfer Acceleration) and keep popular content on CloudFront. Popular content has high cache hit ratio on CloudFront, making it cost-effective. Long-tail content with single views doesn't benefit from CDN caching.

**Correct Answer: C**

**Explanation:** The CloudFront Security Savings Bundle provides up to 30% discount on the $30,000 data transfer — saving $9,000/month. Adaptive bitrate streaming (HLS/DASH) dynamically adjusts video quality based on viewer bandwidth, reducing total bytes transferred for viewers on slower connections. This combination provides the most straightforward cost reduction without architectural changes. Option A's Origin Shield helps reduce origin load but the origin is free S3 in the same region, so origin cost savings are minimal (only S3 GET request reduction). Option B reduces access to edge locations, degrading user experience. Option D's multi-CDN approach adds operational complexity and long-tail content served from S3 directly still incurs data transfer costs.

---

### Question 74
A company runs a Kubernetes cluster on EKS with a mix of workload types: stateless API servers (can tolerate interruptions), stateful databases (cannot tolerate interruptions), batch processing jobs (flexible scheduling), and development/testing workloads (non-critical). All workloads currently run on On-Demand instances. Monthly EC2 cost is $40,000.

A) Use Karpenter with multiple provisioners: Spot Instances for stateless APIs and batch jobs (using node affinity and tolerations), On-Demand for stateful databases (using pod anti-affinity for HA), and Spot for dev/test with aggressive consolidation. Purchase Compute Savings Plans for the On-Demand baseline.
B) Move all workloads to Spot Instances with Karpenter's consolidation feature. Use pod disruption budgets (PDBs) to protect stateful workloads from Spot interruptions.
C) Use EKS Fargate for all workloads. Fargate pricing is per-vCPU-hour and per-GB-hour, which may be cheaper at this scale. No node management needed.
D) Implement cluster right-sizing with Goldilocks VPA recommendations first. Reduce total pod resource requests, then consolidate onto fewer On-Demand instances.

**Correct Answer: A**

**Explanation:** Tiered instance purchasing matches workload characteristics to pricing models. Stateless APIs and batch jobs are ideal for Spot (tolerant of interruptions, easily rescheduled) — 60-90% savings. Stateful databases require On-Demand for stability (Spot interruptions would cause database restarts and potential data issues). PDBs alone aren't sufficient protection for databases on Spot — the 2-minute warning may not be enough for graceful database shutdown. Compute Savings Plans for the On-Demand database baseline provide ~30% additional savings. Karpenter provisioners with node selectors and tolerations ensure workloads land on appropriate instance types. Option B puts databases at risk on Spot. Option C's Fargate may be more expensive at this scale. Option D helps but doesn't leverage Spot pricing.

---

### Question 75
A company is evaluating the total cost of ownership for running their ML inference workload. The current architecture uses 10 ml.g5.2xlarge SageMaker endpoints 24/7. The workload processes 50 million inference requests per month with an average latency of 15ms. The company is considering alternatives to reduce costs while maintaining the same throughput and latency.

A) Migrate inference to AWS Inferentia2 instances (inf2.xlarge) on EKS. Compile models using AWS Neuron SDK. Inferentia2 provides up to 4x price-performance improvement over GPU instances for supported model types.
B) Keep SageMaker but switch to ml.inf2.xlarge instances. SageMaker supports Inferentia instances natively. Compile models with Neuron SDK and deploy to SageMaker endpoints with the same auto-scaling configuration.
C) Migrate to Lambda-based inference using container images. At 50 million requests/month (19 req/s average), Lambda pricing is competitive with provisioned instances, especially with no idle costs.
D) Use EC2 Spot g5 instances with a custom inference server (Triton) for maximum cost savings. Spot provides 60-70% discount on g5 instances.

**Correct Answer: B**

**Explanation:** AWS Inferentia2 (inf2) instances provide significantly better price-performance for inference workloads compared to GPU instances. On SageMaker, switching to ml.inf2.xlarge maintains the managed endpoint benefits (auto-scaling, monitoring, A/B testing) while reducing per-instance cost. Inferentia2's hardware is optimized for inference (vs. GPUs designed for training and inference), providing higher throughput per dollar for supported model architectures. The Neuron SDK compiles models for the Inferentia chip. This approach provides the easiest migration path — same SageMaker infrastructure with a different instance type. Option A's EKS migration adds operational complexity. Option C's Lambda has cold start latency and execution time limits that may not maintain 15ms latency. Option D's Spot has interruption risks for a real-time service.

---

## Answer Key

| # | Answer | # | Answer | # | Answer | # | Answer | # | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | C | 16 | A | 31 | A | 46 | A | 61 | D |
| 2 | C | 17 | A | 32 | A | 47 | A | 62 | A |
| 3 | B | 18 | A | 33 | C | 48 | A | 63 | A |
| 4 | A | 19 | A | 34 | A | 49 | A | 64 | A |
| 5 | A | 20 | A | 35 | A | 50 | C | 65 | C |
| 6 | C | 21 | C | 36 | A | 51 | A | 66 | A |
| 7 | A | 22 | B | 37 | A | 52 | D | 67 | D |
| 8 | D | 23 | D | 38 | A | 53 | A | 68 | A |
| 9 | A | 24 | B | 39 | A | 54 | A | 69 | A |
| 10 | A | 25 | D | 40 | B | 55 | A | 70 | C |
| 11 | C | 26 | B | 41 | B | 56 | A | 71 | C |
| 12 | D | 27 | A | 42 | A | 57 | A | 72 | B |
| 13 | C | 28 | A | 43 | A | 58 | A | 73 | C |
| 14 | A | 29 | A | 44 | D | 59 | D | 74 | A |
| 15 | B | 30 | A | 45 | A | 60 | B | 75 | B |
