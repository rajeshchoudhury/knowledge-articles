# Flashcards — Analytics, ML, AI, IoT, Media, Misc

## Analytics

Q: Athena?
A: Serverless SQL (Trino/Presto) on S3. #must-know

Q: Glue?
A: Serverless ETL + Data Catalog; includes Crawlers, Studio, DataBrew. #must-know

Q: EMR?
A: Managed Spark/Hadoop/Hive/Presto/Trino/Flink/Hudi/Iceberg. EMR Serverless and EMR on EKS also exist. #must-know

Q: Lake Formation?
A: Data-lake governance layer over S3+Glue+Athena+Redshift. #must-know

Q: OpenSearch Service?
A: Managed OpenSearch/Elasticsearch + Serverless option. #must-know

Q: QuickSight?
A: BI SaaS with Q (NLQ) and Generative BI; SPICE in-memory engine. #must-know

Q: Data Exchange?
A: Marketplace for third-party datasets. #must-know

Q: Clean Rooms?
A: Privacy-preserving data collaboration between organizations. #must-know

Q: FinSpace?
A: Analytics SaaS specialized for financial services. #must-know

Q: Kinesis Data Analytics is now called?
A: Managed Service for Apache Flink. #must-know

## ML / Generative AI

Q: SageMaker?
A: End-to-end ML platform (Studio, Training, Inference, Canvas, JumpStart, Pipelines, Feature Store, Model Monitor, Clarify, Ground Truth, Autopilot). #must-know

Q: Rekognition?
A: Image / video analysis (faces, labels, text, moderation). #must-know

Q: Textract?
A: OCR + structured extraction (text, forms, tables) from docs. #must-know

Q: Comprehend?
A: NLP (sentiment, entities, topics, PII) — Medical variant available. #must-know

Q: Translate?
A: Neural machine translation. #must-know

Q: Polly?
A: Text-to-speech. #must-know

Q: Transcribe?
A: Speech-to-text (Medical variant). #must-know

Q: Lex?
A: Chatbot service (same tech as Alexa). #must-know

Q: Kendra?
A: Enterprise semantic search (ML-powered). #must-know

Q: Personalize?
A: Recommendation engine. #must-know

Q: Fraud Detector?
A: Managed fraud-scoring. #must-know

Q: Amazon Bedrock?
A: Serverless foundation-model API (Anthropic, Meta, Mistral, Cohere, Stability, Amazon Titan/Nova). Includes Knowledge Bases, Agents, Guardrails, Flows. #must-know

Q: Amazon Q Business?
A: Enterprise generative-AI assistant on customer data. #must-know

Q: Amazon Q Developer?
A: AI coding assistant (replaces CodeWhisperer). #must-know

Q: Difference: SageMaker vs Bedrock?
A: SageMaker = build/train/deploy ML models (incl. FMs). Bedrock = consume FMs via API without managing infra. #must-know

Q: RAG stands for?
A: Retrieval Augmented Generation — add org-specific context to FM prompts. #must-know

Q: Bedrock Guardrails purpose?
A: Enforce deny topics, filter PII, reduce hallucinations. #must-know

## IoT

Q: IoT Core?
A: MQTT broker, Device Registry, Rules Engine, Device Shadow, Jobs. #must-know

Q: Greengrass?
A: Extends AWS to edge devices; local compute, ML, messaging. #must-know

Q: IoT Analytics?
A: Managed analytics pipeline for IoT data (deprecated; replaced by other services). #note

Q: IoT SiteWise?
A: Industrial IoT data collection and modeling. #must-know

Q: IoT TwinMaker?
A: Digital twin building service. #must-know

Q: IoT FleetWise?
A: Vehicle data collection & organization. #must-know

## Media

Q: MediaConvert?
A: File-based video transcoding. #must-know

Q: MediaLive?
A: Live video encoding. #must-know

Q: MediaPackage?
A: Packaging/origin for streaming (HLS/DASH). #must-know

Q: MediaConnect?
A: Live video transport (contribution). #must-know

Q: MediaTailor?
A: Dynamic ad insertion. #must-know

Q: IVS (Interactive Video Service)?
A: Low-latency live streaming with interactive features. #must-know

## End-user & biz apps

Q: WorkSpaces?
A: Desktop-as-a-service. #must-know

Q: WorkSpaces Web?
A: Secure browser-in-browser for SaaS access. #must-know

Q: AppStream 2.0?
A: App streaming. #must-know

Q: Amazon Connect?
A: Cloud contact center. #must-know

Q: Chime (Chime SDK)?
A: Communications platform/APIs. #must-know

Q: SES?
A: Simple Email Service. #must-know

Q: Pinpoint?
A: Multi-channel marketing/transactional messaging (being rebranded as AWS End User Messaging). #must-know

## Migration

Q: MGN?
A: Application Migration Service — block-level rehost. #must-know

Q: DMS?
A: Database Migration Service. #must-know

Q: DataSync?
A: File-level online data transfer. #must-know

Q: Snow family?
A: Offline hardware-based transfer (Snowcone / Snowball Edge / Snowmobile). #must-know

Q: Migration Hub?
A: Central console to track migrations. #must-know

Q: Application Discovery Service?
A: Discovers on-prem servers for migration planning. #must-know

Q: Migration Evaluator?
A: Generates migration business case / TCO. #must-know

Q: Mainframe Modernization?
A: Lift or refactor mainframe workloads to AWS. #must-know

## Specialty

Q: Braket?
A: Quantum computing service. #must-know

Q: Ground Station?
A: Satellite downlink as a service. #must-know

Q: Managed Blockchain?
A: Managed Hyperledger Fabric (Ethereum support being phased). #must-know

Q: RoboMaker?
A: Robotics simulation (EOL September 2025). #must-know
