# Route 53 & DNS

## Table of Contents

- [Overview](#overview)
- [DNS Fundamentals](#dns-fundamentals)
  - [How DNS Works](#how-dns-works)
  - [Record Types](#record-types)
- [Hosted Zones](#hosted-zones)
  - [Public Hosted Zones](#public-hosted-zones)
  - [Private Hosted Zones](#private-hosted-zones)
- [ALIAS Records vs CNAME Records](#alias-records-vs-cname-records)
- [Routing Policies](#routing-policies)
  - [Simple Routing](#simple-routing)
  - [Weighted Routing](#weighted-routing)
  - [Latency-Based Routing](#latency-based-routing)
  - [Failover Routing](#failover-routing)
  - [Geolocation Routing](#geolocation-routing)
  - [Geoproximity Routing](#geoproximity-routing)
  - [Multi-Value Answer Routing](#multi-value-answer-routing)
  - [IP-Based Routing](#ip-based-routing)
- [Health Checks](#health-checks)
  - [Endpoint Health Checks](#endpoint-health-checks)
  - [Calculated Health Checks](#calculated-health-checks)
  - [CloudWatch Alarm-Based Health Checks](#cloudwatch-alarm-based-health-checks)
- [Route 53 Resolver](#route-53-resolver)
- [Domain Registration](#domain-registration)
- [DNSSEC](#dnssec)
- [Traffic Flow and Traffic Policies](#traffic-flow-and-traffic-policies)
- [Route 53 as Registrar vs Hosted Zone Provider](#route-53-as-registrar-vs-hosted-zone-provider)
- [Split-View DNS](#split-view-dns)
- [Pricing Model](#pricing-model)
- [Route 53 Application Recovery Controller](#route-53-application-recovery-controller)
- [Common Exam Scenarios](#common-exam-scenarios)

---

## Overview

Amazon Route 53 is a highly available and scalable Domain Name System (DNS) web service. It performs three main functions:

1. **Domain Registration** — Register domain names
2. **DNS Routing** — Route internet traffic to resources
3. **Health Checking** — Monitor the health of resources

Route 53 is named after TCP/UDP port 53, which is the port used for DNS. It is a **global service** — not tied to any specific Region.

Route 53 has a 100% availability SLA — the only AWS service with this guarantee.

---

## DNS Fundamentals

### How DNS Works

DNS is the system that translates human-readable domain names (like `www.example.com`) into IP addresses (like `93.184.216.34`).

**DNS Resolution Flow:**

```
1. User types www.example.com in browser
2. Browser checks local cache → not found
3. OS checks its DNS cache → not found
4. Query goes to Recursive DNS Resolver (ISP or configured resolver like 8.8.8.8)
5. Resolver checks its cache → not found
6. Resolver queries Root DNS Server (.) → returns .com TLD server address
7. Resolver queries .com TLD Server → returns example.com NS server address
8. Resolver queries example.com Authoritative Name Server (Route 53) → returns IP address
9. Resolver caches the response (for TTL duration)
10. Resolver returns IP to the user's browser
11. Browser connects to the IP address
```

**Key Terms:**
- **DNS Resolver (Recursive Resolver):** Intermediary between user and authoritative DNS
- **Root DNS Server:** Top of the DNS hierarchy (13 root server groups globally)
- **TLD Server:** Manages top-level domains (.com, .org, .net, etc.)
- **Authoritative Name Server:** Has the actual DNS records for a domain (Route 53 acts as this)
- **TTL (Time To Live):** How long a DNS record is cached (in seconds)

### Record Types

#### A Record
- Maps a hostname to an **IPv4 address**
- Example: `www.example.com → 93.184.216.34`
- Most commonly used record type

#### AAAA Record
- Maps a hostname to an **IPv6 address**
- Example: `www.example.com → 2606:2800:220:1:248:1893:25c8:1946`

#### CNAME Record (Canonical Name)
- Maps a hostname to **another hostname**
- Example: `app.example.com → myapp-123.us-east-1.elb.amazonaws.com`
- **Cannot be used for the zone apex** (naked domain) — e.g., cannot create a CNAME for `example.com`
- Can only be used for non-root domain names (subdomains)
- Charges apply for CNAME queries to Route 53

#### MX Record (Mail Exchange)
- Specifies mail servers for a domain
- Contains a **priority** and a **hostname**
- Example: `example.com MX 10 mail1.example.com, 20 mail2.example.com`
- Lower priority number = higher preference

#### NS Record (Name Server)
- Identifies the DNS servers (name servers) for a hosted zone
- When you create a hosted zone, Route 53 assigns 4 NS records
- Example: `example.com NS ns-100.awsdns-12.com`
- Controls which DNS servers are authoritative for the domain

#### SOA Record (Start of Authority)
- Contains administrative information about the zone
- Includes: primary name server, admin email, serial number, refresh/retry/expire timers, minimum TTL
- Every hosted zone has exactly one SOA record

#### TXT Record
- Contains text information for outside sources
- Common uses: domain verification (for email services, SSL certificates), SPF records
- Example: `example.com TXT "v=spf1 include:_spf.google.com ~all"`

#### SRV Record (Service)
- Specifies location of services (host and port)
- Format: `_service._protocol.name TTL class SRV priority weight port target`
- Used for services like LDAP, SIP, XMPP
- Example: `_sip._tcp.example.com SRV 10 60 5060 sipserver.example.com`

#### PTR Record (Pointer)
- Reverse DNS lookup — maps an IP address to a hostname
- Used to verify the hostname associated with an IP
- Example: `34.216.184.93.in-addr.arpa PTR www.example.com`

#### ALIAS Record (AWS-specific)
- **Route 53 proprietary extension** to DNS
- Maps a hostname to an **AWS resource**
- Works for both root domain (zone apex) and subdomains
- Free for queries to AWS resources
- See detailed comparison below

---

## Hosted Zones

A hosted zone is a container for DNS records for a specific domain and its subdomains.

### Public Hosted Zones

- Contains records that specify how to route traffic on the **internet**
- Anyone on the internet can query these records
- Created automatically when you register a domain with Route 53, or created manually for domains registered elsewhere
- Each public hosted zone is assigned **4 unique name servers** across 4 different TLDs (.com, .net, .org, .co.uk)
- Cost: $0.50/month per hosted zone + per-query charges

### Private Hosted Zones

- Contains records that specify how to route traffic within **one or more VPCs**
- DNS queries are resolved only within the associated VPCs
- Not accessible from the internet
- Must be associated with at least one VPC
- Can be associated with **VPCs in different Regions** and **different accounts**
- Requires `enableDnsSupport` and `enableDnsHostnames` to be true on the VPC
- Cost: $0.50/month per hosted zone + per-query charges

**Associating Private Hosted Zones with VPCs in Other Accounts:**
1. Use the CLI/API: `create-vpc-association-authorization` from the hosted zone account
2. Use the CLI/API: `associate-vpc-with-hosted-zone` from the VPC account
3. Optionally remove the authorization afterward

---

## ALIAS Records vs CNAME Records

This comparison is one of the most frequently tested topics for Route 53.

| Feature | ALIAS Record | CNAME Record |
|---|---|---|
| **Type** | Route 53 proprietary | Standard DNS |
| **Zone Apex (root domain)** | YES — can be used for `example.com` | NO — cannot be used for `example.com` |
| **Target** | AWS resources only | Any hostname (AWS or non-AWS) |
| **TTL** | Set by Route 53 automatically | You set the TTL |
| **Health Checks** | Supports health checks | Supports health checks |
| **Query Charges** | FREE for AWS resource targets | Standard per-query charges |
| **Record Type** | Appears as A or AAAA record | Appears as CNAME record |
| **DNS Protocol** | Native A/AAAA response | Returns another hostname (extra lookup) |
| **Performance** | Faster (direct IP response) | Slower (requires additional DNS resolution) |

### ALIAS Record Targets

ALIAS records can point to these AWS resources:
- **Elastic Load Balancers** (ALB, NLB, CLB)
- **CloudFront distributions**
- **Amazon API Gateway** (Regional and Edge-optimized)
- **Elastic Beanstalk environments**
- **S3 website endpoints** (static website hosting)
- **VPC Interface Endpoints**
- **Global Accelerator**
- **Route 53 records** in the same hosted zone

**ALIAS records CANNOT point to:**
- EC2 instances (use A record with the instance's IP instead)
- RDS endpoints directly (use CNAME)
- Non-AWS resources

### When to Use Each

| Scenario | Use |
|---|---|
| Root domain (`example.com`) pointing to ALB | ALIAS |
| Root domain pointing to CloudFront | ALIAS |
| Subdomain pointing to an ALB | Either (ALIAS is free and faster) |
| Pointing to a non-AWS hostname | CNAME |
| Need specific TTL control | CNAME |
| Want to minimize DNS query costs | ALIAS (free for AWS targets) |

> **Exam Tip:** If a question says "zone apex" or "naked domain" (like `example.com` without `www`), the answer is always ALIAS, never CNAME. CNAME cannot be used for zone apex — this is a DNS protocol restriction, not an AWS restriction.

---

## Routing Policies

Route 53 routing policies determine how DNS queries are answered. This is the most heavily tested Route 53 topic.

### Simple Routing

- **One record** with one or more IP addresses
- If multiple values are specified, Route 53 returns **all values in random order**
- The client chooses which IP to use
- **No health checks** can be associated with simple routing
- Use case: Single resource, no failover needed

```
example.com → A → 10.0.1.1, 10.0.1.2, 10.0.1.3
(Client randomly picks one)
```

### Weighted Routing

- Route traffic to multiple resources based on **assigned weights**
- Each record has a weight (0-255)
- Traffic percentage = (record weight) / (sum of all weights)
- Weights don't need to add up to 100
- A weight of 0 stops traffic to that resource
- If all weights are 0, all records are returned equally
- **Supports health checks** — unhealthy records are excluded
- Use cases: A/B testing, gradual migration, blue/green deployment

```
example.com → A → 10.0.1.1 (weight: 70)   → 70% of traffic
example.com → A → 10.0.2.1 (weight: 20)   → 20% of traffic
example.com → A → 10.0.3.1 (weight: 10)   → 10% of traffic
```

### Latency-Based Routing

- Routes traffic to the resource with the **lowest latency** for the user
- Route 53 measures latency between the user's DNS resolver and AWS Regions
- Records are defined with an associated **AWS Region**
- **Supports health checks** — if the lowest-latency resource is unhealthy, routes to the next best
- Use case: Multi-region deployments where you want users routed to the closest Region

```
example.com → A → 10.0.1.1 (Region: us-east-1)
example.com → A → 10.0.2.1 (Region: eu-west-1)
example.com → A → 10.0.3.1 (Region: ap-northeast-1)

User in France → eu-west-1 (lowest latency)
User in Japan → ap-northeast-1 (lowest latency)
```

> **Note:** Latency is based on network latency measurements between users and AWS Regions, not geographic distance. A user in Country A might have lower latency to a Region in Country B than to a closer Region in Country C due to network routing.

### Failover Routing

- Active-passive failover configuration
- **Primary** record: the main resource
- **Secondary** record: the failover resource
- Route 53 routes to the primary unless it's unhealthy, then routes to the secondary
- **Health check required** on the primary record
- Health check optional on the secondary (if not set, secondary is always considered healthy)
- Use case: Active-passive disaster recovery

```
example.com → A → Primary: 10.0.1.1 (health check: required)
                → Secondary: 10.0.2.1 (failover target)

Primary healthy → 10.0.1.1
Primary unhealthy → 10.0.2.1
```

### Geolocation Routing

- Routes traffic based on the **geographic location** of the user (continent, country, or US state)
- **Does NOT measure latency** — purely based on geographic location
- You must define a **default record** for users whose location doesn't match any record (otherwise, they get no response)
- More specific locations override less specific ones (US state > country > continent > default)
- **Supports health checks**
- Use cases: Content localization, restrict content distribution by geography, load balancing by geography

```
example.com → A → 10.0.1.1 (Location: Europe)
example.com → A → 10.0.2.1 (Location: United States)
example.com → A → 10.0.3.1 (Location: Asia)
example.com → A → 10.0.4.1 (Location: Default)

User in Germany → 10.0.1.1 (Europe)
User in California → 10.0.2.1 (United States)
User in Brazil → 10.0.4.1 (Default — no South America record)
```

### Geoproximity Routing

- Routes traffic based on the geographic location of users **AND resources**, with the ability to shift traffic using a **bias**
- Uses Route 53 **Traffic Flow** feature (required)
- You define resources with their location (AWS Region or latitude/longitude for non-AWS resources)
- **Bias** expands or shrinks the geographic area from which traffic is routed to a resource:
  - Positive bias (1-99): Expands the geographic area → attracts more traffic
  - Negative bias (-1 to -99): Shrinks the geographic area → routes less traffic
  - Zero: No bias, routing based purely on proximity
- **Supports health checks**
- Use case: Gradually shift traffic between regions, fine-tune geographic routing

```
example.com → Region: us-east-1, bias: +25 (attracts more traffic)
example.com → Region: eu-west-1, bias: 0 (neutral)
example.com → Region: ap-southeast-1, bias: -10 (routes less traffic)
```

### Multi-Value Answer Routing

- Returns **up to 8 healthy records** selected at random for each DNS query
- Each record can have an associated **health check**
- Unhealthy records are excluded from responses
- **Not a substitute for a load balancer** — but provides client-side load balancing with health checking
- Use case: Basic health-checked DNS load balancing across multiple resources

```
example.com → A → 10.0.1.1 (health check ✓)
example.com → A → 10.0.1.2 (health check ✓)
example.com → A → 10.0.1.3 (health check ✗ → excluded)
example.com → A → 10.0.1.4 (health check ✓)

Query response: 10.0.1.1, 10.0.1.2, 10.0.1.4 (random order, up to 8)
```

### IP-Based Routing

- Routes traffic based on the **client's IP address** (or more precisely, the CIDR block of the client's DNS resolver)
- You create **CIDR collections** (lists of IP ranges) and associate records with them
- Use cases:
  - Route ISP-specific traffic to optimized endpoints
  - Route traffic from known IP ranges to specific resources
  - Optimize costs by routing traffic through specific paths based on source

```
CIDR Collection "ISP-A": 203.0.113.0/24, 198.51.100.0/24
CIDR Collection "ISP-B": 192.0.2.0/24

example.com → A → 10.0.1.1 (CIDR: ISP-A)
example.com → A → 10.0.2.1 (CIDR: ISP-B)
example.com → A → 10.0.3.1 (Default)
```

### Routing Policy Comparison

| Policy | Based On | Health Checks | Use Case |
|---|---|---|---|
| **Simple** | Random | No | Single resource |
| **Weighted** | Assigned weights | Yes | A/B testing, migration |
| **Latency** | Network latency | Yes | Multi-region, best performance |
| **Failover** | Health status | Yes (primary required) | Active-passive DR |
| **Geolocation** | User location | Yes | Localization, restrictions |
| **Geoproximity** | Location + bias | Yes | Shift traffic between regions |
| **Multi-Value** | Random + health | Yes | Basic health-checked LB |
| **IP-Based** | Client IP/CIDR | Yes | ISP-specific routing |

---

## Health Checks

Route 53 health checks monitor the health of your resources and can trigger DNS failover.

### Endpoint Health Checks

Monitor the health of a specific endpoint (IP address or domain name).

**Health Check Types:**

| Protocol | How It Works |
|---|---|
| **HTTP** | Route 53 sends an HTTP request. Healthy if 2xx or 3xx status code in response. |
| **HTTPS** | Same as HTTP but over TLS. Route 53 does NOT validate SSL certificates. |
| **TCP** | Route 53 attempts a TCP connection. Healthy if connection succeeds within 10 seconds. |

**Configuration Options:**
- **IP address or domain name** of the endpoint
- **Port** to check
- **Path** (for HTTP/HTTPS) — can check a specific URL path
- **Request interval:** 30 seconds (standard) or 10 seconds (fast — 3x cost)
- **Failure threshold:** Number of consecutive failures before marking unhealthy (1-10, default 3)
- **String matching** (HTTP/HTTPS): Check if the response body contains a specific string (first 5,120 bytes)
- **Latency graphs:** View latency over time
- **Invert health check status:** Flip healthy/unhealthy

**How Health Checks Work:**
- Route 53 health checkers are distributed **globally** across multiple Regions
- About **15 health checkers** evaluate the endpoint
- Default interval: Every 30 seconds = one request every ~2 seconds from health checkers combined
- The endpoint must respond to requests from Route 53 health checker IP ranges
- You must **allow incoming traffic** from Route 53 health checker IPs in your security groups/firewalls
- Health checker IPs are published and can be retrieved via API

> **Important:** If your endpoint is behind a firewall or security group, you must allow inbound traffic from Route 53 health checker IP addresses. These IP ranges are published at `https://ip-ranges.amazonaws.com/ip-ranges.json` (filter by service `ROUTE53_HEALTHCHECKS`).

### Calculated Health Checks

Combine the results of multiple health checks into a single health check.

**Configuration:**
- Define **child health checks** (up to 256)
- Specify the **threshold:** minimum number of child health checks that must be healthy
- Logical operations: OR (at least 1), AND (all), or custom threshold (at least N of M)

```
Calculated Health Check (threshold: 2 of 3)
├── Child Health Check 1: Healthy ✓
├── Child Health Check 2: Unhealthy ✗
└── Child Health Check 3: Healthy ✓
→ Calculated: Healthy (2 of 3 healthy, meets threshold)
```

Use cases:
- Perform maintenance on one resource without triggering failover
- Combine health of multiple endpoints into one check
- Create complex health check logic

### CloudWatch Alarm-Based Health Checks

Monitor the status of a **CloudWatch alarm** instead of directly checking an endpoint.

**Why use this?**
- Health check endpoints in **private subnets** or private VPCs cannot be reached by Route 53 health checkers (which are public)
- Solution: Create a CloudWatch metric/alarm for the private resource, then create a Route 53 health check based on that alarm

```
Private resource → CloudWatch metric → CloudWatch alarm → Route 53 health check → DNS routing
```

**States:**
- CloudWatch alarm in `OK` state → health check is healthy
- CloudWatch alarm in `ALARM` state → health check is unhealthy
- CloudWatch alarm in `INSUFFICIENT_DATA` state → health check status depends on configuration (healthy, unhealthy, or last known)

> **Exam Tip:** This is the only way to health-check private resources with Route 53. If a question mentions health checking an RDS instance in a private subnet, the answer involves CloudWatch alarms.

---

## Route 53 Resolver

Route 53 Resolver enables hybrid DNS resolution between your VPC and on-premises networks.

### Default Behavior

- Every VPC gets a **default DNS resolver** (VPC base + 2, e.g., `10.0.0.2`)
- This resolver can resolve:
  - Public DNS names
  - Private hosted zone records
  - VPC internal names (e.g., `ip-10-0-1-5.ec2.internal`)
- By default, on-premises servers **cannot** query Route 53 Resolver
- By default, VPC instances **cannot** query on-premises DNS servers

### Inbound Endpoints

Allow on-premises DNS servers to forward DNS queries to Route 53 Resolver.

**How it works:**
1. Create an inbound endpoint (deploys ENIs in your VPC)
2. Route 53 assigns IP addresses to the ENIs
3. Configure on-premises DNS servers to forward specific domains to these IP addresses
4. Queries are resolved by Route 53 (including private hosted zones)

**Architecture:**
```
On-premises DNS server
    → Conditional forwarder: *.aws.example.com → 10.0.1.10, 10.0.2.10
    → Route 53 Resolver (Inbound Endpoint ENIs)
    → Resolves private hosted zones, VPC DNS
```

### Outbound Endpoints

Allow Route 53 Resolver to forward DNS queries to on-premises DNS servers.

**How it works:**
1. Create an outbound endpoint (deploys ENIs in your VPC)
2. Create **forwarding rules** that specify which domain queries to forward and to which DNS server IPs
3. When a VPC instance queries a matching domain, Route 53 forwards the query to on-premises DNS

**Architecture:**
```
VPC instance queries: server1.corp.example.com
    → Route 53 Resolver
    → Forwarding rule: *.corp.example.com → 172.16.0.53 (on-premises DNS)
    → Outbound Endpoint ENIs
    → VPN/Direct Connect
    → On-premises DNS server
    → Returns IP address
```

### Resolver Rules

| Rule Type | Description |
|---|---|
| **Forward** | Forward queries for specific domains to specified DNS servers |
| **System** | Use Route 53 Resolver's default behavior (override forward rules for specific subdomains) |
| **Recursive** | Default rule — Route 53 handles resolution itself |

Forwarding rules can be shared across accounts using **AWS RAM**.

### Resolver Endpoints Requirements

- Create in at least **2 AZs** for high availability
- Each endpoint creates **ENIs** in the specified subnets
- Each ENI gets a private IP address
- Supports up to **10,000 queries per second per IP address**
- Security groups must allow DNS traffic (TCP/UDP port 53)

---

## Domain Registration

Route 53 can also act as a **domain registrar**.

### Key Facts
- Register new domains or transfer existing domains
- Supported TLDs: .com, .org, .net, .io, .co, and many more (200+ TLDs)
- Auto-renewal available
- Route 53 automatically creates a **public hosted zone** when you register a domain
- Domain registration and hosted zones are separate — you can register with Route 53 but host DNS elsewhere, or vice versa
- **Domain lock** (transfer lock) prevents unauthorized domain transfers
- **Privacy protection** hides personal information from WHOIS (free for most TLDs)

### Domain Transfer
- Transfer domains from other registrars to Route 53
- Requires an **authorization code** from the current registrar
- Domain must be **unlocked** at the current registrar
- Transfer takes up to 7 days

---

## DNSSEC

DNS Security Extensions (DNSSEC) adds a layer of security to DNS by enabling DNS responses to be validated for authenticity.

### How DNSSEC Works
- **Cryptographically signs** DNS records
- Resolvers can verify that DNS responses have not been **tampered with** (prevents DNS spoofing)
- Uses public key cryptography: zone signing key (ZSK) and key signing key (KSK)

### Route 53 DNSSEC Support
- Route 53 supports DNSSEC for **domain registration** (setting DS records)
- Route 53 supports DNSSEC **signing** for public hosted zones
- You enable DNSSEC signing on a hosted zone, and Route 53 manages the zone signing
- KMS key (asymmetric, customer-managed, in **us-east-1**) is required for the KSK
- You must create a **chain of trust** by adding a DS (Delegation Signer) record to the parent zone

### DNSSEC Monitoring
- Monitor DNSSEC with CloudWatch alarms on:
  - `DNSSECInternalFailure` — internal error in Route 53
  - `DNSSECKeySigningKeysNeedingAction` — KSK needs attention

---

## Traffic Flow and Traffic Policies

Route 53 Traffic Flow is a visual editor for creating complex DNS routing configurations.

### Key Features
- **Visual policy editor:** Drag-and-drop interface for creating routing trees
- **Traffic policies:** Reusable routing configurations that can be applied to multiple domains
- **Versioning:** Traffic policies support versions — create new versions without affecting existing traffic
- **Geoproximity routing** is only available through Traffic Flow
- Can combine multiple routing types in a single policy (e.g., geolocation → weighted → failover)

### Policy Records
- A **policy record** is the association of a traffic policy with a specific domain/subdomain
- Applying a traffic policy to a domain creates a policy record
- Policy records cost **$50/month each**
- Policy records can be reused across different domains

### Example Complex Routing Tree

```
                    www.example.com
                          │
                    [Geolocation]
                   /       |        \
              US          EU       Default
              │           │          │
          [Latency]   [Weighted]   [Simple]
          /      \     /      \       │
     us-east  us-west  70%    30%   fallback
        │        │      │      │      │
    [Failover] [HC]  eu-west eu-cen   │
    /       \                          │
 primary  secondary                  IP
    │        │
   ALB1    ALB2
```

---

## Route 53 as Registrar vs Hosted Zone Provider

These are two **separate functions** that Route 53 provides, and they can be used independently.

### Registrar Function
- Register and renew domain names
- Manage domain contacts and privacy
- Set name servers for the domain
- Manage domain locks and transfers

### Hosted Zone Function
- Host DNS records
- Answer DNS queries
- Implement routing policies and health checks

### Common Configurations

| Registrar | DNS Hosting | Configuration |
|---|---|---|
| Route 53 | Route 53 | Default — simplest setup |
| Route 53 | Third party (e.g., Cloudflare) | Update NS records in Route 53 to point to third-party name servers |
| Third party (e.g., GoDaddy) | Route 53 | Update NS records at the registrar to point to Route 53 name servers |
| Third party | Third party | Route 53 not involved |

**How to use Route 53 for hosting with a third-party registrar:**
1. Create a public hosted zone in Route 53
2. Note the 4 NS records assigned by Route 53
3. Go to your domain registrar and update the name server records to the Route 53 NS values
4. DNS queries for your domain now reach Route 53

---

## Split-View DNS

Split-view (split-horizon) DNS returns **different answers** for the same domain depending on whether the query comes from inside or outside your network.

### How It Works with Route 53

1. Create a **public hosted zone** for `example.com`
   - Contains records for external/internet users
   - `app.example.com → public ALB IP (52.x.x.x)`

2. Create a **private hosted zone** for `example.com` (same domain name)
   - Associated with your VPC
   - Contains records for internal users
   - `app.example.com → private IP (10.0.1.50)`

3. When an instance in the VPC queries `app.example.com`:
   - Route 53 checks the private hosted zone first → returns `10.0.1.50`

4. When an internet user queries `app.example.com`:
   - Route 53 checks the public hosted zone → returns `52.x.x.x`

### Use Cases
- Internal users access applications directly (bypassing load balancers or firewalls)
- Different endpoints for internal vs external access
- Internal-only services that should not be resolvable from the internet
- Development/staging environments accessible only internally

### Important Rules
- The private hosted zone takes precedence over the public hosted zone for queries from associated VPCs
- If a record exists only in the public zone and not the private zone, VPC queries will NOT fall back to the public zone — they will get NXDOMAIN
- Solution: Mirror all required records in both zones, or put only overrides in the private zone

---

## Pricing Model

### Hosted Zones
- **$0.50 per hosted zone per month** (first 25 hosted zones)
- **$0.10 per hosted zone per month** (above 25)
- Prorated for partial months
- Hosted zones that are deleted within 12 hours of creation are not charged

### DNS Queries

| Query Type | Price per Million Queries |
|---|---|
| Standard queries | $0.40 |
| Latency-based routing | $0.60 |
| Geo DNS (Geolocation/Geoproximity) | $0.70 |
| IP-based routing | $0.80 |
| **ALIAS queries to AWS resources** | **FREE** |

### Health Checks

| Type | Monthly Cost |
|---|---|
| Basic (AWS endpoints) | $0.50 per health check |
| Basic (non-AWS endpoints) | $0.75 per health check |
| Optional features (HTTPS, string matching, fast interval, latency measurement) | $1.00 - $2.00 additional |

### Domain Registration
- Varies by TLD
- `.com`: $12/year
- `.org`: $12/year
- `.io`: $39/year
- `.net`: $11/year
- Includes WHOIS privacy for most TLDs

### Traffic Flow
- **$50/month per policy record**
- Traffic policies themselves are free to create

---

## Route 53 Application Recovery Controller

Route 53 Application Recovery Controller (ARC) helps you manage and coordinate recovery across multiple AWS Regions and AZs.

### Components

#### Readiness Check
- Monitors whether your recovery environment is ready to handle failover traffic
- Checks resource configuration, capacity, and policies across Regions
- Alerts if recovery resources are not configured to match production
- Monitors: Auto Scaling groups, EC2 instances, ELB, RDS, DynamoDB, Lambda, NLB, etc.

#### Routing Control
- Simple on/off switches that control routing to specific cells (Region/AZ)
- Used to shift traffic during planned failovers or emergency recovery
- Integrates with Route 53 health checks
- **Safety rules** prevent accidentally routing traffic away from all cells
- **Cluster** of 5 regional endpoints for high availability of the control plane

#### Routing Control Health Checks
- Health checks controlled by routing control states (on/off)
- Associated with Route 53 records (typically failover routing)
- When you flip a routing control to "off," the associated health check becomes unhealthy, and Route 53 routes traffic away

### Use Cases
- Controlled failover between Regions
- Planned maintenance (gracefully shift traffic before maintenance)
- Recovery from regional outages
- Preventing accidental failover with safety rules

---

## Common Exam Scenarios

### Scenario 1: Zone Apex to Load Balancer

**Question:** You need to point `example.com` (zone apex) to an Application Load Balancer.

**Answer:** Create an **ALIAS record** of type A pointing to the ALB. You cannot use CNAME for zone apex.

---

### Scenario 2: Active-Passive Disaster Recovery

**Question:** Primary application is in us-east-1, DR in eu-west-1. How to configure DNS?

**Answer:** Use **Failover routing policy**:
- Primary record → us-east-1 ALB with a health check
- Secondary record → eu-west-1 ALB
- When the primary fails health checks, traffic automatically routes to secondary

---

### Scenario 3: Global Application with Best Performance

**Question:** A global application is deployed in 4 Regions. Route users to the fastest Region.

**Answer:** Use **Latency-based routing policy**:
- Create records for each Region
- Route 53 routes users to the Region with the lowest network latency
- Add health checks so unhealthy Regions are automatically excluded

---

### Scenario 4: Content Restriction by Country

**Question:** Due to licensing, video content must only be served to users in the US, UK, and Germany.

**Answer:** Use **Geolocation routing policy**:
- Create records for US, UK, and Germany pointing to the content servers
- **Do NOT create a default record** — users from other countries will get no response (NXDOMAIN)
- For a better user experience, create a default record pointing to a "not available in your region" page

---

### Scenario 5: A/B Testing with 90/10 Split

**Question:** Test a new application version by sending 10% of traffic to it.

**Answer:** Use **Weighted routing policy**:
- Record 1: Old version, weight 90
- Record 2: New version, weight 10
- Add health checks to both records

---

### Scenario 6: Health Checking a Private Resource

**Question:** An RDS instance in a private subnet needs to be health-checked for DNS failover.

**Answer:** Route 53 health checkers cannot reach private resources. Instead:
1. Create a **CloudWatch alarm** based on an RDS metric (e.g., `DatabaseConnections`)
2. Create a Route 53 health check based on the **CloudWatch alarm**
3. Use this health check with a Failover routing policy

---

### Scenario 7: Migrate DNS to Route 53 from Another Provider

**Question:** Migrate DNS hosting to Route 53 while the domain stays registered with the current registrar.

**Answer:**
1. Create a public hosted zone in Route 53
2. Recreate all DNS records from the current provider
3. Note the 4 NS records from Route 53
4. Update the NS records at the current registrar to point to Route 53's name servers
5. Lower the TTL on NS records before migration to speed up propagation
6. Wait for TTL to expire, then verify

---

### Scenario 8: Gradually Shift Traffic Between Regions

**Question:** Shift traffic from us-east-1 to eu-west-1 gradually for a migration.

**Answer:** Use **Geoproximity routing** with Traffic Flow:
- Start with bias: +50 for us-east-1, -50 for eu-west-1
- Gradually reduce us-east-1 bias and increase eu-west-1 bias
- Alternatively, use Weighted routing: start at 100/0 and shift to 0/100

---

### Scenario 9: Internal and External DNS for Same Domain

**Question:** Internal users should access `app.example.com` via private IP; external users via public IP.

**Answer:** **Split-view DNS**:
- Public hosted zone: `app.example.com → 52.x.x.x` (public ALB)
- Private hosted zone (associated with VPC): `app.example.com → 10.0.1.50` (private IP)

---

### Scenario 10: Hybrid DNS Resolution

**Question:** On-premises servers need to resolve AWS private hosted zone records, and AWS instances need to resolve on-premises AD domains.

**Answer:** Use **Route 53 Resolver**:
- **Inbound endpoints:** On-premises DNS forwards `*.aws.example.com` queries to these
- **Outbound endpoints:** Forwarding rules forward `*.corp.example.com` queries to on-premises DNS
- Both communicate over VPN or Direct Connect

---

## Summary

Key Route 53 concepts for the SAA-C03 exam:

1. **ALIAS vs CNAME** — ALIAS for zone apex, free for AWS targets; CNAME cannot be used for zone apex
2. **Routing policies** — know when to use each; latency ≠ geolocation ≠ geoproximity
3. **Health checks** — endpoint, calculated, CloudWatch alarm-based (for private resources)
4. **Failover routing** — primary must have a health check
5. **Geolocation** — based on user location, needs default record
6. **Geoproximity** — location + bias, requires Traffic Flow
7. **Private hosted zones** — for VPC-internal DNS resolution
8. **Resolver** — inbound/outbound endpoints for hybrid DNS
9. **Split-view DNS** — same domain, different answers for internal vs external
10. **100% availability SLA** — Route 53 is the only AWS service with this guarantee
