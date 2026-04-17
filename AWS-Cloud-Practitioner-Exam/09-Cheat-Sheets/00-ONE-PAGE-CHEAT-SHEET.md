# ONE-PAGE CHEAT SHEET — AWS CCP (CLF-C02)

> Print this. If you can mentally run through every block, you are ready.

## Domain weights
```
D1 Cloud Concepts ........................ 24%
D2 Security & Compliance ................. 30%
D3 Cloud Technology & Services ........... 34%
D4 Billing, Pricing & Support ............ 12%
```

## 6 Benefits of the Cloud
1. CapEx → variable expense   2. Economies of scale
3. Stop guessing capacity     4. Increase speed & agility
5. Stop running DCs           6. Go global in minutes

## 6 Well-Architected Pillars (OSRPCS)
Operational Excellence • Security • Reliability
Performance Efficiency • Cost Optimization • Sustainability

## 7 R's of migration
Retire • Retain • Rehost • Relocate • Repurchase • Replatform • Refactor

## 6 CAF perspectives
Business • People • Governance • Platform • Security • Operations

## Global infra
Region ≥ 3 AZ • AZ = 1+ DC • Edge (600+) • Local Zones • Wavelength •
Outposts • GovCloud + China + Secret = separate partitions

## Shared Responsibility
AWS = *security OF* (HW, hypervisor, facilities, managed-service plane)
Customer = *security IN* (IAM, OS (on EC2), app, data, encryption config)

## IAM quick ref
- Users / Groups / Roles / Policies (JSON)
- Policy types: identity, resource, SCP, permissions boundary, session, ACL
- Policy eval: default deny → explicit Allow + not denied → Allow
- SCPs don't grant — they cap
- Prefer roles + STS + temporary creds; avoid long-lived access keys
- Enforce MFA; never use root for daily work

## Security quick ref
- **KMS** (multi-tenant HSM) vs **CloudHSM** (single-tenant HSM)
- **Secrets Manager** (rotation) vs **SSM Parameter Store** (config)
- **ACM** = free TLS certs for AWS services (not for raw EC2)
- **WAF** = L7 (CF/ALB/APIGW/AppSync/AppRunner/VA/Cognito)
- **Shield Standard** free; **Shield Advanced** $3k/mo + SRT + cost prot
- **SG** stateful ENI; **NACL** stateless subnet w/ Allow+Deny by #
- **CloudTrail**=who; **Config**=what/when state; **GuardDuty**=threats
- **Inspector**=CVEs; **Macie**=S3 PII; **Security Hub**=unified; **Detective**=graph investig
- **Artifact**=AWS reports; **Audit Manager**=evidence collection
- **Organizations**+**SCPs**+**Control Tower**=landing zone

## Compute
EC2 (VMs) • Fargate (serverless containers via ECS/EKS) • ECS (AWS-native)
EKS (K8s) • Lambda (≤15 min events) • App Runner (deploy-from-source)
Beanstalk (PaaS) • Lightsail (VPS) • Batch (jobs) • Outposts/Local/Wavelength

## Storage
S3 (object) classes: Std / IT / Std-IA / OneZone-IA / Glacier IR / Glacier FR / Deep Archive
EBS vol types: gp3 (default) / io2 BX (extreme) / gp2 (old) / st1 (HDD thru) / sc1 (HDD cold)
EFS (NFS Linux) • FSx (Windows/Lustre/NetApp/OpenZFS) • Storage Gateway (hybrid)
Snow Family (Snowcone 8–14TB / Snowball 80TB / Snowmobile)
AWS Backup (central) • DataSync (online) • Transfer Family (SFTP/FTPS/AS2) • DRS (DR)

## Database
RDS (MySQL/PG/MariaDB/Oracle/MSSQL/Db2) • Aurora (5× MySQL, 3× PG) / Aurora Global / Serverless v2
DynamoDB (KV NoSQL, global tables, PITR, DAX) • ElastiCache (Redis/Memcached) • MemoryDB (durable Redis)
Neptune (graph) • DocumentDB (MongoDB) • Keyspaces (Cassandra) • Timestream (time-series)
Redshift (data warehouse + Spectrum + Serverless) • Athena (SQL on S3 serverless)

## Networking
VPC / Subnet / RT / IGW / NAT GW / VPC Endpoint (S3/DDB gateway; interface = PrivateLink)
VPC Peering (non-transitive) • Transit Gateway (hub & spoke) • Cloud WAN
Direct Connect (dedicated) • Site-to-Site VPN • Client VPN
Route 53 (simple/weighted/latency/failover/geo/geoproximity/multivalue/IP-based)
CloudFront (CDN) vs Global Accelerator (TCP/UDP static IPs)

## Integration
SQS (pull queue) • SNS (pub/sub) • EventBridge (event bus + Pipes + Scheduler)
Step Functions (Standard/Express) • MQ (RabbitMQ/ActiveMQ) • AppFlow (SaaS) • MSK (Kafka)
API Gateway (REST/HTTP/WS) • AppSync (GraphQL)

## Monitoring / Mgmt / Dev
CloudWatch (Metrics/Logs/Alarms/Events/Dashboards/Synthetics/RUM/Insights)
X-Ray (tracing) • Systems Manager (SSM) umbrella (Session Mgr, Patch Mgr, Param Store, Automation…)
Trusted Advisor (Cost/Perf/Sec/FT/Limits/Ops) — full in Business+Enterprise
Organizations • Control Tower • Service Catalog • Proton • License Manager • RAM
CodeCommit (dep) • CodeBuild • CodeDeploy • CodePipeline • CodeArtifact
Cloud9 (EOL) • Amplify • App Runner • App Composer • Amazon Q Developer

## AI/ML / Analytics / IoT
SageMaker (full ML) • Bedrock (foundation models) • Amazon Q
Rekognition • Textract • Comprehend • Translate • Polly • Transcribe • Lex • Kendra • Personalize • Fraud Detector
Athena • Glue • EMR • Kinesis (Streams/Firehose/Video) • MSK • OpenSearch • QuickSight • Data Exchange • Lake Formation • FinSpace • Clean Rooms
IoT Core • Greengrass • Device Mgmt / Defender / Events / Analytics / SiteWise / TwinMaker / FleetWise

## Pricing & Free
- 3 Free-tier types: Always / 12-month / Trials
- EC2 buy: OD / RI Standard / RI Convertible / Compute SP / EC2 Inst SP / Spot / Dedicated Host+Inst / Capacity Reservation
- Spot: ≤ 90% off; SP/RI: ≤ 72% off
- **Free** internals: VPC itself, IAM, Organizations, CFN itself, Elastic Beanstalk itself, inbound data
- **Charged** "gotchas": NAT GW, public IPv4 always, EIP not-in-use, cross-AZ data, CW detailed/custom metrics

## Cost tools
Pricing Calculator (estimate) • Cost Explorer (analysis) • Budgets (alerts/actions)
CUR (hourly parquet S3) • Cost Anomaly Detection (ML) • Compute Optimizer • Trusted Advisor • Billing Conductor (chargeback)

## Support plans
| | Basic | Developer | Business | Enterprise On-Ramp | Enterprise |
|---|---|---|---|---|---|
| 24×7 phone/chat | — | — | ✓ | ✓ | ✓ |
| Full TA checks | — | — | ✓ | ✓ | ✓ |
| 3rd-party SW support | — | — | ✓ | ✓ | ✓ |
| Dedicated TAM | — | — | — | pool | ✓ |
| WAR on demand | — | — | — | ✓ | ✓ |
| Concierge billing | — | — | — | ✓ | ✓ |
| Crit SLA | — | — | 1h urgent | 30 min | 15 min |

## Partner programs
APN Consulting/Services • APN Technology (ISVs) • MSP • AWS IQ (freelancers) •
AWS Professional Services • AWS Managed Services (AMS) • Marketplace •
Competency programs • Service Delivery Partner
