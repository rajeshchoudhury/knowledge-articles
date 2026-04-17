# Data Transfer Services

## Table of Contents

1. [Data Transfer Options Overview](#data-transfer-options-overview)
2. [AWS Direct Connect](#aws-direct-connect)
3. [Direct Connect Virtual Interfaces](#direct-connect-virtual-interfaces)
4. [Direct Connect Gateway](#direct-connect-gateway)
5. [Direct Connect Resiliency](#direct-connect-resiliency)
6. [Direct Connect + VPN](#direct-connect--vpn)
7. [Direct Connect LAG](#direct-connect-lag)
8. [Direct Connect SiteLink](#direct-connect-sitelink)
9. [AWS VPN](#aws-vpn)
10. [Site-to-Site VPN Deep Dive](#site-to-site-vpn-deep-dive)
11. [AWS Transit Gateway](#aws-transit-gateway)
12. [VPN vs Direct Connect Comparison](#vpn-vs-direct-connect-comparison)
13. [AWS Snow Family](#aws-snow-family)
14. [AWS DataSync](#aws-datasync)
15. [AWS Transfer Family](#aws-transfer-family)
16. [S3 Transfer Acceleration](#s3-transfer-acceleration)
17. [Choosing the Right Data Transfer Method](#choosing-the-right-data-transfer-method)
18. [Bandwidth Calculations for Migration Planning](#bandwidth-calculations-for-migration-planning)
19. [Common Exam Scenarios](#common-exam-scenarios)

---

## Data Transfer Options Overview

### Decision Tree

When choosing a data transfer method, consider these factors:

| Factor | Options |
|--------|---------|
| **Data Volume** | Small (GB) → Network transfer; Large (TB/PB) → Snow Family, Direct Connect |
| **Transfer Frequency** | One-time → Snow Family, DMS; Ongoing → Direct Connect, VPN, DataSync |
| **Bandwidth** | Low → Snow Family; High → Direct Connect, Transfer Acceleration |
| **Latency** | Low latency needed → Direct Connect; Tolerant → VPN, Internet |
| **Security** | Encryption needed → VPN, Direct Connect + VPN; Standard → HTTPS |
| **Direction** | On-premises → AWS; AWS → On-premises; Between AWS services |

### Quick Reference

| Service | Primary Use Case |
|---------|-----------------|
| **Direct Connect** | Dedicated, consistent, low-latency private connection |
| **Site-to-Site VPN** | Encrypted connection over public internet |
| **Transit Gateway** | Hub-and-spoke connectivity for multiple VPCs and on-premises |
| **Snow Family** | Offline bulk data transfer (TB to PB scale) |
| **DataSync** | Automated file transfer between on-premises and AWS storage |
| **Transfer Family** | SFTP/FTPS/FTP file transfer to/from S3 and EFS |
| **S3 Transfer Acceleration** | Accelerated uploads to S3 over long distances |

---

## AWS Direct Connect

### Overview

AWS Direct Connect provides a **dedicated, private network connection** between your on-premises data center and AWS. It bypasses the public internet, providing more consistent network performance, lower latency, and reduced data transfer costs.

### Connection Types

#### Dedicated Connections

A physical Ethernet connection associated with a single customer:

| Speed | Port Type |
|-------|-----------|
| **1 Gbps** | 1000BASE-LX (single-mode fiber) |
| **10 Gbps** | 10GBASE-LR (single-mode fiber) |
| **100 Gbps** | 100GBASE-LR4 (single-mode fiber) |

**Provisioning:**
1. Request a connection through the AWS Console
2. AWS allocates a port at a Direct Connect location
3. Receive a **Letter of Authorization and Connecting Facility Assignment (LOA-CFA)**
4. Provide the LOA-CFA to your colocation provider or network provider
5. Provider establishes the **cross-connect** (physical cable) from your router to the AWS router
6. Connection becomes available (typically 1–4 weeks)

#### Hosted Connections

A connection provisioned by an **AWS Direct Connect Partner** on your behalf:

| Speed | Notes |
|-------|-------|
| **50 Mbps** | Minimum hosted connection speed |
| **100 Mbps, 200 Mbps, 300 Mbps, 400 Mbps, 500 Mbps** | Common hosted speeds |
| **1 Gbps, 2 Gbps, 5 Gbps, 10 Gbps** | Higher-speed hosted connections |

**Provisioning:**
1. Contact an AWS Direct Connect Partner
2. Partner provisions the connection from their existing dedicated connection
3. You accept the hosted connection in the AWS Console
4. Partner handles the physical connectivity

**Key Differences:**

| Feature | Dedicated | Hosted |
|---------|-----------|--------|
| **Speed** | 1, 10, or 100 Gbps | 50 Mbps to 10 Gbps |
| **Provisioned by** | You (via AWS Console) | AWS Direct Connect Partner |
| **Physical port** | Dedicated port at DX location | Shared partner infrastructure |
| **VLAN count** | Up to 50 VIFs per connection | 1 VIF per hosted connection |
| **Lead time** | 1–4 weeks (longer for 100G) | Days to weeks (partner dependent) |
| **Cost** | Port-hour charges + data transfer | Partner pricing + data transfer |

### LOA-CFA (Letter of Authorization and Connecting Facility Assignment)

- Document provided by AWS after you request a dedicated connection
- Contains: Connection ID, port location, device information at the Direct Connect location
- Give this to your colocation provider or network provider to establish the cross-connect
- Valid for **90 days** — must establish the cross-connect within this period
- If expired, request a new LOA-CFA through the AWS Console

### Cross-Connect

The physical cable between your network equipment (or your partner's equipment) and the AWS router at the Direct Connect location:

- Single-mode fiber for dedicated connections
- Your router must support:
  - 802.1Q VLAN encapsulation
  - BGP (Border Gateway Protocol) for routing
  - BGP MD5 authentication (optional but recommended)
- AWS provides the router on their side

---

## Direct Connect Virtual Interfaces

### Overview

Virtual Interfaces (VIFs) are logical interfaces created on top of the physical Direct Connect connection. Each VIF corresponds to a VLAN and a BGP session.

### VIF Types

#### Private Virtual Interface (Private VIF)

**Purpose:** Access AWS resources in a **VPC** using private IP addresses.

**Configuration:**
- Connects to a **Virtual Private Gateway (VGW)** attached to a VPC
- Or connects to a **Direct Connect Gateway** (for multi-VPC access)
- BGP peering with your router
- VLAN ID, BGP ASN, IP addresses
- Supports jumbo frames (MTU up to 9001 bytes)

**Use Case:**
- Access EC2 instances, RDS databases, and other VPC resources privately
- No internet exposure for traffic

**Key Points:**
- One Private VIF → One VGW → One VPC (without DX Gateway)
- One Private VIF → One DX Gateway → Multiple VPCs across regions

#### Public Virtual Interface (Public VIF)

**Purpose:** Access **AWS public services** (S3, DynamoDB, CloudFront, etc.) using public IP addresses via Direct Connect (not over the internet).

**Configuration:**
- AWS announces public IP prefixes via BGP
- You announce your public IP prefixes or request Amazon-provided IPs
- Traffic goes through Direct Connect, NOT the internet
- No VPC required

**Use Case:**
- Access S3, DynamoDB, SQS, SNS, and other public AWS services with consistent performance
- Access any AWS public endpoint over Direct Connect

**Key Points:**
- Public VIF does NOT go through a VPC
- Traffic still uses public IP addresses, but the path is over Direct Connect
- Can access public services in ANY region (not just the Direct Connect region)

#### Transit Virtual Interface (Transit VIF)

**Purpose:** Access one or more **Transit Gateways** associated with a Direct Connect Gateway.

**Configuration:**
- Connects to a **Direct Connect Gateway**
- Direct Connect Gateway associates with one or more Transit Gateways
- Transit Gateways connect to multiple VPCs

**Use Case:**
- Connect on-premises to many VPCs through a single Transit Gateway hub
- Scale beyond Private VIF limits (Private VIF → 1 VGW → 1 VPC)

**Key Points:**
- Transit VIF requires a Direct Connect Gateway
- Supports up to 3 Transit Gateways per Direct Connect Gateway
- Transit VIF supports jumbo frames (up to 8500 bytes)

#### Hosted Virtual Interface

**Purpose:** Allow another AWS account to use your Direct Connect connection.

**How It Works:**
- Connection owner creates a hosted VIF and assigns it to another account
- The other account accepts the VIF and attaches it to their VGW or DX Gateway
- Useful for sharing a single Direct Connect connection across accounts in an organization

### VIF Comparison

| Feature | Private VIF | Public VIF | Transit VIF |
|---------|------------|------------|-------------|
| **Accesses** | VPC resources (private IPs) | AWS public services (public IPs) | VPCs via Transit Gateway |
| **Connects To** | VGW or DX Gateway | AWS public endpoints | DX Gateway + Transit Gateway |
| **IP Addressing** | Private IP | Public IP | Private IP |
| **Jumbo Frames** | Up to 9001 bytes | 1500 bytes | Up to 8500 bytes |
| **Multi-VPC** | Only via DX Gateway | N/A | Yes, via Transit Gateway |
| **Use Case** | Direct VPC access | S3, DynamoDB, public services | Hub-and-spoke to many VPCs |

---

## Direct Connect Gateway

### Overview

A Direct Connect Gateway is a **globally available resource** that enables you to connect your Direct Connect connection to VPCs in **multiple AWS regions** (or Transit Gateways in multiple regions).

### How It Works

```
On-Premises ─── DX Connection ─── Private VIF ─── DX Gateway
                                                      │
                                    ┌─────────────────┼─────────────────┐
                                    │                 │                 │
                                VGW (us-east-1)   VGW (eu-west-1)   VGW (ap-southeast-1)
                                    │                 │                 │
                                VPC-1             VPC-2             VPC-3
```

### Key Features

- **Cross-region**: Connect to VPCs in any AWS region from a single Direct Connect connection
- **Cross-account**: VPCs in different AWS accounts can associate with the same DX Gateway
- **Virtual Private Gateway association**: Associate up to **20 VGWs** from different regions
- **Transit Gateway association**: Associate up to **3 Transit Gateways**
- **No additional data charges**: No extra data transfer charges for using DX Gateway

### Association Types

**DX Gateway + Virtual Private Gateway:**
- Each VGW must be in a different region (or same region, different VPC)
- Private VIF on the DX connection
- Up to 20 VGW associations per DX Gateway

**DX Gateway + Transit Gateway:**
- Transit VIF on the DX connection
- Up to 3 Transit Gateway associations per DX Gateway
- Transit Gateways can be in different regions

### Key Exam Points

- DX Gateway does NOT route traffic between VPCs (it's not a Transit Gateway)
- Traffic flows: On-premises ↔ VPC only, NOT VPC ↔ VPC through DX Gateway
- DX Gateway is a **global resource** (not region-specific)
- No additional cost for DX Gateway itself

---

## Direct Connect Resiliency

AWS provides recommended architectures for different resiliency levels:

### Development and Test (Non-Critical)

```
On-Premises ─── Single DX Connection ─── Single DX Location ─── AWS
```

- Single connection at a single Direct Connect location
- No redundancy
- If the connection or location fails, connectivity is lost
- Use Site-to-Site VPN as backup (failover)

### High Resiliency for Critical Workloads

```
On-Premises ─── DX Connection A ─── DX Location 1 ─── AWS
             └── DX Connection B ─── DX Location 2 ───┘
```

- Two connections at **two different Direct Connect locations**
- Protects against: Single connection failure, single location failure
- Active-active or active-passive configuration
- BGP routing determines traffic path

### Maximum Resiliency for Critical Workloads

```
                    ┌── DX Connection A1 ─── DX Location 1 ─── AWS
On-Premises ────────┤
                    └── DX Connection A2 ─── DX Location 1 ───┘
                    ┌── DX Connection B1 ─── DX Location 2 ─── AWS
On-Premises ────────┤
                    └── DX Connection B2 ─── DX Location 2 ───┘
```

- **Two connections at each of two locations** (4 connections total)
- Protects against: Connection failure, device failure, location failure
- Highest availability guarantee
- Most expensive option
- AWS recommends for mission-critical workloads

### Resiliency with VPN Backup

```
On-Premises ─── DX Connection ─── DX Location ─── AWS (primary)
             └── Site-to-Site VPN ─── Internet ─── AWS (backup)
```

- DX as primary path, VPN as failover
- VPN provides encrypted backup over the internet
- BGP routing with lower priority for VPN path
- Cost-effective alternative to dual DX connections

---

## Direct Connect + VPN

### Overview

Combining Direct Connect with VPN provides an **IPsec-encrypted connection** over Direct Connect.

### How It Works

```
On-Premises ─── DX Connection (Private) ─── VPN Tunnel (encrypted) ─── VGW ─── VPC
```

- Creates an IPsec VPN tunnel over the Direct Connect connection
- Traffic is encrypted end-to-end (DX alone is private but NOT encrypted)
- Uses a Public VIF on DX to reach the VPN endpoint
- Or use a private VIF with a VPN tunnel

### Use Cases

- **Compliance**: Regulations require encryption for all data in transit
- **Defense in depth**: Additional security layer beyond DX's private connection
- **Regulatory requirements**: Financial, healthcare, government workloads

### Key Points

- Direct Connect by itself provides a **private** connection but is NOT encrypted
- Adding VPN provides **encryption** (IPsec)
- VPN throughput is limited by the VPN connection (typically up to 1.25 Gbps per tunnel)
- For higher encrypted throughput, use multiple VPN tunnels or consider MACsec (Layer 2 encryption for 10 Gbps and 100 Gbps DX connections)

### MACsec (IEEE 802.1AE)

- **Layer 2 encryption** available on 10 Gbps and 100 Gbps dedicated connections
- Line-rate encryption (no throughput impact)
- Encrypts data on the physical link between your router and the AWS router
- Requires MACsec-capable hardware on your side
- Provides point-to-point encryption without VPN overhead

---

## Direct Connect LAG

### LAG (Link Aggregation Group)

**Overview:**
A LAG groups multiple Direct Connect connections into a single logical connection using the **Link Aggregation Control Protocol (LACP)**:

**How It Works:**
- Combine multiple connections at the **same Direct Connect location** and **same bandwidth**
- Treated as a single managed connection
- All connections in the LAG must be: Same bandwidth, same DX location, same AWS device

**Configuration:**
- Maximum of **4 connections** per LAG (for dedicated) or **2 connections** (for hosted)
- All connections must have the same port speed
- Minimum links: Configurable (how many connections must be active for the LAG to function)

**Benefits:**
- **Increased bandwidth**: Aggregate bandwidth of all connections
- **Redundancy**: If one connection fails, traffic uses remaining connections
- **Simplified management**: Manage one LAG instead of multiple connections

**Key Points:**
- LAG does NOT provide location redundancy (all connections at the same location)
- For location redundancy, use separate connections at different DX locations
- VIFs are created on the LAG (not on individual connections)

---

## Direct Connect SiteLink

### Overview

Direct Connect SiteLink enables you to send data **between Direct Connect locations**, creating a private network that bypasses the AWS Region.

### How It Works

```
Data Center A ─── DX Location 1 ────── SiteLink ────── DX Location 2 ─── Data Center B
                                    (AWS backbone)
```

- Traffic flows over the AWS global backbone network
- Does NOT transit through an AWS Region
- Lowest latency path between Direct Connect locations
- Pricing based on data transfer between SiteLink-enabled VIFs

### Use Cases

- Connect multiple data centers or offices via AWS backbone
- Low-latency inter-site connectivity
- Use AWS as a global transit network for your sites
- Disaster recovery between data centers

### Configuration

- Enable SiteLink on individual VIFs
- SiteLink-enabled VIFs can communicate with other SiteLink-enabled VIFs
- Works with Private VIFs and Transit VIFs

---

## AWS VPN

### Site-to-Site VPN

A secure, encrypted connection between your on-premises network and your AWS VPC over the public internet.

### Client VPN

A managed VPN service for secure access to AWS resources and on-premises networks from individual clients (laptops, mobile devices):

**Key Features:**
- OpenVPN-based managed VPN service
- Connects individual users to AWS resources
- Supports Active Directory, SAML-based, and mutual authentication
- Split-tunnel or full-tunnel mode
- Client-to-VPC and client-to-on-premises connectivity
- Scales automatically with the number of users

**Use Cases:**
- Remote workforce accessing AWS resources
- VPN access for developers to private VPC resources
- Secure access from mobile devices

### VPN CloudHub

**Overview:** Connect multiple branch offices through a hub-and-spoke VPN model using a single Virtual Private Gateway:

```
Branch Office 1 ─── VPN ───┐
                            │
Branch Office 2 ─── VPN ───├─── VGW (Hub) ─── VPC
                            │
Branch Office 3 ─── VPN ───┘
```

**How It Works:**
- Multiple Customer Gateways connect to a single VGW
- Branch offices can communicate with each other through the VGW
- Uses BGP for dynamic routing between sites
- Hub-and-spoke topology

**Key Points:**
- Traffic between branches goes through AWS (VGW acts as hub)
- Each branch has its own VPN connection to the VGW
- Low cost compared to dedicated WAN connections
- Not as performant as Direct Connect for inter-site traffic

---

## Site-to-Site VPN Deep Dive

### Components

**Virtual Private Gateway (VGW):**
- AWS-side VPN endpoint
- Attached to a single VPC
- Can have multiple VPN connections (up to 10)
- Supports both static and dynamic (BGP) routing
- Has two public IP endpoints for redundancy

**Customer Gateway (CGW):**
- On-premises-side VPN endpoint (your router/firewall)
- Can be a physical device or software VPN
- Configured with the public IP of your on-premises VPN device
- Specify the ASN (Autonomous System Number) for BGP

**VPN Connection:**
- Encrypted connection between VGW and CGW
- Two VPN tunnels per connection (for redundancy)
- Each tunnel uses a different VGW public IP
- IPsec protocol (IKEv1 or IKEv2)
- AES-256, SHA-256 encryption

### Route Propagation

**Static Routing:**
- Manually define routes in the VPC route table
- Specify the on-premises CIDR blocks
- No dynamic route updates

**Dynamic Routing (BGP):**
- BGP exchanges routes automatically between VGW and CGW
- Enable **route propagation** in the VPC route table
- Routes learned via BGP are automatically added to the route table
- Recommended for production environments

### VPN Performance

**Per-Tunnel Throughput:**
- Up to **1.25 Gbps** per tunnel
- Two tunnels per connection = up to 2.5 Gbps (with ECMP on Transit Gateway)
- Standard VPN with VGW uses only ONE tunnel actively (active-passive)

**Limitations:**
- Internet-dependent (subject to internet congestion and variability)
- Higher latency than Direct Connect
- Throughput limited compared to Direct Connect

### Accelerated Site-to-Site VPN

Uses **AWS Global Accelerator** to route VPN traffic through the AWS global network instead of the public internet:

```
On-Premises ─── Internet ─── Nearest AWS Edge Location ─── AWS Global Network ─── VGW ─── VPC
```

**Benefits:**
- Lower latency (enters AWS network at nearest edge location)
- More consistent performance (less internet path variability)
- Uses AWS backbone for the majority of the path

**Requirements:**
- Transit Gateway required (not supported with VGW directly)
- Additional Global Accelerator charges

**Key Exam Points:**
- Accelerated VPN improves performance for geographically distant connections
- Requires Transit Gateway
- Not a replacement for Direct Connect (still uses internet for the first hop)

---

## AWS Transit Gateway

### Overview

AWS Transit Gateway (TGW) is a **regional** network transit hub that connects VPCs, VPN connections, Direct Connect Gateways, and other Transit Gateways.

### Architecture

```
                          ┌─── VPC A
                          │
VPN Connection ───────────┼─── VPC B
                          │
Direct Connect ─── DX GW ┼─── VPC C
                          │
Peering TGW (other region)┼─── VPC D
                          │
                          └─── VPC E
                    Transit Gateway (Hub)
```

### Attachments

Transit Gateway connects to resources via **attachments**:

| Attachment Type | Description |
|----------------|-------------|
| **VPC** | Connect a VPC to the Transit Gateway (one subnet per AZ) |
| **VPN** | Site-to-Site VPN connection |
| **Direct Connect Gateway** | Via Transit VIF on Direct Connect |
| **Peering** | Connect to another Transit Gateway (same or different region, same or different account) |
| **Connect** | Connect SD-WAN appliances using GRE and BGP |

### Route Tables

Transit Gateway uses **route tables** to determine how to route traffic between attachments:

**Default Route Table:**
- Created automatically when TGW is created
- All attachments are associated with the default route table by default
- All attachments propagate routes to the default route table by default
- Result: Full mesh connectivity (all attachments can reach all other attachments)

**Custom Route Tables:**
- Create separate route tables for network segmentation
- Associate specific attachments with specific route tables
- Control route propagation per table
- Enable complex routing scenarios

**Network Segmentation Example:**
```
Production Route Table:
  - VPC-Prod → local
  - VPC-Shared → shared services
  - Direct Connect → on-premises
  (No route to VPC-Dev)

Development Route Table:
  - VPC-Dev → local
  - VPC-Shared → shared services
  (No route to VPC-Prod or on-premises)
```

### Key Features

**Equal-Cost Multi-Path (ECMP):**
- Distribute VPN traffic across multiple VPN tunnels
- Aggregate bandwidth from multiple VPN connections
- Example: 2 VPN connections = 4 tunnels = up to 5 Gbps (with ECMP)
- Only supported with Transit Gateway (not with VGW)

**Multicast:**
- Transit Gateway supports multicast routing
- Create multicast domains
- Register instances as multicast sources and members
- Use case: Media streaming, financial data distribution

**Inter-Region Peering:**
- Connect Transit Gateways across AWS regions
- Traffic stays on AWS private network
- Encrypted automatically
- Useful for global network architectures

**Cross-Account Sharing:**
- Share Transit Gateway across accounts using **AWS RAM (Resource Access Manager)**
- Accounts attach their VPCs to the shared Transit Gateway
- Centralized networking with decentralized VPC management

### Transit Gateway Network Manager

- **Global network visualization**: View your entire global network on a map
- **Topology**: Visual representation of connections between sites, devices, and links
- **Events and metrics**: Monitor network health and performance
- **SD-WAN integration**: Connect third-party SD-WAN devices
- **Route Analyzer**: Test and validate routing paths

### Key Exam Points

- Transit Gateway is a **hub** for VPC-to-VPC, VPC-to-on-premises, and inter-region connectivity
- Replaces complex VPC peering meshes with a hub-and-spoke model
- **ECMP** aggregates VPN bandwidth (only with TGW, not VGW)
- **Route tables** enable network segmentation
- **RAM sharing** enables cross-account Transit Gateway usage
- Transit Gateway is **regional** — use peering for cross-region

---

## VPN vs Direct Connect Comparison

| Feature | Site-to-Site VPN | AWS Direct Connect |
|---------|-----------------|-------------------|
| **Connection Type** | Encrypted tunnel over public internet | Dedicated private connection |
| **Setup Time** | Minutes to hours | Weeks to months |
| **Bandwidth** | Up to 1.25 Gbps per tunnel | 1/10/100 Gbps (dedicated), 50 Mbps–10 Gbps (hosted) |
| **Latency** | Variable (internet-dependent) | Consistent, low latency |
| **Reliability** | Internet-dependent | More reliable (dedicated path) |
| **Encryption** | Yes (IPsec) | No (private but not encrypted; add VPN or MACsec for encryption) |
| **Cost** | Lower (per-hour + data transfer) | Higher (port-hour + data transfer, typically lower DTO rates) |
| **Data Transfer Cost** | Standard internet rates | Lower rates (especially for large volumes) |
| **Redundancy** | Two tunnels per connection | Must set up dual connections at different locations |
| **Best For** | Quick setup, backup, lower bandwidth needs | Consistent performance, high bandwidth, data-intensive workloads |

### When to Use What

**Use VPN when:**
- Need connection quickly (hours, not weeks)
- Bandwidth requirements are under 1.25 Gbps
- Cost is a primary concern
- Connection is for backup/failover
- Internet variability is acceptable

**Use Direct Connect when:**
- Need consistent, low-latency connectivity
- High bandwidth requirements (multi-Gbps)
- Large data transfer volumes (lower per-GB cost)
- Regulatory requirements for private connectivity
- Real-time applications sensitive to jitter

**Use Both when:**
- DX for primary, VPN for backup
- Need encryption over DX (DX + VPN)
- Maximum resiliency with multiple path types

---

## AWS Snow Family

### Overview

The AWS Snow Family consists of physical devices for offline data transfer and edge computing. They address scenarios where network transfer is too slow, too expensive, or not available.

### Device Comparison

#### AWS Snowcone

| Feature | Snowcone | Snowcone SSD |
|---------|----------|--------------|
| **Weight** | 4.5 lbs (2.1 kg) | 4.5 lbs (2.1 kg) |
| **Storage** | 8 TB HDD | 14 TB SSD |
| **Compute** | 2 vCPUs, 4 GB RAM | 2 vCPUs, 4 GB RAM |
| **Power** | USB-C, optional battery | USB-C, optional battery |
| **Transfer** | Ship device or DataSync over network | Ship device or DataSync over network |
| **Environment** | Rugged, dustproof, waterproof | Rugged, dustproof, waterproof |

**Use Cases:**
- Edge computing in harsh/remote environments
- Data collection at the edge
- Small-scale data migration (up to 14 TB)
- IoT sensor data collection
- Military/field operations

#### AWS Snowball Edge

| Feature | Storage Optimized | Compute Optimized |
|---------|-------------------|-------------------|
| **Storage** | 80 TB usable (210 TB total) | 28 TB usable NVMe (42 TB total) + 7.68 TB SSD |
| **Compute** | 40 vCPUs, 80 GB RAM | 104 vCPUs, 416 GB RAM |
| **GPU** | No | Optional GPU (NVIDIA V100) |
| **Clustering** | Up to 15 devices | Up to 16 devices |
| **Network** | 10/25/100 Gbps | 10/25/100 Gbps |
| **Use Case** | Large data transfer, basic edge computing | ML inference, video analysis, heavy edge compute |

**Storage Optimized Use Cases:**
- Large-scale data migration (up to 80 TB per device)
- Disaster recovery data backup
- Local storage for remote locations
- Data aggregation before cloud transfer

**Compute Optimized Use Cases:**
- Machine learning inference at the edge
- Real-time video analysis
- Industrial IoT data processing
- Autonomous vehicle data processing

**Common Features:**
- Run EC2 instances and Lambda functions on the device
- S3-compatible object storage
- NFS file interface
- Cluster multiple devices for higher capacity and availability
- Encryption: 256-bit encryption, KMS-managed keys, tamper-resistant enclosure
- AWS OpsHub: GUI application for managing Snow devices

#### AWS Snowmobile

| Feature | Details |
|---------|---------|
| **Capacity** | 100 PB per Snowmobile |
| **Form Factor** | 45-foot ruggedized shipping container on a semi-trailer truck |
| **Security** | GPS tracking, 24/7 surveillance, escort vehicle, tamper-proof |
| **Power** | Requires dedicated power source at your facility |
| **Network** | 40 Gbps network connection |
| **Transfer Speed** | Approximately 1 TB per minute (network) |
| **Use Case** | Exabyte-scale data migration |

**When to Use Snowmobile:**
- Data volumes exceeding 10 PB
- Data center decommissioning
- Complete data center migration
- **Rule of thumb**: Snowmobile is better than Snowball when data exceeds ~10 PB

### Data Transfer Process

1. **Order**: Request Snow device from AWS Console
2. **Receive**: AWS ships the device (or drives Snowmobile to your facility)
3. **Load**: Connect to your network and transfer data
4. **Ship**: Return device to AWS (prepaid shipping label)
5. **Import**: AWS imports data into S3 (or other designated service)
6. **Erase**: AWS securely erases the device after import

### Snow Family and Edge Computing

All Snow devices support edge computing:
- Run EC2 instances (AMIs deployed via OpsHub or CLI)
- Run Lambda functions
- Run IoT Greengrass
- Operate in disconnected environments
- AWS OpsHub for device management

### Key Exam Points

- **Snowcone**: Smallest (8–14 TB), most portable, rugged environments
- **Snowball Edge**: Medium (28–80 TB), two variants (Storage/Compute optimized), clustering
- **Snowmobile**: Largest (100 PB), for exabyte-scale migrations
- All data is **encrypted** with KMS keys
- Snowball Edge can run **EC2 and Lambda** at the edge
- **Use Snow when network transfer would take too long** (rule of thumb: > 1 week over available bandwidth)

---

## AWS DataSync

### Overview

AWS DataSync is a data transfer service that simplifies, automates, and accelerates moving data between on-premises storage systems, AWS storage services, and between AWS storage services.

### How It Works

**Components:**

| Component | Description |
|-----------|-------------|
| **Agent** | EC2 instance or VM deployed on-premises for on-premises transfers. NOT needed for AWS-to-AWS transfers |
| **Source Location** | Where data is read from (NFS, SMB, HDFS, S3, EFS, FSx) |
| **Destination Location** | Where data is written to (S3, EFS, FSx, NFS, SMB, HDFS) |
| **Task** | Configuration defining source, destination, and transfer settings |
| **Task Execution** | A specific run of a task (manual or scheduled) |

### Supported Locations

**On-Premises Sources/Destinations:**
- Network File System (NFS)
- Server Message Block (SMB)
- Hadoop Distributed File System (HDFS)
- Self-managed object storage (S3-compatible)

**AWS Sources/Destinations:**
- Amazon S3 (all storage classes)
- Amazon EFS
- Amazon FSx for Windows File Server
- Amazon FSx for Lustre
- Amazon FSx for OpenZFS
- Amazon FSx for NetApp ONTAP

**AWS-to-AWS Transfers (no agent needed):**
- S3 → EFS, EFS → S3, S3 → FSx, EFS → FSx, etc.
- Cross-region and cross-account transfers supported

### Key Features

**Scheduling:**
- Cron expressions for recurring transfers
- One-time or recurring schedules
- Minimum interval: 1 hour

**Bandwidth Control:**
- Throttle bandwidth to prevent impacting production network traffic
- Set maximum bandwidth limit (Mbps)
- Schedule bandwidth limits for different times of day

**Data Filtering:**
- Include/exclude filters based on file path patterns
- Transfer only specific directories or file types

**Data Integrity Verification:**
- Automatic integrity checks during and after transfer
- Compares source and destination file metadata and checksums
- Configurable verification options

**Encryption:**
- Data encrypted in transit using TLS
- Destination encryption (S3 SSE, EFS encryption, FSx encryption)

**Transfer Speed:**
- Up to **10 Gbps** throughput per task
- Automatically handles: Parallelization, multi-threading, pipelining
- Significantly faster than traditional tools (rsync, cp, etc.)

**Incremental Transfers:**
- After initial full transfer, only changed files are transferred
- Based on file metadata (modification time, size)
- Efficient for recurring synchronization

### DataSync vs Other Transfer Methods

| Feature | DataSync | S3 CLI/SDK | rsync | Snow Family |
|---------|----------|-----------|-------|-------------|
| **Speed** | Up to 10 Gbps | Varies | Slow | Offline |
| **Automation** | Built-in scheduling | Custom scripts | Custom scripts | Manual |
| **Integrity** | Automatic verification | Manual | Manual | Automatic |
| **Incremental** | Yes (automatic) | Custom | Yes | No |
| **Bandwidth Control** | Built-in | Custom | Custom | N/A |
| **Agent** | Required (on-premises) | No | No | N/A |
| **Best For** | Regular sync, large-scale | Small files, API access | Linux file sync | Offline transfer |

### Key Exam Points

- DataSync is for **file-based transfer** and synchronization
- **Agent required** for on-premises transfers (VM or EC2)
- **No agent** for AWS-to-AWS transfers
- Up to **10 Gbps** throughput
- Built-in **scheduling**, **filtering**, and **bandwidth control**
- Automatic **incremental transfers** and **data verification**
- Supports **cross-region** and **cross-account** transfers

---

## AWS Transfer Family

### Overview

AWS Transfer Family provides fully managed support for file transfers directly into and out of Amazon S3 and Amazon EFS using standard file transfer protocols.

### Supported Protocols

| Protocol | Port | Security | Use Case |
|----------|------|----------|----------|
| **SFTP** (SSH File Transfer Protocol) | 22 | SSH encryption | Most common, secure file transfer |
| **FTPS** (File Transfer Protocol over SSL) | 21/990 | TLS encryption | Legacy systems requiring FTP with encryption |
| **FTP** (File Transfer Protocol) | 21 | **No encryption** (use within VPC only) | Legacy systems in trusted networks |
| **AS2** (Applicability Statement 2) | 443 | S/MIME + HTTP(S) | B2B EDI data exchange, healthcare, supply chain |

### Identity Providers

| Provider | Description |
|----------|-------------|
| **Service Managed** | Transfer Family manages usernames, SSH keys, and passwords |
| **AWS Directory Service** | Microsoft AD or AD Connector for authentication |
| **Custom (Lambda + API Gateway)** | Custom identity provider using Lambda for flexible authentication (LDAP, Okta, custom DB) |

### Key Features

**Logical Directories:**
- Map users to specific S3 paths or EFS paths
- Users see a familiar directory structure
- Restrict access per user to specific S3 prefixes
- Virtual directory structure: `/home/user1` → `s3://bucket/department1/user1/`

**Endpoint Types:**
- **Public**: Internet-accessible endpoint with elastic IP
- **VPC**: Internal endpoint within your VPC (for private access)
- **VPC with internet-facing**: VPC endpoint with elastic IPs for internet access with VPC security controls

**Managed Workflows:**
- Post-upload processing: Trigger Lambda, copy, tag, or delete files
- Pre-built steps: Copy, tag, delete, custom Lambda
- Exception handling for failed steps

**Security:**
- IAM roles define S3/EFS permissions per user
- SSH key-based or password-based authentication
- Security policies: TLS cipher suites and minimum TLS version
- CloudWatch Logs for session logging
- CloudTrail for API auditing

### Use Cases

- Replace self-managed SFTP servers
- B2B file exchange with partners
- Data lake ingestion from external partners
- Compliance: HIPAA, PCI, SOX file transfers
- Migration from legacy FTP servers

### Key Exam Points

- Transfer Family is for **protocol-based file transfer** (SFTP, FTPS, FTP, AS2)
- Stores files directly in **S3 or EFS**
- Replaces self-managed FTP/SFTP servers
- Use **Custom Identity Provider** (Lambda) for integration with existing auth systems
- **Logical directories** provide user-friendly path mapping

---

## S3 Transfer Acceleration

### Overview

Amazon S3 Transfer Acceleration enables fast, easy, and secure transfers of files over long distances between a client and an S3 bucket by leveraging **Amazon CloudFront's edge locations**.

### How It Works

```
Client (Sydney) ─── Internet ─── CloudFront Edge (Sydney) ─── AWS Backbone ─── S3 Bucket (Virginia)
                                                                     ↑
                                                          Optimized, high-bandwidth
                                                          AWS internal network
```

1. Client uploads to a special Transfer Acceleration endpoint: `<bucket-name>.s3-accelerate.amazonaws.com`
2. File is received at the **nearest CloudFront edge location**
3. Data is transferred from the edge location to the S3 bucket over the **AWS backbone network**
4. AWS backbone provides optimized routing, higher throughput, and lower latency than public internet

### When It Helps

Transfer Acceleration provides the most benefit when:
- **Geographic distance** between the client and the S3 bucket is large
- **Clients are distributed** across the globe uploading to a single bucket
- **Large objects** (multi-part uploads benefit significantly)
- **Consistent transfer speeds** are required

### When It Doesn't Help

- Uploads from the **same region** as the bucket
- Small files that don't benefit from network optimization
- Clients close to the S3 bucket region

### Key Features

- **Speed Comparison Tool**: AWS provides a tool to compare transfer speeds with and without acceleration
- **Pay only for acceleration**: Charged only when Transfer Acceleration is faster than regular S3 transfer
- **Compatible with multipart upload**: Accelerates individual parts
- **HTTPS**: Always encrypted in transit

### Pricing

- **$0.04 per GB** transferred via Transfer Acceleration (US, Europe, Japan)
- **$0.08 per GB** for other edge locations
- **No charge** if Transfer Acceleration isn't faster than regular transfer

### Key Exam Points

- Transfer Acceleration uses **CloudFront edge locations** (not CloudFront distributions)
- Special endpoint: `<bucket>.s3-accelerate.amazonaws.com`
- Best for **long-distance**, **large file** uploads
- **Not always faster** — use the speed comparison tool to verify
- Different from CloudFront: Transfer Acceleration is for **uploads to S3**, CloudFront is for **downloads from S3**

---

## Choosing the Right Data Transfer Method

### Decision Flowchart

```
Is it a one-time transfer or ongoing?
│
├── One-time:
│   │
│   ├── How much data?
│   │   ├── < 1 TB: Internet transfer (S3 CLI, DataSync)
│   │   ├── 1-80 TB: Snowball Edge
│   │   ├── 80 TB - 10 PB: Multiple Snowball Edge devices
│   │   └── > 10 PB: Snowmobile
│   │
│   └── Database migration?
│       ├── Same engine: DMS (Full Load + CDC)
│       └── Different engine: SCT + DMS
│
├── Ongoing:
│   │
│   ├── File-based sync?
│   │   ├── Large-scale, automated: DataSync
│   │   ├── Protocol-based (SFTP/FTP): Transfer Family
│   │   └── S3 upload optimization: Transfer Acceleration
│   │
│   ├── Network connectivity?
│   │   ├── High bandwidth, consistent: Direct Connect
│   │   ├── Quick setup, encrypted: Site-to-Site VPN
│   │   └── Both (encrypted + high bandwidth): DX + VPN
│   │
│   └── Multi-VPC connectivity?
│       ├── Few VPCs: VPC Peering
│       ├── Many VPCs + on-premises: Transit Gateway
│       └── Cross-region: Transit Gateway Peering
│
└── Edge computing + data transfer?
    ├── Small, portable: Snowcone
    ├── Medium, clusterable: Snowball Edge
    └── Heavy compute at edge: Snowball Edge Compute Optimized
```

### Quick Selection Guide

| Requirement | Recommended Service |
|-------------|-------------------|
| Private, consistent, high-bandwidth connection to AWS | Direct Connect |
| Encrypted connection, quick setup, lower bandwidth | Site-to-Site VPN |
| Migrate 50 TB of data, limited internet bandwidth | Snowball Edge |
| Daily file sync from on-premises NAS to S3 | DataSync |
| Partners uploading files via SFTP to your S3 bucket | Transfer Family |
| Global users uploading large files to S3 | S3 Transfer Acceleration |
| Connect 20 VPCs + on-premises | Transit Gateway |
| Migrate Oracle DB to Aurora PostgreSQL | SCT + DMS |
| Run ML inference at a remote location + transfer results | Snowball Edge Compute Optimized |
| Migrate 500 servers to AWS | Application Migration Service (MGN) |

---

## Bandwidth Calculations for Migration Planning

### Formula

```
Transfer Time (seconds) = Data Size (bits) / Available Bandwidth (bits per second)
```

### Common Conversions

| From | To | Multiply By |
|------|----|-------------|
| TB | GB | 1,000 (or 1,024 for binary) |
| GB | Gb (gigabits) | 8 |
| TB | Gb | 8,000 |
| Mbps | Gbps | ÷ 1,000 |

### Practical Bandwidth Utilization

Real-world bandwidth utilization is typically **60–80%** of the theoretical maximum due to protocol overhead, network congestion, and other factors.

### Example Calculations

**Example 1: 10 TB over 1 Gbps connection**
```
Data: 10 TB = 80,000 Gb
Bandwidth: 1 Gbps × 0.8 utilization = 0.8 Gbps
Time: 80,000 / 0.8 = 100,000 seconds ≈ 27.8 hours ≈ 1.2 days
```

**Example 2: 50 TB over 100 Mbps connection**
```
Data: 50 TB = 400,000 Gb
Bandwidth: 100 Mbps × 0.8 = 80 Mbps = 0.08 Gbps
Time: 400,000 / 0.08 = 5,000,000 seconds ≈ 57.9 days
```
→ Network transfer takes ~2 months — use **Snowball Edge** instead

**Example 3: 100 TB over 10 Gbps Direct Connect**
```
Data: 100 TB = 800,000 Gb
Bandwidth: 10 Gbps × 0.8 = 8 Gbps
Time: 800,000 / 8 = 100,000 seconds ≈ 27.8 hours ≈ 1.2 days
```
→ Feasible with Direct Connect if the connection is available

### Rule of Thumb for Snow Family

| Data Volume | Best Transfer Method (100 Mbps internet) | Best Transfer Method (1 Gbps internet) |
|-------------|------------------------------------------|----------------------------------------|
| < 100 GB | Internet transfer | Internet transfer |
| 100 GB – 1 TB | Internet or Snowcone | Internet transfer |
| 1 TB – 10 TB | Snowcone or Snowball | Internet or DataSync |
| 10 TB – 80 TB | Snowball Edge | Snowball or DataSync |
| 80 TB – 500 TB | Multiple Snowball Edge | Multiple Snowball or DX + DataSync |
| 500 TB – 10 PB | Many Snowball Edge devices | Many Snowball + DX + DataSync |
| > 10 PB | Snowmobile | Snowmobile |

---

## Common Exam Scenarios

### Scenario 1: Dedicated Low-Latency Connection

**Question**: A company processes financial transactions and needs a consistent, low-latency connection between their data center and AWS with at least 5 Gbps bandwidth.

**Answer**: Use **AWS Direct Connect** with a **10 Gbps dedicated connection**. For resiliency, set up connections at **two different Direct Connect locations** (High Resiliency architecture). Use **Private VIFs** to access VPC resources. If encryption is required for compliance, add **MACsec** (Layer 2 encryption) or **VPN over Direct Connect**.

### Scenario 2: Quick VPN Setup as DX Backup

**Question**: A company has Direct Connect as their primary connection and needs a backup connection that can be set up quickly.

**Answer**: Set up **AWS Site-to-Site VPN** as the backup path. Configure BGP routing with lower preference for the VPN path. When Direct Connect fails, traffic automatically routes over VPN. Setup time is hours (vs. weeks for a second DX connection). The VPN provides encryption, which DX alone does not.

### Scenario 3: Connect 50 VPCs to On-Premises

**Question**: A company has 50 VPCs across 10 accounts and needs to connect all of them to the on-premises data center.

**Answer**: Use **AWS Transit Gateway** as the central hub. Share the Transit Gateway across accounts using **AWS RAM**. Attach all 50 VPCs to the Transit Gateway. Connect on-premises via either:
- **Direct Connect** with Transit VIF → DX Gateway → Transit Gateway
- **Site-to-Site VPN** directly to the Transit Gateway
Use Transit Gateway route tables for network segmentation if needed.

### Scenario 4: Migrate 100 TB with Limited Bandwidth

**Question**: A company needs to migrate 100 TB of data to S3. They have a 50 Mbps internet connection. The migration must be complete within 2 weeks.

**Answer**: Calculate: 100 TB over 50 Mbps = ~185 days (way too long). Use **AWS Snowball Edge Storage Optimized** devices. Order 2 devices (80 TB each). Load data, ship to AWS, data imported into S3. Turnaround time: ~1–2 weeks. For incremental changes during shipping, use **DataSync** over the existing 50 Mbps connection.

### Scenario 5: Daily File Sync to S3

**Question**: A company needs to synchronize files from their on-premises NFS server to S3 daily, with only changed files transferred.

**Answer**: Use **AWS DataSync**. Deploy a DataSync agent on-premises (as a VM). Configure a task with NFS as the source and S3 as the destination. Schedule the task to run daily (cron expression). DataSync automatically performs incremental transfers (only changed files). Configure bandwidth throttling to avoid impacting production traffic.

### Scenario 6: Partner File Exchange via SFTP

**Question**: External business partners need to upload files to the company's S3 bucket using SFTP.

**Answer**: Use **AWS Transfer Family** with SFTP protocol. Create an SFTP server endpoint (public-facing). Configure user authentication (service-managed or custom Lambda-based for partner-specific auth). Use **logical directories** to map each partner to their own S3 prefix. Set IAM roles per user to restrict S3 access. Enable CloudWatch logging for audit.

### Scenario 7: Global Upload Acceleration

**Question**: A company has users worldwide uploading large video files (2–10 GB) to a single S3 bucket in us-east-1. Upload speeds are slow for users in Asia and Australia.

**Answer**: Enable **S3 Transfer Acceleration** on the bucket. Users upload to `<bucket>.s3-accelerate.amazonaws.com`. Files enter the AWS network at the nearest CloudFront edge location and traverse the optimized AWS backbone. Combined with **multipart upload** for large files. Use the speed comparison tool to verify acceleration benefit.

### Scenario 8: Encrypted Traffic over Direct Connect

**Question**: A healthcare company uses Direct Connect but needs to encrypt all traffic for HIPAA compliance.

**Answer**: Two options:
1. **DX + VPN**: Create an IPsec VPN tunnel over the Direct Connect connection. Provides encryption but limits throughput to ~1.25 Gbps per tunnel.
2. **DX + MACsec**: If using 10 Gbps or 100 Gbps dedicated connection, enable MACsec for line-rate Layer 2 encryption. No throughput impact. Requires MACsec-capable hardware on the customer side.

### Scenario 9: Multi-Region VPC Connectivity

**Question**: A company has VPCs in us-east-1, eu-west-1, and ap-southeast-1 that need to communicate with each other.

**Answer**: Deploy a **Transit Gateway** in each region. Set up **Transit Gateway inter-region peering** between all three regions. Attach VPCs in each region to their local Transit Gateway. Configure route tables to route inter-region traffic through the peering connections. All traffic stays on the AWS private network.

### Scenario 10: Edge Computing at Remote Location

**Question**: A mining company needs to process sensor data at a remote location with no internet connectivity, then periodically ship the processed results to AWS.

**Answer**: Deploy **AWS Snowball Edge Compute Optimized** at the remote location. Run EC2 instances on the device to process sensor data locally. Store results on the device's S3-compatible storage. When the device is full (or on a schedule), ship it to AWS for data import into S3. Order a replacement device to maintain continuous operations (rolling device rotation).

### Scenario 11: Aggregate VPN Bandwidth

**Question**: A company needs more than 1.25 Gbps of encrypted throughput to their VPC over VPN.

**Answer**: Use **Transit Gateway** with **ECMP (Equal-Cost Multi-Path routing)**. Create multiple VPN connections to the Transit Gateway. With ECMP enabled, traffic is distributed across all VPN tunnels. 2 VPN connections = 4 tunnels ≈ up to 5 Gbps aggregate throughput. Note: ECMP is only available with Transit Gateway, NOT with Virtual Private Gateway.

### Scenario 12: Cross-Region Direct Connect Access

**Question**: A company has a single Direct Connect connection in us-east-1 but needs to access VPCs in eu-west-1 and ap-southeast-1.

**Answer**: Create a **Direct Connect Gateway** and associate it with VGWs in all three regions (or Transit Gateways for a hub-and-spoke model). Create a Private VIF (or Transit VIF) on the DX connection and associate it with the DX Gateway. The DX Gateway enables cross-region access from a single DX connection. No additional DX connections needed in other regions.

---

## Key Takeaways for the Exam

1. **Direct Connect** = Dedicated private connection, consistent low-latency, 1/10/100 Gbps; takes weeks to set up
2. **Dedicated DX** = 1/10/100 Gbps, you get a physical port; **Hosted DX** = 50 Mbps–10 Gbps via partner
3. **Private VIF** = Access VPC resources; **Public VIF** = Access public AWS services; **Transit VIF** = Access Transit Gateway
4. **DX Gateway** = Cross-region VPC access from a single DX connection
5. **DX + VPN** = Encrypted connection over Direct Connect for compliance
6. **MACsec** = Line-rate Layer 2 encryption for 10/100 Gbps DX connections
7. **LAG** = Aggregate DX connections at SAME location for bandwidth + redundancy
8. **SiteLink** = Site-to-site connectivity via AWS backbone (bypass AWS region)
9. **Site-to-Site VPN** = Encrypted, internet-based, quick setup, up to 1.25 Gbps per tunnel
10. **Accelerated VPN** = Uses Global Accelerator for better performance, requires Transit Gateway
11. **Transit Gateway** = Hub-and-spoke for VPCs + VPN + DX; **ECMP** for VPN bandwidth aggregation
12. **VPN CloudHub** = Connect multiple branch offices through a single VGW
13. **Snowcone** = 8–14 TB, portable; **Snowball Edge** = 28–80 TB, compute/storage; **Snowmobile** = 100 PB
14. **DataSync** = Automated file sync with scheduling, filtering, bandwidth control; agent needed on-premises
15. **Transfer Family** = SFTP/FTPS/FTP/AS2 to S3 or EFS; replaces self-managed FTP servers
16. **S3 Transfer Acceleration** = Uses CloudFront edge locations for faster uploads over long distances
17. **Bandwidth rule of thumb**: If network transfer takes > 1 week, consider Snow Family
