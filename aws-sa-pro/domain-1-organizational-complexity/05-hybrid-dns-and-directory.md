# Hybrid DNS and Directory Services

## AWS Solutions Architect Professional (SAP-C02) — Domain 1: Design Solutions for Organizational Complexity

---

## Table of Contents

1. [Introduction](#introduction)
2. [Route 53 Resolver — Complete Guide](#route-53-resolver--complete-guide)
3. [Route 53 Resolver DNS Firewall](#route-53-resolver-dns-firewall)
4. [Hybrid DNS Architecture Patterns](#hybrid-dns-architecture-patterns)
5. [Private Hosted Zones and VPC Associations](#private-hosted-zones-and-vpc-associations)
6. [Split-View DNS](#split-view-dns)
7. [Multi-Account DNS Architecture](#multi-account-dns-architecture)
8. [AWS Directory Service — Complete Guide](#aws-directory-service--complete-guide)
9. [AWS Managed Microsoft AD](#aws-managed-microsoft-ad)
10. [AD Connector](#ad-connector)
11. [Simple AD](#simple-ad)
12. [AD Trust Relationships](#ad-trust-relationships)
13. [Directory Sharing Across Accounts](#directory-sharing-across-accounts)
14. [LDAP Integration](#ldap-integration)
15. [Amazon WorkSpaces and Directory Integration](#amazon-workspaces-and-directory-integration)
16. [RADIUS MFA Integration](#radius-mfa-integration)
17. [Exam Scenarios](#exam-scenarios)
18. [Exam Tips Summary](#exam-tips-summary)

---

## Introduction

Hybrid DNS and directory services form the critical identity and name-resolution layer of enterprise AWS architectures. The SAP-C02 exam tests your ability to design DNS resolution flows between on-premises and AWS, configure directory services for hybrid environments, and understand the nuances of trust relationships, directory sharing, and federation.

This article covers every aspect of hybrid DNS and directory services you'll encounter on the exam.

---

## Route 53 Resolver — Complete Guide

### VPC DNS Fundamentals

Every VPC has a built-in DNS resolver at the VPC CIDR base +2 address:
- VPC CIDR: `10.0.0.0/16` → DNS resolver: `10.0.0.2`
- Also accessible at: `169.254.169.253`

**VPC DNS Settings**:
| Setting | Description | Default |
|---|---|---|
| `enableDnsSupport` | Enables DNS resolution in the VPC | true |
| `enableDnsHostnames` | Assigns public DNS hostnames to instances | false (true for default VPC) |

### Route 53 Resolver Components

```
┌──────────────────────────────────────────────────────────────┐
│  Route 53 Resolver (within each VPC)                          │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Default Resolver (10.0.0.2)                            │  │
│  │  ├── Resolves Route 53 Private Hosted Zones             │  │
│  │  ├── Resolves VPC internal DNS                          │  │
│  │  ├── Forwards to public DNS for external domains        │  │
│  │  └── Evaluates Resolver Rules before forwarding         │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Inbound Endpoint                                       │  │
│  │  ├── ENIs in specified subnets (min 2 AZs)             │  │
│  │  ├── IP addresses that on-premises DNS can forward to  │  │
│  │  ├── Resolves AWS private DNS for external queries      │  │
│  │  └── Security Group controlled                          │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Outbound Endpoint                                      │  │
│  │  ├── ENIs in specified subnets (min 2 AZs)             │  │
│  │  ├── Forwards queries to on-premises DNS                │  │
│  │  ├── Associated with Forwarding Rules                   │  │
│  │  └── Security Group controlled (allow port 53 outbound) │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Resolver Rules                                         │  │
│  │  ├── Forwarding Rules: Forward queries to specific IPs  │  │
│  │  │   (e.g., *.corp.example.com → 172.16.1.10)         │  │
│  │  ├── System Rules: Override forwarding for specific     │  │
│  │  │   domains (e.g., resolve .amazonaws.com locally)    │  │
│  │  └── Associated with VPCs                               │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### Inbound Endpoint Details

**Purpose**: Allow on-premises DNS to resolve AWS private DNS names.

**Setup**:
```bash
# Create inbound endpoint
aws route53resolver create-resolver-endpoint \
  --creator-request-id inbound-001 \
  --name "OnPremToAWS" \
  --security-group-ids sg-abc123 \
  --direction INBOUND \
  --ip-addresses SubnetId=subnet-1a,Ip=10.0.1.10 SubnetId=subnet-1b,Ip=10.0.2.10
```

**Security Group for Inbound**:
```
Inbound Rules:
  ├── TCP port 53 from on-premises CIDR (172.16.0.0/12)
  └── UDP port 53 from on-premises CIDR (172.16.0.0/12)
```

**On-Premises DNS Configuration**:
```
# Conditional forwarder on on-premises DNS
# Forward *.aws.example.com to inbound endpoint IPs
Zone: aws.example.com
  Forwarders: 10.0.1.10, 10.0.2.10

# Forward *.amazonaws.com to inbound endpoint IPs
Zone: us-east-1.amazonaws.com
  Forwarders: 10.0.1.10, 10.0.2.10
```

### Outbound Endpoint Details

**Purpose**: Allow AWS VPCs to resolve on-premises DNS names.

**Setup**:
```bash
# Create outbound endpoint
aws route53resolver create-resolver-endpoint \
  --creator-request-id outbound-001 \
  --name "AWSToOnPrem" \
  --security-group-ids sg-def456 \
  --direction OUTBOUND \
  --ip-addresses SubnetId=subnet-1a,Ip=10.0.1.20 SubnetId=subnet-1b,Ip=10.0.2.20
```

**Security Group for Outbound**:
```
Outbound Rules:
  ├── TCP port 53 to on-premises DNS IPs
  └── UDP port 53 to on-premises DNS IPs

Inbound Rules:
  ├── TCP port 53 from VPC CIDR (for responses)
  └── UDP port 53 from VPC CIDR (for responses)
```

### Forwarding Rules

```bash
# Create forwarding rule
aws route53resolver create-resolver-rule \
  --creator-request-id rule-001 \
  --name "ForwardCorpDNS" \
  --rule-type FORWARD \
  --domain-name "corp.example.com" \
  --resolver-endpoint-id rslvr-out-abc123 \
  --target-ips Ip=172.16.1.10,Port=53 Ip=172.16.1.11,Port=53

# Associate rule with VPC
aws route53resolver associate-resolver-rule \
  --resolver-rule-id rslvr-rr-abc123 \
  --vpc-id vpc-abc123
```

### Resolver Rule Types

| Type | Purpose | Example |
|---|---|---|
| **Forward** | Forward to specific DNS servers | `*.corp.example.com` → on-premises DNS |
| **System** | Override default resolution | `*.amazonaws.com` → use AWS resolver (not forward) |
| **Recursive** | Default behavior | Forward to Route 53 public resolver |

### Rule Evaluation Order

```
1. System rules (highest priority)
   - Override forwarding for specific domains
   
2. Forwarding rules
   - Most specific domain match wins
   - Example: "db.corp.example.com" rule beats "corp.example.com" rule
   
3. Auto-defined system rules
   - Private Hosted Zones
   - VPC internal DNS (*.ec2.internal)
   
4. Default (recursive resolver)
   - Forward to Route 53 public resolver
```

### Sharing Resolver Rules with RAM

Resolver rules can be shared across accounts using RAM:

```bash
# Share forwarding rule with organization
aws ram create-resource-share \
  --name "SharedDNSRules" \
  --resource-arns "arn:aws:route53resolver:us-east-1:NETWORK_ACCOUNT:resolver-rule/rslvr-rr-abc123" \
  --principals "arn:aws:organizations::MGMT_ACCOUNT:organization/o-org123"
```

When shared:
- Receiving accounts can associate the rule with their VPCs
- Receiving accounts cannot modify the rule
- DNS queries matching the rule are forwarded via the outbound endpoint in the sharing account

> **Exam Tip**: Resolver rules shared via RAM are used in the receiving account's VPCs, but the actual DNS forwarding happens through the outbound endpoint in the sharing account. This means the outbound endpoint must have network connectivity (DX/VPN) to the on-premises DNS servers.

---

## Route 53 Resolver DNS Firewall

### What is DNS Firewall?

DNS Firewall provides protection against DNS-based threats by filtering outbound DNS queries from your VPCs.

### Architecture

```
EC2 Instance
  │
  ├── DNS Query: malicious-domain.com
  │
  ▼
VPC DNS Resolver (10.0.0.2)
  │
  ├── DNS Firewall Rule Groups (evaluated in priority order)
  │   ├── Rule 1: Block malicious-domain.com → BLOCK (NODATA)
  │   ├── Rule 2: Block *.malware-c2.net → BLOCK (NXDOMAIN)
  │   ├── Rule 3: Allow *.example.com → ALLOW
  │   └── Rule 4: Block all remaining → BLOCK (custom response)
  │
  ├── If ALLOWED → continue normal resolution
  └── If BLOCKED → return configured response
```

### DNS Firewall Components

| Component | Description |
|---|---|
| **Rule Group** | Collection of rules, shareable via RAM |
| **Rule** | Domain list + action + priority |
| **Domain List** | AWS managed or custom domain lists |
| **Actions** | ALLOW, BLOCK, ALERT |
| **Block Response** | NODATA, NXDOMAIN, or OVERRIDE (custom IP) |

### AWS Managed Domain Lists

- `AWSManagedDomainsMalwareDomainList` — Known malware domains
- `AWSManagedDomainsBotnetCommandandControl` — Known C&C domains

### DNS Firewall Rule Group Example

```bash
# Create rule group
aws route53resolver create-firewall-rule-group \
  --creator-request-id rg-001 \
  --name "SecurityDNSRules"

# Create domain list
aws route53resolver create-firewall-domain-list \
  --creator-request-id dl-001 \
  --name "BlockedDomains" \
  --domains "malicious-site.com" "*.bad-domain.net"

# Create rule
aws route53resolver create-firewall-rule \
  --creator-request-id rule-001 \
  --firewall-rule-group-id rslvr-frg-abc123 \
  --firewall-domain-list-id rslvr-fdl-abc123 \
  --priority 100 \
  --action BLOCK \
  --block-response NXDOMAIN \
  --name "BlockMalicious"

# Associate with VPC
aws route53resolver associate-firewall-rule-group \
  --creator-request-id assoc-001 \
  --firewall-rule-group-id rslvr-frg-abc123 \
  --vpc-id vpc-abc123 \
  --priority 101
```

### DNS Firewall with Organizations

DNS Firewall Rule Groups can be shared via RAM across the organization:
```
Security Account:
  └── DNS Firewall Rule Group (malware/botnet blocking)
      ├── Shared via RAM to all accounts
      └── Each VPC associates the rule group
```

**AWS Firewall Manager** can enforce DNS Firewall rules across the organization:
```
Firewall Manager Policy (DNS Firewall):
  ├── Rule groups to associate
  ├── Target: All VPCs in organization
  └── Auto-remediation: Associate rules with non-compliant VPCs
```

> **Exam Tip**: DNS Firewall protects against DNS exfiltration and C&C communication. Combine with Firewall Manager for organization-wide enforcement. Know the difference between DNS Firewall (DNS-layer protection) and Network Firewall (network-layer protection).

---

## Hybrid DNS Architecture Patterns

### Pattern 1: On-Premises → AWS Resolution

```
On-Premises Server queries: api.internal.aws.example.com
  │
  ▼
On-Premises DNS Server
  │
  ├── Conditional Forwarder: *.aws.example.com → Inbound Endpoint IPs
  │
  ▼
Route 53 Resolver Inbound Endpoint (10.0.1.10)
  │
  ├── Checks Private Hosted Zone: aws.example.com
  │   └── api.internal → 10.0.5.50
  │
  └── Returns: 10.0.5.50
```

### Pattern 2: AWS → On-Premises Resolution

```
EC2 Instance queries: db.corp.example.com
  │
  ▼
VPC DNS Resolver (10.0.0.2)
  │
  ├── Checks Resolver Rules
  │   └── Match: *.corp.example.com → Forward to Outbound Endpoint
  │
  ▼
Route 53 Resolver Outbound Endpoint (10.0.1.20)
  │
  ├── Forwards query to on-premises DNS: 172.16.1.10
  │   (via DX or VPN connection)
  │
  ▼
On-Premises DNS Server
  │
  └── Returns: db.corp.example.com → 172.16.5.100
```

### Pattern 3: Bidirectional DNS Resolution

```
┌──────────────────────────────────────────────────────────┐
│                     Network Account                        │
│                                                            │
│  ┌─────────────────────────────────────────────────────┐ │
│  │  VPC (Hub/DNS VPC)                                   │ │
│  │                                                       │ │
│  │  Route 53 Resolver:                                   │ │
│  │  ┌─────────────────┐  ┌─────────────────────────┐  │ │
│  │  │ Inbound Endpoint │  │ Outbound Endpoint       │  │ │
│  │  │ 10.0.1.10       │  │ 10.0.1.20               │  │ │
│  │  │ 10.0.2.10       │  │ 10.0.2.20               │  │ │
│  │  └─────────────────┘  └─────────────────────────┘  │ │
│  │                                                       │ │
│  │  Forwarding Rules (shared via RAM):                   │ │
│  │  ├── *.corp.example.com → 172.16.1.10 (on-prem)    │ │
│  │  ├── *.legacy.internal → 172.16.1.11 (on-prem)     │ │
│  │  └── (shared with all VPCs in organization)          │ │
│  │                                                       │ │
│  │  Private Hosted Zones:                                │ │
│  │  ├── aws.example.com (associated with all VPCs)      │ │
│  │  └── internal.example.com (associated with all VPCs) │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                            │
│  On-Premises DNS:                                          │
│  ├── Conditional Forwarder: *.aws.example.com →           │
│  │   Inbound Endpoint IPs (10.0.1.10, 10.0.2.10)        │
│  └── Conditional Forwarder: *.internal.example.com →      │
│      Inbound Endpoint IPs                                  │
└──────────────────────────────────────────────────────────┘
```

### Pattern 4: Multi-Region Hybrid DNS

```
Region: us-east-1                      Region: eu-west-1
┌──────────────────────┐              ┌──────────────────────┐
│  DNS VPC             │              │  DNS VPC             │
│  Inbound Endpoint    │              │  Inbound Endpoint    │
│  Outbound Endpoint   │              │  Outbound Endpoint   │
│                      │              │                      │
│  Forwarding Rules:   │              │  Forwarding Rules:   │
│  *.corp → on-prem    │              │  *.corp → on-prem    │
│  DNS via DX (us)     │              │  DNS via DX (eu)     │
│                      │              │                      │
│  PHZ: aws.example.com│              │  PHZ: aws.example.com│
│  (regional records)  │              │  (regional records)  │
└──────────────────────┘              └──────────────────────┘
```

> **Exam Tip**: The centralized DNS pattern with a network account hosting resolver endpoints and sharing rules via RAM is the most common exam architecture. Inbound endpoints require on-premises conditional forwarders. Outbound endpoints require forwarding rules. Both need proper security group and network connectivity (DX/VPN).

---

## Private Hosted Zones and VPC Associations

### Private Hosted Zone (PHZ) Basics

A PHZ contains DNS records that are only resolvable from associated VPCs:

```bash
# Create PHZ
aws route53 create-hosted-zone \
  --name "internal.example.com" \
  --vpc VPCRegion=us-east-1,VPCId=vpc-abc123 \
  --caller-reference "$(date +%s)" \
  --hosted-zone-config PrivateZone=true
```

### Cross-Account PHZ Association

A PHZ in Account A can be associated with a VPC in Account B:

```
Account A (DNS Account)              Account B (Workload Account)
┌────────────────────────┐          ┌────────────────────────┐
│  PHZ: internal.app.com │  Assoc.  │  VPC-Workload          │
│  ├── api → 10.0.5.50  │────────> │  Can resolve:          │
│  ├── db → 10.0.6.100  │          │  api.internal.app.com  │
│  └── cache → 10.0.7.20│          │  db.internal.app.com   │
└────────────────────────┘          └────────────────────────┘
```

**Cross-Account Association Steps**:

1. **Account A** (PHZ owner): Create authorization
```bash
aws route53 create-vpc-association-authorization \
  --hosted-zone-id Z1234567890 \
  --vpc VPCRegion=us-east-1,VPCId=vpc-bbb222
```

2. **Account B** (VPC owner): Associate VPC
```bash
aws route53 associate-vpc-with-hosted-zone \
  --hosted-zone-id Z1234567890 \
  --vpc VPCRegion=us-east-1,VPCId=vpc-bbb222
```

3. **Account A**: Delete authorization (optional, for cleanup)
```bash
aws route53 delete-vpc-association-authorization \
  --hosted-zone-id Z1234567890 \
  --vpc VPCRegion=us-east-1,VPCId=vpc-bbb222
```

### PHZ Resolution Order

When a VPC has multiple associated PHZs and Resolver rules:

```
DNS Query: api.internal.example.com

1. Resolver Rules (if matching rule exists) → Forward to specified DNS
2. Private Hosted Zones (most specific zone match wins)
   - internal.example.com zone > example.com zone
3. VPC internal DNS (ec2.internal, compute.internal)
4. Public DNS (Route 53 recursive resolver)
```

### Overlapping PHZs

If multiple PHZs have overlapping domains, the most specific match wins:
```
PHZ 1: example.com (associated with VPC-A)
  └── www → 10.0.1.1

PHZ 2: api.example.com (associated with VPC-A)
  └── v1 → 10.0.2.1

Query from VPC-A: v1.api.example.com
  → Resolved by PHZ 2 (more specific)

Query from VPC-A: www.example.com
  → Resolved by PHZ 1
```

---

## Split-View DNS

### What is Split-View DNS?

Split-view DNS returns different DNS responses depending on where the query originates (internal vs external):

```
External Query: app.example.com → 203.0.113.1 (public IP)
Internal Query: app.example.com → 10.0.5.50 (private IP)
```

### Implementation in AWS

```
Route 53 Public Hosted Zone: example.com
  └── app → 203.0.113.1 (ALB public IP)
      (Resolved by public DNS queries)

Route 53 Private Hosted Zone: example.com
  └── app → 10.0.5.50 (ALB internal IP)
      (Resolved by associated VPC queries)
```

**How it works**:
- VPCs associated with the PHZ resolve `app.example.com` → `10.0.5.50`
- All other queries (public internet) resolve `app.example.com` → `203.0.113.1`
- The PHZ takes priority over the public zone for associated VPCs

### Split-View with On-Premises

```
On-Premises Server queries: app.example.com
  │
  ├── If using Inbound Endpoint → resolves PHZ → 10.0.5.50 (private)
  │   (On-prem DNS forwards to AWS Inbound Endpoint)
  │
  └── If using public DNS → resolves public zone → 203.0.113.1 (public)
      (On-prem DNS resolves normally)
```

> **Exam Tip**: Split-view DNS uses the same domain name in both a public and private hosted zone. The PHZ overrides the public zone for associated VPCs. This is a common pattern for accessing internal services privately while maintaining public DNS for external users.

---

## Multi-Account DNS Architecture

### Centralized DNS Management

```
Network Account (DNS Hub)
  │
  ├── Route 53 Resolver Endpoints:
  │   ├── Inbound (for on-premises → AWS)
  │   └── Outbound (for AWS → on-premises)
  │
  ├── Forwarding Rules (shared via RAM):
  │   ├── *.corp.example.com → On-premises DNS
  │   ├── *.legacy.internal → On-premises DNS
  │   └── *.partner.com → Partner DNS
  │
  ├── Private Hosted Zones:
  │   ├── shared.internal (shared infra DNS)
  │   │   └── Associated with all VPCs (cross-account)
  │   └── network.internal (network-specific DNS)
  │       └── Associated with Network VPC only
  │
  └── DNS Firewall Rules (shared via RAM):
      └── Block malicious domains (all VPCs)

Workload Account A:
  ├── PHZ: app-a.internal
  │   └── Associated with App-A VPC
  │   └── Cross-account associated with Shared Services VPC
  └── VPC: Uses shared forwarding rules from Network Account

Workload Account B:
  ├── PHZ: app-b.internal
  │   └── Associated with App-B VPC
  └── VPC: Uses shared forwarding rules from Network Account
```

### Delegated PHZ Management

Teams can manage their own PHZs while the network team manages infrastructure DNS:

```
Network Team:
  ├── Manages Resolver endpoints
  ├── Manages forwarding rules
  └── Manages shared PHZs (infrastructure DNS)

Application Teams:
  ├── Manage their own PHZs (application DNS)
  ├── Associate PHZs with their VPCs
  └── Can associate PHZs cross-account (with authorization)
```

---

## AWS Directory Service — Complete Guide

### Directory Service Options

| Feature | AWS Managed Microsoft AD | AD Connector | Simple AD |
|---|---|---|---|
| **Type** | Full Microsoft AD | Proxy to on-premises AD | Samba-based AD |
| **Managed by** | AWS | AWS (proxy only) | AWS |
| **On-premises AD required** | No (optional trust) | Yes | No |
| **Scale** | Standard (≤5,000 users) or Enterprise (≤500,000) | Small (≤500 users) or Large (≤5,000) | Small (≤500 users) or Large (≤5,000) |
| **MFA** | RADIUS integration | RADIUS integration | No |
| **Trust** | Yes (forest, external) | No | No |
| **Schema extensions** | Yes | N/A (proxied) | No |
| **Supports** | All AD-dependent apps | SSO, WorkSpaces, etc. | Basic AD features |
| **High Availability** | Multi-AZ (2 DCs minimum) | Multi-AZ | Multi-AZ |
| **Cost** | Higher | Medium | Lower |

### Decision Tree: Which Directory Service?

```
Do you have on-premises Active Directory?
├── YES
│   ├── Need full AD features in AWS (trusts, schema extensions, group policies)?
│   │   └── AWS Managed Microsoft AD (with trust to on-premises)
│   │
│   ├── Just need to proxy authentication to on-premises AD?
│   │   └── AD Connector
│   │
│   └── Need AD for WorkSpaces only, and users exist on-premises?
│       └── AD Connector
│
└── NO
    ├── Need full Microsoft AD features?
    │   └── AWS Managed Microsoft AD
    │
    └── Need basic AD features (LDAP, user management)?
        └── Simple AD (or AWS Managed AD for production)
```

---

## AWS Managed Microsoft AD

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Shared Services Account                                       │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  VPC: 10.1.0.0/16                                      │  │
│  │                                                          │  │
│  │  ┌──────────────────┐  ┌──────────────────┐           │  │
│  │  │  Domain Controller│  │  Domain Controller│           │  │
│  │  │  (AZ-a)          │  │  (AZ-b)          │           │  │
│  │  │  10.1.1.10       │  │  10.1.2.10       │           │  │
│  │  │  ENI (managed)   │  │  ENI (managed)   │           │  │
│  │  └──────────────────┘  └──────────────────┘           │  │
│  │                                                          │  │
│  │  Domain: corp.example.com                               │  │
│  │  NetBIOS: CORP                                           │  │
│  │  Admin: Admin@corp.example.com                          │  │
│  │                                                          │  │
│  │  Features:                                               │  │
│  │  ├── Group Policy management                             │  │
│  │  ├── LDAP support                                        │  │
│  │  ├── Kerberos authentication                             │  │
│  │  ├── Schema extensions                                   │  │
│  │  ├── DNS (integrated)                                    │  │
│  │  ├── Trust relationships                                 │  │
│  │  └── Multi-region replication                            │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### Key Features

**Multi-Region Replication**:
```
Primary Region (us-east-1):
  ├── DC-1 (AZ-a)
  └── DC-2 (AZ-b)

Additional Region (eu-west-1):
  ├── DC-3 (AZ-a)  ← Replica
  └── DC-4 (AZ-b)  ← Replica

Benefits:
  ├── Lower latency for regional workloads
  ├── Automatic replication
  └── Regional resilience
```

**What Admin Can Do**:
- Create users, groups, OUs within the managed AD
- Manage Group Policies
- Install AD-integrated applications
- Create trust relationships
- Extend the schema
- Configure password policies

**What Admin Cannot Do**:
- Access the Domain Controller OS
- Promote additional DCs
- Manage replication topology
- Access the Domain Admins or Enterprise Admins groups
- Access the default Sites and Services

### Managed AD DNS

Managed Microsoft AD includes integrated DNS:
- Resolves domain names within the AD domain
- VPCs using the AD as DNS resolver get AD DNS
- Can integrate with Route 53 Resolver:

```
VPC DNS flow with Managed AD:
  1. EC2 queries VPC DNS resolver (10.1.0.2)
  2. Resolver checks PHZ, forwarding rules
  3. If domain matches AD zone → forwards to Managed AD DNS (10.1.1.10)
  4. Managed AD resolves from its DNS zone
```

### Managed AD Integration with AWS Services

| Service | Integration |
|---|---|
| **IAM Identity Center** | Identity source for SSO |
| **Amazon WorkSpaces** | User authentication |
| **Amazon RDS** | Windows authentication for SQL Server |
| **Amazon FSx** | Windows File Server, NetApp ONTAP |
| **Amazon Connect** | Agent authentication |
| **Amazon QuickSight** | User management |
| **EC2 Windows** | Domain join |
| **AWS Client VPN** | User authentication |
| **Service Catalog** | End-user authentication |

---

## AD Connector

### Architecture

```
┌─────────────────────────┐         ┌──────────────────────────┐
│  AWS VPC                │         │  On-Premises Network     │
│                         │         │                          │
│  ┌─────────────────┐   │  DX/VPN │  ┌────────────────────┐ │
│  │  AD Connector    │   │ ←──────>│  │  On-Premises AD    │ │
│  │  (Proxy)         │   │         │  │  Domain Controller │ │
│  │                  │   │         │  │                    │ │
│  │  ENI (AZ-a)     │   │         │  │  corp.example.com  │ │
│  │  ENI (AZ-b)     │   │         │  │                    │ │
│  │                  │   │         │  └────────────────────┘ │
│  │  No data stored  │   │         │                          │
│  │  (stateless proxy)│  │         │                          │
│  └─────────────────┘   │         │                          │
│                         │         │                          │
│  AWS Services:          │         │                          │
│  ├── WorkSpaces → AD Connector → On-Prem AD                │
│  ├── SSO → AD Connector → On-Prem AD                       │
│  └── EC2 domain join → AD Connector → On-Prem AD           │
└─────────────────────────┘         └──────────────────────────┘
```

### AD Connector Key Properties

- **No data stored in AWS**: All authentication is proxied to on-premises
- **Requires network connectivity**: DX or VPN to on-premises (must be reliable)
- **No trust relationships**: It's a proxy, not a directory
- **No caching**: Every authentication request goes to on-premises
- **Service account required**: Needs an AD service account with delegation rights

### AD Connector Use Cases

1. **WorkSpaces with on-premises users**: Users authenticate against on-premises AD
2. **IAM Identity Center**: Use on-premises AD as identity source
3. **EC2 domain join**: Join EC2 instances to on-premises domain
4. **AWS Management Console SSO**: Federated access using on-premises credentials

### AD Connector Limitations

- If network connectivity to on-premises fails, authentication fails
- No local password caching
- Cannot be used standalone (requires existing AD)
- Limited to specific AWS service integrations
- No schema extensions or Group Policy management

> **Exam Tip**: AD Connector is a proxy — no data in AWS. If the question mentions "latency-sensitive" or "need to work during network outage," AD Connector is NOT the answer. Use AWS Managed Microsoft AD instead.

---

## Simple AD

### When to Use Simple AD

- Small environments (≤5,000 users)
- Basic AD features needed (user management, group management, LDAP)
- No trust relationship requirements
- Cost-sensitive environments
- Standalone AD (no on-premises AD)

### Simple AD Limitations

- No trust relationships
- No schema extensions
- No MFA (RADIUS not supported)
- No multi-region replication
- Based on Samba 4 (not full Microsoft AD)
- Cannot integrate with all Microsoft AD features
- Limited to small/large sizes

---

## AD Trust Relationships

### Trust Types

```
One-Way Trust:
  On-Premises AD (Trusting) ←──── AWS Managed AD (Trusted)
  Users in AWS Managed AD can access resources in On-Premises
  (Direction of trust is OPPOSITE to direction of access)

Two-Way Trust:
  On-Premises AD ←───────────→ AWS Managed AD
  Users in either domain can access resources in the other

Forest Trust:
  On-Premises Forest ←───────→ AWS Managed AD Forest
  Transitive trust across all domains in both forests
```

### Trust Architecture

```
On-Premises:                         AWS:
┌──────────────────┐                ┌──────────────────┐
│  Forest:          │                │  Forest:          │
│  corp.example.com │                │  aws.example.com  │
│                   │    Forest      │                   │
│  Domains:         │    Trust       │  Domains:         │
│  ├── corp...      │←────────────→ │  ├── aws...       │
│  ├── dev.corp...  │  (Two-way)    │  └── (single)     │
│  └── prd.corp...  │                │                   │
│                   │                │                   │
│  Users can access │                │  Users can access │
│  AWS resources    │                │  on-prem resources│
└──────────────────┘                └──────────────────┘
```

### Setting Up Trust

**Prerequisites**:
1. Network connectivity between on-premises DCs and AWS Managed AD
2. DNS resolution between domains:
   - On-premises DNS can resolve AWS Managed AD domain
   - AWS Managed AD can resolve on-premises domain
3. Firewall rules allowing AD ports (TCP/UDP 53, 88, 135, 389, 445, 636, 3268, 49152-65535)

**DNS Configuration for Trust**:
```
Option 1: Conditional Forwarder in Managed AD
  aws.example.com → On-premises DNS IPs (for resolving on-prem domain)
  
Option 2: Route 53 Outbound Endpoint
  corp.example.com → Route 53 Outbound → On-premises DNS
```

### Trust Direction Clarification

```
"I trust you" = Users from YOUR domain can access MY resources

One-Way Incoming Trust (On-Premises trusts AWS):
  AWS users → access on-premises resources ✓
  On-premises users → access AWS resources ✗

One-Way Outgoing Trust (AWS trusts On-Premises):
  AWS users → access on-premises resources ✗
  On-premises users → access AWS resources ✓

Two-Way Trust:
  Both directions work ✓
```

> **Exam Tip**: Trust direction is the opposite of access direction. This is confusing and commonly tested. "One-way trust where A trusts B" means users in B can access resources in A. For most hybrid scenarios, two-way forest trust is recommended.

---

## Directory Sharing Across Accounts

### How Directory Sharing Works

AWS Managed Microsoft AD can be shared with other accounts in your organization:

```
Shared Services Account (Directory Owner)
  │
  └── AWS Managed AD: corp.example.com
      │
      ├── Shared with: Workload Account A
      │   └── EC2 instances can join domain
      │   └── WorkSpaces can use the directory
      │
      ├── Shared with: Workload Account B
      │   └── RDS SQL Server can use AD authentication
      │   └── FSx Windows can use AD authentication
      │
      └── Shared with: Workload Account C
          └── Client VPN can use AD for authentication
```

### Sharing Mechanism

```bash
# Share directory with another account
aws ds share-directory \
  --directory-id d-abc123 \
  --share-target Id=222222222222,Type=ACCOUNT \
  --share-method ORGANIZATIONS

# Accept share in target account
aws ds accept-shared-directory \
  --shared-directory-id d-abc123
```

### Share Methods

| Method | Description | Requirements |
|---|---|---|
| **ORGANIZATIONS** | Share within AWS Organizations | Organizations enabled, trusted access |
| **HANDSHAKE** | Share with specific account | Account accepts invitation |

### Directory Sharing Considerations

- Shared directory appears as a "shared directory" in target accounts
- Target accounts can use the directory for:
  - EC2 domain join
  - WorkSpaces
  - RDS SQL Server Windows Auth
  - FSx Windows File Server
  - AWS Client VPN
- Target accounts CANNOT:
  - Manage the directory (users, groups, policies)
  - Delete the directory
  - Modify directory settings

---

## LDAP Integration

### LDAP with AWS Managed AD

AWS Managed AD natively supports LDAP:
- **LDAP** (port 389): Unencrypted (internal VPC only)
- **LDAPS** (port 636): TLS-encrypted
  - Server-side LDAPS: Enabled by importing a certificate to Managed AD
  - Client-side LDAPS: Applications configure TLS

### LDAPS Configuration

```
To enable server-side LDAPS on AWS Managed AD:

1. Create a certificate:
   ├── Use AWS Certificate Manager (ACM) Private CA
   └── Or use on-premises CA

2. Register certificate with Managed AD:
   aws ds register-certificate \
     --directory-id d-abc123 \
     --certificate-data file://cert.pem \
     --type ClientLdaps

3. Enable LDAPS:
   aws ds enable-ldaps \
     --directory-id d-abc123 \
     --type Client
```

### LDAP Applications Integration

```
Application → LDAP(S) → AWS Managed AD
  ├── Bind with service account
  ├── Search users/groups
  ├── Authenticate users
  └── Read attributes

Common integrations:
  ├── Jenkins (LDAP authentication)
  ├── GitLab (LDAP user sync)
  ├── Grafana (LDAP authentication)
  ├── Apache (LDAP authentication)
  └── Custom applications
```

---

## Amazon WorkSpaces and Directory Integration

### WorkSpaces Directory Options

```
Option 1: AWS Managed Microsoft AD
  ├── Full-featured AD
  ├── Supports Group Policy for WorkSpaces
  ├── Local authentication (no on-premises dependency)
  └── Best for: Enterprise, multi-service AD needs

Option 2: AD Connector
  ├── Proxy to on-premises AD
  ├── Users authenticate against on-premises AD
  ├── Depends on network connectivity
  └── Best for: Using existing on-premises user accounts

Option 3: Simple AD
  ├── Basic AD for small deployments
  ├── No trust, no MFA
  └── Best for: Small, standalone WorkSpaces deployments
```

### WorkSpaces Multi-Account Pattern

```
Shared Services Account:
  └── AWS Managed AD (corp.example.com)
      ├── Shared with WorkSpaces Account A
      └── Shared with WorkSpaces Account B

WorkSpaces Account A:
  └── WorkSpaces using shared directory
      └── Users from corp.example.com

WorkSpaces Account B:
  └── WorkSpaces using shared directory
      └── Users from corp.example.com
```

---

## RADIUS MFA Integration

### Architecture

```
User → WorkSpaces/Client VPN → AWS Managed AD
  │                                │
  │  1. Username + Password        │  2. RADIUS Access-Request
  │                                │     (username, password)
  │                                │
  │                                ▼
  │                          ┌──────────────┐
  │                          │ RADIUS Server │
  │                          │ (On-premises  │
  │                          │  or EC2)      │
  │                          │              │
  │                          │ MFA Provider:│
  │                          │ ├── Duo      │
  │                          │ ├── RSA      │
  │                          │ ├── Symantec │
  │                          │ └── Custom   │
  │                          └──────┬───────┘
  │                                 │
  │  4. Access Granted              │ 3. RADIUS Access-Accept
  │  (if password + MFA valid)      │    (MFA verified)
  │                                 │
  └─────────────────────────────────┘
```

### RADIUS Configuration on Managed AD

```bash
aws ds enable-radius \
  --directory-id d-abc123 \
  --radius-settings \
    RadiusServers=172.16.1.50,172.16.1.51 \
    RadiusPort=1812 \
    RadiusTimeout=10 \
    RadiusRetries=3 \
    SharedSecret="your-shared-secret" \
    AuthenticationProtocol=PAP \
    DisplayLabel="MFA"
```

### RADIUS Supported Protocols

| Protocol | Description |
|---|---|
| **PAP** | Password Authentication Protocol (most common) |
| **CHAP** | Challenge-Handshake Authentication Protocol |
| **MS-CHAPv1** | Microsoft CHAP version 1 |
| **MS-CHAPv2** | Microsoft CHAP version 2 |

### Network Requirements for RADIUS

- RADIUS server must be reachable from AWS Managed AD (via DX/VPN or within VPC)
- UDP port 1812 (authentication) and 1813 (accounting) must be open
- Security group on Managed AD ENIs must allow outbound RADIUS traffic

---

## Exam Scenarios

### Scenario 1: Hybrid DNS Resolution

**Question**: A company has an on-premises data center connected to AWS via Direct Connect. Applications in AWS VPCs need to resolve on-premises DNS names (*.corp.example.com), and on-premises servers need to resolve AWS private DNS names (*.internal.aws.example.com). How should you design the DNS architecture?

**Answer**:
1. Create Route 53 Resolver **Outbound Endpoint** in the network VPC
2. Create **Forwarding Rule**: `*.corp.example.com` → on-premises DNS servers
3. Share forwarding rule via **RAM** to all workload VPCs
4. Create Route 53 Resolver **Inbound Endpoint** in the network VPC
5. Configure on-premises DNS **conditional forwarder**: `*.internal.aws.example.com` → Inbound Endpoint IPs
6. Create **Private Hosted Zone**: `internal.aws.example.com` and associate with all VPCs
7. Ensure DNS traffic (UDP/TCP 53) is allowed in security groups and NACLs

### Scenario 2: Directory Service Selection

**Question**: A company is migrating to AWS and needs Active Directory for EC2 domain join, WorkSpaces, and RDS SQL Server Windows authentication. They have an existing on-premises AD and want to maintain a single user identity. They also need the solution to work if the VPN connection to on-premises goes down temporarily.

**Answer**:
- **AWS Managed Microsoft AD** with **two-way forest trust** to on-premises AD
- NOT AD Connector (fails when VPN is down)
- Managed AD provides local authentication capability
- Two-way trust allows users from either domain to access resources in both
- Share the directory with accounts needing WorkSpaces and RDS integration

### Scenario 3: Cross-Account DNS

**Question**: An organization with 50 AWS accounts needs centralized DNS management. Applications in each account need to resolve both on-premises and other accounts' DNS names.

**Answer**:
1. **Network Account**: Host Resolver Endpoints (Inbound + Outbound)
2. **Network Account**: Create forwarding rules for on-premises domains
3. **RAM**: Share forwarding rules with all accounts
4. **Per-Account PHZs**: Each account manages its own application DNS
5. **Cross-Account PHZ Association**: Associate PHZs across accounts as needed
6. **Shared PHZ**: Create shared PHZ (e.g., `shared.internal`) for cross-cutting services

### Scenario 4: DNS Security

**Question**: A company wants to prevent DNS exfiltration and block access to known malicious domains across all VPCs in the organization.

**Answer**:
1. **Route 53 Resolver DNS Firewall** Rule Group in Security Account
2. AWS Managed Domain Lists (malware + botnet)
3. Custom domain lists for company-specific blocks
4. **RAM**: Share DNS Firewall Rule Groups with all accounts
5. **Firewall Manager**: Enforce DNS Firewall association across all VPCs
6. **CloudWatch Logs**: Log DNS Firewall queries for monitoring

### Scenario 5: WorkSpaces with MFA

**Question**: A company wants to deploy Amazon WorkSpaces with MFA. They use Duo Security for MFA and have an on-premises Active Directory.

**Answer**:
1. Deploy **AWS Managed Microsoft AD** in AWS
2. Create **two-way trust** with on-premises AD
3. Deploy **Duo RADIUS Proxy** (EC2 or on-premises)
4. Enable **RADIUS MFA** on AWS Managed AD pointing to Duo RADIUS Proxy
5. Configure WorkSpaces to use AWS Managed AD
6. Users authenticate with AD password + Duo MFA push/code

### Scenario 6: Directory Sharing for Multi-Account

**Question**: An organization has 20 accounts. Multiple accounts need to join EC2 instances to the same Active Directory domain. How should the directory be architectured?

**Answer**:
1. **Shared Services Account**: Deploy AWS Managed Microsoft AD
2. Use **Directory Sharing** to share with all accounts needing domain join
3. Within Organizations, use **ORGANIZATIONS** share method (automatic)
4. Each workload account uses the shared directory for:
   - EC2 domain join (via SSM or manual)
   - FSx Windows File Server
   - RDS SQL Server Windows Auth
5. Manage users/groups centrally from the Shared Services Account

---

## Exam Tips Summary

### DNS Quick Reference

| Need | Solution |
|---|---|
| On-premises → AWS DNS resolution | Inbound Endpoint |
| AWS → On-premises DNS resolution | Outbound Endpoint + Forwarding Rules |
| Share DNS rules across accounts | RAM (Resolver Rules) |
| Block malicious DNS queries | DNS Firewall |
| Enforce DNS Firewall across org | Firewall Manager |
| Internal DNS per application | Private Hosted Zone |
| Same domain, different answers | Split-View DNS (public + private PHZ) |
| Cross-account DNS resolution | Cross-account PHZ association |

### Directory Service Quick Reference

| Need | Solution |
|---|---|
| Full AD in AWS (standalone) | AWS Managed Microsoft AD |
| Full AD in AWS (hybrid) | AWS Managed Microsoft AD + Trust |
| Proxy auth to on-premises AD | AD Connector |
| Basic AD (small, cheap) | Simple AD |
| AD across multiple accounts | Directory Sharing |
| MFA for AD authentication | RADIUS integration (Managed AD only) |
| AD in multiple regions | Managed AD multi-region replication |
| WorkSpaces with existing AD | AD Connector or Managed AD with trust |

### Critical Facts

1. **Inbound Endpoint**: On-premises DNS forwards TO these IPs to resolve AWS DNS
2. **Outbound Endpoint**: AWS forwards FROM these to resolve on-premises DNS
3. **Forwarding Rules can be shared via RAM**: But the outbound endpoint is in the sharing account
4. **PHZ overrides public zones**: For associated VPCs
5. **Cross-account PHZ**: Requires authorization from PHZ owner + association from VPC owner
6. **AD Connector is a proxy**: No data in AWS, fails without connectivity
7. **Managed AD**: Survives network outage to on-premises
8. **Trust direction ≠ access direction**: "A trusts B" means B's users access A's resources
9. **Directory Sharing**: Different from trust — shares the same directory, not a trust between two directories
10. **RADIUS MFA**: Only supported with Managed Microsoft AD, NOT Simple AD or AD Connector

### Common Exam Traps

| Trap | Correct Answer |
|---|---|
| AD Connector works without VPN | Requires network connectivity to on-premises |
| Simple AD supports trusts | Simple AD does NOT support trusts |
| Forwarding rules forward from shared accounts' endpoints | Correct — forwarding uses the sharing account's outbound endpoint |
| PHZ resolves for non-associated VPCs | PHZ only resolves for explicitly associated VPCs |
| Inbound endpoint is for AWS → on-premises | Inbound is for on-premises → AWS |
| AD Connector supports MFA directly | AD Connector supports RADIUS MFA by proxying to on-premises RADIUS |

---

## Advanced DNS Patterns

### Route 53 Resolver Query Logging

Monitor all DNS queries from your VPCs:

```
VPC DNS Query → Route 53 Resolver → Query Log
  │
  └── Destinations:
      ├── CloudWatch Logs (real-time analysis)
      ├── S3 (long-term storage, Athena queries)
      └── Kinesis Data Firehose (streaming analytics)
```

**Query Log Record Fields**:
- `queryName`: Domain queried (e.g., `api.example.com`)
- `queryType`: DNS record type (A, AAAA, CNAME, etc.)
- `queryClass`: Usually IN (Internet)
- `rcode`: Response code (NOERROR, NXDOMAIN, SERVFAIL)
- `answers`: Resolved addresses
- `srcAddr`: IP of the querying resource
- `srcPort`: Source port
- `transport`: UDP or TCP
- `vpcId`: VPC where query originated

**Security Use Cases**:
- Detect DNS exfiltration attempts (unusually long subdomains)
- Monitor for known malicious domains
- Audit which resources access which domains
- Troubleshoot DNS resolution issues

### Route 53 Private Hosted Zone Automation

**Automated PHZ Association with EventBridge**:
```
New VPC Created (EventBridge)
  → Lambda Function:
    1. List all central PHZs
    2. Associate new VPC with each PHZ
    3. Create forwarding rule associations
    4. Log the association
```

```python
import boto3

def associate_vpc_with_phzs(vpc_id, region):
    route53 = boto3.client('route53')
    
    central_phz_ids = ['Z1234567890', 'Z0987654321']
    
    for phz_id in central_phz_ids:
        route53.associate_vpc_with_hosted_zone(
            HostedZoneId=phz_id,
            VPC={
                'VPCRegion': region,
                'VPCId': vpc_id
            }
        )
```

### DNS Failover Patterns

**Active-Passive DNS Failover**:
```
Route 53 Health Check → Primary Endpoint (us-east-1)
  │
  ├── Healthy → Resolve to Primary IP
  │
  └── Unhealthy → Failover to Secondary IP (us-west-2)
```

**Weighted DNS for Blue-Green Deployments**:
```
api.example.com:
  ├── Record Set 1: 10.0.1.50 (Weight: 90) → Blue environment
  └── Record Set 2: 10.0.2.50 (Weight: 10) → Green environment
```

### Multi-Account DNS Delegation Pattern

```
Central DNS Account:
  └── PHZ: internal.company.com
      ├── NS record: app-a.internal.company.com → App-A Account PHZ
      ├── NS record: app-b.internal.company.com → App-B Account PHZ
      └── Direct records: shared.internal.company.com → 10.0.1.50

App-A Account:
  └── PHZ: app-a.internal.company.com
      ├── api.app-a.internal.company.com → 10.1.1.50
      └── web.app-a.internal.company.com → 10.1.2.50

App-B Account:
  └── PHZ: app-b.internal.company.com
      ├── api.app-b.internal.company.com → 10.2.1.50
      └── web.app-b.internal.company.com → 10.2.2.50
```

This allows each team to manage their own DNS while the central team manages the parent zone.

---

## Advanced Directory Patterns

### Managed AD with On-Premises Conditional Forwarding

```
DNS Resolution for Trust:

AWS Managed AD (aws.example.com):
  └── Conditional Forwarder:
      corp.example.com → On-premises DNS IPs (172.16.1.10, 172.16.1.11)

On-Premises AD (corp.example.com):
  └── Conditional Forwarder:
      aws.example.com → AWS Managed AD DNS IPs (10.1.1.10, 10.1.2.10)
      OR
      aws.example.com → Route 53 Inbound Endpoint IPs
```

### Managed AD Group Policy Management

```
AWS Managed AD:
  │
  ├── OU: AWS Reserved (managed by AWS — DO NOT MODIFY)
  │
  ├── OU: Users
  │   ├── User accounts
  │   └── Service accounts
  │
  ├── OU: Computers
  │   ├── EC2 instances (domain-joined)
  │   └── WorkSpaces
  │
  ├── OU: Groups
  │   ├── AWS-Admins
  │   ├── Developers
  │   └── Service-Accounts
  │
  └── Group Policies:
      ├── Password Policy (custom, applied to domain)
      ├── Security Settings (applied to Computers OU)
      └── User Settings (applied to Users OU)

Note: You manage OUs UNDER the domain root.
AWS manages the top-level AWS Reserved OU.
```

### EC2 Domain Join via SSM

```yaml
# CloudFormation - EC2 Domain Join
Resources:
  EC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      SsmAssociations:
        - DocumentName: AWS-JoinDirectoryServiceDomain
          AssociationParameters:
            - Key: directoryId
              Value:
                - !Ref DirectoryId
            - Key: directoryName
              Value:
                - "corp.example.com"
            - Key: directoryOU
              Value:
                - "OU=Computers,OU=corp,DC=corp,DC=example,DC=com"
            - Key: dnsIpAddresses
              Value:
                - "10.1.1.10"
                - "10.1.2.10"
      IamInstanceProfile: !Ref SSMInstanceProfile
```

### FSx for Windows File Server with AD

```
Shared Services Account:
  └── AWS Managed AD: corp.example.com

Workload Account:
  └── FSx for Windows File Server:
      ├── Joined to corp.example.com (shared directory)
      ├── File shares accessible by AD users
      ├── NTFS permissions managed via AD groups
      ├── DFS namespace support
      └── VSS (Volume Shadow Copy) for snapshots
```

### RDS SQL Server Windows Authentication

```
Workload Account:
  └── RDS SQL Server:
      ├── Domain: corp.example.com (shared directory)
      ├── Windows authentication enabled
      ├── AD groups mapped to SQL Server logins
      └── Kerberos authentication for clients
```

### Amazon Connect with AD Integration

```
Connect Instance → AWS Managed AD
  ├── Agent authentication via AD credentials
  ├── User sync from AD groups
  └── SSO integration with Identity Center
```

---

## Directory Service Sizing and Performance

### Managed Microsoft AD Editions

| Feature | Standard | Enterprise |
|---|---|---|
| Users | Up to 5,000 | Up to 500,000 |
| Objects | Up to 30,000 | Up to 500,000 |
| Domain controllers | 2 (min) | 2 (min), add more for scale |
| Multi-region | Yes | Yes |
| Trusts | Yes | Yes |
| Schema extensions | Yes | Yes |
| Cost | Lower | Higher |

### Scaling Managed AD

```
Add additional domain controllers:
  aws ds update-number-of-domain-controllers \
    --directory-id d-abc123 \
    --desired-number 4

Benefits of additional DCs:
  ├── Higher read throughput (LDAP queries)
  ├── Better fault tolerance
  ├── Reduced latency (spread across AZs)
  └── Higher concurrent authentication capacity
```

### Directory Service Monitoring

```
CloudWatch Metrics for Managed AD:
  ├── LDAP Searches / min
  ├── LDAP Binds / min
  ├── DNS Queries / min
  ├── Kerberos Authentications / min
  └── Domain Controller health

CloudWatch Alarms:
  ├── LDAP search latency > threshold
  ├── Failed authentication rate > threshold
  └── Domain controller unreachable
```

---

## Hybrid Identity Architecture — Complete Reference

### Enterprise Hybrid Identity Pattern

```
On-Premises:
  ├── Active Directory (corp.example.com)
  │   ├── 10,000 users
  │   ├── 500 groups
  │   └── Group Policies
  │
  ├── ADFS (Federation to cloud services)
  │   └── SAML assertions for AWS
  │
  └── DNS Servers
      └── Conditional forwarders to AWS

AWS:
  ├── AWS Managed AD (aws.corp.example.com)
  │   ├── Two-way forest trust to on-premises
  │   ├── Users can authenticate from either domain
  │   ├── Shared with 20+ workload accounts
  │   └── Multi-region replication (DR)
  │
  ├── IAM Identity Center
  │   ├── Identity source: AWS Managed AD
  │   ├── Maps AD groups to permission sets
  │   └── SSO portal for all accounts
  │
  ├── Route 53 Resolver
  │   ├── Inbound: On-prem resolves AWS DNS
  │   ├── Outbound: AWS resolves on-prem DNS
  │   └── Forwarding rules shared via RAM
  │
  └── Workload Accounts:
      ├── EC2 instances domain-joined
      ├── FSx using AD authentication
      ├── RDS using Windows authentication
      └── WorkSpaces using AD credentials
```

### Migration from On-Premises AD to AWS

```
Phase 1: Deploy AWS Managed AD
  ├── Create AWS Managed AD in Shared Services account
  ├── Configure DNS (conditional forwarders)
  └── Create two-way forest trust

Phase 2: Extend Services to AWS AD
  ├── Domain join EC2 instances to AWS AD
  ├── Configure Identity Center with AWS AD
  ├── Share directory with workload accounts
  └── Test authentication flows

Phase 3: Migrate Users (optional, if removing on-prem AD)
  ├── Use ADMT (AD Migration Tool)
  ├── Migrate users, groups, service accounts
  ├── Update application configurations
  └── Update Group Policies

Phase 4: Cut Over
  ├── Point DNS to AWS AD
  ├── Update trust to one-way (or remove)
  ├── Decommission on-premises AD
  └── Update documentation
```

---

*Previous Article: [← Networking & Connectivity](./04-networking-connectivity.md)*
*Next Article: [Identity Federation →](./06-identity-federation.md)*
