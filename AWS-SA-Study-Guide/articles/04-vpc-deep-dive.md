# VPC Deep Dive

## Table of Contents

- [Overview](#overview)
- [VPC Fundamentals](#vpc-fundamentals)
  - [CIDR Blocks](#cidr-blocks)
  - [Default VPC](#default-vpc)
- [Subnets](#subnets)
  - [Public vs Private Subnets](#public-vs-private-subnets)
  - [Subnet Sizing and Reserved IPs](#subnet-sizing-and-reserved-ips)
- [Route Tables](#route-tables)
- [Internet Gateway](#internet-gateway)
- [NAT Gateway vs NAT Instance](#nat-gateway-vs-nat-instance)
- [Elastic IPs](#elastic-ips)
- [Security Groups](#security-groups)
- [Network ACLs](#network-acls)
- [Security Groups vs NACLs](#security-groups-vs-nacls)
- [VPC Peering](#vpc-peering)
- [Transit Gateway](#transit-gateway)
- [VPC Endpoints](#vpc-endpoints)
- [VPN Connectivity](#vpn-connectivity)
- [AWS Direct Connect](#aws-direct-connect)
- [VPC Flow Logs](#vpc-flow-logs)
- [DNS in VPC](#dns-in-vpc)
- [IPv6 in VPC](#ipv6-in-vpc)
- [AWS Network Firewall](#aws-network-firewall)
- [Traffic Mirroring](#traffic-mirroring)
- [Reachability Analyzer](#reachability-analyzer)
- [VPC Sharing with RAM](#vpc-sharing-with-ram)
- [AWS PrivateLink](#aws-privatelink)
- [CIDR Calculation Examples](#cidr-calculation-examples)
- [Common Exam Scenarios](#common-exam-scenarios)

---

## Overview

Amazon Virtual Private Cloud (VPC) is the foundational networking layer in AWS. It allows you to launch AWS resources in a logically isolated virtual network that you define. VPC is one of the most heavily tested topics on the SAA-C03 exam.

---

## VPC Fundamentals

### CIDR Blocks

CIDR (Classless Inter-Domain Routing) blocks define the IP address range for your VPC.

**Key rules:**
- A VPC can have a **primary CIDR block** and up to **4 secondary CIDR blocks** (total of 5)
- Minimum size: **/28** (16 IP addresses)
- Maximum size: **/16** (65,536 IP addresses)
- The CIDR block **cannot be changed** after creation (but you can add secondary CIDR blocks)
- CIDR blocks **cannot overlap** with other VPCs you are peering with
- AWS-recommended RFC 1918 private ranges:
  - `10.0.0.0/8` (10.0.0.0 – 10.255.255.255) — Class A
  - `172.16.0.0/12` (172.16.0.0 – 172.31.255.255) — Class B
  - `192.168.0.0/16` (192.168.0.0 – 192.168.255.255) — Class C
- You CAN use public IP ranges, but AWS strongly discourages it
- Secondary CIDR blocks can be from a different range (e.g., primary `10.0.0.0/16`, secondary `100.64.0.0/16`)

**VPC characteristics:**
- VPCs are **Regional** — they span all AZs in a Region
- You can have up to **5 VPCs per Region** (soft limit, can be increased)
- VPCs do not span Regions
- Each VPC is completely isolated from other VPCs (unless you connect them)
- A VPC comes with a default route table, default security group, and default NACL

### Default VPC

Every Region has a **default VPC** created automatically when you first create your AWS account.

**Default VPC characteristics:**
- CIDR block: `172.31.0.0/16`
- One default subnet in each AZ with a **/20** CIDR block (4,096 addresses)
- An Internet Gateway is attached
- The default route table has a route to the Internet Gateway
- Default security group allows all outbound, all inbound from the same SG
- Default NACL allows all inbound and outbound
- Instances launched in the default VPC get a **public IP automatically**
- Has `enableDnsHostnames` and `enableDnsSupport` enabled by default

> **Exam Tip:** If you accidentally delete the default VPC, you can recreate it from the VPC console (Actions → Create Default VPC).

---

## Subnets

A subnet is a range of IP addresses in your VPC. Each subnet must reside entirely within **one Availability Zone** — subnets cannot span AZs.

### Public vs Private Subnets

There is no inherent AWS property that makes a subnet "public" or "private." The distinction comes from the **route table configuration**:

**Public Subnet:**
- Has a route to an **Internet Gateway** (0.0.0.0/0 → igw-xxx)
- Instances with public IPs can communicate directly with the internet
- Typically hosts: load balancers, bastion hosts, NAT Gateways

**Private Subnet:**
- Does **NOT** have a route to an Internet Gateway
- Instances cannot be reached directly from the internet
- For outbound internet access, route traffic through a NAT Gateway/Instance in a public subnet (0.0.0.0/0 → nat-xxx)
- Typically hosts: application servers, databases, backend services

### Subnet Sizing and Reserved IPs

AWS reserves **5 IP addresses** in every subnet (the first 4 and the last 1):

For a subnet with CIDR `10.0.1.0/24` (256 total IPs):

| IP Address | Reserved For | Description |
|---|---|---|
| `10.0.1.0` | Network address | Base network address |
| `10.0.1.1` | VPC router | AWS reserves for the VPC router |
| `10.0.1.2` | DNS server | AWS-provided DNS (VPC base + 2) |
| `10.0.1.3` | Future use | Reserved by AWS for future use |
| `10.0.1.255` | Broadcast | Network broadcast address |

**Usable IPs = Total IPs - 5**

Examples:
- `/24` → 256 - 5 = **251 usable**
- `/25` → 128 - 5 = **123 usable**
- `/26` → 64 - 5 = **59 usable**
- `/27` → 32 - 5 = **27 usable**
- `/28` → 16 - 5 = **11 usable** (smallest subnet)

### Subnet Best Practices
- Create subnets in **at least 2 AZs** for high availability
- Use separate subnets for public and private resources
- Size subnets appropriately (consider future growth)
- Use consistent CIDR allocation patterns across AZs

---

## Route Tables

Route tables contain rules (routes) that determine where network traffic is directed.

### Key Concepts

- Every VPC has a **main route table** (created automatically)
- You can create **custom route tables** and associate them with subnets
- Each subnet must be associated with **exactly one route table**
- If not explicitly associated, a subnet uses the **main route table**
- A route table can be associated with **multiple subnets**
- Each route has a **destination** (CIDR block) and a **target** (where to send traffic)

### Route Priority

When multiple routes match, AWS uses the **most specific route** (longest prefix match):

```
Route Table:
  10.0.0.0/16 → local           (matches traffic within VPC)
  0.0.0.0/0   → igw-12345       (matches all other traffic)
  10.1.0.0/16 → pcx-12345       (matches peered VPC traffic)
  172.16.0.0/24 → vpn-12345     (matches VPN traffic)
```

If a packet is destined for `10.1.0.5`:
- Matches `10.0.0.0/16`? No (10.1.0.5 is not in 10.0.0.0/16)
- Matches `10.1.0.0/16`? Yes → Routes to peering connection
- Matches `0.0.0.0/0`? Yes, but `/16` is more specific than `/0`

**Longest prefix match** means the route with the most specific (longest) matching prefix wins.

### Common Route Table Entries

| Destination | Target | Purpose |
|---|---|---|
| `10.0.0.0/16` | local | VPC internal traffic (cannot be modified/deleted) |
| `0.0.0.0/0` | igw-xxx | Internet access via IGW |
| `0.0.0.0/0` | nat-xxx | Internet access via NAT Gateway |
| `10.1.0.0/16` | pcx-xxx | Traffic to peered VPC |
| `172.16.0.0/16` | vgw-xxx | Traffic to on-premises via VPN |
| `0.0.0.0/0` | tgw-xxx | Default route through Transit Gateway |
| `pl-xxx` | vpce-xxx | Traffic to VPC endpoint (prefix list) |

### Edge Route Tables (Gateway Route Tables)

- Associated with Internet Gateways or Virtual Private Gateways
- Direct incoming traffic to specific appliances (e.g., firewall)
- Used for advanced network inspection architectures

---

## Internet Gateway

An Internet Gateway (IGW) enables communication between instances in your VPC and the internet.

### Key Characteristics

- **One IGW per VPC** (and one VPC per IGW)
- **Horizontally scaled, redundant, and highly available** — no bandwidth constraints
- Performs **network address translation (NAT)** for instances with public IPs
- Does not perform NAT for instances with only private IPs
- Must be created separately and attached to the VPC
- Route table must have a route pointing to the IGW for internet access

### How IGW Works

For an EC2 instance to have internet access:
1. The VPC must have an IGW attached
2. The subnet's route table must have `0.0.0.0/0 → igw-xxx`
3. The instance must have a **public IP** or **Elastic IP**
4. The security group must allow the traffic
5. The NACL must allow the traffic

The IGW performs 1:1 NAT between the instance's private IP and its public IP. The instance only knows its private IP — the public IP mapping is handled by the IGW.

---

## NAT Gateway vs NAT Instance

Both allow instances in private subnets to access the internet while remaining unreachable from the internet. NAT Gateway is the AWS-managed solution; NAT Instance is the self-managed alternative.

### Comparison Table

| Feature | NAT Gateway | NAT Instance |
|---|---|---|
| **Managed by** | AWS | You |
| **Availability** | Highly available within AZ | You must manage (scripted failover) |
| **Bandwidth** | Up to 100 Gbps | Depends on instance type |
| **Performance** | AWS-optimized | General purpose |
| **Cost** | Hourly charge + data processing | Instance cost + data transfer |
| **Elastic IP** | Associated at creation | Assigned manually |
| **Security Groups** | Cannot be associated | Can use security groups |
| **NACLs** | Applies (subnet-level) | Applies (subnet-level) |
| **Bastion Host** | Cannot be used as one | Can be used as a bastion |
| **Port forwarding** | Not supported | Supported (manual config) |
| **Source/Dest Check** | N/A (managed) | Must be disabled |
| **Protocol** | TCP, UDP, ICMP | TCP, UDP, ICMP |
| **Placement** | Must be in a public subnet | Must be in a public subnet |
| **Multi-AZ** | Deploy one per AZ for HA | Deploy one per AZ for HA |

### NAT Gateway Architecture for High Availability

```
VPC (10.0.0.0/16)
├── AZ-a
│   ├── Public Subnet (10.0.1.0/24)
│   │   └── NAT Gateway A (with EIP)
│   └── Private Subnet (10.0.2.0/24)
│       └── Route: 0.0.0.0/0 → NAT Gateway A
├── AZ-b
│   ├── Public Subnet (10.0.3.0/24)
│   │   └── NAT Gateway B (with EIP)
│   └── Private Subnet (10.0.4.0/24)
│       └── Route: 0.0.0.0/0 → NAT Gateway B
```

Each AZ has its own NAT Gateway with its own route table entry. If one AZ fails, the other AZ's private subnet still has internet access.

### NAT Gateway Pricing
- Hourly charge: ~$0.045/hour (~$32/month per NAT Gateway)
- Data processing: ~$0.045/GB
- For high-availability, you need one per AZ (potentially $96+/month for 3 AZs)
- Cost optimization: If non-critical, you can use a single NAT Gateway (accepting the AZ risk)

---

## Elastic IPs

An Elastic IP (EIP) is a static, public IPv4 address allocated to your account.

### Key Characteristics
- EIPs persist until you release them (unlike dynamic public IPs)
- Can be associated with an instance or a network interface
- When associated with a stopped instance, **you are charged** for the unused EIP
- When associated with a running instance, there is **no additional charge**
- Limit: **5 EIPs per Region** per account (can be increased)
- EIPs can be moved between instances within the same Region
- EIPs from one Region cannot be used in another Region
- You can tag EIPs for cost allocation

> **Exam Tip:** AWS charges for EIPs that are allocated but not associated with a running instance. This is to discourage waste of IPv4 addresses.

---

## Security Groups

Security groups act as a virtual firewall for your instances, controlling inbound and outbound traffic at the **instance level** (specifically, the ENI level).

### Key Characteristics

- **Stateful** — if you allow inbound traffic, the response is automatically allowed outbound (and vice versa)
- **Allow rules only** — you cannot create deny rules
- Default behavior: all inbound denied, all outbound allowed
- Applied at the **ENI (network interface) level**, not subnet level
- An instance can have up to **5 security groups** (can be increased)
- A security group can have up to **60 inbound + 60 outbound rules** (can be increased)
- Security groups are **VPC-scoped** — they exist within a specific VPC
- Changes take effect **immediately**
- You can reference other security groups as sources/destinations (security group chaining)

### Security Group Chaining

This is a powerful pattern and common exam topic:

```
Internet → ALB (SG: AllowHTTP from 0.0.0.0/0)
              │
              ▼
         App Servers (SG: AllowHTTP from ALB-SG)
              │
              ▼
         Database (SG: Allow3306 from AppServer-SG)
```

By referencing security groups instead of IP addresses:
- You don't need to know the IP addresses of the source instances
- When instances are added/removed, security group rules automatically apply
- It creates a clean, layered security architecture

### Default Security Group

- Every VPC has a default security group
- **Inbound:** Allows all traffic from the same security group (self-referencing)
- **Outbound:** Allows all traffic to all destinations
- You cannot delete the default security group, but you can modify its rules
- Best practice: Do not use the default security group — create custom ones

### Security Group Rule Components

| Component | Description | Example |
|---|---|---|
| Protocol | IP protocol | TCP, UDP, ICMP, All |
| Port Range | Port or range | 80, 443, 1024-65535 |
| Source/Destination | IP, CIDR, or SG | 10.0.0.0/16, sg-xxx |
| Description | Optional note | "Allow HTTP from ALB" |

---

## Network ACLs

Network ACLs (NACLs) are an additional layer of security that operates at the **subnet level**.

### Key Characteristics

- **Stateless** — inbound and outbound rules are evaluated independently
- Supports **allow AND deny** rules
- Rules are evaluated in **order by rule number** (lowest first)
- Default NACL: allows all inbound and outbound traffic
- Custom NACL: denies all inbound and outbound traffic by default
- Applied at the **subnet level** — all instances in the subnet are affected
- One NACL per subnet (but a NACL can be associated with multiple subnets)
- Rules have a **number** (1-32766); lower numbers evaluated first
- First matching rule wins; remaining rules are not evaluated
- Always has a catch-all deny rule (rule number `*`) at the end

### Ephemeral Ports

Because NACLs are stateless, you must explicitly allow return traffic on **ephemeral ports**:

- **Linux:** uses ephemeral ports 32768-65535
- **Windows:** uses ephemeral ports 49152-65535
- **ELB/NAT Gateway:** uses ports 1024-65535

When an instance in your subnet initiates a connection to an external server:
1. The **outbound** NACL rule must allow traffic to the destination IP and port
2. The **inbound** NACL rule must allow return traffic from the source IP on the ephemeral port range

### NACL Rule Example

| Rule # | Type | Protocol | Port Range | Source | Allow/Deny |
|---|---|---|---|---|---|
| 100 | HTTP | TCP | 80 | 0.0.0.0/0 | ALLOW |
| 110 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW |
| 120 | SSH | TCP | 22 | 10.0.0.0/16 | ALLOW |
| 130 | Custom TCP | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW |
| * | All traffic | All | All | 0.0.0.0/0 | DENY |

> **Best Practice:** Number rules in increments of 10 or 100 so you can insert new rules between existing ones.

---

## Security Groups vs NACLs

| Feature | Security Group | Network ACL |
|---|---|---|
| **Level** | Instance/ENI | Subnet |
| **Stateful/Stateless** | Stateful | Stateless |
| **Rule Type** | Allow only | Allow and Deny |
| **Rule Evaluation** | All rules evaluated | Rules evaluated in order |
| **Default (inbound)** | Deny all | Allow all (default NACL) |
| **Default (outbound)** | Allow all | Allow all (default NACL) |
| **Applies to** | Only if associated with instance | All instances in subnet |
| **Return traffic** | Automatically allowed | Must be explicitly allowed |
| **Number of rules** | 60 in + 60 out per SG | 20 in + 20 out per NACL |
| **Can block specific IPs** | No (allow only) | Yes (deny rules) |

> **Exam Tip:** If a question asks about blocking a specific IP address, the answer is NACL (because security groups only support Allow rules). This is one of the most common networking questions.

---

## VPC Peering

VPC Peering creates a networking connection between two VPCs that enables you to route traffic between them using private IP addresses.

### Key Characteristics

- Peered VPCs can be in the **same or different accounts**
- Peered VPCs can be in the **same or different Regions** (inter-region peering)
- CIDR blocks of peered VPCs **must not overlap**
- **Not transitive:** If VPC A peers with VPC B, and VPC B peers with VPC C, VPC A cannot reach VPC C through VPC B
- Each VPC peering connection is a **one-to-one relationship**
- You must update **route tables in both VPCs** to route traffic through the peering connection
- Security groups can reference peer VPC security groups (same-region peering only)
- DNS resolution can be enabled to resolve private hostnames across peered VPCs
- Data transfer across peering: same-region is cheaper (~$0.01/GB), cross-region varies
- Max 125 peering connections per VPC (50 default)

### VPC Peering Setup

```
VPC A (10.0.0.0/16) ←→ VPC B (172.16.0.0/16)

VPC A Route Table:
  172.16.0.0/16 → pcx-xxx

VPC B Route Table:
  10.0.0.0/16 → pcx-xxx
```

### Limitations

- **No transitive peering** — this is the most common exam topic about VPC peering
- Cannot create a peering connection between VPCs with overlapping CIDR blocks
- Cannot have more than one peering connection between the same two VPCs
- Cannot reference a peer VPC's security group across Regions
- The peering connection must be accepted by the other VPC owner
- Each side must update their route tables independently

---

## Transit Gateway

AWS Transit Gateway acts as a regional network transit hub to interconnect VPCs and on-premises networks through a central hub.

### Key Characteristics

- **Hub-and-spoke model** — each VPC/VPN connects to the Transit Gateway instead of peering with each other
- Supports **thousands of VPC attachments**
- Works with **VPN**, **Direct Connect**, **VPC peering**, and **other Transit Gateways** (inter-region peering)
- **Transitive routing** — VPC A can reach VPC B through the Transit Gateway
- Supports **multiple route tables** for network segmentation
- Supports **multicast**
- **Regional resource**, but can peer with Transit Gateways in other Regions
- Supports **ECMP** (Equal-Cost Multi-Path) routing for VPN connections (aggregate bandwidth)
- Can be shared across accounts using AWS RAM

### Transit Gateway Components

```
Transit Gateway
├── Attachments
│   ├── VPC A attachment
│   ├── VPC B attachment
│   ├── VPC C attachment
│   ├── VPN attachment (on-premises)
│   └── Direct Connect Gateway attachment
├── Route Tables
│   ├── Default route table
│   └── Custom route tables (for segmentation)
└── Associations & Propagations
    ├── Each attachment associated with a route table
    └── Routes propagated or statically added
```

### Route Table Segmentation

You can create multiple Transit Gateway route tables to isolate traffic:

```
TGW Route Table: Shared-Services
  Routes: VPC-A, VPC-B, VPC-Shared → all can communicate

TGW Route Table: Isolated-Prod
  Routes: VPC-Prod → can only reach VPC-Shared, not VPC-Dev

TGW Route Table: Isolated-Dev
  Routes: VPC-Dev → can only reach VPC-Shared, not VPC-Prod
```

### Transit Gateway vs VPC Peering

| Feature | VPC Peering | Transit Gateway |
|---|---|---|
| **Connectivity** | Point-to-point | Hub-and-spoke |
| **Transitive routing** | No | Yes |
| **Scalability** | O(n²) connections | O(n) connections |
| **Cost** | Data transfer only | Hourly + data transfer |
| **Cross-region** | Supported | Inter-region peering |
| **Bandwidth** | No limit | Up to 50 Gbps per attachment |
| **Multicast** | Not supported | Supported |
| **Best for** | Few VPCs, simple topology | Many VPCs, complex topology |

---

## VPC Endpoints

VPC Endpoints allow you to privately connect your VPC to supported AWS services without requiring an internet gateway, NAT device, VPN, or Direct Connect.

### Interface Endpoints (AWS PrivateLink)

- Powered by **AWS PrivateLink**
- Creates an **Elastic Network Interface (ENI)** with a private IP in your subnet
- Supports most AWS services (and third-party services in AWS Marketplace)
- **Costs:** Hourly charge (~$0.01/hr) + data processing (~$0.01/GB)
- Security groups can be attached to interface endpoints
- Requires **DNS resolution** — can use private DNS to override the public service endpoint
- When private DNS is enabled, requests to the service's default DNS name route to the interface endpoint

### Gateway Endpoints

- Available for **only two services:** **S3** and **DynamoDB**
- Creates a **route table entry** (prefix list) — no ENI is created
- **Free** — no hourly or data processing charges
- Does not use security groups — use VPC endpoint policies to control access
- Must be in the same Region as the VPC
- Specified in the route table as a target (prefix list: `pl-xxx`)

### Comparison

| Feature | Interface Endpoint | Gateway Endpoint |
|---|---|---|
| **Services** | Most AWS services | S3 and DynamoDB only |
| **Implementation** | ENI in subnet | Route table entry |
| **Cost** | Hourly + data processing | Free |
| **Security** | Security groups + endpoint policy | Endpoint policy only |
| **Access from on-prem** | Yes (via VPN/DX) | No (route table only) |
| **Cross-region** | No | No |
| **DNS** | Private DNS override | Uses S3/DDB endpoint |

### VPC Endpoint Policies

Both endpoint types support endpoint policies that control access:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSpecificBucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::my-bucket",
        "arn:aws:s3:::my-bucket/*"
      ]
    }
  ]
}
```

> **Important:** The endpoint policy does not override IAM policies or S3 bucket policies. All three must allow the action.

> **Exam Tip:** For S3, you can use either a Gateway Endpoint (free) or an Interface Endpoint (paid). Use Gateway Endpoint unless you need access from on-premises via VPN/DX (which requires Interface Endpoint).

---

## VPN Connectivity

### Site-to-Site VPN

Connects your on-premises network to your VPC over the internet using IPsec VPN tunnels.

**Components:**
- **Virtual Private Gateway (VGW):** VPN concentrator on the AWS side, attached to the VPC
- **Customer Gateway (CGW):** A resource in AWS that represents your on-premises VPN device
- **VPN Connection:** The encrypted tunnel between VGW and CGW

**Key characteristics:**
- Each VPN connection has **two tunnels** for redundancy (active/passive or active/active)
- Supports **static routing** or **dynamic routing (BGP)**
- Max throughput per tunnel: **1.25 Gbps**
- Can use **ECMP** with Transit Gateway to aggregate bandwidth across multiple VPN connections
- Internet-dependent — quality varies with internet conditions
- Typical setup time: minutes
- IPsec encryption
- Can accelerate with **AWS Global Accelerator** for consistent performance

### Client VPN

Managed client-based VPN to securely access AWS resources or on-premises networks.

**Key characteristics:**
- OpenVPN-based
- Users connect from laptops/mobile devices
- Supports Active Directory and certificate-based authentication
- Split-tunnel or full-tunnel options
- Supports MFA
- Scales automatically based on demand

### AWS VPN CloudHub

Connects multiple remote offices using the VPN hub-and-spoke model:
- Multiple Customer Gateways connect to a single VGW
- Remote offices can communicate with each other (through AWS)
- Requires BGP for dynamic routing
- Low cost and simple to set up

---

## AWS Direct Connect

Direct Connect provides a dedicated private network connection from your on-premises data center to AWS.

### Connection Types

| Type | Bandwidth | Lead Time | Provider |
|---|---|---|---|
| **Dedicated Connection** | 1 Gbps, 10 Gbps, 100 Gbps | Weeks to months | Direct from AWS |
| **Hosted Connection** | 50 Mbps to 10 Gbps | Days to weeks | Through AWS Partner |

### Link Aggregation Groups (LAG)

- Bundle multiple Direct Connect connections (same bandwidth) into one logical connection
- Up to **4 connections** in a LAG
- All connections must be the same bandwidth and terminate at the same DX location
- Provides aggregate bandwidth and redundancy

### Virtual Interfaces (VIFs)

| VIF Type | Purpose | What It Accesses |
|---|---|---|
| **Private VIF** | Connect to VPC | Resources in VPC via VGW |
| **Public VIF** | Connect to AWS public services | S3, DynamoDB, public endpoints |
| **Transit VIF** | Connect to Transit Gateway | Multiple VPCs via TGW |

### Direct Connect Gateway

A Direct Connect Gateway enables you to connect your Direct Connect connection to VPCs in **any Region** (except China):

```
On-premises → DX Connection → DX Gateway → VGW (VPC in us-east-1)
                                          → VGW (VPC in eu-west-1)
                                          → TGW (multiple VPCs)
```

### Encryption with Direct Connect

Direct Connect traffic is **NOT encrypted by default** (it's a private connection, but not encrypted).

To add encryption:
- Run a **Site-to-Site VPN over Direct Connect** using a Public VIF
- This provides IPsec encryption over the dedicated connection
- The VPN terminates at a VGW or Transit Gateway
- Alternatively, use **MACsec** (802.1AE) for Layer 2 encryption on 10 Gbps and 100 Gbps connections

### Direct Connect Resiliency

**Maximum resiliency (critical workloads):**
- Separate connections from separate DX locations

**High resiliency (important workloads):**
- Two connections at one DX location

**Development and test:**
- Single connection

**Common pattern: DX + VPN backup:**
```
Primary: Direct Connect (1 Gbps)
Backup: Site-to-Site VPN (over internet)
```
Use BGP to failover from DX to VPN automatically.

---

## VPC Flow Logs

VPC Flow Logs capture information about the IP traffic going to and from network interfaces in your VPC.

### Log Levels

| Level | What It Captures |
|---|---|
| **VPC Flow Log** | All traffic in the entire VPC |
| **Subnet Flow Log** | All traffic in a specific subnet |
| **ENI Flow Log** | Traffic for a specific network interface |

### Destinations

- **Amazon CloudWatch Logs**
- **Amazon S3**
- **Amazon Kinesis Data Firehose**

### Default Log Format

```
<version> <account-id> <interface-id> <srcaddr> <dstaddr> <srcport> <dstport> <protocol> <packets> <bytes> <start> <end> <action> <log-status>
```

Example:
```
2 123456789012 eni-abc123de 10.0.1.5 10.0.2.10 49152 443 6 20 4000 1620140761 1620140821 ACCEPT OK
2 123456789012 eni-abc123de 203.0.113.12 10.0.1.5 0 0 1 4 336 1620140761 1620140821 REJECT OK
```

Fields explained:
- `version`: Log format version (2 = default)
- `account-id`: AWS account ID
- `interface-id`: ENI ID
- `srcaddr`/`dstaddr`: Source/destination IP
- `srcport`/`dstport`: Source/destination port
- `protocol`: IANA protocol number (6 = TCP, 17 = UDP, 1 = ICMP)
- `packets`/`bytes`: Number of packets and bytes
- `start`/`end`: Start and end time of capture window (Unix timestamp)
- `action`: ACCEPT or REJECT
- `log-status`: OK, NODATA, or SKIPDATA

### Custom Log Format

You can select additional fields in a custom format:
- `vpc-id`, `subnet-id`, `instance-id`
- `type` (IPv4, IPv6, EFA)
- `pkt-srcaddr`, `pkt-dstaddr` (original packet source/destination, useful for NAT)
- `region`, `az-id`
- `sublocation-type`, `sublocation-id`
- `tcp-flags`
- `traffic-path` (for egress traffic — identifies the path taken)

### What Flow Logs Do NOT Capture

- DNS traffic to the VPC DNS server (Amazon-provided DNS)
- DHCP traffic
- Traffic to the instance metadata service (`169.254.169.254`)
- Traffic to the Amazon Time Sync Service (`169.254.169.123`)
- Traffic to reserved IP addresses for the default VPC router
- Traffic between an endpoint network interface and a Network Load Balancer
- DHCP and DNS queries to the Amazon-provided DNS server

### Key Exam Facts

- Flow Logs do not affect network throughput or latency
- You cannot modify a flow log after creation (must delete and recreate)
- Flow Logs capture traffic at the **network interface level**
- You can filter on ACCEPT, REJECT, or ALL traffic
- Not real-time — there is a capture window and delivery delay

---

## DNS in VPC

### VPC DNS Settings

Two key VPC attributes control DNS behavior:

| Setting | Default | Description |
|---|---|---|
| `enableDnsSupport` | true | Enables DNS resolution via the Amazon-provided DNS server at VPC base + 2 (e.g., 10.0.0.2) |
| `enableDnsHostnames` | false (non-default VPC) | Assigns public DNS hostnames to instances with public IPs |

For public DNS hostnames to work, **both** must be `true`.

### Amazon-Provided DNS

- Always at the VPC CIDR base address + 2 (e.g., `10.0.0.2` for a `10.0.0.0/16` VPC)
- Also accessible at `169.254.169.253`
- Resolves:
  - Public DNS hostnames to public IPs
  - Private DNS hostnames to private IPs
  - Route 53 private hosted zones
  - Route 53 Resolver rules

### Route 53 Resolver

Route 53 Resolver enables DNS resolution between your VPC and on-premises networks.

**Inbound Endpoints:**
- Allow on-premises DNS servers to forward queries to Route 53 Resolver
- On-premises resolvers send DNS queries to the inbound endpoint IP
- Resolves AWS private hosted zones and VPC DNS names

**Outbound Endpoints:**
- Allow Route 53 Resolver to forward queries to on-premises DNS servers
- Uses **forwarding rules** to determine which queries to forward
- Example: Forward `corp.example.com` queries to on-premises DNS at `10.1.0.53`

**Architecture:**
```
On-premises DNS ←→ Inbound Endpoint (ENI in VPC)
                    Route 53 Resolver
VPC DNS ←→ Outbound Endpoint (ENI in VPC) ←→ On-premises DNS
```

### DHCP Option Sets

DHCP option sets control the following VPC DNS/NTP settings:
- `domain-name`: Domain name for the VPC
- `domain-name-servers`: DNS server IPs (default: AmazonProvidedDNS)
- `ntp-servers`: NTP server IPs
- `netbios-name-servers`: NetBIOS name server IPs
- `netbios-node-type`: NetBIOS node type

**Key facts:**
- Each VPC is associated with one DHCP option set
- You cannot modify a DHCP option set — create a new one and associate it
- You can use your own DNS server instead of Amazon's

---

## IPv6 in VPC

### Dual-Stack Mode

- VPCs support **dual-stack** — both IPv4 and IPv6 simultaneously
- IPv6 CIDR block: assigned from AWS's pool (you can also bring your own)
- IPv6 addresses are **globally unique** and **publicly routable** (no NAT needed)
- All IPv6 addresses are public (no concept of "private" IPv6 in VPC)
- You cannot disable IPv4 — VPCs must always have an IPv4 CIDR
- Subnet IPv6 CIDR: always **/64** (assigned from the VPC's /56)

### Egress-Only Internet Gateway

For IPv6 instances in private subnets that need outbound internet access:

- **Egress-only Internet Gateway** is the IPv6 equivalent of a NAT Gateway
- Allows outbound IPv6 traffic and return traffic
- Blocks inbound IPv6 traffic initiated from the internet
- Stateful
- Free (no per-hour charge like NAT Gateway)

> **Exam Tip:** For IPv4 outbound from private subnets → NAT Gateway. For IPv6 outbound from private subnets → Egress-Only Internet Gateway.

---

## AWS Network Firewall

AWS Network Firewall is a managed network firewall and intrusion detection/prevention service for VPCs.

### Key Characteristics

- **Stateful and stateless** rule groups
- Operates at **layers 3-7** (IP, TCP/UDP, HTTP, TLS/SNI, domain filtering)
- Uses **Gateway Load Balancer** under the hood for scalability
- Deployed in a dedicated **firewall subnet** in each AZ
- Supports:
  - IP/port filtering (stateless)
  - Protocol-based filtering
  - Stateful connection tracking
  - Domain name (FQDN) filtering
  - Suricata-compatible IPS rules
  - TLS/SNI inspection

### Deployment Models

**Centralized Model (with Transit Gateway):**
```
Internet → IGW → Firewall Subnet → TGW → Spoke VPCs
```

**Distributed Model:**
```
Each VPC: Internet → IGW → Firewall Subnet → Application Subnets
```

### Rule Types

| Rule Type | Layer | State | Use Case |
|---|---|---|---|
| Stateless | 3-4 | No state tracking | Simple allow/deny by IP/port |
| Stateful (5-tuple) | 3-4 | Tracks connections | Allow established connections |
| Stateful (Domain) | 7 | Tracks connections | Allow/deny by domain name |
| Stateful (Suricata) | 3-7 | IPS rules | Deep packet inspection |

---

## Traffic Mirroring

VPC Traffic Mirroring copies network traffic from ENIs and sends it to security or monitoring appliances.

### Key Characteristics
- **Source:** ENI of an EC2 instance
- **Target:** ENI or Network Load Balancer (for multiple appliances)
- Creates a copy of the traffic (does not affect original traffic)
- Can filter by direction (inbound/outbound), protocol, and port
- Captured via **VXLAN encapsulation**
- Use cases: content inspection, threat monitoring, troubleshooting
- Source and target must be in the same VPC or connected via peering/Transit Gateway

---

## Reachability Analyzer

VPC Reachability Analyzer is a network diagnostic tool that tests connectivity between two endpoints in your VPC(s).

### Key Characteristics
- Analyzes **configuration** — does NOT send actual packets
- Identifies the path between source and destination
- Finds blocking components (security groups, NACLs, route tables)
- Supports: EC2, ENI, IGW, VGW, Transit Gateway, VPC Peering, ALB/NLB, VPC Endpoints
- Works across VPC peering and Transit Gateway connections
- Useful for troubleshooting connectivity issues and verifying network paths

---

## VPC Sharing with RAM

VPC owners can share subnets with other AWS accounts using AWS RAM.

### Key Facts
- **Owner account** manages: VPC, subnets, route tables, NACLs, gateways
- **Participant accounts** manage: Their own resources launched in shared subnets, their own security groups
- Participants cannot modify VPC infrastructure (routes, NACLs, etc.)
- Each account's resources are isolated (Account A cannot see Account B's instances)
- All accounts share the same subnet IP space
- Benefits: IP address conservation, simplified network architecture, centralized management

---

## AWS PrivateLink

AWS PrivateLink provides private connectivity between VPCs and services without exposing traffic to the public internet.

### Exposing Your Service to Other VPCs/Accounts

If you want to expose your service running in your VPC to other VPCs/accounts:

1. Create a **Network Load Balancer** (NLB) in front of your service
2. Create a **VPC Endpoint Service** pointing to the NLB
3. Consumer creates an **Interface Endpoint** in their VPC to connect to your service
4. Traffic flows: Consumer VPC → Interface Endpoint → PrivateLink → NLB → Your Service

### Key Characteristics
- Traffic stays on AWS's private network
- Service provider and consumer can be in different accounts, VPCs, or even different Regions (with inter-region VPC Peering)
- The consumer does not need to know the provider's CIDR block or IP addresses
- The service appears as a private IP in the consumer's VPC
- Supports thousands of consumers per service
- Consumer uses DNS to resolve the endpoint (optionally with private DNS)
- Only the service provider can see the consumer's private IP (not the consumer's VPC structure)

### PrivateLink vs VPC Peering

| Scenario | Use |
|---|---|
| Expose a specific service to another VPC | PrivateLink |
| Full network connectivity between two VPCs | VPC Peering |
| Expose service to many VPCs | PrivateLink |
| Need transitive routing | Transit Gateway |

---

## CIDR Calculation Examples

### Example 1: Design a VPC with 4 subnets

**Requirements:** VPC for 3 AZs with public and private subnets each, plus room for growth.

**Solution:**
```
VPC CIDR: 10.0.0.0/16 (65,536 IPs)

Subnets (using /20 for large subnets - 4,091 usable IPs each):
  AZ-a Public:  10.0.0.0/20   (10.0.0.0 - 10.0.15.255)
  AZ-a Private: 10.0.16.0/20  (10.0.16.0 - 10.0.31.255)
  AZ-b Public:  10.0.32.0/20  (10.0.32.0 - 10.0.47.255)
  AZ-b Private: 10.0.48.0/20  (10.0.48.0 - 10.0.63.255)
  AZ-c Public:  10.0.64.0/20  (10.0.64.0 - 10.0.79.255)
  AZ-c Private: 10.0.80.0/20  (10.0.80.0 - 10.0.95.255)

Remaining: 10.0.96.0 - 10.0.255.255 (reserved for future)
```

### Example 2: Calculate usable IPs

**Question:** How many usable IP addresses in a /24 subnet?

```
/24 = 2^(32-24) = 2^8 = 256 total IPs
256 - 5 (AWS reserved) = 251 usable IPs
```

### Example 3: Determine if two CIDRs overlap

**Question:** Do `10.0.0.0/16` and `10.0.5.0/24` overlap?

```
10.0.0.0/16 covers: 10.0.0.0 - 10.0.255.255
10.0.5.0/24 covers: 10.0.5.0 - 10.0.5.255
Yes, 10.0.5.0/24 is a subset of 10.0.0.0/16 — they overlap.
```

### CIDR Quick Reference

| CIDR | IPs Total | Usable (AWS) | Subnet Mask |
|---|---|---|---|
| /16 | 65,536 | 65,531 | 255.255.0.0 |
| /17 | 32,768 | 32,763 | 255.255.128.0 |
| /18 | 16,384 | 16,379 | 255.255.192.0 |
| /19 | 8,192 | 8,187 | 255.255.224.0 |
| /20 | 4,096 | 4,091 | 255.255.240.0 |
| /21 | 2,048 | 2,043 | 255.255.248.0 |
| /22 | 1,024 | 1,019 | 255.255.252.0 |
| /23 | 512 | 507 | 255.255.254.0 |
| /24 | 256 | 251 | 255.255.255.0 |
| /25 | 128 | 123 | 255.255.255.128 |
| /26 | 64 | 59 | 255.255.255.192 |
| /27 | 32 | 27 | 255.255.255.224 |
| /28 | 16 | 11 | 255.255.255.240 |

---

## Common Exam Scenarios

### Scenario 1: Block a Specific IP Address

**Question:** An EC2 instance is being attacked from IP `203.0.113.100`. How do you block it?

**Answer:** Add a **DENY** rule in the **NACL** for the subnet. Security groups can only Allow, not Deny. Add an inbound rule: Rule #50, Deny, All traffic, Source `203.0.113.100/32`.

---

### Scenario 2: Private Subnet Needs Internet Access

**Question:** Instances in a private subnet need to download software updates from the internet.

**Answer:** Deploy a **NAT Gateway** in a public subnet. Update the private subnet's route table: `0.0.0.0/0 → nat-gateway`. For HA, deploy one NAT Gateway per AZ.

---

### Scenario 3: Connect On-Premises to AWS

**Question:** A company needs a reliable, high-bandwidth connection between their data center and AWS VPC.

**Answer:**
- **Quick setup:** Site-to-Site VPN (minutes)
- **Production:** Direct Connect (weeks to months, but consistent performance)
- **Best of both:** Direct Connect as primary + VPN as backup
- Encrypt DX: Run VPN over DX Public VIF, or use MACsec

---

### Scenario 4: Connect Hundreds of VPCs

**Question:** An enterprise has 200 VPCs that need to communicate.

**Answer:** Use **Transit Gateway**. VPC Peering would require 19,900 peering connections ((200 × 199)/2). Transit Gateway requires only 200 attachments.

---

### Scenario 5: Access S3 Without Internet

**Question:** An application in a private subnet needs to access S3 without going through the internet.

**Answer:** Create an **S3 Gateway Endpoint**. It's free, requires no NAT Gateway, and traffic stays within AWS. Add a route in the private subnet's route table pointing to the endpoint.

---

### Scenario 6: Expose a Service to Partner VPCs

**Question:** You need to expose an internal service to 100 partner VPCs securely.

**Answer:** Use **AWS PrivateLink**. Place your service behind an NLB, create a VPC Endpoint Service. Partners create Interface Endpoints in their VPCs. No VPC peering or Transit Gateway needed.

---

### Scenario 7: DNS Resolution Between VPC and On-Premises

**Question:** On-premises servers need to resolve AWS private hosted zone records. AWS instances need to resolve on-premises Active Directory domains.

**Answer:** Use **Route 53 Resolver** with:
- **Inbound endpoints** for on-premises → AWS DNS resolution
- **Outbound endpoints** with forwarding rules for AWS → on-premises DNS resolution

---

### Scenario 8: VPC Peering Not Working

**Question:** Two VPCs are peered, but instances can't communicate.

**Checklist:**
1. Is the peering connection in **Active** state?
2. Are **route tables** updated in both VPCs?
3. Do **security groups** allow the traffic?
4. Do **NACLs** allow the traffic (both inbound and outbound, including ephemeral ports)?
5. Do the CIDR blocks **not overlap**?

---

### Scenario 9: Reduce NAT Gateway Costs

**Question:** NAT Gateway data processing charges are too high.

**Answer:**
- Use **S3 Gateway Endpoints** for S3 traffic (free, bypasses NAT)
- Use **Interface Endpoints** for other AWS services
- Move resources to the same AZ to reduce cross-AZ NAT charges
- Review if instances truly need outbound internet access
- Consider using a NAT Instance for low-throughput workloads

---

### Scenario 10: Multi-Region Disaster Recovery Networking

**Question:** Design networking for a multi-Region active-passive DR architecture.

**Answer:**
- Use **Transit Gateway inter-region peering** for VPC-to-VPC communication across Regions
- Use **Route 53 failover routing** for DNS-based failover
- Replicate data using service-native features (S3 CRR, RDS Read Replicas, DynamoDB Global Tables)
- VPN/Direct Connect in both Regions for on-premises connectivity
- Use consistent CIDR planning across Regions to avoid overlap

---

## Summary

VPC is the networking backbone of AWS. For the SAA-C03 exam, master these concepts:

1. **CIDR calculations** — sizes, reserved IPs, overlap detection
2. **Public vs private subnets** — determined by route table (IGW route = public)
3. **NAT Gateway** — HA requires one per AZ, pricing model
4. **Security Groups vs NACLs** — stateful vs stateless, allow-only vs allow+deny
5. **VPC Peering** — not transitive, no overlapping CIDRs
6. **Transit Gateway** — hub-and-spoke, transitive, scalable
7. **VPC Endpoints** — Gateway (free, S3/DDB) vs Interface (paid, most services)
8. **Direct Connect** — dedicated, VIF types, encryption options, resiliency
9. **VPN** — quick setup, internet-dependent, 1.25 Gbps per tunnel
10. **Flow Logs** — what they capture and don't capture
11. **PrivateLink** — expose services privately via NLB + Endpoint Service
12. **DNS** — enableDnsSupport, enableDnsHostnames, Route 53 Resolver
