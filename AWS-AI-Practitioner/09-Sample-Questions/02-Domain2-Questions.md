# Domain 2 — Sample Questions (Generative AI Fundamentals)

---

**Q1.** Which best describes a **Foundation Model**?
- A. A small model trained from scratch for a single task
- B. A large, pretrained model that can be adapted to many tasks
- C. An embedding used to search documents
- D. A fine-tuned classifier

<details><summary>Answer</summary>**B.** FMs are large and multi-task adaptable.</details>

---

**Q2.** What is the core architectural building block of modern LLMs?
- A. Convolutional layer
- B. Self-attention (transformer)
- C. Recurrent cell (LSTM)
- D. K-Nearest Neighbors

<details><summary>Answer</summary>**B.** Self-attention is the defining component of transformers.</details>

---

**Q3.** In Amazon Bedrock, which guarantee describes data privacy?
- A. Your prompts are used to train the foundation models.
- B. Your prompts and responses remain in your AWS account and are not used to train the base FMs.
- C. Your data is shared across customers to improve models.
- D. Your data is sent to third-party model vendors without your control.

<details><summary>Answer</summary>**B.** Data stays in your account, and is not used to train Bedrock FMs.</details>

---

**Q4.** Which inference parameter increases output randomness?
- A. max_tokens
- B. temperature
- C. stop sequences
- D. model_id

<details><summary>Answer</summary>**B.** Higher temperature = more random sampling.</details>

---

**Q5.** Which Bedrock feature provides a managed RAG capability?
- A. Guardrails
- B. Knowledge Bases
- C. Flows
- D. Agents

<details><summary>Answer</summary>**B.** Knowledge Bases = managed RAG. Agents can call them; Guardrails are safety; Flows are orchestration.</details>

---

**Q6.** Which Bedrock feature enables multi-step orchestration that calls external APIs?
- A. Knowledge Bases
- B. Guardrails
- C. Agents
- D. Prompt Management

<details><summary>Answer</summary>**C.** Agents handle planning, tool/action calls, memory, and RAG.</details>

---

**Q7.** Which Bedrock feature filters PII, hate speech, and enforces denied topics?
- A. Guardrails
- B. Knowledge Bases
- C. Flows
- D. Model Evaluation

<details><summary>Answer</summary>**A.** Guardrails is the safety layer.</details>

---

**Q8.** You need the unified chat API that works across Anthropic Claude, Amazon Nova, and Meta Llama with one request schema. Which API?
- A. `InvokeModel`
- B. `Converse`
- C. `CreateFoundationModel`
- D. `Retrieve`

<details><summary>Answer</summary>**B.** Converse normalizes inputs and outputs across chat-capable models.</details>

---

**Q9.** Which Bedrock pricing mode is required to serve most **custom fine-tuned** models?
- A. On-demand
- B. Batch
- C. Provisioned Throughput
- D. Free tier

<details><summary>Answer</summary>**C.** Provisioned Throughput is typically required to serve a custom model.</details>

---

**Q10.** Which Bedrock mode is ~50% cheaper for large async workloads?
- A. On-demand
- B. Batch
- C. Provisioned Throughput
- D. Model customization

<details><summary>Answer</summary>**B.** Batch inference jobs are ~50% cheaper.</details>

---

**Q11.** A team wants their chatbot to answer from the latest company policies that change weekly. Best approach?
- A. Fine-tune the model weekly
- B. Use RAG with a Knowledge Base
- C. Use only prompt engineering
- D. Use continued pretraining

<details><summary>Answer</summary>**B.** RAG pulls fresh content without retraining.</details>

---

**Q12.** A team wants the model to always respond in a specific structured format even without in-prompt examples. Best approach?
- A. Prompt engineering with few-shot
- B. Fine-tuning the model on examples of that format
- C. Continued pretraining
- D. Lowering temperature only

<details><summary>Answer</summary>**B.** Fine-tuning cements consistent behavior. Prompting alone is brittle at scale.</details>

---

**Q13.** Which is a mitigation for prompt injection attacks?
- A. Embed user input directly into the system prompt
- B. Use untrusted retrieved content as instructions
- C. Apply guardrails and separate user content with clear delimiters
- D. Remove all input validation

<details><summary>Answer</summary>**C.** Defense-in-depth with guardrails and separation.</details>

---

**Q14.** Which embedding model is provided first-party by AWS on Bedrock?
- A. OpenAI text-embedding-3-large
- B. Amazon Titan Embeddings V2
- C. Meta Llama Embed
- D. Anthropic Claude Embed

<details><summary>Answer</summary>**B.** Titan Embeddings V2 is AWS's first-party text embedding model. Cohere Embed is also on Bedrock but third-party.</details>

---

**Q15.** Which is a Bedrock image generation model?
- A. Amazon Nova Canvas
- B. Claude 3 Opus
- C. Cohere Embed
- D. Llama 3 70B

<details><summary>Answer</summary>**A.** Nova Canvas generates images; Titan Image Generator and Stable Diffusion also on Bedrock.</details>

---

**Q16.** What does "context window" refer to?
- A. The GPU memory of the host
- B. Max tokens (input + output) the model processes per request
- C. The number of fine-tuning examples
- D. The max size of the response only

<details><summary>Answer</summary>**B.** Both input and output count against the context window.</details>

---

**Q17.** Chain-of-Thought (CoT) prompting primarily improves performance on:
- A. Simple lookups
- B. Multi-step reasoning tasks
- C. Text classification
- D. Embedding quality

<details><summary>Answer</summary>**B.** CoT helps the model break down reasoning, improving math/logic/multi-step accuracy.</details>

---

**Q18.** Which is NOT a typical benefit of Bedrock?
- A. Single API across multiple model providers
- B. Serverless (no GPU provisioning for on-demand)
- C. Customer data is used to train the base FMs
- D. Regional data residency

<details><summary>Answer</summary>**C.** Customer data is NOT used to train base FMs. The other three are true benefits.</details>

---

**Q19.** Which of these is most likely to reduce **hallucination** in a GenAI app?
- A. Increase temperature
- B. Use RAG with good retrieval + contextual grounding guardrail
- C. Disable stop sequences
- D. Remove the system prompt

<details><summary>Answer</summary>**B.** Grounding in retrieved facts and a grounding check reduce hallucination.</details>

---

**Q20.** Which technique refers to one "teacher" model teaching a smaller "student" model to mimic it?
- A. Continued pretraining
- B. Fine-tuning
- C. Model distillation
- D. RAG

<details><summary>Answer</summary>**C.** Distillation is the teacher-student approach.</details>

---

**Q21.** Which is NOT a Bedrock model provider?
- A. Anthropic
- B. Mistral AI
- C. OpenAI
- D. Cohere

<details><summary>Answer</summary>**C.** OpenAI is not a Bedrock provider.</details>

---

**Q22.** A system needs low latency (<400ms) for short text classifications at high volume. Which Bedrock model would you consider first?
- A. Anthropic Claude Opus
- B. Amazon Nova Micro or Claude Haiku
- C. Meta Llama 3 405B
- D. Stable Diffusion XL

<details><summary>Answer</summary>**B.** Small, fast models are ideal for low-latency high-volume tasks.</details>

---

**Q23.** What does a **denied topic** in Bedrock Guardrails do?
- A. Blocks HTTP requests
- B. Natural-language topic definition that the guardrail uses to block or flag prompts/responses on that subject
- C. A regex pattern
- D. A type of content-filter category

<details><summary>Answer</summary>**B.** Denied topics are defined in natural language (up to 30).</details>

---

**Q24.** Which Bedrock Guardrails feature reduces hallucination in RAG responses?
- A. Denied topics
- B. Word filters
- C. Contextual grounding check
- D. Content filters

<details><summary>Answer</summary>**C.** Contextual grounding check scores grounding/relevance against reference context.</details>

---

**Q25.** Which AWS service can use an FM to generate SQL from natural language inside a dashboard?
- A. Amazon Q in QuickSight
- B. Amazon Athena
- C. Amazon Redshift
- D. Amazon Forecast

<details><summary>Answer</summary>**A.** Q in QuickSight brings NL BI into dashboards.</details>

---

**Q26.** Which is TRUE about fine-tuning on Bedrock?
- A. It automatically enables on-demand serving.
- B. It usually requires Provisioned Throughput to serve the custom model.
- C. It updates the base model globally for all customers.
- D. It replaces the need for guardrails.

<details><summary>Answer</summary>**B.** Provisioned Throughput required to serve most custom models.</details>

---

**Q27.** A team needs a visual pipeline chaining prompts, KBs, Lambdas, and conditions without writing much code. Which Bedrock feature?
- A. Bedrock Flows
- B. Bedrock Studio
- C. Knowledge Bases
- D. Guardrails

<details><summary>Answer</summary>**A.** Flows is the visual orchestration feature.</details>

---

**Q28.** What does **prompt caching** (where supported) save?
- A. Output tokens only
- B. Compute for repeatedly sent stable prompt prefixes (system + long context)
- C. Storage in S3
- D. Network bandwidth to the user

<details><summary>Answer</summary>**B.** Caching a stable prefix reduces per-request cost and latency.</details>

---

**Q29.** Which is a typical order of customization approaches from least to most cost?
- A. Prompt engineering → RAG → Fine-tuning → Continued pretraining
- B. Fine-tuning → RAG → Prompt engineering
- C. Continued pretraining → Fine-tuning → RAG
- D. RAG → Prompt engineering → Fine-tuning

<details><summary>Answer</summary>**A.** Start with prompt engineering; escalate only if needed.</details>

---

**Q30.** Which vector store is NOT natively supported by Bedrock Knowledge Bases?
- A. OpenSearch Serverless
- B. Aurora PostgreSQL (pgvector)
- C. Pinecone
- D. DynamoDB

<details><summary>Answer</summary>**D.** DynamoDB is not a vector DB option for Bedrock KBs.</details>

---

**Q31.** Which is TRUE about Bedrock Agents?
- A. Agents can call Lambda-backed Action Groups and Knowledge Bases.
- B. Agents cannot use guardrails.
- C. Agents never show reasoning traces.
- D. Agents only work with Amazon Titan.

<details><summary>Answer</summary>**A.** Agents combine Action Groups (Lambda), KBs, guardrails, memory, and traces.</details>

---

**Q32.** Which Bedrock capability helps you compare models on your dataset using metrics like ROUGE, BLEU, BERTScore, toxicity?
- A. Bedrock Model Evaluation
- B. Bedrock Guardrails
- C. Bedrock Flows
- D. SageMaker Model Monitor

<details><summary>Answer</summary>**A.** Model Evaluation supports automatic, human, and LLM-as-judge evaluations.</details>

---

**Q33.** For which goal is "few-shot prompting" most effective?
- A. Teach the model a brand-new fact
- B. Demonstrate desired style or format via 2-5 examples
- C. Speed up inference
- D. Reduce token cost

<details><summary>Answer</summary>**B.** Few-shot = in-context examples to steer behavior.</details>

---

**Q34.** Which model family is particularly known for long context windows and strong reasoning?
- A. Stable Diffusion XL
- B. Anthropic Claude
- C. Amazon Titan Image Generator
- D. Cohere Embed

<details><summary>Answer</summary>**B.** Claude is known for long context (200K+) and strong reasoning.</details>

---

**Q35.** "Top-p" sampling means:
- A. Sample only the most probable token
- B. Sample from the smallest set of tokens whose cumulative probability ≥ p
- C. Use the top-p of historical prompts
- D. A safety filter

<details><summary>Answer</summary>**B.** Nucleus sampling.</details>

---

**Q36.** A retail company wants to run a summarization job on 2 million product descriptions once a quarter. Best Bedrock pricing mode?
- A. On-demand
- B. Provisioned Throughput (6-month)
- C. Batch inference
- D. Free tier

<details><summary>Answer</summary>**C.** Large-scale async → batch inference, ~50% discount.</details>

---

**Q37.** "Multi-agent collaboration" in Bedrock enables:
- A. Multiple accounts sharing an agent
- B. A supervisor agent delegating to specialist sub-agents
- C. Running two different FMs in parallel for every request
- D. Running guardrails in parallel

<details><summary>Answer</summary>**B.** Supervisor/specialist pattern.</details>

---

**Q38.** Which of the following best describes **prompt injection**?
- A. Injecting new weights into the model
- B. A dependency injection framework for prompts
- C. Adversarial input that manipulates the LLM into ignoring instructions or leaking data
- D. An optimization pass for prompts

<details><summary>Answer</summary>**C.** Core security concept for LLMs.</details>

---

**Q39.** Which is the best approach when your model must respond in a specific JSON schema consistently?
- A. Plain English instruction and hope for the best
- B. Use structured-output / tool use / schema enforcement, plus validation + retry in code
- C. Increase temperature to 2.0
- D. Disable guardrails

<details><summary>Answer</summary>**B.** Combine schema + retry + validation for reliability.</details>

---

**Q40.** The `RetrieveAndGenerate` API is used for:
- A. Fine-tuning a model
- B. Full managed RAG: retrieval + FM generation + citations
- C. Fetching provisioned throughput
- D. Inviting collaborators

<details><summary>Answer</summary>**B.** Managed RAG API returning citations.</details>

---

**Q41.** Which Bedrock feature lets you version and reuse prompt templates with variables?
- A. Prompt Management
- B. Knowledge Bases
- C. Model Evaluation
- D. PartyRock

<details><summary>Answer</summary>**A.** Prompt Management handles versioned reusable prompts.</details>

---

**Q42.** Which is the correct description of **embeddings**?
- A. The model's total parameter count
- B. Numerical vector representations capturing semantic meaning
- C. A type of GPU
- D. A pricing unit

<details><summary>Answer</summary>**B.** Embeddings map content to dense vectors for similarity search.</details>

---

**Q43.** Which metric captures similarity of two embeddings on a scale from -1 to 1?
- A. Mean Squared Error
- B. Cosine similarity
- C. Accuracy
- D. BLEU

<details><summary>Answer</summary>**B.** Cosine similarity is the standard for embedding vectors.</details>

---

**Q44.** Which is NOT typically a limitation of GenAI?
- A. Hallucination
- B. Training data staleness
- C. Always explainable
- D. Bias inherited from training data

<details><summary>Answer</summary>**C.** GenAI is famously hard to explain.</details>

---

**Q45.** Which best describes the ReAct pattern?
- A. A retry framework for API calls
- B. Reason → Act (tool call) → Observe → repeat, used by agents
- C. A CSS framework
- D. A fine-tuning algorithm

<details><summary>Answer</summary>**B.** Core agent pattern.</details>

---

**Q46.** A business wants to build a multi-step customer-support automation: look up orders, check warranty, open tickets, and answer FAQs from docs — all via natural language. Best service mix?
- A. Lex only
- B. Bedrock Agent + Knowledge Bases + Guardrails + Lambda (Action Groups)
- C. SageMaker + Rekognition
- D. Polly + Translate

<details><summary>Answer</summary>**B.** Agents orchestrate multi-step actions with KB for FAQs and guardrails for safety.</details>

---

**Q47.** Which statement about `InvokeModel` vs `Converse` is correct?
- A. `Converse` only works with Anthropic models.
- B. `Converse` normalizes the chat schema across supported models; `InvokeModel` is model-specific.
- C. `InvokeModel` is deprecated.
- D. Both APIs return SQL.

<details><summary>Answer</summary>**B.** Converse is the unified chat API; InvokeModel requires model-specific JSON.</details>

---

**Q48.** Which is TRUE about Amazon Q Business?
- A. It's a code completion tool for developers.
- B. It's an enterprise AI assistant with connectors that respects document-level permissions.
- C. It trains foundation models.
- D. It's only for QuickSight dashboards.

<details><summary>Answer</summary>**B.** Q Business is the enterprise search+chat with ACL enforcement.</details>

---

**Q49.** Which output is typical of `RetrieveAndGenerate`?
- A. Only retrieved chunks
- B. A generated answer plus citations to source documents
- C. Binary model weights
- D. Training logs

<details><summary>Answer</summary>**B.** Answer + citations.</details>

---

**Q50.** Which combination is the safest for a public-facing GenAI chatbot?
- A. Open model + no guardrails
- B. FM + Guardrails (content filters, PII, denied topics) + output validation + rate limiting
- C. Only prompt engineering
- D. Logging only

<details><summary>Answer</summary>**B.** Defense in depth: guardrails + validation + rate limiting.</details>
