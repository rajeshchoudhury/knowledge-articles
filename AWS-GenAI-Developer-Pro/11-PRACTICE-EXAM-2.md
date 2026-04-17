# AWS Certified Generative AI Developer – Professional (AIP-C01) — Practice Exam 2

> **75 Questions · 170 Minutes · Passing Score ≈ 750/1000**
> Difficulty: **Advanced** (harder than Practice Exam 1)

---

## Domain Distribution

| Domain | Questions | Weight |
|--------|-----------|--------|
| Domain 1 – Selecting & Integrating Foundation Models | Q1–Q20 | 31% |
| Domain 2 – Building GenAI Applications | Q21–Q37 | 26% |
| Domain 3 – Optimizing & Securing GenAI Solutions | Q38–Q50 | 20% |
| Domain 4 – Compliance, Governance & Incident Response | Q51–Q63 | ~17% |
| Domain 5 – CI/CD, Monitoring & Operational Excellence | Q64–Q75 | ~16% |

---

## QUESTIONS

---

**Question 1** [Domain 1]

A financial services company is building a real-time fraud-narrative generator that must produce explanations for flagged transactions within 200 ms. The application processes 50,000 requests per hour during peak periods. The team has tested Anthropic Claude 3 Sonnet on Amazon Bedrock and finds the quality excellent, but p99 latency occasionally spikes to 900 ms during peak hours. They have already enabled streaming responses. The team needs a solution that guarantees consistent low-latency performance without sacrificing output quality.

What should the team implement?

A) Switch to Anthropic Claude 3 Haiku to reduce latency, then use a post-processing Lambda to enhance output quality
B) Purchase Provisioned Throughput for Claude 3 Sonnet on Amazon Bedrock to guarantee dedicated capacity and consistent latency
C) Deploy Claude 3 Sonnet on a SageMaker real-time endpoint with auto-scaling and request batching enabled
D) Implement a client-side caching layer with Amazon ElastiCache to serve repeated fraud patterns without calling the model

---

**Question 2** [Domain 1]

A healthcare technology company needs to build a medical document summarization system. The documents contain Protected Health Information (PHI) and range from 2,000 to 180,000 tokens in length. The team must ensure no data leaves the AWS account boundary, and the system must handle documents that exceed typical context windows. They are evaluating Amazon Bedrock and Amazon SageMaker for this workload.

Which approach meets ALL requirements?

A) Use Amazon Bedrock with Anthropic Claude 3.5 Sonnet (200K context window) for all documents, enabling VPC endpoints for private connectivity
B) Use Amazon SageMaker to deploy a Llama 3 model within a private VPC with no internet access, and implement a map-reduce summarization pattern for documents exceeding the context window
C) Use Amazon Bedrock with Anthropic Claude 3.5 Sonnet for documents under 200K tokens and fall back to a SageMaker-hosted model with chunked summarization for longer documents, both behind VPC endpoints
D) Use Amazon Bedrock Guardrails to mask all PHI before sending documents to any model, then use Claude 3.5 Sonnet for summarization regardless of document length

---

**Question 3** [Domain 1]

A multinational e-commerce company wants to deploy a product description generator that serves customers in 14 languages. The system must produce culturally appropriate content, not just direct translations. Initial testing shows that the Cohere Command R+ model on Amazon Bedrock handles most languages well but produces suboptimal content for Thai, Vietnamese, and Arabic. The team has collected 5,000 high-quality product descriptions in each of these three languages from local marketing teams.

What is the MOST cost-effective approach to improve quality across all languages?

A) Fine-tune three separate Cohere Command R+ models on Amazon Bedrock, one for each underperforming language, and route requests by detected language
B) Use Amazon Bedrock prompt management to create language-specific prompt templates with few-shot examples for Thai, Vietnamese, and Arabic, while keeping the base model for other languages
C) Deploy separate SageMaker endpoints with language-specific fine-tuned open-source multilingual models for the three underperforming languages
D) Use Amazon Translate to convert all inputs to English, generate descriptions with the base model, then translate outputs back to the target language

---

**Question 4** [Domain 1]

A legal-tech startup is building a contract analysis system that must extract structured data (parties, obligations, penalties, dates) from legal documents AND generate natural language risk assessments. The system processes approximately 200 contracts per day, each averaging 15,000 tokens. The team wants to minimize costs while maintaining high accuracy for the extraction task. Testing shows that Claude 3 Haiku achieves 94% accuracy on structured extraction but only 78% quality on risk assessments, while Claude 3 Sonnet achieves 96% accuracy on extraction and 93% quality on risk assessments.

What architecture MINIMIZES cost while maintaining acceptable quality for BOTH tasks?

A) Use Claude 3 Sonnet for all tasks via a single API call that handles both extraction and assessment
B) Use Claude 3 Haiku for structured extraction, then pass the extracted data to Claude 3 Sonnet only for the risk assessment generation
C) Use Claude 3 Haiku for both tasks but implement a confidence-scoring mechanism that escalates low-confidence risk assessments to Claude 3 Sonnet
D) Fine-tune Claude 3 Haiku on the risk assessment task using Amazon Bedrock custom model training to improve its quality score

---

**Question 5** [Domain 1]

A media company is building an automated video content tagging system. For each video, the system receives a transcript, scene descriptions, and thumbnail images. The system must generate multi-label tags across 500+ categories with contextual understanding of how visual and textual elements relate. The team has 100,000 manually tagged videos as training data. They require the model to return structured JSON with confidence scores per tag.

Which approach provides the BEST accuracy for this multi-modal classification task?

A) Use Amazon Bedrock with Anthropic Claude 3.5 Sonnet, passing transcript text and thumbnail images together in a single multi-modal prompt with structured output instructions
B) Fine-tune a SageMaker-hosted multi-modal model on the labeled dataset, with a custom inference pipeline that processes text and images jointly and outputs structured JSON
C) Use Amazon Bedrock Titan Multimodal Embeddings to create combined text-image embeddings, then train a SageMaker classification head on the 100K labeled examples
D) Use Amazon Rekognition for visual tagging and Amazon Comprehend for text classification separately, then merge results with a Lambda function using weighted scoring

---

**Question 6** [Domain 1]

An autonomous vehicle company needs to evaluate three candidate foundation models for generating natural language incident reports from sensor data logs. Each model will be tested against 2,000 manually written gold-standard reports. The evaluation must measure factual accuracy, completeness of safety-critical details, readability, and adherence to regulatory formatting requirements. The team needs a systematic, reproducible evaluation framework.

Which evaluation approach provides the MOST comprehensive and reliable assessment?

A) Use Amazon Bedrock model evaluation with a human evaluation workflow, defining custom metrics for each criterion, and have domain experts rate outputs on a 5-point scale
B) Use automated metrics (ROUGE, BLEU, BERTScore) computed in a SageMaker Processing job, supplemented by a separate LLM-as-judge evaluation using Claude 3.5 Sonnet with a detailed rubric
C) Deploy all three models on SageMaker endpoints, run the 2,000 test cases through each, and use Amazon Bedrock model evaluation with both automatic metrics and human evaluation jobs for the four criteria
D) Create an A/B testing framework using SageMaker inference components, route live traffic to all three models, and collect user feedback through a rating widget

---

**Question 7** [Domain 1]

A research organization uses Amazon Bedrock to power a scientific literature assistant. They notice that when users ask about recent papers (published in the last 6 months), the model frequently generates plausible-sounding but incorrect citations — complete with fabricated DOIs, authors, and publication dates. The model's responses on well-established topics are accurate. The organization wants to eliminate hallucinated citations while maintaining the conversational experience.

What is the MOST effective solution?

A) Implement Retrieval-Augmented Generation using Amazon Bedrock Knowledge Bases connected to an OpenSearch Serverless collection containing indexed recent papers, with citation grounding validation
B) Fine-tune the model on recent papers using Amazon Bedrock custom model training to update its knowledge of recent publications
C) Add a system prompt instructing the model to only cite papers it is confident about and to state "I don't have information about recent papers" when uncertain
D) Implement Amazon Bedrock Guardrails with a word filter policy that blocks responses containing DOI patterns that aren't verified against a reference database

---

**Question 8** [Domain 1]

A SaaS company offers a multi-tenant AI writing assistant. Each tenant has different content policies, tone requirements, and domain vocabulary. Currently, they use a single Claude 3 Sonnet model with tenant-specific system prompts stored in DynamoDB. As tenant count grows to 500+, they find that system prompts are becoming extremely long (8,000+ tokens) to capture all tenant-specific requirements, consuming a significant portion of the context window and increasing costs.

What architecture BEST addresses the scaling challenge while maintaining tenant customization?

A) Fine-tune separate models for each tenant category (e.g., legal, healthcare, marketing) using Amazon Bedrock, and route requests to the appropriate fine-tuned model based on tenant industry
B) Use Amazon Bedrock Prompt Management with prompt variants to maintain tenant-specific templates, and use Amazon Bedrock Agents to dynamically select the appropriate variant
C) Implement a tiered prompt architecture: use a short core system prompt with tenant-specific few-shot examples stored in a per-tenant Knowledge Base, injecting only relevant examples via RAG at query time
D) Migrate to SageMaker with LoRA adapters — train a lightweight adapter per tenant and swap adapters at inference time using multi-model endpoints

---

**Question 9** [Domain 1]

A logistics company is evaluating whether to fine-tune a foundation model or implement RAG for their freight routing optimization assistant. The assistant must reason about route constraints, fuel costs, regulatory limits, and weather impacts. Route constraint rules change weekly, fuel costs update hourly, regulations update quarterly, and weather data is real-time. The company has 50,000 historical routing decisions with expert annotations.

What approach BEST balances accuracy, freshness, and cost?

A) Fine-tune a model on the 50,000 historical decisions to learn routing reasoning patterns, and implement RAG for all four dynamic data sources
B) Implement RAG only — index all routing rules, fuel costs, regulations, and weather data in a Knowledge Base, using the base model's reasoning capabilities
C) Fine-tune a model on historical decisions and regulation documents for deep domain reasoning, use RAG for fuel costs and weather data, and implement a scheduled re-indexing job for regulation updates
D) Use a base model with an Amazon Bedrock Agent that has action groups calling real-time APIs for fuel costs and weather, with routing rules and regulations stored in the agent's Knowledge Base

---

**Question 10** [Domain 1]

A company has deployed a customer support chatbot using Amazon Bedrock that handles 10,000 conversations per day. They want to implement an intelligent model routing strategy: simple FAQ-type questions should use a cheaper model, complex troubleshooting should use a more capable model, and sensitive topics (billing disputes, account cancellations) should use the most capable model with specific guardrails. The routing decision must add less than 50 ms of latency.

Which architecture achieves this multi-tier routing with minimal latency overhead?

A) Use a lightweight classifier model deployed on SageMaker Serverless inference to categorize each incoming message, then route to the appropriate Bedrock model based on the classification
B) Use Amazon Bedrock Prompt Router to automatically route between a smaller and larger model based on the prompt characteristics
C) Implement keyword-based routing rules in a Lambda function that checks for billing/account terms and question complexity heuristics, routing to three different Bedrock models
D) Use Amazon Comprehend real-time endpoint for intent classification and sentiment analysis, then route based on the combined output to the appropriate Bedrock model

---

**Question 11** [Domain 1]

A pharmaceutical company is building a drug interaction checker powered by a foundation model. The system must be deterministic — given the same drug combination input, it must ALWAYS return the same interaction warnings. The model must reference only the FDA's approved drug interaction database, never its parametric knowledge. Incorrect or hallucinated interactions could have life-threatening consequences.

Which architecture provides the HIGHEST level of determinism and safety?

A) Use Amazon Bedrock with temperature set to 0, a system prompt restricting responses to the FDA database, and Guardrails to filter any response not grounded in the provided context
B) Implement a RAG pipeline with the FDA database in a Knowledge Base, set temperature to 0 and top_p to 1, and add a post-processing validation step that cross-references every mentioned interaction against the database
C) Fine-tune a model exclusively on the FDA drug interaction database, set temperature to 0, and deploy with Guardrails that block any response mentioning drugs not in the database
D) Use an Amazon Bedrock Agent with an action group that directly queries a structured FDA database API, formats the results deterministically, and returns only the API response without additional model generation

---

**Question 12** [Domain 1]

A retail company wants to build a visual product search system where customers upload a photo and receive similar products from their 2-million-item catalog. The system must return results within 500 ms, handle 1,000 concurrent searches, and rank results by visual similarity AND price relevance. Product images and metadata are stored in Amazon S3.

Which architecture delivers the BEST performance at scale?

A) Use Amazon Bedrock Titan Multimodal Embeddings to pre-compute embeddings for all catalog items, store them in Amazon OpenSearch Serverless with vector search, and at query time embed the uploaded image and perform a k-NN search with a price-boosting scoring function
B) Use Amazon Rekognition Custom Labels to identify product attributes from uploaded images, then query a DynamoDB table by attributes with price-based sort keys
C) Deploy a CLIP model on SageMaker real-time endpoints with auto-scaling, pre-compute catalog embeddings stored in a Pinecone index, and perform similarity search with metadata filtering
D) Use Amazon Bedrock with Claude 3.5 Sonnet's multi-modal capability to analyze the uploaded image, generate a text description, then search an OpenSearch text index of product descriptions

---

**Question 13** [Domain 1]

A government agency needs to process Freedom of Information Act (FOIA) requests. Each request requires redacting sensitive information from thousands of pages of documents before release. The system must identify and redact 15 categories of sensitive information (SSNs, case numbers, agent names, intelligence sources, etc.) with 99.9% recall — missing even one instance is unacceptable. The agency currently has a manual process that takes 40 analyst-hours per request.

What approach achieves the required recall rate?

A) Use Amazon Bedrock with Claude 3.5 Sonnet to process each page, instructing it to identify and redact all 15 categories, with Amazon Textract for OCR of scanned documents
B) Build a multi-stage pipeline: Amazon Textract for OCR, Amazon Comprehend PII detection for standard PII categories, a fine-tuned NER model on SageMaker for custom categories, and a final Claude 3.5 Sonnet review pass, with mandatory human review of flagged pages
C) Use Amazon Macie for automated sensitive data discovery across the document corpus, supplemented by regex patterns for custom categories
D) Deploy a fine-tuned Llama 3 model on SageMaker specifically trained on redaction examples from the agency, with post-processing regex validation for structured patterns like SSNs

---

**Question 14** [Domain 1]

A customer is building a code generation platform that supports 12 programming languages. They need the model to generate syntactically correct, secure code that follows each language's idiomatic patterns. Testing reveals that while the base model performs well for Python and JavaScript, it produces non-idiomatic code for Rust, Haskell, and Kotlin. The team has 10,000 high-quality code examples per language from their senior engineers.

What strategy produces the BEST code quality across all languages with the LEAST operational overhead?

A) Use Amazon Bedrock with Claude 3.5 Sonnet and language-specific system prompts containing style guides and idiom examples, using prompt caching for the static system prompt portions
B) Fine-tune a single model on Amazon Bedrock using a combined dataset of all 12 languages with language-identification tokens, creating one customized model
C) Fine-tune separate models for Rust, Haskell, and Kotlin on SageMaker using the curated examples, and use the base Bedrock model for well-performing languages, with a router Lambda
D) Use Amazon CodeWhisperer for code generation across all languages, supplemented by a Bedrock-powered code review step that checks for idiomatic patterns

---

**Question 15** [Domain 1]

A streaming music service wants to generate personalized playlist descriptions and mood narratives. The system must process the user's listening history (last 200 songs with metadata), current time of day, and weather at the user's location to generate a 2-3 sentence poetic description. The service has 50 million active users and needs to generate descriptions within 2 seconds. Daily request volume is approximately 10 million descriptions.

What is the MOST cost-efficient architecture that meets the latency requirement?

A) Use Amazon Bedrock with Claude 3 Haiku, batching user context into concise prompts with only the 20 most relevant songs, and implement a CDN-backed cache for similar user-context combinations
B) Fine-tune Amazon Titan Text Express on 100,000 example descriptions, deploy with Provisioned Throughput, and pre-generate descriptions during off-peak hours for predictable listening patterns
C) Use Amazon Bedrock with Claude 3.5 Sonnet and prompt caching enabled, passing the full 200-song history for maximum context
D) Deploy a fine-tuned GPT-2 model on SageMaker Serverless endpoints for maximum cost efficiency at the quality level needed for short creative text

---

**Question 16** [Domain 1]

A robotics company is building a natural language command interface for warehouse robots. Operators issue commands like "Move the blue pallet from zone B3 to loading dock 7, avoid the maintenance area near C2." The system must parse these into structured motion plans with coordinates, obstacle avoidance waypoints, and timing constraints. Commands must be parsed in under 100 ms for safety reasons. The warehouse layout changes weekly.

What architecture meets the latency and accuracy requirements?

A) Use Amazon Bedrock with Claude 3 Haiku with structured output parsing, pre-loading the current warehouse layout as a system prompt, with prompt caching enabled
B) Deploy a fine-tuned smaller model on a SageMaker real-time endpoint with GPU instances for minimal inference latency, with the warehouse layout injected as context
C) Use Amazon Bedrock with an Agent that has an action group calling a warehouse management API to resolve locations, then formats the motion plan
D) Train a custom seq2seq model specifically for command-to-plan translation on SageMaker, retrained weekly when layouts change

---

**Question 17** [Domain 1]

A financial analytics firm is comparing the cost and performance of Amazon Bedrock versus SageMaker for their quarterly earnings call summarization pipeline. They process 3,000 earnings call transcripts per quarter (each ~30,000 tokens), generating 2,000-token summaries. Processing happens in a 2-week burst after earnings season. They need to evaluate total cost of ownership including infrastructure, development time, and operational overhead.

Given the bursty workload pattern, which deployment provides the LOWEST total cost?

A) Amazon Bedrock On-Demand pricing with batch inference API for non-time-sensitive processing
B) SageMaker real-time endpoints with managed auto-scaling, scaling to zero during off-season
C) Amazon Bedrock with Provisioned Throughput committed for the 2-week processing window, released afterward
D) SageMaker asynchronous inference endpoints with auto-scaling, processing transcripts in a queue

---

**Question 18** [Domain 1]

A social media company needs to implement content moderation at scale — 500,000 posts per hour, each containing text and potentially images. The system must classify content into 8 risk categories with different SLAs: hate speech and CSAM require < 1 second classification, while spam and misinformation can tolerate up to 30 seconds. False negative rate for hate speech must be below 0.1%.

What architecture BEST meets the tiered SLA requirements?

A) Use Amazon Rekognition Content Moderation for images and Amazon Comprehend for text toxicity in parallel for all posts, with a Bedrock-powered secondary review for borderline cases
B) Implement a two-tier system: a fast, fine-tuned lightweight classifier on SageMaker real-time endpoints for immediate risk scoring of all posts, escalating high-risk posts to Claude 3 Sonnet on Bedrock for detailed multi-category classification
C) Use Amazon Bedrock Guardrails content filters applied to all posts simultaneously, with custom deny-topic policies for each risk category
D) Process all posts through Claude 3 Haiku on Amazon Bedrock with Provisioned Throughput for consistent latency, using a single prompt that classifies across all 8 categories

---

**Question 19** [Domain 1]

A company wants to implement semantic search across their 50-million-document corpus. Documents are updated at a rate of 100,000 per day. They need sub-second query latency, support for hybrid search (combining semantic and keyword matching), and the ability to filter results by 20+ metadata fields. The current keyword search system uses Amazon OpenSearch Service.

What is the MOST operationally efficient architecture?

A) Use Amazon Bedrock Titan Text Embeddings V2 to generate embeddings, store them in Amazon OpenSearch Serverless with vector search, and use OpenSearch's hybrid query combining k-NN and BM25 scoring
B) Use Amazon Bedrock Knowledge Bases with an OpenSearch Serverless vector store, relying on the managed sync to handle document updates automatically
C) Deploy a sentence-transformer model on SageMaker for embeddings, store vectors in Amazon Aurora PostgreSQL with pgvector, and implement application-level hybrid scoring
D) Use Amazon Kendra Enterprise Edition which natively supports semantic search, keyword search, and metadata filtering with automatic document sync from S3

---

**Question 20** [Domain 1]

An insurance company uses foundation models to generate policy recommendation letters. A compliance audit reveals that 12% of generated letters contain subtle factual errors — correct policy names but wrong coverage amounts, or accurate deductibles paired with incorrect policy tiers. Simple hallucination detection (checking if entities exist) passes, but relational accuracy (correct associations between entities) fails. The company needs to reduce relational hallucination to below 1%.

What approach MOST effectively addresses relational hallucination specifically?

A) Implement a structured RAG pipeline that retrieves complete policy records as structured data (JSON), includes the full record in context, and instructs the model to ONLY use values from the provided structured data
B) Fine-tune the model on 50,000 correctly generated policy letters with verified relational accuracy
C) Add a post-generation validation step using a second LLM call that receives the generated letter and the source policy data, specifically checking entity-relationship accuracy
D) Implement Amazon Bedrock Guardrails with contextual grounding checks to verify that all generated content is grounded in the retrieved documents

---

**Question 21** [Domain 2]

A legal firm is building a contract review system using Amazon Bedrock Agents. The agent must: (1) retrieve relevant contract clauses from a Knowledge Base, (2) compare clauses against a regulatory compliance database via API, (3) generate a risk assessment, and (4) create a formatted report. The process for complex contracts involves 8-12 tool calls and the agent occasionally enters loops where it repeatedly calls the same API with identical parameters.

What is the MOST effective way to prevent action loops while maintaining agent autonomy?

A) Set a maximum number of iterations in the agent configuration and implement idempotency detection in the action group Lambda functions that returns a cached response for duplicate calls
B) Use Amazon Bedrock Prompt Flows instead of Agents to create a deterministic DAG of the four steps, eliminating the possibility of loops
C) Implement an orchestration Lambda that tracks the agent's tool call history and injects a summary of previous calls into the agent's context at each step
D) Reduce the agent's temperature to 0 and add explicit instructions in the agent prompt that list the exact sequence of tool calls for each contract type

---

**Question 22** [Domain 2]

A customer service platform uses an Amazon Bedrock Agent with three Knowledge Bases: product documentation, troubleshooting guides, and customer account data. Users report that the agent frequently retrieves information from the wrong Knowledge Base — pulling product specs when users ask troubleshooting questions, or accessing troubleshooting guides when users ask about their account details. The retrieval scores are high, but relevance is low.

How should the team improve Knowledge Base selection accuracy?

A) Consolidate all three sources into a single Knowledge Base with metadata tags indicating the source type, and use metadata filtering in the retrieval configuration based on intent classification
B) Implement a pre-processing step using a separate Bedrock model call to classify the user's intent, then configure the agent to query only the classified Knowledge Base
C) Write detailed Knowledge Base descriptions in the agent's instruction prompt that clearly define when each Knowledge Base should be queried, including example query patterns for each
D) Increase the number of retrieved chunks from each Knowledge Base and implement a reranking step using Cohere Rerank to select the most relevant chunks across all sources

---

**Question 23** [Domain 2]

A company is implementing a multi-agent architecture using Strands Agents SDK for a financial advisory platform. The system has: a Portfolio Analyzer agent, a Market Research agent, a Compliance Checker agent, and an Orchestrator agent. The Orchestrator must coordinate the other three agents, handle partial failures gracefully (e.g., if Market Research times out, still provide portfolio analysis with a caveat), and ensure the Compliance Checker ALWAYS runs before any recommendation is delivered to the user.

How should the multi-agent coordination be implemented?

A) Use Amazon Bedrock Prompt Flows with parallel nodes for Portfolio and Market Research, a conditional node for timeout handling, and a sequential Compliance node before the output
B) Implement the Orchestrator as a Strands Agent with tools that invoke the other three agents, using try-catch patterns in the tool implementations and a mandatory compliance-check tool call instruction in the orchestrator's system prompt
C) Use AWS Step Functions to orchestrate the agents with parallel states, catch blocks for timeouts, and a required compliance step before the final response state
D) Deploy all four agents as Amazon Bedrock Agents with the Orchestrator using agent-to-agent collaboration, configured with required action groups for compliance checking

---

**Question 24** [Domain 2]

A developer is building an advanced RAG pipeline for a technical support system. The pipeline uses Amazon Bedrock Knowledge Bases with OpenSearch Serverless. Users frequently ask complex questions that require synthesizing information from multiple documents (e.g., "What are all the compatibility requirements between Product X v3.2 and Product Y v4.1?"). The current single-query retrieval often misses relevant chunks because the information is spread across different document sections with different terminology.

What retrieval enhancement strategy MOST improves multi-document synthesis quality?

A) Implement query decomposition — use a Bedrock model to break the complex question into sub-queries, retrieve chunks for each sub-query independently, deduplicate results, then synthesize across all retrieved chunks
B) Increase the chunk size to 1,500 tokens with 300-token overlap to capture more context per chunk, and increase the number of retrieved chunks to 20
C) Implement hierarchical indexing — create document-level summaries in addition to chunk-level indexes, retrieve at the summary level first to identify relevant documents, then retrieve specific chunks from those documents
D) Switch to Amazon Kendra with FAQ-style indexed question-answer pairs extracted from the documentation

---

**Question 25** [Domain 2]

A developer is configuring an Amazon Bedrock Knowledge Base for a legal document search system. The documents contain dense legal language with many domain-specific terms. Initial testing shows poor retrieval relevance — the embedding model struggles to differentiate between similar legal concepts like "indemnification," "hold harmless," and "limitation of liability." The team is using Titan Text Embeddings V2 with default chunking.

Which combination of techniques will MOST improve retrieval relevance? (Select TWO)

A) Switch to Cohere Embed on Amazon Bedrock, which supports configurable input_type parameter for separating document vs. query embeddings
B) Implement custom chunking with a semantic chunking strategy that respects legal document structure (sections, clauses, sub-clauses)
C) Add a metadata extraction step that tags each chunk with legal concept categories, and use metadata filtering at query time
D) Reduce the embedding dimensions from 1024 to 256 to improve similarity computation speed
E) Implement a hybrid search strategy combining vector similarity with BM25 keyword matching in OpenSearch Serverless

---

**Question 26** [Domain 2]

A company building a customer-facing chatbot with Amazon Bedrock needs to maintain conversation context across multiple turns. The chatbot handles product inquiries that often span 15-20 turns as customers narrow down their requirements. By turn 15, the full conversation history exceeds the model's optimal performance window, and the team notices degraded response quality and increased latency. Conversation history is stored in DynamoDB.

What context management strategy BEST maintains conversation quality while controlling costs?

A) Implement a sliding window that keeps only the last 10 turns of raw conversation, discarding earlier turns
B) Use a summarization approach — after every 5 turns, use a cheaper model to summarize the conversation so far, then include only the summary plus the last 3 raw turns in the prompt
C) Increase the context window by switching to a model with a larger context window (200K tokens) so all turns fit without truncation
D) Store all conversation turns in a per-session Knowledge Base and use RAG to retrieve only the most relevant previous turns for each new query

---

**Question 27** [Domain 2]

A developer is building an Amazon Bedrock Agent that needs to interact with external services via MCP (Model Context Protocol) servers. The agent must connect to three MCP servers: a database query server (latency-sensitive, called frequently), a document processing server (CPU-intensive, called occasionally), and a notification server (called rarely but requires persistent connections to SMTP). The team needs to choose the right deployment pattern for each MCP server.

What deployment architecture is MOST appropriate?

A) Deploy all three MCP servers as Lambda functions behind the Bedrock Agent's action groups for serverless simplicity
B) Deploy the database query server on Lambda for auto-scaling, the document processing server on ECS Fargate with higher CPU allocation, and the notification server on ECS with persistent container tasks
C) Deploy all three MCP servers on a single ECS service with different container definitions sharing a task definition
D) Deploy all three MCP servers as separate SageMaker endpoints for managed scaling and monitoring

---

**Question 28** [Domain 2]

A retail company is building a product recommendation chatbot. When a user asks "I need a laptop for video editing under $1,500," the system must search the product catalog, filter by price, rank by suitability, and present recommendations with explanations. The catalog has 50,000 products in an Amazon Aurora PostgreSQL database. The team is deciding between using an Amazon Bedrock Agent with action groups versus Amazon Bedrock Prompt Flows.

Given the requirement for dynamic user interaction with follow-up questions, which approach is BEST and why?

A) Amazon Bedrock Agent with action groups — because the agent can dynamically decide when to query the catalog, ask clarifying questions, and adapt its behavior based on user responses within a conversation
B) Amazon Bedrock Prompt Flows — because the deterministic DAG ensures the catalog search always executes in the correct order and the price filter is always applied
C) Amazon Bedrock Agent with an attached Knowledge Base containing the product catalog exported as documents, avoiding the need for direct database queries
D) Amazon Bedrock Prompt Flows with a conditional branch — one path for when the user's requirements are complete, another that loops back to ask clarifying questions

---

**Question 29** [Domain 2]

A developer is implementing a document processing pipeline using Amazon Bedrock. The pipeline must extract key information from uploaded PDFs (which may contain tables, charts, and handwritten annotations), enrich the extracted data with information from external APIs, and store the results in a structured format. The pipeline processes 10,000 documents daily in batches.

What is the MOST robust document processing architecture?

A) Use Amazon Textract for document parsing (including tables and forms), pass extracted text to Bedrock for information extraction and enrichment via agent action groups, and store results in DynamoDB
B) Convert PDFs to images and pass directly to Claude 3.5 Sonnet's multi-modal capability for end-to-end extraction, with a Lambda function for API enrichment
C) Use Amazon Textract for OCR, Amazon Comprehend for entity extraction, and Bedrock only for the enrichment step that requires reasoning about the extracted entities
D) Use a SageMaker Processing job with a custom document parsing library, then batch-process extracted text through Bedrock's batch inference API

---

**Question 30** [Domain 2]

A healthcare company is building a symptom checker chatbot using Amazon Bedrock. The system must NEVER provide a definitive diagnosis, always recommend consulting a healthcare professional, and escalate to a human agent when it detects symptoms of a medical emergency. The company needs to ensure these safety behaviors cannot be overridden through prompt injection attacks where users try to trick the bot into providing diagnoses.

What combination of safeguards provides the MOST robust protection?

A) System prompt instructions prohibiting diagnoses, Amazon Bedrock Guardrails with denied topics for diagnostic statements, and a separate classification model that monitors outputs for diagnostic language before delivery to users
B) Fine-tune the model on conversations where it always deflects diagnostic questions, and add Guardrails with content filters
C) Implement Bedrock Guardrails with prompt attack filters enabled, denied topics for medical diagnosis, and a custom word policy blocking diagnostic terminology — combined with input validation that strips common prompt injection patterns
D) Use a deterministic rule-based system for emergency symptom detection in a pre-processing Lambda, with Bedrock handling only safe conversational responses, and Guardrails for additional output filtering

---

**Question 31** [Domain 2]

A company uses AWS AppConfig to manage feature flags for their GenAI application. They want to implement dynamic model selection — switching between Claude 3 Haiku, Claude 3 Sonnet, and Claude 3.5 Sonnet based on current traffic load, error rates, and cost budget. The configuration should update in real-time without redeploying the application, and invalid configurations (e.g., selecting a non-existent model ID) should be rejected.

How should this dynamic model selection be implemented?

A) Store model configurations in a DynamoDB table with a Lambda function that polls for changes every 5 minutes
B) Use AWS AppConfig with a freeform configuration profile containing model IDs, deployment strategies with bake time, and a Lambda validator that checks model ID validity before deployment
C) Implement a CloudWatch alarm-based system that triggers Lambda functions to update environment variables in the application's ECS task definition
D) Use AWS Systems Manager Parameter Store with a change notification via EventBridge to trigger application reloads

---

**Question 32** [Domain 2]

A developer is building an Amazon Bedrock Agent that helps data analysts write and execute SQL queries. The agent must: understand natural language questions, generate SQL, validate the SQL for safety (no DROP/DELETE/TRUNCATE), execute it against an Amazon Redshift cluster, and present results in natural language. The agent should also learn from corrections — when an analyst says "that's not what I meant," it should refine the query.

What architecture BEST supports iterative query refinement with safety guardrails?

A) Use an Amazon Bedrock Agent with two action groups: one for SQL generation and validation (Lambda that parses the SQL AST to block dangerous operations), and one for query execution (Lambda with read-only Redshift credentials) — with conversation memory enabled for iterative refinement
B) Use Amazon Bedrock Prompt Flows with a loop node that generates SQL, validates it, and returns to generation if validation fails, with a separate execution node
C) Use Amazon Q in Amazon Redshift for natural language to SQL conversion, which has built-in query safety mechanisms
D) Deploy a text-to-SQL fine-tuned model on SageMaker with a Guardrails layer that regex-filters dangerous SQL keywords before execution

---

**Question 33** [Domain 2]

A developer needs to implement a human-in-the-loop review system for an AI-generated content pipeline. The pipeline generates marketing emails using Amazon Bedrock. Emails targeting high-value customers (>$10K annual spend) must be reviewed and approved by a marketing manager before sending. The review must support approve, reject, or edit-and-approve workflows with an SLA of 4 hours.

What AWS service combination provides the MOST streamlined human review workflow?

A) Amazon A2I (Augmented AI) with a custom task template for email review, integrated with the Bedrock pipeline via a Lambda function that routes high-value emails to the human review workflow
B) Amazon SES with a draft/review state, where high-value emails are held in a DynamoDB queue and a custom React UI allows managers to review and approve
C) AWS Step Functions with a human approval step using a callback pattern, where the task token is sent to the manager via SNS, and approval triggers continuation
D) Amazon A2I with a private workforce of marketing managers, a custom worker task template showing the generated email alongside customer context, and automatic approval after 4 hours if not reviewed

---

**Question 34** [Domain 2]

A developer is building a conversational AI system that must maintain context across channels — a user starts a conversation on web chat, continues via mobile app, and may follow up via email. The system must seamlessly continue the conversation regardless of channel, maintaining full context of previous interactions. The company processes 100,000 conversations per day.

What architecture provides seamless cross-channel conversation continuity?

A) Store conversation history in DynamoDB with the user ID as the partition key and timestamp as the sort key, load the full history when a user connects from any channel, and pass it as context to the Bedrock model
B) Use Amazon Bedrock's session management with a custom session store in ElastiCache that maps user IDs to session IDs, allowing any channel to resume the same Bedrock session
C) Store conversation history in DynamoDB, use a summarization step to maintain a rolling conversation summary, and implement a channel-agnostic API layer that reconstructs context from the summary plus recent turns
D) Use Amazon Lex for multi-channel support with built-in conversation management, powered by Bedrock for response generation

---

**Question 35** [Domain 2]

A developer is implementing a complex document QA system where answers often require reasoning across multiple sections of long documents (100+ pages). The current RAG implementation retrieves the top 5 chunks but frequently misses critical context that is in a different section of the same document. For example, a financial report's risk section may reference specific figures from the financial statements section 50 pages earlier.

What retrieval strategy BEST handles cross-section dependencies within documents?

A) Implement parent-child chunk indexing — index smaller chunks for precise retrieval but retrieve the parent (larger) chunk for context, and include adjacent sibling chunks when the confidence score indicates cross-reference likelihood
B) Increase chunk overlap to 50% so that cross-section references are captured in overlapping regions
C) Implement a two-pass retrieval: first retrieve relevant chunks, then use the model to identify referenced sections (e.g., "See Table 3.2"), perform a second targeted retrieval for those references, and combine all chunks for the final answer
D) Convert each document into a knowledge graph with entity relationships, then traverse the graph to find all related entities when answering a question

---

**Question 36** [Domain 2]

A startup is building an AI coding assistant using Amazon Bedrock that must provide repository-aware code suggestions. The assistant must understand the project's architecture, coding conventions, existing utility functions, and dependency versions. The repository has 500,000 lines of code across 3,000 files. Simply stuffing code into the context window is infeasible.

What architecture MOST effectively provides repository-aware code generation?

A) Index the entire codebase in an Amazon Bedrock Knowledge Base using code-aware chunking (function/class level), and retrieve relevant code files/functions based on the developer's current file and query context
B) Fine-tune a code model on the company's codebase using SageMaker to learn the patterns and conventions
C) Use Amazon CodeWhisperer customization with the repository connected as a reference source
D) Implement a multi-level retrieval system: (1) embed file-level summaries for architecture understanding, (2) embed function/class-level chunks for code retrieval, (3) embed dependency manifests for version awareness — query all three levels and combine results in the prompt

---

**Question 37** [Domain 2]

A company is building a Bedrock Agent that helps employees search across internal wikis, Jira tickets, Confluence pages, and Slack messages. The agent has four Knowledge Bases, one per data source. Employees complain that the agent is slow — each query takes 8-12 seconds because the agent sequentially queries all four Knowledge Bases before responding, even when the answer is clearly in only one source.

How can the team MOST effectively reduce response latency?

A) Consolidate all four data sources into a single Knowledge Base with source-type metadata, query once, and filter/boost by source type as needed
B) Implement a lightweight intent classifier (using a fast Bedrock model call) that determines which 1-2 Knowledge Bases to query based on the question, then query only those
C) Switch from sequential to parallel Knowledge Base queries using an agent orchestration Lambda, and return results from the first Knowledge Base that produces above-threshold results
D) Use Amazon Kendra as a unified index across all four data sources, replacing the four separate Knowledge Bases

---

**Question 38** [Domain 3]

A company deployed a GenAI application using Amazon Bedrock two months ago. Usage analysis shows that 40% of requests are near-identical queries (same intent, slightly different phrasing) from different users. The monthly Bedrock invoice has grown to $85,000. The team needs to reduce costs by at least 50% without degrading the user experience. The application uses Claude 3 Sonnet for all requests.

What combination of strategies achieves the 50% cost reduction target? (Select TWO)

A) Implement semantic caching — use embeddings to identify semantically similar queries and serve cached responses for queries above a similarity threshold
B) Switch ALL traffic to Claude 3 Haiku, which is ~12x cheaper per token
C) Implement a tiered model strategy — route simple/FAQ-like queries to Claude 3 Haiku and complex queries requiring deep reasoning to Claude 3 Sonnet
D) Enable Amazon Bedrock prompt caching for system prompts and frequently used context
E) Reduce the maximum output token limit from 4,096 to 500 tokens for all responses

---

**Question 39** [Domain 3]

A financial services company has deployed an Amazon Bedrock-powered advisory chatbot. A security researcher discovers that by carefully crafting prompts, they can extract the system prompt content, which contains proprietary trading strategy logic and client segmentation rules. The system prompt is currently 3,000 tokens and contains both behavioral instructions and sensitive business logic.

What is the MOST secure mitigation approach?

A) Split the system prompt — keep behavioral instructions in the system prompt and move sensitive business logic to a backend service that the agent queries via action groups, never exposing it in the prompt context
B) Add instructions to the system prompt telling the model to never reveal the system prompt content
C) Use Amazon Bedrock Guardrails with a custom word policy that blocks responses containing key terms from the system prompt
D) Encrypt the system prompt content using a custom encoding before including it in the prompt

---

**Question 40** [Domain 3]

A company running a GenAI application on Amazon Bedrock notices intermittent ThrottlingException errors during business hours (9 AM - 5 PM). The errors affect approximately 5% of requests. The application currently makes synchronous Bedrock API calls from a Lambda function triggered by API Gateway. The team needs to handle throttling gracefully without purchasing Provisioned Throughput.

What is the MOST resilient architecture for handling throttling?

A) Implement exponential backoff with jitter in the Lambda function, with a maximum of 5 retries and a circuit breaker that returns a graceful degradation response after exhausting retries
B) Add an Amazon SQS queue between API Gateway and the Lambda function to buffer requests and process them at a controlled rate
C) Implement a client-side request queue with rate limiting that ensures the application never exceeds the Bedrock service quota
D) Use multiple AWS regions for Bedrock API calls with a round-robin routing strategy via Route 53

---

**Question 41** [Domain 3]

A company is building a multi-tenant GenAI platform where different customers pay for different service tiers. The Gold tier gets access to Claude 3.5 Sonnet with Provisioned Throughput, the Silver tier gets Claude 3 Sonnet with on-demand, and the Bronze tier gets Claude 3 Haiku with strict rate limits. Each tenant's data must be completely isolated — a tenant's queries and responses must never be accessible to other tenants. All API calls must be auditable per tenant.

What architecture ensures proper tenant isolation and tiered access?

A) Use separate AWS accounts per tenant with AWS Organizations, each account having its own Bedrock configuration and CloudTrail logging
B) Implement tenant-scoped IAM roles with resource tags, use a shared Bedrock endpoint with a middleware Lambda that enforces model access by tenant tier, logs all requests to a per-tenant CloudWatch log group, and stores conversation data in a DynamoDB table with tenant ID as the partition key
C) Deploy separate Amazon Bedrock model invocations per tenant with unique model access credentials, using AWS Secrets Manager for credential rotation
D) Use Amazon Cognito for tenant authentication with custom claims for tier, implement a tenant-routing API Gateway that directs to tenant-specific Lambda functions, each with its own Bedrock model access policy and isolated DynamoDB tables

---

**Question 42** [Domain 3]

A developer needs to implement Amazon Bedrock Guardrails for a customer-facing chatbot. The guardrails must: (1) block personally identifiable information in BOTH inputs and outputs, (2) prevent the model from discussing competitor products, (3) ensure responses are grounded in the retrieved context, and (4) filter sexually explicit content. The developer must configure these as granularly as possible.

In which order of priority should the guardrail policies be configured, and what is the correct configuration?

A) Content filters for explicit content → PII detection with BLOCK action on inputs AND outputs → Denied topics for competitor mentions → Contextual grounding checks with a 0.7 threshold
B) PII detection on inputs only → Content filters → Denied topics → Contextual grounding
C) Contextual grounding checks → Content filters → PII detection on outputs only → Denied topics
D) Denied topics for competitors → PII detection with ANONYMIZE action on inputs and BLOCK on outputs → Content filters for explicit content → Contextual grounding checks with a configurable threshold

---

**Question 43** [Domain 3]

A machine learning team deployed a RAG-based customer support system 3 months ago. They notice that answer quality has degraded significantly despite no changes to the model or retrieval pipeline. Investigation reveals that the Knowledge Base contains product documentation that was updated 6 weeks ago, but the embeddings index was not refreshed. Additionally, 30% of customer queries now reference a newly launched product line that has no documentation indexed.

What systematic approach prevents this quality degradation?

A) Implement automated Knowledge Base sync triggered by S3 event notifications when documentation is updated, add a monitoring dashboard that tracks index freshness and query-hit rates, and establish an alerting threshold for queries with low retrieval scores indicating missing content
B) Schedule a weekly re-indexing job using an EventBridge rule that triggers a Lambda function to sync the Knowledge Base
C) Implement a feedback loop where customers can rate responses, and trigger a manual Knowledge Base refresh when ratings drop below a threshold
D) Use Amazon Kendra instead, which automatically crawls and re-indexes connected data sources on a configurable schedule

---

**Question 44** [Domain 3]

A company is optimizing their Amazon Bedrock application's token usage. Analysis shows that the average request includes a 2,000-token system prompt, 1,500 tokens of retrieved context, a 200-token user query, and generates a 500-token response. The system prompt is identical across all requests. The retrieved context shares a 500-token preamble that explains the document format. The application handles 50,000 requests per day.

What token optimization strategy provides the GREATEST cost reduction?

A) Enable Amazon Bedrock prompt caching to cache the static 2,000-token system prompt and the 500-token context preamble across requests
B) Compress the system prompt using abbreviations and shorthand to reduce it from 2,000 to 800 tokens
C) Reduce the number of retrieved context chunks from 5 to 3, cutting context tokens from 1,500 to 900
D) Set the maximum output token parameter to 300 instead of 500 to reduce output token costs

---

**Question 45** [Domain 3]

A healthcare AI platform processes patient data through Amazon Bedrock. The platform must ensure that model inputs and outputs are never logged by the Bedrock service, patient data is encrypted with customer-managed KMS keys, and VPC traffic to Bedrock never traverses the public internet. The security team also requires a mechanism to prove to auditors that no patient data is stored by the Bedrock service.

What architecture satisfies ALL security requirements?

A) Enable Bedrock model invocation logging to S3 with SSE-KMS encryption, use VPC endpoints for Bedrock, and configure the model invocation to use customer-managed KMS keys
B) Disable Bedrock model invocation logging, configure a VPC endpoint for Bedrock with a VPC endpoint policy restricting access, use customer-managed KMS keys for any data at rest, and reference AWS's data privacy documentation showing Bedrock does not store customer inputs/outputs for model training
C) Deploy the model on SageMaker within a private VPC with no internet access, using customer-managed KMS keys, to have full control over data handling
D) Use Bedrock with AWS PrivateLink, enable CloudTrail logging for API calls only (not payloads), configure S3 server-side encryption for any stored data, and use customer-managed KMS keys

---

**Question 46** [Domain 3]

A developer is implementing a circuit breaker pattern for their GenAI application that calls Amazon Bedrock. The application experiences cascading failures when Bedrock returns errors — downstream services pile up requests, Lambda concurrency is exhausted, and the entire system becomes unresponsive. The team needs to implement graceful degradation.

What implementation provides the MOST robust circuit breaker behavior?

A) Implement a Step Functions state machine with retry and catch blocks, using a DynamoDB table to track error rates and a choice state that routes to a fallback response when the error rate exceeds the threshold
B) Implement the circuit breaker in the application code: track error rates in ElastiCache, open the circuit when errors exceed 50% in a 1-minute window, serve cached/fallback responses while the circuit is open, and half-open after 30 seconds to test recovery
C) Use API Gateway throttling to limit the rate of requests to the Bedrock-calling Lambda, preventing cascading failures
D) Configure Lambda reserved concurrency to cap the number of simultaneous Bedrock calls, with a dead letter queue for overflow requests

---

**Question 47** [Domain 3]

A company's GenAI application serves users in the US and EU. They need to ensure that EU user data is processed only in the eu-west-1 region, while US users can use us-east-1. If a region experiences an outage, the application should fail over to a secondary region within the SAME geographic boundary (EU to eu-central-1, US to us-west-2). The system must maintain conversation context during failover.

What architecture ensures compliance with data residency requirements while providing cross-region resilience?

A) Use Amazon Route 53 geolocation routing to direct users to the correct region, deploy the application stack in all four regions, store conversation context in DynamoDB Global Tables, and implement Route 53 health checks that fail over to the geo-appropriate secondary region
B) Deploy in us-east-1 and eu-west-1 only, with CloudFront geo-restriction to enforce data residency, and accept downtime if a primary region fails
C) Use a single global deployment in us-east-1 with AWS Transfer Family to encrypt EU data before processing, ensuring data protection regardless of region
D) Deploy in all four regions with Amazon Aurora Global Database for conversation context, and use Application Load Balancers with cross-region failover

---

**Question 48** [Domain 3]

A security team discovers that their Amazon Bedrock-powered internal tool has been subject to a prompt injection attack. An employee embedded instructions in a document that was indexed in the Knowledge Base, causing the agent to execute unauthorized API calls when other employees queried that document's content. The agent has action groups with write access to internal systems.

What is the MOST comprehensive remediation plan?

A) Remove the malicious document from the Knowledge Base, re-index, and add Bedrock Guardrails with prompt attack detection enabled for both user inputs and retrieved context
B) Remove the malicious document, re-index, enable Guardrails prompt attack detection, implement least-privilege access for action groups (read-only where possible), add a confirmation step for any write operations, and audit all agent actions in the last 30 days via CloudTrail
C) Remove the malicious document and implement document validation scanning before any content is added to the Knowledge Base
D) Disable the agent's write access to internal systems until a full security review is completed

---

**Question 49** [Domain 3]

A developer is configuring Provisioned Throughput for an Amazon Bedrock model. The application has a predictable weekday pattern: 100 requests/minute from 9 AM - 5 PM, 20 requests/minute from 5 PM - 9 AM, and 5 requests/minute on weekends. The team has a fixed monthly budget and wants to optimize between on-demand and provisioned pricing.

What Provisioned Throughput strategy MINIMIZES cost?

A) Purchase Provisioned Throughput for the peak capacity (100 req/min) 24/7 to ensure consistent performance
B) Purchase Provisioned Throughput sized for the average load (50 req/min) and use on-demand for burst above provisioned capacity
C) Do not purchase Provisioned Throughput — use on-demand pricing with a request queue to smooth out peaks, since the pattern has significant off-peak periods where provisioned capacity would be wasted
D) Purchase Provisioned Throughput for the business-hours load (100 req/min) with a 1-month commitment, and use on-demand for off-hours and weekends — schedule the provisioned throughput via automation

---

**Question 50** [Domain 3]

A GenAI application generates personalized investment summaries. The application currently takes 12 seconds end-to-end: 2 seconds for data retrieval, 1 second for prompt construction, 8 seconds for model inference, and 1 second for post-processing. The team needs to reduce the total latency to under 6 seconds. They use Claude 3 Sonnet on Bedrock.

What combination of optimizations achieves the target latency? (Select TWO)

A) Enable response streaming so users see content progressively, reducing perceived latency to first-token time (~1 second)
B) Parallelize data retrieval and prompt construction, reducing their combined time from 3 seconds to 2 seconds
C) Switch to Claude 3 Haiku for the generation step, reducing model inference from 8 seconds to approximately 2-3 seconds
D) Implement prompt engineering to reduce the input token count by 40%, shortening the model inference time
E) Pre-compute common investment summary components during off-peak hours and cache them in ElastiCache

---

**Question 51** [Domain 4]

A European insurance company uses Amazon Bedrock to process claims that contain personal data of EU residents. Under GDPR, a customer exercises their "right to erasure" (right to be forgotten) and requests deletion of all their personal data. The company has used the customer's claims data in three ways: (1) as input to Bedrock model invocations for claims processing, (2) indexed in an Amazon Bedrock Knowledge Base for retrieval, (3) stored as conversation logs in DynamoDB.

What steps are required to comply with the GDPR erasure request?

A) Delete the customer's data from DynamoDB and the Knowledge Base S3 source; Bedrock does not store or learn from customer inputs, so no action is needed for historical model invocations; re-sync the Knowledge Base to remove the embeddings; and document the erasure for compliance records
B) Delete data from DynamoDB only — Bedrock and Knowledge Bases are managed services and handle data deletion automatically
C) Delete data from all three locations and also request AWS Support to purge any data that may have been used to train the Bedrock model
D) Delete data from DynamoDB and the Knowledge Base, then fine-tune the model with the customer's data removed to "unlearn" their information

---

**Question 52** [Domain 4]

A US-based health tech company is building a HIPAA-compliant AI scribe that listens to doctor-patient conversations (via audio transcription), generates clinical notes using Amazon Bedrock, and stores them in the patient's electronic health record. The company has a Business Associate Agreement (BAA) with AWS. A compliance officer asks what additional technical controls are needed beyond the BAA.

What technical architecture ensures HIPAA compliance?

A) Encrypt all data in transit and at rest using customer-managed KMS keys, configure VPC endpoints for all AWS services, enable CloudTrail for full API audit logging, implement Bedrock Guardrails to redact any PHI from model outputs before storage, and ensure the model invocation logging is configured to an encrypted S3 bucket
B) The BAA covers all technical requirements — no additional controls are needed beyond signing the BAA
C) Enable default AWS encryption for all services, use public endpoints with TLS 1.2, and implement IAM policies restricting access to authorized personnel
D) Deploy all components in a dedicated AWS GovCloud region, as HIPAA workloads can only run in GovCloud

---

**Question 53** [Domain 4]

A financial institution is deploying an AI system that makes credit recommendation suggestions. Regulators require the institution to provide explanations for any adverse credit decisions. The AI system uses a complex RAG pipeline with Amazon Bedrock that considers credit history, income verification, debt ratios, and market conditions from multiple data sources.

How should the team implement explainability for regulatory compliance?

A) Log all retrieved context chunks with their relevance scores, the complete prompt sent to the model, the model's response, and the specific data points referenced — structure this as an "explanation chain" that traces the reasoning from input data to recommendation
B) Use Amazon SageMaker Clarify to generate explanations for the model's predictions
C) Implement a simpler rule-based system alongside the AI system, and use the rule-based system's logic as the regulatory explanation even when the AI system's recommendation differs
D) Add an instruction in the prompt telling the model to "explain your reasoning," and log the model's self-generated explanation as the regulatory documentation

---

**Question 54** [Domain 4]

A company's AI risk committee is establishing a model governance framework for their GenAI applications. They deploy models from multiple providers (Anthropic, Meta, Cohere) on Amazon Bedrock and also host custom models on SageMaker. The framework must track model versions, evaluation results, approved use cases, and risk ratings. Model changes must go through an approval workflow before production deployment.

What AWS-native architecture supports this governance framework?

A) Use Amazon SageMaker Model Registry to catalog all models (both Bedrock and SageMaker), with model package groups for each use case, approval workflows tied to CI/CD pipelines, and custom metadata for risk ratings and evaluation results
B) Build a custom governance application using DynamoDB for the model catalog, Step Functions for approval workflows, and S3 for storing evaluation artifacts
C) Use AWS Service Catalog to create approved model products, with portfolio sharing for different teams and launch constraints for governance
D) Use Amazon SageMaker Model Cards combined with SageMaker Model Registry — Model Cards document risk ratings, use cases, and evaluation results, while Model Registry handles versioning and approval workflows

---

**Question 55** [Domain 4]

A multinational company discovers that their customer service AI chatbot has been generating responses that contain biased recommendations — it recommends premium products more frequently to customers with English names compared to customers with non-English names. The bias was not present in testing but emerged after 3 months of production use. The model has not been retrained; it uses RAG with customer interaction history.

What is the root cause analysis approach AND remediation?

A) The foundation model has inherent bias — switch to a different foundation model and add Bedrock Guardrails content filters for bias
B) Investigate the RAG retrieval pipeline — the customer interaction history likely contains historical bias where sales agents upsold premium products more frequently to certain demographics, and the RAG system is surfacing these biased interaction patterns as context; remediate by auditing and debiasing the Knowledge Base content, implementing retrieval-time fairness filters, and adding evaluation metrics that monitor recommendation patterns across demographic groups
C) The system prompt likely contains biased instructions — audit and rewrite the system prompt for neutrality
D) This is a model drift issue — retrain the model with a balanced dataset using SageMaker

---

**Question 56** [Domain 4]

A government contractor building AI solutions must comply with FedRAMP High requirements. They need to deploy a GenAI application that processes classified documents. The application must use only FedRAMP-authorized services and ensure all data remains within FedRAMP-authorized boundaries.

What is the correct deployment strategy?

A) Use Amazon Bedrock in a standard commercial AWS region with VPC endpoints and customer-managed KMS encryption — Bedrock is FedRAMP High authorized
B) Deploy in AWS GovCloud (US), verify that the required Bedrock models are available in GovCloud, and if not, deploy open-source models on SageMaker in GovCloud which is FedRAMP High authorized
C) Use Amazon Bedrock in any region and apply Security Hub controls to enforce FedRAMP compliance
D) Deploy on-premises using AWS Outposts with SageMaker for complete data sovereignty

---

**Question 57** [Domain 4]

A company's security operations center (SOC) detects anomalous behavior from their Amazon Bedrock-powered internal assistant: unusually large responses, requests at unusual hours from a service account, and API calls to model IDs that the application doesn't normally use. The SOC suspects the service account credentials have been compromised and an attacker is using them to exfiltrate data through the Bedrock API.

What is the correct incident response sequence?

A) Immediately delete the compromised service account, deploy new credentials, and review CloudTrail logs
B) Rotate the service account credentials immediately to stop the attack, then investigate later
C) Contain: revoke the service account's IAM permissions immediately without deleting (preserve evidence); Investigate: analyze CloudTrail logs for all Bedrock API calls from the compromised credentials, check the model IDs accessed, review request/response sizes; Assess: determine what data was potentially exfiltrated; Remediate: create new credentials with least-privilege policies, enable GuardDuty for IAM anomaly detection, and implement SCP guardrails limiting Bedrock model access
D) Notify AWS Support and wait for their investigation before taking any action

---

**Question 58** [Domain 4]

A company deploys a customer-facing GenAI application and wants to implement responsible AI practices. They need to track and report on: model accuracy metrics, fairness metrics across demographic groups, hallucination rates, user satisfaction scores, and content safety incidents. These metrics must be aggregated monthly for the AI ethics board review.

What monitoring architecture provides comprehensive responsible AI metrics?

A) Use Amazon CloudWatch custom metrics for each responsible AI dimension, with automated monthly reports generated by a Lambda function and published to an S3-backed dashboard
B) Implement a custom evaluation pipeline: sample 5% of daily interactions, run automated evaluations (using a judge LLM for accuracy/hallucination, demographic analysis for fairness, Guardrails logs for safety incidents), store results in a metrics database, and generate monthly reports via Amazon QuickSight dashboards
C) Use Amazon SageMaker Model Monitor for all metrics, including bias detection and model quality monitoring
D) Rely on Amazon Bedrock's built-in model invocation logging and manually review a random sample of logs each month

---

**Question 59** [Domain 4]

A company is using Amazon Bedrock to generate insurance policy documents. A regulator requires that every AI-generated document include: (1) a disclosure that it was AI-generated, (2) a unique generation ID for traceability, (3) the model version used, and (4) a timestamp. These metadata requirements must be tamper-proof and verifiable.

How should the team implement tamper-proof AI content provenance?

A) Append the required metadata as a footer in every generated document and store a hash in a DynamoDB table
B) Log the metadata in CloudTrail and reference the CloudTrail event ID in the document
C) Generate the document, create a metadata record including all four required fields, compute a SHA-256 hash of the document+metadata, store the hash in Amazon QLDB (Quantum Ledger Database) for immutable audit, and embed the QLDB document ID in the generated document for traceability
D) Use Amazon Managed Blockchain to create an immutable record of each generated document with its metadata

---

**Question 60** [Domain 4]

A company operating in both EU and US markets uses a single Amazon Bedrock-powered application. EU privacy law (GDPR) requires that EU customer data not be transferred to US servers, while the US team requires access to US customer data for their operations. The AI application needs to serve both markets with the same functionality. A recent data protection impact assessment (DPIA) revealed that the current architecture routes all traffic through us-east-1.

What is the MINIMUM architectural change required for GDPR compliance?

A) Deploy a separate application stack in eu-west-1 for EU customers with its own Bedrock endpoint, Knowledge Base, and data stores; use Route 53 geolocation routing to direct EU users to the EU stack; ensure no EU customer data replicates to US regions
B) Add EU data encryption using AWS KMS with EU-managed keys, but keep the infrastructure in us-east-1 — encryption satisfies the GDPR requirement for adequate protection
C) Implement data pseudonymization for EU customer data before sending to the US-based Bedrock application, as pseudonymized data is not considered personal data under GDPR
D) Sign Standard Contractual Clauses (SCCs) with AWS for the cross-border data transfer, allowing EU data to continue flowing through us-east-1

---

**Question 61** [Domain 4]

A bank's AI system uses Amazon Bedrock to generate customer communication for loan applications. An internal audit finds that the model occasionally generates language that could be interpreted as discriminatory under the Equal Credit Opportunity Act (ECOA) — for example, using different tones or levels of formality based on the applicant's neighborhood (which correlates with race). The bank needs an immediate fix and a long-term solution.

What approach addresses BOTH the immediate and long-term concerns?

A) Immediately add Bedrock Guardrails with denied topics for any demographic references, and long-term, implement a bias testing framework that tests generated communications across diverse applicant profiles before deployment
B) Immediately switch to template-based responses that don't use AI generation, and long-term, fine-tune a model specifically on fair-lending-compliant communications
C) Immediately implement a post-generation review where a separate Bedrock model evaluates each communication for discriminatory language and tone disparities, blocking flagged content; long-term, remove neighborhood data from the model's input context, establish regular bias audits comparing communication patterns across protected class proxies, and implement automated regression testing for fairness metrics in the CI/CD pipeline
D) Immediately retrain the model with debiased training data, and long-term, implement continuous monitoring

---

**Question 62** [Domain 4]

A company uses multiple AI models across their applications and needs to implement centralized prompt governance. Different teams create their own prompts, leading to inconsistent safety practices — some teams forget to include safety instructions, others use outdated model-specific formatting. The company has 50+ prompts across 12 applications.

What architecture provides centralized prompt governance at scale?

A) Store all prompts in a shared S3 bucket with versioning, implement a CI/CD pipeline that validates prompts against a safety checklist before deployment, and use IAM policies to prevent direct prompt modification in application code
B) Use Amazon Bedrock Prompt Management to centrally manage all prompt templates with versioning, implement prompt variants for different models, create a required approval workflow via CodePipeline for prompt changes, and enforce usage of managed prompts through IAM policies that deny direct InvokeModel calls without a prompt ARN
C) Create a shared prompt library in a private npm/PyPI package that all teams import, with code review requirements for changes
D) Implement a prompt gateway Lambda function that sits between applications and Bedrock, injecting standardized safety prefixes to all prompts

---

**Question 63** [Domain 4]

An e-commerce company's AI-powered product recommendation system was found to be making recommendations that inadvertently created a filter bubble — repeatedly recommending similar products, reducing product diversity, and disadvantaging new or niche sellers. This has both ethical implications (limiting consumer choice) and business implications (reduced long-term engagement).

What systematic approach addresses the filter bubble while maintaining recommendation relevance?

A) Randomly inject 20% diverse products into recommendations to break the filter bubble
B) Implement a diversity-aware retrieval strategy: modify the RAG pipeline to include a re-ranking step that balances relevance scores with diversity metrics (product category spread, seller diversity, novelty score), add a configurable diversity threshold that can be tuned without model changes, monitor diversity metrics on the responsible AI dashboard, and A/B test the impact on long-term engagement and seller fairness
C) Use a multi-armed bandit approach for recommendations, allocating an exploration budget to new and diverse products
D) Remove collaborative filtering signals from the RAG context and rely solely on content-based similarity for recommendations

---

**Question 64** [Domain 5]

A team is implementing a CI/CD pipeline for their GenAI application that uses Amazon Bedrock. The application includes prompts, Guardrails configurations, Knowledge Base data sources, and application code. A recent production incident was caused by a prompt change that passed unit tests but caused the model to produce harmful outputs in edge cases. The team needs a robust testing strategy.

What CI/CD pipeline design catches prompt-related regressions before production?

A) Implement unit tests for application code, integration tests for API endpoints, and manual prompt review before each deployment
B) Implement a multi-stage pipeline: (1) unit tests for application code, (2) prompt regression tests using a curated test suite of 200+ diverse inputs including adversarial cases evaluated against quality rubrics, (3) Guardrails policy validation against test inputs, (4) a canary deployment that routes 5% of traffic to the new version with automated rollback if quality metrics drop, and (5) model evaluation job comparing the new prompt's performance against the baseline
C) Use blue/green deployments for all changes and manually validate outputs for 24 hours before full cutover
D) Implement shadow testing where all production traffic is also sent to the new version, and compare outputs between old and new versions automatically

---

**Question 65** [Domain 5]

A developer is debugging a RAG pipeline where users report that the system "knows" the answer is in the documents but returns "I don't have enough information to answer that." The pipeline uses Amazon Bedrock Knowledge Bases with OpenSearch Serverless. The developer has confirmed that relevant documents exist in the Knowledge Base.

What is the systematic debugging approach to identify the failure point?

A) Increase the number of retrieved chunks from 5 to 20 to ensure the relevant information is captured
B) Enable Bedrock Knowledge Base trace logging and analyze the retrieval step: (1) check if the query embedding is semantically close to the expected document chunks, (2) verify the retrieved chunks contain the relevant information, (3) check chunk relevance scores — if chunks are retrieved but scores are low, the embedding model may be poorly matching the query style to document style; (4) if correct chunks are retrieved with good scores, inspect the prompt template to ensure it instructs the model to use the provided context
C) Re-index the Knowledge Base with a different chunking strategy and retry
D) Switch to a more capable model (e.g., Claude 3.5 Sonnet) that can better synthesize information from retrieved chunks

---

**Question 66** [Domain 5]

A company runs a production GenAI application on Amazon Bedrock. They need comprehensive monitoring for: model performance (latency, error rates), cost tracking (token usage per feature), business metrics (user satisfaction, task completion rates), and safety metrics (guardrail trigger rates, content policy violations). The team needs to identify issues quickly and attribute costs to specific features.

What monitoring architecture provides the required observability?

A) Enable Bedrock model invocation logging to CloudWatch, create CloudWatch dashboards with metrics for latency and errors, and use AWS Cost Explorer for cost tracking
B) Implement custom instrumentation: emit CloudWatch custom metrics with dimensions for feature name and model ID at each Bedrock call, log token counts with feature attribution to a cost tracking table, integrate user feedback collection that records satisfaction per interaction, aggregate Guardrails CloudWatch metrics by policy type — visualize everything in a unified CloudWatch dashboard with alarms for anomalies
C) Use AWS X-Ray for end-to-end tracing of each request, supplemented by CloudWatch Logs Insights queries for cost analysis
D) Deploy a third-party observability platform (Datadog, New Relic) with Bedrock integration for comprehensive monitoring

---

**Question 67** [Domain 5]

A team manages a Knowledge Base that serves a GenAI application. The Knowledge Base indexes 500,000 documents from S3, and new documents are added at a rate of 1,000 per day. The team has discovered that some documents fail to sync silently — they appear in S3 but their embeddings never appear in the OpenSearch index. This has caused gaps in retrieval quality that went undetected for weeks.

What operational improvement prevents undetected sync failures?

A) Switch to a manual re-indexing process where an operator triggers and verifies each sync
B) Implement a sync monitoring pipeline: after each Knowledge Base sync, compare the document count in S3 versus the vector count in OpenSearch, emit a CloudWatch custom metric for the delta, set an alarm when the delta exceeds a threshold, additionally log sync job status and parse for errors, and implement a dead-letter mechanism for documents that fail to embed
C) Increase the sync frequency to every hour to catch failures faster
D) Use Amazon Kendra instead of Bedrock Knowledge Bases, as Kendra provides built-in sync status dashboards

---

**Question 68** [Domain 5]

A company wants to implement automated model evaluation as part of their GenAI application lifecycle. They need to evaluate their Bedrock-based application monthly against three criteria: response accuracy, response safety, and latency performance. The evaluation must use a consistent test dataset and produce comparable scores over time to detect quality degradation.

What architecture supports automated, reproducible model evaluation?

A) Use Amazon Bedrock model evaluation jobs with a fixed dataset stored in S3, scheduled monthly via EventBridge, with results stored in S3 and comparison dashboards in QuickSight that track scores over time; supplement with custom Lambda-based latency benchmarks
B) Have a team of evaluators manually review 100 random responses each month and score them on a rubric
C) Use SageMaker Model Monitor with custom monitoring schedules to detect drift in model quality
D) Implement A/B testing in production and use real user engagement metrics as a proxy for quality

---

**Question 69** [Domain 5]

A company's GenAI application experiences a sudden 10x increase in latency during a marketing campaign that drives unexpected traffic. The application uses Amazon Bedrock with Claude 3 Sonnet behind API Gateway and Lambda. CloudWatch shows that Bedrock is returning HTTP 429 (ThrottlingException) for 60% of requests. The team needs to restore service immediately and prevent recurrence.

What is the correct sequence of actions?

A) Immediately request a Bedrock service quota increase, then optimize the application to reduce token usage
B) Immediately: (1) implement request queuing with SQS to absorb the burst, (2) activate a cached-response fallback for common queries, (3) route overflow traffic to a secondary region; Short-term: request quota increase and evaluate Provisioned Throughput; Long-term: implement auto-scaling architecture with circuit breakers and load shedding based on priority
C) Immediately switch all traffic to Claude 3 Haiku which has higher default quotas
D) Immediately scale up Lambda concurrency and API Gateway throttling limits

---

**Question 70** [Domain 5]

A developer is using AWS Step Functions to orchestrate a complex GenAI workflow. The workflow involves: (1) document ingestion and parsing, (2) parallel extraction of entities, sentiment, and key phrases, (3) consolidation of extracted information, (4) generation of a summary using Bedrock, (5) human review for quality above a confidence threshold, and (6) storage of results. Each step can fail independently and the workflow must be resumable.

What Step Functions design pattern BEST handles this workflow?

A) A single Express Workflow with all steps in sequence, using retry policies on each state
B) A Standard Workflow with: a Task state for ingestion, a Parallel state for the three extraction steps, a Task state for consolidation, a Task state for Bedrock generation, a Choice state that routes to a callback Task (human review) or directly to storage based on confidence, with Catch blocks on each state routing to a failure handler that stores progress for resumability
C) Nested Step Functions — an Express Workflow for the fast extraction steps and a Standard Workflow for the human review step
D) A Map state that processes each document independently with all six steps, using retry and catch at the Map level

---

**Question 71** [Domain 5]

A team is debugging inconsistent outputs from their Amazon Bedrock application. The same user query produces significantly different quality responses at different times of day. The application code, prompts, and model are unchanged. Morning responses are detailed and accurate; evening responses are brief and sometimes miss key details.

What is the MOST likely cause and investigation approach?

A) The model's performance degrades under load — investigate Bedrock service health during evening hours
B) Investigate the RAG pipeline: the Knowledge Base retrieval may return different context at different times because (1) background sync jobs running during business hours temporarily cause indexing inconsistencies, (2) the query embedding may interact differently with recently updated vectors, or (3) concurrent load affects OpenSearch search latency causing timeouts that return fewer chunks — enable Knowledge Base trace logging and compare retrieved chunks between morning and evening queries
C) The temperature parameter is being set dynamically based on a configuration that changes throughout the day — audit the application configuration
D) This is expected model behavior — foundation models have inherent randomness and non-zero temperature causes variation

---

**Question 72** [Domain 5]

A company is implementing blue/green deployment for their GenAI application. The application consists of: a Lambda function calling Bedrock, an API Gateway, a Bedrock Knowledge Base, and DynamoDB for session storage. A deployment updates the Lambda code, the system prompt, and adds new documents to the Knowledge Base. The team needs to ensure they can instantly roll back to the previous version if the new deployment produces quality issues.

What deployment strategy enables instant rollback for ALL components?

A) Use Lambda versioning with aliases (blue/green via weighted alias), API Gateway stage variables pointing to the Lambda alias, version the system prompt in a parameter store with separate blue/green values, maintain the Knowledge Base with versioned S3 prefixes (v1/ and v2/) — rollback switches the Lambda alias, stage variable, and parameter store values
B) Use AWS CodeDeploy with Lambda deployment preferences for traffic shifting, and manually revert Knowledge Base changes if needed
C) Deploy the new version in a separate AWS account and use Route 53 to switch traffic, rolling back by changing the DNS record
D) Use Lambda layers for the system prompt, Lambda versioning for code, and accept that Knowledge Base changes cannot be instantly rolled back

---

**Question 73** [Domain 5]

A production GenAI application logs all interactions to S3 via Bedrock model invocation logging. The team wants to build an automated feedback loop: analyze logged interactions to identify poor-quality responses, generate improved training examples, and use them to improve the system. The analysis must happen daily and flag interactions where the model's response quality is below acceptable thresholds.

What architecture implements this automated quality improvement loop?

A) Export logs to Amazon Athena for daily SQL analysis, manually review flagged interactions, and update prompts based on patterns
B) Implement a daily EventBridge-triggered pipeline: (1) a Glue job parses model invocation logs from S3, (2) a SageMaker Processing job runs a judge LLM evaluation on each interaction scoring quality dimensions, (3) low-scoring interactions are stored in a "needs improvement" dataset in S3, (4) a data scientist reviews flagged interactions weekly, (5) approved corrections are added to a few-shot examples database or RAG Knowledge Base to improve future responses
C) Use CloudWatch Logs Insights to query for error patterns and automatically update the system prompt based on common error categories
D) Implement real-time evaluation in the application — after each Bedrock response, immediately run a quality evaluation and log the score, triggering an alarm when the score drops

---

**Question 74** [Domain 5]

A company runs a multi-model GenAI application that uses Claude 3 Haiku for simple queries, Claude 3 Sonnet for complex queries, and Titan Embeddings for RAG. Their monthly AWS bill shows $120,000 for Bedrock, but they have no visibility into which features, user segments, or query types drive the most cost. The finance team requires a cost attribution report broken down by feature (chat, search, summarization) and user tier (free, premium, enterprise).

What cost attribution architecture provides the required granularity?

A) Use AWS Cost Explorer with Bedrock-specific cost categories and tags
B) Implement a cost tracking middleware: before each Bedrock API call, record the feature name, user tier, model ID, and estimated input tokens; after the call, record actual input/output tokens from the response metadata; store all records in a DynamoDB table with feature and tier as GSI keys; generate weekly reports via Athena queries on DynamoDB exports, and set budget alerts per feature using CloudWatch alarms on aggregated costs
C) Enable AWS Cost and Usage Reports (CUR) with hourly granularity and use resource-level tags to attribute costs
D) Use Amazon CloudWatch Metrics to track InvocationCount per model and distribute total Bedrock cost proportionally

---

**Question 75** [Domain 5]

A platform team manages a shared GenAI infrastructure used by 8 development teams. Each team has their own Bedrock Agents, Knowledge Bases, and application code. The platform team needs to enforce standards: all agents must use approved model versions, all Knowledge Bases must have encryption enabled, Guardrails must be attached to every agent, and no team can exceed their allocated monthly token budget. Non-compliant resources should be automatically detected and the team notified.

What governance architecture enforces these standards at scale?

A) Create detailed documentation of standards and rely on code review to enforce compliance
B) Implement AWS Config custom rules that check: (1) Bedrock Agent configurations use only approved model ARNs, (2) Knowledge Base encryption is enabled, (3) Guardrails are associated with each agent; use Service Control Policies (SCPs) to prevent model invocations for non-approved models; implement a cost governance Lambda that tracks per-team token usage against budgets and sends SNS alerts at 80% and 100% thresholds; auto-remediate non-compliant resources using Config remediation actions
C) Use AWS Organizations with separate accounts per team and manually review each team's configuration quarterly
D) Implement a shared API Gateway layer that validates all Bedrock calls against the standard policies before forwarding to Bedrock

---

## ANSWER KEY

---

### Question 1
**Correct Answer: B**

**Explanation:** Provisioned Throughput on Amazon Bedrock reserves dedicated model inference capacity, guaranteeing consistent latency regardless of overall service load. The problem is specifically latency spikes during peak hours, which indicates contention for on-demand capacity. Option A (Haiku) trades quality for speed, which the question says is unacceptable. Option C (SageMaker) introduces significant operational complexity for a problem solvable natively in Bedrock. Option D (caching) only helps with identical queries, not near-identical ones, and fraud narratives are unique to each transaction.

**Key Takeaway:** When latency consistency is the primary concern and quality cannot be compromised, Provisioned Throughput is the Bedrock-native solution for dedicated capacity.

---

### Question 2
**Correct Answer: C**

**Explanation:** This requires handling documents up to 180K tokens AND ensuring no data leaves the AWS account boundary. Claude 3.5 Sonnet has a 200K context window, handling most documents, but some exceed this. The hybrid approach uses Bedrock with VPC endpoints for documents within the window and SageMaker with chunked summarization for those exceeding it. Option A fails for documents > 200K tokens. Option B adds unnecessary SageMaker complexity for documents that fit in Claude's window. Option D — Guardrails PII masking would alter the content making summarization less useful, and masking isn't the same as preventing data from leaving the account.

**Key Takeaway:** For varying document sizes, a tiered architecture using the appropriate service for each size range is optimal. VPC endpoints keep traffic private for both Bedrock and SageMaker.

---

### Question 3
**Correct Answer: B**

**Explanation:** Prompt engineering with few-shot examples is the most cost-effective approach — it requires no model training, no additional infrastructure, and can be iterated quickly. The underperformance in three languages can often be addressed by providing high-quality examples in the prompt. Option A (fine-tuning three models) is expensive and operationally complex. Option C (SageMaker endpoints) adds infrastructure costs and operational overhead. Option D (translate round-trip) loses cultural nuance, which is the exact requirement.

**Key Takeaway:** Always try prompt engineering with few-shot examples before investing in fine-tuning. It's the cheapest and fastest approach, especially when you have high-quality examples but the underperformance is moderate.

---

### Question 4
**Correct Answer: C**

**Explanation:** A confidence-based routing strategy minimizes cost by using the cheaper model (Haiku) for the majority of work while escalating only when needed. Haiku handles extraction well (94% accuracy is acceptable), and for risk assessments, only low-confidence ones go to Sonnet. This means most requests use Haiku pricing while maintaining quality where it matters. Option A uses Sonnet for everything (most expensive). Option B always sends to Sonnet for risk assessment regardless of Haiku's confidence (more expensive than C). Option D — fine-tuning Haiku for risk assessment is possible but takes time, cost, and may not achieve Sonnet's quality.

**Key Takeaway:** Confidence-based model routing is a powerful cost optimization: use cheap models as default and escalate to expensive models only when confidence is low.

---

### Question 5
**Correct Answer: C**

**Explanation:** With 100,000 labeled examples across 500+ categories, the best approach combines powerful embeddings with supervised learning. Titan Multimodal Embeddings create a joint representation of text and images, and a classification head trained on 100K examples can learn the complex multi-label classification task. Option A (prompt-based) lacks the ability to handle 500+ categories reliably and can't be trained on the labeled data. Option B (SageMaker fine-tuning) is viable but has more operational complexity. Option D treats modalities independently and loses cross-modal understanding.

**Key Takeaway:** For large-scale classification with abundant labeled data, combining foundation model embeddings with a trained classification layer outperforms pure prompt-based approaches.

---

### Question 6
**Correct Answer: C**

**Explanation:** Comprehensive model evaluation requires both automated metrics (for scalable, reproducible measurement) and human evaluation (for nuanced assessment of safety-critical content and readability). Amazon Bedrock model evaluation supports both modes. Option A misses automated metrics. Option B misses Bedrock's managed evaluation infrastructure and the LLM-as-judge has known limitations for factual accuracy in specialized domains. Option D evaluates with live traffic, which is inappropriate for safety-critical evaluation — you need offline evaluation first.

**Key Takeaway:** For safety-critical domains, model evaluation must combine automated metrics (scalability) with human evaluation (reliability on nuanced criteria). Never use live traffic as the primary evaluation method for safety-critical systems.

---

### Question 7
**Correct Answer: A**

**Explanation:** The problem is hallucinated citations for recent papers, which is a classic knowledge cutoff issue. RAG with a Knowledge Base of recent papers directly addresses the root cause by providing the model with actual recent paper data to cite from. Citation grounding validation ensures the model only cites papers present in the retrieved context. Option B (fine-tuning) is expensive and doesn't solve the ongoing problem as new papers are published. Option C (system prompt) doesn't reliably prevent hallucination. Option D (Guardrails) can't validate DOI correctness at generation time.

**Key Takeaway:** Hallucinated citations are best solved with RAG + grounding validation. RAG provides real references; grounding ensures the model uses them.

---

### Question 8
**Correct Answer: C**

**Explanation:** The tiered prompt architecture solves both problems: long prompts consuming context window, and per-tenant customization. A short core system prompt keeps base costs low, while per-tenant Knowledge Bases with few-shot examples inject only relevant context via RAG, keeping the variable portion minimal and targeted. Option A (category fine-tuning) doesn't capture individual tenant nuance within a category. Option B (prompt variants) still faces the long-prompt problem. Option D (LoRA adapters per tenant) doesn't scale to 500+ tenants operationally.

**Key Takeaway:** For multi-tenant GenAI, combine a short shared system prompt with per-tenant RAG-based context injection — this controls token costs while maintaining customization.

---

### Question 9
**Correct Answer: D**

**Explanation:** An Agent-based architecture best handles this mix of static knowledge and dynamic data. The base model's reasoning is sufficient when augmented with proper tools and context — routing rules and regulations change slowly enough to be in a Knowledge Base, while fuel costs and weather require real-time API calls via action groups. Option A (fine-tune + RAG for all) over-invests in fine-tuning when the model's reasoning is adequate with proper context. Option B (RAG only) can't handle real-time fuel and weather data effectively. Option C unnecessarily fine-tunes for regulation knowledge that changes quarterly.

**Key Takeaway:** Use Agents with action groups for real-time data and Knowledge Bases for semi-static data. Fine-tuning is only warranted when the model needs new reasoning patterns, not just new facts.

---

### Question 10
**Correct Answer: C**

**Explanation:** Keyword-based routing in a Lambda function is the lightest-weight approach that meets the <50 ms latency requirement. Simple heuristics (keyword matching for billing/account terms, question length/complexity) execute in single-digit milliseconds. Option A (SageMaker classifier) adds ~100-200 ms latency for a cold start. Option B (Bedrock Prompt Router) routes between only two models and uses AI-based routing which adds latency. Option D (Comprehend) adds network latency for the API call.

**Key Takeaway:** For ultra-low-latency routing decisions, simple rule-based/heuristic approaches outperform ML classifiers. Save ML-based routing for cases where the classification is truly complex.

---

### Question 11
**Correct Answer: D**

**Explanation:** For maximum determinism in a safety-critical application, removing the model's generative freedom is the safest approach. An Agent with an action group that directly queries a structured API and returns formatted results ensures the output is 100% derived from the database, not the model's parametric knowledge. The model serves only as a natural language interface to interpret the query. Option A (temperature=0 + guardrails) — temperature=0 is near-deterministic but not guaranteed, and LLMs can still hallucinate associations. Option B (RAG + validation) is strong but has the validation as a catch rather than prevention. Option C (fine-tuning) can still hallucinate despite training data.

**Key Takeaway:** For safety-critical applications requiring determinism, design the architecture to limit the model to query interpretation, not fact generation. Use structured data lookups for the authoritative answers.

---

### Question 12
**Correct Answer: A**

**Explanation:** Titan Multimodal Embeddings + OpenSearch Serverless provides a fully managed, scalable architecture. Pre-computing embeddings handles the 2M catalog offline, OpenSearch k-NN search meets the 500 ms latency at 1,000 concurrent users, and price-boosting scoring functions combine visual similarity with business logic. Option B (Rekognition Custom Labels) is for object detection, not similarity search. Option C (CLIP on SageMaker + Pinecone) introduces a third-party dependency and SageMaker management overhead. Option D (Claude multimodal) is too slow and expensive for 1,000 concurrent searches.

**Key Takeaway:** For visual similarity search at scale, pre-compute embeddings with a multimodal model, store in a vector database, and use k-NN search with custom scoring functions.

---

### Question 13
**Correct Answer: B**

**Explanation:** For 99.9% recall on 15 categories, a multi-stage pipeline with different detection methods provides defense in depth. Textract handles OCR, Comprehend catches standard PII, a fine-tuned NER model handles custom categories, Claude provides reasoning-based detection for edge cases, and mandatory human review catches the remaining errors. No single model achieves 99.9% recall. Option A (Claude only) is a single point of failure. Option C (Macie) is designed for S3 data classification, not document redaction. Option D (fine-tuned model only) is still a single model.

**Key Takeaway:** For recall-critical tasks, use a multi-stage pipeline with different detection methods (rule-based + ML + LLM + human review). Never rely on a single model for safety-critical detection.

---

### Question 14
**Correct Answer: A**

**Explanation:** Language-specific system prompts with style guides and idiom examples leverage the model's existing multi-language capabilities while guiding it toward idiomatic patterns. Prompt caching for the static portions (style guides) reduces cost for repeated calls. This has the LEAST operational overhead because it requires no model training or additional infrastructure. Option B (single fine-tune) risks catastrophic forgetting in well-performing languages. Option C (separate fine-tuned models + router) works but has high operational overhead. Option D (CodeWhisperer) may not support all 12 languages at the required quality.

**Key Takeaway:** Prompt engineering with style guides and prompt caching offers the best quality-to-overhead ratio for multi-language generation tasks, especially when the base model is already competent.

---

### Question 15
**Correct Answer: A**

**Explanation:** Claude 3 Haiku is optimized for speed and cost, ideal for short creative text. Trimming to the 20 most relevant songs dramatically reduces input tokens (and cost) while maintaining personalization quality. CDN-backed caching handles the high request volume for users with similar contexts. Option B (fine-tune + provisioned) is over-engineered — pre-generation fails because context (weather, time) changes. Option C (Sonnet + full history) is expensive at 10M requests/day. Option D (GPT-2 on SageMaker Serverless) — SageMaker Serverless has cold start issues and GPT-2 quality is insufficient.

**Key Takeaway:** For high-volume, short-output tasks, combine the cheapest capable model with aggressive input pruning and semantic caching for maximum cost efficiency.

---

### Question 16
**Correct Answer: B**

**Explanation:** A fine-tuned smaller model on a dedicated GPU instance provides the most consistent sub-100ms latency. Fine-tuning on command-to-plan pairs learns the domain-specific mapping directly. The warehouse layout is injected as context and updated weekly. Option A (Haiku on Bedrock) — even with prompt caching, network round-trip + model inference may not consistently meet 100ms. Option C (Agent) adds multiple round-trips (model → API → model) making 100ms impossible. Option D (custom seq2seq) is viable but weekly retraining is operationally heavy.

**Key Takeaway:** For ultra-low latency requirements (<100ms), a dedicated fine-tuned model on a GPU endpoint provides the most consistent performance, avoiding network round-trip variability of API-based services.

---

### Question 17
**Correct Answer: A**

**Explanation:** Amazon Bedrock batch inference API is designed exactly for this use case — large batch processing that is not time-sensitive. It offers a 50% discount compared to on-demand pricing. The bursty, predictable workload (2 weeks per quarter) means no idle infrastructure costs. Option B (SageMaker endpoints) requires infrastructure management and has costs even when idle or scaling to zero has cold start delays. Option C (Provisioned Throughput) has minimum commitment periods and is expensive for bursty workloads. Option D (SageMaker async) adds operational complexity versus Bedrock batch.

**Key Takeaway:** For large, non-time-sensitive batch workloads, Amazon Bedrock batch inference API provides the lowest total cost with minimal operational overhead.

---

### Question 18
**Correct Answer: B**

**Explanation:** A two-tier system matches the tiered SLA requirements: a fast lightweight classifier on SageMaker real-time endpoints handles the <1 second SLA for all posts (initial risk scoring), while high-risk posts escalate to a more capable model for detailed classification within the 30-second SLA. Option A (Rekognition + Comprehend) doesn't provide a single risk score and may not meet custom category requirements. Option C (Guardrails) is designed for model output filtering, not content classification at scale. Option D (Haiku for all) — processing 500K posts/hour through a single model is expensive and doesn't optimize for the tiered SLA.

**Key Takeaway:** For tiered SLA requirements, implement a multi-tier architecture: a fast, cheap classifier for initial triage, with escalation to a more capable (and expensive) model only for high-risk items.

---

### Question 19
**Correct Answer: A**

**Explanation:** This leverages the existing OpenSearch investment, adds vector search capability with Titan Embeddings, and uses OpenSearch's native hybrid query to combine k-NN (semantic) and BM25 (keyword) scoring. This is the most operationally efficient because it minimizes new infrastructure. Option B (Bedrock Knowledge Bases) has limited hybrid search capabilities and may not support all 20+ metadata filters natively. Option C (pgvector) loses the BM25 hybrid search capability and adds complexity. Option D (Kendra) has document limits and may not scale to 50M documents cost-effectively.

**Key Takeaway:** When hybrid search (semantic + keyword) is required at scale, OpenSearch Serverless with vector search provides the best balance of capability, scalability, and operational efficiency.

---

### Question 20
**Correct Answer: A**

**Explanation:** Relational hallucination happens when the model mixes up associations between entities. By providing complete policy records as structured data (JSON) and instructing the model to use ONLY those values, you ensure the model has the correct relationships explicitly available. Structured data makes entity relationships unambiguous. Option B (fine-tuning) doesn't prevent hallucination and requires ongoing training. Option C (second LLM check) adds cost and latency and may itself make relational errors. Option D (Guardrails grounding) checks if content is grounded but may not catch subtle relational errors where individual facts are present but paired incorrectly.

**Key Takeaway:** For relational accuracy, provide structured data (not unstructured text) as context, making entity-to-attribute relationships explicit and unambiguous.

---

### Question 21
**Correct Answer: A**

**Explanation:** The combination of maximum iterations (preventing infinite loops) and idempotency detection in Lambda (detecting and short-circuiting duplicate calls) directly addresses the loop problem while maintaining agent autonomy. Option B (Prompt Flows) replaces the agent entirely, losing the dynamic reasoning capability needed for complex contracts. Option C adds complexity without guaranteed prevention. Option D (reducing temperature + explicit instructions) makes the agent rigid and fragile when encountering unusual contract structures.

**Key Takeaway:** Combat agent action loops with two defenses: iteration limits at the agent level, and idempotency detection at the action group level. This preserves agent flexibility while preventing runaway behavior.

---

### Question 22
**Correct Answer: C**

**Explanation:** The agent uses Knowledge Base descriptions to decide which Knowledge Base to query. Poorly written descriptions lead to incorrect routing. Detailed descriptions with example query patterns directly improve the agent's ability to select the right source. This is the simplest, most effective fix. Option A (consolidation) loses the ability to query targeted sources and metadata filtering adds complexity. Option B (pre-processing classifier) adds latency and another potential failure point. Option D (reranking) doesn't fix the retrieval selection problem — it just re-sorts results after the wrong data is retrieved.

**Key Takeaway:** Agent Knowledge Base selection is driven by the descriptions in the agent's instructions. Invest time in clear, example-rich Knowledge Base descriptions before adding architectural complexity.

---

### Question 23
**Correct Answer: B**

**Explanation:** Strands Agents SDK with try-catch patterns provides the right balance of flexibility and reliability. The Orchestrator as a Strands Agent can dynamically coordinate the other agents, try-catch in tool implementations handles partial failures gracefully (allowing the system to continue with available results), and system prompt instructions enforce the compliance checkpoint. Option A (Prompt Flows) doesn't support the dynamic decision-making needed for complex financial advice. Option C (Step Functions) adds infrastructure complexity and is better for stateless orchestration, not conversational agents. Option D (Bedrock agent-to-agent) has limited failure handling capabilities.

**Key Takeaway:** For multi-agent systems requiring graceful degradation, use try-catch patterns in agent tool implementations to handle partial failures while maintaining the system's overall availability.

---

### Question 24
**Correct Answer: A**

**Explanation:** Query decomposition directly addresses the multi-document synthesis problem. Complex questions are broken into focused sub-queries, each retrieving from the most relevant document sections. Deduplication prevents redundant context, and the final synthesis step combines information across all retrieved chunks. Option B (bigger chunks) wastes context window on irrelevant text. Option C (hierarchical indexing) helps with document selection but doesn't address cross-document retrieval for specific details. Option D (Kendra FAQs) can't handle the open-ended nature of compatibility questions.

**Key Takeaway:** For complex questions requiring multi-document synthesis, query decomposition into sub-queries dramatically improves retrieval completeness compared to single-query retrieval.

---

### Question 25
**Correct Answer: A, E**

**Explanation:** Cohere Embed's `input_type` parameter (setting "search_document" for indexing and "search_query" for querying) significantly improves retrieval for domain-specific content by optimizing the embedding space for asymmetric search. Hybrid search (Option E) combines the strengths of semantic similarity (catching concepts like "indemnification" ≈ "hold harmless") with keyword matching (catching exact legal terms). Option B (semantic chunking) helps but doesn't address the core embedding quality issue. Option C (metadata filtering) requires known intent at query time. Option D (reducing dimensions) degrades quality for no relevance benefit.

**Key Takeaway:** For domain-specific retrieval, use embedding models with asymmetric search support (separate document/query embeddings) and combine with BM25 keyword matching for hybrid search.

---

### Question 26
**Correct Answer: B**

**Explanation:** Summarization of earlier turns preserves the essential context (decisions made, requirements gathered) without consuming token budget. Keeping the last 3 raw turns maintains conversational coherence. This balances context retention, cost, and quality. Option A (sliding window) loses important early-conversation context (e.g., initial requirements stated in turn 1). Option C (larger context window) doesn't solve the degraded quality at long contexts — models still perform worse with very long inputs. Option D (per-session KB + RAG) adds architectural complexity and may miss important conversational flow.

**Key Takeaway:** For long conversations, use a rolling summarization strategy — summarize older turns periodically and keep recent turns verbatim. This optimizes the signal-to-token ratio.

---

### Question 27
**Correct Answer: B**

**Explanation:** Each MCP server has different requirements that map to different deployment patterns. Lambda is ideal for the frequently-called, latency-sensitive database server (auto-scales, pay-per-use). ECS Fargate with higher CPU handles CPU-intensive document processing without Lambda's timeout constraints. ECS with persistent tasks suits the notification server's need for persistent SMTP connections that Lambda's ephemeral nature can't maintain. Option A (all Lambda) fails for persistent connections and CPU-intensive work. Option C (single ECS service) doesn't allow independent scaling. Option D (SageMaker) is designed for ML inference, not general-purpose services.

**Key Takeaway:** Match deployment patterns to workload characteristics — Lambda for auto-scaling stateless work, ECS for persistent connections and resource-intensive tasks.

---

### Question 28
**Correct Answer: A**

**Explanation:** The key requirement is "dynamic user interaction with follow-up questions." Bedrock Agents are designed for conversational, iterative interactions — they can decide when to ask clarifying questions, when to search, and how to adapt based on user responses. Option B (Prompt Flows) is a directed graph — it lacks the ability to dynamically branch based on unpredictable user follow-ups. Option C (KB as product catalog) loses structured search capabilities (price filtering, sorting). Option D (Prompt Flows with loop) approximates conversational behavior but is rigid compared to agent reasoning.

**Key Takeaway:** Use Bedrock Agents for dynamic, conversational interactions and Prompt Flows for deterministic, predefined workflows. The key differentiator is whether the interaction pattern is predictable.

---

### Question 29
**Correct Answer: A**

**Explanation:** Amazon Textract is purpose-built for document parsing with table and form extraction capabilities that outperform general-purpose vision models on structured documents. Bedrock Agents with action groups handle the reasoning and API enrichment step naturally. DynamoDB provides fast, structured storage. Option B (Claude vision only) is less accurate for structured table extraction than Textract. Option C (Comprehend for NER) misses the document structure information. Option D (SageMaker Processing) adds unnecessary complexity when managed services handle each step.

**Key Takeaway:** Use purpose-built services (Textract for document parsing, Comprehend for NER) for their specialized tasks, and foundation models (Bedrock) for the reasoning/enrichment tasks that require language understanding.

---

### Question 30
**Correct Answer: D**

**Explanation:** Defense in depth with a deterministic safety layer is most robust against prompt injection. A rule-based system for emergency detection (Lambda) cannot be influenced by prompt injection attacks — it operates independently of the LLM. Bedrock handles only the safe conversational responses, and Guardrails provide additional output filtering. Option A has all safety checks within the LLM pipeline, which prompt injection could potentially bypass. Option B (fine-tuning) doesn't prevent sophisticated injection attacks. Option C (Guardrails only) is good but a single layer — determined attackers may find bypasses.

**Key Takeaway:** For safety-critical chatbots, implement deterministic safety checks (rule-based systems) OUTSIDE the LLM pipeline for critical scenarios, as they cannot be manipulated by prompt injection.

---

### Question 31
**Correct Answer: B**

**Explanation:** AWS AppConfig provides real-time configuration updates without redeployment, supports deployment strategies (gradual rollout with bake time for safety), and Lambda validators can verify model ID validity before the configuration is deployed. This prevents invalid configurations from reaching the application. Option A (DynamoDB polling) has latency and no validation mechanism. Option C (CloudWatch alarms → task definition update) requires ECS redeployment. Option D (Parameter Store) requires application-level change detection.

**Key Takeaway:** Use AWS AppConfig with Lambda validators for dynamic configuration that requires real-time updates with safety validation — it's purpose-built for this pattern.

---

### Question 32
**Correct Answer: A**

**Explanation:** The Bedrock Agent architecture with two separate action groups provides clear separation of concerns (generation/validation vs. execution), proper safety guardrails (AST parsing blocks dangerous SQL, read-only credentials prevent accidents), and conversation memory enables the iterative refinement workflow. Option B (Prompt Flows) can't handle the iterative, conversational refinement. Option C (Amazon Q) doesn't provide the customization needed. Option D (SageMaker fine-tuned) lacks conversational refinement capabilities.

**Key Takeaway:** Separate action groups for different security levels (validation vs. execution) is a security best practice for agents. Use conversation memory for iterative refinement patterns.

---

### Question 33
**Correct Answer: C**

**Explanation:** Step Functions with a callback pattern is the most streamlined approach for this workflow. The callback pattern pauses the workflow, sends a task token via SNS to the manager, and resumes when the manager approves — natively supporting approve/reject. Combined with a simple frontend for the edit-and-approve workflow, this integrates cleanly with the existing pipeline. Option A (A2I) is designed for ML-specific review workflows and adds overhead. Option B (custom DynamoDB queue + React UI) requires building the entire workflow from scratch. Option D (A2I with auto-approve) — auto-approving after 4 hours defeats the purpose of human review.

**Key Takeaway:** AWS Step Functions callback pattern is ideal for human-in-the-loop workflows with defined SLAs — it pauses execution, delegates to humans, and resumes on response.

---

### Question 34
**Correct Answer: C**

**Explanation:** DynamoDB for durable conversation storage + rolling summarization handles the cross-channel requirement (any channel can load from DynamoDB by user ID) while managing the context window challenge (summaries keep context concise). The channel-agnostic API layer ensures consistent behavior regardless of channel. Option A (full history loading) will exceed context windows for long conversations. Option B (Bedrock sessions) — Bedrock doesn't have persistent cross-channel session management. Option D (Amazon Lex) adds unnecessary complexity for what is primarily a state management problem.

**Key Takeaway:** For cross-channel conversation continuity, store conversation state in a durable, channel-agnostic store (DynamoDB) with a summarization strategy to manage context growth.

---

### Question 35
**Correct Answer: C**

**Explanation:** Two-pass retrieval directly addresses cross-section dependencies. The first pass finds the directly relevant chunks. The model then identifies references to other sections (e.g., "See Table 3.2"), triggering a targeted second retrieval. This captures the exact cross-references the model needs. Option A (parent-child) helps with adjacent context but doesn't bridge 50-page gaps. Option B (50% overlap) is extremely wasteful and still can't bridge distant sections. Option D (knowledge graph) is complex to build and maintain for document QA.

**Key Takeaway:** For documents with cross-section references, implement multi-pass retrieval — let the model identify what additional context it needs, then retrieve it in a follow-up pass.

---

### Question 36
**Correct Answer: D**

**Explanation:** A multi-level retrieval system captures different granularities of repository understanding: file-level summaries provide architectural context, function/class-level chunks provide implementation details, and dependency manifests provide version awareness. Combining all three levels gives the model a comprehensive view. Option A (single-level KB) can't simultaneously capture architecture and implementation details. Option B (fine-tuning) creates a static snapshot that's outdated as the codebase evolves. Option C (CodeWhisperer) — while relevant, it doesn't provide the level of customization described.

**Key Takeaway:** Repository-aware code generation requires multi-level indexing: architecture-level for design decisions, code-level for implementation patterns, and dependency-level for compatibility awareness.

---

### Question 37
**Correct Answer: B**

**Explanation:** A lightweight intent classifier determines which Knowledge Base(s) to query before committing to full retrieval. This reduces the typical 4 sequential KB queries to 1-2, cutting latency proportionally. A fast Bedrock model call for classification adds ~200ms but saves 6-8 seconds of unnecessary retrieval. Option A (consolidation) loses the ability to optimize retrieval per source type. Option C (parallel queries) still uses resources on all 4 KBs and requires complex orchestration. Option D (Kendra) may not support all source types equally well.

**Key Takeaway:** For multi-KB agents, add a lightweight intent classification step to route to only the relevant Knowledge Base(s) rather than querying all sources for every request.

---

### Question 38
**Correct Answer: A, C**

**Explanation:** Semantic caching (A) directly addresses the 40% near-identical queries — serving cached responses for these eliminates ~40% of model invocations. Tiered model routing (C) addresses the remaining 60% by using the cheaper Haiku for simple queries. Together: 40% from caching + cost reduction on remaining 60% from tiered routing easily achieves 50%+ savings. Option B (all Haiku) sacrifices quality for all users. Option D (prompt caching) saves on input tokens but doesn't address the 40% duplicate queries. Option E (output limit reduction) truncates responses and degrades experience.

**Key Takeaway:** Semantic caching + tiered model routing is the most powerful cost optimization combination — caching eliminates redundant calls, tiering optimizes the remaining calls.

---

### Question 39
**Correct Answer: A**

**Explanation:** The root cause is that sensitive business logic is embedded in the prompt, making it extractable. Moving business logic to a backend service (queried via action groups) ensures it never enters the prompt context, making extraction impossible regardless of attack sophistication. Option B (prompt instructions) is easily bypassed. Option C (word policies) can be circumvented by paraphrasing. Option D (encoding) — the model needs to read the prompt, so any encoding it can read, an attacker can potentially extract.

**Key Takeaway:** Never embed sensitive business logic in prompts. Move sensitive information to backend services accessed via action groups — what's not in the prompt cannot be extracted.

---

### Question 40
**Correct Answer: A**

**Explanation:** Exponential backoff with jitter is the standard pattern for handling transient throttling errors. The circuit breaker prevents cascading failures by failing fast when the service is consistently throttled. This handles the 5% error rate gracefully without architectural changes. Option B (SQS queue) changes the API from synchronous to asynchronous, which may break the user experience. Option C (client-side rate limiting) can't anticipate other users' consumption of shared quotas. Option D (multi-region) is overkill for 5% throttling.

**Key Takeaway:** For intermittent throttling (<10% of requests), implement exponential backoff with jitter and a circuit breaker. Reserve architectural changes (queuing, provisioned throughput) for persistent throttling.

---

### Question 41
**Correct Answer: D**

**Explanation:** This architecture provides complete tenant isolation: Cognito handles authentication with tier claims, separate Lambda functions per tenant ensure code-level isolation, tenant-specific Bedrock access policies enforce model tier restrictions, and isolated DynamoDB tables prevent data leakage. Per-tenant CloudWatch logging enables auditing. Option A (separate accounts) works but is over-engineered for most multi-tenant scenarios. Option B (shared middleware) has a single Lambda handling all tenants, which is a data isolation risk. Option C (separate model invocations with credentials) doesn't fully address data isolation.

**Key Takeaway:** Multi-tenant GenAI requires isolation at every layer: authentication (Cognito), routing (API Gateway), execution (per-tenant Lambdas), data (per-tenant DynamoDB), and model access (IAM policies with tier restrictions).

---

### Question 42
**Correct Answer: D**

**Explanation:** This configuration follows correct guardrail policy design: (1) Denied topics for competitor mentions — blocks unwanted subjects. (2) PII detection with ANONYMIZE on inputs (allows processing with masked data) and BLOCK on outputs (prevents PII leakage in responses). (3) Content filters for explicit content. (4) Contextual grounding with configurable threshold. Option A uses BLOCK for input PII which prevents the query from being processed at all. Option B only detects PII on inputs, missing output PII leakage. Option C prioritizes grounding over safety, which is incorrect.

**Key Takeaway:** Configure PII policies differently for inputs (ANONYMIZE to allow processing) vs. outputs (BLOCK to prevent leakage). Contextual grounding thresholds should be tunable per use case.

---

### Question 43
**Correct Answer: A**

**Explanation:** Event-driven sync (triggered by S3 changes) ensures immediate re-indexing when documents change. Monitoring the delta between S3 document count and OpenSearch vector count catches silent sync failures. Alerting on low retrieval scores for queries identifies missing content for new products. Option B (weekly re-indexing) has a 1-week latency gap. Option C (feedback-based) is reactive, not preventive. Option D (Kendra) doesn't address the core monitoring need — Kendra can also have sync issues.

**Key Takeaway:** Implement proactive monitoring for Knowledge Base health: event-driven sync for freshness, document-count comparison for completeness, and retrieval-score monitoring for coverage.

---

### Question 44
**Correct Answer: A**

**Explanation:** Prompt caching caches the 2,500 static tokens (2,000 system prompt + 500 context preamble) across all 50,000 daily requests. At 50K requests/day, caching 2,500 tokens per request saves 125M input tokens daily. This is the single highest-impact optimization. Option B (compression) saves 1,200 tokens per request but may degrade instruction quality. Option C (fewer chunks) reduces context quality. Option D (output limit) saves 200 output tokens per request, less impactful than caching 2,500 input tokens.

**Key Takeaway:** Prompt caching provides the greatest cost reduction when there are static prompt components shared across many requests. The savings scale linearly with request volume.

---

### Question 45
**Correct Answer: B**

**Explanation:** Disabling model invocation logging prevents Bedrock from storing input/output payloads. VPC endpoints with restrictive policies keep traffic private. Customer-managed KMS keys encrypt any data at rest. AWS documentation confirms Bedrock does not use customer data for training, providing auditable proof. Option A contradicts the requirement by enabling invocation logging. Option C (SageMaker) meets requirements but adds operational overhead unnecessarily. Option D (CloudTrail for API calls only) is partial — CloudTrail logs metadata but not payloads, which is correct, but it doesn't address all requirements.

**Key Takeaway:** For strict no-logging requirements, explicitly disable Bedrock model invocation logging. Use VPC endpoints + KMS + AWS data privacy documentation for a complete compliance posture.

---

### Question 46
**Correct Answer: B**

**Explanation:** An application-level circuit breaker in ElastiCache provides the fastest detection and response. Tracking error rates in a shared cache allows all Lambda instances to see the circuit state. The half-open state after 30 seconds tests recovery without flooding the service. Cached/fallback responses maintain user experience during outages. Option A (Step Functions) adds latency and complexity for what should be a fast, in-band decision. Option C (API Gateway throttling) doesn't differentiate between healthy and degraded states. Option D (Lambda concurrency + DLQ) limits concurrency but doesn't provide graceful degradation.

**Key Takeaway:** Implement circuit breakers in application code with shared state (ElastiCache) for distributed systems. The pattern: closed (normal) → open (failing, serve fallback) → half-open (testing recovery).

---

### Question 47
**Correct Answer: A**

**Explanation:** Route 53 geolocation routing ensures EU users hit eu-west-1 and US users hit us-east-1. Deploying in all four regions (two per geography) provides failover within the same geographic boundary. DynamoDB Global Tables replicate conversation context across regions within each geography. Health checks enable automatic failover. Option B (accept downtime) violates the resilience requirement. Option C (single region) violates data residency. Option D (ALB cross-region) — ALBs are regional and don't natively support cross-region failover.

**Key Takeaway:** For data residency + resilience, deploy in primary and secondary regions within each geographic boundary, use Route 53 geolocation routing for data residency, and health checks for in-geography failover.

---

### Question 48
**Correct Answer: B**

**Explanation:** This is the most comprehensive remediation: immediate containment (remove document, re-index), detection improvement (Guardrails prompt attack detection), access reduction (least-privilege for action groups), process improvement (confirmation for writes), and retroactive assessment (audit via CloudTrail). Option A misses access restriction and audit. Option C is preventive only, doesn't address the current damage. Option D halts business operations unnecessarily.

**Key Takeaway:** Prompt injection remediation must address: (1) immediate containment, (2) detection improvement, (3) access reduction (least-privilege), (4) process controls (write confirmations), and (5) retroactive damage assessment.

---

### Question 49
**Correct Answer: D**

**Explanation:** Purchasing Provisioned Throughput for business-hours peak capacity and using on-demand for off-hours combines the predictability of provisioned capacity (during the high-demand period where it's cost-effective) with the flexibility of on-demand (during low-demand periods where provisioned would be wasted). Scheduling via automation starts/stops provisioned throughput. Option A (24/7 provisioned) wastes money during off-peak. Option B (average load) leads to throttling during peaks. Option C (on-demand only) is more expensive during business hours at 100 req/min sustained.

**Key Takeaway:** For workloads with predictable peaks, purchase Provisioned Throughput sized for peak periods and supplement with on-demand during off-peak. Automate the scheduling to match the pattern.

---

### Question 50
**Correct Answer: A, C**

**Explanation:** Streaming (A) reduces *perceived* latency to first-token time (~1 second), immediately improving user experience even though total generation time remains similar. Switching to Haiku (C) reduces model inference from 8 seconds to 2-3 seconds, achieving the most significant absolute time reduction. Together: perceived wait drops from 12 seconds to ~1 second (streaming), actual completion drops to ~6 seconds. Option B saves only 1 second. Option D (token reduction) may reduce inference time but not predictably enough. Option E (pre-computation) helps for common cases but doesn't solve the general case.

**Key Takeaway:** Combine streaming (reduces perceived latency) with a faster model (reduces actual latency) for the most impactful latency improvement. Focus on the biggest bottleneck first — model inference time.

---

### Question 51
**Correct Answer: A**

**Explanation:** Under GDPR right to erasure: DynamoDB conversation logs and S3 source documents must be deleted. The Knowledge Base must be re-synced to remove embeddings derived from deleted documents. Critically, Amazon Bedrock does NOT store customer inputs/outputs and does NOT use them for model training — so no action is needed for historical model invocations. Option B misses the Knowledge Base re-sync. Option C incorrectly assumes Bedrock stores/trains on customer data. Option D — you cannot "unlearn" data from a foundation model through fine-tuning.

**Key Takeaway:** For GDPR erasure with Bedrock: delete from your own data stores (DynamoDB, S3), re-sync Knowledge Bases to remove embeddings, and understand that Bedrock's managed models don't retain customer data.

---

### Question 52
**Correct Answer: A**

**Explanation:** A BAA is necessary but not sufficient. Technical controls required for HIPAA include: encryption at rest and in transit with customer-managed KMS keys, VPC endpoints to prevent PHI from traversing the public internet, CloudTrail audit logging for accountability, model invocation logging for audit trail, and Guardrails for PHI redaction. Option B incorrectly assumes BAA alone is sufficient. Option C uses default encryption (not customer-managed) and public endpoints. Option D — HIPAA workloads can run in standard commercial regions under a BAA; GovCloud is for FedRAMP.

**Key Takeaway:** HIPAA compliance requires BAA + technical controls: customer-managed encryption, VPC endpoints, full audit logging, and PHI handling policies. A BAA alone is never sufficient.

---

### Question 53
**Correct Answer: A**

**Explanation:** Regulatory explainability for AI-assisted credit decisions requires end-to-end traceability: what data was retrieved, what context was provided to the model, and what the model produced. Logging the complete "explanation chain" from input data to recommendation enables regulators to audit the decision process. Option B (SageMaker Clarify) is for ML model feature importance, not RAG pipeline explainability. Option C (rule-based proxy) is deceptive if the AI's actual logic differs. Option D (model self-explanation) is not reliable or auditable for regulatory purposes.

**Key Takeaway:** For regulatory explainability of GenAI decisions, log the complete reasoning chain: retrieved data, relevance scores, full prompt, and model output. This provides the traceability regulators require.

---

### Question 54
**Correct Answer: D**

**Explanation:** SageMaker Model Cards + Model Registry together provide a complete governance solution. Model Cards document evaluation results, risk ratings, intended use cases, and limitations (the documentation layer). Model Registry handles versioning, model package groups per use case, and approval workflows (the operational layer). Both support Bedrock and SageMaker models. Option A (Registry alone) lacks the documentation capabilities of Model Cards. Option B (custom build) reinvents what SageMaker provides natively. Option C (Service Catalog) is designed for infrastructure templates, not model governance.

**Key Takeaway:** Use SageMaker Model Cards for governance documentation (risk, evaluation, use cases) and Model Registry for operational governance (versioning, approval workflows). Together they provide comprehensive model governance.

---

### Question 55
**Correct Answer: B**

**Explanation:** The bias emerged from production RAG data, not the model itself. The interaction history contains historical sales patterns where agents may have upsold to certain demographics more frequently. RAG surfaces these biased patterns as context, amplifying historical bias. The model simply follows the biased context. Remediation requires: auditing the Knowledge Base content, implementing retrieval fairness filters, and monitoring recommendation patterns across demographics. Option A (switch model) doesn't address the root cause in the data. Option C (system prompt) isn't the source. Option D (retrain) is irrelevant — the model wasn't retrained; it's a RAG data issue.

**Key Takeaway:** RAG systems can amplify historical biases present in the retrieval corpus. When bias emerges in production but wasn't in testing, investigate the RAG data source first — production data often contains societal biases that test data doesn't.

---

### Question 56
**Correct Answer: B**

**Explanation:** AWS GovCloud (US) is FedRAMP High authorized. Not all Bedrock models may be available in GovCloud, so the team must verify availability and use SageMaker with open-source models as a fallback. SageMaker in GovCloud is also FedRAMP High authorized. Option A — standard commercial regions may have FedRAMP Moderate but not necessarily FedRAMP High for all services. Option C (Security Hub controls) doesn't make a non-FedRAMP service compliant. Option D (Outposts) doesn't automatically provide FedRAMP authorization.

**Key Takeaway:** For FedRAMP High workloads, deploy in AWS GovCloud. Verify service availability in GovCloud and have fallback plans (e.g., SageMaker for models not available in Bedrock GovCloud).

---

### Question 57
**Correct Answer: C**

**Explanation:** The correct incident response follows: Contain → Investigate → Assess → Remediate. Revoking permissions (not deleting the account) preserves forensic evidence while stopping the attack immediately. CloudTrail analysis reveals the scope of compromise. Creating new credentials with least-privilege prevents recurrence. GuardDuty and SCPs provide additional protection. Option A (delete account) destroys forensic evidence. Option B (rotate only) doesn't investigate the damage. Option D (wait for AWS) — incident response must be immediate; you can't wait for vendor support.

**Key Takeaway:** Incident response for compromised credentials: revoke (don't delete) immediately, investigate via CloudTrail, assess impact, then remediate with least-privilege. Preserve evidence throughout.

---

### Question 58
**Correct Answer: B**

**Explanation:** A comprehensive responsible AI monitoring system requires automated evaluation (judge LLM for subjective quality), demographic analysis for fairness, integration with existing guardrails logs for safety, and executive reporting via dashboards. Sampling 5% balances thoroughness with cost. Option A (CloudWatch only) lacks the evaluation methodology. Option C (SageMaker Model Monitor) is designed for ML model drift, not GenAI interaction quality. Option D (manual log review) doesn't scale.

**Key Takeaway:** Responsible AI monitoring requires automated evaluation pipelines that measure across multiple dimensions (accuracy, fairness, safety), with executive-friendly dashboards for governance reporting.

---

### Question 59
**Correct Answer: C**

**Explanation:** Amazon QLDB provides immutable, cryptographically verifiable transaction logs — ideal for tamper-proof audit trails. Computing a hash of the document+metadata and storing it in QLDB means any tampering is cryptographically detectable. The QLDB document ID embedded in the generated document enables traceability. Option A (DynamoDB) is mutable — records can be altered. Option B (CloudTrail) logs API calls but doesn't provide document-level provenance. Option D (Managed Blockchain) is over-engineered and designed for multi-party consensus, not single-organization audit.

**Key Takeaway:** For tamper-proof AI content provenance, use Amazon QLDB for immutable audit records with cryptographic verification. Embed the QLDB reference in generated content for traceability.

---

### Question 60
**Correct Answer: A**

**Explanation:** GDPR requires that EU personal data not be transferred to third countries without adequate protection. The minimum architectural change is deploying a separate EU stack with its own data stores, ensuring EU data stays in the EU. Route 53 geolocation routing directs users based on their location. Option B (encryption alone) doesn't satisfy GDPR's data localization requirements. Option C (pseudonymization) — pseudonymized data CAN still be personal data under GDPR if re-identification is possible. Option D (SCCs) — post-Schrems II, SCCs alone may not be sufficient and require supplementary measures.

**Key Takeaway:** For GDPR compliance, deploy EU data processing in EU regions. Encryption, pseudonymization, and SCCs are supplementary measures, not substitutes for data localization when required.

---

### Question 61
**Correct Answer: C**

**Explanation:** The immediate fix (post-generation evaluation by a second model checking for discriminatory patterns) provides a safety net without halting operations. The long-term approach addresses the root cause: removing the proxy variable (neighborhood data), establishing bias audits, and adding automated fairness regression testing to CI/CD. Option A (denied topics) is too blunt — the bias is in tone, not explicit demographic references. Option B (templates) eliminates AI benefits entirely. Option D (retrain) is irrelevant since the model hasn't been retrained; it's using the base model with RAG.

**Key Takeaway:** For AI fairness issues, implement immediate output evaluation as a safety net, then address root causes: remove proxy variables, audit for disparate impact, and add fairness regression testing to CI/CD.

---

### Question 62
**Correct Answer: B**

**Explanation:** Bedrock Prompt Management provides native centralized prompt management with versioning and variants. CodePipeline approval workflows enforce governance on changes. IAM policies restricting direct InvokeModel calls (requiring prompt ARN) enforce that all teams use managed prompts. Option A (S3 + CI/CD) requires custom build of version management. Option C (npm/PyPI package) requires teams to update dependencies and doesn't enforce usage. Option D (prompt gateway) doesn't provide version management or approval workflows.

**Key Takeaway:** Use Amazon Bedrock Prompt Management for centralized prompt governance — it provides versioning, variants, and can be enforced via IAM policies. Add CI/CD approval workflows for change control.

---

### Question 63
**Correct Answer: B**

**Explanation:** A diversity-aware re-ranking step in the RAG pipeline directly addresses the filter bubble by balancing relevance with diversity metrics. The configurable diversity threshold allows business tuning without model changes. Monitoring diversity metrics ensures ongoing accountability, and A/B testing measures the impact. Option A (random injection) degrades relevance significantly. Option C (multi-armed bandit) is complementary but doesn't address the core retrieval bias. Option D (removing collaborative filtering) loses valuable personalization signals.

**Key Takeaway:** Address filter bubbles with diversity-aware re-ranking that balances relevance and diversity through configurable thresholds. Measure the impact with A/B tests tracking both engagement and diversity metrics.

---

### Question 64
**Correct Answer: B**

**Explanation:** A multi-stage pipeline with prompt regression tests, Guardrails validation, canary deployments, and model evaluation provides defense in depth against prompt-related regressions. The 200+ diverse test cases catch edge cases that unit tests miss. Canary deployment limits blast radius. Automated rollback prevents extended outages. Option A (manual review) doesn't scale and misses edge cases. Option C (manual validation) is slow and error-prone. Option D (shadow testing) is complementary but doesn't replace structured testing.

**Key Takeaway:** CI/CD for GenAI must include prompt regression testing with diverse inputs (including adversarial cases), Guardrails policy validation, canary deployment, and automated rollback based on quality metrics.

---

### Question 65
**Correct Answer: B**

**Explanation:** Systematic debugging of RAG requires tracing each pipeline stage: query embedding → retrieval → relevance scoring → prompt template → model generation. Bedrock Knowledge Base trace logging reveals where the breakdown occurs. If chunks are retrieved but the model says "I don't have information," the prompt template may be poorly instructing the model. If chunks aren't retrieved, the embedding mismatch needs addressing. Option A (more chunks) is a blind fix without diagnosis. Option C (re-chunking) changes a variable without understanding the current failure. Option D (better model) doesn't address the retrieval issue.

**Key Takeaway:** Debug RAG pipelines systematically: trace from query embedding → retrieval → scoring → prompt → generation. Identify which stage fails before applying fixes. Use trace logging to inspect each stage.

---

### Question 66
**Correct Answer: B**

**Explanation:** Custom instrumentation with feature and model dimensions provides the required cost attribution, performance tracking, and business metrics in a single framework. Feature-name dimensions enable cost tracking per feature. User feedback collection tracks satisfaction. Guardrails metrics aggregation tracks safety. A unified CloudWatch dashboard with alarms provides operational visibility. Option A (default logging) lacks feature attribution and business metrics. Option C (X-Ray) provides tracing but not cost attribution or business metrics. Option D (third-party) adds cost and dependency.

**Key Takeaway:** For comprehensive GenAI observability, implement custom instrumentation with dimensions for feature name, model ID, and user segment. This enables cost attribution, performance monitoring, and business metrics in one framework.

---

### Question 67
**Correct Answer: B**

**Explanation:** Comparing S3 document count vs. OpenSearch vector count catches silent sync failures as a simple metric. The CloudWatch alarm provides automated alerting. Logging and parsing sync job status catches errors. The dead-letter mechanism ensures failed documents are captured for retry. Option A (manual process) doesn't scale. Option C (more frequent sync) doesn't detect failures, just reduces the time between sync attempts. Option D (Kendra) changes the service rather than solving the monitoring problem.

**Key Takeaway:** Monitor Knowledge Base health by comparing source document counts against indexed vector counts. Set alarms for discrepancies and implement dead-letter handling for documents that fail to embed.

---

### Question 68
**Correct Answer: A**

**Explanation:** Amazon Bedrock model evaluation jobs with a fixed dataset provide reproducible, consistent evaluation. EventBridge scheduling ensures monthly execution. S3 storage of results enables historical comparison. QuickSight dashboards track trends over time. Lambda-based latency benchmarks complement the quality evaluation. Option B (manual review) is inconsistent and doesn't scale. Option C (SageMaker Monitor) is for ML model drift, not GenAI evaluation. Option D (A/B testing) doesn't provide consistent, controlled evaluation conditions.

**Key Takeaway:** Use Amazon Bedrock model evaluation jobs with fixed datasets for reproducible quality assessments. Schedule them regularly and track results over time to detect quality degradation trends.

---

### Question 69
**Correct Answer: B**

**Explanation:** The correct response addresses immediate, short-term, and long-term needs. Immediately: SQS absorbs the burst, cached responses serve common queries, and a secondary region handles overflow. Short-term: quota increase and Provisioned Throughput address the capacity gap. Long-term: auto-scaling architecture with circuit breakers prevents recurrence. Option A (quota increase alone) takes days to process and doesn't help immediately. Option C (switch to Haiku) may degrade quality and Haiku quotas may also be hit. Option D (Lambda/API GW scaling) doesn't address the root cause (Bedrock throttling).

**Key Takeaway:** For traffic surge incidents, implement three horizons: immediate (queue, cache, multi-region), short-term (quota increase, provisioned throughput), and long-term (auto-scaling architecture with circuit breakers and load shedding).

---

### Question 70
**Correct Answer: B**

**Explanation:** A Standard Workflow with Parallel state (for extraction), Choice state (for conditional human review based on confidence), callback Task (for human review), and Catch blocks (for per-step failure handling with progress storage for resumability) matches every requirement. Option A (Express Workflow) has a 5-minute max duration and doesn't support callbacks for human review. Option C (nested workflows) adds complexity without benefit. Option D (Map state) is for processing items in a collection, not orchestrating different pipeline stages.

**Key Takeaway:** Use Step Functions Standard Workflow for orchestrations requiring human review (callback pattern), parallel execution, conditional branching, and long execution times. Express Workflows are only for short, high-volume workloads.

---

### Question 71
**Correct Answer: B**

**Explanation:** Time-dependent quality variation with an unchanged application points to the RAG pipeline, not the model. Background sync jobs can cause temporary indexing inconsistencies. Concurrent load on OpenSearch during business hours may cause search timeouts, returning fewer chunks. The investigation approach (trace logging + comparing retrieved chunks between morning and evening) will reveal whether the model receives different context at different times. Option A (model load) — Bedrock manages capacity; model performance doesn't degrade under load. Option C (dynamic config) should be verified but is less likely without evidence. Option D (inherent randomness) doesn't explain systematic morning/evening quality differences.

**Key Takeaway:** When GenAI output quality varies by time of day with unchanged code, investigate the dynamic components: RAG retrieval (affected by indexing jobs, concurrent load), cache behavior, and external data freshness.

---

### Question 72
**Correct Answer: A**

**Explanation:** This architecture enables instant rollback of ALL components: Lambda alias switch reverts the code, stage variable change reverts the API routing, parameter store value change reverts the system prompt, and S3 prefix-based Knowledge Base versioning enables reverting the indexed content by re-syncing to the previous prefix. All switches are immediate with no deployment pipeline needed. Option B (CodeDeploy) handles Lambda but not prompts or Knowledge Bases. Option C (separate accounts) is extreme for deployment purposes. Option D acknowledges Knowledge Base limitations without solving them.

**Key Takeaway:** For full-stack GenAI blue/green deployment, version every component independently: Lambda aliases for code, parameter store for prompts, S3 prefixes for Knowledge Base data. Rollback switches all three atomically.

---

### Question 73
**Correct Answer: B**

**Explanation:** An automated pipeline with judge LLM evaluation, human review of flagged interactions, and improvement integration (few-shot examples or KB updates) creates a structured quality improvement loop. The daily automated evaluation catches issues early, human review ensures quality corrections are accurate, and the improvements feed back into the system. Option A (Athena + manual) lacks automated evaluation. Option C (Logs Insights + auto-update) is too simplistic for quality evaluation and risky to auto-modify prompts. Option D (real-time evaluation) adds latency and cost to every request.

**Key Takeaway:** Build automated quality improvement loops: daily automated evaluation with judge LLMs, human review of flagged items, and structured improvement pathways (few-shot examples, KB updates) that feed back into the system.

---

### Question 74
**Correct Answer: B**

**Explanation:** A cost tracking middleware that records feature, user tier, model, and token counts at every API call provides the exact granularity needed. DynamoDB with GSIs on feature and tier enables efficient queries. Athena on exported data generates reports. CloudWatch alarms on aggregated costs enable per-feature budget alerts. Option A (Cost Explorer) doesn't have feature-level granularity for Bedrock. Option C (CUR) provides service-level cost but not feature-level or per-request attribution. Option D (CloudWatch InvocationCount) provides count but not token-based cost attribution.

**Key Takeaway:** For granular GenAI cost attribution, implement application-level instrumentation that records feature, user segment, model, and token counts per request. AWS billing tools don't provide this level of application-specific granularity.

---

### Question 75
**Correct Answer: B**

**Explanation:** AWS Config custom rules check compliance of deployed resources automatically and continuously. SCPs at the Organizations level prevent non-approved model invocations (preventive control). A cost governance Lambda with budget tracking and alerting handles the token budget requirement. Auto-remediation via Config actions fixes non-compliant resources without manual intervention. Option A (documentation only) relies on human compliance. Option C (manual quarterly review) is too infrequent for continuous compliance. Option D (shared API Gateway) is a single point of failure and doesn't detect directly deployed resources.

**Key Takeaway:** Enforce GenAI standards at scale with preventive controls (SCPs blocking non-approved models), detective controls (AWS Config custom rules), and automated remediation. Token budgets require application-level monitoring with automated alerting.

---

## EXAM SUMMARY

| Domain | Questions | Key Themes |
|--------|-----------|------------|
| Domain 1 (Q1-Q20) | 20 | Model selection trade-offs, Bedrock vs SageMaker decisions, evaluation methodology, cost-tiered routing, deterministic architectures |
| Domain 2 (Q21-Q37) | 17 | Agent orchestration, advanced RAG patterns, multi-agent coordination, context management, MCP deployment, dynamic configuration |
| Domain 3 (Q38-Q50) | 13 | Cost optimization, security hardening, circuit breakers, cross-region resilience, Provisioned Throughput, token efficiency |
| Domain 4 (Q51-Q63) | 13 | GDPR/HIPAA compliance, bias detection, incident response, model governance, explainability, responsible AI |
| Domain 5 (Q64-Q75) | 12 | CI/CD for GenAI, monitoring architecture, debugging RAG pipelines, blue/green deployment, quality feedback loops, cost attribution |

**Scoring Guide:**
- 90%+ (68+ correct): Excellent — ready for the exam
- 80-89% (60-67 correct): Good — review missed topics
- 70-79% (53-59 correct): Fair — focused study needed on weak domains
- Below 70%: Additional preparation recommended across all domains
