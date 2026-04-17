# VPC Cheat Sheet

## VPC CIDR Reference Table

| CIDR Prefix | Subnet Mask       | Total IPs   | Usable IPs (AWS) |
|-------------|-------------------|-------------|-------------------|
| /16         | 255.255.0.0       | 65,536      | 65,531            |
| /17         | 255.255.128.0     | 32,768      | 32,763            |
| /18         | 255.255.192.0     | 16,384      | 16,379            |
| /19         | 255.255.224.0     | 8,192       | 8,187             |
| /20         | 255.255.240.0     | 4,096       | 4,091             |
| /21         | 255.255.248.0     | 2,048       | 2,043             |
| /22         | 255.255.252.0     | 1,024       | 1,019             |
| /23         | 255.255.254.0     | 512         | 507               |
| /24         | 255.255.255.0     | 256         | 251               |
| /25         | 255.255.255.128   | 128         | 123               |
| /26         | 255.255.255.192   | 64          | 59                |
| /27         | 255.255.255.224   | 32          | 27                |
| /28         | 255.255.255.240   | 16          | 11                |

- **VPC allowed range:** /16 (largest) to /28 (smallest)
- **Formula:** 2^(32 - prefix) = total IPs

---

## Subnet Sizing — 5 Reserved IPs Per Subnet

AWS reserves **5 IPs** in every subnet:

| Reserved IP         | Purpose                                     |
|---------------------|---------------------------------------------|
| x.x.x.**0**        | Network address                             |
| x.x.x.**1**        | VPC router                                  |
| x.x.x.**2**        | DNS server (VPC base + 2)                   |
| x.x.x.**3**        | Reserved for future use                     |
| x.x.x.**last**     | Broadcast address (AWS doesn't support broadcast) |

**Example:** /24 subnet → 256 - 5 = **251 usable IPs**

---

## Security Groups vs NACLs

| Feature                  | Security Groups                | NACLs                          |
|--------------------------|--------------------------------|--------------------------------|
| **Level**                | Instance (ENI) level           | Subnet level                   |
| **State**                | Stateful                       | Stateless                      |
| **Rules**                | Allow rules only               | Allow AND Deny rules           |
| **Rule evaluation**      | All rules evaluated together   | Rules evaluated in order (lowest # first) |
| **Default inbound**      | Deny all                       | Allow all (default NACL)       |
| **Default outbound**     | Allow all                      | Allow all (default NACL)       |
| **Return traffic**       | Automatically allowed          | Must explicitly allow          |
| **Association**          | Multiple SGs per ENI           | One NACL per subnet            |
| **Applies to**           | Only if associated with instance | All instances in subnet       |
| **Rule limit**           | 60 inbound + 60 outbound       | 20 inbound + 20 outbound      |

**Exam tip:** "Block a specific IP" → use NACL (SGs can't deny). "Allow traffic from another SG" → use Security Group referencing.

---

## NAT Gateway vs NAT Instance

| Feature                  | NAT Gateway                    | NAT Instance                   |
|--------------------------|--------------------------------|--------------------------------|
| **Managed by**           | AWS                            | You                            |
| **Availability**         | Highly available within AZ     | Depends on your setup          |
| **Bandwidth**            | Up to 100 Gbps                 | Depends on instance type       |
| **Maintenance**          | No patching needed             | You manage patching            |
| **Cost**                 | Per hour + data processed      | Per hour + data (cheaper)      |
| **Security Groups**      | Cannot associate               | Can associate                  |
| **Bastion host**         | Cannot use as bastion          | Can use as bastion             |
| **Port forwarding**      | Not supported                  | Supported                      |
| **Protocol**             | TCP, UDP, ICMP                 | TCP, UDP, ICMP                 |
| **Elastic IP**           | Assigned at creation           | Must assign manually           |
| **Source/Dest check**    | N/A                            | Must disable                   |

**Exam tip:** NAT Gateway is the preferred/recommended answer for most scenarios.

---

## VPC Peering vs Transit Gateway

| Feature                  | VPC Peering                    | Transit Gateway                |
|--------------------------|--------------------------------|--------------------------------|
| **Connectivity**         | One-to-one (hub/spoke not native) | Hub-and-spoke (many-to-many) |
| **Transitive routing**   | NOT supported                  | Supported                      |
| **Cross-Region**         | Supported                      | Supported (peering)            |
| **Cross-Account**        | Supported                      | Supported                      |
| **Bandwidth**            | No limit (uses AWS backbone)   | Up to 50 Gbps per attachment   |
| **Cost**                 | Data transfer only             | Per attachment + data transfer |
| **Overlapping CIDRs**    | NOT supported                  | NOT supported                  |
| **Max connections**      | 125 peering per VPC            | 5,000 attachments              |
| **Route tables**         | Must update in each VPC        | Centralized route tables       |
| **Use case**             | Few VPCs, simple connectivity  | Many VPCs, complex networking  |

**Exam tip:** "10+ VPCs need to communicate" → Transit Gateway. "Two VPCs, low latency" → VPC Peering.

---

## Interface Endpoints vs Gateway Endpoints

| Feature                  | Interface Endpoint (PrivateLink) | Gateway Endpoint              |
|--------------------------|----------------------------------|-------------------------------|
| **Services supported**   | Most AWS services + 3rd party    | S3 and DynamoDB only          |
| **How it works**         | ENI with private IP in subnet    | Route table entry (prefix list) |
| **Access from**          | VPC, on-prem (DX/VPN), peered VPCs | Same VPC only              |
| **DNS**                  | Private DNS name                 | Uses public S3/DDB endpoint   |
| **Security**             | Security groups                  | VPC endpoint policies         |
| **Cost**                 | Per hour + data processed        | FREE                          |
| **AZ placement**         | Choose specific AZs              | Regional (all AZs)            |
| **High availability**    | Deploy in multiple AZs           | Built-in                      |

**Exam tip:** "Free" + "S3/DynamoDB" → Gateway Endpoint. "On-premises access to S3 privately" → Interface Endpoint.

---

## VPN vs Direct Connect

| Feature                  | Site-to-Site VPN               | Direct Connect                 |
|--------------------------|--------------------------------|--------------------------------|
| **Connection type**      | Encrypted over internet        | Dedicated private connection   |
| **Setup time**           | Minutes                        | Weeks to months                |
| **Bandwidth**            | Up to 1.25 Gbps per tunnel     | 1, 10, or 100 Gbps            |
| **Latency**              | Variable (internet-dependent)  | Consistent, low latency        |
| **Cost**                 | Lower                          | Higher (port + data out)       |
| **Encryption**           | IPSec built-in                 | Not encrypted by default       |
| **Redundancy**           | 2 tunnels per connection       | Need 2 connections for HA      |
| **Use case**             | Quick setup, backup link       | Large data, consistent perf    |

**Combo:** Direct Connect + VPN = encrypted DX (IPSec over DX public VIF)

---

## Direct Connect Connection Types

| Type                     | Bandwidth               | Lead Time       | Notes                              |
|--------------------------|-------------------------|-----------------|-------------------------------------|
| **Dedicated Connection** | 1, 10, 100 Gbps        | Weeks-months    | Physical port at DX location        |
| **Hosted Connection**    | 50 Mbps to 10 Gbps     | Days-weeks      | Via AWS Partner                     |
| **DX Gateway**           | N/A                     | N/A             | Connect to VPCs in multiple regions |

**Virtual Interfaces (VIFs):**

| VIF Type       | Purpose                                | BGP ASN    |
|----------------|----------------------------------------|------------|
| **Private VIF** | Access VPC resources (private IPs)    | Private    |
| **Public VIF**  | Access AWS public services (S3, etc.) | Public     |
| **Transit VIF** | Access VPCs via Transit Gateway       | Private    |

---

## Key Port Numbers

| Port  | Protocol | Service                    |
|-------|----------|----------------------------|
| 22    | TCP      | SSH                        |
| 25    | TCP      | SMTP                       |
| 53    | TCP/UDP  | DNS                        |
| 80    | TCP      | HTTP                       |
| 110   | TCP      | POP3                       |
| 143   | TCP      | IMAP                       |
| 443   | TCP      | HTTPS                      |
| 465   | TCP      | SMTPS                      |
| 993   | TCP      | IMAPS                      |
| 995   | TCP      | POP3S                      |
| 1433  | TCP      | MS SQL Server              |
| 3306  | TCP      | MySQL / Aurora             |
| 3389  | TCP      | RDP (Windows)              |
| 5432  | TCP      | PostgreSQL                 |
| 5439  | TCP      | Redshift                   |
| 6379  | TCP      | Redis (ElastiCache)        |
| 11211 | TCP      | Memcached (ElastiCache)    |
| 27017 | TCP      | MongoDB (DocumentDB)       |

---

## VPC Flow Log Format

```
<version> <account-id> <interface-id> <srcaddr> <dstaddr> <srcport> <dstport> <protocol> <packets> <bytes> <start> <end> <action> <log-status>
```

**Example:**
```
2 123456789012 eni-abc123 10.0.1.5 10.0.2.10 49152 443 6 20 4000 1620000000 1620000060 ACCEPT OK
```

| Field        | Key Info                                                  |
|--------------|-----------------------------------------------------------|
| protocol     | 6 = TCP, 17 = UDP, 1 = ICMP                              |
| action       | ACCEPT or REJECT                                          |
| log-status   | OK, NODATA, SKIPDATA                                      |

**Flow Log levels:** VPC level, Subnet level, or ENI level  
**Destinations:** CloudWatch Logs, S3, Kinesis Data Firehose  
**Not captured:** DNS to Amazon DNS, DHCP, metadata (169.254.169.254), Amazon Time Sync, License Manager

---

## Route Table Priority Rules

1. **Longest prefix match wins** (most specific route)
   - /32 beats /24 beats /16 beats /0
2. **Local route** always takes priority for intra-VPC traffic
3. **Static routes** take priority over propagated routes
4. For equal prefix: Static > Propagated
5. For propagated routes with same prefix:
   - Direct Connect BGP > Static VPN > BGP VPN

---

## IPv4 vs IPv6 Differences in VPC

| Feature                  | IPv4                           | IPv6                           |
|--------------------------|--------------------------------|--------------------------------|
| **Address type**         | Private + Public               | All public (globally unique)   |
| **VPC CIDR**             | Required (/16 to /28)          | Optional (/56 fixed)           |
| **Subnet CIDR**          | Variable                       | Fixed /64                      |
| **Elastic IP**           | Supported                      | Not needed (all public)        |
| **NAT Gateway**          | Supported                      | Not needed (use Egress-only IGW) |
| **Egress-only IGW**      | N/A                            | Allows outbound, blocks inbound |
| **Security Groups**      | Supported                      | Supported                      |
| **NACLs**                | Supported                      | Supported                      |
| **Dual-stack**           | Default                        | Optional add-on                |
| **Private addressing**   | RFC 1918                       | No private addresses           |

**Exam tip:** "IPv6 outbound only" → Egress-Only Internet Gateway (NOT NAT Gateway).
