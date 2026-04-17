# AWS Certified Generative AI Developer - Professional (AIP-C01)

## Exam Overview and Comprehensive 8-Week Study Plan

---

## Table of Contents

1. [Exam Overview](#exam-overview)
2. [Domain Weights and Breakdown](#domain-weights-and-breakdown)
3. [Target Candidate Profile](#target-candidate-profile)
4. [8-Week Study Plan](#8-week-study-plan)
5. [Exam Strategies](#exam-strategies)
6. [Recommended Resources](#recommended-resources)
7. [Study Materials Index](#study-materials-index)

---

## Exam Overview

| Detail                | Information                                                    |
| --------------------- | -------------------------------------------------------------- |
| **Full Exam Name**    | AWS Certified Generative AI Developer - Professional (AIP-C01) |
| **Duration**          | 180 minutes (3 hours)                                          |
| **Total Questions**   | 75 (65 scored + 10 unscored)                                   |
| **Format**            | Multiple choice and multiple response                          |
| **Cost**              | $300 USD                                                       |
| **Passing Score**     | 750 / 1000                                                     |
| **Validity**          | 3 years from exam date                                         |
| **Delivery Method**   | Pearson VUE testing center or online proctored                 |
| **Languages**         | English, Japanese, Korean, Simplified Chinese                  |
| **Recertification**   | Retake the exam or pass a higher-level certification           |

### Question Types Explained

- **Multiple Choice (single answer):** Four options, one correct. These make up the majority of questions.
- **Multiple Response (multiple answers):** Five or more options, two or more correct. The question will specify how many answers to select.
- **Unscored Questions:** 10 of the 75 questions are unscored field-test items. You cannot identify which ones they are, so treat every question as scored.

### Scoring Model

AWS uses a compensatory scoring model scaled from 100 to 1000. You do not need to pass each domain individually — your total weighted score across all domains must reach 750. There is no penalty for wrong answers, so always answer every question.

---

## Domain Weights and Breakdown

| Domain | Topic                                                        | Weight | Approx. Scored Questions |
| ------ | ------------------------------------------------------------ | ------ | ------------------------ |
| 1      | Foundation Model Integration, Data Management, and Compliance | 31%    | ~20                      |
| 2      | Implementation and Integration                                | 26%    | ~17                      |
| 3      | AI Safety, Security, and Governance                           | 20%    | ~13                      |
| 4      | Operational Efficiency and Optimization                       | 12%    | ~8                       |
| 5      | Testing, Validation, and Troubleshooting                      | 11%    | ~7                       |

### Domain 1: Foundation Model Integration, Data Management, and Compliance (31%)

This is the heaviest domain. Master it thoroughly.

**Key Topics:**
- Amazon Bedrock APIs and SDK integration
- Foundation model selection criteria (Claude, Titan, Llama, Mistral, Cohere, Stability AI)
- Prompt engineering techniques (zero-shot, few-shot, chain-of-thought, ReAct)
- Data preparation and preprocessing for GenAI workloads
- Data ingestion pipelines for training and fine-tuning
- Retrieval-Augmented Generation (RAG) architecture and implementation
- Knowledge bases for Amazon Bedrock
- Vector databases and embeddings (Amazon OpenSearch Serverless, Amazon Aurora pgvector, Pinecone)
- Data compliance requirements (GDPR, HIPAA, SOC 2, PCI DSS)
- Data residency and sovereignty considerations
- Model licensing and intellectual property

### Domain 2: Implementation and Integration (26%)

**Key Topics:**
- Building GenAI applications with Amazon Bedrock
- Amazon Bedrock Agents (action groups, knowledge bases, orchestration)
- Amazon Bedrock Guardrails configuration
- Amazon SageMaker for model training, fine-tuning, and deployment
- SageMaker JumpStart for foundation model deployment
- AWS Lambda integration with GenAI services
- API Gateway patterns for GenAI endpoints
- Step Functions for orchestrating GenAI workflows
- Streaming responses and asynchronous invocation patterns
- LangChain and other frameworks on AWS
- Multi-model architectures and model chaining
- Conversational AI and chatbot implementation
- Code generation and developer tooling (Amazon CodeWhisperer / Amazon Q Developer)

### Domain 3: AI Safety, Security, and Governance (20%)

**Key Topics:**
- Amazon Bedrock Guardrails (content filters, denied topics, word filters, sensitive information filters)
- Responsible AI principles and AWS commitments
- Model access controls and IAM policies for Bedrock
- VPC endpoints and private connectivity for GenAI services
- Encryption at rest and in transit for model data
- AWS CloudTrail logging for GenAI API calls
- Model invocation logging in Amazon Bedrock
- Bias detection and mitigation strategies
- Hallucination detection and reduction techniques
- Content moderation pipelines
- AWS AI Service Cards
- Compliance frameworks relevant to AI/ML workloads
- Data privacy in model training and inference

### Domain 4: Operational Efficiency and Optimization (12%)

**Key Topics:**
- Amazon Bedrock provisioned throughput vs. on-demand pricing
- Cost optimization strategies for GenAI workloads
- Token management and prompt optimization to reduce costs
- Caching strategies (prompt caching, semantic caching)
- Latency optimization for real-time GenAI applications
- Model selection trade-offs (cost vs. quality vs. latency)
- Auto-scaling GenAI endpoints on SageMaker
- Monitoring GenAI applications with CloudWatch
- Performance benchmarking for foundation models
- Batch inference patterns

### Domain 5: Testing, Validation, and Troubleshooting (11%)

**Key Topics:**
- Evaluation metrics for GenAI outputs (ROUGE, BLEU, BERTScore, human evaluation)
- Amazon Bedrock model evaluation jobs
- A/B testing GenAI model responses
- Regression testing for prompt changes
- Debugging common GenAI issues (hallucinations, context window overflow, token limits)
- Troubleshooting Amazon Bedrock API errors
- Load testing GenAI applications
- Monitoring model drift and quality degradation
- Logging and observability for GenAI pipelines
- Automated evaluation pipelines

---

## Target Candidate Profile

### Experience Requirements

- **2+ years** building production applications on AWS
- **1+ year** hands-on experience with Generative AI technologies
- Familiarity with at least one programming language (Python strongly recommended)
- Experience with REST APIs, SDKs, and cloud-native architectures

### Typical Roles

| Role                         | Focus Area                                         |
| ---------------------------- | -------------------------------------------------- |
| GenAI Developer              | Building applications powered by foundation models |
| Cloud AI Architect           | Designing GenAI solutions on AWS infrastructure    |
| ML Engineer                  | Training, fine-tuning, and deploying AI models     |
| Solutions Architect          | Integrating GenAI into enterprise solutions        |
| Full-Stack Developer         | Adding GenAI capabilities to existing applications |
| DevOps / MLOps Engineer      | Operating and scaling GenAI workloads              |

### Assumed Knowledge

- AWS core services (IAM, VPC, S3, Lambda, API Gateway, CloudWatch)
- Python programming and Boto3 SDK usage
- REST API design and consumption
- Basic machine learning concepts (training, inference, embeddings, transformers)
- JSON, YAML, and infrastructure-as-code basics
- CI/CD concepts

---

## 8-Week Study Plan

### Study Plan Overview

| Week  | Focus                                     | Domains  | Hours/Week |
| ----- | ----------------------------------------- | -------- | ---------- |
| 1     | Domain 1 — Foundation Models & Bedrock    | D1       | 10-12      |
| 2     | Domain 1 — RAG, Data Management, Compliance | D1     | 10-12      |
| 3     | Domain 2 — Bedrock Agents & SageMaker     | D2       | 10-12      |
| 4     | Domain 2 — Integration Patterns & Workflows | D2     | 10-12      |
| 5     | Domain 3 — Safety, Security, Governance   | D3       | 8-10       |
| 6     | Domain 4 + Domain 5 — Optimization & Testing | D4, D5 | 8-10       |
| 7     | Practice Exams & Weak Area Review         | All      | 12-15      |
| 8     | Final Review & Exam                       | All      | 10-12      |

---

### Week 1: Domain 1 — Foundation Models and Amazon Bedrock (Part 1)

**Theme:** Understand foundation models, Bedrock APIs, and prompt engineering.

#### Day 1 (Monday): Foundation Model Fundamentals
- **Study Topics:**
  - Transformer architecture at a conceptual level (encoder, decoder, attention)
  - Types of foundation models: text generation, embeddings, image generation, multimodal
  - Model families available on Amazon Bedrock and their strengths
- **Read:**
  - [Amazon Bedrock User Guide — Supported Models](https://docs.aws.amazon.com/bedrock/latest/userguide/models-supported.html)
  - [Amazon Bedrock Model Providers](https://docs.aws.amazon.com/bedrock/latest/userguide/model-providers.html)
- **Key Concepts to Master:**
  - Differences between Anthropic Claude, Amazon Titan, Meta Llama, Mistral, Cohere, Stability AI
  - When to choose each model family (task suitability, context window, pricing)
- **Practice:** 10 questions on model selection criteria

#### Day 2 (Tuesday): Amazon Bedrock Core APIs
- **Study Topics:**
  - Bedrock runtime APIs: `InvokeModel`, `InvokeModelWithResponseStream`
  - Bedrock management APIs: `ListFoundationModels`, `GetFoundationModel`
  - Converse API and its advantages over model-specific APIs
  - Request/response formats per model provider
- **Hands-on Lab:**
  - Set up AWS CLI and Boto3 for Bedrock access
  - Write a Python script to invoke Claude via `InvokeModel`
  - Write a Python script to invoke Titan Embeddings
  - Test the Converse API with multiple models
- **Read:**
  - [Amazon Bedrock API Reference](https://docs.aws.amazon.com/bedrock/latest/APIReference/)
  - [Bedrock Runtime API Reference](https://docs.aws.amazon.com/bedrock/latest/APIReference/API_Operations_Amazon_Bedrock_Runtime.html)
- **Practice:** 10 questions on Bedrock API patterns

#### Day 3 (Wednesday): Prompt Engineering Fundamentals
- **Study Topics:**
  - Zero-shot prompting: when and how to use it
  - Few-shot prompting: example selection, formatting, ordering
  - Chain-of-thought (CoT) prompting: step-by-step reasoning
  - System prompts vs. user prompts vs. assistant prefills
  - Temperature, top_p, top_k, max_tokens — what each controls
- **Hands-on Lab:**
  - Experiment with zero-shot vs. few-shot on a classification task
  - Compare chain-of-thought vs. direct prompting for math/logic problems
  - Test the effect of temperature on output variability
- **Read:**
  - [Prompt Engineering Guidelines for Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html)
  - [Anthropic Prompt Engineering Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/)
- **Key Concepts to Master:**
  - Prompt template design patterns
  - Inference parameter tuning and their impact on output quality
- **Practice:** 15 questions on prompt engineering

#### Day 4 (Thursday): Advanced Prompt Techniques
- **Study Topics:**
  - ReAct (Reasoning + Acting) prompting framework
  - Prompt chaining and multi-step workflows
  - Self-consistency prompting
  - Prompt templates with variable substitution
  - Amazon Bedrock Prompt Management (prompt flows, versions, variants)
- **Hands-on Lab:**
  - Build a ReAct-style prompt that reasons through a problem
  - Create a prompt chain that summarizes, then translates, then formats text
  - Use Amazon Bedrock Prompt Management to create and version prompts
- **Read:**
  - [Amazon Bedrock Prompt Management](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-management.html)
  - [Amazon Bedrock Prompt Flows](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-flows.html)
- **Practice:** 10 questions on advanced prompting and prompt management

#### Day 5 (Friday): Embeddings and Vector Concepts
- **Study Topics:**
  - What are embeddings and why they matter for GenAI
  - Text embeddings vs. multimodal embeddings
  - Cosine similarity and distance metrics
  - Vector database concepts: indexing, approximate nearest neighbor (ANN)
  - Amazon Titan Embeddings models (Text v1, Text v2, Multimodal)
  - Cohere Embed models on Bedrock
- **Hands-on Lab:**
  - Generate embeddings for a set of documents using Titan Embeddings
  - Compute cosine similarity between document pairs
  - Store and query embeddings in a Python-based vector store
- **Read:**
  - [Amazon Titan Embeddings](https://docs.aws.amazon.com/bedrock/latest/userguide/titan-embedding-models.html)
  - [Vector Search concepts in OpenSearch](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/knn.html)
- **Practice:** 10 questions on embeddings and vector similarity

#### Day 6 (Saturday): Review and Consolidation
- **Review:** All notes from Days 1-5
- **Build a mini-project:** A CLI chatbot that uses Bedrock Converse API with conversation history
- **Practice:** 25-question mini quiz covering the week's topics
- **Identify weak areas** for targeted review next week

#### Day 7 (Sunday): Rest or Light Review
- Skim flash cards from the week
- Re-read any topics that felt unclear
- Plan the coming week's study schedule

---

### Week 2: Domain 1 — RAG, Data Management, and Compliance (Part 2)

**Theme:** Deep-dive into RAG architectures, knowledge bases, data pipelines, and compliance.

#### Day 1 (Monday): RAG Architecture Fundamentals
- **Study Topics:**
  - RAG (Retrieval-Augmented Generation) end-to-end architecture
  - Why RAG: reducing hallucinations, adding domain knowledge, keeping data current
  - Chunking strategies: fixed-size, semantic, recursive, hierarchical
  - Chunk overlap and its impact on retrieval quality
  - Indexing and retrieval flow: embed → store → query → augment → generate
- **Read:**
  - [RAG concepts in Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/kb-rag.html)
  - [Knowledge Bases for Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base.html)
- **Key Concepts to Master:**
  - When RAG is preferable to fine-tuning
  - Trade-offs between chunk size and retrieval precision
- **Practice:** 10 questions on RAG architecture decisions

#### Day 2 (Tuesday): Knowledge Bases for Amazon Bedrock
- **Study Topics:**
  - Creating and configuring Knowledge Bases in Bedrock
  - Data source types: S3, Confluence, SharePoint, Salesforce, web crawler
  - Supported file formats (PDF, HTML, TXT, DOCX, CSV, MD)
  - Vector store options: Amazon OpenSearch Serverless, Aurora PostgreSQL (pgvector), Pinecone, Redis Enterprise
  - Sync operations and data ingestion scheduling
  - Metadata filtering in retrieval queries
- **Hands-on Lab:**
  - Create a Knowledge Base backed by S3 and OpenSearch Serverless
  - Upload a set of documents and trigger a sync
  - Query the Knowledge Base using the `RetrieveAndGenerate` API
  - Test metadata filtering to scope retrieval
- **Read:**
  - [Setting up a Knowledge Base](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-setup.html)
  - [Data source connectors](https://docs.aws.amazon.com/bedrock/latest/userguide/knowledge-base-ds.html)
- **Practice:** 15 questions on Knowledge Base configuration

#### Day 3 (Wednesday): Vector Databases on AWS
- **Study Topics:**
  - Amazon OpenSearch Serverless vector engine: configuration, scaling, cost
  - Amazon Aurora PostgreSQL with pgvector extension
  - Amazon Neptune for graph-based knowledge retrieval
  - Choosing between vector store options (managed vs. self-hosted, scale, query patterns)
  - Hybrid search: combining keyword search with vector similarity
- **Hands-on Lab:**
  - Set up an OpenSearch Serverless collection with vector search enabled
  - Index embeddings and perform k-NN search queries
  - Compare search results with and without hybrid search
- **Read:**
  - [OpenSearch Serverless Vector Engine](https://docs.aws.amazon.com/opensearch-service/latest/developerguide/serverless-vector-search.html)
  - [pgvector on Aurora](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/AuroraPostgreSQL.VectorDB.html)
- **Practice:** 10 questions on vector database selection and configuration

#### Day 4 (Thursday): Data Preparation and Pipelines
- **Study Topics:**
  - Data preprocessing for GenAI: cleaning, deduplication, formatting
  - ETL pipelines for GenAI data using AWS Glue
  - Amazon S3 data lake patterns for GenAI training data
  - Data versioning and lineage tracking
  - Data labeling with Amazon SageMaker Ground Truth
  - Handling unstructured data (PDFs, images, audio) with Amazon Textract, Rekognition, Transcribe
- **Hands-on Lab:**
  - Build a simple Glue job that preprocesses documents for a Knowledge Base
  - Use Textract to extract text from PDFs and prepare them for RAG ingestion
- **Read:**
  - [AWS Glue Developer Guide](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html)
  - [Amazon Textract](https://docs.aws.amazon.com/textract/latest/dg/what-is.html)
- **Practice:** 10 questions on data pipeline architecture

#### Day 5 (Friday): Compliance, Licensing, and Data Governance
- **Study Topics:**
  - Data residency requirements and AWS Regions
  - GDPR considerations for GenAI (right to be forgotten, data minimization)
  - HIPAA compliance for healthcare GenAI applications
  - SOC 2 and PCI DSS relevance to GenAI workloads
  - Model licensing: open-source vs. proprietary model usage rights
  - Intellectual property considerations for AI-generated content
  - AWS Artifact for compliance reports
  - AWS Config rules for GenAI resource compliance
- **Read:**
  - [AWS Compliance Programs](https://aws.amazon.com/compliance/programs/)
  - [Amazon Bedrock Security](https://docs.aws.amazon.com/bedrock/latest/userguide/security.html)
  - [Shared Responsibility Model for AI](https://aws.amazon.com/compliance/shared-responsibility-model/)
- **Key Concepts to Master:**
  - Which compliance controls are AWS's responsibility vs. the customer's
  - How model licensing affects architecture decisions
- **Practice:** 15 questions on compliance and data governance

#### Day 6 (Saturday): Review and Consolidation
- **Review:** All notes from Week 2
- **Build a mini-project:** A RAG-based Q&A system using Knowledge Bases for Bedrock
- **Practice:** 30-question mini exam covering all Domain 1 topics (Weeks 1-2)
- **Score and identify gaps** — bookmark any concepts scoring below 80%

#### Day 7 (Sunday): Rest or Light Review
- Review flash cards
- Re-read flagged weak areas
- Prepare for Domain 2

---

### Week 3: Domain 2 — Bedrock Agents, SageMaker, and Core Implementation (Part 1)

**Theme:** Build with Bedrock Agents, understand SageMaker for GenAI, and core integration patterns.

#### Day 1 (Monday): Amazon Bedrock Agents
- **Study Topics:**
  - Bedrock Agents architecture: orchestration, action groups, knowledge bases
  - Creating and configuring Agents
  - Action groups: Lambda function integration, OpenAPI schemas
  - Agent instruction design and persona configuration
  - Agent session management and memory
  - Return of control (user confirmation flows)
- **Hands-on Lab:**
  - Create a Bedrock Agent with a knowledge base and one action group
  - Write a Lambda function as an action group backend
  - Define an OpenAPI schema for the action group
  - Test the agent through the Bedrock console and programmatically
- **Read:**
  - [Amazon Bedrock Agents](https://docs.aws.amazon.com/bedrock/latest/userguide/agents.html)
  - [Action groups](https://docs.aws.amazon.com/bedrock/latest/userguide/agents-action-groups.html)
- **Practice:** 15 questions on Bedrock Agents

#### Day 2 (Tuesday): Amazon Bedrock Guardrails
- **Study Topics:**
  - Guardrails architecture and use cases
  - Content filters: hate, insults, sexual, violence, misconduct, prompt attacks
  - Denied topics: defining and enforcing topic restrictions
  - Word filters: custom word/phrase blocking, profanity filter
  - Sensitive information filters: PII detection and handling (mask vs. block)
  - Contextual grounding checks: relevance and faithfulness thresholds
  - Applying Guardrails to model invocations and agent interactions
- **Hands-on Lab:**
  - Create a Guardrail with content filters, denied topics, and PII detection
  - Apply the Guardrail to an `InvokeModel` call and test with adversarial inputs
  - Test contextual grounding with a RAG pipeline
- **Read:**
  - [Amazon Bedrock Guardrails](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)
  - [Guardrails components](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails-components.html)
- **Practice:** 10 questions on Guardrails configuration

#### Day 3 (Wednesday): Amazon SageMaker for GenAI
- **Study Topics:**
  - SageMaker JumpStart: deploying foundation models
  - SageMaker endpoints: real-time, serverless, asynchronous, batch transform
  - SageMaker Training: fine-tuning foundation models
  - SageMaker Studio for GenAI development
  - Hugging Face integration on SageMaker
  - Instance types for GenAI workloads (ml.g5, ml.p4d, ml.p5, ml.inf2)
- **Hands-on Lab:**
  - Deploy a Llama model via SageMaker JumpStart
  - Test inference via a real-time endpoint
  - Compare real-time vs. serverless endpoint behavior
- **Read:**
  - [SageMaker JumpStart](https://docs.aws.amazon.com/sagemaker/latest/dg/studio-jumpstart.html)
  - [Deploy models for inference](https://docs.aws.amazon.com/sagemaker/latest/dg/deploy-model.html)
- **Practice:** 15 questions on SageMaker for GenAI

#### Day 4 (Thursday): Fine-Tuning Foundation Models
- **Study Topics:**
  - When to fine-tune vs. use RAG vs. prompt engineering
  - Amazon Bedrock custom model training (fine-tuning and continued pre-training)
  - Training data format requirements for Bedrock fine-tuning
  - Hyperparameter selection for fine-tuning (epochs, batch size, learning rate, warmup)
  - SageMaker fine-tuning with Hugging Face Transformers
  - Parameter-Efficient Fine-Tuning (PEFT): LoRA, QLoRA
  - Evaluation of fine-tuned models
- **Hands-on Lab:**
  - Prepare a JSONL training dataset for Bedrock fine-tuning
  - Launch a fine-tuning job in Bedrock (or simulate the configuration)
  - Compare base model vs. fine-tuned model outputs
- **Read:**
  - [Custom models in Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/custom-models.html)
  - [Fine-tuning on SageMaker](https://docs.aws.amazon.com/sagemaker/latest/dg/adapt-training.html)
- **Practice:** 10 questions on fine-tuning decisions and configuration

#### Day 5 (Friday): Streaming, Async Patterns, and Error Handling
- **Study Topics:**
  - Streaming responses with `InvokeModelWithResponseStream`
  - Converse API streaming mode
  - Asynchronous invocation patterns with SageMaker async endpoints
  - Error handling: throttling (429), service errors (5xx), validation errors (4xx)
  - Retry strategies and exponential backoff
  - Dead letter queues for failed invocations
- **Hands-on Lab:**
  - Implement streaming response handling in Python
  - Build a retry wrapper with exponential backoff for Bedrock calls
  - Set up an SQS dead letter queue for failed async invocations
- **Read:**
  - [Bedrock streaming](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-invoke.html)
  - [Error handling best practices](https://docs.aws.amazon.com/bedrock/latest/userguide/troubleshooting.html)
- **Practice:** 10 questions on streaming and error handling

#### Day 6 (Saturday): Review and Consolidation
- **Review:** All notes from Week 3
- **Build a mini-project:** A Bedrock Agent that queries a knowledge base and calls an external API
- **Practice:** 25-question quiz on Week 3 topics
- **Score and flag weak areas**

#### Day 7 (Sunday): Rest or Light Review

---

### Week 4: Domain 2 — Integration Patterns and Workflows (Part 2)

**Theme:** Advanced integration with AWS services, orchestration, and application architectures.

#### Day 1 (Monday): Serverless GenAI Architectures
- **Study Topics:**
  - AWS Lambda for GenAI: function design, timeout considerations, memory/CPU tuning
  - Lambda Powertools for observability in GenAI functions
  - API Gateway REST and WebSocket APIs for GenAI endpoints
  - WebSocket APIs for streaming GenAI responses to frontends
  - Amazon EventBridge for event-driven GenAI workflows
- **Hands-on Lab:**
  - Build a Lambda function that invokes Bedrock and returns via API Gateway
  - Set up a WebSocket API for streaming chat responses
  - Create an EventBridge rule that triggers a GenAI workflow on S3 upload
- **Read:**
  - [Lambda best practices](https://docs.aws.amazon.com/lambda/latest/dg/best-practices.html)
  - [API Gateway WebSocket APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api.html)
- **Practice:** 10 questions on serverless GenAI patterns

#### Day 2 (Tuesday): Orchestration with Step Functions
- **Study Topics:**
  - AWS Step Functions for GenAI workflow orchestration
  - Bedrock integration with Step Functions (optimized integrations)
  - Parallel processing patterns for multi-model invocations
  - Error handling and retry in Step Functions workflows
  - Map state for batch processing GenAI tasks
  - Human-in-the-loop patterns with callback tasks
- **Hands-on Lab:**
  - Build a Step Functions workflow that chains Bedrock calls (summarize → translate → format)
  - Add error handling and retry logic
  - Implement a parallel state for comparing outputs from multiple models
- **Read:**
  - [Step Functions Bedrock integration](https://docs.aws.amazon.com/step-functions/latest/dg/connect-bedrock.html)
  - [Step Functions best practices](https://docs.aws.amazon.com/step-functions/latest/dg/best-practices.html)
- **Practice:** 10 questions on Step Functions orchestration

#### Day 3 (Wednesday): LangChain and Frameworks on AWS
- **Study Topics:**
  - LangChain framework fundamentals (chains, agents, tools, memory)
  - LangChain integration with Amazon Bedrock
  - LangChain integration with Amazon Bedrock Knowledge Bases
  - LangChain vs. native Bedrock Agents: when to use each
  - Other frameworks: LlamaIndex, Haystack on AWS
  - Amazon Bedrock Prompt Flows as a managed alternative
- **Hands-on Lab:**
  - Build a LangChain RAG pipeline using Bedrock and OpenSearch
  - Implement a LangChain agent with custom tools backed by AWS services
  - Compare LangChain agent vs. Bedrock Agent for the same task
- **Read:**
  - [LangChain Bedrock integration docs](https://python.langchain.com/docs/integrations/providers/aws/)
  - [Amazon Bedrock Prompt Flows](https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-flows.html)
- **Practice:** 10 questions on framework selection

#### Day 4 (Thursday): Conversational AI and Memory Management
- **Study Topics:**
  - Conversation history management patterns
  - Amazon Bedrock Converse API session management
  - Context window management: truncation, summarization, sliding window
  - DynamoDB for conversation persistence
  - Amazon Lex integration with Bedrock for voice/chat bots
  - Multi-turn conversation design patterns
- **Hands-on Lab:**
  - Build a multi-turn chatbot with DynamoDB-backed conversation history
  - Implement context window management with automatic summarization
  - Test conversation continuity across sessions
- **Read:**
  - [Converse API](https://docs.aws.amazon.com/bedrock/latest/userguide/conversation-inference-call.html)
  - [Amazon Lex V2](https://docs.aws.amazon.com/lexv2/latest/dg/what-is.html)
- **Practice:** 10 questions on conversational AI patterns

#### Day 5 (Friday): Amazon Q Developer and Code Generation
- **Study Topics:**
  - Amazon Q Developer (formerly CodeWhisperer) capabilities
  - Code generation, completion, and transformation features
  - Amazon Q for IDE integration
  - Amazon Q for CLI and chat-based development
  - Amazon Q Apps for business user self-service
  - Code review and security scanning with Amazon Q
- **Hands-on Lab:**
  - Install and configure Amazon Q Developer in your IDE
  - Test code generation, explanation, and refactoring features
  - Use Amazon Q Chat for AWS architecture questions
- **Read:**
  - [Amazon Q Developer](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/what-is.html)
  - [Amazon Q Apps](https://docs.aws.amazon.com/amazonq/latest/qbusiness-ug/purpose-built-qapps.html)
- **Practice:** 10 questions on Amazon Q capabilities

#### Day 6 (Saturday): Review and Consolidation
- **Review:** All notes from Weeks 3-4
- **Build a mini-project:** A full serverless GenAI application with API Gateway + Lambda + Bedrock + DynamoDB
- **Practice:** 30-question Domain 2 exam covering all implementation topics
- **Score and flag weak areas**

#### Day 7 (Sunday): Rest or Light Review

---

### Week 5: Domain 3 — AI Safety, Security, and Governance

**Theme:** Master safety, security controls, responsible AI, and governance for GenAI.

#### Day 1 (Monday): IAM and Access Control for GenAI
- **Study Topics:**
  - IAM policies for Amazon Bedrock (resource-level permissions)
  - Service-linked roles for Bedrock
  - Cross-account access patterns for shared GenAI resources
  - Resource-based policies for Bedrock custom models
  - SCP (Service Control Policies) to restrict model access at the organization level
  - Least-privilege access for GenAI services
- **Hands-on Lab:**
  - Write IAM policies that restrict access to specific Bedrock models
  - Configure cross-account access for a shared Knowledge Base
  - Test SCP-based model restrictions
- **Read:**
  - [IAM for Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/security-iam.html)
  - [Bedrock IAM policy examples](https://docs.aws.amazon.com/bedrock/latest/userguide/security_iam_id-based-policy-examples.html)
- **Practice:** 15 questions on IAM for GenAI

#### Day 2 (Tuesday): Network Security and Encryption
- **Study Topics:**
  - VPC endpoints for Amazon Bedrock (interface endpoints via PrivateLink)
  - Private connectivity patterns: no internet exposure for GenAI calls
  - Encryption at rest: AWS KMS, customer-managed keys for model artifacts
  - Encryption in transit: TLS 1.2+ for all Bedrock API calls
  - S3 encryption for training data and knowledge base sources
  - Amazon Macie for detecting sensitive data in GenAI datasets
- **Hands-on Lab:**
  - Set up a VPC endpoint for Bedrock
  - Configure a KMS key for Bedrock custom model encryption
  - Invoke Bedrock from a private subnet via VPC endpoint
- **Read:**
  - [VPC endpoints for Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/vpc-interface-endpoints.html)
  - [Encryption in Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/data-protection.html)
- **Practice:** 10 questions on network security

#### Day 3 (Wednesday): Logging, Monitoring, and Auditing
- **Study Topics:**
  - AWS CloudTrail for Bedrock API auditing
  - Amazon Bedrock model invocation logging (input/output logging to S3 and CloudWatch)
  - CloudWatch metrics for Bedrock (invocation count, latency, errors, throttling)
  - CloudWatch alarms for GenAI anomaly detection
  - AWS Config rules for GenAI compliance monitoring
  - Centralized logging architecture for multi-account GenAI deployments
- **Hands-on Lab:**
  - Enable model invocation logging in Bedrock
  - Set up CloudWatch alarms for throttling and error rates
  - Create a CloudTrail trail that captures all Bedrock API calls
- **Read:**
  - [Bedrock model invocation logging](https://docs.aws.amazon.com/bedrock/latest/userguide/model-invocation-logging.html)
  - [Monitoring Bedrock with CloudWatch](https://docs.aws.amazon.com/bedrock/latest/userguide/monitoring-cw.html)
- **Practice:** 10 questions on logging and monitoring

#### Day 4 (Thursday): Responsible AI and Bias Mitigation
- **Study Topics:**
  - AWS Responsible AI principles
  - AI Service Cards: purpose, contents, how to use them
  - Bias types in GenAI: training data bias, representation bias, confirmation bias
  - Bias detection techniques for GenAI outputs
  - Mitigation strategies: diverse training data, evaluation benchmarks, human review
  - Hallucination types: factual, contextual, logical
  - Hallucination reduction: RAG, grounding, confidence scoring, citation generation
  - Amazon SageMaker Clarify for bias detection
- **Read:**
  - [AWS AI Service Cards](https://aws.amazon.com/machine-learning/responsible-machine-learning/)
  - [Amazon SageMaker Clarify](https://docs.aws.amazon.com/sagemaker/latest/dg/clarify-fairness-and-explainability.html)
- **Key Concepts to Master:**
  - The difference between model-level and application-level responsible AI controls
  - How Guardrails, RAG, and human review work together for safety
- **Practice:** 15 questions on responsible AI

#### Day 5 (Friday): Content Moderation and Compliance Frameworks
- **Study Topics:**
  - Building content moderation pipelines for GenAI outputs
  - Amazon Comprehend for sentiment and toxicity detection
  - Amazon Rekognition for image content moderation in multimodal pipelines
  - Compliance frameworks: SOC 2, ISO 27001, HIPAA, FedRAMP
  - AWS Audit Manager for GenAI compliance evidence
  - Documentation requirements for AI governance
- **Hands-on Lab:**
  - Build a content moderation pipeline: Bedrock → Comprehend toxicity check → conditional routing
  - Configure Audit Manager for GenAI-related controls
- **Read:**
  - [Amazon Comprehend](https://docs.aws.amazon.com/comprehend/latest/dg/what-is.html)
  - [AWS Audit Manager](https://docs.aws.amazon.com/audit-manager/latest/userguide/what-is.html)
- **Practice:** 10 questions on content moderation and compliance

#### Day 6 (Saturday): Review and Consolidation
- **Review:** All Domain 3 notes
- **Practice:** 25-question Domain 3 exam
- **Score and flag weak areas**
- **Build a mini-project:** A secure GenAI API with VPC endpoints, Guardrails, and invocation logging

#### Day 7 (Sunday): Rest or Light Review

---

### Week 6: Domain 4 (Optimization) + Domain 5 (Testing and Troubleshooting)

**Theme:** Cost/performance optimization and testing/validation for GenAI applications.

#### Day 1 (Monday): Cost Optimization for GenAI
- **Study Topics:**
  - Amazon Bedrock pricing models: on-demand vs. provisioned throughput vs. batch inference
  - Token-based pricing: understanding input tokens vs. output tokens
  - Prompt optimization to reduce token count (concise prompts, efficient system prompts)
  - Caching strategies: prompt caching in Bedrock, semantic caching with ElastiCache
  - Model selection for cost: smaller models for simple tasks, larger models for complex tasks
  - SageMaker endpoint cost optimization: instance selection, auto-scaling, spot instances
  - AWS Cost Explorer and Budgets for GenAI workload tracking
- **Hands-on Lab:**
  - Compare costs across different Bedrock models for the same task
  - Implement a semantic cache layer using ElastiCache/Redis
  - Set up Cost Explorer tags to track GenAI spending
- **Read:**
  - [Amazon Bedrock Pricing](https://aws.amazon.com/bedrock/pricing/)
  - [Provisioned Throughput](https://docs.aws.amazon.com/bedrock/latest/userguide/prov-throughput.html)
- **Practice:** 15 questions on cost optimization

#### Day 2 (Tuesday): Latency and Performance Optimization
- **Study Topics:**
  - Latency components: network, tokenization, inference, detokenization
  - Streaming responses to reduce perceived latency
  - Provisioned throughput for guaranteed performance
  - Amazon Bedrock batch inference for non-real-time workloads
  - Edge caching with CloudFront for GenAI responses
  - Concurrency management and throttle handling
  - Model distillation concepts: using smaller models trained on larger model outputs
- **Hands-on Lab:**
  - Benchmark latency across Bedrock models (time-to-first-token, total latency)
  - Implement streaming with latency measurement
  - Configure provisioned throughput and compare performance
- **Read:**
  - [Bedrock quotas and limits](https://docs.aws.amazon.com/bedrock/latest/userguide/quotas.html)
  - [Batch inference](https://docs.aws.amazon.com/bedrock/latest/userguide/batch-inference.html)
- **Practice:** 10 questions on performance optimization

#### Day 3 (Wednesday): Monitoring and Observability for GenAI
- **Study Topics:**
  - CloudWatch dashboards for GenAI workloads
  - Custom metrics: response quality scores, user satisfaction, cost-per-query
  - Distributed tracing with AWS X-Ray for GenAI pipelines
  - Alarm strategies: latency spikes, error rate increases, cost anomalies
  - Amazon Managed Grafana for GenAI dashboards
  - Operational runbooks for GenAI incident response
- **Hands-on Lab:**
  - Build a CloudWatch dashboard with key GenAI metrics
  - Implement X-Ray tracing through a Lambda → Bedrock pipeline
  - Create composite alarms for GenAI health monitoring
- **Read:**
  - [AWS X-Ray](https://docs.aws.amazon.com/xray/latest/devguide/aws-xray.html)
  - [CloudWatch dashboards](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html)
- **Practice:** 10 questions on monitoring and observability

#### Day 4 (Thursday): GenAI Evaluation Metrics and Methods
- **Study Topics:**
  - Automated evaluation metrics: ROUGE, BLEU, BERTScore, METEOR
  - When to use each metric (summarization → ROUGE, translation → BLEU, general → BERTScore)
  - Human evaluation frameworks: Likert scales, pairwise comparison, A/B testing
  - Amazon Bedrock model evaluation jobs (automatic and human evaluation)
  - LLM-as-a-judge: using one model to evaluate another
  - Custom evaluation pipelines with SageMaker Processing
  - Evaluation datasets: creation, curation, versioning
- **Hands-on Lab:**
  - Run a Bedrock model evaluation job comparing two models
  - Implement ROUGE scoring for a summarization task in Python
  - Build an LLM-as-a-judge pipeline using Bedrock
- **Read:**
  - [Bedrock model evaluation](https://docs.aws.amazon.com/bedrock/latest/userguide/model-evaluation.html)
  - [Evaluation metrics concepts](https://docs.aws.amazon.com/bedrock/latest/userguide/model-evaluation-report.html)
- **Practice:** 15 questions on evaluation metrics and methods

#### Day 5 (Friday): Testing and Troubleshooting GenAI Applications
- **Study Topics:**
  - Unit testing GenAI components: mocking Bedrock calls, testing prompt templates
  - Integration testing: end-to-end RAG pipeline testing
  - Regression testing: detecting quality degradation after prompt or model changes
  - Load testing GenAI APIs: considerations for token-based rate limits
  - Common troubleshooting scenarios:
    - ThrottlingException: causes and resolution
    - ModelTimeoutException: context window overflow
    - ValidationException: malformed requests
    - AccessDeniedException: IAM misconfigurations
    - Hallucinations in production: detection and handling
    - RAG retrieval quality issues: re-chunking, re-indexing, metadata tuning
  - Debugging tools: CloudWatch Logs Insights queries, X-Ray trace analysis
- **Hands-on Lab:**
  - Write unit tests for a Bedrock-based Lambda function using moto/mocking
  - Build a regression test suite that checks output quality against golden datasets
  - Debug a simulated RAG quality issue (poor chunking → bad retrieval → hallucination)
- **Read:**
  - [Bedrock troubleshooting](https://docs.aws.amazon.com/bedrock/latest/userguide/troubleshooting.html)
  - [Bedrock quotas](https://docs.aws.amazon.com/bedrock/latest/userguide/quotas.html)
- **Practice:** 15 questions on testing and troubleshooting

#### Day 6 (Saturday): Review and Consolidation
- **Review:** All Domain 4 and Domain 5 notes
- **Practice:** 30-question combined exam for Domains 4 and 5
- **Score and flag weak areas**

#### Day 7 (Sunday): Rest or Light Review

---

### Week 7: Practice Exams and Weak Area Review

**Theme:** Test yourself under exam conditions and systematically close knowledge gaps.

#### Day 1 (Monday): Full Practice Exam #1
- Take a full 75-question practice exam under timed conditions (180 minutes)
- Simulate exam conditions: no notes, no breaks, no looking up answers
- Score the exam and record your results by domain
- **Target:** Identify domains where you score below 75%

#### Day 2 (Tuesday): Practice Exam #1 Review
- Review every question you got wrong or were uncertain about
- For each wrong answer:
  1. Identify the domain and topic
  2. Understand why the correct answer is correct
  3. Understand why your answer was wrong
  4. Write a brief note on the concept
- Group mistakes by theme and domain

#### Day 3 (Wednesday): Targeted Review — Weakest Domain
- Spend the entire day on your weakest domain from Practice Exam #1
- Re-read relevant AWS documentation
- Redo hands-on labs for that domain
- Take a 25-question focused quiz on that domain
- **Target:** Improve weak domain score by 15-20%

#### Day 4 (Thursday): Targeted Review — Second Weakest Domain
- Same approach as Day 3, but for your second weakest domain
- Focus on the specific topics within the domain that caused mistakes
- Take a 25-question focused quiz

#### Day 5 (Friday): Full Practice Exam #2
- Take a different full 75-question practice exam under timed conditions
- Compare scores to Practice Exam #1
- **Target:** Overall score improvement of 10%+ and no domain below 70%

#### Day 6 (Saturday): Practice Exam #2 Review + Gap Closure
- Review all wrong answers from Practice Exam #2
- Create a "final weak areas" list
- Deep-dive into remaining weak topics
- Take targeted quizzes on remaining weak areas

#### Day 7 (Sunday): Rest — Light Flash Card Review Only

---

### Week 8: Final Review and Exam

#### Day 1 (Monday): Rapid Domain Review — Domains 1 & 2
- Speed-review all Domain 1 and Domain 2 notes (skim, don't deep-read)
- Focus on key decision points that show up in exam questions:
  - When to use RAG vs. fine-tuning vs. prompt engineering
  - Bedrock vs. SageMaker decision criteria
  - Knowledge Base vector store selection
  - Agent vs. Prompt Flow vs. LangChain
- Take a 20-question rapid quiz covering D1 and D2

#### Day 2 (Tuesday): Rapid Domain Review — Domains 3, 4 & 5
- Speed-review all Domain 3, 4, and 5 notes
- Focus on:
  - Guardrails configuration scenarios
  - IAM and VPC endpoint patterns
  - Cost optimization decision points
  - Evaluation metric selection
  - Common error codes and troubleshooting steps
- Take a 20-question rapid quiz covering D3, D4, and D5

#### Day 3 (Wednesday): Full Practice Exam #3 (Final)
- Take your final full-length practice exam
- **Target:** Score 85%+ overall, no domain below 75%
- Review any remaining wrong answers
- If below target, focus remaining days on gap areas

#### Day 4 (Thursday): Exam-Day Preparation
- Light review only — skim your summary notes and flash cards
- Review the exam logistics:
  - Test center location or online proctoring setup
  - Required ID documents
  - What you can/cannot bring
  - How to flag questions for review
- Get a good night's sleep
- Prepare everything you need for exam day

#### Day 5 (Friday): EXAM DAY
- Arrive early (30 minutes for test center, 15 minutes for online)
- Take the exam with confidence
- Use all remaining time to review flagged questions
- Do not change answers unless you are certain

#### Day 6-7 (Weekend): Recovery and Next Steps
- Results are typically available within a few hours
- If passed: celebrate and plan your next certification
- If not passed: review the score report, identify weak domains, schedule a retake in 2-4 weeks

---

## Exam Strategies

### Time Management

| Strategy                  | Details                                                    |
| ------------------------- | ---------------------------------------------------------- |
| **Total Time**            | 180 minutes for 75 questions = ~2.4 minutes per question   |
| **First Pass**            | Answer all questions in order, flag uncertain ones (~90 min) |
| **Second Pass**           | Return to flagged questions with fresh perspective (~60 min) |
| **Final Pass**            | Review all answers, ensure no blanks (~30 min)              |
| **Never leave blanks**    | No penalty for wrong answers — always answer every question |

### Time Checkpoints

- After 25 questions: ~60 minutes should have elapsed
- After 50 questions: ~120 minutes should have elapsed
- After 75 questions: should have ~30 minutes remaining for review
- If behind pace, spend less time per question and flag more for review

### Question Approach Strategy

1. **Read the question stem carefully.** Identify what is actually being asked — the last sentence usually contains the actual question.
2. **Identify keywords:** "most cost-effective," "least operational overhead," "most secure," "best practice" — these change the correct answer.
3. **Read ALL answer choices** before selecting. The first plausible answer is often a distractor.
4. **Eliminate obviously wrong answers** first. This typically removes 1-2 options immediately.
5. **For scenario questions:** Identify the constraints (budget, timeline, team size, compliance requirements) and match them to the solution.

### Handling Scenario-Based Questions

Scenario questions make up the majority of the exam. They follow this pattern:

```
A company is building [description of system].
They need [specific requirement].
They have [constraints].
Which solution meets these requirements?
```

**Approach:**
1. Underline/note the **requirements** (what must the solution do?)
2. Underline/note the **constraints** (cost, time, complexity, compliance)
3. Evaluate each answer against ALL requirements and constraints
4. The correct answer satisfies ALL stated requirements, not just some

### Elimination Techniques

- **"Always" and "Never" answers** are usually wrong — AWS solutions are context-dependent
- **Overly complex answers** are usually wrong when a simpler managed service exists
- **Answers mentioning deprecated services** are wrong
- **If two answers are very similar**, one of them is likely correct
- **"Custom build" options** are usually wrong when a managed AWS service covers the use case
- **Answers that violate the Well-Architected Framework** (e.g., single AZ, no encryption) are wrong

### When to Guess vs. Skip

- **Never skip** — there is no penalty for wrong answers
- **Flag and move on** if you've spent more than 3 minutes on a question
- **Make your best guess** even when flagging — your first instinct is often correct
- **Return to flagged questions** in your second pass with fresh eyes
- **If stuck between two answers**, go with the one that uses more managed AWS services

### Key Decision Frameworks for Common Question Types

| Question Type                        | Think About                                      |
| ------------------------------------ | ------------------------------------------------ |
| RAG vs. Fine-tuning                  | Data freshness, cost, complexity, accuracy needs |
| Bedrock vs. SageMaker                | Managed vs. flexible, custom model needs         |
| On-demand vs. Provisioned Throughput | Traffic patterns, latency requirements, budget   |
| Guardrails vs. Custom Moderation     | Simplicity, customization needs, multi-model     |
| Real-time vs. Batch Inference        | Latency requirements, cost, volume               |

---

## Recommended Resources

### Official AWS Training

| Resource                                                         | Type        | Cost     |
| ---------------------------------------------------------------- | ----------- | -------- |
| AWS Skill Builder — Generative AI Learning Plan for Developers   | Online      | Free     |
| AWS Skill Builder — Building Generative AI Applications on AWS   | Online      | Free     |
| Developing Generative AI Applications on AWS (classroom)         | Classroom   | Paid     |
| AWS Cloud Quest: Machine Learning                                | Game-based  | Free     |
| Official AIP-C01 Exam Prep Course on Skill Builder               | Online      | Subscription |

### AWS Documentation (Must-Read)

| Document                                          | Priority  |
| ------------------------------------------------- | --------- |
| Amazon Bedrock User Guide                         | Critical  |
| Amazon Bedrock API Reference                      | Critical  |
| Amazon SageMaker Developer Guide (GenAI sections) | High      |
| Amazon Q Developer User Guide                     | High      |
| AWS Well-Architected — Machine Learning Lens      | High      |
| Amazon OpenSearch Serverless Developer Guide       | Medium    |
| AWS Lambda Developer Guide                        | Medium    |
| AWS Step Functions Developer Guide                | Medium    |
| AWS IAM User Guide (Bedrock policies)             | Medium    |
| AWS KMS Developer Guide                           | Low       |

### Practice Exam Sources

| Source                                             | Questions | Notes                          |
| -------------------------------------------------- | --------- | ------------------------------ |
| AWS Official Practice Question Set (Skill Builder)  | 20        | Free, closest to real exam     |
| AWS Official Practice Exam (Skill Builder)          | 65        | Paid subscription              |
| Tutorials Dojo AIP-C01 Practice Exams              | 300+      | Highly recommended, detailed explanations |
| Whizlabs AIP-C01 Practice Tests                    | 200+      | Good variety of questions      |
| Neal Davis / Digital Cloud Training                 | 150+      | Scenario-heavy                 |

### Hands-On Lab Platforms

| Platform                              | Highlights                                        |
| ------------------------------------- | ------------------------------------------------- |
| AWS Skill Builder Labs                | Official labs, Bedrock-focused                    |
| AWS Workshops (workshops.aws)         | Free, topic-specific workshops                    |
| A Cloud Guru / Pluralsight Labs       | Sandboxed AWS environment                         |
| Personal AWS Account                  | Best for unrestricted experimentation (watch costs!) |

### Community Resources

| Resource                                    | Type              |
| ------------------------------------------- | ----------------- |
| AWS re:Post — Generative AI                 | Q&A Forum         |
| r/AWSCertifications on Reddit               | Community         |
| AWS Certified Global Community (LinkedIn)   | Networking        |
| AWS re:Invent session recordings (YouTube)  | Video lectures    |
| AWS Blog — Machine Learning category         | Latest features   |
| Last Week in AWS (newsletter)               | Industry updates  |

---

## Study Materials Index

This study package consists of the following files. Work through them in order, aligned with the weekly study plan above.

| File | Title | Relevant Domains | Study Week |
| ---- | ----- | ---------------- | ---------- |
| `00-EXAM-OVERVIEW-AND-STUDY-PLAN.md` | Exam Overview and Study Plan (this file) | All | All |
| `01-FOUNDATION-MODELS-AND-BEDROCK.md` | Foundation Models and Amazon Bedrock Core Concepts | D1 | Week 1 |
| `02-PROMPT-ENGINEERING.md` | Prompt Engineering Techniques and Best Practices | D1 | Week 1 |
| `03-RAG-AND-KNOWLEDGE-BASES.md` | RAG Architecture and Knowledge Bases for Bedrock | D1 | Week 2 |
| `04-EMBEDDINGS-AND-VECTOR-DATABASES.md` | Embeddings, Vector Databases, and Similarity Search | D1 | Week 2 |
| `05-DATA-MANAGEMENT-AND-COMPLIANCE.md` | Data Management, Pipelines, and Compliance | D1 | Week 2 |
| `06-BEDROCK-AGENTS-AND-GUARDRAILS.md` | Amazon Bedrock Agents and Guardrails | D2, D3 | Week 3 |
| `07-SAGEMAKER-FOR-GENAI.md` | Amazon SageMaker for GenAI Development | D2 | Week 3 |
| `08-FINE-TUNING-AND-CUSTOMIZATION.md` | Fine-Tuning, PEFT, and Model Customization | D2 | Week 3 |
| `09-INTEGRATION-PATTERNS.md` | Serverless and Integration Patterns for GenAI | D2 | Week 4 |
| `10-SECURITY-AND-GOVERNANCE.md` | AI Safety, Security, IAM, and Governance | D3 | Week 5 |
| `11-RESPONSIBLE-AI.md` | Responsible AI, Bias Detection, and Content Moderation | D3 | Week 5 |
| `12-COST-AND-PERFORMANCE-OPTIMIZATION.md` | Cost Optimization and Performance Tuning | D4 | Week 6 |
| `13-TESTING-AND-EVALUATION.md` | Testing, Evaluation Metrics, and Validation | D5 | Week 6 |
| `14-TROUBLESHOOTING-AND-DEBUGGING.md` | Troubleshooting, Debugging, and Common Issues | D5 | Week 6 |

### How to Use This Package

1. **Start with this file** — understand the exam structure and plan your schedule.
2. **Follow the weekly plan** — each week maps to specific files above.
3. **Do the hands-on labs** — reading alone is not sufficient for this exam.
4. **Take practice exams** — use Week 7 to close gaps revealed by practice tests.
5. **Revisit weak areas** — use the domain-to-file mapping above to quickly find review material.

---

## Quick Reference: AWS Services for the AIP-C01 Exam

### Core GenAI Services (Know Deeply)

| Service                       | What to Know                                           |
| ----------------------------- | ------------------------------------------------------ |
| Amazon Bedrock                | APIs, models, agents, guardrails, knowledge bases, prompt management, custom models, evaluation |
| Amazon SageMaker              | JumpStart, training, fine-tuning, endpoints, inference |
| Amazon Q Developer            | Code generation, IDE integration, chat capabilities    |

### Supporting AWS Services (Know Well)

| Service                        | Relevance to GenAI                                    |
| ------------------------------ | ----------------------------------------------------- |
| AWS Lambda                     | Serverless compute for GenAI functions                |
| Amazon API Gateway             | REST/WebSocket APIs for GenAI endpoints               |
| AWS Step Functions             | Orchestrating multi-step GenAI workflows              |
| Amazon S3                      | Data storage for training data, knowledge bases       |
| Amazon DynamoDB                | Conversation history, session management              |
| Amazon OpenSearch Serverless   | Vector store for RAG/knowledge bases                  |
| Amazon Aurora (pgvector)       | Alternative vector store for RAG                      |
| Amazon CloudWatch              | Monitoring, logging, metrics for GenAI                |
| AWS CloudTrail                 | API auditing for GenAI services                       |
| AWS IAM                        | Access control for all GenAI services                 |
| AWS KMS                        | Encryption key management for GenAI data              |
| Amazon EventBridge             | Event-driven GenAI triggers                           |
| Amazon SQS                     | Async messaging, dead letter queues                   |

### Peripheral Services (Know at a High Level)

| Service                   | Relevance                                              |
| ------------------------- | ------------------------------------------------------ |
| Amazon Textract           | Extract text from documents for RAG                    |
| Amazon Comprehend         | NLP, sentiment, toxicity detection                     |
| Amazon Rekognition        | Image moderation in multimodal pipelines               |
| Amazon Transcribe         | Speech-to-text for voice-based GenAI                   |
| Amazon Lex                | Conversational bots with Bedrock backends              |
| AWS Glue                  | ETL for GenAI data pipelines                           |
| Amazon Macie              | Sensitive data detection in GenAI datasets             |
| AWS Config                | Compliance monitoring for GenAI resources              |
| AWS Audit Manager         | Compliance evidence collection                         |
| Amazon ElastiCache        | Semantic caching for GenAI responses                   |
| Amazon CloudFront         | Edge caching for GenAI API responses                   |
| AWS X-Ray                 | Distributed tracing for GenAI pipelines                |
| SageMaker Clarify         | Bias and explainability analysis                       |
| SageMaker Ground Truth    | Data labeling for GenAI training data                  |

---

## Final Checklist: Are You Ready for the Exam?

Use this checklist the day before your exam. You should be able to confidently check every item.

### Domain 1: Foundation Model Integration, Data Management, and Compliance
- [ ] I can list all model families on Amazon Bedrock and explain when to choose each
- [ ] I can write code to invoke Bedrock models using `InvokeModel` and the Converse API
- [ ] I understand prompt engineering techniques: zero-shot, few-shot, CoT, ReAct
- [ ] I can design a RAG architecture and select the right vector store
- [ ] I can configure a Knowledge Base in Bedrock with S3 data sources
- [ ] I understand chunking strategies and their impact on retrieval quality
- [ ] I know data compliance requirements (GDPR, HIPAA) and how they affect GenAI
- [ ] I understand model licensing implications

### Domain 2: Implementation and Integration
- [ ] I can create and configure Bedrock Agents with action groups
- [ ] I can set up Guardrails with content filters, denied topics, and PII detection
- [ ] I understand SageMaker JumpStart and endpoint types
- [ ] I know when to fine-tune vs. use RAG vs. prompt engineering
- [ ] I can design serverless GenAI architectures (Lambda + API Gateway + Bedrock)
- [ ] I can build Step Functions workflows for GenAI orchestration
- [ ] I understand LangChain integration with Bedrock
- [ ] I know Amazon Q Developer capabilities

### Domain 3: AI Safety, Security, and Governance
- [ ] I can write IAM policies for Bedrock with least-privilege access
- [ ] I understand VPC endpoints for private Bedrock access
- [ ] I know encryption patterns (KMS, at-rest, in-transit) for GenAI
- [ ] I can configure model invocation logging and CloudTrail auditing
- [ ] I understand responsible AI principles and bias mitigation
- [ ] I can design content moderation pipelines

### Domain 4: Operational Efficiency and Optimization
- [ ] I understand Bedrock pricing: on-demand vs. provisioned vs. batch
- [ ] I can optimize prompts to reduce token costs
- [ ] I know caching strategies for GenAI (prompt caching, semantic caching)
- [ ] I can select optimal model/instance types for cost vs. performance
- [ ] I understand monitoring and alerting for GenAI workloads

### Domain 5: Testing, Validation, and Troubleshooting
- [ ] I know evaluation metrics: ROUGE, BLEU, BERTScore and when to use each
- [ ] I can run Bedrock model evaluation jobs
- [ ] I understand LLM-as-a-judge evaluation patterns
- [ ] I can troubleshoot common Bedrock errors (throttling, timeout, validation)
- [ ] I can debug RAG quality issues (chunking, retrieval, generation)
- [ ] I know how to build regression tests for prompt changes

---

> **Good luck on your AIP-C01 exam! Consistent daily study, hands-on practice, and practice exams are the keys to passing.**
