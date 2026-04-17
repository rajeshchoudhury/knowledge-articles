# AWS Limits & Quotas Cheat Sheet — SAP-C02

> Key service limits frequently tested on the exam. Limits marked **(soft)** can be increased via AWS Support. Limits marked **(hard)** cannot be changed.

---

## Table of Contents

1. [VPC & Networking](#1-vpc--networking)
2. [EC2 & Compute](#2-ec2--compute)
3. [S3](#3-s3)
4. [IAM](#4-iam)
5. [Lambda](#5-lambda)
6. [DynamoDB](#6-dynamodb)
7. [SQS](#7-sqs)
8. [SNS](#8-sns)
9. [API Gateway](#9-api-gateway)
10. [Organizations](#10-organizations)
11. [Route 53](#11-route-53)
12. [CloudFormation](#12-cloudformation)
13. [EBS](#13-ebs)
14. [EFS](#14-efs)
15. [RDS & Aurora](#15-rds--aurora)
16. [ElastiCache](#16-elasticache)
17. [Kinesis](#17-kinesis)
18. [CloudFront](#18-cloudfront)
19. [Direct Connect](#19-direct-connect)
20. [Transit Gateway](#20-transit-gateway)
21. [Step Functions](#21-step-functions)
22. [ECS & EKS](#22-ecs--eks)
23. [KMS](#23-kms)
24. [CloudTrail](#24-cloudtrail)
25. [CloudWatch](#25-cloudwatch)
26. [Elastic Load Balancing](#26-elastic-load-balancing)
27. [Auto Scaling](#27-auto-scaling)
28. [Redshift](#28-redshift)
29. [EventBridge](#29-eventbridge)
30. [Cognito](#30-cognito)
31. [Systems Manager](#31-systems-manager)
32. [AWS Backup](#32-aws-backup)
33. [Secrets Manager & Parameter Store](#33-secrets-manager--parameter-store)
34. [Config](#34-config)

---

## 1. VPC & Networking

| Resource | Default Limit | Hard/Soft |
|----------|--------------|-----------|
| VPCs per region | 5 | Soft |
| Subnets per VPC | 200 | Soft |
| IPv4 CIDR blocks per VPC | 5 | Soft (max 50) |
| IPv6 CIDR blocks per VPC | 5 | Soft |
| Internet Gateways per region | 5 (1 per VPC) | Soft |
| Egress-Only IGWs per VPC | 5 | Soft |
| NAT Gateways per AZ | 5 | Soft |
| Elastic IPs per region | 5 | Soft |
| Route tables per VPC | 200 | Soft |
| Routes per route table | 50 (static) + 100 (propagated) | Soft |
| Security Groups per VPC | 2,500 | Soft |
| Inbound/outbound rules per SG | 60 each (total 120) | Soft |
| Security Groups per ENI | 5 | Soft (max 16) |
| NACLs per VPC | 200 | Soft |
| Rules per NACL | 20 (each direction) | Soft |
| Network interfaces per instance | Varies by instance type | Hard |
| VPC Peering connections per VPC | 50 | Soft (max 125+) |
| VPC Endpoints (Gateway) per VPC | 20 | Soft |
| VPC Endpoints (Interface) per VPC | 50 | Soft |
| Flow Logs per resource | No limit | — |
| Active VPC peering connections per region | 50 | Soft (max 125) |

### Key VPC Exam Points

- Max SG rules effective per ENI = 5 SGs × 60 rules = **300 rules evaluated**
- Can increase SGs per ENI to 16, but total SG rules × SGs per ENI cannot exceed **1,000**
- Route table: static routes take priority over propagated routes for the same CIDR
- /16 is the largest VPC CIDR, /28 is the smallest
- 5 IP addresses reserved per subnet

---

## 2. EC2 & Compute

| Resource | Default Limit | Hard/Soft |
|----------|--------------|-----------|
| Running On-Demand instances | Varies by instance type (vCPU-based) | Soft |
| Spot instance requests per region | Varies (vCPU-based) | Soft |
| Reserved Instances | 20 per AZ per month | Soft |
| EBS volumes per instance | 28 (Nitro: 128) | Hard |
| EBS volume max | gp2/gp3/io1/io2: 16 TiB, io2 BE: 64 TiB | Hard |
| Elastic IPs per region | 5 | Soft |
| AMIs per region | 50,000 | Soft |
| Key pairs per region | 5,000 | Soft |
| Placement groups per region | 500 | Soft |
| Instances per Spread placement group | 7 per AZ | Hard |
| Instances per Cluster placement group | No hard limit | Soft |
| Instance Store volumes | Instance-type dependent | Hard |

### EC2 Instance Metadata

| Endpoint | Purpose |
|----------|---------|
| `169.254.169.254/latest/meta-data/` | Instance metadata (IMDSv1/v2) |
| `169.254.169.254/latest/user-data/` | User data script |
| `169.254.169.254/latest/dynamic/` | Dynamic data |

- **IMDSv2:** Requires session token (PUT request first), hop limit configurable
- **Require IMDSv2:** Best practice — prevent SSRF attacks

---

## 3. S3

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Max object size | 5 TB | Hard |
| Max single PUT upload | 5 GB | Hard |
| Multipart upload: min part size | 5 MB (except last part) | Hard |
| Multipart upload: max parts | 10,000 | Hard |
| Multipart upload: max object | 5 TB (5 MB × 10,000 parts) | Hard |
| Buckets per account | 100 | Soft (max 1,000) |
| Objects per bucket | Unlimited | — |
| Request rate: GET per prefix | 5,500/sec | Soft |
| Request rate: PUT/POST/DELETE per prefix | 3,500/sec | Soft |
| Number of prefixes | Unlimited | — |
| Object key length | 1,024 bytes (UTF-8) | Hard |
| Object metadata | 2 KB | Hard |
| Tags per object | 10 | Hard |
| Lifecycle rules per bucket | 1,000 | Hard |
| Bucket policy size | 20 KB | Hard |
| S3 Access Points per bucket | 10,000 | Soft |
| S3 Access Points per region per account | 10,000 | Soft |
| Event notification configurations per bucket | 100 | Hard |
| S3 Inventory configurations per bucket | 1,000 | Hard |
| Replication rules per bucket | 1,000 | Hard |

### S3 Performance

| Metric | Value |
|--------|-------|
| GET requests per prefix | 5,500/sec |
| PUT/COPY/POST/DELETE per prefix | 3,500/sec |
| S3 Transfer Acceleration | 100s of Mbps improvement |
| S3 Batch Operations | Billions of objects |
| S3 Select | Up to 400% faster for filtered queries |

---

## 4. IAM

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| IAM users per account | 5,000 | Hard |
| Groups per account | 300 | Soft |
| Groups per user | 10 | Hard |
| Roles per account | 1,000 | Soft (max 5,000) |
| Instance profiles per account | 1,000 | Soft |
| Managed policies per account | 1,500 | Soft |
| Inline policies per user/role/group | 10 (≤2,048 chars each) | Soft |
| Managed policies per user | 10 | Soft (max 20) |
| Managed policies per role | 10 | Soft (max 20) |
| Managed policies per group | 10 | Soft (max 20) |
| Managed policy size | 6,144 characters (JSON) | Hard |
| Inline policy size | 2,048 characters (per policy) | Hard |
| Trust policy size | 2,048 characters | Hard |
| Access keys per user | 2 | Hard |
| MFA devices per user | 8 | Hard |
| SAML providers per account | 100 | Hard |
| OIDC providers per account | 100 | Soft |
| Versions per managed policy | 5 | Hard |
| Tags per IAM resource | 50 | Hard |
| Role session duration | 1 hour – 12 hours | Configurable |

### IAM Policy Limits — Key Exam Points

- **6,144 characters** max for managed policy = plan for large policies with wildcards
- **2,048 characters** max for inline policy and trust policy = keep these concise
- If you need more than 10 managed policies on a role → use inline policies or consolidate
- Permission boundary: 1 per user/role

---

## 5. Lambda

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Concurrent executions per region | 1,000 | Soft (can be raised to 10,000+) |
| Reserved concurrency per function | Deducted from account total | — |
| Provisioned concurrency | Based on account concurrency | — |
| Function memory | 128 MB – 10,240 MB (10 GB) | Hard |
| Function timeout | 15 minutes (900 sec) | Hard |
| Deployment package (zip) | 50 MB (compressed), 250 MB (uncompressed) | Hard |
| Container image size | 10 GB | Hard |
| Ephemeral storage (/tmp) | 512 MB – 10,240 MB (10 GB) | Hard |
| Environment variables | 4 KB total | Hard |
| Layers | 5 per function | Hard |
| Layer size (unzipped) | 250 MB (total with function) | Hard |
| Function resource policy | 20 KB | Hard |
| Synchronous payload | 6 MB | Hard |
| Asynchronous payload | 256 KB | Hard |
| SQS batch size (event source) | 10 (Standard), 10 (FIFO) | Hard |
| Kinesis batch size (event source) | 10,000 records | Hard |
| DynamoDB Streams batch size | 10,000 records | Hard |
| Burst concurrency | 500–3,000 (region dependent) | Hard |
| Lambda@Edge — viewer events timeout | 5 seconds | Hard |
| Lambda@Edge — origin events timeout | 30 seconds | Hard |
| Lambda@Edge — viewer memory | 128 MB | Hard |
| Lambda@Edge — origin memory | 128 MB – 10,240 MB | Hard |

### Lambda Key Exam Points

- **15-minute timeout** is frequently tested — if task takes longer, use Step Functions, ECS, or Batch
- **6 MB sync payload** — if larger, use S3 pre-signed URL pattern
- **1,000 default concurrency** — plan for throttling, set reserved concurrency for critical functions
- **No VPC by default** — attaching to VPC adds ENI creation overhead (but improved with Hyperplane)
- **/tmp is ephemeral** — use S3 or EFS for persistent storage

---

## 6. DynamoDB

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Max item size | 400 KB | Hard |
| Max partition key length | 2,048 bytes | Hard |
| Max sort key length | 1,024 bytes | Hard |
| Local Secondary Indexes per table | 5 | Hard |
| Global Secondary Indexes per table | 20 | Soft |
| Projected attributes per GSI/LSI | 100 | Hard |
| Max item collection size (with LSI) | 10 GB per partition key value | Hard |
| Provisioned RCU/WCU per table | 40,000 | Soft |
| Provisioned RCU/WCU per account per region | 80,000 | Soft |
| On-demand RRU/WRU per table | 40,000 | Soft |
| Transaction items per request | 100 items (or 4 MB) | Hard |
| BatchGetItem | 100 items, 16 MB | Hard |
| BatchWriteItem | 25 items, 16 MB | Hard |
| Query/Scan result | 1 MB per call (paginate for more) | Hard |
| Attribute nesting depth | 32 levels | Hard |
| Tables per account per region | 2,500 | Soft |
| Global table replicas | 6 regions (per table) | Soft |
| Number of DynamoDB Streams | 1 per table | Hard |
| Backup (PITR) retention | 35 days | Hard |

### DynamoDB Key Exam Points

- **400 KB item size** — if larger, store in S3 and keep S3 URI in DynamoDB
- **10 GB per partition key** with LSI — design partition keys carefully
- **1 MB per query/scan** — use pagination (LastEvaluatedKey)
- **5 LSIs max, created at table creation** — plan GSIs for flexibility
- Provisioned capacity: 1 RCU = 4 KB strongly consistent read, 1 WCU = 1 KB write

---

## 7. SQS

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Message size | 256 KB | Hard |
| Extended client (with S3) | 2 GB | Hard |
| Message retention | 1 min – 14 days (default 4 days) | Configurable |
| Visibility timeout | 0 sec – 12 hours (default 30 sec) | Configurable |
| Long polling wait | 1 – 20 seconds | Configurable |
| Batch size (send/receive/delete) | 10 messages | Hard |
| In-flight messages (Standard) | 120,000 | Hard |
| In-flight messages (FIFO) | 20,000 | Hard |
| Queues per account | Unlimited | — |
| FIFO throughput (without batching) | 300 messages/sec | Hard |
| FIFO throughput (with batching) | 3,000 messages/sec | Hard |
| FIFO high throughput | Up to 70,000 messages/sec (per queue) | Soft |
| Message groups per FIFO queue | Unlimited | — |
| Delay queue | 0 – 15 minutes | Configurable |
| Dead-letter queue redrive | Source queue → DLQ, or DLQ → source queue (redrive) | — |

### SQS Key Exam Points

- **256 KB message limit** — use S3 Extended Client Library for larger payloads
- **Visibility timeout** must be > processing time to prevent duplicate processing
- **FIFO queues** sacrifice throughput for ordering — 3,000 msg/s with batching
- **120,000 in-flight messages** — if exceeded, receive returns error (OverLimit)
- DLQ **maxReceiveCount** triggers move to DLQ after N failed processing attempts

---

## 8. SNS

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Message size | 256 KB | Hard |
| Topics per account per region | 100,000 | Soft |
| Subscriptions per topic | 12,500,000 | Soft |
| FIFO topic throughput | 300 messages/sec (3,000 with batching) | Hard |
| Filter policies per topic | 200 | Soft |
| Filter policy size | 150 KB | Hard |
| SMS messages per second | 1 (US), varies by country | Soft |
| Push notifications per second | Varies by platform | Soft |
| Message attributes | 10 per message | Hard |

---

## 9. API Gateway

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Throttle (default) — REST | 10,000 requests/sec per region | Soft |
| Burst — REST | 5,000 concurrent requests | Soft |
| Throttle — HTTP API | 10,000 requests/sec per region | Soft |
| Payload size — REST | 10 MB | Hard |
| Payload size — HTTP API | 10 MB | Hard |
| Payload size — WebSocket | 128 KB (frame), 32 KB (message) | Hard |
| Integration timeout — REST | 50 ms – 29 seconds | Hard |
| Integration timeout — HTTP API | 50 ms – 30 seconds | Hard |
| WebSocket idle timeout | 10 minutes | Hard |
| WebSocket connect duration | 2 hours | Hard |
| REST APIs per region | 600 | Soft |
| HTTP APIs per region | 600 | Soft |
| Stages per API | 10 | Soft |
| API keys per account per region | 10,000 | Soft |
| Usage plans per account per region | 300 | Soft |
| Cache size | 0.5 GB – 237 GB | Configurable |
| Edge-optimized custom domains | 10 per account | Soft |
| Regional custom domains | 10 per account | Soft |

### API Gateway Key Exam Points

- **29-second timeout** for REST API → longer operations should use async (Step Functions, SQS)
- **10 MB payload** — larger files should use pre-signed S3 URLs
- **10,000 RPS throttle** — configurable per stage, per method, per usage plan
- **REST vs HTTP API:** HTTP API is cheaper, faster, but fewer features; REST for full feature set

---

## 10. Organizations

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Accounts per organization | 10 (default) | Soft (commonly raised to 100s–1000s) |
| Organizational Units (OUs) | 1,000 | Hard |
| OU nesting depth | 5 levels (under root) | Hard |
| SCPs per account/OU | 5 | Soft |
| SCP document size | 5,120 characters (JSON) | Hard |
| Tag policies per account/OU | 5 | Soft |
| Delegated administrators per service | 3 | Hard |
| Invitations per day | 20 | Hard |

### Organizations Key Exam Points

- **5,120 character SCP limit** — plan SCPs carefully, use deny lists (more concise)
- **5 SCPs per target** — consolidate related restrictions
- **OU nesting: 5 levels** — keep hierarchy manageable
- **10 accounts default** — always request increase early in migration planning

---

## 11. Route 53

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Hosted zones per account | 500 | Soft |
| Records per hosted zone | 10,000 | Soft |
| Domains per account (registration) | 20 | Soft |
| Health checks per account | 200 | Soft |
| Reusable delegation sets | 100 | Soft |
| Route 53 Resolver rules per region | 1,000 | Soft |
| Route 53 Resolver endpoints per region | 4 | Soft |
| IP addresses per Resolver endpoint | 6 | Soft (min 2 for HA) |
| DNSSEC-signed hosted zones | 2,000 | Soft |
| Routing policies: Weighted records | 100 per name | Hard |
| Routing policies: Latency records | 1 per region per name | Hard |
| Routing policies: Geolocation records | 1 per location per name | Hard |

---

## 12. CloudFormation

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Resources per stack | 500 | Hard |
| Stacks per account per region | 2,000 | Soft |
| Nested stack depth | Unlimited (practical limit: stack resource count) | — |
| Template body size (inline) | 51,200 bytes (50 KB) | Hard |
| Template body size (S3) | 1 MB | Hard |
| Parameters per template | 200 | Hard |
| Outputs per template | 200 | Hard |
| Mappings per template | 200 | Hard |
| Conditions per template | 200 | Hard |
| StackSets per account per region | 100 | Soft |
| Stack instances per StackSet | 2,000 | Soft |
| Macros per account per region | 100 | Soft |
| Concurrent StackSet operations | 3,500 per StackSet | Soft |

### CloudFormation Key Exam Points

- **500 resources per stack** — use nested stacks or StackSets for larger deployments
- **50 KB inline template / 1 MB S3** — package large templates to S3
- **StackSets** for multi-account/multi-region deployment
- **DeletionPolicy: Retain** prevents resource deletion when stack is deleted
- **UpdateReplacePolicy:** Controls behavior during replacement updates

---

## 13. EBS

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Volumes per region | 100,000 | Soft |
| Snapshots per region | 100,000 | Soft |
| Volumes per instance | 28 (Nitro: 128) | Hard |
| gp2/gp3 max IOPS | 16,000 | Hard |
| io1/io2 max IOPS | 64,000 | Hard |
| io2 Block Express max IOPS | 256,000 | Hard |
| gp3 max throughput | 1,000 MiB/s | Hard |
| io2 Block Express max throughput | 4,000 MiB/s | Hard |
| st1 max throughput | 500 MiB/s | Hard |
| sc1 max throughput | 250 MiB/s | Hard |
| Volume max size | 16 TiB (io2 BE: 64 TiB) | Hard |
| io2 multi-attach instances | 16 | Hard |
| Fast Snapshot Restore (FSR) per AZ | 10 volume creates per snapshot | Hard |
| Snapshot archive restore time | 24–72 hours | — |

---

## 14. EFS

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| File systems per account per region | 1,000 | Soft |
| Mount targets per file system | 1 per AZ (up to 400 per VPC) | Soft |
| Access points per file system | 120 | Soft |
| Max file size | 52 TiB | Hard |
| Max throughput (Elastic mode) | 10+ GiB/s (read), 3+ GiB/s (write) | Soft |
| Max throughput (Bursting) | Scales with storage (50 MiB/s per TiB) | — |
| Max throughput (Provisioned) | 3+ GiB/s (read), 1+ GiB/s (write) | Soft |
| Path length | 4,096 bytes | Hard |
| Hard links per file | 177 | Hard |
| Total file system size | Petabytes | Soft |

---

## 15. RDS & Aurora

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| DB instances per region | 40 | Soft |
| Read replicas per DB instance | 15 (MySQL, PostgreSQL, MariaDB), 5 (Oracle, SQL Server) | Hard |
| Max storage per RDS instance | 64 TiB | Hard |
| Max storage per Aurora cluster | 128 TiB | Hard |
| Aurora read replicas per cluster | 15 | Hard |
| Aurora Serverless v2 min ACU | 0.5 | Hard |
| Aurora Serverless v2 max ACU | 128 | Hard |
| Aurora Global Database secondary regions | 5 | Hard |
| Aurora Global Database read replicas per secondary | 16 | Hard |
| Aurora custom endpoints per cluster | 5 | Soft |
| Manual snapshots per account per region | 100 | Soft (can increase) |
| DB subnet groups per region | 50 | Soft |
| Subnets per DB subnet group | 20 | Soft |
| Security groups per DB instance | 5 | Soft |
| Event subscriptions per account per region | 20 | Soft |
| Reserved DB instances per region | 40 | Soft |
| RDS Proxy per account per region | 20 | Soft |
| Parameter groups per account per region | 50 | Soft |
| Option groups per account per region | 20 | Soft |
| Max backup retention | 35 days | Hard |
| Aurora backtrack window | 72 hours | Hard |

---

## 16. ElastiCache

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Nodes per region | 300 | Soft |
| Clusters per region | 50 (non-cluster mode) | Soft |
| Nodes per cluster (Redis, cluster mode enabled) | 500 (250 primary + 250 replicas, or variations) | Soft |
| Shards per cluster (cluster mode enabled) | 500 | Soft |
| Replicas per shard | 5 | Hard |
| Parameter groups per region | 150 | Soft |
| Subnet groups per region | 150 | Soft |
| Subnets per subnet group | 20 | Soft |
| Redis Global Datastore secondary regions | 2 | Hard |
| Memcached nodes per cluster | 40 | Soft |

---

## 17. Kinesis

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| **Data Streams** | | |
| Shards per account per region | 200 (on-demand: 200, provisioned: varies) | Soft |
| Data records per shard (write) | 1,000 records/sec | Hard |
| Write throughput per shard | 1 MB/sec | Hard |
| Read throughput per shard (standard) | 2 MB/sec | Hard |
| Read throughput per shard (enhanced fan-out) | 2 MB/sec per consumer | Hard |
| Consumers per stream (enhanced fan-out) | 20 | Soft |
| Record size | 1 MB | Hard |
| Retention period | 24 hours (default), up to 365 days | Configurable |
| Streams per account per region | 500 | Soft |
| **Data Firehose** | | |
| Delivery streams per region | 50 | Soft |
| Buffer size | 1–128 MB | Configurable |
| Buffer interval | 0–900 seconds | Configurable |
| Record size | 1 MB | Hard |

---

## 18. CloudFront

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Distributions per account | 200 | Soft |
| Alternate domain names (CNAMEs) per distribution | 100 | Soft |
| Origins per distribution | 25 | Soft |
| Origin groups per distribution | 10 | Soft |
| Cache behaviors per distribution | 25 | Soft |
| Lambda@Edge functions per distribution | 100 | Soft |
| CloudFront Functions per distribution | 25 | Soft |
| SSL certificates per account | 100 (ACM in us-east-1) | Soft |
| Requests per second per distribution | 250,000 | Soft |
| File size (cacheable) | 30 GB | Hard |
| Signed URL policy statement | 2,048 bytes | Hard |
| Custom headers per origin | 10 | Hard |
| Header size total | 20 KB | Hard |

---

## 19. Direct Connect

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Connections per region | 10 | Soft |
| Private VIFs per connection (dedicated 1G+) | 50 | Hard |
| Public VIFs per connection | 1 | Hard |
| Transit VIFs per connection | 1 | Hard |
| Private VIFs per hosted connection (<1G) | 1 | Hard |
| DX Gateways per account | 200 | Soft |
| VGWs per DX Gateway | 10 | Hard |
| Transit Gateways per DX Gateway | 3 | Hard |
| DX Gateway associations per Transit Gateway | 3 | Hard |
| LAG connections | 4 per LAG | Hard |
| BGP routes advertised per VIF (to AWS) | 100 | Hard |
| BGP routes received per VIF (from AWS) | 1,000 (private), varies (public/transit) | Hard |

---

## 20. Transit Gateway

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Transit Gateways per region | 5 | Soft |
| Attachments per TGW | 5,000 | Soft |
| Route tables per TGW | 20 | Soft |
| Static routes per TGW route table | 10,000 | Soft |
| Dynamic (propagated) routes per TGW route table | 5,000 | Soft |
| Peered TGWs | 50 | Soft |
| TGW multicast groups | 10,000 | Soft |
| Bandwidth per VPC attachment per AZ | 50 Gbps | Hard |
| Bandwidth per VPN tunnel | 1.25 Gbps | Hard |
| Bandwidth per Direct Connect (transit VIF) | Connection bandwidth | Hard |
| VPN connections per TGW | 5,000 (shared with attachments) | Soft |

---

## 21. Step Functions

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| **Standard Workflows** | | |
| Max execution duration | 1 year | Hard |
| Max execution history (events) | 25,000 | Hard |
| Max input/output size per state | 256 KB | Hard |
| State transitions per second per account | 4,000 (us-east-1), lower in other regions | Soft |
| Open executions per state machine | 1,000,000 | Soft |
| **Express Workflows** | | |
| Max execution duration | 5 minutes | Hard |
| Max execution start rate | 100,000 per second | Soft |
| Max input/output size per state | 256 KB | Hard |

---

## 22. ECS & EKS

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| **ECS** | | |
| Clusters per region | 10,000 | Soft |
| Services per cluster | 5,000 | Soft |
| Tasks per service | 5,000 | Soft |
| Container instances per cluster | 5,000 | Soft |
| Containers per task definition | 10 | Hard |
| Task definition revisions per family | 1,000,000 | Hard |
| Fargate tasks per region | 5,000 (default) | Soft |
| **EKS** | | |
| Clusters per region | 100 | Soft |
| Managed node groups per cluster | 30 | Soft |
| Nodes per managed node group | 450 | Soft |
| Pods per node (default) | 110 (configurable) | Soft |
| Fargate profiles per cluster | 10 | Soft |
| Selectors per Fargate profile | 5 | Hard |
| Label pairs per selector | 5 | Hard |
| Services per cluster | 5,000 | Hard |

---

## 23. KMS

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Customer managed keys per account per region | 100,000 | Soft |
| Aliases per account per region | 50,000 | Soft |
| Key policy size | 32 KB | Hard |
| Grants per key | 50,000 | Hard |
| Cryptographic operations (symmetric) per second | 5,500–30,000 (varies by region) | Soft |
| Cryptographic operations (RSA) per second | 500 | Soft |
| Cryptographic operations (ECC) per second | 300 | Soft |
| GenerateDataKey per second | Same as symmetric ops | Soft |
| Encrypt/Decrypt payload | 4 KB (direct) | Hard |

### KMS Key Exam Points

- **4 KB direct encrypt limit** — use envelope encryption (GenerateDataKey) for larger data
- **5,500 req/s base** — implement caching (data key caching with AWS Encryption SDK) for high-volume
- Grant propagation takes ~5 minutes — use grant tokens for immediate access

---

## 24. CloudTrail

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Trails per region | 5 | Soft |
| Event selectors per trail | 5 (advanced: 500) | Hard |
| Data event resources per event selector | 250 | Hard |
| Insights events per trail | 2 (API call rate, error rate) | Hard |
| CloudTrail Lake event data stores | 5 per region | Soft |
| CloudTrail Lake retention | Up to 7 years (2,557 days) | Configurable |
| Organization trails per organization | 5 | Soft |

---

## 25. CloudWatch

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Alarms per account per region | 5,000 | Soft |
| Metrics per PutMetricData call | 1,000 | Hard |
| Dimensions per metric | 30 | Hard |
| Dashboard widgets per dashboard | 500 | Hard |
| Dashboards per account per region | 5,000 | Soft |
| Log groups per account per region | 1,000,000 | Soft |
| Metric filters per log group | 100 | Hard |
| Subscription filters per log group | 2 | Hard |
| Retention period | 1 day – never expire | Configurable |
| Custom metrics (standard resolution) | 1-minute intervals | — |
| Custom metrics (high resolution) | 1-second intervals | — |
| Logs Insights: max results | 10,000 | Hard |
| Logs Insights: max query time | 60 minutes | Hard |
| Composite alarms per account per region | 5,000 | Soft |

---

## 26. Elastic Load Balancing

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| ALBs per region | 50 | Soft |
| NLBs per region | 50 | Soft |
| GWLBs per region | 50 | Soft |
| Target groups per region | 3,000 | Soft |
| Targets per target group | 1,000 (IP), 1,000 (instance), 1 (Lambda) | Soft |
| Listeners per ALB | 50 | Soft |
| Listeners per NLB | 50 | Hard |
| Rules per ALB listener | 100 + default rule | Soft |
| Certificates per ALB (SNI) | 25 + default | Soft |
| Targets per ALB (cross-zone) | 1,000 per AZ | Hard |
| NLB static IPs | 1 per AZ (or EIP) | — |

---

## 27. Auto Scaling

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Auto Scaling Groups per region | 200 | Soft |
| Launch configurations per region | 200 | Soft |
| Launch templates per region | 5,000 | Soft |
| Scaling policies per ASG | 50 | Soft |
| Scheduled actions per ASG | 125 | Soft |
| Lifecycle hooks per ASG | 50 | Soft |
| SNS topics per ASG | 10 | Soft |
| Step adjustments per policy | 20 | Hard |
| Max instances per ASG | 1,000+ (limited by account EC2 limits) | Soft |
| Warm pool max | 1,000 instances | Soft |

---

## 28. Redshift

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Nodes per cluster | 128 (RA3/DC2) | Hard |
| Reserved nodes per account | 200 | Soft |
| Clusters per region | 40+ | Soft |
| Snapshots per cluster | 20 (automated), unlimited (manual) | Soft |
| Tables per cluster | 100,000 (large nodes) | Hard |
| Databases per cluster | 60 | Hard |
| Schemas per database | 9,900 | Hard |
| Concurrent connections | 500 | Hard |
| Concurrency Scaling clusters | 10 | Soft |
| Spectrum: max file size | No limit | — |
| Spectrum: concurrent queries | Cluster-dependent | Soft |

---

## 29. EventBridge

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Rules per event bus | 300 | Soft |
| Targets per rule | 5 | Hard |
| Event buses per account per region | 100 | Soft |
| PutEvents entries per request | 10 | Hard |
| PutEvents max entry size | 256 KB | Hard |
| PutEvents invocations per second | 400 (default, up to 10,000+) | Soft |
| Scheduled rules per account per region | 300 | Soft |
| API destinations per account per region | 3,000 | Soft |
| Connections per account per region | 3,000 | Soft |
| Event archive retention | Up to indefinite | Configurable |
| Pipe targets | 1 | Hard |
| Pipes per account per region | 1,000 | Soft |

---

## 30. Cognito

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| User Pools per account per region | 1,000 | Soft |
| Users per User Pool | 40,000,000 | Soft |
| App clients per User Pool | 1,000 | Soft |
| Identity Pools per account per region | 60 | Soft |
| Groups per User Pool | 300 | Soft |
| Custom attributes per User Pool | 50 | Hard |
| Lambda triggers per User Pool | 1 per trigger type | Hard |
| Resource servers per User Pool | 25 | Soft |

---

## 31. Systems Manager

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Parameters (Standard) per account per region | 10,000 | Soft |
| Parameters (Advanced) per account per region | 100,000 | Soft |
| Parameter value size (Standard) | 4 KB | Hard |
| Parameter value size (Advanced) | 8 KB | Hard |
| Parameter policies per parameter | 10 | Hard |
| Concurrent Run Commands per account | 20 | Soft |
| Run Command targets per invocation | 50 | Hard |
| Maintenance windows per account per region | 50 | Soft |
| State Manager associations per account per region | 500 | Soft |
| Session Manager concurrent sessions | 50 | Soft |
| Automation executions per second | 25 | Soft |

---

## 32. AWS Backup

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Backup vaults per account per region | 100 | Soft |
| Backup plans per account per region | 100 | Soft |
| Recovery points per backup vault | 1,000,000 | Hard |
| Frameworks per account per region | 10 | Soft |
| Reports per account per region | 20 | Soft |
| Concurrent backup jobs | 500 | Soft |
| Concurrent copy jobs | 500 | Soft |
| Concurrent restore jobs | 500 | Soft |

---

## 33. Secrets Manager & Parameter Store

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| **Secrets Manager** | | |
| Secrets per account per region | 500,000 | Soft |
| Secret value size | 64 KB | Hard |
| Versions per secret | ~100 | Hard |
| Labels per version | 20 | Hard |
| Resource-based policy size | 20 KB | Hard |
| API request rate | 10,000/sec | Soft |
| **Parameter Store** | | |
| Parameters (Standard) per region | 10,000 | Soft |
| Parameters (Advanced) per region | 100,000 | Soft |
| Standard parameter size | 4 KB | Hard |
| Advanced parameter size | 8 KB | Hard |
| Standard throughput | 40 TPS | Hard |
| Higher throughput | 10,000 TPS | Soft (paid) |

---

## 34. Config

| Resource | Limit | Hard/Soft |
|----------|-------|-----------|
| Config rules per account per region | 400 | Soft |
| Organization Config rules | 150 | Soft |
| Conformance packs per account per region | 50 | Soft |
| Organization conformance packs | 50 | Soft |
| Remediation targets per rule | 100 | Hard |
| Config aggregators per account | 50 | Soft |
| Accounts per aggregator | 10,000 | Hard |
| Tags per Config rule | 50 | Hard |
| Configuration recorders per region | 1 | Hard |

---

## Quick Reference — Most Frequently Tested Limits

| Service | Key Limit | Value |
|---------|-----------|-------|
| **Lambda** | Timeout | 15 min |
| **Lambda** | Memory | 10 GB |
| **Lambda** | Sync payload | 6 MB |
| **Lambda** | Deployment package | 50 MB zip / 250 MB unzipped |
| **Lambda** | Concurrency | 1,000 default |
| **API Gateway** | Timeout | 29 sec (REST) |
| **API Gateway** | Payload | 10 MB |
| **SQS** | Message size | 256 KB |
| **SQS** | Retention | 14 days max |
| **SQS FIFO** | Throughput | 3,000 msg/s (batching) |
| **DynamoDB** | Item size | 400 KB |
| **DynamoDB** | LSIs | 5 per table, at creation only |
| **DynamoDB** | GSIs | 20 per table |
| **S3** | Object size | 5 TB |
| **S3** | Single PUT | 5 GB |
| **S3** | GET rate per prefix | 5,500/s |
| **CloudFormation** | Resources per stack | 500 |
| **CloudFormation** | Template size (S3) | 1 MB |
| **VPC** | SGs per ENI | 5 (max 16) |
| **VPC** | Peering per VPC | 50 (soft) / 125 |
| **EBS io2** | Max IOPS | 64,000 (256,000 BE) |
| **KMS** | Direct encrypt size | 4 KB |
| **IAM** | Managed policies per role | 10 |
| **IAM** | Policy document size | 6,144 chars |
| **Step Functions Standard** | Max duration | 1 year |
| **Step Functions Express** | Max duration | 5 min |
| **Kinesis** | Record size | 1 MB |
| **Organizations** | SCP size | 5,120 chars |
| **Organizations** | Default accounts | 10 |
| **Transit Gateway** | Attachments | 5,000 |
| **Transit Gateway** | Bandwidth per VPC per AZ | 50 Gbps |
| **NAT Gateway** | Bandwidth | 100 Gbps |
| **CloudFront** | Cacheable file size | 30 GB |
| **EventBridge** | Targets per rule | 5 |
