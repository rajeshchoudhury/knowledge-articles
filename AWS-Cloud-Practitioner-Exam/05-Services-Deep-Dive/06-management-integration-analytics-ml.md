# Management, Integration, Analytics, ML & Misc — Deep Dive

## Management & Governance

### Amazon CloudWatch

- **Metrics** — Numeric series; AWS + custom; standard (1-min) or
  high-resolution (1-sec).
- **Logs** — Group → Stream → Event. Retention per group. Queries via
  Logs Insights.
- **Alarms** — Threshold on metrics or composite alarms. Actions: SNS,
  Auto Scaling, EC2 actions (stop/terminate/reboot/recover), Systems
  Manager OpsItem.
- **EventBridge (formerly Events)** — Event buses, rules, targets.
- **Dashboards** — Cross-Region, cross-account; JSON-definable.
- **Synthetics** — Canary scripts (Node/Python) hitting URLs/APIs.
- **RUM** — Real-user (browser) telemetry.
- **Container Insights / Lambda Insights** — prebuilt dashboards.
- **Contributor Insights** — top contributors from logs.
- **Application Signals** — SLIs/SLOs.
- **Internet Monitor** — internet health for your users.
- **Network Monitor** — hybrid network perf monitoring.

### AWS CloudTrail

- Management, data, and Insight events. Event History (90 d free);
  Trails to S3 (long-term + data events); CloudTrail Lake (SQL-queryable
  store); Integration with CloudWatch Logs and EventBridge for near
  real-time analysis.

### AWS Config

- Resource config items + relationships; managed + custom rules;
  conformance packs; remediation via SSM Automation; multi-account
  aggregator.

### AWS Systems Manager (SSM)

Capabilities: Fleet Manager, Inventory, Patch Manager, Run Command,
Session Manager (IAM-audited SSH), State Manager, Automation,
Parameter Store, OpsCenter, Incident Manager, Change Manager / Calendar,
Distributor, Application Manager, Quick Setup.

### AWS Organizations

Multi-account: Root OU → OUs → Accounts. SCPs, tag policies, backup
policies, AI opt-out, consolidated billing.

### AWS Control Tower

Landing zone on top of Organizations + Identity Center + Config + CT +
Security Hub. Guardrails (SCPs + Config), Account Factory (AFT / CfCT).

### AWS Trusted Advisor

5 categories (6 with Ops Excellence): Cost, Performance, Security,
Fault Tolerance, Service Limits, Operational Excellence. Full checks
in Business/Enterprise plans.

### AWS Health

Personal Health Dashboard; AWS Health API; organizational view via
Organizations.

### AWS Service Catalog

Portfolios → Products (CloudFormation or Terraform). Constraints,
launch roles, notifications.

### AWS License Manager / AWS Resource Access Manager

- License Manager — license compliance + tracking.
- RAM — share resources (subnets, TGW, Route 53 Resolver rules, License
  configs, Image Builder, Marketplace Subscriptions, etc.) cross-account.

### AWS Proton

Managed infrastructure for platform teams; self-service templates.

### AWS CloudFormation / CDK / SAM

- **CloudFormation** — YAML/JSON IaC (stacks, StackSets, change sets,
  drift detection).
- **CDK** — TypeScript/Python/Java/C#/Go generating CFN templates.
- **SAM** — YAML for serverless apps (Lambda, APIGW, DynamoDB).

### AWS Application Composer

Visual canvas for SAM/CFN authoring.

### AWS CloudShell

Pre-authenticated browser shell with AWS CLI, Python, Node, Git, Docker.

---

## Application Integration

### Amazon SQS

Pull-based queue.
- **Standard** — unlimited TPS, at-least-once, best-effort ordering.
- **FIFO** — 3,000 TPS (with batching), exactly-once, strict order.
- Visibility Timeout, DLQ, Long Polling, Message Retention (1 min–14
  days), Delay Queues.

### Amazon SNS

Push-based pub/sub. Fan-out to SQS/Lambda/HTTP(S)/email/SMS/mobile
push/Firehose. **FIFO topics** deliver only to FIFO SQS.

### Amazon EventBridge

Event bus (default + custom + partner buses). Rules → Targets. Schema
Registry, Archive + Replay, Pipes (source → filter → enrich → target),
Scheduler (managed cron).

### AWS Step Functions

Workflow engine with ASL.
- **Standard** — up to 1 year, exactly-once, async execution.
- **Express** — up to 5 min, at-least-once, high-volume.

### Amazon MQ

Managed ActiveMQ / RabbitMQ.

### Amazon AppFlow

SaaS↔AWS data flow (Salesforce, ServiceNow, Slack, Google Analytics,
Marketo, Zendesk, Datadog, S3, Redshift, etc.).

### Amazon MSK

Managed Apache Kafka. MSK Serverless, MSK Connect.

### Amazon API Gateway

REST, HTTP, WebSocket. Auth (IAM, Cognito, Lambda authorizer), usage
plans, throttling, caching, stages, canary deploy, VPC-private.

### AWS AppSync

Managed GraphQL + Pub/Sub. Real-time subscriptions.

---

## Analytics

- **Amazon Athena** — Serverless SQL (Trino/Presto) on S3; CTAS, workgroups,
  federated queries.
- **AWS Glue** — Serverless ETL (PySpark/Scala); Glue Data Catalog;
  Crawlers; Glue Studio; DataBrew; Glue Schema Registry.
- **Amazon EMR** — Managed Spark/Hadoop/Hive/Presto/Trino/Flink/Hudi/
  Iceberg; EMR Serverless; EMR on EKS.
- **Amazon Kinesis**
  - **Data Streams** — shards, 365-day retention, custom consumers.
  - **Data Firehose** — managed delivery to S3/Redshift/OpenSearch/
    Splunk/HTTP.
  - **Video Streams** — video ingest for analytics / ML.
- **Managed Service for Apache Flink** (ex-Kinesis Data Analytics).
- **Amazon MSK** — Kafka (see above).
- **Amazon OpenSearch Service** — Elasticsearch/OpenSearch clusters +
  Serverless.
- **Amazon QuickSight** — BI SaaS; Q (NLQ), Generative BI, SPICE engine.
- **AWS Data Exchange** — marketplace for datasets.
- **AWS Lake Formation** — central data-lake governance over S3 + Glue
  + Athena + Redshift.
- **Amazon Redshift** — data warehouse (see DB section).
- **Amazon FinSpace** — analytics SaaS for finance.
- **AWS Clean Rooms** — privacy-preserving cross-company analytics.

---

## Machine Learning & Generative AI

### Amazon SageMaker

End-to-end ML platform. Capabilities: Studio, Notebook Instances,
Training Jobs (with Spot), Processing Jobs, Hyperparameter Tuning,
Debugger, Autopilot (AutoML), Canvas (low-code), JumpStart (model
hub), Experiments, Feature Store, Pipelines, Model Registry, Model
Monitor, Clarify (bias / explainability), Ground Truth (labeling),
Edge Manager, Neo (compile), Inference (real-time, serverless,
async, batch), HyperPod (large distributed training), Lakehouse
(unified data + analytics + ML; 2024+).

### Pre-trained AI services

| Service | Capability |
|---|---|
| Rekognition | Image / video analysis |
| Textract | Document text / form / table extraction |
| Comprehend | NLP (sentiment, entities, topics, PII) + Medical |
| Translate | Neural machine translation |
| Polly | Text-to-speech |
| Transcribe | Speech-to-text (+ Medical) |
| Lex | Chatbots |
| Kendra | Enterprise search |
| Personalize | Recommendations |
| Fraud Detector | Fraud scoring |
| Forecast | Time-series forecasts (being deprecated) |
| Lookout for Equipment / Vision / Metrics | Industrial anomaly detection |
| Monitron | Equipment monitoring hardware |
| HealthLake / Omics | Healthcare / genomics AI |

### Generative AI

- **Amazon Bedrock** — FM API service. Models: Anthropic Claude, Meta
  Llama, Mistral, Cohere, AI21, Stability, Amazon (Titan, Nova).
  Features: Knowledge Bases (RAG), Agents, Guardrails, Prompt
  Management, Flows, Model Evaluation, Custom models, Provisioned
  Throughput.
- **Amazon Q Business** — enterprise generative-AI assistant connected
  to your data.
- **Amazon Q Developer** — AI coding assistant (replaces CodeWhisperer).
- **Amazon Q in QuickSight / Connect / Chime** — embedded Q experiences.
- **Amazon Q Apps** — NL app builder on top of Q Business.

---

## IoT

- **AWS IoT Core** — MQTT/HTTPS broker + device registry + rules engine
  + device shadow + jobs.
- **AWS IoT Greengrass** — local edge runtime for IoT devices.
- **AWS IoT Device Management / Defender / Events / Analytics / SiteWise
  / TwinMaker / FleetWise / ExpressLink** — specialized IoT services.

## Media

- **Elemental MediaConvert** — file-based video transcoding.
- **Elemental MediaLive** — live video encoding.
- **Elemental MediaPackage** — packaging/origin for streaming.
- **Elemental MediaStore** — low-latency object store for video (AWS
  recommends S3 for new workloads).
- **Elemental MediaTailor** — ad insertion.
- **Elemental MediaConnect** — live video transport.
- **Amazon IVS** — low-latency live streaming for interactive apps.

## End-User Computing

- **Amazon WorkSpaces** — DaaS (Windows/Linux).
- **Amazon WorkSpaces Web** — secure browser access.
- **Amazon AppStream 2.0** — app streaming.
- **Amazon Connect** — cloud contact center.
- **Amazon Chime / Chime SDK** — meetings & voice/video APIs.

## Business Applications

- **Amazon SES** — email.
- **Amazon Pinpoint** — multi-channel messaging (being rebranded into
  AWS End User Messaging).

## Migration & Transfer

See `11-Scenarios-and-Glossary/` for migration case studies. Core
services:
- **Migration Hub**
- **Application Migration Service (MGN)**
- **Database Migration Service (DMS)** + **SCT**
- **DataSync**
- **Transfer Family**
- **Snow Family**
- **Application Discovery Service**
- **Migration Evaluator**
- **Elastic Disaster Recovery (DRS)**
- **VM Import/Export**
- **Mainframe Modernization**

## Blockchain / Quantum / Robotics / Satellite

- **Amazon Managed Blockchain** — Hyperledger Fabric (Ethereum support
  being wound down).
- **Amazon Braket** — quantum computing.
- **AWS RoboMaker** — end-of-life Sept 2025.
- **AWS Ground Station** — satellite downlink as a service.

## Customer Engagement

- **Amazon Connect** (contact center).
- **Amazon Pinpoint** (campaigns).
- **Amazon SES** (email).
- **Amazon Chime SDK** (communications in apps).

## Developer Tools

- **CodeCommit** (deprecated for new), **CodeBuild**, **CodeDeploy**,
  **CodePipeline**, **CodeArtifact**, **X-Ray**, **Cloud9** (EOL),
  **Amplify**, **CloudShell**, **App Composer**, **Amazon Q Developer**.
