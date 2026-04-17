# 09 — Machine Learning Services on AWS

## Complete Guide for AWS Solutions Architect Professional (SAP-C02)

---

## Table of Contents

1. [Amazon SageMaker](#1-amazon-sagemaker)
2. [Amazon Bedrock](#2-amazon-bedrock)
3. [AI/ML Services Overview](#3-aiml-services-overview)
4. [ML Pipeline Patterns on AWS](#4-ml-pipeline-patterns-on-aws)
5. [When to Use Pre-Built vs Custom vs Foundation Models](#5-when-to-use-pre-built-vs-custom-vs-foundation-models)
6. [ML Architecture Patterns for Exam](#6-ml-architecture-patterns-for-exam)
7. [Exam Scenarios](#7-exam-scenarios)

---

## 1. Amazon SageMaker

### Overview

SageMaker is the comprehensive ML platform for building, training, and deploying ML models. The exam tests your ability to select the right SageMaker component for a given scenario.

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Amazon SageMaker                              │
│                                                                      │
│  BUILD                    TRAIN                    DEPLOY             │
│  ┌──────────────┐         ┌──────────────┐         ┌──────────────┐  │
│  │ Studio       │         │ Training     │         │ Real-Time    │  │
│  │ Notebooks    │         │ Jobs         │         │ Endpoints    │  │
│  │ Data Wrangler│         │ Hyper-       │         │ Batch        │  │
│  │ Feature Store│         │ parameter    │         │ Transform    │  │
│  │ Ground Truth │         │ Tuning       │         │ Serverless   │  │
│  │ Autopilot   │         │ Distributed  │         │ Inference    │  │
│  │ Canvas      │         │ Training     │         │ Async        │  │
│  │ JumpStart   │         │              │         │ Inference    │  │
│  └──────────────┘         └──────────────┘         └──────────────┘  │
│                                                                      │
│  OPERATE                                                             │
│  ┌──────────────┐         ┌──────────────┐         ┌──────────────┐  │
│  │ Pipelines    │         │ Model        │         │ Model        │  │
│  │ (MLOps)      │         │ Monitor      │         │ Registry     │  │
│  └──────────────┘         └──────────────┘         └──────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

### SageMaker Studio

Integrated ML development environment (IDE):
- JupyterLab-based interface
- Integrated with all SageMaker components
- Experiment tracking and lineage
- Collaboration features
- Git integration

### SageMaker Notebooks

| Type | Description | Use Case |
|------|------------|----------|
| **Studio Notebooks** | Managed Jupyter within Studio | Team collaboration, integrated workflows |
| **Notebook Instances** | Standalone EC2-backed Jupyter | Quick experiments, isolation |

Both support lifecycle configurations for auto-install packages and auto-shutdown.

### Training

```
┌──────────┐     ┌──────────────────────────────────────┐     ┌──────────┐
│ S3       │────▶│  Training Job                         │────▶│ S3       │
│ (data)   │     │  ┌─────────────────────────────────┐  │     │ (model   │
│          │     │  │ ML Instance (ml.p3.2xlarge)     │  │     │  artifact)│
│          │     │  │ ┌──────────┐  ┌──────────────┐  │  │     │          │
│          │     │  │ │Training  │  │ Algorithm/   │  │  │     │          │
│          │     │  │ │Data      │  │ Framework    │  │  │     │          │
│          │     │  │ │(mounted) │  │ Container    │  │  │     │          │
│          │     │  │ └──────────┘  └──────────────┘  │  │     │          │
│          │     │  └─────────────────────────────────┘  │     │          │
└──────────┘     └──────────────────────────────────────┘     └──────────┘
```

**Algorithm options:**
- **Built-in algorithms:** XGBoost, Linear Learner, K-Means, Image Classification, Object Detection, Seq2Seq, BlazingText, DeepAR, etc.
- **Framework containers:** TensorFlow, PyTorch, MXNet, Hugging Face, Scikit-learn
- **Custom containers:** Bring your own Docker image

**Training instance types:**
- `ml.m5.*` — general purpose
- `ml.c5.*` — compute optimized
- `ml.p3.*` / `ml.p4d.*` — GPU (deep learning)
- `ml.g4dn.*` / `ml.g5.*` — GPU (inference-optimized, training)
- `ml.trn1.*` — AWS Trainium (custom ML chip, cost-effective for DL)

**Managed Spot Training:** Use Spot instances for training jobs (up to 90% cost reduction). SageMaker handles checkpointing and retries.

### Hyperparameter Tuning

Automatically finds the best hyperparameters:

```
Tuning Job
├── Training Job 1: learning_rate=0.01, batch_size=32   → accuracy: 0.85
├── Training Job 2: learning_rate=0.001, batch_size=64  → accuracy: 0.88
├── Training Job 3: learning_rate=0.005, batch_size=128  → accuracy: 0.91
└── Training Job N: ...                                  → accuracy: 0.93 ← Best
```

Strategies:
- **Bayesian** (default) — uses previous results to guide search
- **Random** — random sampling of hyperparameter space
- **Hyperband** — early stopping of poor-performing jobs
- **Grid** — exhaustive search (small parameter spaces)

### Model Deployment Options

| Deployment Type | Latency | Use Case | Pricing |
|----------------|---------|----------|---------|
| **Real-time Endpoint** | Milliseconds | Interactive apps, APIs | Per instance-hour |
| **Serverless Inference** | Cold start (seconds), then ms | Intermittent traffic | Per invocation + duration |
| **Batch Transform** | Minutes | Large dataset scoring, nightly predictions | Per instance-hour during job |
| **Async Inference** | Seconds to minutes | Large payloads, queued processing | Per instance-hour |

### Real-Time Endpoints

```
Client → SageMaker Endpoint → Endpoint Configuration → Model(s)
                                     │
                              ┌──────┼──────┐
                              ▼      ▼      ▼
                         Variant A  Variant B  Variant C
                         (weight:70) (weight:20) (weight:10)
```

**Production variants** enable A/B testing and canary deployments by routing traffic across model versions.

**Auto scaling** based on:
- `InvocationsPerInstance`
- `CPUUtilization`
- `GPUUtilization`
- Custom CloudWatch metrics

### Multi-Model Endpoints (MME)

Host **thousands** of models on a single endpoint:

```
┌──────────────────────────────────────────┐
│  Multi-Model Endpoint                     │
│                                           │
│  Request: TargetModel=model_A.tar.gz      │
│                                           │
│  ┌────────┐  ┌────────┐  ┌────────┐      │
│  │Model A │  │Model B │  │Model C │      │
│  │(loaded)│  │(loaded)│  │(on S3) │      │
│  └────────┘  └────────┘  └────────┘      │
│                                           │
│  Models loaded/unloaded dynamically       │
│  from S3 based on request traffic         │
└──────────────────────────────────────────┘
```

Use case: Per-customer models, per-region models, thousands of similar models.

### Serverless Inference

```
Client → SageMaker Serverless Endpoint → Auto-provisions compute → Response
                                         (cold start: 1-2 minutes if idle)
```

- Specify memory (1024 MB – 6144 MB) and max concurrency
- No instance management
- Scales to zero when idle
- Cost-effective for infrequent/unpredictable traffic

### SageMaker Pipelines (MLOps)

Define ML workflows as DAGs:

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Data     │───▶│ Feature  │───▶│ Training │───▶│ Evaluate │───▶│ Register │
│ Processing│   │ Engineer │    │          │    │          │    │ Model    │
│ Step     │    │ Step     │    │ Step     │    │ Step     │    │ Step     │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
                                                      │              │
                                                      │ if accuracy  │ if pass
                                                      │ < threshold  ▼
                                                      │         ┌──────────┐
                                                      └────────▶│ Deploy   │
                                                       fail     │ Endpoint │
                                                                └──────────┘
```

Integrates with:
- SageMaker Experiments (tracking)
- SageMaker Model Registry (versioning, approval workflows)
- EventBridge (triggers)
- CodePipeline (CI/CD)

### Model Monitor

Detect model quality degradation in production:

| Monitor Type | What It Detects |
|-------------|----------------|
| **Data Quality** | Schema changes, missing values, statistical drift in input data |
| **Model Quality** | Accuracy, precision, recall degradation over time |
| **Bias Drift** | Changes in model bias (fairness metrics) |
| **Feature Attribution Drift** | Changes in feature importance rankings |

```
Real-time Endpoint → Captures predictions → Model Monitor →
    Compare against baseline → CloudWatch Alarm → Retrain pipeline trigger
```

### Feature Store

Centralized repository for ML features:

```
┌──────────────────────────────────────────────────┐
│  SageMaker Feature Store                          │
│                                                   │
│  ┌─────────────────┐  ┌─────────────────┐         │
│  │ Online Store    │  │ Offline Store   │         │
│  │ (low-latency)   │  │ (S3, historical)│         │
│  │                 │  │                 │         │
│  │ Key: customer_id│  │ Full history    │         │
│  │ → latest feature│  │ of all feature  │         │
│  │   values        │  │ values          │         │
│  │                 │  │                 │         │
│  │ Use: real-time  │  │ Use: training,  │         │
│  │ inference       │  │ batch inference │         │
│  └─────────────────┘  └─────────────────┘         │
└──────────────────────────────────────────────────┘
```

### Data Wrangler

Visual data preparation and feature engineering:
- 300+ built-in transforms
- Data type conversions, text processing, date handling
- Join, concatenate, split datasets
- Export to SageMaker Pipeline, Jupyter, or Python script

### Autopilot

Automated ML (AutoML):
1. Provide tabular dataset
2. Autopilot tries multiple algorithms and hyperparameters
3. Returns ranked list of model candidates
4. Full visibility into generated notebooks and code
5. Deploy best model to endpoint

### Canvas

No-code ML for business analysts:
- Upload CSV data
- Point-and-click model building
- Time-series forecasting, classification, regression
- Natural language predictions (using foundation models)
- No ML expertise required

### Ground Truth

Data labeling service:

```
Raw Data → Ground Truth → Human Labelers → Labeled Data → Training
               │
               ├── Human workforce (Amazon Mechanical Turk, private, vendor)
               ├── Automated labeling (active learning reduces human effort)
               └── Ground Truth Plus (fully managed labeling project)
```

### JumpStart

Pre-trained models and solution templates:
- 400+ pre-trained models (Hugging Face, Stability AI, Meta, etc.)
- One-click fine-tuning and deployment
- Solution templates for common ML use cases
- Foundation models (LLMs) available for deployment

> **Exam Tip:** SageMaker is the most comprehensive ML service. For the exam: Training = choose right instance type + Spot for cost. Deployment = real-time (low latency), batch (large datasets), serverless (intermittent), async (large payloads). Pipelines = MLOps. Model Monitor = detect drift. Feature Store = shared features.

---

## 2. Amazon Bedrock

### Overview

Fully managed service to access foundation models (FMs) from leading AI companies:

```
┌────────────────────────────────────────────────────────────────┐
│                      Amazon Bedrock                             │
│                                                                 │
│  Foundation Models:                                             │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │
│  │ Amazon   │ │ Anthropic│ │ Meta     │ │ Stability│          │
│  │ Titan    │ │ Claude   │ │ Llama    │ │ AI       │          │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐                       │
│  │ AI21     │ │ Cohere   │ │ Mistral  │                       │
│  │ Labs     │ │          │ │          │                       │
│  └──────────┘ └──────────┘ └──────────┘                       │
│                                                                 │
│  Capabilities:                                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐          │
│  │ Agents   │ │Knowledge │ │Guardrails│ │ Fine-    │          │
│  │          │ │ Bases    │ │          │ │ tuning   │          │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘          │
└────────────────────────────────────────────────────────────────┘
```

### Key Features

**Model Access:**
- On-demand inference (pay per token)
- Provisioned throughput (reserved capacity, consistent latency)
- Model invocation via API (`InvokeModel`, `InvokeModelWithResponseStream`)

### Bedrock Agents

Automate multi-step tasks using foundation models + tools:

```
User Query → Agent → Plan steps → Execute actions → Return result
                        │
                  ┌─────┼─────────────┐
                  ▼     ▼             ▼
           Lambda   Knowledge    API actions
           functions  Base query  (defined via
           (tools)                OpenAPI spec)
```

Agents can:
- Break down user requests into steps
- Call Lambda functions to execute actions
- Query knowledge bases for information
- Maintain conversation context

### Bedrock Knowledge Bases

RAG (Retrieval Augmented Generation) built-in:

```
┌──────────────┐     ┌──────────────────┐     ┌──────────────────┐
│ Data Sources │────▶│ Vector Database  │────▶│ Knowledge Base   │
│              │     │                  │     │                  │
│ - S3 docs    │     │ - OpenSearch     │     │ Query: "What is  │
│ - Web crawl  │     │   Serverless     │     │  our refund      │
│ - Confluence │     │ - Aurora DSQL    │     │  policy?"        │
│              │     │ - Pinecone       │     │                  │
│              │     │ - Redis          │     │ → Retrieves      │
│              │     │                  │     │   relevant docs  │
│              │     │ Embedding model  │     │ → FM generates   │
│              │     │ (Titan/Cohere)   │     │   grounded answer│
└──────────────┘     └──────────────────┘     └──────────────────┘
```

### Bedrock Guardrails

Control FM outputs:

| Guardrail | Description |
|-----------|------------|
| **Content filters** | Block harmful content (hate, violence, sexual, etc.) |
| **Denied topics** | Prevent responses about specific topics |
| **Word filters** | Block specific words or phrases |
| **Sensitive information filters** | Detect and redact PII (names, SSN, credit cards) |
| **Contextual grounding** | Check that responses are grounded in source material |

### Fine-Tuning

Customize foundation models with your own data:

```
Your Domain Data (S3) → Fine-tuning Job → Custom Model → Deploy
                                              │
                               Private, in your account
                               Only accessible by you
```

- **Continued pre-training:** Adapt to domain-specific language
- **Instruction fine-tuning:** Improve task-specific performance

### Model Evaluation

Compare models on your specific use cases:
- Automated evaluation (ROUGE, BERTScore, accuracy)
- Human evaluation (through SageMaker Ground Truth)
- Custom evaluation metrics

> **Exam Tip:** Bedrock = managed access to LLMs/FMs. Knowledge Bases = RAG (ground answers in your data). Guardrails = safety controls. If the question asks about "generative AI" or "foundation models" with minimal infrastructure, Bedrock is the answer.

---

## 3. AI/ML Services Overview

### Service Decision Tree

```
Q: Do you need to build/train a CUSTOM model?
├── Yes → SageMaker
│
Q: Do you need generative AI / LLM capabilities?
├── Yes → Bedrock
│
Q: Do you need a specific AI capability?
└── Yes → Use the appropriate pre-built AI service ↓
```

### Amazon Rekognition

**Computer vision service — no ML expertise required:**

| Capability | Description | Use Case |
|-----------|------------|----------|
| **Object Detection** | Detect objects in images/videos | Inventory counting, scene analysis |
| **Face Detection** | Detect faces, analyze attributes (age, emotion, glasses) | User verification |
| **Face Comparison** | Compare faces across images | Identity verification |
| **Content Moderation** | Detect inappropriate content | User-generated content platforms |
| **Text in Image** | Extract text from images | License plates, signs |
| **Celebrity Recognition** | Identify celebrities | Media, entertainment |
| **Custom Labels** | Train custom object/scene detection | Specific product detection, defect inspection |
| **Video Analysis** | Track people, detect activities | Security, sports analytics |
| **PPE Detection** | Detect protective equipment | Workplace safety compliance |

**Custom Labels** — train your own model with as few as 30 images:

```
Your Images (S3) → Label (Rekognition console) → Train → Deploy endpoint
```

### Amazon Textract

**Document intelligence — extract text, forms, tables:**

| Feature | Description |
|---------|------------|
| **OCR** | Extract printed and handwritten text |
| **Forms** | Extract key-value pairs from forms |
| **Tables** | Extract structured table data |
| **Queries** | Ask specific questions about a document (e.g., "What is the patient name?") |
| **Signatures** | Detect signatures in documents |
| **Identity Documents** | Extract from IDs (driver's license, passport) |
| **Lending** | Pre-built for mortgage/loan document processing |

```
Document (S3/bytes) → Textract API → Structured JSON output
                                         │
                              ┌───────────┼───────────┐
                              ▼           ▼           ▼
                         Raw Text    Key-Value    Table Data
                                     Pairs
```

### Amazon Comprehend

**Natural Language Processing (NLP):**

| Feature | Description |
|---------|------------|
| **Sentiment Analysis** | Positive, negative, neutral, mixed |
| **Entity Recognition** | People, places, dates, organizations, quantities |
| **Key Phrase Extraction** | Important phrases in text |
| **Language Detection** | Identify language (100+ languages) |
| **PII Detection/Redaction** | Detect and redact PII (names, SSN, addresses) |
| **Topic Modeling** | Discover topics across a collection of documents |
| **Custom Classification** | Train custom text classifiers |
| **Custom Entity Recognition** | Train to extract custom entities |
| **Targeted Sentiment** | Sentiment per entity in text |

**Comprehend Medical** — NLP specifically for medical text:
- Extract medical conditions, medications, dosages, procedures
- ICD-10-CM / RxNorm ontology linking

### Amazon Translate

**Neural machine translation:**

| Feature | Description |
|---------|------------|
| **Real-time** | Translate text on the fly via API |
| **Batch** | Translate documents in S3 |
| **Custom Terminology** | Enforce specific translations for brand names, technical terms |
| **Formality** | Control formal vs. informal tone |
| **Profanity Masking** | Mask profane words in translations |
| **Active Custom Translation** | Use parallel data to customize translation quality |

### Amazon Polly

**Text-to-Speech:**

| Feature | Description |
|---------|------------|
| **Standard Voices** | Traditional TTS |
| **Neural Voices** | More natural, human-like speech |
| **SSML** | Control pronunciation, speed, volume, emphasis |
| **Speech Marks** | Timestamps for lip-sync, karaoke |
| **Lexicons** | Custom pronunciation for specific words |
| **Long Audio** | Async synthesis for articles, books (output to S3) |
| **Newscaster Style** | News anchor-style voice |

### Amazon Transcribe

**Speech-to-Text:**

| Feature | Description |
|---------|------------|
| **Real-time** | Streaming transcription |
| **Batch** | Transcribe audio files in S3 |
| **Custom Vocabulary** | Improve accuracy for domain terms |
| **Custom Language Model** | Train on domain-specific text |
| **Automatic Language Identification** | Detect language automatically |
| **Speaker Diarization** | Identify different speakers |
| **Content Redaction** | Redact PII from transcriptions |
| **Toxicity Detection** | Detect toxic content in audio |

**Transcribe Medical** — optimized for medical dictation.

**Transcribe Call Analytics** — built for contact center analysis:
- Sentiment per speaker
- Talk time analysis
- Call categorization
- Post-call and real-time analytics

### Amazon Lex

**Conversational AI (chatbots):**

```
User → Lex Bot → Intent Recognition → Slot Filling → Fulfillment (Lambda)
                                                            │
                                                      ┌─────┴─────┐
                                                      │ Response  │
                                                      │ to user   │
                                                      └───────────┘
```

| Component | Description |
|-----------|------------|
| **Intent** | What the user wants to do (e.g., "BookHotel") |
| **Slot** | Data to fulfill the intent (e.g., "city", "checkin_date") |
| **Fulfillment** | Lambda function that processes the intent |
| **Utterance** | Sample phrases that map to an intent |

Integrates with: Amazon Connect (contact center), Twilio, Facebook Messenger, Slack, web/mobile apps.

### Amazon Kendra

**Intelligent enterprise search:**

```
┌──────────────────────────────────────────────────────────────┐
│  Amazon Kendra                                                │
│                                                               │
│  Data Sources (connectors):                                   │
│  ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐     │
│  │ S3   │ │Share │ │Conf- │ │Sales-│ │Service│ │ RDS  │     │
│  │      │ │Point │ │luence│ │force │ │Now   │ │      │     │
│  └──────┘ └──────┘ └──────┘ └──────┘ └──────┘ └──────┘     │
│                                                               │
│  Index → ML Ranking → Results                                 │
│                                                               │
│  Features:                                                    │
│  - FAQ support (question-answer pairs)                        │
│  - Custom Document Enrichment (Lambda pre-processing)         │
│  - Access control (user/group based document visibility)      │
│  - Relevance tuning                                           │
│  - Experience Builder (search UI with no code)                │
└──────────────────────────────────────────────────────────────┘
```

### Amazon Personalize

**Real-time personalization and recommendations:**

```
Historical Data (S3)  ┐
                      ├──▶ Personalize → Train → Campaign → Real-time API
User Interactions     │                                         │
(Events API)         ─┘                              ┌──────────┴──────────┐
                                                     ▼                    ▼
                                              Recommendations      Personalized
                                              (products, content)   Rankings
```

| Recipe | Description |
|--------|------------|
| **User Personalization** | Recommend items for a specific user |
| **Similar Items** | Find items similar to a given item |
| **Personalized Ranking** | Re-rank a list of items for a specific user |
| **Trending Now** | Items trending across all users |
| **Next Best Action** | Recommend actions based on user context |

### Amazon Forecast

**Time-series forecasting:**

```
Historical Data (S3) → Forecast → Predictor (AutoML) → Forecast → Export (S3)

Examples:
- Retail demand forecasting
- Resource capacity planning
- Financial forecasting
- Weather impact on sales
```

Uses Amazon's proprietary DeepAR+ algorithm and other statistical methods.

### Amazon Fraud Detector

**ML-based fraud detection:**

```
Historical Fraud Data → Fraud Detector → Train Model → Real-time Predictions
                                                            │
                                              ┌─────────────┼─────────────┐
                                              ▼             ▼             ▼
                                         Approve      Review          Block
                                         (low risk)   (medium risk)   (high risk)
```

Built-in model templates:
- **Online Fraud Insights** — new account fraud, payment fraud
- **Transaction Fraud Insights** — transaction-level fraud
- **Account Takeover Insights** — login anomalies

### Amazon CodeWhisperer / Amazon Q Developer

**AI-powered coding assistant:**

| Feature | Description |
|---------|------------|
| **Code Generation** | Generate code from comments and context |
| **Code Completion** | Real-time suggestions as you type |
| **Security Scanning** | Detect vulnerabilities in code |
| **Code Transformation** | Upgrade Java versions, modernize code |
| **Q Chat** | Ask questions about AWS services, your codebase |
| **Q for Troubleshooting** | Diagnose and fix operational issues |

> **Exam Tip:** Know which AI service to pick for each use case. The exam won't test implementation details of these services but WILL test service selection: Image analysis → Rekognition. Document extraction → Textract. Text analysis → Comprehend. Search → Kendra. Recommendations → Personalize. Chatbot → Lex. Speech-to-text → Transcribe. Text-to-speech → Polly. Translation → Translate.

---

## 4. ML Pipeline Patterns on AWS

### End-to-End ML Pipeline

```
┌──────────────────────────────────────────────────────────────────────┐
│  ML Pipeline                                                          │
│                                                                       │
│  ┌─────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐  │
│  │ Data    │──│ Feature  │──│ Training │──│ Evaluate │──│ Deploy │  │
│  │ Ingest  │  │ Engineer │  │          │  │          │  │        │  │
│  └─────────┘  └──────────┘  └──────────┘  └──────────┘  └────────┘  │
│       │            │             │              │            │        │
│   S3/Kinesis  SageMaker     SageMaker     Model quality   SageMaker  │
│   Glue ETL    Processing    Training Job  metrics check   Endpoint   │
│               Feature Store  (Spot)       Model Registry  Auto Scale │
│                                                                       │
│  Orchestration: SageMaker Pipelines or Step Functions                 │
│  CI/CD: CodePipeline + CodeBuild                                      │
│  Monitoring: Model Monitor + CloudWatch                               │
└──────────────────────────────────────────────────────────────────────┘
```

### SageMaker Pipelines vs Step Functions for ML

| Feature | SageMaker Pipelines | Step Functions |
|---------|-------------------|---------------|
| **ML-specific steps** | Native (Training, Processing, Transform, etc.) | Via SDK integrations |
| **Experiment tracking** | Built-in | Manual |
| **Model Registry** | Integrated | Separate |
| **Caching** | Step-level caching | No |
| **Non-ML steps** | Limited | Full AWS service support |
| **Human approval** | Callback step | `.waitForTaskToken` |
| **Visualization** | Pipeline DAG in Studio | State machine visual |
| **Best for** | ML-focused pipelines | Complex orchestration mixing ML + non-ML |

### Automated Retraining Pipeline

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ New Data  │──▶│ EventBridge  │──▶│ SageMaker    │──▶│ Model        │
│ in S3     │   │ Trigger      │   │ Pipeline     │   │ Monitor      │
└──────────┘    └──────────────┘   │              │   │              │
                                   │ 1. Process   │   │ Detect drift │
┌──────────┐    ┌──────────────┐   │ 2. Train     │   │      │       │
│ Drift    │──▶│ CloudWatch   │──▶│ 3. Evaluate  │   │      ▼       │
│ Detected │   │ Alarm        │   │ 4. Register  │   │ CloudWatch   │
│          │   └──────────────┘   │ 5. Deploy    │   │ Alarm        │
└──────────┘                       └──────────────┘   └──────────────┘
```

---

## 5. When to Use Pre-Built vs Custom vs Foundation Models

### Decision Framework

```
┌──────────────────────────────────────────────────────────────────┐
│                                                                   │
│  Q: Is this a COMMON AI task?                                     │
│  (image recognition, text extraction, translation, etc.)          │
│  ├── Yes → Use PRE-BUILT AI Service                               │
│  │         (Rekognition, Textract, Comprehend, etc.)              │
│  │         Cheapest, fastest, no ML expertise needed              │
│  │                                                                │
│  └── No                                                           │
│      Q: Do you need GENERATIVE AI or NATURAL LANGUAGE?            │
│      ├── Yes → Use FOUNDATION MODEL (Bedrock)                     │
│      │         Need domain-specific? → Fine-tune in Bedrock       │
│      │         Need grounded answers? → Bedrock Knowledge Bases   │
│      │                                                            │
│      └── No                                                       │
│          Q: Do you need a DOMAIN-SPECIFIC model?                  │
│          ├── Yes                                                  │
│          │   Q: Have ML expertise?                                │
│          │   ├── Yes → SageMaker (full control)                   │
│          │   │         Custom training, hyperparameter tuning     │
│          │   └── No → SageMaker Autopilot or Canvas               │
│          │             AutoML, no-code options                     │
│          │                                                        │
│          └── No → Re-evaluate if a pre-built service works        │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### Detailed Comparison

| Approach | When to Use | Examples | Effort |
|----------|------------|---------|--------|
| **Pre-built AI services** | Common AI tasks; no training data needed | Rekognition, Textract, Comprehend, Translate | Minimal (API call) |
| **Pre-built + custom** | Common task but need domain adaptation | Rekognition Custom Labels, Comprehend Custom Classifier | Low (labeled data + training) |
| **Foundation models (Bedrock)** | Generative AI, text/code generation, summarization, Q&A | Claude, Titan, Llama, Mistral | Low (prompt engineering) to Medium (fine-tuning) |
| **AutoML (Autopilot/Canvas)** | Tabular data, classification/regression, no ML expertise | Customer churn, demand forecasting | Low (provide data) |
| **Custom ML (SageMaker)** | Unique problems, proprietary data, need full control | Fraud detection, recommendation engines, anomaly detection | High (data prep, training, tuning, deployment) |
| **Custom DL (SageMaker)** | Computer vision, NLP, complex patterns | Custom image classification, NER, time series | Highest (deep learning expertise + GPU training) |

> **Exam Tip:** The exam tests whether you pick the SIMPLEST solution. Always prefer pre-built AI services when they fit the use case. Only go to SageMaker when pre-built services don't meet requirements.

---

## 6. ML Architecture Patterns for Exam

### Pattern 1: Intelligent Document Processing

```
Documents     ┌──────────┐    ┌───────────┐    ┌──────────────┐
(S3)     ────▶│ Textract │───▶│Comprehend │───▶│ DynamoDB/    │
              │ (extract │    │ (classify,│    │ OpenSearch   │
              │  text,   │    │  entities,│    │ (store +     │
              │  tables) │    │  sentiment│    │  search)     │
              └──────────┘    │  PII)     │    └──────────────┘
                              └───────────┘
              
              Orchestration: Step Functions
```

### Pattern 2: Real-Time Personalization

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐
│ User     │───▶│ API Gateway  │───▶│ Lambda       │
│ Request  │    │              │    │ ┌──────────┐ │
└──────────┘    └──────────────┘    │ │Personalize│ │
                                    │ │ Runtime   │ │
                                    │ └──────────┘ │
                                    └──────────────┘
                                          │
                                    ┌─────▼─────┐
                                    │Personalized│
                                    │ Response   │
                                    └───────────┘

Offline Training:
S3 (interactions) → Personalize Dataset → Train → Solution Version → Campaign
```

### Pattern 3: Contact Center Intelligence

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Amazon   │───▶│Transcribe│───▶│Comprehend│───▶│ Lex      │
│ Connect  │    │ (STT)    │    │(sentiment│    │(chatbot) │
│ (calls)  │    │          │    │ entities)│    │          │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
                                                      │
                                              ┌───────▼───────┐
                                              │ Lambda         │
                                              │ (fulfillment)  │
                                              │ → DynamoDB     │
                                              │ → CRM          │
                                              └───────────────┘
```

### Pattern 4: Content Moderation Pipeline

```
User Upload → S3 → Lambda → Rekognition (image moderation)
                         → Comprehend (text moderation)
                         → Transcribe + Comprehend (audio moderation)
                              │
                    ┌─────────┼─────────┐
                    ▼         ▼         ▼
               Approve    Human      Reject
                          Review
                          (A2I)
```

**Amazon Augmented AI (A2I):** Adds human review loop for ML predictions with low confidence.

### Pattern 5: Generative AI Application

```
┌──────────┐    ┌──────────┐    ┌──────────────────────┐
│ User     │───▶│ API GW   │───▶│ Lambda               │
│ Question │    │          │    │ ┌──────────────────┐  │
└──────────┘    └──────────┘    │ │ Bedrock          │  │
                                │ │ Knowledge Base   │  │
                                │ │ (RAG: query docs │  │
                                │ │  + generate)     │  │
                                │ └──────────────────┘  │
                                │                       │
                                │ Guardrails:           │
                                │ - PII filtering       │
                                │ - Content safety      │
                                │ - Topic restrictions   │
                                └───────────────────────┘
                                         │
                              ┌──────────▼──────────┐
                              │ Vector DB           │
                              │ (OpenSearch          │
                              │  Serverless)         │
                              │                     │
                              │ Company docs (S3)   │
                              │ → Embedded          │
                              │ → Indexed            │
                              └─────────────────────┘
```

---

## 7. Exam Scenarios

### Scenario 1: Customer Service Automation

**Question:** A retail company wants to automate customer service. They receive inquiries via phone, email, and chat. They need automatic call transcription, sentiment analysis, automatic responses for common questions, and escalation to humans for complex issues.

**Answer:**
- **Phone:** Amazon Connect + Transcribe Call Analytics (real-time transcription + sentiment)
- **Chat/Email:** Amazon Lex (intent recognition, slot filling, automated responses)
- **Sentiment:** Comprehend (analyze text sentiment from all channels)
- **Knowledge base:** Bedrock Knowledge Bases (RAG for FAQ-style responses)
- **Escalation:** A2I (Amazon Augmented AI) for human review
- **Analytics:** Comprehend + QuickSight for sentiment trends dashboard

---

### Scenario 2: Document Processing Pipeline

**Question:** An insurance company receives 100,000 claims documents per month (PDFs, scanned images). They need to extract key fields (claim amount, date, patient name), classify document types, redact PII, and store structured data for analytics.

**Answer:**
- **Extract:** Textract with Queries (extract specific fields)
- **Classify:** Comprehend Custom Classification (claim type: medical, auto, property)
- **PII:** Comprehend PII detection and redaction
- **Orchestration:** Step Functions (document → Textract → Comprehend → store)
- **Storage:** DynamoDB (structured data) + S3 (original documents)
- **Search:** OpenSearch (full-text search across claims)

---

### Scenario 3: Product Recommendations

**Question:** An e-commerce company wants real-time product recommendations on their website. They have 3 years of purchase history and want to personalize for each user. New users with no history should also get recommendations.

**Answer:**
- **Recommendations:** Amazon Personalize
  - **User Personalization** recipe for existing users
  - **Popular Items** fallback for new users (cold start)
  - **Real-time Events API** to capture browsing behavior
  - **Campaign** for real-time inference
- **Integration:** API GW → Lambda → Personalize Runtime

**Why not SageMaker?** Personalize is purpose-built for recommendations, requires less ML expertise, and handles cold-start natively.

---

### Scenario 4: Fraud Detection in Real-Time

**Question:** A payment processing company needs to evaluate every transaction (50,000/second) for fraud in under 100ms. They have 2 years of labeled fraud data. The model needs to be retrained monthly.

**Answer:**
- **Model Training:** SageMaker with XGBoost built-in algorithm (tabular fraud data)
- **Feature Store:** SageMaker Feature Store (online store for real-time lookup of customer features)
- **Inference:** SageMaker Real-time Endpoint (auto-scaled, ml.c5.xlarge for low latency)
- **Pipeline:** SageMaker Pipelines for monthly retraining
- **Monitoring:** SageMaker Model Monitor for drift detection
- **Integration:** Kinesis Data Streams → Lambda → SageMaker Endpoint → approve/block

**Why not Fraud Detector?** At 50K TPS with custom model requirements, SageMaker provides more control and scale.

---

### Scenario 5: Generative AI Enterprise Search

**Question:** A legal firm wants employees to ask questions about internal documents (contracts, case law, policies) using natural language. Answers must be grounded in the firm's documents (no hallucination). PII must be filtered from responses.

**Answer:**
- **Foundation model:** Amazon Bedrock (Claude or Titan)
- **RAG:** Bedrock Knowledge Bases
  - Source: S3 (documents)
  - Vector store: OpenSearch Serverless
  - Embedding: Titan Embeddings
- **Safety:** Bedrock Guardrails (PII filtering, topic restrictions)
- **Interface:** Lex or custom web UI
- **Alternative for search-only:** Amazon Kendra (if they want traditional ranked search results rather than generative answers)

---

### Scenario 6: ML Model Cost Optimization

**Question:** A company has 200 ML models serving different customer segments. Each model gets 10-50 requests per day. Currently, each model has its own SageMaker endpoint costing $0.10/hour (200 × $72/month = $14,400/month). How can they reduce cost?

**Answer:**
- **Multi-Model Endpoint:** Host all 200 models on a single endpoint. Models loaded/unloaded from S3 dynamically based on traffic. Reduces to 1-3 endpoints.
- **Alternative for cold-start tolerance:** SageMaker Serverless Inference (scale to zero, pay per invocation only).
- Cost reduction: 80-95%

---

### Key Exam Tips Summary

| Topic | Key Point |
|-------|-----------|
| SageMaker | Comprehensive ML platform. Training → Spot instances for cost. Endpoints → auto-scale. |
| Bedrock | Managed foundation models. Knowledge Bases = RAG. Guardrails = safety. |
| AI Services | Pre-built = simplest. Always prefer over custom when the task matches. |
| Rekognition | Image/video analysis. Custom Labels for domain-specific detection. |
| Textract | Document extraction (forms, tables, queries). |
| Comprehend | NLP (sentiment, entities, PII, classification). Medical variant exists. |
| Kendra | Enterprise search with connectors. |
| Personalize | Recommendations and personalization. Handles cold-start. |
| Lex | Chatbots (intents, slots, fulfillment). Integrates with Connect. |
| Model deployment | Real-time = low latency. Batch = large datasets. Serverless = intermittent. Multi-model = many models. |
| MLOps | SageMaker Pipelines or Step Functions. Model Registry for versioning. Model Monitor for drift. |
| Cost optimization | Spot training (90% savings). Multi-model endpoints. Serverless inference. |

---

*End of Article 09 — Machine Learning Services*
