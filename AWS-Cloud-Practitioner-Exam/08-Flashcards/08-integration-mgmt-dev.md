# Flashcards — Integration, Management, Dev Tools

## Integration

Q: What is SQS?
A: Managed pull-based message queue (Standard + FIFO). #must-know

Q: SQS Standard vs FIFO?
A: Standard: at-least-once, best-effort order, unlimited TPS. FIFO: exactly-once, strict order, up to 3K/s (30K with batching). #must-know

Q: SQS message retention?
A: 1 minute – 14 days (default 4 days). #must-know

Q: What's a DLQ?
A: Dead-letter queue — catches messages exceeding max receives. #must-know

Q: SNS purpose?
A: Push-based pub/sub — fan-out to SQS, Lambda, HTTP, email, SMS, mobile push, Firehose. #must-know

Q: EventBridge purpose?
A: Event bus + rules + targets; archive/replay; Pipes; Scheduler. #must-know

Q: Step Functions Standard vs Express?
A: Standard: long-running (up to 1 year), exactly-once, good for durable workflows. Express: short (≤ 5 min), at-least-once, high-volume. #must-know

Q: Amazon MQ is for?
A: Managed RabbitMQ / ActiveMQ (existing JMS/AMQP workloads). #must-know

Q: MSK?
A: Managed Kafka (and MSK Serverless, MSK Connect). #must-know

Q: AppFlow?
A: SaaS ↔ AWS data flow (Salesforce, ServiceNow, etc.). #must-know

Q: API Gateway types?
A: REST, HTTP, WebSocket. #must-know

Q: AppSync?
A: Managed GraphQL + real-time subscriptions. #must-know

Q: Kinesis Data Streams vs Firehose?
A: Streams: shards, 24h default retention (up to 365 d), you build consumers. Firehose: managed delivery to S3/Redshift/OpenSearch/Splunk/HTTP, near-real-time, no consumer code. #must-know

Q: Kinesis Video Streams use?
A: Ingest video from devices for analytics or ML. #must-know

## Management & Observability

Q: CloudWatch Metrics granularity?
A: Standard 1-minute (many services); 1-second with high-resolution custom metrics. #must-know

Q: CloudWatch Logs Insights?
A: Query language for log data. #must-know

Q: What are CloudWatch Synthetics?
A: Canary scripts (Node/Python) simulating user transactions. #must-know

Q: CloudWatch RUM?
A: Real-user browser telemetry (performance, errors). #must-know

Q: X-Ray?
A: Distributed tracing across microservices. #must-know

Q: What's ADOT?
A: AWS Distro for OpenTelemetry — send traces/metrics to CloudWatch or third-party. #must-know

Q: Session Manager replaces?
A: Bastion hosts; gives IAM-audited browser-based SSH. #must-know

Q: Patch Manager?
A: SSM capability that patches OSes on schedule with baselines. #must-know

Q: Run Command?
A: SSM feature to run ad-hoc commands on fleets of instances. #must-know

Q: Parameter Store?
A: SSM capability for config + SecureString secrets. #must-know

Q: OpsCenter?
A: SSM Incident/operational issue aggregator. #must-know

Q: Incident Manager?
A: SSM incident-response workflow tool (rotations, runbooks, contacts). #must-know

Q: Change Manager?
A: SSM service for controlled change approvals + calendars. #must-know

Q: Systems Manager Inventory?
A: Software + config inventory across managed instances (AWS + on-prem). #must-know

Q: Distributor?
A: SSM service that distributes software packages to managed instances. #must-know

## Organizations / Governance

Q: Management account =?
A: The "payer" or root account of an Organization. #must-know

Q: Feature sets of Organizations?
A: "All features" (default now) vs legacy "consolidated billing only". #must-know

Q: Can SCPs apply to root of management account?
A: No — management account principals are not restricted by SCPs. #must-know

Q: What is RAM?
A: Resource Access Manager — share resources (TGW attachment, subnets, R53 resolver rules, License configs) across accounts. #must-know

Q: What's AWS Proton?
A: Service for platform teams to publish self-service infra templates for developers. #must-know

Q: Service Catalog vs Proton?
A: Service Catalog = curated IaC; Proton = platform templates + CI/CD for dev teams. #must-know

## Developer tools

Q: CodeCommit?
A: AWS-hosted Git repos (service restricted to existing customers since 2024). #must-know

Q: CodeBuild?
A: Managed CI build service. #must-know

Q: CodeDeploy?
A: Deployment automation for EC2, ECS, Lambda, on-prem. #must-know

Q: CodePipeline?
A: Orchestrates CI/CD across sources/build/deploy. #must-know

Q: CodeArtifact?
A: Managed package repos (npm, Maven, PyPI, NuGet). #must-know

Q: Cloud9?
A: Browser-based IDE (EOL; replaced with VS Code / CloudShell workflows). #must-know

Q: Amplify?
A: Front-end + back-end framework for web/mobile (hosting, auth via Cognito, API via AppSync/APIGW). #must-know

Q: CloudShell?
A: Browser-based pre-authenticated shell. Free. #must-know

Q: CloudFormation?
A: Declarative IaC in YAML/JSON. Stacks, Change Sets, StackSets, drift detection. #must-know

Q: AWS CDK?
A: Code-first IaC in TS/Python/Java/C#/Go; compiles to CFN. #must-know

Q: AWS SAM?
A: YAML superset of CFN for serverless apps. #must-know

Q: App Composer?
A: Visual designer for SAM/CFN. #must-know

Q: Amazon Q Developer?
A: AI coding assistant (successor to CodeWhisperer). #must-know
