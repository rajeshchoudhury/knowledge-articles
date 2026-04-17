# 06 — AWS Services Deep Dive for Generative AI Workloads

> **Exam:** AWS Certified Generative AI Developer – Professional (AIP-C01)
>
> Every in-scope service is covered below, grouped by category. Machine Learning services receive the deepest treatment because they dominate the exam blueprint.

---

## TABLE OF CONTENTS

1. [Machine Learning Services](#1-machine-learning-services)
   - [Amazon Bedrock](#11-amazon-bedrock)
   - [Amazon SageMaker AI](#12-amazon-sagemaker-ai)
   - [Amazon Q](#13-amazon-q)
   - [Other ML Services](#14-other-ml-services)
2. [Analytics](#2-analytics)
3. [Application Integration](#3-application-integration)
4. [Compute](#4-compute)
5. [Containers](#5-containers)
6. [Database](#6-database)
7. [Developer Tools](#7-developer-tools)
8. [Management and Governance](#8-management-and-governance)
9. [Networking and Content Delivery](#9-networking-and-content-delivery)
10. [Security, Identity, and Compliance](#10-security-identity-and-compliance)
11. [Storage](#11-storage)
12. [Migration and Transfer](#12-migration-and-transfer)
13. [Customer Engagement](#13-customer-engagement)

---

## 1. MACHINE LEARNING SERVICES

---

### 1.1 Amazon Bedrock

Amazon Bedrock is **the single most important service on the AIP-C01 exam**. Expect questions on every sub-feature below.

#### 1.1.1 Overview and Architecture

Amazon Bedrock is a fully managed service that provides access to high-performing foundation models (FMs) from leading AI companies through a single, unified API. It is serverless — there are no instances to provision or manage. All data processed by Bedrock stays within the AWS Region where the API call is made and is not used by AWS to train or improve base models.

**Core value proposition:** Build and scale GenAI applications without managing infrastructure or ML expertise, with built-in security, privacy, and responsible AI features.

**Architecture highlights:**
- API-driven: all interactions happen through the Bedrock Runtime API
- Models run in isolated compute environments managed by AWS
- Customer data is encrypted in transit (TLS 1.2+) and at rest (KMS)
- VPC endpoints (PrivateLink) available for private connectivity
- Model access must be explicitly enabled per Region before use

#### 1.1.2 Foundation Models Available

| Provider | Models | Strengths |
|----------|--------|-----------|
| **Anthropic** | Claude 3.5 Sonnet, Claude 3 Opus/Sonnet/Haiku, Claude 2.x, Claude Instant | Complex reasoning, long context (200K tokens), coding, vision |
| **Amazon** | Titan Text (Express, Lite, Premier), Titan Embeddings (v1, v2), Titan Image Generator, Titan Multimodal Embeddings | First-party models, embeddings for RAG, image generation |
| **Meta** | Llama 3.x, Llama 2 | Open-weight models, customization-friendly |
| **Mistral AI** | Mistral Large, Mistral 8x7B (Mixtral), Mistral 7B | Efficient inference, multilingual |
| **Cohere** | Command R/R+, Embed | RAG-optimized, multilingual embeddings |
| **AI21 Labs** | Jamba-Instruct, Jurassic-2 | Long context, enterprise text generation |
| **Stability AI** | Stable Diffusion XL | Image generation, image-to-image |

**Exam tip:** Know which model families support which modalities (text, image, embeddings, multimodal). Titan Embeddings and Cohere Embed are the primary embedding models for RAG. Claude and Titan are the most frequently tested.

#### 1.1.3 Bedrock APIs

**InvokeModel**
- Synchronous, single-turn call to a foundation model
- Request body is model-specific JSON (prompt format varies by provider)
- Returns the complete response in one payload
- Use case: batch processing, simple Q&A, non-interactive workloads

**InvokeModelWithResponseStream**
- Same as InvokeModel but returns the response as a stream of chunks
- Essential for real-time chat applications (reduces perceived latency)
- Uses HTTP chunked transfer encoding
- Use case: chatbots, interactive applications, long-form generation

**Converse API (ConverseStream)**
- Provider-agnostic API — same request/response format regardless of model
- Supports multi-turn conversations natively (message history as array)
- Handles tool use (function calling) with a standardized schema
- Supports system prompts, images, documents as input
- **Exam favorite:** When asked about "model-agnostic" or "switching models easily," the answer is the Converse API

**Key distinctions for the exam:**

| Feature | InvokeModel | Converse API |
|---------|-------------|--------------|
| Request format | Model-specific | Unified |
| Multi-turn | Manual history management | Built-in message array |
| Tool use | Model-specific format | Standardized toolUse blocks |
| Streaming | InvokeModelWithResponseStream | ConverseStream |
| Model switching | Requires code changes | Change model ID only |

#### 1.1.4 Bedrock Knowledge Bases

Knowledge Bases power **Retrieval-Augmented Generation (RAG)** natively in Bedrock.

**Architecture:**
1. **Data source** → Documents are ingested from S3, Confluence, SharePoint, Salesforce, or web crawlers
2. **Chunking** → Documents are split into manageable chunks
3. **Embedding** → Each chunk is converted to a vector using an embedding model (Titan Embeddings v2, Cohere Embed)
4. **Vector store** → Embeddings are stored in a vector database
5. **Retrieval** → At query time, the user query is embedded, similar chunks are retrieved via semantic search
6. **Augmentation** → Retrieved chunks are injected into the prompt as context
7. **Generation** → The FM generates a response grounded in the retrieved context

**Chunking strategies:**
- **Fixed-size chunking:** Split by token/character count with optional overlap. Simple, predictable.
- **Default chunking:** ~300 tokens per chunk (Bedrock's default)
- **Hierarchical chunking:** Parent-child chunks; retrieve child, pass parent for broader context
- **Semantic chunking:** Split at natural semantic boundaries (sentence/paragraph breaks). Better coherence.
- **No chunking:** Treat each file as one chunk. Good for small docs.

**Supported vector stores:**
- Amazon OpenSearch Serverless (default, managed)
- Amazon Aurora PostgreSQL (pgvector)
- Pinecone
- Redis Enterprise Cloud
- MongoDB Atlas

**Sync mechanisms:**
- **StartIngestionJob** API to trigger sync
- Incremental sync: only new/modified/deleted documents are processed
- Can be triggered on schedule via EventBridge + Lambda
- Metadata filtering: attach metadata to documents for filtered retrieval at query time

**Exam scenarios:**
- "Responses lack current information" → Add a Knowledge Base with up-to-date documents
- "Reduce hallucinations" → Enable Knowledge Base with source attribution
- "Need to search internal docs" → Knowledge Base with S3 or Confluence data source
- "Filter results by department" → Use metadata filtering on the Knowledge Base

#### 1.1.5 Bedrock Agents

Agents enable FMs to **take actions** by calling APIs and querying Knowledge Bases dynamically.

**Architecture:**
- Agent receives user input → FM reasons about what to do (ReAct-style orchestration) → selects an action group or knowledge base → executes → returns result → FM synthesizes final response
- Orchestration uses chain-of-thought prompting internally

**Action Groups:**
- Define API operations the agent can invoke
- Backed by Lambda functions or OpenAPI schemas (return-of-control supported)
- Each action group has a description telling the FM when to use it
- Lambda receives the action, parameters, and session context
- **Return of control:** Instead of calling Lambda, Bedrock returns the action to the calling application to execute (useful when execution must happen client-side)

**Knowledge Base integration:** Agents can query one or more Knowledge Bases during orchestration to retrieve grounded information before responding.

**Multi-agent orchestration:**
- Supervisor agent delegates to sub-agents
- Each sub-agent specializes in a domain
- Supervisor routes queries and combines results
- Enables complex workflows with separation of concerns

**Session management:**
- `sessionId` maintains conversational context
- Session attributes persist across turns
- Prompt session attributes are per-turn overrides

**Exam scenarios:**
- "Need to look up order status and query a knowledge base" → Bedrock Agent with an action group (Lambda → DynamoDB) + Knowledge Base
- "Break a complex task into specialized sub-tasks" → Multi-agent orchestration
- "Agent needs to call an external API" → Action group with OpenAPI schema

#### 1.1.6 Bedrock Guardrails

Guardrails enforce responsible AI policies on inputs and outputs.

**Components:**

| Filter Type | What It Does |
|-------------|-------------|
| **Content filters** | Block harmful content across categories: hate, insults, sexual, violence, misconduct, prompt attacks. Configurable strength (NONE, LOW, MEDIUM, HIGH) for both input and output. |
| **Denied topics** | Define custom topics the model must refuse to discuss. Uses natural language descriptions. Example: "Do not discuss competitor products." |
| **Word filters** | Block specific words or phrases (exact match, profanity list). |
| **Sensitive information filters (PII)** | Detect and handle PII: SSN, phone, email, name, address, credit card, etc. Actions: BLOCK or ANONYMIZE (mask/redact). |
| **Contextual grounding** | Checks if model output is grounded in the provided source (knowledge base). Configurable threshold for grounding and relevance scores. Reduces hallucinations. |

**How Guardrails work:**
- Applied as a layer around model invocation (input pre-processing + output post-processing)
- Can be attached to Bedrock agents, Knowledge Bases, or direct InvokeModel calls
- Identified by a Guardrail ID and version
- Independent of the model — same guardrail works across models

**Exam scenarios:**
- "Prevent the model from discussing pricing" → Denied topics
- "Redact SSNs from responses" → PII filter with ANONYMIZE
- "Ensure responses are grounded in source documents" → Contextual grounding check
- "Block prompt injection attempts" → Content filter for prompt attacks

#### 1.1.7 Bedrock Prompt Management

- Create, store, and version **prompt templates** with variables
- Variables use `{{variable_name}}` syntax
- Version control: create new versions, roll back to previous
- Compare performance across prompt versions
- Integrate with Bedrock Agents and applications via API
- **Exam tip:** When asked about "managing prompts across environments" or "A/B testing prompts," think Prompt Management

#### 1.1.8 Bedrock Prompt Flows

- Visual workflow builder for chaining multiple FM invocations and logic
- **Node types:** Input, Output, Prompt, Knowledge Base, Agent, Condition, Lambda, Iterator, Collector, S3 Storage
- Conditional branching based on model output or variables
- Chain multiple models: e.g., classify with one model, generate with another
- Iterator node processes items in a list individually, Collector aggregates results
- Deploy as an API endpoint for integration

**Exam scenario:** "Route customer queries to different models based on complexity" → Prompt Flow with a condition node

#### 1.1.9 Bedrock Model Evaluation

**Automatic evaluation:**
- Run evaluation jobs against built-in metrics: accuracy, robustness, toxicity
- Uses benchmark datasets or your own custom datasets
- Metrics: BERTScore, ROUGE, F1, human-likeness, toxicity scores
- Compare multiple models side-by-side

**Human evaluation:**
- Use your own workforce or AWS-managed workforce
- Rate responses on custom criteria (helpfulness, harmlessness, honesty)
- Collect preference rankings between models

**Custom metrics:**
- Define evaluation criteria using an LLM-as-judge approach
- Use a strong model to evaluate outputs of the model being tested

**Exam scenario:** "Choose the best model for our use case" → Bedrock Model Evaluation (automatic for scale, human for nuance)

#### 1.1.10 Bedrock Cross-Region Inference

- Route inference requests across AWS Regions automatically
- Increases throughput and availability
- Uses inference profiles that map to multiple Regions
- No code changes required — use the inference profile ARN instead of the model ID
- Data stays within the configured Regions

**Exam tip:** When asked about "handling traffic spikes" or "improving availability for model inference," consider Cross-Region Inference.

#### 1.1.11 Bedrock Provisioned Throughput vs On-Demand

| Aspect | On-Demand | Provisioned Throughput |
|--------|-----------|----------------------|
| Pricing | Per input/output token | Fixed hourly rate for reserved model units |
| Capacity | Shared, best-effort | Guaranteed, dedicated |
| Custom models | No | Required for fine-tuned/custom models |
| Commitment | None | 1-month or 6-month terms |
| Use case | Variable/unpredictable workloads | Steady-state production, latency-sensitive |

**Exam tip:** Fine-tuned models in Bedrock require Provisioned Throughput to serve.

#### 1.1.12 Bedrock Model Invocation Logging

- Log all API calls to S3 and/or CloudWatch Logs
- Captures: input prompts, output responses, model ID, token counts, latency
- Enable for compliance, debugging, cost analysis
- Can include full request/response content or metadata only
- **Exam tip:** "Audit what prompts were sent to the model" → Model Invocation Logging

#### 1.1.13 Bedrock Data Automation

- Automatically extract, transform, and structure data from documents, images, audio, and video
- Uses FMs to understand unstructured content
- Outputs structured formats (JSON, CSV)
- Integrates with S3 for input/output
- Use case: processing invoices, contracts, media files at scale

#### 1.1.14 Bedrock AgentCore

- Infrastructure layer for deploying and managing AI agents at scale
- Provides memory, tool management, identity, and orchestration primitives
- Designed for production agent deployments
- Supports both Bedrock-native and custom agents
- Gateway for secure agent-to-tool connectivity

#### 1.1.15 Amazon Titan Models (Deep Dive)

**Titan Text (Express / Lite / Premier):**
- General-purpose text generation
- Express: balanced performance and cost
- Lite: low-latency, lower cost, smaller context
- Premier: highest quality for complex tasks
- All support fine-tuning through Bedrock custom models

**Titan Embeddings v1 / v2:**
- Convert text to vector representations (1536 dimensions for v2)
- v2 supports configurable dimensions and normalization
- Primary use: RAG pipelines, semantic search, similarity matching
- v2 supports 8192 token input length

**Titan Image Generator:**
- Text-to-image generation
- Image editing: inpainting, outpainting, image variation
- Built-in invisible watermarking for AI-generated images
- Supports negative prompts, seed for reproducibility

**Titan Multimodal Embeddings:**
- Embed both text and images into the same vector space
- Use case: multimodal search (search images by text, text by images)
- 1024 / 384 / 256 dimension options

---

### 1.2 Amazon SageMaker AI

SageMaker is AWS's end-to-end ML platform. For the GenAI exam, focus on model hosting, JumpStart, monitoring, and responsible AI features.

#### 1.2.1 SageMaker Endpoints

- Deploy custom models (fine-tuned LLMs, custom transformers) as real-time HTTP endpoints
- **Real-time endpoints:** persistent, low-latency, auto-scaling
- **Serverless endpoints:** scale to zero, pay-per-inference (cold starts)
- **Asynchronous endpoints:** for large payloads or long-running inference (results to S3)
- Support multi-model endpoints (host multiple models on one instance) and multi-container endpoints
- Instance types: ml.g5, ml.p4d, ml.p5 (GPU); ml.inf2 (Inferentia2) for cost-optimized inference

**GenAI relevance:** Host custom fine-tuned LLMs, domain-specific models, or models not available in Bedrock.

**Exam scenario:** "We fine-tuned a model outside AWS and need to deploy it" → SageMaker endpoint with a custom container.

#### 1.2.2 SageMaker JumpStart

- Hub of 600+ pre-trained foundation models (Llama, Falcon, Mistral, Stable Diffusion, etc.)
- One-click deployment to SageMaker endpoints
- Fine-tuning notebooks and scripts included
- Foundation models available as JumpStart model packages
- **Difference from Bedrock:** JumpStart gives you the actual model on your infrastructure (you manage instances); Bedrock is serverless

**Exam scenario:** "Deploy an open-source LLM with full control over the infrastructure" → SageMaker JumpStart

#### 1.2.3 SageMaker Model Registry

- Central repository for ML model versions
- Track model lineage, metadata, and approval status
- Approval workflow: Pending → Approved → Rejected
- Integrates with CI/CD pipelines (CodePipeline, CodeBuild)
- Group models into Model Packages and Model Package Groups

**GenAI relevance:** Version and govern fine-tuned LLM iterations before production deployment.

#### 1.2.4 SageMaker Model Monitor

- Detect data drift, model quality drift, and bias drift in real time on deployed endpoints
- **Monitor types:** Data Quality, Model Quality, Bias Drift, Feature Attribution Drift
- Runs on a schedule (e.g., hourly) comparing live traffic to a baseline
- Generates CloudWatch metrics and alerts
- Outputs violation reports to S3

**GenAI relevance:** Monitor embeddings drift in RAG systems; detect shifts in input distributions to deployed LLMs.

**Exam scenario:** "Model performance is degrading over time" → SageMaker Model Monitor for drift detection.

#### 1.2.5 SageMaker Clarify

- **Bias detection:** Pre-training bias (data), post-training bias (model predictions)
- **Explainability:** SHAP values, feature importance, prompt-level attributions
- **Foundation model evaluation:** Evaluate FM outputs for toxicity, accuracy, robustness
- Integrates with Model Monitor for continuous bias monitoring

**GenAI relevance:** Evaluate and explain FM behavior; detect bias in model outputs; meet responsible AI requirements.

**Exam scenario:** "Ensure our model doesn't discriminate based on protected attributes" → SageMaker Clarify.

#### 1.2.6 SageMaker Ground Truth / Ground Truth Plus

- Create high-quality labeled training datasets
- Human annotation workforce options: Amazon Mechanical Turk, private workforce, third-party vendors
- Ground Truth Plus: fully managed labeling service
- Supports text, image, video, 3D point cloud labeling
- Active learning reduces labeling costs by auto-labeling high-confidence samples

**GenAI relevance:** Create fine-tuning datasets, RLHF preference datasets, evaluation datasets.

#### 1.2.7 SageMaker Data Wrangler

- Visual data preparation and feature engineering tool
- 300+ built-in data transformations
- Import from S3, Athena, Redshift, Snowflake, Databricks
- Export to SageMaker Processing, Pipelines, or as a DataFrame

**GenAI relevance:** Prepare and clean data before embedding generation or fine-tuning.

#### 1.2.8 SageMaker Processing

- Run data processing, evaluation, and transformation jobs on managed compute
- Use built-in containers (scikit-learn, Spark) or custom containers
- Decoupled from training — run pre/post-processing independently

**GenAI relevance:** Pre-process documents before ingestion into a Knowledge Base; post-process model outputs at scale.

#### 1.2.9 SageMaker Neo

- Compile and optimize ML models for target hardware
- Reduces model size and improves inference performance
- Supports multiple frameworks (TensorFlow, PyTorch, MXNet, ONNX)
- Deploy optimized models to edge or cloud endpoints

#### 1.2.10 SageMaker Unified Studio

- Unified workspace for data engineering, analytics, and ML
- Access SageMaker, Glue, Athena, Redshift, EMR from a single interface
- Built on Amazon DataZone for data governance
- Collaborative environment for multi-persona teams (data engineers, data scientists, ML engineers)

---

### 1.3 Amazon Q

#### 1.3.1 Amazon Q Developer

AI-powered coding assistant integrated into IDEs and the AWS console.

**Key capabilities:**
- **Code generation:** Generate code from natural language descriptions
- **Code completion:** Real-time inline suggestions as you type
- **Code transformation:** Modernize Java 8 → Java 17, .NET Framework → .NET Core
- **Debugging:** Explain and fix errors
- **Refactoring:** Optimize code structure
- **Security scanning:** Detect vulnerabilities (OWASP Top 10, CWE) and suggest fixes
- **CLI assistance:** Translate natural language to AWS CLI commands
- **Chat:** Ask questions about AWS services, your codebase, or general coding

**Supported IDEs:** VS Code, JetBrains, Visual Studio, AWS Cloud9, AWS Console

**GenAI relevance:** This IS a GenAI application — an AI coding assistant. Understand its capabilities for the exam.

**Exam scenarios:**
- "Developer wants AI help writing Lambda functions" → Amazon Q Developer
- "Need to find security vulnerabilities in code" → Amazon Q Developer security scan
- "Migrate a Java 8 application to Java 17" → Amazon Q Developer code transformation

#### 1.3.2 Amazon Q Business

Enterprise AI assistant that connects to organizational data sources.

**Key features:**
- Connects to 40+ enterprise data sources: S3, SharePoint, Confluence, Salesforce, Jira, Slack, databases, etc.
- Respects existing access controls (ACLs) — users only see data they're authorized to access
- Admin controls: block topics, manage responses
- Plugins: perform actions (create Jira tickets, send emails)
- Built-in web experience — no coding required to deploy
- Custom UI possible via API

**Guardrails:** Admin and topic-level controls, global controls to block topics.

**Exam scenario:** "Employees need to search across internal wikis, SharePoint, and S3" → Amazon Q Business

#### 1.3.3 Amazon Q Business Apps

- Build custom AI-powered applications on top of Q Business
- No-code/low-code app creation
- Forms, workflows, and actions powered by GenAI
- Use case: automate HR requests, IT helpdesk, procurement approvals

---

### 1.4 Other ML Services

#### 1.4.1 Amazon Comprehend

Natural Language Processing (NLP) service for text analysis.

**Capabilities:** Entity recognition, sentiment analysis, key phrase extraction, language detection, PII detection/redaction, custom entity recognition, custom classification, topic modeling.

**GenAI relevance:**
- Pre-process text before feeding to an FM (extract entities, detect language)
- PII detection as a pre/post-processing step in GenAI pipelines
- Classify user queries before routing to specialized models
- Comprehend's custom classification can route prompts to different models

**Exam scenario:** "Detect and redact PII before sending data to a foundation model" → Amazon Comprehend (or Bedrock Guardrails PII filter).

#### 1.4.2 Amazon Kendra

Intelligent enterprise search service powered by ML.

**Key features:**
- Natural language search (not keyword-based)
- Connectors for 14+ data sources (S3, SharePoint, Confluence, databases, etc.)
- Relevance tuning and query suggestions
- Incremental learning from user feedback (thumbs up/down)
- Returns ranked results with document excerpts

**GenAI relevance:**
- Can serve as a retriever for RAG architectures (retrieve → augment prompt → generate)
- Integrates with Bedrock Agents as a retrieval source
- Alternative to Bedrock Knowledge Bases for enterprise search + GenAI

**Exam scenario:** "Already using Kendra for search; want to add GenAI answers" → Kendra retrieval + Bedrock FM for generation.

#### 1.4.3 Amazon Lex

Build conversational interfaces (chatbots and voice bots).

**Key features:**
- Automatic speech recognition (ASR) + natural language understanding (NLU)
- Intents, slots, fulfillment (via Lambda)
- Multi-turn dialog management
- Integration with Amazon Connect for contact centers
- Supports SSML for speech output

**GenAI relevance:**
- Lex bots can invoke Bedrock FMs for generalized responses beyond defined intents
- Traditional intent-based routing combined with GenAI fallback
- Use Lex for structured conversations, Bedrock for open-ended generation

**Exam scenario:** "Chatbot handles known intents well but fails on open-ended questions" → Add Bedrock FM as fallback in Lex fulfillment Lambda.

#### 1.4.4 Amazon Rekognition

Image and video analysis service.

**Capabilities:** Object detection, facial analysis, celebrity recognition, text in images (OCR), content moderation, custom labels, PPE detection, face liveness.

**GenAI relevance:**
- Pre-process images before multimodal FM invocation (detect objects, extract text)
- Content moderation layer for user-uploaded images in GenAI apps
- Custom labels for domain-specific image classification

#### 1.4.5 Amazon Textract

Extract text, forms, and tables from scanned documents.

**Capabilities:** Text detection (OCR), form extraction (key-value pairs), table extraction, query-based extraction (ask questions about the document), expense analysis, identity document analysis.

**GenAI relevance:**
- Extract text from PDFs/images before embedding for RAG
- Pre-process documents before sending to an FM for summarization
- Structure extraction from invoices, contracts, forms → feed into GenAI workflows

**Exam scenario:** "Process scanned invoices and generate summaries" → Textract (extract) → Bedrock (summarize).

#### 1.4.6 Amazon Transcribe

Automatic speech-to-text service.

**Capabilities:** Real-time and batch transcription, custom vocabularies, automatic language identification, speaker diarization, PII redaction, custom language models, call analytics.

**GenAI relevance:**
- Transcribe audio → feed transcript to FM for summarization, analysis, or Q&A
- Build voice-powered GenAI interfaces
- Call center analytics: Transcribe → Comprehend/Bedrock for sentiment and insights

#### 1.4.7 Amazon Augmented AI (A2I)

Human review workflows for ML predictions.

**How it works:**
1. Define conditions that trigger human review (confidence threshold)
2. ML prediction below threshold → sent to human reviewer
3. Human reviewer accepts, rejects, or modifies the prediction
4. Results stored in S3

**Worker types:** Amazon Mechanical Turk, private workforce, third-party vendors.

**Integrations:** Built-in with Textract, Rekognition. Custom integrations for any ML workflow.

**GenAI relevance:**
- Human-in-the-loop review for high-stakes GenAI outputs
- Review FM-generated content before publishing
- Quality assurance for automated document processing

**Exam scenario:** "Critical decisions need human verification before proceeding" → A2I workflow.

---

## 2. ANALYTICS

---

### 2.1 Amazon Athena

**What it does:** Serverless interactive query service to analyze data in S3 using standard SQL.

**GenAI relevance:** Query large datasets to prepare training/evaluation data. Use Athena to analyze model invocation logs stored in S3. Athena Federated Queries can join data from multiple sources for GenAI feature engineering.

**Key exam features:**
- Pay per query (per TB scanned)
- Supports Parquet, ORC, JSON, CSV, Avro
- Integrates with AWS Glue Data Catalog for schema management
- Partition projection reduces query costs

**Common exam scenario:** "Analyze Bedrock model invocation logs stored in S3" → Athena query over the S3 log bucket.

**Integration points:** S3 (data source), Glue Data Catalog (schema), QuickSight (visualization), Lambda (UDFs).

---

### 2.2 Amazon EMR

**What it does:** Managed big data platform running Apache Spark, Hive, Presto, and other frameworks.

**GenAI relevance:** Large-scale data preprocessing for training datasets. Distribute embedding generation across a Spark cluster. Process terabytes of documents before ingestion into vector stores.

**Key exam features:**
- EMR on EC2, EMR on EKS, EMR Serverless
- Spark MLlib for distributed ML
- EMR Serverless: no cluster management, pay for resources used

**Common exam scenario:** "Process petabytes of log data to extract features for model training" → EMR Spark job.

**Integration points:** S3, Glue Data Catalog, SageMaker, Lake Formation.

---

### 2.3 AWS Glue

**What it does:** Serverless ETL (Extract, Transform, Load) service for data integration.

**GenAI relevance:** Prepare, clean, and transform data before embedding or fine-tuning. Glue crawlers discover schema automatically. Central metadata catalog for all data assets.

**Key exam features:**
- **Glue Data Catalog:** Central metadata repository; stores table definitions, schema, partitions. Used by Athena, EMR, Redshift Spectrum.
- **Glue Data Quality:** Define and enforce data quality rules (completeness, uniqueness, freshness). Run quality checks on datasets.
- **Glue ETL Jobs:** PySpark or Python Shell for data transformation
- **Glue Crawlers:** Automatically discover data schema from S3, databases
- **Glue Studio:** Visual ETL job authoring

**Common exam scenario:** "Ensure training data quality before fine-tuning" → Glue Data Quality rules.

**Integration points:** S3, Athena, Redshift, EMR, Lake Formation, SageMaker.

---

### 2.4 Amazon Kinesis

**What it does:** Real-time data streaming platform for ingestion, processing, and analytics.

**GenAI relevance:** Stream real-time data into GenAI applications. Ingest events for real-time inference with Bedrock. Process clickstream data for personalization.

**Key exam features:**
- **Kinesis Data Streams:** Low-latency data ingestion (shards, on-demand capacity)
- **Kinesis Data Firehose:** Deliver streaming data to S3, Redshift, OpenSearch, Splunk (near real-time, batched)
- **Kinesis Data Analytics:** SQL or Apache Flink for stream processing

**Common exam scenario:** "Real-time sentiment analysis on streaming social media data" → Kinesis Data Streams → Lambda → Bedrock InvokeModel → DynamoDB.

**Integration points:** Lambda, S3, OpenSearch, DynamoDB, Bedrock (via Lambda consumer).

---

### 2.5 Amazon OpenSearch Service

**What it does:** Managed search and analytics engine based on OpenSearch (Elasticsearch fork).

**GenAI relevance:** **Critical for vector search in RAG architectures.** OpenSearch Serverless with vector engine is a supported vector store for Bedrock Knowledge Bases.

**Key exam features:**
- **k-NN plugin:** Approximate k-nearest-neighbor search for vector similarity (HNSW, IVF, FAISS)
- **Neural plugin:** Integrates ML models directly into search pipelines (e.g., embed queries at search time)
- **Vector search:** Store and search embeddings for semantic search
- **OpenSearch Serverless:** No cluster management; collection types include vector search
- **Hybrid search:** Combine keyword (BM25) and vector search for better retrieval

**Common exam scenario:** "Build a semantic search engine for product descriptions" → OpenSearch with k-NN and Titan Embeddings.

**Integration points:** Bedrock Knowledge Bases (vector store), Lambda, Kinesis Data Firehose, S3.

---

### 2.6 Amazon QuickSight

**What it does:** Serverless business intelligence (BI) service for creating dashboards and visualizations.

**GenAI relevance:** Visualize model performance metrics, A/B test results, and usage analytics. QuickSight Q enables natural language queries on BI data.

**Key exam features:**
- SPICE (Super-fast Parallel In-memory Calculation Engine) for fast queries
- QuickSight Q: ask questions in natural language, get answers as visualizations
- ML-powered anomaly detection and forecasting
- Embedded dashboards in applications

**Common exam scenario:** "Dashboard showing Bedrock API usage, costs, and latency trends" → QuickSight connected to Athena over invocation logs.

**Integration points:** Athena, S3, Redshift, RDS, OpenSearch.

---

### 2.7 Amazon MSK (Managed Streaming for Apache Kafka)

**What it does:** Fully managed Apache Kafka service for building real-time streaming data pipelines.

**GenAI relevance:** Event-driven architectures feeding GenAI inference. Decouple data producers from ML consumers.

**Key exam features:**
- MSK Serverless: no capacity planning
- MSK Connect: managed Kafka Connect connectors
- Compatible with existing Kafka clients and tools

**Common exam scenario:** "Stream transaction events for real-time fraud detection using an FM" → MSK → Lambda consumer → Bedrock.

**Integration points:** Lambda, Kinesis Data Firehose, S3, OpenSearch.

---

## 3. APPLICATION INTEGRATION

---

### 3.1 Amazon AppFlow

**What it does:** Fully managed integration service for transferring data between SaaS applications and AWS services without code.

**GenAI relevance:** Ingest data from SaaS apps (Salesforce, Slack, Google Analytics, ServiceNow) into S3 for RAG knowledge bases or training data preparation.

**Key exam features:**
- Bi-directional data flows
- Data transformation (masking, filtering, mapping, validation)
- Scheduled or event-triggered flows
- Encryption with KMS, PrivateLink support

**Common exam scenario:** "Sync Salesforce case data to S3 for a Bedrock Knowledge Base" → AppFlow.

**Integration points:** S3, Redshift, Salesforce, ServiceNow, Slack, Zendesk, Bedrock Knowledge Base (via S3).

---

### 3.2 AWS AppConfig

**What it does:** Feature flags, operational configurations, and gradual deployments for applications.

**GenAI relevance:** Toggle GenAI features on/off, gradually roll out new model versions, manage prompt configurations without redeployment.

**Key exam features:**
- Deployment strategies (linear, exponential, all-at-once)
- Validators (JSON schema, Lambda)
- Rollback on alarm
- Feature flags with targeting rules

**Common exam scenario:** "Gradually roll out a new prompt template to 10% of users" → AppConfig feature flag with a linear deployment.

**Integration points:** Lambda, EC2, ECS, CloudWatch (alarm-based rollback).

---

### 3.3 Amazon EventBridge

**What it does:** Serverless event bus for building event-driven architectures. Routes events between AWS services, SaaS apps, and custom applications.

**GenAI relevance:** Trigger GenAI workflows based on events. Orchestrate async pipelines. Schedule Knowledge Base syncs.

**Key exam features:**
- Event patterns for filtering and routing
- Schema registry for event discovery
- Scheduled rules (cron/rate expressions)
- Event archive and replay
- Cross-account and cross-Region event delivery

**Common exam scenario:** "When a new document is uploaded to S3, trigger a Knowledge Base sync" → S3 → EventBridge → Lambda → StartIngestionJob.

**Integration points:** Lambda, Step Functions, SQS, SNS, S3, API Gateway, Bedrock (via Lambda).

---

### 3.4 Amazon SNS (Simple Notification Service)

**What it does:** Pub/sub messaging service for fan-out notifications to multiple subscribers.

**GenAI relevance:** Notify downstream systems when GenAI processing completes. Fan-out inference results to multiple consumers. Alert on guardrail violations.

**Key exam features:**
- Topics (Standard and FIFO)
- Subscribers: Lambda, SQS, HTTP/S, email, SMS
- Message filtering policies
- Server-side encryption with KMS

**Common exam scenario:** "Notify multiple teams when a Bedrock Guardrail blocks a response" → CloudWatch alarm → SNS topic → multiple subscribers.

**Integration points:** Lambda, SQS, CloudWatch, EventBridge, Step Functions.

---

### 3.5 Amazon SQS (Simple Queue Service)

**What it does:** Fully managed message queuing service for decoupling application components.

**GenAI relevance:** Buffer inference requests to handle traffic spikes. Decouple request ingestion from FM invocation. Dead-letter queues for failed inference attempts.

**Key exam features:**
- Standard queues (at-least-once, best-effort ordering) vs FIFO queues (exactly-once, ordered)
- Dead-letter queues (DLQ) for message failure handling
- Long polling to reduce empty responses
- Message visibility timeout
- Max message size 256 KB (use S3 Extended Client for larger payloads)

**Common exam scenario:** "Handle bursts of inference requests without losing any" → SQS queue → Lambda consumer → Bedrock InvokeModel.

**Integration points:** Lambda (event source mapping), SNS, Step Functions, EC2, ECS.

---

### 3.6 AWS Step Functions

**What it does:** Serverless visual workflow orchestrator for coordinating AWS services. **Critical service for GenAI orchestration.**

**GenAI relevance:** Orchestrate complex multi-step GenAI pipelines: document processing → embedding → retrieval → generation → post-processing. Handle error recovery and retry logic. Manage human-in-the-loop workflows.

**Key exam features:**
- **Standard workflows:** Long-running (up to 1 year), exactly-once execution, full history
- **Express workflows:** High-volume, short-duration (up to 5 minutes), at-least-once
- Direct SDK integrations: call Bedrock InvokeModel, Lambda, DynamoDB, S3, SageMaker, etc. directly from a step
- Parallel execution: run multiple steps concurrently
- Map state: dynamic parallelism over a list of items (process 1000 documents in parallel)
- Error handling: Retry, Catch, Timeout per step
- Wait state: pause for a duration or until a timestamp
- Choice state: conditional branching
- **Bedrock integration:** Native InvokeModel task for calling FMs from a workflow step

**Common exam scenarios:**
- "Process 10,000 documents: extract text, generate embeddings, store in vector DB" → Step Functions with Map state (parallel processing) calling Textract → Bedrock (embed) → OpenSearch
- "Orchestrate a multi-step GenAI pipeline with error handling" → Step Functions Standard workflow
- "Human approval before publishing AI-generated content" → Step Functions with a task token (callback pattern)

**Integration points:** Lambda, Bedrock, SageMaker, DynamoDB, S3, SNS, SQS, EventBridge, ECS, Textract, Comprehend.

---

## 4. COMPUTE

---

### 4.1 AWS App Runner

**What it does:** Fully managed service to build and deploy containerized web applications and APIs at scale, with no infrastructure to manage.

**GenAI relevance:** Deploy GenAI-powered web APIs from a container image or source code repository with automatic scaling and HTTPS.

**Key exam features:**
- Deploy from ECR image or GitHub source
- Automatic scaling (based on concurrent requests)
- Built-in HTTPS, load balancing
- VPC connector for private resources

**Common exam scenario:** "Deploy a simple GenAI chatbot API without managing infrastructure" → App Runner with a container calling Bedrock.

---

### 4.2 Amazon EC2

**What it does:** Virtual servers in the cloud with full control over instance type, OS, and configuration.

**GenAI relevance:** Run self-hosted LLMs on GPU instances (P4d, P5, G5, Inf2). Custom inference servers (vLLM, TGI). Training workloads requiring specialized hardware.

**Key exam features:**
- GPU instance families: P4d/P5 (NVIDIA A100/H100), G5 (A10G), Inf2 (Inferentia2), Trn1 (Trainium)
- Spot instances for cost-effective training
- Placement groups for low-latency GPU communication
- EFA (Elastic Fabric Adapter) for distributed training

**Common exam scenario:** "Need maximum control over model hosting with custom CUDA kernels" → EC2 GPU instances.

**Integration points:** EBS, S3, VPC, Auto Scaling, ELB, SageMaker (as underlying compute).

---

### 4.3 AWS Lambda

**What it does:** Serverless compute that runs code in response to events without provisioning servers. **Critical for GenAI architectures.**

**GenAI relevance:** Glue layer in every serverless GenAI architecture. Process events, call Bedrock APIs, transform data, implement business logic for agents.

**Key exam features:**
- Max 15-minute execution time, 10 GB memory, 10 GB ephemeral storage
- Event source mappings: SQS, Kinesis, DynamoDB Streams, MSK
- Lambda layers for shared code and dependencies
- Lambda function URLs for simple HTTPS endpoints
- Provisioned concurrency to avoid cold starts
- Lambda extensions for monitoring/observability
- Container image support (up to 10 GB)
- Supports Python, Node.js, Java, .NET, Go, Ruby, custom runtimes

**Common exam scenarios:**
- "Bedrock Agent action group needs to query a database" → Lambda function
- "Process S3 upload and trigger embedding generation" → S3 event → Lambda → Bedrock Titan Embeddings → OpenSearch
- "API Gateway frontend for a Bedrock chatbot" → API Gateway → Lambda → Bedrock Converse API
- "SQS consumer for async inference" → SQS → Lambda → Bedrock InvokeModel → DynamoDB

**Integration points:** API Gateway, S3, SQS, SNS, DynamoDB, EventBridge, Step Functions, Bedrock, SageMaker, Kinesis, OpenSearch.

---

### 4.4 Lambda@Edge

**What it does:** Run Lambda functions at CloudFront edge locations for request/response manipulation.

**GenAI relevance:** Lightweight pre-processing at the edge (input validation, request routing) before forwarding to GenAI backends. A/B testing model endpoints.

**Key exam features:**
- Runs in CloudFront edge locations worldwide
- Triggered by CloudFront events (viewer request/response, origin request/response)
- Max 5-second execution (viewer), 30-second (origin)
- Node.js and Python runtimes

**Common exam scenario:** "Route users to different model endpoints based on geography" → Lambda@Edge on CloudFront.

---

### 4.5 AWS Outposts

**What it does:** Run AWS infrastructure on-premises for workloads with low-latency or data residency requirements.

**GenAI relevance:** Run inference on-premises when data cannot leave the facility. Deploy SageMaker endpoints on Outposts.

**Key exam features:**
- Fully managed by AWS but hosted in your data center
- Supports EC2, EBS, S3, ECS, EKS, RDS, SageMaker
- Connected to the nearest AWS Region

**Common exam scenario:** "Data sovereignty requires inference to happen on-premises" → SageMaker endpoint on Outposts or EC2 GPU on Outposts.

---

### 4.6 AWS Wavelength

**What it does:** Deploy compute at the edge of 5G networks for ultra-low-latency applications.

**GenAI relevance:** Real-time GenAI inference at the mobile edge (AR/VR, autonomous vehicles, real-time translation).

**Key exam features:**
- Wavelength Zones embedded in telecom provider networks
- Single-digit millisecond latency to mobile devices
- Supports EC2, EBS, VPC, ECS, EKS

**Common exam scenario:** "Real-time AI inference for a mobile AR application with <10ms latency" → Wavelength Zone deployment.

---

## 5. CONTAINERS

---

### 5.1 Amazon ECR (Elastic Container Registry)

**What it does:** Fully managed Docker container registry for storing, managing, and deploying container images.

**GenAI relevance:** Store custom inference container images for SageMaker endpoints, ECS tasks, or EKS pods.

**Key exam features:**
- Private and public repositories
- Image vulnerability scanning (basic + enhanced with Inspector)
- Lifecycle policies for image cleanup
- Cross-Region and cross-account replication
- OCI artifact support

**Integration points:** ECS, EKS, Lambda (container images), SageMaker, App Runner, CodeBuild.

---

### 5.2 Amazon ECS (Elastic Container Service)

**What it does:** Fully managed container orchestration service for running Docker containers.

**GenAI relevance:** Run containerized GenAI inference services, data processing pipelines, and web applications.

**Key exam features:**
- Launch types: EC2 (you manage instances) or Fargate (serverless)
- Task definitions specify containers, resources, networking
- Service auto-scaling based on CPU, memory, or custom metrics
- Service Connect for service-to-service communication
- GPU support on EC2 launch type

**Common exam scenario:** "Deploy a custom LLM inference server as a long-running service" → ECS on EC2 with GPU instances.

**Integration points:** ECR, ALB, CloudWatch, Fargate, Step Functions, EventBridge.

---

### 5.3 Amazon EKS (Elastic Kubernetes Service)

**What it does:** Managed Kubernetes service for running containerized workloads.

**GenAI relevance:** Run GPU-based ML inference workloads on Kubernetes. Leverage Kubernetes ecosystem tools (KServe, NVIDIA Triton) for model serving.

**Key exam features:**
- Managed control plane
- Node groups: managed, self-managed, Fargate profiles
- GPU node groups for inference/training
- EKS Anywhere for on-premises
- Add-ons marketplace

**Common exam scenario:** "Team uses Kubernetes and wants to deploy ML inference with GPU nodes" → EKS with GPU node groups.

**Integration points:** ECR, ALB, CloudWatch, Fargate, IAM (IRSA), S3.

---

### 5.4 AWS Fargate

**What it does:** Serverless compute engine for containers — run containers without managing servers.

**GenAI relevance:** Run containerized GenAI tasks (data processing, lightweight inference) without managing EC2 instances.

**Key exam features:**
- Works with both ECS and EKS
- Per-vCPU and per-GB memory pricing
- No GPU support (use EC2 launch type for GPUs)
- Spot Fargate for cost savings on fault-tolerant tasks

**Common exam scenario:** "Run a batch document processing pipeline in containers without managing servers" → Fargate task (no GPU needed).

---

## 6. DATABASE

---

### 6.1 Amazon Aurora

**What it does:** MySQL- and PostgreSQL-compatible relational database with up to 5x throughput of standard MySQL and 3x of PostgreSQL.

**GenAI relevance:** **Aurora PostgreSQL with pgvector extension is a supported vector store for Bedrock Knowledge Bases.** Store and query embeddings directly in your relational database alongside structured data.

**Key exam features:**
- **pgvector:** PostgreSQL extension for vector similarity search (L2, cosine, inner product distances)
- Aurora Serverless v2: auto-scales compute
- Up to 128 TB auto-scaling storage
- Multi-AZ with read replicas
- Global Database for cross-Region replication

**Common exam scenarios:**
- "Already using Aurora PostgreSQL; want to add vector search for RAG" → Enable pgvector extension
- "Need vector search alongside transactional data" → Aurora with pgvector (avoids a separate vector DB)

**Integration points:** Bedrock Knowledge Bases, Lambda, SageMaker, RDS Proxy, Secrets Manager.

---

### 6.2 Amazon DocumentDB

**What it does:** MongoDB-compatible managed document database.

**GenAI relevance:** Store semi-structured data (JSON documents) for GenAI applications. Supports vector search for MongoDB-compatible workloads.

**Key exam features:**
- MongoDB compatibility (wire protocol)
- Scales to 64 TB, up to 15 read replicas
- Vector search support (as of 2024)
- Automatic backups, encryption at rest

**Common exam scenario:** "Migrate a MongoDB-based RAG application to AWS" → DocumentDB with vector search.

---

### 6.3 Amazon DynamoDB

**What it does:** Fully managed, serverless NoSQL key-value and document database with single-digit millisecond performance at any scale.

**GenAI relevance:** Store conversation history, session state, user preferences, and metadata for GenAI applications. DynamoDB Streams trigger event-driven workflows.

**Key exam features:**
- On-demand and provisioned capacity modes
- **DynamoDB Streams:** Capture item-level changes in near real-time (trigger Lambda on data changes)
- Global tables for multi-Region replication
- TTL (Time to Live) for automatic item expiration
- DAX (DynamoDB Accelerator) for microsecond read caching
- PartiQL for SQL-like queries

**Common exam scenarios:**
- "Store chat history for a Bedrock-powered chatbot" → DynamoDB table with sessionId as partition key
- "Trigger re-embedding when a document record changes" → DynamoDB Streams → Lambda → Bedrock embed
- "Low-latency metadata store for retrieval results" → DynamoDB

**Integration points:** Lambda (event source mapping via Streams), API Gateway, Step Functions, S3, EventBridge Pipes.

---

### 6.4 Amazon ElastiCache

**What it does:** Managed in-memory data store (Redis or Memcached) for caching and real-time workloads.

**GenAI relevance:** Cache FM responses to reduce latency and cost for repeated queries. Semantic caching: store embeddings of previous queries and return cached results for similar queries.

**Key exam features:**
- Redis: data structures, pub/sub, persistence, replication, Lua scripting, vector search (Redis Stack)
- Memcached: simple key-value caching, multi-threaded
- Serverless option available
- Sub-millisecond latency

**Common exam scenarios:**
- "Reduce Bedrock API costs for frequently asked questions" → ElastiCache semantic cache
- "Cache retrieved knowledge base results" → ElastiCache Redis

**Integration points:** Lambda, EC2, ECS, EKS, Bedrock (via application code).

---

### 6.5 Amazon Neptune

**What it does:** Fully managed graph database supporting property graph (Gremlin, openCypher) and RDF (SPARQL).

**GenAI relevance:** Store knowledge graphs for GraphRAG — combine structured graph relationships with vector search for richer context retrieval. Neptune ML for graph-based predictions.

**Key exam features:**
- Supports billions of relationships
- Neptune ML: graph neural networks on Neptune data
- Neptune Analytics: for graph algorithms and vector search
- Full-text search integration

**Common exam scenario:** "Enrich RAG with entity relationships from a knowledge graph" → Neptune for graph storage + Bedrock for generation (GraphRAG pattern).

**Integration points:** Lambda, SageMaker (Neptune ML), S3, Bedrock (via Lambda).

---

### 6.6 Amazon RDS

**What it does:** Managed relational database service supporting MySQL, PostgreSQL, MariaDB, Oracle, SQL Server.

**GenAI relevance:** Store structured data referenced by GenAI applications. RDS PostgreSQL supports pgvector for vector search (though Aurora is preferred for scale).

**Key exam features:**
- Multi-AZ for high availability
- Read replicas for read scaling
- Automated backups and snapshots
- RDS Proxy for connection pooling (great with Lambda)
- pgvector on PostgreSQL

**Common exam scenario:** "Lambda functions connecting to RDS time out due to connection limits" → RDS Proxy.

**Integration points:** Lambda, RDS Proxy, Secrets Manager, CloudWatch, S3 (export).

---

## 7. DEVELOPER TOOLS

---

### 7.1 AWS Amplify

**What it does:** Full-stack development platform for building web and mobile apps with cloud backends.

**GenAI relevance:** Quickly build and deploy GenAI-powered web applications with authentication, API, and hosting. Amplify AI kit provides React components for chat UIs connected to Bedrock.

**Key exam features:**
- Amplify Hosting: CI/CD for frontend apps (Git-based)
- Amplify Backend: auth, API (GraphQL/REST), storage, functions
- Amplify AI Kit: pre-built AI/ML components
- Framework support: React, Next.js, Vue, Angular, Flutter

**Common exam scenario:** "Rapidly build a GenAI chatbot web app with user authentication" → Amplify (hosting + auth + Bedrock backend via Lambda).

---

### 7.2 AWS CDK (Cloud Development Kit)

**What it does:** Define cloud infrastructure using familiar programming languages (TypeScript, Python, Java, C#, Go).

**GenAI relevance:** Infrastructure-as-code for GenAI architectures. Define Bedrock agents, knowledge bases, Lambda functions, and API Gateway resources programmatically.

**Key exam features:**
- Constructs: L1 (CloudFormation resources), L2 (higher-level), L3 (patterns/solutions)
- Synthesizes to CloudFormation templates
- `cdk deploy` for deployment, `cdk diff` for change preview
- Construct Hub for community constructs

---

### 7.3 AWS CLI

**What it does:** Unified command-line interface for managing AWS services.

**GenAI relevance:** Automate Bedrock operations (invoke models, manage agents, trigger knowledge base sync), scripting for CI/CD.

**Key exam features:**
- Supports all AWS services
- Profiles for multiple accounts
- Output formats: JSON, text, table
- Pagination and waiters

---

### 7.4 AWS CloudFormation

**What it does:** Infrastructure-as-code service using JSON/YAML templates to provision AWS resources.

**GenAI relevance:** Declarative templates to deploy GenAI stacks (Bedrock resources, Lambda, API Gateway, DynamoDB, OpenSearch).

**Key exam features:**
- Stacks, nested stacks, stack sets (multi-account)
- Change sets for preview before deployment
- Drift detection
- Rollback on failure
- Custom resources (Lambda-backed)

---

### 7.5 AWS CodeArtifact

**What it does:** Managed artifact repository for software packages (npm, PyPI, Maven, NuGet).

**GenAI relevance:** Store and manage private Python packages (e.g., custom LLM wrappers, embedding utilities) used across GenAI projects.

**Key exam features:**
- Upstream repository chaining (proxy to public registries)
- Domain-level and repository-level permissions
- Package versioning and retention policies

---

### 7.6 AWS CodeBuild

**What it does:** Fully managed continuous integration service that compiles code, runs tests, and produces artifacts.

**GenAI relevance:** Build and test GenAI application code. Build custom Docker images for SageMaker or ECS inference containers.

**Key exam features:**
- Build from CodeCommit, GitHub, Bitbucket, S3
- Custom build environments (Docker images)
- Buildspec.yml defines build steps
- Caching (S3, local) for faster builds
- Reports: test results, code coverage

---

### 7.7 AWS CodeDeploy

**What it does:** Automates application deployments to EC2, ECS, Lambda, and on-premises servers.

**GenAI relevance:** Blue/green and canary deployments for GenAI application updates. Safe model endpoint updates.

**Key exam features:**
- Deployment types: in-place, blue/green
- Deployment configurations: all-at-once, half-at-a-time, one-at-a-time, canary, linear
- Automatic rollback on failure or CloudWatch alarm
- Lambda deployment: traffic shifting (canary, linear, all-at-once)

**Common exam scenario:** "Safely deploy a new version of our GenAI API with gradual traffic shift" → CodeDeploy with canary deployment on Lambda/ECS.

---

### 7.8 AWS CodePipeline

**What it does:** Fully managed CI/CD pipeline service that automates build, test, and deploy stages.

**GenAI relevance:** End-to-end CI/CD for GenAI applications. Pipeline: Source → Build → Test → Deploy model + application.

**Key exam features:**
- Source: CodeCommit, GitHub, S3, ECR
- Build: CodeBuild
- Deploy: CodeDeploy, CloudFormation, ECS, S3, Lambda
- Manual approval actions (human gate before production)
- Parallel and sequential stages

**Common exam scenario:** "Automate deployment of updated Bedrock agent configuration" → CodePipeline (Source → Build → Deploy via CloudFormation).

---

### 7.9 AWS Tools and SDKs

**What it does:** SDKs for programmatically interacting with AWS services from various languages (Python/Boto3, JavaScript, Java, .NET, Go, Ruby, etc.).

**GenAI relevance:** Boto3 (Python) is the primary SDK for Bedrock API calls. All Bedrock examples in documentation use Boto3. Know the `bedrock-runtime` client vs the `bedrock` client.

**Key exam features:**
- `bedrock-runtime` client: InvokeModel, InvokeModelWithResponseStream, Converse, ConverseStream
- `bedrock-agent-runtime` client: InvokeAgent, Retrieve, RetrieveAndGenerate
- `bedrock` client: management operations (create agent, create knowledge base, etc.)
- Automatic retries, pagination, waiters
- Credential provider chain

---

### 7.10 AWS X-Ray

**What it does:** Distributed tracing service for analyzing and debugging production applications.

**GenAI relevance:** Trace GenAI request flows end-to-end: API Gateway → Lambda → Bedrock → DynamoDB. Identify latency bottlenecks in multi-step GenAI pipelines.

**Key exam features:**
- Trace map: visual representation of service dependencies
- Segments and subsegments for fine-grained timing
- Annotations (indexed) and metadata (not indexed) for filtering
- Sampling rules to control tracing volume
- Integration with Lambda, API Gateway, ECS, EC2

**Common exam scenario:** "GenAI API is slow — need to find the bottleneck" → X-Ray trace map showing latency per service hop.

**Integration points:** Lambda, API Gateway, ECS, EC2, CloudWatch ServiceLens.

---

## 8. MANAGEMENT AND GOVERNANCE

---

### 8.1 AWS Auto Scaling

**What it does:** Automatically scale AWS resources based on demand.

**GenAI relevance:** Scale Lambda concurrency, ECS tasks, DynamoDB capacity, or SageMaker endpoints based on inference demand.

**Key exam features:**
- Target tracking, step, and scheduled scaling policies
- Predictive scaling based on historical patterns
- Application Auto Scaling: covers DynamoDB, ECS, SageMaker endpoints, Lambda provisioned concurrency, and more

**Common exam scenario:** "SageMaker endpoint needs to handle variable inference traffic" → Application Auto Scaling on the endpoint variant.

---

### 8.2 AWS Chatbot

**What it does:** Interactive agent that routes AWS notifications to Slack and Microsoft Teams channels.

**GenAI relevance:** Receive GenAI pipeline alerts (CloudWatch alarms, CodePipeline failures, Cost Anomaly alerts) directly in team chat. Run AWS CLI commands from Slack.

**Key exam features:**
- Integrates with SNS topics, CloudWatch alarms, EventBridge
- Run read-only or approved AWS CLI commands from chat
- Channel-level IAM permissions

---

### 8.3 AWS CloudTrail

**What it does:** Records API calls and account activity across your AWS infrastructure for auditing and compliance.

**GenAI relevance:** Audit who called Bedrock APIs, when, and from where. Track model access, agent creation, and knowledge base modifications. Essential for compliance.

**Key exam features:**
- Management events (control plane) and data events (data plane)
- Trail can deliver to S3 and CloudWatch Logs
- CloudTrail Lake: SQL-based query and analysis of events
- Multi-Region and organization-wide trails
- Event history: 90 days of management events free

**Common exam scenario:** "Audit which IAM users invoked Bedrock models" → CloudTrail data events for Bedrock.

**Integration points:** S3, CloudWatch Logs, EventBridge, Athena (query CloudTrail logs in S3).

---

### 8.4 Amazon CloudWatch

**What it does:** Monitoring and observability service for AWS resources and applications.

**GenAI relevance:** Monitor Bedrock invocation metrics (latency, errors, throttling), Lambda performance, and custom application metrics. Central logging for GenAI pipelines.

**Key exam features:**
- **CloudWatch Metrics:** Built-in metrics for all AWS services + custom metrics. Bedrock publishes Invocations, InvocationLatency, InvocationClientErrors, InvocationServerErrors, ModelInputTokenCount, ModelOutputTokenCount.
- **CloudWatch Logs:** Centralized log storage. Store Bedrock model invocation logs, Lambda logs, application logs.
- **CloudWatch Alarms:** Alert on metric thresholds (e.g., Bedrock error rate > 5%)
- **CloudWatch Dashboards:** Visualize metrics and logs
- **CloudWatch Logs Insights:** Query and analyze logs with a purpose-built query language
- **CloudWatch Synthetics:** Canary scripts that monitor API endpoints (test GenAI APIs proactively)
- **Contributor Insights:** Identify top contributors to metrics (top callers, top error sources)

**Common exam scenarios:**
- "Alert when Bedrock throttling exceeds a threshold" → CloudWatch alarm on ThrottledCount metric
- "Proactively test our GenAI API every 5 minutes" → CloudWatch Synthetics canary
- "Analyze patterns in model invocation logs" → CloudWatch Logs Insights queries

**Integration points:** SNS (alarm notifications), Lambda (alarm actions), EventBridge, X-Ray, Grafana.

---

### 8.5 AWS Cost Anomaly Detection

**What it does:** Uses ML to detect unusual spending patterns and sends alerts.

**GenAI relevance:** Detect unexpected spikes in Bedrock usage costs (e.g., runaway inference loop, unexpected traffic). Early warning for cost overruns.

**Key exam features:**
- ML-based anomaly detection (no manual threshold setting)
- Alert via SNS or email
- Root cause analysis
- Monitor by service, linked account, cost category, or cost allocation tag

**Common exam scenario:** "Bedrock costs spiked 10x overnight — need early detection" → Cost Anomaly Detection monitor for Bedrock service.

---

### 8.6 AWS Cost Explorer

**What it does:** Visualize, understand, and manage AWS costs and usage over time.

**GenAI relevance:** Analyze Bedrock spending by model, Region, and time period. Forecast future GenAI costs. Identify cost optimization opportunities.

**Key exam features:**
- Daily and monthly granularity
- Filter and group by service, Region, tag, usage type
- Savings Plans and Reserved Instance recommendations
- Forecast future spending
- API for programmatic cost analysis

---

### 8.7 Amazon Managed Grafana

**What it does:** Fully managed Grafana service for operational dashboards and observability.

**GenAI relevance:** Build custom operational dashboards for GenAI systems combining metrics from CloudWatch, Prometheus, X-Ray, and other sources.

**Key exam features:**
- Built-in data sources: CloudWatch, Prometheus, X-Ray, Athena, Redshift, OpenSearch
- Workspace-level access control via IAM Identity Center
- Alerting and notification channels

---

### 8.8 AWS Service Catalog

**What it does:** Create and manage curated catalogs of approved IT resources.

**GenAI relevance:** Provide pre-approved GenAI infrastructure templates (Bedrock configurations, SageMaker endpoints) to development teams. Governance and standardization.

**Key exam features:**
- Products: CloudFormation templates
- Portfolios: collections of products
- Constraints: launch, notification, tag
- Self-service provisioning with guardrails

---

### 8.9 AWS Systems Manager

**What it does:** Operations hub for managing AWS resources at scale.

**GenAI relevance:** Store and manage configuration for GenAI applications. Parameter Store for prompts, model IDs, and API keys. Automate operational tasks.

**Key exam features:**
- **Parameter Store:** Hierarchical storage for configuration and secrets. Store prompt templates, model IDs, feature flags. Free for standard parameters.
- **Session Manager:** Secure shell access without SSH keys
- **Run Command:** Execute commands across fleets
- **Automation:** Runbooks for operational workflows
- **Patch Manager:** Automated patching

**Common exam scenario:** "Store model configuration and prompt templates that change frequently" → Systems Manager Parameter Store (or Secrets Manager for sensitive values).

---

### 8.10 AWS Well-Architected Tool

**What it does:** Review workloads against AWS Well-Architected Framework best practices across six pillars.

**GenAI relevance:** Evaluate GenAI architectures for operational excellence, security, reliability, performance, cost optimization, and sustainability. ML-specific lens available.

**Key exam features:**
- Six pillars: Operational Excellence, Security, Reliability, Performance Efficiency, Cost Optimization, Sustainability
- Custom lenses (e.g., ML lens, GenAI lens)
- Improvement plans with prioritized recommendations

---

## 9. NETWORKING AND CONTENT DELIVERY

---

### 9.1 Amazon API Gateway

**What it does:** Fully managed service for creating, publishing, and managing APIs at any scale. **Critical for exposing GenAI applications.**

**GenAI relevance:** Front-door for GenAI APIs. Handles authentication, throttling, request/response transformation, and API versioning for Bedrock-powered applications.

**Key exam features:**
- **REST API:** Full-featured API management (resource-based, request validation, caching, WAF integration, usage plans/API keys)
- **HTTP API:** Low-latency, low-cost (JWT authorizers, Lambda proxy, simpler)
- **WebSocket API:** Real-time bidirectional communication (essential for streaming chat interfaces)
- Authorizers: IAM, Cognito, Lambda custom authorizer
- Throttling: account-level (10K RPS default), stage/method overrides, usage plans per API key
- Request/response transformation with mapping templates
- Canary deployments for safe API updates
- Integration types: Lambda proxy, HTTP proxy, AWS service proxy, Mock

**Common exam scenarios:**
- "Expose a Bedrock chatbot via a streaming API" → API Gateway WebSocket API → Lambda → Bedrock ConverseStream
- "Rate-limit third-party API consumers" → API Gateway with usage plans and API keys
- "Authenticate users before calling the GenAI API" → API Gateway with Cognito authorizer
- "Need request validation before sending to the model" → API Gateway request validators or Lambda authorizer

**Integration points:** Lambda, Cognito, WAF, CloudWatch, X-Ray, CloudFront, Step Functions.

---

### 9.2 AWS AppSync

**What it does:** Managed GraphQL and Pub/Sub API service with real-time data synchronization.

**GenAI relevance:** Build real-time GenAI-powered applications with subscriptions (e.g., stream model responses to clients in real-time). Merge data from multiple sources in a single GraphQL query.

**Key exam features:**
- GraphQL and Merged APIs
- Real-time subscriptions (WebSocket-based)
- Resolvers: Lambda, DynamoDB, OpenSearch, HTTP, RDS
- Caching, conflict resolution, offline support
- Pipeline resolvers for chaining multiple data sources

**Common exam scenario:** "Frontend needs real-time streaming of GenAI responses with GraphQL" → AppSync subscription.

---

### 9.3 Amazon CloudFront

**What it does:** Global content delivery network (CDN) for low-latency content distribution.

**GenAI relevance:** Cache and distribute GenAI application frontends. Reduce latency for API responses. DDoS protection (integrated with Shield).

**Key exam features:**
- Edge locations worldwide
- Origin types: S3, ALB, API Gateway, custom HTTP origin
- Cache behaviors and policies
- Origin Access Control (OAC) for S3
- Lambda@Edge and CloudFront Functions for edge compute
- Field-level encryption

**Common exam scenario:** "Reduce latency for our global GenAI chatbot web app" → CloudFront in front of S3 (static assets) + API Gateway (API calls).

---

### 9.4 Elastic Load Balancing (ELB)

**What it does:** Distribute incoming traffic across multiple targets (EC2, containers, IPs, Lambda).

**GenAI relevance:** Load-balance traffic to containerized inference services or SageMaker endpoints. Health checks ensure only healthy inference servers receive traffic.

**Key exam features:**
- **Application Load Balancer (ALB):** HTTP/HTTPS, path/host-based routing, gRPC support, Lambda target, WebSocket support
- **Network Load Balancer (NLB):** TCP/UDP, ultra-low latency, static IP, PrivateLink support
- **Gateway Load Balancer (GWLB):** Transparent network appliance insertion
- Target groups, health checks, sticky sessions
- SSL/TLS termination

---

### 9.5 AWS Global Accelerator

**What it does:** Network layer service that improves global application availability and performance using the AWS global network.

**GenAI relevance:** Improve performance for globally distributed GenAI APIs by routing traffic over the AWS backbone instead of the public internet.

**Key exam features:**
- Static anycast IP addresses
- Endpoint groups across Regions
- Health checks and automatic failover
- TCP/UDP traffic acceleration

---

### 9.6 AWS PrivateLink

**What it does:** Provides private connectivity between VPCs and AWS services without traversing the public internet.

**GenAI relevance:** **Call Bedrock APIs privately** without going over the internet. Keep GenAI inference traffic within the AWS network for security-sensitive workloads.

**Key exam features:**
- Interface VPC endpoints (powered by PrivateLink)
- Gateway endpoints (S3 and DynamoDB only)
- Endpoint policies for access control
- DNS resolution to private IPs

**Common exam scenario:** "Call Bedrock from a Lambda in a VPC without internet access" → VPC endpoint for Bedrock Runtime via PrivateLink.

**Integration points:** Bedrock, SageMaker, S3, DynamoDB, Secrets Manager, and most other AWS services.

---

### 9.7 Amazon Route 53

**What it does:** Highly available DNS service and domain registrar.

**GenAI relevance:** DNS routing for GenAI application domains. Latency-based routing to direct users to the nearest inference Region.

**Key exam features:**
- Routing policies: simple, weighted, latency-based, failover, geolocation, multivalue, geoproximity
- Health checks and DNS failover
- Alias records for AWS resources
- Private hosted zones (VPC DNS)

**Common exam scenario:** "Route users to the lowest-latency Bedrock Region" → Route 53 latency-based routing.

---

### 9.8 Amazon VPC

**What it does:** Logically isolated virtual network in AWS to deploy resources.

**GenAI relevance:** Network isolation for GenAI infrastructure. Deploy Lambda, SageMaker endpoints, and databases in private subnets. Security groups and NACLs for defense-in-depth.

**Key exam features:**
- Subnets (public/private), route tables, internet gateway, NAT gateway
- Security groups (stateful) and NACLs (stateless)
- VPC peering, Transit Gateway
- VPC Flow Logs for network monitoring
- VPC endpoints for private access to AWS services

**Common exam scenario:** "Secure a GenAI application: Lambda in private subnet, Bedrock via VPC endpoint, no internet access" → VPC with private subnets + VPC endpoints for Bedrock, S3, DynamoDB.

---

## 10. SECURITY, IDENTITY, AND COMPLIANCE

---

### 10.1 Amazon Cognito

**What it does:** User authentication and authorization service for web and mobile applications.

**GenAI relevance:** Authenticate users of GenAI applications. Manage user pools and federated identities. Issue JWT tokens consumed by API Gateway authorizers.

**Key exam features:**
- **User Pools:** User directory with sign-up/sign-in, MFA, password policies, hosted UI, social and SAML federation, JWT tokens (ID, access, refresh)
- **Identity Pools (Federated Identities):** Exchange tokens for temporary AWS credentials (access AWS services directly from client)
- Custom attributes, groups, and triggers (Lambda)
- Advanced security: adaptive authentication, compromised credential detection

**Common exam scenarios:**
- "Authenticate users of our GenAI chatbot" → Cognito User Pool + API Gateway Cognito authorizer
- "Users need temporary AWS credentials to upload files to S3" → Cognito Identity Pool
- "Federate with corporate SAML IdP for single sign-on" → Cognito User Pool with SAML federation

**Integration points:** API Gateway, ALB, Lambda (triggers), S3, DynamoDB, Amplify.

---

### 10.2 AWS Encryption SDK

**What it does:** Client-side encryption library for encrypting data before sending to AWS services.

**GenAI relevance:** Encrypt sensitive data (PII, proprietary documents) before storing in S3 for RAG knowledge bases. Client-side encryption of prompts/responses in transit and at rest.

**Key exam features:**
- Envelope encryption (data key encrypted by a master key)
- Multi-keyring support (encrypt with multiple KMS keys)
- Message format with embedded metadata
- Available for Java, Python, CLI, JavaScript, .NET, Go

**Common exam scenario:** "Encrypt documents client-side before uploading to S3 for the knowledge base" → Encryption SDK with KMS key.

---

### 10.3 AWS IAM (Identity and Access Management)

**What it does:** Manage access to AWS services and resources securely. **Fundamental to every AWS service.**

**GenAI relevance:** Control who can invoke Bedrock models, create agents, access knowledge bases. Least-privilege permissions for Lambda execution roles. Service-linked roles for Bedrock.

**Key exam features:**
- **Policies:** Identity-based (attached to users/roles/groups), resource-based (attached to resources), permission boundaries, SCPs
- **Roles:** Assumed by services (Lambda, Bedrock, SageMaker), cross-account, federation
- **Conditions:** Restrict by IP, time, MFA, tags, VPC endpoint, source VPC
- **IAM Access Analyzer:** Identify resources shared externally, validate policies, generate least-privilege policies from CloudTrail activity
- **IAM Identity Center (SSO):** Centralized access management across AWS accounts and applications. SAML 2.0 federation.

**Common exam scenarios:**
- "Lambda function needs to call Bedrock InvokeModel" → Lambda execution role with `bedrock:InvokeModel` permission
- "Restrict Bedrock model access to specific models" → IAM policy with `Resource` specifying model ARNs
- "Audit external access to S3 buckets containing training data" → IAM Access Analyzer
- "Manage developer access across multiple AWS accounts" → IAM Identity Center

**Integration points:** Every AWS service. Bedrock, SageMaker, Lambda, S3, DynamoDB, API Gateway, KMS.

---

### 10.4 AWS KMS (Key Management Service)

**What it does:** Create and manage encryption keys for data protection across AWS services.

**GenAI relevance:** Encrypt data at rest in S3 (training data, knowledge base documents), DynamoDB (conversation history), OpenSearch (vector store). Encrypt Bedrock model invocation logs.

**Key exam features:**
- **Key types:** AWS managed keys, customer managed keys (CMK), AWS owned keys
- **Symmetric vs asymmetric keys**
- Key policies + IAM policies for access control
- Automatic key rotation (1 year for CMKs)
- Grants for temporary access
- Envelope encryption pattern
- Multi-Region keys for cross-Region encryption

**Common exam scenario:** "Encrypt Bedrock Knowledge Base data with a customer-managed key" → KMS CMK referenced in the Bedrock Knowledge Base configuration.

**Integration points:** S3, DynamoDB, EBS, RDS, OpenSearch, SQS, SNS, Lambda, Secrets Manager, Bedrock.

---

### 10.5 Amazon Macie

**What it does:** ML-powered service that discovers and protects sensitive data in S3.

**GenAI relevance:** Scan S3 buckets containing training data or knowledge base documents for sensitive data (PII, financial data, credentials) before feeding to FMs.

**Key exam features:**
- Automated sensitive data discovery (PII, financial, credentials, custom patterns)
- S3 bucket inventory and security posture
- Policy findings (unencrypted, public, shared buckets)
- Integration with Security Hub
- Custom data identifiers (regex + keywords)

**Common exam scenario:** "Ensure no PII exists in documents uploaded to the Knowledge Base S3 bucket" → Macie scan on the bucket.

**Integration points:** S3, EventBridge (findings trigger actions), Security Hub, Step Functions.

---

### 10.6 AWS Secrets Manager

**What it does:** Securely store, rotate, and retrieve secrets (database credentials, API keys, tokens).

**GenAI relevance:** Store third-party API keys (e.g., external model providers), database credentials for vector stores, application secrets used by GenAI services.

**Key exam features:**
- Automatic rotation (Lambda-based)
- Cross-Region replication
- Fine-grained IAM and resource policies
- Integration with RDS, Redshift, DocumentDB for native rotation
- Versioning (AWSCURRENT, AWSPREVIOUS)

**Common exam scenario:** "Lambda function needs to retrieve database credentials for the vector store" → Secrets Manager with Lambda rotation.

**Integration points:** Lambda, RDS, Aurora, Redshift, DocumentDB, ECS (environment variables), CloudFormation.

---

### 10.7 AWS WAF (Web Application Firewall)

**What it does:** Protects web applications from common web exploits (SQL injection, XSS, bots, DDoS).

**GenAI relevance:** Protect GenAI API endpoints from abuse, injection attacks, and bot traffic. Rate-limit API calls per IP.

**Key exam features:**
- Web ACLs with rules: IP sets, rate-based rules, regex patterns, geo-match, SQL injection/XSS detection
- Managed rule groups (AWS, Marketplace)
- Bot Control (common bots, targeted bot protection)
- Integrates with ALB, API Gateway, CloudFront, AppSync
- Custom response bodies for blocked requests
- Logging to S3, CloudWatch Logs, Kinesis Data Firehose

**Common exam scenarios:**
- "Rate-limit users of our GenAI API to prevent abuse" → WAF rate-based rule on API Gateway
- "Block prompt injection attempts at the API layer" → WAF custom rule with regex matching + Bedrock Guardrails as secondary defense

**Integration points:** API Gateway, CloudFront, ALB, AppSync, CloudWatch.

---

## 11. STORAGE

---

### 11.1 Amazon EBS (Elastic Block Store)

**What it does:** Block storage volumes for EC2 instances, providing persistent storage for running instances.

**GenAI relevance:** Storage for self-hosted model weights on GPU EC2 instances. High-throughput io2 volumes for model loading.

**Key exam features:**
- Volume types: gp3 (general), io2 (high IOPS), st1 (throughput), sc1 (cold)
- Snapshots to S3 for backup
- Multi-Attach (io2 only)
- Encryption with KMS

**Common exam scenario:** "Store a 70B parameter model on a GPU instance" → EBS io2 volume for fast model weight loading.

---

### 11.2 Amazon EFS (Elastic File System)

**What it does:** Serverless, fully managed NFS file system for shared file storage across multiple instances and containers.

**GenAI relevance:** Shared file system for model artifacts accessed by multiple Lambda functions or ECS tasks. Lambda file system mount point for large ML libraries.

**Key exam features:**
- POSIX-compatible, supports NFS v4
- Elastic throughput (auto-scales)
- Standard and Infrequent Access storage classes
- Lambda mount targets (access from Lambda functions)
- Multi-AZ and One Zone options

**Common exam scenario:** "Multiple Lambda functions need to access the same large ML model file" → EFS mounted to Lambda functions.

**Integration points:** Lambda, EC2, ECS, EKS, SageMaker.

---

### 11.3 Amazon S3 (Simple Storage Service)

**What it does:** Object storage service with virtually unlimited scalability. **The backbone of data storage for all GenAI workloads.**

**GenAI relevance:** Store everything: training data, knowledge base documents, model artifacts, invocation logs, processed outputs, embeddings, evaluation datasets.

**Key exam features:**
- **Storage classes:** Standard, Intelligent-Tiering (automatic cost optimization), Standard-IA, One Zone-IA, Glacier Instant Retrieval, Glacier Flexible Retrieval, Glacier Deep Archive
- **S3 Intelligent-Tiering:** Automatically moves objects between access tiers based on access patterns. No retrieval fees. Ideal for unpredictable access patterns.
- **S3 Lifecycle policies:** Transition objects between storage classes or expire them on a schedule. Example: move training data to Glacier after 90 days.
- **Cross-Region Replication (CRR):** Replicate objects across Regions for compliance, latency, or disaster recovery. Useful for multi-Region GenAI deployments.
- **Same-Region Replication (SRR):** Replicate within the same Region to different account or storage class.
- **Event notifications:** Trigger Lambda, SQS, SNS, or EventBridge on object events (PUT, DELETE)
- **S3 Select / Glacier Select:** Query subsets of objects with SQL
- **Versioning:** Protect against accidental deletion; track document versions for knowledge bases
- **Encryption:** SSE-S3, SSE-KMS, SSE-C, client-side with Encryption SDK
- **Access control:** Bucket policies, ACLs, access points, Object Lock

**Common exam scenarios:**
- "Store documents for a Bedrock Knowledge Base" → S3 bucket (the primary data source for Knowledge Bases)
- "Archive old training data to reduce costs" → S3 Lifecycle policy to transition to Glacier
- "Trigger embedding generation when new docs are uploaded" → S3 event notification → Lambda → Bedrock Titan Embeddings
- "Replicate knowledge base data to another Region for DR" → Cross-Region Replication
- "Optimize costs for a knowledge base with unpredictable access patterns" → S3 Intelligent-Tiering

**Integration points:** Lambda, Bedrock Knowledge Bases, SageMaker, Glue, Athena, EMR, CloudFront, EventBridge, Macie.

---

## 12. MIGRATION AND TRANSFER

---

### 12.1 AWS DataSync

**What it does:** Online data transfer service that automates moving data between on-premises storage and AWS services.

**GenAI relevance:** Migrate on-premises document repositories to S3 for Bedrock Knowledge Base ingestion. Transfer large datasets for model training.

**Key exam features:**
- Transfers between on-premises (NFS, SMB, HDFS) and AWS (S3, EFS, FSx)
- Scheduled and incremental transfers
- Data validation (checksums)
- Bandwidth throttling
- Encryption in transit and at rest

**Common exam scenario:** "Move 10 TB of documents from on-premises NAS to S3 for our Knowledge Base" → DataSync.

**Integration points:** S3, EFS, FSx, CloudWatch (monitoring).

---

### 12.2 AWS Transfer Family

**What it does:** Fully managed SFTP, FTPS, FTP, and AS2 service for transferring files in and out of S3 and EFS.

**GenAI relevance:** Accept document uploads from partners/vendors via SFTP into S3 for GenAI processing.

**Key exam features:**
- Supports SFTP, FTPS, FTP, AS2 protocols
- Backed by S3 or EFS
- Custom identity providers (Lambda, API Gateway)
- VPC endpoint for private access
- Managed file workflows (tag, copy, decrypt on arrival)

**Common exam scenario:** "Third-party vendors upload documents via SFTP for our Knowledge Base" → Transfer Family (SFTP) → S3 → EventBridge → Lambda → Knowledge Base sync.

---

## 13. CUSTOMER ENGAGEMENT

---

### 13.1 Amazon Connect

**What it does:** Cloud-based contact center service with omnichannel support (voice, chat, tasks).

**GenAI relevance:** Build AI-powered contact centers combining Lex (intent routing), Bedrock (GenAI responses), and Transcribe/Comprehend (real-time analytics). Amazon Q in Connect provides AI-assisted agent guidance.

**Key exam features:**
- Contact flows: visual builder for call/chat routing logic
- Amazon Q in Connect: real-time AI recommendations to human agents
- Amazon Connect Customer Profiles: unified customer view
- Amazon Connect Wisdom (now part of Q in Connect): knowledge base search for agents
- Voice ID: real-time caller authentication
- Contact Lens: real-time and post-call analytics (sentiment, categorization, summarization)
- Integration with Lex for self-service bots
- Lambda integrations for custom logic

**Common exam scenarios:**
- "Build an AI-powered contact center with self-service and agent assist" → Connect + Lex + Bedrock + Q in Connect
- "Automatically summarize customer calls" → Contact Lens post-call analytics with GenAI summarization
- "Real-time agent coaching during calls" → Amazon Q in Connect

**Integration points:** Lex, Bedrock, Lambda, S3, DynamoDB, Kinesis, SNS, Transcribe, Comprehend.

---

## QUICK REFERENCE: SERVICE SELECTION DECISION TREE

| Scenario | Service(s) |
|----------|-----------|
| Call a foundation model serverlessly | **Bedrock InvokeModel / Converse API** |
| Model-agnostic API calls | **Bedrock Converse API** |
| RAG with managed vector store | **Bedrock Knowledge Bases** |
| FM takes actions via APIs | **Bedrock Agents** |
| Content filtering / PII redaction | **Bedrock Guardrails** |
| Evaluate multiple models | **Bedrock Model Evaluation** |
| Deploy a custom/fine-tuned model | **SageMaker Endpoints** |
| Open-source FM deployment with infra control | **SageMaker JumpStart** |
| Monitor model drift in production | **SageMaker Model Monitor** |
| Detect bias in model outputs | **SageMaker Clarify** |
| AI coding assistant | **Amazon Q Developer** |
| Enterprise search with GenAI | **Amazon Q Business** or **Kendra + Bedrock** |
| Orchestrate multi-step GenAI pipeline | **Step Functions** |
| REST/WebSocket API for GenAI app | **API Gateway** |
| Authenticate GenAI app users | **Cognito** |
| Serverless compute for GenAI logic | **Lambda** |
| Store conversation history | **DynamoDB** |
| Vector search (standalone) | **OpenSearch Serverless** |
| Vector search (relational) | **Aurora PostgreSQL + pgvector** |
| Object storage for data/docs | **S3** |
| Extract text from documents | **Textract** |
| Speech-to-text | **Transcribe** |
| NLP / PII detection | **Comprehend** |
| Human review of ML outputs | **A2I** |
| Encrypt data with managed keys | **KMS** |
| Store secrets and credentials | **Secrets Manager** |
| Private Bedrock access from VPC | **PrivateLink (VPC Endpoints)** |
| Protect GenAI APIs from abuse | **WAF** on API Gateway/CloudFront |
| Audit Bedrock API calls | **CloudTrail** |
| Monitor Bedrock metrics/logs | **CloudWatch** |
| CI/CD for GenAI applications | **CodePipeline + CodeBuild + CodeDeploy** |
| Trace latency in GenAI pipelines | **X-Ray** |
| Detect sensitive data in S3 | **Macie** |
| Transfer on-prem data to S3 | **DataSync** |
| AI-powered contact center | **Connect + Lex + Bedrock** |

---

## CROSS-CUTTING EXAM THEMES

### Theme 1: Security and Privacy
- Data never leaves the Region in Bedrock (unless Cross-Region Inference is configured)
- Bedrock does not use customer data to train base models
- Encrypt at rest (KMS) and in transit (TLS 1.2+)
- VPC endpoints (PrivateLink) for private API access
- IAM policies control model access at the resource level
- Bedrock Guardrails for content safety
- Macie for sensitive data discovery in S3

### Theme 2: RAG Architecture
- Knowledge Base: S3 → Chunking → Embedding (Titan/Cohere) → Vector Store (OpenSearch/Aurora/Pinecone) → Retrieval → Augmentation → Generation
- Alternative: Kendra for retrieval, Bedrock for generation
- Metadata filtering for precise retrieval
- Hierarchical/semantic chunking for better context
- Contextual grounding in Guardrails to reduce hallucination

### Theme 3: Responsible AI
- Bedrock Guardrails: content filters, PII, denied topics
- SageMaker Clarify: bias detection, explainability
- A2I: human-in-the-loop review
- Model Evaluation: automatic and human evaluation
- CloudTrail + Invocation Logging: audit trail
- Comprehend: PII detection as pre-processing

### Theme 4: Cost Optimization
- Bedrock On-Demand for variable workloads, Provisioned Throughput for steady-state
- Caching (ElastiCache) to reduce repeated FM calls
- Smaller models for simpler tasks (Haiku for classification, Sonnet for reasoning)
- S3 Intelligent-Tiering and Lifecycle for storage costs
- Lambda right-sizing (memory affects CPU allocation)
- Batch processing with SageMaker Async endpoints
- Cross-Region Inference for handling spikes without over-provisioning

### Theme 5: Operational Excellence
- CloudWatch metrics and alarms for monitoring
- X-Ray for distributed tracing
- Step Functions for orchestration with built-in error handling
- CodePipeline for CI/CD
- CloudFormation/CDK for infrastructure-as-code
- Model Invocation Logging for debugging

---

*End of AWS Services Deep Dive — AIP-C01 Exam Reference*
