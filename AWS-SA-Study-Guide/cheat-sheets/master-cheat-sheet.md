# Master Cheat Sheet — Last Minute Review

## Key Comparison Tables (Condensed)

### ELB Comparison (ALB vs NLB vs GLB vs CLB)

| Feature           | ALB (L7)              | NLB (L4)              | GLB (L3)              | CLB (Legacy)          |
|-------------------|-----------------------|-----------------------|-----------------------|-----------------------|
| **Protocol**      | HTTP/S, gRPC          | TCP, UDP, TLS         | GENEVE (6081)         | HTTP/S, TCP, SSL      |
| **Static IP**     | No                    | Yes (Elastic IP)      | No                    | No                    |
| **Path routing**  | Yes                   | No                    | No                    | No                    |
| **WAF support**   | Yes                   | No                    | No                    | No                    |
| **Best for**      | Web apps, microservices | Ultra-low latency    | 3rd party appliances  | Nothing (deprecated)  |

### Compute Comparison

| Feature           | EC2                | Lambda             | Fargate            | ECS (EC2)          | EKS                |
|-------------------|--------------------|--------------------|--------------------|--------------------|--------------------|
| **Management**    | You manage         | Fully managed      | Serverless compute | You manage EC2     | You manage K8s     |
| **Max runtime**   | Unlimited          | 15 min             | Unlimited          | Unlimited          | Unlimited          |
| **Pricing**       | Per instance-hr    | Per req + duration | Per vCPU+mem/sec   | Per instance-hr    | $0.10/hr + compute |
| **GPU**           | Yes                | No                 | No                 | Yes                | Yes                |
| **Use case**      | Full control       | Event-driven       | Serverless container | Docker (simple)  | Kubernetes         |

### Storage Comparison

| Feature           | S3                 | EBS                | EFS                | FSx Lustre         | FSx Windows        | Instance Store     |
|-------------------|--------------------|--------------------|--------------------|--------------------|--------------------|--------------------| 
| **Type**          | Object             | Block              | File (NFS)         | File (Lustre)      | File (SMB)         | Block (ephemeral)  |
| **Durability**    | 11 nines           | 99.999%            | 11 nines*          | Depends on config  | Depends on config  | None (ephemeral)   |
| **Max size**      | Unlimited          | 64 TB per vol      | Petabytes          | Petabytes          | 64 TB              | Instance dependent |
| **Multi-attach**  | N/A                | io2 only (same AZ) | Yes (multi-AZ)    | Yes                | Yes (Multi-AZ)     | No                 |
| **Access**        | API (HTTP)         | Single EC2 (or multi-attach) | Multi-AZ, multi-EC2 | Multi-AZ    | Multi-AZ           | Local only         |
| **Persistence**   | Yes                | Yes (independent)  | Yes                | Yes                | Yes                | Lost on stop/term  |
| **Use case**      | Data lake, backup  | Boot vol, databases | Shared content    | HPC, ML            | Windows workloads  | Temp data, cache   |

*EFS Standard storage class

### Messaging Comparison

| Feature           | SQS                | SNS                | EventBridge        | Kinesis Data Streams |
|-------------------|--------------------|--------------------|--------------------|----------------------|
| **Model**         | Pull (polling)     | Push (pub/sub)     | Event bus (push)   | Stream (pull)        |
| **Ordering**      | FIFO only          | FIFO only          | No guarantee       | Per-shard ordering   |
| **Retention**     | 1–14 days (def: 4) | No retention       | Archive up to indefinite | 1–365 days (def: 24hr) |
| **Throughput**    | Nearly unlimited   | Millions/sec       | Millions/sec       | 1 MB/s per shard write |
| **Consumers**     | 1 consumer group   | Many subscribers   | Many rules/targets | Multiple consumers   |
| **Replay**        | No                 | No                 | Archive & replay   | Yes (seek by time)   |
| **Dedup**         | FIFO (5 min window)| FIFO               | No built-in        | No built-in          |
| **Max msg size**  | 256 KB             | 256 KB             | 256 KB             | 1 MB per record      |
| **Use case**      | Decouple, buffer   | Fan-out            | Event routing      | Real-time analytics  |

---

## Critical Numbers and Limits

### Lambda
| Limit                  | Value               |
|------------------------|---------------------|
| Timeout                | 15 minutes (900s)   |
| Memory                 | 128 MB – 10 GB      |
| /tmp storage           | 512 MB – 10 GB      |
| Deployment (zip)       | 50 MB / 250 MB      |
| Container image        | 10 GB                |
| Concurrent executions  | 1,000/region (default) |
| Payload (sync/async)   | 6 MB / 256 KB       |

### SQS
| Limit                  | Value               |
|------------------------|---------------------|
| Message retention       | 1–14 days (default: 4) |
| Message size            | 256 KB (up to 2 GB with Extended Client Library) |
| Visibility timeout      | 0s – 12 hours (default: 30s) |
| Long polling timeout    | 1–20 seconds        |
| FIFO throughput         | 300 msg/s (batch: 3,000) or high throughput mode |
| Delay queue             | 0–15 minutes        |
| In-flight (Standard)    | 120,000             |
| In-flight (FIFO)        | 20,000              |

### S3
| Limit                  | Value               |
|------------------------|---------------------|
| Object size (max)      | 5 TB                |
| Single PUT max         | 5 GB                |
| Multipart threshold    | 100 MB recommended  |
| PUT/POST/DELETE        | 3,500 req/s/prefix  |
| GET/HEAD               | 5,500 req/s/prefix  |
| Buckets per account    | 100 (default)       |

### EBS
| Volume  | Max IOPS    | Max Throughput | Notes                    |
|---------|-------------|----------------|--------------------------|
| gp3     | 16,000      | 1,000 MB/s     | Baseline 3,000 IOPS      |
| gp2     | 16,000      | 250 MB/s       | 3 IOPS/GB, burst 3,000   |
| io2 BE  | 256,000     | 4,000 MB/s     | Sub-ms latency            |
| io2/io1 | 64,000      | 1,000 MB/s     | 50 IOPS/GB (io2)          |
| st1     | 500         | 500 MB/s       | Throughput optimized HDD  |
| sc1     | 250         | 250 MB/s       | Cold HDD                  |

### DynamoDB
| Limit                  | Value               |
|------------------------|---------------------|
| Item size (max)        | 400 KB              |
| Partition key length   | 2048 bytes          |
| Sort key length        | 1024 bytes          |
| GSI per table          | 20                  |
| LSI per table          | 5                   |
| Max tables per region  | 2,500 (default)     |
| DAX item cache TTL     | Default 5 min       |

### API Gateway
| Limit                  | Value               |
|------------------------|---------------------|
| Timeout                | 29 seconds          |
| Payload size           | 10 MB               |
| Throttle (default)     | 10,000 req/s, 5,000 burst |
| WebSocket message      | 128 KB              |

### CloudFront
| Limit                  | Value               |
|------------------------|---------------------|
| Max file size           | 30 GB (single file) |
| Origin timeout          | Up to 60 seconds    |
| Edge locations          | 400+ globally       |

### VPC
| Limit                  | Value (Default)     |
|------------------------|---------------------|
| VPCs per region        | 5                   |
| Subnets per VPC        | 200                 |
| IGWs per VPC           | 1                   |
| Route tables per VPC   | 200                 |
| Security groups per ENI | 5                  |
| Rules per SG           | 60 inbound + 60 outbound |
| NACLs per VPC          | 200                 |
| VPC peering per VPC    | 125                 |
| Elastic IPs per region | 5                   |

---

## Service Abbreviation Quick Reference

| Abbreviation | Full Name                                    |
|-------------|----------------------------------------------|
| ALB         | Application Load Balancer                     |
| NLB         | Network Load Balancer                         |
| GLB         | Gateway Load Balancer                         |
| ASG         | Auto Scaling Group                            |
| ACM         | AWS Certificate Manager                       |
| AMI         | Amazon Machine Image                          |
| ARN         | Amazon Resource Name                          |
| AZ          | Availability Zone                             |
| CDN         | Content Delivery Network (CloudFront)         |
| CMK         | Customer Master Key (KMS)                     |
| CRR         | Cross-Region Replication                      |
| DAX         | DynamoDB Accelerator                          |
| DMS         | Database Migration Service                    |
| DX          | Direct Connect                                |
| EBS         | Elastic Block Store                           |
| EC2         | Elastic Compute Cloud                         |
| ECR         | Elastic Container Registry                    |
| ECS         | Elastic Container Service                     |
| EFS         | Elastic File System                           |
| EKS         | Elastic Kubernetes Service                    |
| ENA         | Elastic Network Adapter                       |
| ENI         | Elastic Network Interface                     |
| EFA         | Elastic Fabric Adapter                        |
| GSI         | Global Secondary Index                        |
| HSM         | Hardware Security Module                      |
| IAM         | Identity and Access Management                |
| IGW         | Internet Gateway                              |
| KMS         | Key Management Service                        |
| LSI         | Local Secondary Index                         |
| NACL        | Network Access Control List                   |
| NAT         | Network Address Translation                   |
| OIDC        | OpenID Connect                                |
| OU          | Organizational Unit                           |
| RCU         | Read Capacity Unit                            |
| RPO         | Recovery Point Objective                      |
| RTO         | Recovery Time Objective                       |
| SAML        | Security Assertion Markup Language            |
| SCP         | Service Control Policy                        |
| SRR         | Same-Region Replication                       |
| SSE         | Server-Side Encryption                        |
| STS         | Security Token Service                        |
| TGW         | Transit Gateway                               |
| VIF         | Virtual Interface (Direct Connect)            |
| VPC         | Virtual Private Cloud                         |
| VPN         | Virtual Private Network                       |
| WAF         | Web Application Firewall                      |
| WCU         | Write Capacity Unit                           |

---

## Disaster Recovery Strategies

| Strategy                  | RPO           | RTO            | Cost      | Description                        |
|---------------------------|---------------|----------------|-----------|------------------------------------|
| **Backup & Restore**      | Hours         | 24+ hours      | $         | Backup data, restore when needed   |
| **Pilot Light**           | Minutes       | Tens of min    | $$        | Core components always running     |
| **Warm Standby**          | Seconds       | Minutes        | $$$       | Scaled-down full environment       |
| **Multi-Site Active/Active** | Near zero  | Near zero      | $$$$      | Full production in 2+ regions      |

```
Cost:    Low ◄─────────────────────────────────► High
         Backup    Pilot     Warm       Multi-Site
         Restore   Light     Standby    Active/Active

RTO/RPO: High ◄─────────────────────────────────► Low (Near Zero)
```

---

## Migration Strategies — 7 Rs

| Strategy         | Description                                         | Effort | Example                          |
|------------------|-----------------------------------------------------|--------|----------------------------------|
| **Retire**       | Decommission, no longer needed                      | Low    | Unused applications              |
| **Retain**       | Keep as-is (not moving yet)                         | None   | Complex legacy, revisit later    |
| **Rehost**       | "Lift and shift" — move to cloud as-is              | Low    | VM to EC2                        |
| **Relocate**     | "Hypervisor-level lift and shift"                   | Low    | VMware Cloud on AWS              |
| **Replatform**   | "Lift, tinker, and shift" — minor optimizations     | Medium | MySQL on EC2 → RDS               |
| **Repurchase**   | Move to SaaS                                        | Medium | CRM → Salesforce                 |
| **Refactor**     | Re-architect for cloud-native                       | High   | Monolith → microservices/Lambda  |

**Migration tools:** AWS Migration Hub, Application Discovery Service, Server Migration Service (SMS), Database Migration Service (DMS), Snow Family (data transfer)

---

## Well-Architected Framework — 6 Pillars

| Pillar                     | Focus                                    | Key Services                           |
|----------------------------|------------------------------------------|----------------------------------------|
| **Operational Excellence** | Run & monitor systems, improve processes | CloudFormation, Config, CloudTrail, CloudWatch, Systems Manager |
| **Security**               | Protect data, systems, assets            | IAM, KMS, WAF, Shield, GuardDuty, Macie, CloudTrail |
| **Reliability**            | Recover from failures, meet demand       | Auto Scaling, Multi-AZ, S3, Route 53, CloudFormation |
| **Performance Efficiency** | Use resources efficiently                | Auto Scaling, Lambda, CloudFront, ElastiCache, Global Accelerator |
| **Cost Optimization**      | Avoid unnecessary costs                  | Reserved/Spot/Savings Plans, S3 tiers, Trusted Advisor, Cost Explorer |
| **Sustainability**         | Minimize environmental impact            | Graviton instances, Lambda, Auto Scaling, managed services |

**Memory trick:** **S**ORPCS — Security, Operational Excellence, Reliability, Performance Efficiency, Cost Optimization, Sustainability

---

## Auto Scaling Policy Types

| Policy                | Trigger                    | Speed     | Use Case                          |
|-----------------------|----------------------------|-----------|-----------------------------------|
| **Target Tracking**   | Maintain metric at value   | Moderate  | CPU at 50%, ALB requests/target   |
| **Step Scaling**      | CloudWatch alarm steps     | Fast      | Variable scaling amounts           |
| **Simple Scaling**    | CloudWatch alarm           | Slow      | Legacy, basic                      |
| **Scheduled**         | Cron / one-time schedule   | Proactive | Known traffic patterns             |
| **Predictive**        | ML forecast                | Proactive | Recurring patterns                 |

---

## CloudFormation Key Intrinsic Functions

| Function             | Purpose                                    | Example                            |
|----------------------|--------------------------------------------|------------------------------------|
| `Ref`                | Return value of parameter or resource ID   | `!Ref MyBucket`                    |
| `Fn::GetAtt`        | Get attribute of a resource                | `!GetAtt MyALB.DNSName`           |
| `Fn::Join`          | Join strings with delimiter                | `!Join ["-", [a, b, c]]` → "a-b-c"|
| `Fn::Sub`           | Substitute variables in string             | `!Sub "arn:aws:s3:::${Bucket}"`   |
| `Fn::Select`        | Select item from list by index             | `!Select [0, [a, b, c]]` → "a"   |
| `Fn::Split`         | Split string into list                     | `!Split [",", "a,b,c"]`           |
| `Fn::ImportValue`   | Import exported value from another stack   | Cross-stack references             |
| `Fn::FindInMap`     | Lookup value in Mappings section            | Region-to-AMI mapping             |
| `Fn::If`            | Conditional value                          | `!If [IsProd, m5.large, t3.micro]`|
| `Fn::Base64`        | Encode to Base64                           | UserData scripts                   |
| `Fn::Cidr`          | Generate CIDR blocks                       | Subnet CIDR allocation             |
| `Fn::GetAZs`        | Get list of AZs in region                 | Subnet placement                   |

---

## Key Exam Keywords and What They Map To

| Keyword / Phrase                          | AWS Service / Feature                      |
|-------------------------------------------|--------------------------------------------|
| "Decouple" / "Loose coupling"             | SQS, SNS, EventBridge                      |
| "Serverless"                              | Lambda, API Gateway, DynamoDB, S3, Fargate |
| "Static IP"                               | NLB, Global Accelerator                    |
| "Real-time"                               | Kinesis Data Streams, Kinesis Data Analytics|
| "Near real-time"                          | Kinesis Data Firehose (60s buffer)         |
| "Immutable" / "Ledger"                    | QLDB                                       |
| "Graph"                                   | Neptune                                     |
| "Machine learning predictions"            | SageMaker                                  |
| "Schema-less" / "Flexible schema"         | DynamoDB, DocumentDB                       |
| "OLAP" / "Analytics" / "Data warehouse"   | Redshift                                   |
| "Full-text search"                        | OpenSearch (Elasticsearch)                 |
| "Compliance / Regulatory"                 | AWS Artifact, Config, CloudTrail           |
| "PII / Sensitive data in S3"             | Macie                                       |
| "Threat detection"                        | GuardDuty                                  |
| "Vulnerability scanning"                  | Inspector                                  |
| "Central security view"                   | Security Hub                               |
| "Investigate findings"                    | Detective                                  |
| "Caching" / "Session store"              | ElastiCache (Redis)                        |
| "Microsecond latency (DynamoDB)"          | DAX                                        |
| "Hybrid cloud"                            | Direct Connect, VPN, Storage Gateway       |
| "Data transfer (petabytes, offline)"      | Snow Family (Snowball, Snowmobile)         |
| "Migrate databases"                       | DMS + SCT                                  |
| "Block specific IPs"                      | NACL (not Security Group)                  |
| "Port-based routing"                      | NLB (Layer 4)                              |
| "Path-based routing"                      | ALB (Layer 7)                              |
| "Content-based routing"                   | ALB (host header, path, query string)      |
| "3rd party firewall / network appliance"  | Gateway Load Balancer                      |
| "DDoS protection"                         | Shield (Standard/Advanced) + WAF           |
| "Automated password rotation"             | Secrets Manager                            |
| "Configuration management"                | Systems Manager Parameter Store            |
| "DNS"                                     | Route 53                                   |
| "Least privilege"                         | IAM Policies + Permissions Boundaries      |
| "Cross-account"                           | IAM Roles (AssumeRole), Resource policies  |
| "Organization-wide policy"                | SCPs (Service Control Policies)            |
| "Single sign-on"                          | IAM Identity Center (SSO)                  |
| "Cost-effective" / "Minimize cost"        | Spot, Reserved, Savings Plans, S3 tiers    |
| "Reduce latency globally"                 | CloudFront, Global Accelerator             |
| "Event-driven architecture"               | EventBridge, SNS + SQS, Lambda triggers    |
| "Loosely coupled microservices"           | SQS, API Gateway, ECS/EKS, App Mesh       |
| "Fan-out"                                 | SNS → multiple SQS queues                  |
| "Ordered messages"                        | SQS FIFO, Kinesis (per-shard)              |
| "Time-series data"                        | Timestream                                 |
| "Containers" (simplest)                   | ECS + Fargate                              |
| "Kubernetes"                              | EKS                                        |
| "CI/CD pipeline"                          | CodePipeline, CodeBuild, CodeDeploy        |
| "Infrastructure as Code"                  | CloudFormation, CDK, Terraform             |
| "Shared file system (Linux)"             | EFS                                         |
| "Shared file system (Windows)"           | FSx for Windows File Server                 |
| "HPC file system"                         | FSx for Lustre                             |
| "On-premises file access to S3"           | Storage Gateway                            |
| "Object storage"                          | S3                                          |
| "Managed Apache Kafka"                    | MSK (Managed Streaming for Kafka)          |
| "ETL"                                     | Glue                                       |
| "Query S3 with SQL"                       | Athena                                     |
| "Secrets with rotation"                   | Secrets Manager                            |

---

## Common Wrong Answer Traps

| Trap                                          | Why It's Wrong                                  | Correct Answer                    |
|-----------------------------------------------|------------------------------------------------|-----------------------------------|
| Using CloudFront for TCP/UDP traffic          | CloudFront is HTTP/HTTPS/WebSocket only         | Use Global Accelerator            |
| NAT Gateway for IPv6                          | IPv6 doesn't use NAT                            | Use Egress-Only IGW               |
| Security Group to block an IP                 | SGs only allow; cannot deny                     | Use NACL deny rule                |
| S3 Standard-IA for frequently accessed data   | IA = Infrequent Access, retrieval fee per GB    | Use S3 Standard                   |
| RDS Read Replica for HA                       | Read Replicas = read scaling, not HA            | Use Multi-AZ for HA               |
| Glacier for real-time access                  | Glacier Flexible has hours retrieval time        | Use Glacier Instant or S3 IA     |
| Lambda for >15-minute jobs                    | Lambda max timeout is 15 minutes                | Use ECS/Fargate, Step Functions   |
| Single AZ deployment as "highly available"    | Single AZ = single point of failure             | Multi-AZ, Multi-Region            |
| VPC Peering for transitive routing            | VPC Peering is NOT transitive                   | Use Transit Gateway               |
| Placing DB in public subnet                   | Databases should be in private subnets          | Private subnet + SG rules         |
| Using CloudWatch for API audit logging         | CloudWatch = metrics/logs, not API audit        | Use CloudTrail for API auditing   |
| AWS Config for threat detection               | Config = compliance, not threats                | Use GuardDuty for threats         |
| Redshift for OLTP workloads                   | Redshift is OLAP (analytics), not OLTP          | Use RDS/Aurora for OLTP          |
| DynamoDB for complex joins                    | DynamoDB = key-value, no joins                  | Use RDS/Aurora for joins          |
| Gateway Endpoint for access from on-premises  | Gateway Endpoints work within VPC only          | Use Interface Endpoint            |
| Kinesis Data Firehose for real-time (<1 sec)  | Firehose buffers (min 60s)                      | Use Kinesis Data Streams          |
| SSE-S3 for audit trail of key usage           | SSE-S3 keys are AWS-managed, no audit           | Use SSE-KMS for audit trail       |
| EBS Multi-Attach with gp3                     | Multi-Attach only works with io1/io2            | Use io2 for Multi-Attach          |
| ALB for non-HTTP protocols                    | ALB is Layer 7 (HTTP/HTTPS only)                | Use NLB for TCP/UDP               |
