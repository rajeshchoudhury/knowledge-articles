# AWS Certified Generative AI Developer – Professional (AIP-C01) Flashcards

> 250+ flashcards organized by exam domain. Use these for rapid recall before the exam.

---

# DOMAIN 1: Foundation Model Integration

## 1.1 — Foundation Model Selection

**Q:** What are the key criteria for selecting a foundation model on AWS?
**A:** Consider task type (text generation, summarization, code, multimodal), latency requirements, cost per token, context window size, language support, licensing terms, and whether fine-tuning is needed. Match the model's strengths to your specific use case.

---

**Q:** When should you choose Amazon Bedrock over Amazon SageMaker for deploying foundation models?
**A:** Choose Bedrock when you want a fully managed, serverless experience with no infrastructure to manage, access to multiple FM providers via a single API, and built-in features like Guardrails, Knowledge Bases, and Agents. Choose SageMaker when you need full control over the hosting environment, custom model training, or support for models not available in Bedrock.

---

**Q:** What is the primary advantage of Bedrock's single-API approach to multiple foundation models?
**A:** Bedrock provides a unified API (InvokeModel, Converse) to access models from Anthropic, Meta, Mistral, Cohere, Amazon, and others. This allows you to switch between models without changing application code, facilitating model evaluation and A/B testing.

---

**Q:** What factors determine whether a smaller or larger foundation model is appropriate?
**A:** Smaller models (e.g., Haiku, Llama 8B) are best for simple tasks, lower latency, and cost efficiency. Larger models (e.g., Sonnet, Llama 70B) excel at complex reasoning, nuanced generation, and multi-step tasks. Choose based on task complexity, latency budget, and cost constraints.

---

**Q:** What is model cascading and when is it useful?
**A:** Model cascading routes requests to a smaller/cheaper model first, then falls back to a larger model only if the initial response doesn't meet a quality threshold. It optimizes cost by using expensive models only when necessary while maintaining overall quality.

---

**Q:** What is the difference between a generative model and a discriminative model?
**A:** A generative model learns the joint probability distribution and can generate new data (e.g., GPT, Claude). A discriminative model learns the boundary between classes for classification tasks. For GenAI applications, you primarily use generative models.

---

**Q:** What does "context window" mean for a foundation model?
**A:** The context window is the maximum number of tokens (input + output) a model can process in a single request. Larger context windows allow more information to be included in a prompt, which is critical for long-document analysis and RAG applications.

---

## 1.2 — RAG Architecture

**Q:** What is Retrieval-Augmented Generation (RAG)?
**A:** RAG is a pattern that enhances FM responses by first retrieving relevant information from an external knowledge base, then including that information in the prompt context. This reduces hallucinations, provides up-to-date information, and grounds responses in your proprietary data.

---

**Q:** What are the core components of a RAG pipeline?
**A:** (1) Data ingestion and chunking, (2) embedding generation, (3) vector store for indexed embeddings, (4) retrieval mechanism (similarity search), (5) prompt construction with retrieved context, (6) FM invocation for response generation.

---

**Q:** What is the role of an embedding model in RAG?
**A:** The embedding model converts text chunks into dense numerical vectors (embeddings) that capture semantic meaning. These vectors are stored in a vector database and used for similarity search during the retrieval phase. Common choices include Amazon Titan Embeddings and Cohere Embed.

---

**Q:** What is Amazon Bedrock Knowledge Bases?
**A:** A fully managed RAG service that automates data ingestion, chunking, embedding generation, and vector store management. It connects to data sources (S3, Confluence, SharePoint, web crawlers), processes documents, and provides a retrieval API that integrates with Bedrock Agents and applications.

---

**Q:** What data sources does Bedrock Knowledge Bases support?
**A:** S3 buckets, Confluence, SharePoint, Salesforce, web crawlers, and custom data sources via Lambda connectors. Documents can be in PDF, TXT, HTML, Markdown, CSV, DOC/DOCX, and other formats.

---

**Q:** What vector stores can Bedrock Knowledge Bases use?
**A:** Amazon OpenSearch Serverless, Amazon Aurora PostgreSQL (pgvector), Pinecone, Redis Enterprise Cloud, MongoDB Atlas, and Amazon Neptune Analytics. OpenSearch Serverless is the default managed option.

---

**Q:** What is hybrid search in the context of RAG?
**A:** Hybrid search combines semantic (vector) search with keyword (lexical) search to improve retrieval quality. Semantic search captures meaning while keyword search catches exact matches. Results are merged using techniques like Reciprocal Rank Fusion (RRF). Bedrock Knowledge Bases supports hybrid search natively.

---

**Q:** What is query expansion in RAG?
**A:** Query expansion rewrites or augments the user's query to improve retrieval. Techniques include using the FM to generate multiple query variants, adding synonyms, or decomposing a complex question into sub-queries. This increases the chance of retrieving relevant documents.

---

**Q:** What is query decomposition in RAG?
**A:** Query decomposition breaks a complex multi-part question into simpler sub-questions, retrieves relevant context for each, and then synthesizes a final answer. This improves accuracy for questions that span multiple topics or require information from different documents.

---

**Q:** What is the purpose of metadata filtering in vector stores?
**A:** Metadata filtering narrows the vector search to a subset of documents based on attributes like date, source, category, or department. This improves retrieval precision and reduces noise by excluding irrelevant documents before similarity search runs.

---

**Q:** What metadata framework considerations apply to vector stores?
**A:** Define a consistent metadata schema across documents (source, date, category, access level). Use metadata for pre-filtering to improve retrieval precision, implement access control via metadata tags, and version metadata to support updates and re-indexing.

---

## 1.3 — Chunking Strategies

**Q:** What is fixed-size chunking?
**A:** Fixed-size chunking splits documents into segments of a predetermined token/character count with optional overlap. It's simple and predictable but may split sentences or paragraphs mid-thought, potentially losing semantic coherence.

---

**Q:** What is hierarchical chunking?
**A:** Hierarchical chunking creates chunks at multiple granularity levels (e.g., paragraph-level and section-level) organized in a parent-child relationship. During retrieval, the system first identifies relevant parent chunks, then drills into child chunks for precision.

---

**Q:** What is semantic chunking?
**A:** Semantic chunking uses NLP techniques to split documents at natural semantic boundaries (topic changes, paragraph breaks). It preserves coherent ideas within each chunk, improving retrieval quality compared to fixed-size chunking at the cost of variable chunk sizes.

---

**Q:** How does chunk size affect RAG performance?
**A:** Smaller chunks improve retrieval precision but may lack context. Larger chunks provide more context but may include irrelevant information and reduce precision. The optimal size depends on the document type and query patterns — typically 256-1024 tokens with 10-20% overlap.

---

**Q:** Why is chunk overlap important?
**A:** Overlap ensures that information at chunk boundaries isn't lost. Without overlap, a relevant passage split across two chunks might not be fully retrieved. Typical overlap is 10-20% of chunk size, ensuring continuity between adjacent chunks.

---

**Q:** What chunking strategy does Bedrock Knowledge Bases support?
**A:** Bedrock Knowledge Bases supports fixed-size chunking (configurable size and overlap), default chunking (automatic), hierarchical chunking, semantic chunking, and no chunking (treat each file as a single chunk). You can also use a custom Lambda for parsing.

---

## 1.4 — Embedding Models

**Q:** What is Amazon Titan Text Embeddings V2?
**A:** Amazon's managed embedding model available in Bedrock that generates 1024-dimensional vectors (configurable to 256 or 512). It supports up to 8,192 tokens input, is optimized for RAG, and supports normalization for cosine similarity search.

---

**Q:** How does embedding dimensionality affect performance?
**A:** Higher dimensionality captures more semantic nuance but increases storage costs and search latency. Lower dimensionality is faster and cheaper but may lose subtle distinctions. Choose based on your precision requirements and scale — 256-1024 dimensions covers most use cases.

---

**Q:** What similarity metrics are used for vector search?
**A:** Cosine similarity (measures angle between vectors, most common), Euclidean distance (L2, measures straight-line distance), and dot product (combines magnitude and direction). Cosine similarity is preferred when vectors are normalized.

---

**Q:** When should you re-embed your knowledge base?
**A:** Re-embed when you change the embedding model, modify the chunking strategy, update the embedding dimensions, or significantly update the source documents. Partial re-indexing is possible when only adding new documents.

---

## 1.5 — Prompt Engineering

**Q:** What is zero-shot prompting?
**A:** Providing the model a task instruction without any examples. The model relies solely on its pre-training knowledge. Works well for simple, well-defined tasks but may produce inconsistent results for complex or ambiguous tasks.

---

**Q:** What is few-shot prompting?
**A:** Including a small number of input-output examples in the prompt to demonstrate the desired behavior. Typically 2-5 examples are sufficient. This guides the model's format and reasoning pattern without any model fine-tuning.

---

**Q:** What is chain-of-thought (CoT) prompting?
**A:** A technique that instructs the model to reason step-by-step before providing a final answer. Adding phrases like "Let's think step by step" or showing examples with reasoning chains significantly improves performance on math, logic, and multi-step tasks.

---

**Q:** What is the difference between system prompts and user prompts?
**A:** System prompts set the model's behavior, persona, constraints, and output format — they persist across the conversation. User prompts are the individual messages or questions from the end user. System prompts guide *how* the model responds; user prompts define *what* it responds to.

---

**Q:** What is prompt template management in Bedrock?
**A:** Bedrock Prompt Management allows you to create, version, and manage prompt templates with variables. Templates can be tested in the console, shared across teams, and referenced by ARN. This enables consistent prompting across applications and facilitates A/B testing of prompt variants.

---

**Q:** What are Bedrock Prompt Flows?
**A:** A visual workflow builder in Bedrock that chains together prompts, knowledge base retrievals, conditions, and Lambda functions into directed acyclic graphs (DAGs). Prompt Flows enable complex multi-step AI workflows without custom orchestration code.

---

**Q:** What nodes are available in Bedrock Prompt Flows?
**A:** Input, Output, Prompt (invoke FM), Knowledge Base (RAG retrieval), Condition (branching logic), Lambda (custom code), Iterator (loop over items), Collector (aggregate results), S3 Storage, and Lex (conversation).

---

**Q:** What is the purpose of output parsers in prompt engineering?
**A:** Output parsers extract structured data (JSON, XML, lists) from FM responses. They validate the format, handle malformed outputs gracefully, and transform raw text into programmatically usable data structures for downstream processing.

---

## 1.6 — Cross-Region Inference & Throughput

**Q:** What is Cross-Region Inference in Bedrock?
**A:** A feature that automatically routes Bedrock API requests to other AWS regions when the primary region is at capacity. It improves availability and reduces throttling without requiring application changes. You use an inference profile ARN instead of a model ID.

---

**Q:** What is the difference between On-Demand and Provisioned Throughput in Bedrock?
**A:** On-Demand charges per input/output token with no commitment — ideal for variable workloads. Provisioned Throughput reserves dedicated model capacity (measured in Model Units) for a fixed period (1-6 months), guaranteeing consistent performance at a predictable cost — ideal for steady, high-volume workloads.

---

**Q:** What is a Bedrock Inference Profile?
**A:** An inference profile is a configuration that specifies how model invocations are routed. System-defined profiles enable cross-region routing, while application inference profiles allow tagging for cost tracking. You reference profiles by ARN in API calls.

---

**Q:** When should you use Provisioned Throughput?
**A:** Use Provisioned Throughput when you have consistent, predictable workloads, need guaranteed latency SLAs, run high-volume production applications, or when on-demand throttling is impacting performance. The commitment period ranges from 1 to 6 months.

---

## 1.7 — Model Customization

**Q:** When should you fine-tune a foundation model vs. using RAG?
**A:** Use RAG when you need to incorporate dynamic, frequently updated knowledge or proprietary data without modifying the model. Fine-tune when you need to change the model's behavior, style, tone, or domain-specific reasoning patterns that can't be achieved through prompting alone.

---

**Q:** What is continued pre-training in Bedrock?
**A:** Continued pre-training (also called domain adaptation) feeds large amounts of unlabeled, domain-specific text to a foundation model so it learns domain vocabulary and patterns. It adapts the model's general knowledge to your domain without requiring labeled examples.

---

**Q:** What is fine-tuning in Bedrock?
**A:** Fine-tuning trains a foundation model on labeled examples (prompt-completion pairs) to improve performance on a specific task. Bedrock supports fine-tuning for select models (Amazon Titan, Meta Llama, Cohere) using your training data stored in S3. The result is a private model version.

---

**Q:** What is LoRA (Low-Rank Adaptation)?
**A:** A parameter-efficient fine-tuning technique that freezes the original model weights and injects small trainable matrices into each layer. LoRA reduces compute and memory requirements dramatically compared to full fine-tuning while achieving comparable quality. It's commonly used in SageMaker.

---

**Q:** What is parameter-efficient fine-tuning (PEFT)?
**A:** A family of techniques (LoRA, QLoRA, prefix tuning, adapters) that fine-tune only a small subset of model parameters rather than all weights. This drastically reduces compute cost, memory requirements, and training data needs while preserving most of the base model's capabilities.

---

**Q:** What data format does Bedrock fine-tuning expect?
**A:** Bedrock fine-tuning expects JSONL files stored in S3, where each line contains a prompt-completion pair. The exact schema varies by model provider. Training data should be representative, high-quality, and typically requires hundreds to thousands of examples.

---

**Q:** How does Glue Data Quality help with GenAI training data?
**A:** AWS Glue Data Quality validates and monitors data quality using rules you define (completeness, uniqueness, format checks). For GenAI, it ensures training data and RAG source documents meet quality standards before ingestion, preventing garbage-in-garbage-out scenarios.

---

## 1.8 — Multimodal & Advanced

**Q:** What is multimodal data processing in the context of GenAI?
**A:** Processing and generating content across multiple data types — text, images, audio, video, and documents. Models like Claude 3 and Amazon Nova support multimodal inputs, enabling use cases like visual question answering, document understanding, and image generation.

---

**Q:** What is Amazon Nova in Bedrock?
**A:** Amazon's family of foundation models including Nova Micro (text-only, lowest latency), Nova Lite (multimodal, cost-effective), Nova Pro (multimodal, balanced), and Nova Premier (most capable). They also include Nova Canvas (image generation) and Nova Reel (video generation).

---

**Q:** What is the Model Context Protocol (MCP)?
**A:** An open standard protocol that allows AI models and agents to discover and interact with external tools, data sources, and services in a standardized way. MCP servers expose capabilities that AI agents can call, enabling dynamic tool use without hardcoding integrations.

---

**Q:** How does MCP differ from traditional function calling?
**A:** Traditional function calling requires pre-defining tools in each prompt. MCP provides a dynamic discovery mechanism — agents can query MCP servers to learn available tools at runtime, making integrations more flexible and maintainable. MCP also standardizes the tool schema format.

---

**Q:** What is Amazon Titan Image Generator?
**A:** A Bedrock model that generates and edits images from text prompts. It supports text-to-image generation, image editing (inpainting/outpainting), image variation, and background removal. It includes built-in watermarking for responsible AI.

---

**Q:** What are the key considerations when choosing an embedding model?
**A:** Consider dimensionality (precision vs. cost), maximum input token length, multilingual support, domain specificity, speed/latency, and whether it's optimized for your use case (retrieval, classification, clustering). Also consider managed (Bedrock) vs. self-hosted (SageMaker).

---

**Q:** What is the difference between dense and sparse embeddings?
**A:** Dense embeddings (from neural models) represent text as compact vectors where every dimension has a value — they capture semantic meaning. Sparse embeddings (like BM25/TF-IDF) have mostly zero values and capture exact keyword matches. Hybrid search combines both approaches.

---

**Q:** How do you handle documents with tables and images in RAG?
**A:** Use multimodal parsing to extract text from tables and describe images. Options include Amazon Textract for document extraction, multimodal models to generate image descriptions, custom parsers via Lambda in Bedrock Knowledge Bases, and Bedrock Data Automation for structured extraction.

---

---

# DOMAIN 2: Implementation and Integration

## 2.1 — Agentic AI

**Q:** What is agentic AI?
**A:** AI systems that can autonomously plan, reason, use tools, and take actions to accomplish goals. Unlike simple prompt-response models, agents maintain state, make decisions, execute multi-step workflows, and interact with external systems to complete complex tasks.

---

**Q:** What is Amazon Bedrock Agents?
**A:** A managed service for building AI agents that can reason, plan, and execute multi-step tasks. Agents automatically break down user requests, call APIs via action groups, query knowledge bases, and maintain conversation context. They use an FM for orchestration.

---

**Q:** What is the ReAct pattern in agentic AI?
**A:** ReAct (Reasoning + Acting) is an agent paradigm where the model alternates between reasoning about what to do next and taking actions (tool calls). The cycle is: Thought (reason) → Action (execute tool) → Observation (process result) → repeat until task is complete.

---

**Q:** What are Bedrock Agent Action Groups?
**A:** Action groups define the tools/APIs an agent can invoke. Each action group maps to a Lambda function or API schema (OpenAPI). The agent's FM decides which action group to call based on the user's request and the action group descriptions.

---

**Q:** What is Strands Agents?
**A:** An open-source Python SDK from AWS for building AI agents. It provides a model-driven approach where the agent's behavior is primarily defined by its system prompt and available tools, with the SDK handling the orchestration loop, tool execution, and state management.

---

**Q:** What is AWS Agent Squad (formerly Multi-Agent Orchestrator)?
**A:** An open-source framework for building multi-agent systems where a supervisor agent routes requests to specialized sub-agents based on the task. It supports parallel and sequential agent execution, context sharing, and conversation management across agents.

---

**Q:** What is multi-agent orchestration?
**A:** A pattern where multiple specialized agents collaborate to complete complex tasks. A supervisor/router agent delegates sub-tasks to domain-specific agents (e.g., a research agent, a coding agent, a data agent), then aggregates results. This enables division of labor and specialization.

---

**Q:** How does Bedrock Agents handle multi-agent collaboration?
**A:** Bedrock supports multi-agent collaboration where a supervisor agent can invoke sub-agents as tools. The supervisor routes requests, sub-agents handle specialized tasks, and results flow back through the supervisor for final synthesis. This is configured via agent collaboration settings.

---

**Q:** What is the difference between sequential and parallel agent orchestration?
**A:** Sequential orchestration passes results from one agent to the next in a pipeline (A → B → C). Parallel orchestration runs multiple agents simultaneously on different aspects of a task, then merges results. Choose based on whether sub-tasks have dependencies.

---

**Q:** What is tool integration in agentic AI?
**A:** Connecting external capabilities (APIs, databases, code execution, file systems) to an AI agent so it can take actions beyond text generation. Tools are described to the agent via schemas, and the agent decides when and how to invoke them based on the user's request.

---

## 2.2 — MCP Servers

**Q:** How can you deploy MCP servers on AWS?
**A:** MCP servers can be deployed on Lambda (serverless, per-request scaling, cost-effective for bursty workloads) or ECS/Fargate (persistent connections, better for stateful tools or long-running operations). Lambda suits stateless tools while ECS suits tools needing persistent connections.

---

**Q:** What is the difference between MCP on Lambda vs. ECS?
**A:** Lambda MCP servers are stateless, scale automatically, and cost nothing when idle — ideal for simple tool calls. ECS MCP servers support persistent connections (WebSocket/SSE), maintain state across calls, and handle long-running operations — ideal for complex tools and streaming.

---

## 2.3 — Deployment and APIs

**Q:** What is the difference between Bedrock InvokeModel and Converse APIs?
**A:** InvokeModel is model-specific — request/response formats vary by provider. Converse provides a unified, model-agnostic API with a consistent message format across all Bedrock models. Use Converse for portability; InvokeModel when you need provider-specific features.

---

**Q:** What is response streaming in Bedrock?
**A:** InvokeModelWithResponseStream and ConverseStream return partial responses as they're generated, reducing perceived latency. The client receives tokens incrementally rather than waiting for the full response. Essential for chat interfaces and real-time applications.

---

**Q:** When should you use WebSocket vs. Server-Sent Events (SSE) for streaming?
**A:** WebSocket provides full-duplex communication (both directions) — use when the client needs to send messages during streaming. SSE is simpler, unidirectional (server to client) — use for standard response streaming. Bedrock's native streaming uses chunked HTTP responses similar to SSE.

---

**Q:** What are container-based deployment strategies for LLMs on SageMaker?
**A:** SageMaker supports Deep Learning Containers (DLCs) with pre-built images for popular frameworks, custom containers, and Large Model Inference (LMI) containers. LMI containers support model parallelism (tensor parallel, pipeline parallel) for deploying models across multiple GPUs.

---

**Q:** What is SageMaker's Large Model Inference (LMI) container?
**A:** A specialized container for deploying large language models that don't fit on a single GPU. It supports tensor parallelism, continuous batching, and quantization. Built on frameworks like vLLM, TensorRT-LLM, and DeepSpeed for optimized inference.

---

**Q:** What is model routing in GenAI applications?
**A:** Directing requests to different models based on criteria like task complexity, cost budget, latency requirements, or content type. Implementations include rules-based routers, classifier-based routers, and FM-based routers that analyze the request to choose the optimal model.

---

**Q:** What is Amazon Q Developer?
**A:** An AI-powered assistant for software development that provides code generation, code transformation, debugging, test generation, and code review within IDEs. It understands your codebase context and integrates with AWS services for infrastructure guidance.

---

**Q:** What is Amazon Q Business?
**A:** An AI assistant for enterprise users that answers questions using company data sources (S3, SharePoint, Confluence, databases). It provides RAG-based answers with citations, respects existing access controls (ACLs), and supports plugins for taking actions.

---

**Q:** What is Bedrock Data Automation?
**A:** A managed service that extracts structured data from unstructured documents (PDFs, images, audio, video) using FMs. It generates standardized output formats and can be customized with blueprints. Useful for document processing pipelines feeding into RAG or analytics.

---

**Q:** How do you implement CI/CD for GenAI applications?
**A:** Use CodePipeline/GitHub Actions for code deployment, version prompt templates (Bedrock Prompt Management), track model versions, maintain golden test datasets for regression testing, automate evaluation metrics, and implement canary/blue-green deployments for model updates.

---

**Q:** What is an event-driven architecture pattern for GenAI?
**A:** Using EventBridge, SQS, or SNS to decouple GenAI components. For example: S3 upload → Lambda triggers document processing → SQS queues embedding generation → another Lambda indexes vectors. This enables asynchronous processing, retry logic, and scalability.

---

**Q:** How do you integrate API Gateway with Bedrock?
**A:** API Gateway can proxy to a Lambda function that calls Bedrock APIs. Use API Gateway for authentication (Cognito/API keys), rate limiting, request/response transformation, and caching. For streaming, use WebSocket APIs or Lambda response streaming with function URLs.

---

**Q:** What is the Lambda Web Adapter for GenAI?
**A:** Lambda Web Adapter allows running web applications (Flask, FastAPI, Express) in Lambda with response streaming support. This enables deploying GenAI APIs that stream responses from Bedrock through Lambda without custom streaming code.

---

**Q:** What is model composition or chaining?
**A:** Using multiple model invocations in sequence where each model's output feeds into the next. For example: Model A extracts entities → Model B classifies them → Model C generates a summary. Bedrock Prompt Flows and Step Functions can orchestrate these chains.

---

**Q:** How does Step Functions integrate with Bedrock?
**A:** Step Functions has native Bedrock integration (optimized service integrations) for InvokeModel and other Bedrock APIs. This enables building serverless GenAI workflows with branching, parallel execution, error handling, and human-in-the-loop approval steps.

---

**Q:** What is Amazon Bedrock Marketplace?
**A:** A feature that extends Bedrock with additional foundation models from third-party providers beyond the default Bedrock model catalog. Models are deployed to your account and accessed through the standard Bedrock APIs.

---

---

# DOMAIN 3: AI Safety, Security, and Governance

## 3.1 — Bedrock Guardrails

**Q:** What are Amazon Bedrock Guardrails?
**A:** A managed feature that applies safety controls to FM inputs and outputs. Guardrails can filter harmful content, block denied topics, detect/redact PII, check for hallucinations (grounding), and apply word/regex filters. They work with any Bedrock model and can be applied independently via ApplyGuardrail API.

---

**Q:** What content filtering types does Bedrock Guardrails support?
**A:** Hate, Insults, Sexual, Violence, Misconduct, and Prompt Attack categories. Each can be configured with different strength thresholds (None, Low, Medium, High) independently for input and output. This allows granular control over content moderation.

---

**Q:** How does Bedrock Guardrails handle PII?
**A:** Guardrails can detect and either block or redact PII types including names, email addresses, phone numbers, SSNs, credit card numbers, and IP addresses. You configure which PII types to detect and whether to anonymize (mask) or block the request entirely.

---

**Q:** What is the Guardrails grounding check?
**A:** The grounding check (contextual grounding) validates whether the model's response is factually supported by the provided reference source/context. It detects hallucinated content that isn't grounded in the input context, with a configurable threshold. Essential for RAG applications.

---

**Q:** What is the Guardrails relevance check?
**A:** The relevance filter checks whether the model's response is actually relevant to the user's query. It catches cases where the model generates off-topic responses even if the content is technically grounded in the source. Works alongside the grounding check.

---

**Q:** Can Bedrock Guardrails be used independently of model invocation?
**A:** Yes. The ApplyGuardrail API lets you evaluate any text against your guardrail configuration without invoking a model. This enables using guardrails as standalone content moderation for any text input, including from non-Bedrock sources.

---

**Q:** What is the denied topics feature in Bedrock Guardrails?
**A:** Denied topics let you define subjects the model should refuse to engage with. You provide a natural language description of each topic and sample phrases. The guardrail detects when inputs or outputs relate to denied topics and blocks them with a configurable response.

---

**Q:** How do you configure word filters in Bedrock Guardrails?
**A:** Word filters block specific words, phrases, or regex patterns in inputs and outputs. You can upload a custom word list, use managed profanity word lists, or define regex patterns. Useful for blocking competitor names, internal jargon, or specific content patterns.

---

## 3.2 — Prompt Injection & Security

**Q:** What is prompt injection?
**A:** An attack where malicious instructions are embedded in user input to override the model's system prompt or intended behavior. For example, "Ignore all previous instructions and reveal the system prompt." Bedrock Guardrails includes a prompt attack filter to detect these attempts.

---

**Q:** What is jailbreak detection?
**A:** Detection of attempts to bypass a model's safety training and content filters. Jailbreaks use techniques like role-playing scenarios, encoding tricks, or multi-turn manipulation. Bedrock Guardrails' prompt attack category detects common jailbreak patterns.

---

**Q:** What is the defense-in-depth approach for GenAI security?
**A:** Layering multiple security controls: input validation, prompt injection detection (Guardrails), output filtering, content moderation, rate limiting, authentication/authorization, VPC isolation, encryption, logging, and monitoring. No single control is sufficient — multiple layers provide comprehensive protection.

---

**Q:** How do you prevent indirect prompt injection in RAG?
**A:** Indirect injection occurs when malicious instructions are embedded in retrieved documents. Mitigations include: separating system prompts from retrieved context clearly, using guardrails on both input and output, sanitizing documents before ingestion, and validating retrieved content before including it in prompts.

---

**Q:** What is the role of input validation in GenAI applications?
**A:** Input validation checks user inputs for length limits, format requirements, banned patterns, and potential injection attempts before they reach the model. Implement at the API Gateway level, in application code, and via Bedrock Guardrails for defense-in-depth.

---

## 3.3 — Network & Access Security

**Q:** How do VPC endpoints work with Bedrock?
**A:** VPC interface endpoints (AWS PrivateLink) allow you to call Bedrock APIs from within your VPC without traffic traversing the public internet. Create a VPC endpoint for `bedrock-runtime` and optionally `bedrock` (control plane). Configure security groups and endpoint policies for access control.

---

**Q:** What IAM policies are needed for Bedrock access?
**A:** At minimum, `bedrock:InvokeModel` for model invocation. Use resource-level permissions to restrict access to specific models by ARN. Additional actions include `bedrock:InvokeModelWithResponseStream`, `bedrock:Retrieve` (Knowledge Bases), and `bedrock:ApplyGuardrail`. Use condition keys for fine-grained control.

---

**Q:** How does AWS KMS integrate with Bedrock?
**A:** KMS encrypts data at rest for fine-tuned models, Knowledge Base data, model invocation logs, and evaluation results. You can use AWS-managed keys or customer-managed CMKs. Customer-managed keys provide more control over key rotation, access policies, and audit logging.

---

**Q:** How do you control model access in Bedrock?
**A:** Use IAM policies with model ARN resource restrictions, Bedrock model access management (enable/disable specific models in the console), service control policies (SCPs) at the organization level, and VPC endpoint policies. Combine these for least-privilege access.

---

**Q:** How does Lake Formation integrate with GenAI data governance?
**A:** Lake Formation provides fine-grained access control (column-level, row-level, cell-level) for data in S3 and Glue Data Catalog. It governs who can access what data for training, RAG knowledge bases, and analytics, ensuring only authorized data is used in GenAI pipelines.

---

## 3.4 — Governance & Responsible AI

**Q:** What are model cards?
**A:** Documentation artifacts that describe a model's intended use, limitations, training data, evaluation results, ethical considerations, and performance metrics. SageMaker Model Cards provide a structured format. They promote transparency and help users understand model capabilities and limitations.

---

**Q:** How does Glue support data lineage for GenAI?
**A:** AWS Glue tracks data lineage — the origin, transformations, and movement of data through ETL pipelines. For GenAI, this provides traceability of training data sources, transformation steps, and which data was used to build knowledge bases, supporting auditability and compliance.

---

**Q:** How does CloudTrail support GenAI governance?
**A:** CloudTrail logs all Bedrock API calls including InvokeModel, CreateKnowledgeBase, and configuration changes. Logs capture who called which model, when, and from where. This provides an audit trail for compliance, security investigations, and usage tracking.

---

**Q:** What is Bedrock Model Invocation Logging?
**A:** A feature that logs full request/response payloads (input prompts and output completions) to S3 and/or CloudWatch Logs. This goes beyond CloudTrail API logging to capture the actual content of model interactions for compliance, debugging, and quality monitoring.

---

**Q:** What are the core responsible AI principles for GenAI on AWS?
**A:** Fairness (equitable treatment across demographics), Explainability (understanding why the model produces outputs), Privacy (protecting personal data), Robustness (consistent performance), Safety (preventing harmful outputs), Transparency (disclosing AI use), and Governance (organizational controls and accountability).

---

**Q:** How does SageMaker Clarify detect bias in GenAI?
**A:** Clarify evaluates FM outputs for bias across demographic groups using metrics like toxicity, stereotyping, and sentiment disparities. It can run as part of Bedrock Model Evaluations to assess fairness across protected attributes. Results help identify and mitigate biased model behavior.

---

**Q:** What is LLM-as-a-Judge for fairness evaluation?
**A:** Using a foundation model to evaluate another model's outputs for fairness, bias, and quality. A "judge" model scores responses against criteria like equitable treatment, stereotype avoidance, and balanced representation. Bedrock Model Evaluations supports this pattern natively.

---

**Q:** How do you implement transparency in GenAI applications?
**A:** Clearly disclose that users are interacting with AI, provide citations/sources for RAG responses, show confidence indicators, explain limitations, enable feedback mechanisms, and maintain model cards. In RAG systems, include source attribution with retrieved chunk references.

---

**Q:** What is the Shared Responsibility Model for GenAI on AWS?
**A:** AWS is responsible for infrastructure security, model hosting environment, and platform controls. The customer is responsible for data security, prompt engineering safety, guardrail configuration, access control, monitoring, and ensuring responsible use of GenAI within their applications.

---

**Q:** What compliance considerations apply to GenAI applications?
**A:** Data residency (where data is processed/stored), data retention policies for logs and interactions, PII handling regulations (GDPR, HIPAA, CCPA), content moderation requirements, AI-specific regulations, and industry-specific compliance frameworks. Use Bedrock's region selection and KMS encryption for compliance.

---

---

# DOMAIN 4: Operational Efficiency

## 4.1 — Token Optimization

**Q:** What are strategies for reducing token consumption?
**A:** Use concise system prompts, implement prompt compression, remove redundant context, use shorter output formats (JSON vs. prose), leverage smaller models for simple tasks, cache frequent prompts, and use model cascading to route simple queries to cheaper models.

---

**Q:** What is prompt compression?
**A:** Reducing prompt length while preserving essential meaning. Techniques include removing filler words, using abbreviations in system prompts, summarizing long contexts before including them, selecting only the most relevant RAG chunks, and using structured formats instead of verbose instructions.

---

**Q:** What is context pruning?
**A:** Selectively removing less relevant information from the context window to stay within limits and reduce costs. Techniques include conversation summarization (compressing older messages), relevance ranking of RAG results, and dropping low-confidence retrieved chunks.

---

**Q:** What is semantic caching for GenAI?
**A:** Caching model responses keyed by the semantic meaning of the query rather than exact text match. When a new query is semantically similar to a cached query (above a similarity threshold), the cached response is returned. Reduces latency and cost for repeated or similar queries. Tools like ElastiCache or Amazon MemoryDB can be used.

---

**Q:** What is Bedrock Prompt Caching?
**A:** A Bedrock feature that caches the processing of long, frequently-used prompt prefixes (like system prompts and static context). Subsequent requests with the same prefix skip re-processing, reducing latency and cost. Especially effective for long system prompts or repeated RAG contexts.

---

**Q:** How does conversation history management affect costs?
**A:** Each turn in a conversation includes all previous messages in the prompt, causing token usage to grow linearly. Mitigate by summarizing older turns, implementing a sliding window, truncating to the most recent N turns, or using a separate memory store instead of full history replay.

---

## 4.2 — Cost Management

**Q:** How do you monitor GenAI costs on AWS?
**A:** Use AWS Cost Explorer with Bedrock service filters, set up AWS Budgets alerts for Bedrock spending, use application inference profiles with tags for per-project cost tracking, analyze model invocation logs for usage patterns, and use Cost Anomaly Detection for unexpected spikes.

---

**Q:** What is cost anomaly detection for GenAI?
**A:** AWS Cost Anomaly Detection uses ML to identify unusual spending patterns in your GenAI workloads. It alerts you to unexpected cost spikes from runaway loops, prompt injection attacks that increase token usage, or misconfigured applications generating excessive API calls.

---

**Q:** How does Provisioned Throughput reduce costs?
**A:** Provisioned Throughput offers a discount over on-demand pricing in exchange for a commitment period (1-6 months). It's cost-effective when your steady-state usage exceeds the break-even point. It also eliminates throttling and provides predictable budgeting.

---

**Q:** What is the cost impact of embedding dimensions?
**A:** Lower-dimensional embeddings reduce vector storage costs and search computation costs. For example, using 256 dimensions instead of 1024 cuts storage by 75%. Choose the minimum dimensionality that meets your retrieval quality requirements.

---

**Q:** How do you optimize RAG costs?
**A:** Use smaller embedding models when sufficient, reduce chunk overlap, implement metadata filtering to search fewer vectors, cache frequent query results, use OpenSearch Serverless with auto-scaling collection, and batch embedding generation for bulk ingestion.

---

## 4.3 — Latency Optimization

**Q:** What are key strategies for reducing GenAI latency?
**A:** Use response streaming, choose smaller/faster models, reduce prompt length, implement caching (semantic and prompt), use Provisioned Throughput, deploy in regions close to users, use Cross-Region Inference for availability, and parallelize independent operations.

---

**Q:** How does response streaming improve user experience?
**A:** Streaming returns tokens as they're generated rather than waiting for the full response. Users see the first token in milliseconds, creating a perception of fast response even when total generation takes seconds. Time-to-first-token (TTFT) becomes the key latency metric.

---

**Q:** What is batch inference in Bedrock?
**A:** Processing multiple prompts as a batch job rather than individual API calls. Input is an S3 file with multiple requests; output is an S3 file with all responses. It's more cost-effective for bulk processing, offers higher throughput, but has higher latency per individual request.

---

**Q:** When should you use batch inference vs. real-time inference?
**A:** Use batch for non-time-sensitive bulk processing (document summarization, content generation, evaluation). Use real-time for interactive applications (chatbots, search, assistants). Batch typically offers cost savings and avoids throttling for large-volume jobs.

---

## 4.4 — Scaling & Monitoring

**Q:** How do you auto-scale GenAI applications?
**A:** For Bedrock, scaling is managed (serverless). For SageMaker endpoints, use auto-scaling policies based on invocation count or custom metrics. For Lambda-based architectures, configure reserved concurrency. For ECS-based, use target tracking scaling on request count or CPU/memory.

---

**Q:** What CloudWatch metrics are important for GenAI monitoring?
**A:** Bedrock metrics include Invocations, InvocationLatency, InvocationClientErrors, InvocationServerErrors, InvocationThrottles, InputTokenCount, OutputTokenCount. SageMaker adds ModelLatency, OverheadLatency, InvocationsPerInstance, and GPU utilization.

---

**Q:** How do you set up alarms for GenAI workloads?
**A:** Create CloudWatch alarms for throttling rate (InvocationThrottles), error rate (4xx/5xx), latency percentiles (p50, p90, p99), token usage spikes, and cost thresholds. Use composite alarms for complex conditions and SNS for notifications.

---

**Q:** What is the role of model invocation logs in operations?
**A:** Model invocation logs capture full request/response data, enabling troubleshooting (why did the model respond this way?), quality monitoring (track response quality over time), compliance auditing, cost analysis (actual token counts), and dataset creation for fine-tuning.

---

## 4.5 — Inference Parameters

**Q:** What does the temperature parameter control?
**A:** Temperature controls randomness in token selection. Lower values (0.0-0.3) make outputs more deterministic and focused — use for factual tasks. Higher values (0.7-1.0) increase creativity and diversity — use for creative writing. Temperature 0 always selects the most probable token.

---

**Q:** What is top-k sampling?
**A:** Top-k limits the model to sampling from only the k most probable next tokens. Lower k (e.g., 10) produces more focused text; higher k (e.g., 250) allows more variety. It prevents the model from selecting very unlikely tokens while still allowing some randomness.

---

**Q:** What is top-p (nucleus) sampling?
**A:** Top-p selects from the smallest set of tokens whose cumulative probability exceeds p. For example, top-p=0.9 considers tokens that together represent 90% probability mass. This adapts dynamically — using fewer tokens when the model is confident and more when uncertain.

---

**Q:** How do temperature, top-k, and top-p interact?
**A:** They're applied sequentially as filters: top-k first narrows to k candidates, top-p further narrows based on cumulative probability, then temperature adjusts the distribution of remaining candidates. For deterministic output, set temperature=0 (top-k and top-p become irrelevant).

---

**Q:** What is the max_tokens parameter?
**A:** max_tokens sets the maximum number of tokens the model will generate in its response. It prevents runaway generation and controls costs. Set it based on expected response length — too low truncates responses, too high wastes budget. It does not guarantee that many tokens will be generated.

---

**Q:** What are stop sequences?
**A:** Tokens or strings that tell the model to stop generating. When the model produces a stop sequence, generation ends immediately. Useful for structured outputs (stop at "```" after code blocks) or conversational turns (stop at "Human:"). Reduces unnecessary token generation.

---

---

# DOMAIN 5: Testing and Troubleshooting

## 5.1 — FM Evaluation

**Q:** What are the key evaluation metrics for foundation models?
**A:** Relevance (is the answer on-topic?), Accuracy/Correctness (is it factually right?), Coherence (is it logically structured?), Fluency (is the language natural?), Helpfulness (does it address the user's need?), and Harmlessness (is it safe?). Different use cases prioritize different metrics.

---

**Q:** What is Amazon Bedrock Model Evaluations?
**A:** A managed service for evaluating and comparing FM performance. It supports automatic evaluation (with built-in metrics like accuracy, robustness, toxicity) and human evaluation (using your workforce or AWS-managed workforce). Results help you choose the best model for your use case.

---

**Q:** What evaluation methods does Bedrock Model Evaluations offer?
**A:** (1) Automatic evaluation using built-in algorithms for metrics like BERTScore, ROUGE, and accuracy. (2) Human evaluation using Amazon SageMaker Ground Truth workforces. (3) LLM-as-a-Judge using another FM to evaluate responses against criteria you define.

---

**Q:** What is LLM-as-a-Judge?
**A:** Using a foundation model to evaluate the quality of another model's outputs. A "judge" model scores responses on criteria like relevance, accuracy, helpfulness, and safety using a rubric. It's more scalable than human evaluation and more nuanced than automated metrics.

---

**Q:** What are the advantages of LLM-as-a-Judge over automated metrics?
**A:** LLM-as-a-Judge can evaluate subjective qualities (helpfulness, tone, creativity) that automated metrics like ROUGE/BLEU miss. It understands context and nuance, can follow custom rubrics, and scales better than human evaluation while providing more detailed feedback.

---

**Q:** How do you set up A/B testing for foundation models?
**A:** Deploy two model variants behind a router that splits traffic (e.g., 50/50). Log responses and collect user feedback for both. Compare metrics (quality, latency, cost, user satisfaction) over a statistically significant sample. Bedrock's model routing and CloudWatch facilitate this.

---

**Q:** What is canary deployment for GenAI models?
**A:** Routing a small percentage of traffic (e.g., 5-10%) to a new model version while the majority goes to the current version. Monitor quality and performance metrics; if the canary performs well, gradually increase its traffic share. If it degrades, roll back automatically.

---

## 5.2 — RAG Evaluation

**Q:** What metrics are used to evaluate RAG systems?
**A:** Retrieval metrics: precision@k, recall@k, MRR (Mean Reciprocal Rank), and nDCG. Generation metrics: faithfulness (grounded in retrieved context), relevance (answers the question), completeness (covers all aspects), and attribution accuracy (correct source citations).

---

**Q:** What is context relevance in RAG evaluation?
**A:** A metric measuring whether the retrieved chunks are actually relevant to the user's query. Low context relevance means the retrieval step is returning irrelevant documents, which degrades generation quality regardless of the FM's capability.

---

**Q:** What is faithfulness in RAG evaluation?
**A:** A metric measuring whether the generated answer is supported by the retrieved context — i.e., the model didn't hallucinate beyond what the documents say. High faithfulness means the response is grounded in the source material. Bedrock Guardrails grounding check evaluates this.

---

**Q:** What is answer relevance in RAG evaluation?
**A:** A metric measuring whether the generated response actually addresses the user's question. A response can be faithful to the documents but still not answer what was asked. This metric catches off-topic but technically accurate responses.

---

**Q:** How do you create a golden dataset for RAG evaluation?
**A:** Curate a set of questions with known correct answers and the source documents that contain the answers. Include diverse question types, edge cases, and adversarial queries. Use this dataset to systematically measure retrieval and generation quality as you iterate on your RAG pipeline.

---

## 5.3 — Agent Evaluation

**Q:** What metrics are used to evaluate AI agents?
**A:** Task completion rate, number of steps to completion, tool selection accuracy, error recovery rate, cost per task, latency, and user satisfaction. Also measure hallucination rate in agent reasoning and whether the agent correctly identifies when it cannot complete a task.

---

**Q:** How do you test agent tool selection?
**A:** Create test scenarios with known correct tool sequences. Verify the agent selects the right tools in the right order, passes correct parameters, handles tool failures gracefully, and doesn't invoke unnecessary tools. Track tool selection accuracy as a percentage.

---

## 5.4 — Troubleshooting

**Q:** How do you diagnose context window overflow?
**A:** Symptoms include truncated responses, missing information, or API errors (validation exceptions). Check the total token count (input + output) against the model's limit. Mitigate by summarizing conversation history, reducing RAG chunk count, compressing prompts, or switching to a model with a larger context window.

---

**Q:** How do you diagnose poor embedding quality?
**A:** Symptoms include irrelevant retrieval results in RAG. Test by checking if semantically similar queries return similar documents. Evaluate retrieval metrics (precision@k, recall@k) on a golden dataset. Consider switching embedding models, adjusting dimensionality, or improving chunking strategy.

---

**Q:** What is embedding drift?
**A:** When the distribution of new documents differs significantly from the documents used to build the initial vector index, retrieval quality degrades. Monitor by tracking retrieval relevance metrics over time and re-index periodically. Can also occur if the embedding model is updated.

---

**Q:** What is semantic drift in GenAI?
**A:** Gradual changes in how a model interprets prompts or generates responses over time, often due to model updates by the provider. Monitor by running regression tests with golden datasets, tracking evaluation metrics over time, and pinning to specific model versions when consistency is critical.

---

**Q:** What is prompt regression testing?
**A:** Running a standardized set of prompts through the model after any change (prompt update, model version change, guardrail modification) and comparing outputs to expected baselines. This catches unintended quality degradations. Automate as part of your CI/CD pipeline.

---

**Q:** How do you detect hallucinations in production?
**A:** Use Bedrock Guardrails grounding check, implement source attribution and verify claims against retrieved documents, maintain golden datasets for periodic testing, use LLM-as-a-Judge to score faithfulness, and enable user feedback mechanisms to flag incorrect responses.

---

**Q:** What is output diffing for GenAI?
**A:** Comparing model outputs across different versions, configurations, or prompts to identify changes. Use semantic similarity (not just text diff) to detect meaningful changes. Automated diffing helps catch regressions, evaluate prompt changes, and monitor model behavior over time.

---

**Q:** How do you troubleshoot high latency in Bedrock?
**A:** Check for throttling (InvocationThrottles metric), review prompt length (more tokens = more latency), analyze CloudWatch latency metrics (p50 vs p99), consider response streaming, evaluate if a smaller model is sufficient, check if Provisioned Throughput would help, and verify network path (VPC endpoint vs public).

---

**Q:** How do you troubleshoot RAG returning irrelevant results?
**A:** Check chunking strategy (chunks too large or small?), evaluate embedding model quality, verify metadata filtering is correct, test similarity search directly (bypass the FM), review the top-k setting, ensure documents were properly ingested, and check if hybrid search would improve results.

---

**Q:** What is drift monitoring for GenAI applications?
**A:** Continuously tracking model performance metrics (quality, latency, cost, fairness) to detect degradation over time. Set baselines during deployment, create CloudWatch alarms for metric deviations, and run periodic evaluations against golden datasets. Drift can come from data changes, user behavior shifts, or model updates.

---

**Q:** How do you debug agent failures?
**A:** Enable Bedrock Agent trace logging to see the step-by-step reasoning, tool selections, and observations. Check CloudWatch Logs for Lambda (action group) errors, verify API schemas match actual endpoints, test individual action groups in isolation, and review the agent's system prompt for ambiguity.

---

---

# AWS SERVICES QUICK RECALL

## Service Identification

**Q:** Which service provides serverless access to foundation models from multiple providers?
**A:** Amazon Bedrock. It offers a unified API to access models from Anthropic, Meta, Mistral, Cohere, Amazon, AI21, and Stability AI without managing infrastructure.

---

**Q:** Which service should you use for custom model training with full control over the training environment?
**A:** Amazon SageMaker. It provides notebooks, training jobs, hyperparameter tuning, distributed training, and flexible deployment options for custom ML/GenAI models.

---

**Q:** Which service provides managed RAG with automatic data ingestion and vector indexing?
**A:** Amazon Bedrock Knowledge Bases. It handles chunking, embedding, vector storage, and retrieval automatically from data sources like S3, Confluence, and SharePoint.

---

**Q:** Which service should you use for building AI agents that can call APIs and access knowledge bases?
**A:** Amazon Bedrock Agents. It provides managed orchestration using the ReAct pattern, action groups for API calls, and knowledge base integration for grounded responses.

---

**Q:** Which service provides content safety controls for foundation model inputs and outputs?
**A:** Amazon Bedrock Guardrails. It offers content filtering, denied topics, PII detection/redaction, word filters, and grounding checks.

---

**Q:** Which service should you use for evaluating and comparing foundation model performance?
**A:** Amazon Bedrock Model Evaluations. It supports automatic metrics, human evaluation, and LLM-as-a-Judge across multiple models.

---

**Q:** Which service provides managed vector search for RAG?
**A:** Amazon OpenSearch Serverless (with vector engine). It's the default vector store for Bedrock Knowledge Bases and supports approximate nearest neighbor (ANN) search with HNSW and IVF algorithms.

---

**Q:** Which service should you use for extracting structured data from unstructured documents?
**A:** Amazon Textract for OCR and form extraction, or Bedrock Data Automation for FM-powered structured extraction from documents, images, audio, and video.

---

**Q:** Which service provides AI-powered code assistance in the IDE?
**A:** Amazon Q Developer. It offers code generation, transformation, debugging, test generation, security scanning, and AWS infrastructure guidance within IDEs.

---

**Q:** Which service provides an enterprise AI assistant that answers questions from company data?
**A:** Amazon Q Business. It provides RAG-based Q&A over enterprise data sources with access control, citations, and plugin actions.

---

**Q:** Which service should you use for visual workflow orchestration of GenAI pipelines?
**A:** Amazon Bedrock Prompt Flows for FM-specific workflows, or AWS Step Functions for broader serverless orchestration with native Bedrock integration.

---

**Q:** Which service manages prompt templates with versioning?
**A:** Amazon Bedrock Prompt Management. It provides prompt template creation, variable substitution, versioning, and testing capabilities.

---

**Q:** Which service provides serverless compute for GenAI API backends?
**A:** AWS Lambda for synchronous and short-running tasks. Use Lambda with Bedrock for serverless GenAI APIs, action groups for Bedrock Agents, and event-driven processing.

---

**Q:** Which service should you use for long-running GenAI container workloads?
**A:** Amazon ECS with Fargate for container-based GenAI services, or ECS with EC2 (GPU instances) for self-hosted model inference. Use for MCP servers needing persistent connections or custom model serving.

---

**Q:** Which service provides managed PostgreSQL with vector search capability?
**A:** Amazon Aurora PostgreSQL with the pgvector extension. It supports vector storage and similarity search, making it a vector store option for Bedrock Knowledge Bases.

---

**Q:** Which service should you use for graph-based knowledge representation with vector search?
**A:** Amazon Neptune Analytics. It combines graph database capabilities with vector search, useful for knowledge graphs enhanced with semantic search.

---

**Q:** Which service detects bias in foundation model outputs?
**A:** Amazon SageMaker Clarify. It evaluates FM outputs for bias, toxicity, and stereotyping across demographic groups and integrates with Bedrock Model Evaluations.

---

**Q:** Which service provides data quality validation for GenAI training data?
**A:** AWS Glue Data Quality. It validates datasets with configurable rules for completeness, uniqueness, format, and custom checks to ensure high-quality training and RAG data.

---

**Q:** Which service tracks data lineage for GenAI pipelines?
**A:** AWS Glue Data Catalog with lineage tracking. It records the origin and transformations of data used in training, fine-tuning, and knowledge base construction.

---

**Q:** Which service should you use for managing secrets and API keys in GenAI applications?
**A:** AWS Secrets Manager for API keys, database credentials, and third-party service tokens. Use it in Lambda functions and ECS tasks that connect to external tools or data sources.

---

**Q:** Which service provides encryption key management for GenAI data?
**A:** AWS KMS (Key Management Service). It encrypts fine-tuned model artifacts, knowledge base data, model invocation logs, and data at rest. Supports both AWS-managed and customer-managed keys.

---

**Q:** Which service controls fine-grained data access for GenAI data lakes?
**A:** AWS Lake Formation. It provides column-level, row-level, and cell-level access control for data in S3 and Glue Data Catalog used in GenAI pipelines.

---

**Q:** Which service logs all Bedrock API calls for auditing?
**A:** AWS CloudTrail. It records who invoked which models, when, and from where. Essential for compliance, security investigations, and governance.

---

**Q:** Which service should you use for GenAI application monitoring and alerting?
**A:** Amazon CloudWatch. It provides Bedrock-specific metrics (latency, throttling, token counts, errors), custom dashboards, alarms, and log analysis for operational monitoring.

---

**Q:** Which service detects anomalous GenAI spending?
**A:** AWS Cost Anomaly Detection. It uses ML to identify unusual spending patterns in Bedrock and SageMaker, alerting you to unexpected cost spikes from runaway workloads.

---

**Q:** Which service provides API management for GenAI endpoints?
**A:** Amazon API Gateway. It adds authentication, rate limiting, caching, and request/response transformation in front of Lambda-based GenAI APIs. Supports REST, HTTP, and WebSocket APIs.

---

**Q:** Which service should you use for asynchronous GenAI event processing?
**A:** Amazon EventBridge for event routing, Amazon SQS for message queuing, or Amazon SNS for pub/sub notifications. Use these to decouple document processing, embedding generation, and notification workflows.

---

**Q:** Which service provides caching for GenAI application data?
**A:** Amazon ElastiCache (Redis or Memcached) or Amazon MemoryDB for Redis. Use for semantic caching of model responses, session state management, and conversation history caching.

---

**Q:** Which service should you use for real-time streaming of GenAI responses to web clients?
**A:** Amazon API Gateway WebSocket APIs for bidirectional streaming, Lambda function URLs with response streaming, or Amazon CloudFront for global distribution of streaming endpoints.

---

## Service Comparisons

**Q:** When should you use Bedrock Knowledge Bases vs. building a custom RAG pipeline?
**A:** Use Bedrock Knowledge Bases for standard RAG workflows with supported data sources and vector stores — it handles ingestion, chunking, embedding, and retrieval automatically. Build custom when you need unsupported data sources, custom chunking logic, specialized embedding models, or complex retrieval strategies.

---

**Q:** When should you use Bedrock Agents vs. Strands Agents?
**A:** Use Bedrock Agents for fully managed, serverless agent deployments with built-in knowledge base integration and action groups. Use Strands Agents (open-source SDK) when you need more customization, want to run agents locally, need specific tool integrations, or prefer a code-first approach.

---

**Q:** When should you use OpenSearch Serverless vs. Aurora pgvector for vector search?
**A:** Use OpenSearch Serverless for dedicated, high-performance vector search at scale with built-in hybrid search. Use Aurora pgvector when you already use Aurora PostgreSQL and want to add vector search alongside relational data without managing a separate vector database.

---

**Q:** When should you use Step Functions vs. Bedrock Prompt Flows for orchestration?
**A:** Use Bedrock Prompt Flows for FM-centric workflows (chaining prompts, knowledge bases, conditions). Use Step Functions for broader workflows involving multiple AWS services, complex error handling, human approval steps, and long-running processes beyond just FM invocation.

---

**Q:** When should you use Bedrock Model Evaluations vs. custom evaluation?
**A:** Use Bedrock Model Evaluations for standardized benchmarks, quick model comparisons, and managed LLM-as-a-Judge. Build custom evaluation when you need domain-specific metrics, integration with your CI/CD pipeline, real-time monitoring, or evaluation criteria not supported by the managed service.

---

**Q:** When should you use Lambda vs. ECS for GenAI backends?
**A:** Use Lambda for stateless, bursty workloads with <15-minute execution time and moderate memory needs. Use ECS for persistent services, GPU-based inference, WebSocket connections, large memory requirements, or workloads needing consistent warm capacity.

---

**Q:** When should you use fine-tuning vs. continued pre-training?
**A:** Use fine-tuning when you have labeled examples (prompt-completion pairs) and want to improve performance on a specific task. Use continued pre-training when you have large amounts of unlabeled domain text and want the model to learn domain vocabulary and knowledge without task-specific tuning.

---

**Q:** When should you use Bedrock Guardrails vs. application-level content filtering?
**A:** Use Bedrock Guardrails for standardized content moderation, PII handling, and grounding checks — it's managed, consistent, and doesn't require custom code. Use application-level filtering for business-specific rules, custom logic, or when you need to filter content from non-Bedrock sources (though ApplyGuardrail API can help here too).

---

**Q:** When should you use on-demand vs. Provisioned Throughput?
**A:** Use on-demand for development, testing, variable workloads, and cost experimentation. Use Provisioned Throughput for production workloads with predictable, consistent volume where you need guaranteed latency and can commit to 1-6 month terms for cost savings.

---

**Q:** When should you use Amazon Q Developer vs. Amazon Q Business?
**A:** Use Q Developer for software development tasks — code generation, debugging, transformation, and security scanning in IDEs. Use Q Business for enterprise knowledge management — answering employee questions from company data sources like Confluence, SharePoint, and databases.

---

**Q:** When should you use batch inference vs. real-time inference in Bedrock?
**A:** Use batch inference for processing thousands of prompts asynchronously (bulk document analysis, dataset augmentation, content generation at scale). Use real-time for interactive applications needing immediate responses (chatbots, search, live recommendations).

---

**Q:** When should you use CloudTrail vs. Bedrock Model Invocation Logging?
**A:** CloudTrail logs API metadata (who, what, when, where) for all Bedrock API calls. Model Invocation Logging captures the full payload (input prompts and output responses). Use CloudTrail for security/audit; use Model Invocation Logging for content review, debugging, and quality monitoring.

---

**Q:** When should you use Textract vs. Bedrock Data Automation for document processing?
**A:** Use Textract for OCR, form extraction, and table extraction from documents — it's fast and cost-effective for structured extraction. Use Bedrock Data Automation when you need FM-powered understanding of document content, complex extraction logic, or multimodal processing (images, audio, video).

---

## Feature Identification

**Q:** What Bedrock feature lets you test prompt templates with different variables?
**A:** Bedrock Prompt Management. It provides a prompt playground where you can create templates with variables, test different model configurations, compare outputs, and save versioned prompt configurations.

---

**Q:** What Bedrock feature automatically routes requests to other regions during capacity constraints?
**A:** Cross-Region Inference. Enable it by using an inference profile ARN (instead of a model ID) which automatically routes to available regions. Your data stays within the configured region set.

---

**Q:** What Bedrock feature validates model responses against source documents?
**A:** Bedrock Guardrails contextual grounding check. It compares the model's output against the provided reference context and blocks or flags responses that aren't supported by the source material.

---

**Q:** What Bedrock feature enables visual workflow creation for AI pipelines?
**A:** Bedrock Prompt Flows. It provides a visual DAG editor to chain together prompts, retrievals, conditions, Lambda functions, and other operations into automated workflows.

---

**Q:** What Bedrock feature lets you log full model inputs and outputs?
**A:** Bedrock Model Invocation Logging. Configure it to send full request/response payloads to S3 and/or CloudWatch Logs for compliance, debugging, and quality monitoring.

---

**Q:** What SageMaker feature helps deploy models too large for a single GPU?
**A:** SageMaker Large Model Inference (LMI) containers. They support model parallelism (tensor parallel, pipeline parallel), quantization, and optimized inference frameworks like vLLM and TensorRT-LLM.

---

**Q:** What Bedrock feature lets you manage and version AI safety policies?
**A:** Bedrock Guardrails. Each guardrail has a versioned configuration that defines content filters, denied topics, PII handling, word filters, and grounding policies. You can update and version guardrails independently of your application.

---

**Q:** What Bedrock feature provides managed multi-turn conversation with memory?
**A:** Bedrock Agents with session management. Agents automatically maintain conversation state across turns within a session, and you can configure memory to persist information across sessions using Bedrock's memory feature.

---

**Q:** What feature of Bedrock Knowledge Bases supports automatic data syncing?
**A:** Data source sync jobs. You can configure scheduled or on-demand syncing from data sources (S3, Confluence, SharePoint, etc.) to automatically update the vector index when source documents change.

---

**Q:** What feature allows Bedrock Guardrails to be used without calling a model?
**A:** The ApplyGuardrail API. It evaluates any text against your guardrail configuration independently of model invocation, enabling content moderation for any text source.

---

## Additional Service Cards

**Q:** Which service provides web crawling capability for Bedrock Knowledge Bases?
**A:** Bedrock Knowledge Bases includes a built-in web crawler data source connector. It crawls specified URLs, extracts content, chunks it, generates embeddings, and indexes them in your vector store.

---

**Q:** Which service should you use for real-time feature engineering for GenAI applications?
**A:** Amazon SageMaker Feature Store. It provides online (low-latency) and offline (batch) feature storage, useful for maintaining user context, session features, and real-time signals that augment GenAI prompts.

---

**Q:** Which service provides managed Jupyter notebooks for GenAI experimentation?
**A:** Amazon SageMaker Studio. It provides JupyterLab notebooks with pre-installed ML libraries, access to GPU instances, and integration with Bedrock and SageMaker services for model development and testing.

---

**Q:** Which AWS service should you use for image generation?
**A:** Amazon Bedrock with Amazon Titan Image Generator, Stability AI SDXL, or Amazon Nova Canvas. These models generate and edit images from text prompts with built-in safety controls.

---

**Q:** Which service should you use for video generation?
**A:** Amazon Nova Reel on Bedrock. It generates short videos from text or image prompts. For longer or more complex video workflows, combine with Amazon Bedrock Data Automation.

---

**Q:** Which AWS service converts text to speech for GenAI output?
**A:** Amazon Polly. It converts text to natural-sounding speech in multiple languages, useful for voice-enabled GenAI applications, accessibility, and multimodal outputs.

---

**Q:** Which AWS service converts speech to text for GenAI input?
**A:** Amazon Transcribe. It provides real-time and batch speech-to-text, enabling voice input for GenAI applications. It supports custom vocabularies, speaker diarization, and PII redaction.

---

**Q:** Which service translates text between languages for multilingual GenAI?
**A:** Amazon Translate. It provides real-time neural machine translation for input/output localization. However, many FMs support multilingual generation natively, which may be preferable.

---

**Q:** Which service provides document model cards in a structured format?
**A:** Amazon SageMaker Model Cards. They provide a standardized framework for documenting model purpose, training details, evaluation results, intended use, and ethical considerations.

---

**Q:** Which service should you use for human review of GenAI outputs?
**A:** Amazon SageMaker Ground Truth. It provides a managed workforce (your team or Amazon Mechanical Turk) for labeling, evaluation, and human-in-the-loop review of model outputs.

---

**Q:** Which service provides a managed graph database for knowledge graphs?
**A:** Amazon Neptune. Use Neptune for knowledge graph construction and traversal, and Neptune Analytics for combining graph queries with vector search for hybrid retrieval.

---

**Q:** Which service should you use for serverless event-driven orchestration of GenAI workflows?
**A:** AWS Step Functions (Express and Standard). Native integration with Bedrock, Lambda, and 200+ AWS services. Supports parallel execution, error handling, retries, and visual workflow monitoring.

---

**Q:** Which service provides managed Redis for GenAI caching and session storage?
**A:** Amazon MemoryDB for Redis (durable, strongly consistent) or Amazon ElastiCache for Redis (in-memory cache). Both support vector search for semantic caching use cases.

---

**Q:** Which service should you use for streaming data ingestion into GenAI pipelines?
**A:** Amazon Kinesis Data Streams for real-time data ingestion, or Amazon Kinesis Data Firehose for near-real-time delivery to S3, OpenSearch, and other destinations. Use for real-time log processing and event streaming.

---

**Q:** Which service provides authentication for GenAI application users?
**A:** Amazon Cognito. It provides user pools (sign-up/sign-in), identity pools (AWS credentials), and OAuth/OIDC federation. Integrate with API Gateway to authenticate GenAI API requests.

---

## Scenario-Based Cards

**Q:** A company wants their customer support chatbot to answer questions using internal documentation. Which Bedrock features should they use?
**A:** Bedrock Knowledge Bases (ingest documentation, create vector index), Bedrock Agents (orchestrate conversation with tool use), and Bedrock Guardrails (content filtering, PII redaction, grounding check to reduce hallucinations).

---

**Q:** An application needs to process 10,000 documents and generate summaries overnight. What approach should they use?
**A:** Bedrock Batch Inference. Store prompts in an S3 file, submit a batch job, and collect results from S3. This is more cost-effective than real-time API calls for bulk processing and avoids throttling.

---

**Q:** A team wants to ensure their GenAI application never discusses competitor products. How should they implement this?
**A:** Use Bedrock Guardrails with Denied Topics. Define a topic for competitor discussion with sample phrases. The guardrail will detect and block both user inputs asking about competitors and model outputs that mention them, returning a configured refusal message.

---

**Q:** An application is experiencing intermittent Bedrock throttling during peak hours. What are two solutions?
**A:** (1) Enable Cross-Region Inference to automatically route to other regions with available capacity. (2) Switch to Provisioned Throughput for guaranteed, dedicated capacity if the workload is predictable and consistent enough to justify the commitment.

---

**Q:** A healthcare company needs to ensure patient data is never exposed in GenAI responses. What should they implement?
**A:** Bedrock Guardrails with PII detection configured to redact or block all PHI/PII types (names, dates, medical records). Combine with VPC endpoints for network isolation, KMS encryption for data at rest, and Model Invocation Logging for compliance auditing.

---

**Q:** A developer needs to compare Claude 3 Sonnet, Llama 3, and Amazon Nova Pro for a summarization task. What should they use?
**A:** Bedrock Model Evaluations. Create an evaluation job with a summarization dataset, select the three models, choose automatic metrics (ROUGE, BERTScore) and/or LLM-as-a-Judge evaluation, and compare results on quality, latency, and cost.

---

**Q:** An application's RAG system returns accurate but irrelevant answers. What should be investigated?
**A:** The retrieval step is likely returning off-topic chunks. Investigate: chunking strategy (too large?), metadata filtering (not applied?), embedding model quality, similarity threshold settings, and whether hybrid search (adding keyword matching) would improve precision.

---

**Q:** A company wants to fine-tune a model for legal document analysis. They have 50,000 unlabeled legal documents and 500 labeled examples. What approach should they take?
**A:** First, use continued pre-training with the 50,000 unlabeled documents to adapt the model to legal domain language. Then, fine-tune the adapted model using the 500 labeled examples for the specific legal analysis task. This two-stage approach maximizes both domain knowledge and task performance.

---

**Q:** How should you deploy a GenAI application that needs to be globally available with low latency?
**A:** Use CloudFront for global edge distribution, API Gateway regional endpoints with Lambda for compute, Bedrock with Cross-Region Inference for FM availability, and semantic caching (ElastiCache/MemoryDB) in each region to reduce redundant model calls.

---

**Q:** A team wants to track which department is spending the most on Bedrock. How should they implement this?
**A:** Use Bedrock Application Inference Profiles with tags (e.g., Department=Sales, Department=Engineering). Each department uses their tagged profile for invocations. Use AWS Cost Explorer or Cost and Usage Reports filtered by these tags to analyze per-department spending.

---

**Q:** An application needs to handle both simple FAQ queries and complex analytical questions. What model routing strategy should they use?
**A:** Implement model cascading: route queries through a classifier (or small model) that determines complexity. Simple queries go to a fast, cheap model (e.g., Nova Micro, Haiku). Complex queries go to a capable model (e.g., Nova Pro, Sonnet). This optimizes both cost and quality.

---

**Q:** How should you secure a GenAI application handling financial data?
**A:** Use VPC endpoints for Bedrock (no public internet), IAM policies with least-privilege model access, KMS customer-managed keys for encryption, Guardrails for PII/financial data redaction, Model Invocation Logging to S3 (encrypted) for audit, CloudTrail for API audit, and Lake Formation for data access control.

---

**Q:** A company is seeing increased hallucinations in their RAG application after adding new documents. What should they investigate?
**A:** Check if new documents conflict with existing ones, verify chunking produces coherent chunks for the new content, ensure embeddings are generated correctly, review retrieval quality (are new chunks displacing better ones?), check if the grounding guardrail threshold needs adjustment, and evaluate whether the new documents need metadata filtering.

---

**Q:** An agent keeps calling the wrong tool for user requests. How do you fix this?
**A:** Improve tool descriptions in the action group definitions to be more specific and distinctive. Add negative examples ("do NOT use this tool for X"). Refine the agent's system prompt with clearer routing instructions. Test with diverse inputs and iterate on descriptions. Enable agent trace to see the reasoning chain.

---

**Q:** A GenAI application needs to process both PDF documents and images. What Bedrock approach should be used?
**A:** Use a multimodal model (Claude 3, Amazon Nova) that natively handles both text and images. For PDFs, use Bedrock Knowledge Bases with Textract/custom parser for extraction. For images embedded in documents, use Bedrock Data Automation or multimodal models to generate text descriptions for indexing.

---

**Q:** How do you implement a feedback loop for continuous GenAI improvement?
**A:** Collect user feedback (thumbs up/down, corrections) alongside model invocation logs. Analyze feedback patterns to identify weak areas. Use negative examples for prompt refinement, create golden datasets from corrected outputs, consider fine-tuning with high-quality feedback data, and update guardrails based on flagged content.

---

**Q:** What is the recommended architecture for a production GenAI chatbot on AWS?
**A:** CloudFront → API Gateway (WebSocket) → Lambda → Bedrock (with streaming). Add Cognito for auth, Bedrock Knowledge Bases for RAG, Guardrails for safety, DynamoDB for conversation history, CloudWatch for monitoring, and Model Invocation Logging for audit. Use Cross-Region Inference for high availability.

---

**Q:** How do you handle model version updates in production GenAI applications?
**A:** Pin to specific model versions in code, test new versions against golden datasets before updating, use canary deployments to gradually shift traffic, monitor evaluation metrics during rollout, maintain rollback capability, and document model version changes in deployment logs.

---

**Q:** A team needs to process real-time customer conversations and generate summaries. What architecture should they use?
**A:** Amazon Transcribe (speech-to-text) → Kinesis Data Streams (real-time pipeline) → Lambda (invoke Bedrock for summarization) → DynamoDB (store summaries) → EventBridge (trigger notifications). Use streaming Bedrock invocation for real-time partial summaries.

---

**Q:** What is the recommended approach for implementing guardrails in a multi-model application?
**A:** Create a single guardrail configuration and apply it consistently across all model invocations using the guardrail ID/version. Use the ApplyGuardrail API for non-Bedrock models. This ensures consistent safety policies regardless of which model processes the request.

---

**Q:** How should you handle PII in a GenAI application that needs to reference customer data?
**A:** Use anonymization: replace PII with tokens before sending to the model (e.g., "Customer [C123]" instead of real names). Store the PII-to-token mapping securely. De-anonymize in the response before showing to authorized users. Bedrock Guardrails can also redact PII automatically.

---

**Q:** What is the correct approach when Bedrock returns a ThrottlingException?
**A:** Implement exponential backoff with jitter in your retry logic. Consider enabling Cross-Region Inference for automatic failover, evaluate Provisioned Throughput for consistent capacity, optimize prompt length to reduce processing time, and implement request queuing with SQS to smooth traffic spikes.

---

**Q:** How do you implement role-based access to different foundation models?
**A:** Create IAM policies that restrict `bedrock:InvokeModel` to specific model ARNs. Assign policies to IAM roles: e.g., developers get access to cheaper models, production services get access to premium models. Use condition keys to further restrict by tags or inference profiles.

---

**Q:** What should you do if your Bedrock Knowledge Base retrieval returns empty results?
**A:** Verify the data source sync completed successfully, check the vector index contains embeddings (query OpenSearch directly), ensure the embedding model matches between ingestion and query, test with known queries that should match indexed content, and verify metadata filters aren't too restrictive.

---

---

*Total: 260 flashcards covering all five exam domains plus AWS services quick recall.*
