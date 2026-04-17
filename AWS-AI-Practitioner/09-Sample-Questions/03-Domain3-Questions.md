# Domain 3 — Sample Questions (Applications of Foundation Models)

---

**Q1.** Which is the MOST common reason to choose RAG over fine-tuning?
- A. To permanently change the model's behavior
- B. To ground answers in up-to-date or private knowledge without retraining
- C. To reduce inference latency
- D. To remove the need for prompt engineering

<details><summary>Answer</summary>**B.** RAG = fresh/private knowledge without retraining.</details>

---

**Q2.** Which chunking strategy retrieves small chunks for precision but returns a larger parent chunk for context?
- A. Fixed-size chunking
- B. Hierarchical chunking
- C. Semantic chunking
- D. No chunking

<details><summary>Answer</summary>**B.** Hierarchical = parent/child relationship.</details>

---

**Q3.** A team builds a RAG system with Bedrock KB and wants the response to fail if not grounded in the retrieved context. Which feature helps?
- A. Word filter
- B. Contextual grounding check (Guardrail)
- C. Stop sequences
- D. Automatic Model Tuning

<details><summary>Answer</summary>**B.** The grounding check scores grounding & relevance and can block.</details>

---

**Q4.** Which of these tasks is most suited for fine-tuning rather than RAG?
- A. Include weekly-updated policy docs
- B. Teach the model to always respond in a specific brand voice
- C. Search across private files
- D. Cite specific sources

<details><summary>Answer</summary>**B.** Persistent style/format cement via fine-tuning.</details>

---

**Q5.** What is **continued pretraining** on Bedrock used for?
- A. Teaching the model a new task with labeled pairs
- B. Unlabeled domain text to teach vocabulary and domain knowledge
- C. Deploying a custom model
- D. Evaluating a model

<details><summary>Answer</summary>**B.** Continued pretraining uses unlabeled domain corpora.</details>

---

**Q6.** Which is the BEST description of **model distillation**?
- A. Pruning random weights from the model
- B. Training a smaller student model to mimic a larger teacher's outputs
- C. Removing training data
- D. Increasing the context window

<details><summary>Answer</summary>**B.** Smaller/cheaper student model mimics teacher's behavior.</details>

---

**Q7.** Which metric is commonly used for summarization evaluation?
- A. BLEU
- B. ROUGE
- C. RMSE
- D. AUC-PR

<details><summary>Answer</summary>**B.** ROUGE is the standard for summarization (BLEU is translation).</details>

---

**Q8.** Which of these is a **RAG-specific** evaluation dimension?
- A. Learning rate
- B. Faithfulness / groundedness
- C. L2 regularization
- D. Softmax temperature

<details><summary>Answer</summary>**B.** Groundedness of the answer in retrieved context.</details>

---

**Q9.** Which of the following are supported vector stores for Bedrock Knowledge Bases? (Select all that apply.)
- A. Amazon OpenSearch Serverless
- B. Amazon Aurora (pgvector)
- C. Amazon DynamoDB
- D. Pinecone
- E. Redis Enterprise Cloud

<details><summary>Answer</summary>**A, B, D, E.** DynamoDB is not a supported vector store.</details>

---

**Q10.** For a multi-step workflow that must consult internal documents, then call CRM APIs, then generate a summary, what is the best architecture?
- A. One invoke_model call with everything
- B. A Bedrock Agent with Knowledge Base + Action Group + Guardrails
- C. SageMaker Canvas
- D. Textract + Lex

<details><summary>Answer</summary>**B.** Agents orchestrate multi-step tool use and KB.</details>

---

**Q11.** Which retrieval technique combines semantic and lexical matching?
- A. Cold storage retrieval
- B. Hybrid search (BM25 + vector)
- C. Hash lookup
- D. Softmax retrieval

<details><summary>Answer</summary>**B.** Hybrid search = dense + sparse.</details>

---

**Q12.** Which of the following is TRUE about citations in Bedrock Knowledge Bases?
- A. They cannot be returned with answers.
- B. They link response spans to retrieved source chunks for verification.
- C. They replace guardrails.
- D. They are only available with Cohere Command.

<details><summary>Answer</summary>**B.** Citations provide source traceability.</details>

---

**Q13.** Which of the following would you **NOT** expect to reduce cost of a GenAI app?
- A. Caching common prompt prefixes
- B. Using a smaller model if quality allows
- C. Using batch inference for offline workloads
- D. Increasing `max_tokens` to very large

<details><summary>Answer</summary>**D.** Larger max tokens increases cost and latency.</details>

---

**Q14.** Which type of evaluation uses another LLM to grade outputs against a rubric?
- A. Human evaluation
- B. Automatic n-gram metrics
- C. LLM-as-a-judge
- D. Perplexity

<details><summary>Answer</summary>**C.** LLM-as-a-judge is fast and scalable; validate with humans periodically.</details>

---

**Q15.** Which is a typical chunk size and overlap for RAG?
- A. 1 token, 0 overlap
- B. 300–1000 tokens with 10–20% overlap
- C. 1 million tokens with 90% overlap
- D. Always 8192 tokens

<details><summary>Answer</summary>**B.** Common defaults.</details>

---

**Q16.** Which is the best model for generating **embeddings** on Bedrock when cost/quality matters and data is mostly text?
- A. Claude 3 Opus
- B. Titan Embeddings V2
- C. Nova Canvas
- D. Stable Diffusion XL

<details><summary>Answer</summary>**B.** Titan Embeddings V2 is tuned for text embeddings.</details>

---

**Q17.** A customer wants to deploy an agent that can execute destructive actions (delete data). Which safeguard should be enforced?
- A. Increase temperature
- B. User confirmation for destructive actions
- C. Disable guardrails
- D. Store credentials in the prompt

<details><summary>Answer</summary>**B.** Require explicit user confirmation.</details>

---

**Q18.** Which of the following is a pitfall of fine-tuning?
- A. Catastrophic forgetting (losing general ability)
- B. Automatically improves retrieval
- C. Always requires zero data
- D. Removes the need for monitoring

<details><summary>Answer</summary>**A.** Fine-tuning too narrowly can degrade general skills.</details>

---

**Q19.** Which is the correct use for the `Retrieve` (not RetrieveAndGenerate) API?
- A. Only fetch chunks; you compose the prompt and call the FM yourself
- B. Run the full managed RAG flow
- C. Fine-tune a model
- D. Delete a knowledge base

<details><summary>Answer</summary>**A.** Retrieve returns chunks only.</details>

---

**Q20.** Which foundation model is known for strong **RAG + tool use** on Bedrock?
- A. Cohere Command R+
- B. AI21 Jurassic
- C. Titan Image Generator
- D. DeepSeek V1

<details><summary>Answer</summary>**A.** Command R+ is tuned for RAG and tool use.</details>

---

**Q21.** Which is a parameter-efficient fine-tuning technique that trains small low-rank matrices instead of full weights?
- A. LoRA
- B. Dropout
- C. Data augmentation
- D. One-hot encoding

<details><summary>Answer</summary>**A.** LoRA.</details>

---

**Q22.** Which is NOT a typical step when designing an agent?
- A. Write clear instructions
- B. Define tool schemas precisely
- C. Grant `*:*` IAM to Lambda
- D. Attach guardrails

<details><summary>Answer</summary>**C.** Always least-privilege.</details>

---

**Q23.** Which measure helps evaluate **context relevance** in a RAG pipeline?
- A. Regression MAE
- B. How well retrieved chunks relate to the user's question
- C. Number of epochs
- D. CPU utilization

<details><summary>Answer</summary>**B.** Context relevance is a RAG-specific quality metric.</details>

---

**Q24.** Which of the following is the BEST reason to choose a smaller foundation model?
- A. Lower quality
- B. Lower cost and latency, when the quality bar can be met
- C. Better for complex reasoning
- D. Required by compliance

<details><summary>Answer</summary>**B.** Pick the smallest model that meets the quality bar.</details>

---

**Q25.** Which is TRUE about Bedrock **on-demand** inference?
- A. Always requires a monthly commitment
- B. Pay per token with no commitment; ideal for spiky workloads
- C. Only available for Titan
- D. Requires GPU provisioning

<details><summary>Answer</summary>**B.** On-demand = per-token, no reservation.</details>

---

**Q26.** A team wants to combine structured + unstructured KB filters ("only docs for tenant X, created after Jan 1"). Which feature enables this?
- A. Metadata filtering
- B. Temperature
- C. Stop sequences
- D. Streaming

<details><summary>Answer</summary>**A.** Metadata filters apply strict constraints on retrieval.</details>

---

**Q27.** Which is a valid way to evaluate a custom fine-tuned Bedrock model?
- A. Bedrock Model Evaluation (automatic + human + LLM-as-judge)
- B. Amazon Transcribe
- C. Amazon Polly
- D. Amazon Forecast

<details><summary>Answer</summary>**A.** Model Evaluation supports custom models.</details>

---

**Q28.** Which of the following is the BEST mitigation for indirect prompt injection via retrieved docs?
- A. Trust all retrieved content
- B. Apply guardrails; treat retrieved content as untrusted; use delimiters & structured outputs
- C. Increase temperature
- D. Remove the system prompt

<details><summary>Answer</summary>**B.** Defense in depth.</details>

---

**Q29.** Which is a feature of Bedrock Flows?
- A. Visual DAG of prompts, KBs, agents, Lambdas, conditions
- B. A distributed training engine
- C. A database of foundation models
- D. A GPU scheduler

<details><summary>Answer</summary>**A.** Flows = visual workflow builder.</details>

---

**Q30.** Which best describes **self-consistency**?
- A. Sample multiple chains of thought and take the majority-vote answer
- B. A guardrail for consistency
- C. A retrieval metric
- D. A fine-tuning option

<details><summary>Answer</summary>**A.** Self-consistency voting improves reasoning accuracy.</details>

---

**Q31.** Which is TRUE about Bedrock Agents and KBs?
- A. Agents can't use KBs.
- B. Agents can query KBs as one of their tools during reasoning.
- C. KBs require a separate agent runtime.
- D. Only Claude can be an agent.

<details><summary>Answer</summary>**B.** Agents integrate KBs.</details>

---

**Q32.** Which FM output control enforces formal-logic policies (e.g., HR policies)?
- A. Temperature
- B. Automated Reasoning Checks (Guardrails)
- C. Batch inference
- D. Prompt Management

<details><summary>Answer</summary>**B.** Automated Reasoning verifies claims against formal rules.</details>

---

**Q33.** Which is the BEST mix when images are included in your RAG corpus (e.g., diagrams in PDFs)?
- A. Use text-only embeddings
- B. Multimodal embeddings and/or FM parsing for pages with images
- C. Only Rekognition
- D. Skip image pages

<details><summary>Answer</summary>**B.** Multimodal embeddings or FM parsing preserves image context.</details>

---

**Q34.** Which is a true statement about costs when using RAG?
- A. RAG always reduces token costs to zero.
- B. Long retrieved contexts increase per-request token cost and latency.
- C. RAG eliminates the need for a vector store.
- D. RAG never requires re-indexing.

<details><summary>Answer</summary>**B.** Longer prompts cost more.</details>

---

**Q35.** Which is NOT an agent trace component?
- A. Rationale / thought
- B. Tool invocation input/output
- C. KB lookup result
- D. L2 regularization value

<details><summary>Answer</summary>**D.** L2 is a training-time hyperparameter, not an agent trace element.</details>

---

**Q36.** A model you fine-tuned keeps producing invalid JSON. Best fix?
- A. Lower temperature
- B. Use structured-output / tool use schemas, add validation + retry in code, and include JSON examples
- C. Disable guardrails
- D. Use a larger context window only

<details><summary>Answer</summary>**B.** Combine structure enforcement with robust code-side handling.</details>

---

**Q37.** Which is the BEST way to ensure answers are only from the retrieved context?
- A. Increase temperature
- B. Strong system prompt + citation requirement + contextual grounding guardrail
- C. Use fewer retrieved chunks
- D. Remove stop sequences

<details><summary>Answer</summary>**B.** Prompting + guardrail together.</details>

---

**Q38.** Which is a typical first-tier Bedrock fine-tune candidate when you want the smallest, fastest custom model?
- A. Claude Opus
- B. Claude Haiku, Amazon Nova Micro, or Llama 3 8B
- C. Stable Diffusion XL
- D. Titan Image Generator

<details><summary>Answer</summary>**B.** Smaller models fine-tune faster and are cheaper to serve.</details>

---

**Q39.** Which vector similarity metric is MOST commonly used for text embeddings?
- A. Cosine similarity
- B. Pearson correlation
- C. Edit distance
- D. Accuracy

<details><summary>Answer</summary>**A.** Cosine similarity is the default.</details>

---

**Q40.** Which Bedrock feature version-controls reusable prompts?
- A. Prompt Management
- B. Model Evaluation
- C. Model Customization
- D. Flows

<details><summary>Answer</summary>**A.** Prompt Management.</details>

---

**Q41.** Which BEST describes MMR (Max Marginal Relevance) in retrieval?
- A. Ensures only one result is returned
- B. Diversifies results by penalizing near-duplicates
- C. Increases learning rate
- D. Reduces the vector dimension

<details><summary>Answer</summary>**B.** MMR balances relevance with diversity.</details>

---

**Q42.** Which of the following is TRUE about tool (function) calling with the Converse API?
- A. Not supported on Bedrock
- B. You supply tool schemas; the model returns a structured tool_use block for your code to execute
- C. Models cannot ever refuse a tool call
- D. Only Claude supports it

<details><summary>Answer</summary>**B.** Converse supports tool use across multiple models.</details>

---

**Q43.** A team notices their RAG system recalls irrelevant chunks. Which is the BEST first step?
- A. Lower temperature
- B. Improve chunking strategy, add metadata filters, consider hybrid search and reranking
- C. Switch to a bigger model
- D. Fine-tune the model

<details><summary>Answer</summary>**B.** Retrieval quality is the root cause — fix ingestion and search first.</details>

---

**Q44.** Which of the following typically increases the context window of a RAG system **effectively**?
- A. Summarize earlier turns and reuse them as compressed context
- B. Increase temperature
- C. Increase embedding dimension only
- D. Remove citations

<details><summary>Answer</summary>**A.** Summarization / compression retains more semantic info per token.</details>

---

**Q45.** Which of the following is a valid evaluation of code generation?
- A. BLEU only
- B. Unit-test pass rate (e.g., HumanEval), compilation rate, human review
- C. ROUGE only
- D. Perplexity only

<details><summary>Answer</summary>**B.** Execution-based metrics are best for code.</details>

---

**Q46.** Which is the BEST approach to ensure an agent won't loop forever calling tools?
- A. Remove tool definitions
- B. Set a max iterations limit, tool timeouts, guardrails, and monitor traces
- C. Delete the agent each day
- D. Always use a different foundation model

<details><summary>Answer</summary>**B.** Safety net via limits + monitoring.</details>

---

**Q47.** Which of the following is TRUE about Bedrock and fine-tuned models' inference?
- A. Fine-tuned models are served without any reserved capacity.
- B. Most Bedrock custom models require **Provisioned Throughput** to serve.
- C. Fine-tuned models never support guardrails.
- D. Fine-tuned models are shared across all AWS customers.

<details><summary>Answer</summary>**B.** Provisioned throughput required for most custom model serving.</details>

---

**Q48.** Which is a valid motivation to choose a multimodal model (e.g., Claude 3 / Nova Pro)?
- A. Need to answer questions about both images (charts) and text together
- B. Need to compile code
- C. Need to transcribe audio
- D. Need to generate videos

<details><summary>Answer</summary>**A.** Multimodal = mixed-input understanding.</details>

---

**Q49.** Which is TRUE about Bedrock batch inference?
- A. It's real-time only.
- B. It's ~50% cheaper than on-demand and processes files in S3 asynchronously.
- C. It requires fine-tuning.
- D. It doesn't support Anthropic Claude.

<details><summary>Answer</summary>**B.** Batch mode is ~50% cheaper and async.</details>

---

**Q50.** Which of the following is the cheapest, fastest customization to try first when an FM doesn't behave right?
- A. Train from scratch
- B. Continued pretraining
- C. Prompt engineering (incl. few-shot, CoT, delimiters)
- D. Full fine-tuning

<details><summary>Answer</summary>**C.** Always try prompt engineering first.</details>
