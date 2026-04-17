# Hybrid Cloud Architectures

## Introduction

Hybrid cloud is one of the most tested architecture patterns on the AWS Solutions Architect Associate exam. In the real world, very few organizations are 100% cloud-native from day one. Most enterprises operate in a hybrid state — running workloads both on-premises and in the AWS cloud — for months or years during migration, and sometimes permanently for regulatory, latency, or data sovereignty reasons.

This article covers every AWS service and design pattern you need to understand for hybrid cloud scenarios on the SAA-C03 exam: from edge computing options (Outposts, Local Zones, Wavelength) to hybrid networking (Direct Connect, VPN, Transit Gateway), hybrid storage (Storage Gateway), hybrid identity (AD, federation), and hybrid compute (ECS/EKS Anywhere, VMware Cloud on AWS).

---

## Hybrid Cloud Design Patterns on AWS

### Why Hybrid Cloud?

Organizations adopt hybrid cloud for several reasons:

1. **Migration in progress** — Workloads are being moved incrementally; both environments coexist during transition
2. **Data residency / sovereignty** — Regulations require certain data to remain on-premises or in a specific geographic location
3. **Low-latency requirements** — Applications need sub-millisecond response times achievable only with local compute
4. **Legacy dependencies** — Mainframes, proprietary hardware, or applications that cannot be refactored
5. **Burst capacity** — On-premises baseline with cloud burst for peak demand
6. **Disaster recovery** — Cloud as the DR site for on-premises production workloads

### Core Hybrid Patterns

| Pattern | Description | Key Services |
|---------|-------------|--------------|
| **Extend to Cloud** | On-prem primary, cloud for specific workloads | VPN, Direct Connect, Storage Gateway |
| **Cloud-First with On-Prem Footprint** | Cloud primary, on-prem for latency or regulatory needs | Outposts, Local Zones |
| **Burst to Cloud** | On-prem steady state, cloud for peak loads | Auto Scaling, Direct Connect |
| **DR to Cloud** | On-prem production, cloud DR site | DRS, S3, AMIs, Route 53 |
| **Edge Computing** | Cloud management, edge execution | Wavelength, Greengrass, Snowball Edge |
| **Tiered Storage** | Hot data on-prem, warm/cold in cloud | Storage Gateway, S3, Glacier |

---

## AWS Outposts

### What is AWS Outposts?

AWS Outposts is a fully managed service that extends AWS infrastructure, services, APIs, and tools to your on-premises data center. AWS owns, operates, installs, and maintains the hardware — you simply consume it like any other AWS service, but the physical equipment sits in your facility.

### Outposts Rack vs Outposts Servers

**Outposts Rack:**
- Full 42U rack form factor
- Starts at 1 rack, scalable to 96 racks
- Provides a wide range of AWS compute and storage services
- Connected to the nearest AWS Region via a Service Link (private or public connectivity)
- Requires dedicated space, power (5–15 kW per rack), cooling, and network connectivity
- Minimum commitment is a 3-year term

**Outposts Servers (1U/2U):**
- Individual 1U or 2U server form factor
- Designed for locations with limited space (branch offices, retail stores, factories)
- Supports EC2 and EBS only (smaller service footprint than Rack)
- Still fully managed by AWS
- Ideal when you cannot accommodate a full rack

### Services Available on Outposts

| Service | Availability | Notes |
|---------|-------------|-------|
| Amazon EC2 | Yes | Multiple instance families (C5, M5, R5, G4dn, etc.) |
| Amazon EBS | Yes | gp2 and io1 volumes |
| Amazon S3 on Outposts | Yes | Local object storage with S3 API compatibility |
| Amazon RDS | Yes | MySQL, PostgreSQL, SQL Server |
| Amazon ECS | Yes | Container orchestration |
| Amazon EKS | Yes | Kubernetes on Outposts |
| Amazon EMR | Yes | Big data processing |
| AWS App Mesh | Yes | Service mesh |
| Application Load Balancer | Yes | Layer 7 load balancing |
| AWS IoT Greengrass | Yes | Edge IoT |

### S3 on Outposts

- Provides local object storage using the S3 API
- Data is stored locally on the Outpost (it does NOT replicate to the Region)
- Uses **S3 access points** and **endpoint connections** for access
- Objects stored in a new storage class: `OUTPOSTS`
- Maximum capacity depends on the Outpost configuration
- Data can be copied to regional S3 using **DataSync**
- Use cases: data residency requirements, local processing of large datasets, low-latency access to objects

### Outposts Use Cases (Exam-Relevant)

1. **Data residency** — Data must physically remain in a specific location
2. **Low-latency local processing** — Manufacturing execution systems, real-time analytics
3. **Local data processing** — Process data locally before sending results to the cloud
4. **Migration staging** — Run workloads on AWS APIs on-prem while preparing for full migration
5. **Consistent hybrid experience** — Same APIs, tools (CloudFormation, CDK) in both environments

### Key Exam Points for Outposts

- Outposts is connected back to the parent AWS Region via a **Service Link**
- If the network connection to the Region is lost, instances continue to run but you cannot launch new instances
- Outposts is **not** a disconnected/air-gapped solution — it requires connectivity to the parent Region
- AWS manages the infrastructure (patching, monitoring, replacement)
- You pay for the Outpost capacity, not individual instances

---

## AWS Local Zones

### What are Local Zones?

AWS Local Zones are extensions of an AWS Region placed in large metropolitan areas. They bring select AWS services closer to end users, providing single-digit millisecond latency for latency-sensitive applications.

### How Local Zones Work

- Local Zones are an extension of a parent AWS Region
- You **extend your VPC** into the Local Zone by creating a subnet in the Local Zone
- Instances in the Local Zone subnet have low-latency access to local users
- The Local Zone has a direct connection back to the parent Region for services not available locally
- You opt in to Local Zones in the EC2 console (they are disabled by default)

### Services Available in Local Zones

- Amazon EC2 (select instance types)
- Amazon EBS (gp2, gp3, io1)
- Amazon ECS
- Amazon EKS
- Application Load Balancer
- Amazon FSx
- Amazon ElastiCache
- Amazon RDS (select engines)
- Amazon VPC subnets

### Use Cases

1. **Media & entertainment** — Real-time video rendering, live streaming
2. **Gaming** — Low-latency multiplayer game servers
3. **Machine learning inference** — Low-latency inference at the edge
4. **Ad-tech** — Real-time bidding (RTB) requiring <10ms latency
5. **Financial trading** — Latency-sensitive trading applications
6. **End-user computing** — Virtual desktops close to users (Amazon WorkSpaces)

### Key Exam Points for Local Zones

- Local Zones are **not** separate Regions — they are extensions of a Region
- You create subnets in Local Zones just like in Availability Zones
- Not all services are available in Local Zones
- Internet egress can occur directly from the Local Zone (local internet gateway)
- Ideal when you need AWS services close to a population center but don't need a full Region

---

## AWS Wavelength

### What is AWS Wavelength?

AWS Wavelength embeds AWS compute and storage services at the edge of 5G networks operated by telecommunications carriers (e.g., Verizon, Vodafone, KDDI, SK Telecom). The goal is ultra-low-latency access for mobile devices connected to 5G.

### How Wavelength Works

- **Wavelength Zones** are infrastructure deployments inside telecom carrier data centers at the edge of 5G networks
- Traffic from 5G devices reaches the Wavelength Zone **without leaving the carrier network**, avoiding multiple hops across the internet
- You extend your VPC to include Wavelength Zone subnets
- A **Carrier Gateway** allows inbound traffic from the carrier network and outbound traffic to the internet or back to the parent Region

### Key Components

| Component | Description |
|-----------|-------------|
| **Wavelength Zone** | AWS infrastructure inside the carrier data center |
| **Carrier Gateway** | Enables connectivity from the carrier network to the Wavelength Zone |
| **Carrier IP** | Public IP address assigned from the carrier's IP pool |
| **VPC Extension** | Your VPC is extended to include Wavelength Zone subnets |

### Use Cases

1. **Connected vehicles** — Vehicle-to-everything (V2X) communication, autonomous driving
2. **Interactive live streaming** — Real-time interactive media over 5G
3. **AR/VR** — Augmented and virtual reality applications requiring ultra-low latency
4. **Real-time gaming** — Cloud gaming at 5G edge
5. **ML inference at edge** — Real-time inference for 5G-connected devices
6. **Smart factories** — IoT applications on 5G private networks

### Key Exam Points for Wavelength

- Think "5G edge" whenever you see Wavelength
- Traffic stays on the carrier network (does not traverse the public internet)
- Very limited service footprint: EC2, EBS, VPC, ECS, EKS
- The **Carrier Gateway** is unique to Wavelength (don't confuse with NAT Gateway or Internet Gateway)

---

## Outposts vs Local Zones vs Wavelength — Comparison

| Feature | Outposts | Local Zones | Wavelength |
|---------|----------|-------------|------------|
| **Location** | Your data center | Metro area (AWS-operated) | Carrier data center (5G edge) |
| **Purpose** | AWS in your DC | Low-latency to metro users | Ultra-low-latency to 5G users |
| **Managed by** | AWS (in your facility) | AWS | AWS (in carrier facility) |
| **Network** | Direct Connect / Internet to Region | Dedicated connection to parent Region | Carrier network to parent Region |
| **Target latency** | Depends on on-prem network | Single-digit ms to metro users | Single-digit ms to 5G devices |
| **Services** | Broadest set | Medium set | Smallest set |
| **VPC integration** | Outpost subnet in VPC | Local Zone subnet in VPC | Wavelength Zone subnet in VPC |
| **Key use case** | Data residency, local processing | Media, gaming, ad-tech | 5G applications, AR/VR, V2X |
| **Exam keyword** | "on-premises", "data residency" | "low latency to end users", "metro" | "5G", "mobile edge", "carrier" |

**Exam Tip:** If the question mentions needing AWS services **in your data center**, the answer is Outposts. If it mentions **low latency to end users in a city**, the answer is Local Zones. If it mentions **5G** or **mobile edge**, the answer is Wavelength.

---

## VMware Cloud on AWS

### What is It?

VMware Cloud on AWS lets you run VMware vSphere-based workloads on dedicated, single-tenant AWS hardware within AWS data centers. It's jointly engineered by VMware and AWS.

### Key Features

- Runs the full VMware SDDC stack: vSphere, vSAN, NSX, vCenter
- Workloads run on bare-metal AWS infrastructure
- Direct, high-bandwidth, low-latency access to native AWS services
- Managed and maintained by VMware
- vCenter integration — manage cloud and on-premises vSphere environments from a single vCenter

### Use Cases

1. **Migrate VMware workloads to AWS** — Lift-and-shift without re-architecting, using VMware HCX for migration
2. **Extend on-premises VMware environment** — Consistent operations across on-premises and cloud
3. **Disaster recovery** — Use VMware Site Recovery with AWS as the DR target
4. **Dev/test environments** — Spin up VMware environments on-demand without procuring hardware
5. **Data center consolidation** — Reduce on-premises footprint by moving VMware workloads to AWS

### Key Exam Points

- The question will specifically mention **VMware** — that's your signal
- VMware Cloud on AWS is NOT the same as running EC2 instances
- It provides a consistent VMware experience (same tools, same processes)
- Useful when customers want to migrate VMware workloads **without converting VMs to AMIs**

---

## Storage Gateway Integration Patterns

### Overview

AWS Storage Gateway is a hybrid cloud storage service that gives you on-premises access to virtually unlimited cloud storage. It provides a standard set of storage protocols (NFS, SMB, iSCSI, iSCSI VTL) and connects to S3, S3 Glacier, EBS, and AWS Backup behind the scenes.

Storage Gateway runs as a VM on-premises (VMware ESXi, Hyper-V, KVM, or as a hardware appliance) or as an EC2 instance.

### File Gateway (S3 File Gateway)

- **Protocol:** NFS and SMB
- **Backend:** Amazon S3 (Standard, Standard-IA, One Zone-IA, Intelligent-Tiering)
- **Behavior:** Files stored as objects in S3; metadata (permissions, timestamps) stored as S3 object metadata
- **Cache:** Most recently accessed data is cached locally on the gateway for low-latency access
- **Use cases:**
  - Migrate file shares to S3
  - On-premises applications need file access to cloud-stored data
  - Data lake ingestion from on-premises file servers
  - Backup files to S3

**FSx File Gateway:**
- Similar concept but backed by Amazon FSx for Windows File Server
- Provides SMB access with full Windows NTFS compatibility
- Local cache for frequently accessed data
- Use when Windows file server features (DFS, Active Directory integration) are needed

### Volume Gateway

- **Protocol:** iSCSI
- **Backend:** Amazon S3 (stored as EBS snapshots)
- Two modes:

**Stored Volumes:**
- Entire dataset stored on-premises
- Asynchronously backed up to AWS as EBS snapshots in S3
- Low-latency access to the entire dataset
- Volume size: 1 GiB to 16 TiB
- Use when you need local access to full dataset with cloud backup

**Cached Volumes:**
- Primary data stored in S3
- Frequently accessed data cached locally
- Reduces on-premises storage footprint
- Volume size: 1 GiB to 32 TiB
- Use when you want to reduce on-premises storage costs

### Tape Gateway (VTL)

- **Protocol:** iSCSI Virtual Tape Library
- **Backend:** Amazon S3 and S3 Glacier / Glacier Deep Archive
- Presents a virtual tape library to existing backup software (Veeam, Veritas, Commvault, etc.)
- Virtual tapes stored in S3; archived tapes in Glacier/Glacier Deep Archive
- **Use case:** Replace physical tape backup infrastructure with cloud-based backup without changing backup workflows

### Storage Gateway Decision Matrix

| Requirement | Gateway Type |
|-------------|-------------|
| File shares accessible via NFS/SMB backed by S3 | S3 File Gateway |
| Windows file shares with AD integration | FSx File Gateway |
| Block storage (iSCSI) with full local dataset | Volume Gateway (Stored) |
| Block storage (iSCSI) with cloud-primary data | Volume Gateway (Cached) |
| Replace physical tape backup | Tape Gateway |

### Exam Tips for Storage Gateway

- **S3 File Gateway** — Think "NFS/SMB access to S3 from on-premises"
- **Volume Gateway Stored** — Full dataset on-prem, snapshots in cloud
- **Volume Gateway Cached** — Primary data in S3, cache on-prem (exam often asks about reducing on-prem storage)
- **Tape Gateway** — Existing backup software using tapes, migrate to cloud without changing backup process
- Storage Gateway always requires a local VM or hardware appliance on-premises

---

## Direct Connect + VPN for Hybrid Networking

### AWS Direct Connect (DX)

AWS Direct Connect provides a dedicated, private network connection from your on-premises data center to AWS. Key characteristics:

- **Dedicated connection:** Physical fiber connection (1 Gbps, 10 Gbps, 100 Gbps) at a DX location
- **Hosted connection:** Sub-1 Gbps connections (50 Mbps to 10 Gbps) via an AWS Partner
- **Private Virtual Interface (VIF):** Access VPC resources using private IP addresses
- **Public Virtual Interface:** Access AWS public services (S3, DynamoDB) over the DX connection
- **Transit Virtual Interface:** Access VPCs through a Transit Gateway over DX
- **Provisioning time:** Weeks to months (this is important for exam questions about urgent needs)
- **Encryption:** DX traffic is NOT encrypted by default

### Site-to-Site VPN

- IPsec encrypted tunnel over the public internet
- Two tunnels per VPN connection for high availability
- Can be provisioned in minutes (contrast with DX)
- Bandwidth limited by internet connection
- Components:
  - **Virtual Private Gateway (VGW):** AWS side of VPN
  - **Customer Gateway (CGW):** On-premises side of VPN
  - **Customer Gateway Device:** Physical or software appliance on-premises

### DX + VPN Combination

For encrypted connectivity over a private dedicated link:
- Create a VPN connection that uses the DX **Public VIF** as the transport
- This gives you the **reliability and bandwidth of DX** plus **encryption of VPN**
- This is an IPsec VPN running over the DX connection
- Exam loves this: "dedicated, encrypted connection between on-premises and AWS"

### DX High Availability

| HA Level | Configuration |
|----------|--------------|
| **Basic** | Single DX connection (no HA) |
| **Development** | Single DX + VPN backup |
| **Production** | Two DX connections at different DX locations |
| **Maximum** | Two DX connections at different DX locations + VPN backup |

### Key Exam Points for DX + VPN

- DX takes weeks/months to set up; VPN takes minutes
- If the question says "immediately" or "quickly," VPN is the answer (not DX)
- DX is NOT encrypted by default — use VPN over DX for encryption
- DX provides consistent network performance (not over the internet)
- For cost optimization, use DX for steady-state traffic, VPN as backup
- **DX Gateway** allows connecting DX to multiple VPCs across Regions

---

## Route 53 Hybrid DNS

### The Challenge

In hybrid environments, you have DNS zones in both on-premises DNS servers and Route 53. Resources in each environment need to resolve names in the other environment.

### Route 53 Resolver Endpoints

**Inbound Resolver Endpoint:**
- Allows on-premises DNS servers to resolve AWS-hosted domain names
- On-premises servers forward DNS queries to the Inbound Endpoint
- The endpoint has ENIs in your VPC with IP addresses that on-premises servers target
- Traffic flow: On-premises → Inbound Endpoint → Route 53

**Outbound Resolver Endpoint:**
- Allows AWS resources to resolve on-premises domain names
- Route 53 Resolver forwards queries matching specified rules to on-premises DNS
- Uses **Resolver Rules** to define which domains to forward and to which on-premises DNS servers
- Traffic flow: VPC resource → Outbound Endpoint → On-premises DNS

### Resolver Rules

- **Forwarding Rules:** Forward queries for specific domains (e.g., `corp.example.com`) to specified IP addresses (on-premises DNS)
- **System Rules:** Override forwarding rules for specific subdomains
- Rules can be shared across accounts using **AWS RAM (Resource Access Manager)**

### Architecture Example

```
On-premises DNS ←→ DX/VPN ←→ Route 53 Resolver Endpoints ←→ Route 53
     |                                    |
corp.example.com                    aws.example.com
```

### Key Exam Points

- **Inbound:** On-premises resolving AWS names
- **Outbound:** AWS resolving on-premises names
- Both endpoints require ENIs in your VPC (they consume IP addresses)
- Resolver Endpoints work over DX or VPN (private connectivity)
- Often paired with Private Hosted Zones for internal DNS in VPCs

---

## Active Directory Integration

### The Options

AWS provides three options for Active Directory in hybrid environments:

### AWS Managed Microsoft AD

- Full Microsoft Active Directory running on AWS (not just compatible — actual Microsoft AD)
- Runs on Windows Server 2019 on AWS-managed EC2 instances
- Deployed in 2 AZs for high availability (minimum)
- Supports:
  - Group Policy
  - LDAP/LDAPS
  - Kerberos authentication
  - Trust relationships with on-premises AD
  - MFA (with RADIUS)
- **Trust relationship:** You create a two-way forest trust between AWS Managed AD and on-premises AD
- Users in either directory can access resources in both environments
- Supports **one-way and two-way trusts** (incoming, outgoing, or both)

### AD Connector

- A **proxy** (directory gateway) that redirects directory requests to your on-premises AD
- Does NOT store any directory data in AWS
- Requires VPN or Direct Connect to on-premises AD
- Supports: EC2 domain join, AWS Management Console sign-in, Amazon WorkSpaces, Amazon WorkDocs
- Available in **Small** (up to 500 users) and **Large** (up to 5,000 users) sizes
- Use when you want to use your existing on-premises AD without any AD in AWS

### Simple AD

- Standalone managed directory powered by Samba 4 (NOT Microsoft AD)
- Does NOT support trust relationships with Microsoft AD
- Cannot be used for hybrid scenarios (no on-premises integration)
- Low cost for simple directory needs in AWS-only environments
- Not suitable for hybrid architectures

### Decision Matrix

| Requirement | Solution |
|-------------|----------|
| Full AD in AWS with trust to on-premises | AWS Managed Microsoft AD |
| Proxy to on-premises AD, no data in AWS | AD Connector |
| Standalone simple directory, no hybrid | Simple AD |
| Support for MFA via RADIUS | AWS Managed Microsoft AD |
| EC2 instances joining on-premises domain | AD Connector or Managed AD with trust |

### Exam Tips

- If the question mentions **trust relationship**, the answer is AWS Managed Microsoft AD
- If the question says "without storing directory data in AWS," the answer is AD Connector
- AD Connector requires reliable network connectivity to on-premises (VPN or DX)
- Managed Microsoft AD can operate independently if the connection to on-premises is lost

---

## Hybrid Identity: Federation with SAML 2.0 and AWS IAM Identity Center

### SAML 2.0 Federation

SAML 2.0 (Security Assertion Markup Language) enables federated single sign-on (SSO) between your on-premises identity provider (IdP) and AWS.

**How it works:**
1. User authenticates against the on-premises IdP (e.g., ADFS, Okta, Ping)
2. IdP returns a SAML assertion containing the user's identity and roles
3. User's browser posts the SAML assertion to the AWS sign-in endpoint
4. AWS STS `AssumeRoleWithSAML` returns temporary credentials
5. User is signed in to the AWS Management Console or can make API calls

**Key components:**
- **Identity Provider (IdP):** On-premises ADFS, Okta, etc.
- **Service Provider (SP):** AWS
- **SAML Assertion:** XML document asserting user identity and attributes
- **IAM Role:** The role the federated user assumes

### AWS IAM Identity Center (formerly AWS SSO)

AWS IAM Identity Center is the **recommended** approach for managing workforce access to multiple AWS accounts and applications.

- **Central place** to manage SSO access to all AWS accounts in an AWS Organization
- Supports multiple identity sources:
  - IAM Identity Center built-in directory
  - Active Directory (Managed AD or AD Connector)
  - External IdP (Okta, Azure AD, Ping) via SAML 2.0
- **Permission Sets:** Define the level of access (policies) for users/groups
- Supports **attribute-based access control (ABAC)**
- Provides a **user portal** for single sign-on to all assigned accounts and applications

### Federation vs IAM Identity Center

| Feature | SAML 2.0 Federation | IAM Identity Center |
|---------|---------------------|---------------------|
| **Scope** | Single account | Multi-account (Organization) |
| **Management** | Manual IAM role/IdP setup per account | Centralized, automated |
| **User portal** | No (custom) | Yes (built-in) |
| **Recommended** | Legacy / specific use cases | Yes — AWS recommended |
| **Integration** | Any SAML 2.0 IdP | Built-in, AD, external IdP |

### Exam Tips

- **IAM Identity Center** is the answer for "centralized access management across multiple AWS accounts"
- **SAML 2.0 Federation** is the answer for "federate on-premises users to a single AWS account"
- For API access, federated users get **temporary credentials** via STS
- Federation does NOT create IAM users — users assume IAM roles

---

## Hybrid Database Patterns

### Read Replicas On-Premises

While AWS RDS read replicas are cloud-to-cloud, you can achieve hybrid database patterns:

- **RDS Cross-Region Read Replicas** — Place read replicas in a Region closer to on-premises users
- **Self-managed replicas** — Use native database replication (MySQL, PostgreSQL) from an on-premises primary to an EC2-based replica (or vice versa)
- **RDS as primary with on-premises replicas** — Some organizations replicate from RDS to on-premises for local reporting

### AWS Database Migration Service (DMS)

- Migrates databases to AWS with minimal downtime
- Supports **homogeneous** (Oracle → Oracle) and **heterogeneous** (Oracle → Aurora) migrations
- **Continuous replication** (CDC — Change Data Capture) keeps source and target in sync
- Use **AWS SCT (Schema Conversion Tool)** for heterogeneous migrations (converts schema and code)
- DMS can be used for **ongoing replication** in hybrid scenarios, not just one-time migration

### Hybrid Database Architecture Patterns

| Pattern | Description | AWS Services |
|---------|-------------|--------------|
| **Cloud DR for on-prem DB** | Replicate on-prem DB to AWS for DR | DMS with continuous replication |
| **Cloud read replicas** | On-prem primary, cloud read replicas | DMS CDC, native replication |
| **Gradual migration** | Run both, migrate applications incrementally | DMS, Route 53 weighted routing |
| **Analytics offload** | On-prem transactional, cloud analytics | DMS to Redshift, S3, or Aurora |
| **Multi-cloud sync** | Keep databases in sync across environments | DMS continuous replication |

---

## Edge Computing

### AWS IoT Greengrass

- Extends AWS IoT to edge devices
- Runs a **Greengrass Core** runtime on local devices (Linux)
- Enables **local Lambda function** execution on edge devices
- Supports **local messaging** between devices without cloud connectivity
- **ML inference** at the edge using pre-trained models
- **Stream management** — processes IoT data streams locally
- Syncs with AWS IoT Core when connectivity is available
- Use case: Factory floor, agriculture, oil rigs — anywhere with intermittent connectivity

### AWS Snowball Edge

Snowball Edge devices provide edge computing capabilities in addition to data transfer:

**Snowball Edge Storage Optimized:**
- 80 TB usable storage
- 40 vCPUs, 80 GiB memory
- Can run EC2 instances and Lambda functions locally
- Use case: Large-scale data transfer + local compute

**Snowball Edge Compute Optimized:**
- 42 TB usable storage
- 52 vCPUs, 208 GiB memory
- Optional GPU (for ML inference)
- Can run EC2 instances and Lambda functions locally
- Use case: Edge compute in disconnected environments (ships, mines, military)

### Key Exam Points for Edge Computing

- **Greengrass** — IoT edge, local Lambda, ML inference, intermittent connectivity
- **Snowball Edge** — Large data transfer + edge compute, disconnected environments
- Both can operate in **disconnected/offline** mode (unlike Outposts)

---

## ECS/EKS Anywhere

### Amazon ECS Anywhere

- Run Amazon ECS tasks on **your own on-premises infrastructure**
- Uses the ECS control plane in the cloud to manage on-premises container workloads
- Install the **ECS Agent** and **SSM Agent** on your on-premises servers
- Servers register as **EXTERNAL** launch type in ECS
- Benefits:
  - Familiar ECS API and tooling
  - Centralized management
  - CloudWatch monitoring
  - No ECS cluster management overhead on-premises

### Amazon EKS Anywhere

- Run Amazon EKS on your own on-premises infrastructure
- **Full Kubernetes** distribution based on EKS Distro (EKS-D)
- Runs on VMware vSphere, bare metal, Snowball Edge, or other platforms
- Optional **EKS Connector** to register and view clusters in the AWS Console
- Includes:
  - Default networking (Cilium CNI)
  - Default storage (CSI drivers)
  - Lifecycle management (cluster create, upgrade, delete)
  - Curated package support

### Key Differences

| Feature | ECS Anywhere | EKS Anywhere |
|---------|-------------|-------------|
| **Orchestrator** | ECS | Kubernetes |
| **Control plane location** | AWS cloud | On-premises |
| **Launch type** | EXTERNAL | N/A (native K8s) |
| **On-prem requirements** | ECS Agent + SSM Agent | EKS-D + supported infrastructure |
| **Use case** | Extend ECS to on-prem | Run K8s on-prem with EKS tooling |

---

## Network Architecture for Hybrid: Transit Gateway with DX and VPN

### The Challenge

In large hybrid architectures, you may have:
- Multiple VPCs (dev, staging, prod, shared services)
- On-premises data centers connected via DX
- Branch offices connected via VPN
- Full mesh connectivity requirements

Managing individual VPC peering + individual VPN connections becomes unmanageable.

### AWS Transit Gateway (TGW)

Transit Gateway acts as a **regional hub** that connects VPCs, VPN connections, Direct Connect gateways, and peering connections through a single gateway.

**Key features:**
- Hub-and-spoke model (star topology)
- Supports thousands of VPC and VPN attachments
- Supports **route tables** for traffic segmentation
- Supports **inter-Region peering** between Transit Gateways
- Supports **multicast**
- Supports **equal-cost multi-path (ECMP)** routing for VPN connections to aggregate bandwidth

### Transit Gateway + Direct Connect

```
On-premises DC → DX Connection → DX Gateway → Transit Gateway → Multiple VPCs
```

- Use a **Transit Virtual Interface (Transit VIF)** on the DX connection
- The Transit VIF connects to a **DX Gateway**
- The DX Gateway connects to the **Transit Gateway**
- The Transit Gateway has attachments to all VPCs
- Result: On-premises access to all VPCs through a single DX connection

### Transit Gateway + VPN

```
Branch Office → VPN → Transit Gateway → Multiple VPCs
```

- VPN connections attach directly to the Transit Gateway
- Multiple VPN connections can use ECMP for higher throughput
- VPN can serve as backup for DX (lower priority route via Transit Gateway route tables)

### Combined Architecture

```
                            ┌─── VPC A
                            │
On-prem DC ─── DX ─── TGW ─┼─── VPC B
                     │      │
Branch ─── VPN ──────┘      └─── VPC C (Shared Services)
```

### Transit Gateway Route Tables

You can create multiple route tables for traffic segmentation:

- **Default route table:** All attachments use this by default
- **Custom route tables:** Isolate traffic between different environments
- Example: Dev VPCs can communicate with each other but not with Prod VPCs, while both can reach Shared Services

### Key Exam Points for Transit Gateway

- TGW is the answer when you see "multiple VPCs need connectivity to on-premises"
- TGW simplifies network topology (hub-and-spoke vs full mesh)
- TGW supports both DX and VPN connections
- TGW supports inter-Region peering
- VPN ECMP through TGW can aggregate bandwidth
- Cost: Per attachment per hour + per GB of data processed

---

## Common Exam Scenarios

### Scenario 1: Low-Latency Application for City Users

**Question pattern:** "An application needs single-digit millisecond latency for users in Los Angeles..."

**Answer:** AWS Local Zones — Extend VPC into the LA Local Zone, deploy instances there.

### Scenario 2: Data Must Stay On-Premises

**Question pattern:** "Due to regulations, data must remain in the company's own data center, but the team wants to use AWS APIs..."

**Answer:** AWS Outposts — Deploy an Outpost rack in the company data center.

### Scenario 3: 5G Mobile Application

**Question pattern:** "A gaming company wants ultra-low-latency for 5G mobile users..."

**Answer:** AWS Wavelength — Deploy to Wavelength Zones at the 5G carrier edge.

### Scenario 4: Replace Tape Backup

**Question pattern:** "A company wants to replace physical tape infrastructure without changing their backup software..."

**Answer:** Tape Gateway (Storage Gateway) — Presents a virtual tape library to existing backup software.

### Scenario 5: Encrypted Dedicated Connection

**Question pattern:** "The company needs a dedicated, encrypted connection between on-premises and AWS..."

**Answer:** VPN over Direct Connect — DX for dedicated bandwidth + VPN for encryption.

### Scenario 6: On-Premises Users Need AWS DNS Resolution

**Question pattern:** "On-premises servers need to resolve domain names in a Route 53 Private Hosted Zone..."

**Answer:** Route 53 Inbound Resolver Endpoint — On-premises DNS forwards queries to the inbound endpoint.

### Scenario 7: Federated Access to Multiple AWS Accounts

**Question pattern:** "The company wants employees to use their corporate credentials to access 50 AWS accounts..."

**Answer:** AWS IAM Identity Center — Centralized SSO with integration to corporate Active Directory.

### Scenario 8: Migrate VMware Workloads

**Question pattern:** "A company running hundreds of VMware VMs wants to migrate to AWS with minimal changes..."

**Answer:** VMware Cloud on AWS — Run vSphere workloads on AWS infrastructure without VM conversion.

### Scenario 9: Hybrid Container Orchestration

**Question pattern:** "The company wants to manage on-premises containers using the same tools as their AWS containers..."

**Answer:** ECS Anywhere or EKS Anywhere — Depends on whether they use ECS or Kubernetes.

### Scenario 10: File Shares Backed by S3

**Question pattern:** "On-premises applications need NFS access to data stored in S3..."

**Answer:** S3 File Gateway — NFS/SMB interface to S3 with local caching.

---

## Summary and Key Takeaways

| Topic | Key Service | Exam Trigger Keywords |
|-------|-------------|----------------------|
| AWS in your DC | Outposts | "on-premises", "data residency", "AWS APIs in data center" |
| Low-latency metro | Local Zones | "single-digit ms", "end users", "city" |
| 5G edge | Wavelength | "5G", "carrier", "mobile edge" |
| VMware to AWS | VMware Cloud on AWS | "VMware", "vSphere", "vCenter" |
| File hybrid storage | Storage Gateway | "NFS", "SMB", "iSCSI", "tape backup" |
| Dedicated network | Direct Connect | "dedicated", "consistent", "private connection" |
| Quick encrypted network | VPN | "quickly", "encrypted", "immediately" |
| Hybrid DNS | Route 53 Resolver | "on-prem DNS", "resolve AWS names" |
| Hybrid identity | Managed AD / AD Connector | "Active Directory", "domain join" |
| Federated access | IAM Identity Center | "SSO", "multiple accounts", "corporate credentials" |
| Hub networking | Transit Gateway | "multiple VPCs", "centralized routing" |
| Edge compute (IoT) | Greengrass | "IoT", "edge Lambda", "intermittent" |
| Edge compute (large) | Snowball Edge | "disconnected", "remote location", "large data" |
| On-prem containers | ECS/EKS Anywhere | "on-premises containers", "hybrid K8s" |

Remember: Hybrid cloud questions often combine multiple services. A complete hybrid architecture might include Direct Connect for networking, Storage Gateway for storage, Managed AD for identity, Transit Gateway for VPC connectivity, and Route 53 Resolver for DNS — all working together.

---

*Next Article: [Well-Architected Framework](29-well-architected-framework.md)*
