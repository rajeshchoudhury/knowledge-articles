# Domain 5: Testing, Validation, and Troubleshooting

> **Exam Weight: 11% of total score (~7-8 questions)**
> This domain tests your ability to evaluate FM outputs, validate GenAI system quality, and systematically troubleshoot issues.

---

## Table of Contents

1. [Task 5.1: Implement Evaluation Systems](#task-51-implement-evaluation-systems)
2. [Task 5.2: Troubleshoot GenAI Applications](#task-52-troubleshoot-genai-applications)
3. [ASCII Diagrams](#ascii-diagrams)
4. [Exam Tips Summary](#exam-tips-summary)

---

## Task 5.1: Implement Evaluation Systems

Evaluation is the backbone of production GenAI. Without rigorous evaluation, you cannot know if your system is improving, degrading, or hallucinating. AWS provides both managed evaluation tools (Bedrock Model Evaluations) and the building blocks for custom evaluation pipelines.

---

### FM Output Quality Assessment

Every FM output should be evaluated across multiple quality dimensions. No single metric captures "quality."

#### The Four Pillars of Output Quality

| Dimension          | What It Measures                                         | How to Assess                              |
|--------------------|----------------------------------------------------------|--------------------------------------------|
| **Relevance**      | Does the response answer the actual question asked?       | Embedding similarity, human rating         |
| **Factual Accuracy** | Are the claims in the response true and verifiable?     | Fact-checking against knowledge base, golden datasets |
| **Consistency**    | Does the model give the same answer to the same question? | Repeated sampling, output diffing          |
| **Fluency**        | Is the response grammatically correct and well-structured?| Perplexity scoring, human rating           |

**Extended quality dimensions for production systems:**

- **Completeness**: Does the response address all parts of a multi-part question?
- **Conciseness**: Is the response appropriately brief without unnecessary padding?
- **Harmlessness**: Does the response avoid toxic, biased, or inappropriate content?
- **Groundedness**: Are the claims in the response supported by the provided context (critical for RAG)?
- **Instruction Following**: Did the model comply with formatting, length, and style instructions?

> **EXAM TIP:** The exam distinguishes between "factual accuracy" (is the claim true in the real world?) and "groundedness" (is the claim supported by the provided context?). A response can be factually accurate but not grounded (the fact is true but wasn't in the context), or grounded but not factually accurate (the context itself contains errors).

#### Automated Quality Metrics

**Reference-based metrics** (require a "correct" answer):
- **ROUGE** (Recall-Oriented Understudy for Gisting Evaluation): Measures n-gram overlap between generated and reference text. ROUGE-1 (unigrams), ROUGE-2 (bigrams), ROUGE-L (longest common subsequence).
- **BLEU** (Bilingual Evaluation Understudy): Measures precision of n-gram matches. Originally for translation, now widely used.
- **BERTScore**: Uses BERT embeddings to measure semantic similarity between generated and reference text. More robust than n-gram metrics.
- **Exact Match (EM)**: Binary — did the model produce the exact expected answer? Used for factoid QA.

**Reference-free metrics** (no "correct" answer needed):
- **Perplexity**: How "surprised" the model is by its own output. Lower = more fluent.
- **Embedding similarity**: Cosine similarity between query embedding and response embedding.
- **Self-consistency**: Generate multiple responses and measure agreement.

**GenAI-specific metrics:**
- **Hallucination rate**: % of claims not supported by context or knowledge base
- **Refusal rate**: % of queries the model refuses to answer
- **Token efficiency**: Useful information per token in the response

---

### Amazon Bedrock Model Evaluations

Amazon Bedrock provides a **managed evaluation service** that simplifies FM assessment.

#### Automatic Evaluation

Bedrock supports automatic evaluation using built-in metrics:

- **Accuracy**: Measures correctness against reference answers
- **Robustness**: Tests model performance under input perturbations
- **Toxicity**: Measures harmful content in responses

**How it works:**
1. Prepare an evaluation dataset (JSONL format) with prompts and optional reference answers
2. Upload to S3
3. Configure an evaluation job in Bedrock console or API
4. Select models to evaluate and metrics to compute
5. Bedrock runs the evaluation and produces a report

#### Human Evaluation

Bedrock also supports human evaluation workflows:

- Define evaluation criteria (relevance, accuracy, helpfulness, etc.)
- Configure a human workforce (Amazon SageMaker Ground Truth workforce)
- Distribute evaluation tasks to human reviewers
- Aggregate scores with inter-annotator agreement metrics

#### Model Comparison

Bedrock Model Evaluations support **side-by-side model comparison**:

- Evaluate multiple models against the same dataset
- Compare across all configured metrics
- Identify the best model for your specific use case
- Output includes per-metric breakdowns and aggregate scores

> **EXAM TIP:** Bedrock Model Evaluations is a key service to know. It supports both automatic and human evaluation, can compare multiple models, and produces structured reports. The evaluation dataset must be in JSONL format stored in S3.

---

### A/B Testing and Canary Testing of FMs

#### A/B Testing

Systematically compare two model configurations in production:

```
                    ┌──────────────────┐
                    │   User Traffic   │
                    └────────┬─────────┘
                             │
                    ┌────────┴─────────┐
                    │  Traffic Router  │
                    │  (50/50 or       │
                    │   custom split)  │
                    └────────┬─────────┘
                             │
                  ┌──────────┴──────────┐
                  ▼                     ▼
          ┌──────────────┐     ┌──────────────┐
          │  Variant A   │     │  Variant B   │
          │  (Current    │     │  (New model/ │
          │   model)     │     │   prompt)    │
          └──────┬───────┘     └──────┬───────┘
                 │                     │
                 ▼                     ▼
          ┌──────────────────────────────────┐
          │       Metrics Collection         │
          │  (Quality, Latency, Cost, User   │
          │   Satisfaction, Task Completion)  │
          └──────────────┬───────────────────┘
                         │
                         ▼
          ┌──────────────────────────────────┐
          │    Statistical Analysis          │
          │    (Significance Testing)        │
          └──────────────────────────────────┘
```

**What to A/B test:**
- Different foundation models (e.g., Claude 3 Sonnet vs. Claude 3.5 Sonnet)
- Different prompt templates
- Different inference parameters (temperature, top-p)
- Different RAG configurations (chunk size, top-k, reranking)
- Different system prompts

**Metrics to track in A/B tests:**
- Quality scores (automated + human)
- Latency (P50, P95)
- Cost per request
- User satisfaction (thumbs up/down, explicit ratings)
- Task completion rate
- Hallucination rate

#### Canary Testing

Deploy a new model version to a small percentage of traffic first:

1. Route 5% of traffic to the new model
2. Monitor all quality and performance metrics
3. If metrics are stable, gradually increase to 25%, 50%, 100%
4. If metrics degrade, roll back immediately

**Implementation on AWS:**
- Use API Gateway with canary release settings
- Use Lambda aliases with weighted routing
- Use CloudWatch alarms to trigger automatic rollback

> **EXAM TIP:** The exam may present a scenario where you need to safely deploy a new model version. Canary testing (small % of traffic first, with automatic rollback on metric degradation) is the safest approach. Know how API Gateway canary releases work.

---

### Multi-Model Evaluation and Cost-Performance Analysis

#### Comparing Multiple Models

Build a systematic evaluation framework:

```
┌──────────────────┐
│  Evaluation      │
│  Dataset         │
│  (500+ queries)  │
└────────┬─────────┘
         │
         ▼
┌──────────────────────────────────────────────────┐
│              Model Evaluation Matrix              │
│                                                   │
│  Model       │ Quality │ Latency │ Cost  │ Score │
│  ────────────┼─────────┼─────────┼───────┼───────│
│  Claude Opus │  9.2    │  2.1s   │ $15/M │  7.8  │
│  Claude Son. │  8.8    │  1.2s   │ $3/M  │  9.1  │
│  Claude Haiku│  7.5    │  0.4s   │ $0.25 │  9.4  │
│  Titan Expr. │  7.0    │  0.8s   │ $0.80 │  8.5  │
│  Llama 3 70B │  8.5    │  1.5s   │ $2.50 │  8.7  │
└──────────────────────────────────────────────────┘
```

#### Cost-Performance Analysis

Calculate a composite efficiency score:

```
Efficiency = (Quality_Score / Max_Quality) × w1
           + (1 - Latency / Max_Latency) × w2
           + (1 - Cost / Max_Cost) × w3
```

Where w1, w2, w3 are weights reflecting your priorities (e.g., 0.5, 0.3, 0.2).

This enables data-driven model selection rather than subjective preference.

---

### User-Centered Evaluation

Automated metrics have blind spots. Human evaluation captures what machines miss.

#### Feedback Interfaces

Design feedback collection into the user experience:

- **Binary feedback**: Thumbs up / thumbs down on every response
- **Likert scale**: 1-5 star ratings on specific dimensions (helpfulness, accuracy)
- **Free-text feedback**: "What was wrong with this response?"
- **Comparative feedback**: "Which response is better — A or B?"
- **Implicit feedback**: Did the user copy the response? Did they regenerate? Did they abandon the conversation?

#### Rating Systems

Structure ratings around specific quality dimensions:

```
┌─────────────────────────────────────────────┐
│  Rate this response:                         │
│                                              │
│  Accuracy:      ★ ★ ★ ★ ☆  (4/5)           │
│  Helpfulness:   ★ ★ ★ ★ ★  (5/5)           │
│  Completeness:  ★ ★ ★ ☆ ☆  (3/5)           │
│                                              │
│  [Flag as Harmful]  [Report Hallucination]   │
│                                              │
│  Optional comment: ________________________  │
└─────────────────────────────────────────────┘
```

#### Annotation Workflows

For systematic quality assessment:

1. **Sample selection**: Randomly sample N responses per day/week
2. **Annotator assignment**: Route to trained evaluators (internal team or MTurk via Ground Truth)
3. **Guidelines**: Provide detailed annotation guidelines with examples
4. **Inter-annotator agreement**: Measure Cohen's Kappa or Fleiss' Kappa to ensure consistency
5. **Aggregation**: Combine scores using majority vote or weighted average
6. **Feedback loop**: Use annotations to improve prompts, fine-tune models, or adjust guardrails

---

### Quality Assurance

#### Continuous Evaluation

Don't evaluate once and forget. Implement continuous evaluation:

- Run evaluation datasets against production on a schedule (daily/weekly)
- Track quality metrics over time as time series
- Detect degradation trends early
- Trigger alerts when quality drops below thresholds

#### Regression Testing

Before deploying any change (model update, prompt change, RAG config change):

1. Run the full evaluation suite against the current production configuration (baseline)
2. Run the same suite against the proposed change (candidate)
3. Compare results using statistical significance tests
4. Only deploy if the candidate is not statistically worse on any critical metric

**Regression test suite components:**
- Core functionality tests (does the model still answer basic questions correctly?)
- Edge case tests (does the model handle ambiguous or adversarial inputs?)
- Safety tests (does the model still refuse inappropriate requests?)
- Format compliance tests (does the model still follow output format instructions?)
- Domain-specific tests (does the model still get domain knowledge right?)

#### Automated Quality Gates

Implement gates in your CI/CD pipeline:

```
Code/Config Change
        │
        ▼
┌──────────────────┐
│  Build & Deploy  │
│  to Staging      │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐     ┌─────────────────────┐
│  Run Evaluation  │────▶│ Quality Gate Check   │
│  Suite           │     │                      │
└──────────────────┘     │ • Accuracy ≥ 0.85?   │
                         │ • Hallucination ≤ 5%? │
                         │ • Latency P95 ≤ 3s?   │
                         │ • No safety failures?  │
                         └──────────┬────────────┘
                                    │
                           ┌────────┴────────┐
                          Pass              Fail
                           │                  │
                           ▼                  ▼
                    Deploy to Prod      Block & Alert
                    (Canary first)      Engineering Team
```

> **EXAM TIP:** The exam values automated quality gates in CI/CD. Know that you should define threshold metrics (accuracy, hallucination rate, latency) and automatically block deployments that fail these checks.

---

### RAG Evaluation

Evaluating RAG systems requires assessing both the retrieval and generation components independently and together.

#### RAG Evaluation Dimensions

```
┌──────────────────────────────────────────────────┐
│                RAG Evaluation                     │
│                                                   │
│  ┌─────────────────┐    ┌──────────────────────┐ │
│  │   RETRIEVAL     │    │    GENERATION         │ │
│  │                 │    │                       │ │
│  │ • Precision     │    │ • Faithfulness        │ │
│  │   (% relevant   │    │   (grounded in        │ │
│  │    in top-k)    │    │    context?)           │ │
│  │                 │    │                       │ │
│  │ • Recall        │    │ • Answer Relevance    │ │
│  │   (% of all     │    │   (answers the        │ │
│  │    relevant     │    │    question?)          │ │
│  │    retrieved)   │    │                       │ │
│  │                 │    │ • Answer Correctness  │ │
│  │ • MRR (Mean     │    │   (factually right?)  │ │
│  │   Reciprocal    │    │                       │ │
│  │   Rank)         │    │ • Completeness        │ │
│  │                 │    │   (covers all          │ │
│  │ • nDCG          │    │    aspects?)           │ │
│  └─────────────────┘    └──────────────────────┘ │
│                                                   │
│  ┌──────────────────────────────────────────────┐ │
│  │             END-TO-END                        │ │
│  │  • Answer quality given the full pipeline     │ │
│  │  • Latency (retrieval + generation)           │ │
│  │  • Cost (embedding + search + generation)     │ │
│  └──────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────┘
```

#### Frameworks: RAGAS and Similar

**RAGAS (Retrieval Augmented Generation Assessment)**:
- Open-source framework for RAG evaluation
- Measures: Faithfulness, Answer Relevance, Context Precision, Context Recall
- Uses an LLM as the evaluator (LLM-as-a-Judge)

**Key RAGAS metrics:**
- **Faithfulness**: What fraction of the claims in the answer can be attributed to the provided context?
- **Answer Relevance**: How relevant is the answer to the question? (inverse: penalizes irrelevant padding)
- **Context Precision**: Are the relevant documents ranked higher in the retrieval results?
- **Context Recall**: How much of the ground truth answer is covered by the retrieved context?

---

### LLM-as-a-Judge Techniques

Use a powerful LLM to evaluate another LLM's outputs. This is increasingly the standard for scalable evaluation.

#### How LLM-as-a-Judge Works

```
┌──────────────┐     ┌──────────────┐     ┌─────────────────┐
│   Question   │     │  Model Under │     │  Judge Model    │
│   (Input)    │────▶│  Test (MUT)  │────▶│  (e.g., Claude  │
│              │     │  Response    │     │   Opus as judge) │
└──────────────┘     └──────────────┘     └────────┬────────┘
                                                    │
                                                    ▼
                                          ┌─────────────────┐
                                          │  Structured     │
                                          │  Score + Reason │
                                          │  (1-5 rating +  │
                                          │   explanation)  │
                                          └─────────────────┘
```

#### Judge Prompt Template (Example)

```
You are evaluating the quality of an AI assistant's response.

Question: {question}
Context provided: {context}
Assistant's response: {response}

Rate the response on the following criteria (1-5 scale):
1. Relevance: Does it answer the question?
2. Accuracy: Are the facts correct and grounded in the context?
3. Completeness: Does it address all parts of the question?
4. Clarity: Is it well-organized and easy to understand?

For each criterion, provide:
- A score (1-5)
- A one-sentence justification

Output as JSON.
```

#### Best Practices for LLM-as-a-Judge

- Use a more capable model as the judge than the model being evaluated
- Validate judge accuracy against human evaluations (calibration)
- Watch for position bias (judges may prefer the first option in A/B comparisons)
- Use multiple judge prompts and average scores for robustness
- Include few-shot examples in the judge prompt to calibrate scoring

> **EXAM TIP:** LLM-as-a-Judge is a scalable alternative to human evaluation. The exam may ask when to use it vs. human evaluation. Use LLM-as-a-Judge for continuous, high-volume evaluation. Use human evaluation for high-stakes decisions, calibration, and catching subtle quality issues that LLMs miss.

---

### Human Feedback Integration

#### Feedback Collection Methods

- **Explicit**: Thumbs up/down, star ratings, flagging
- **Implicit**: Regeneration requests, copy events, session abandonment, time-to-next-action
- **Structured**: Annotation tasks with defined rubrics
- **Unstructured**: Free-text comments, support tickets

#### Feedback-Driven Improvement Loop

```
Production Responses ──▶ Collect Feedback ──▶ Analyze Patterns
        ▲                                           │
        │                                           ▼
        │                                    Identify Issues
        │                                    (Bad prompts,
        │                                     wrong model,
        │                                     poor retrieval)
        │                                           │
        │                                           ▼
        └─────── Deploy Fix ◀──────────── Fix & Evaluate
                                          (Prompt change,
                                           rerank tuning,
                                           guardrail update)
```

---

### Retrieval Quality Testing

#### Relevance Scoring

Measure how relevant the retrieved documents are to the query:

- **Precision@K**: Of the top K retrieved documents, what fraction are relevant?
- **Recall@K**: Of all relevant documents in the corpus, what fraction appear in the top K?
- **Mean Reciprocal Rank (MRR)**: Average of 1/rank of the first relevant document
- **Normalized Discounted Cumulative Gain (nDCG)**: Accounts for the position of relevant documents (higher-ranked = better)

#### Context Matching

Ensure retrieved context matches the query intent:

- Compute embedding similarity between query and each retrieved chunk
- Set a minimum relevance threshold (e.g., cosine similarity > 0.7)
- Track how often retrieval falls below the threshold
- Test with adversarial queries designed to trick the retriever

#### Retrieval Latency

Monitor and optimize retrieval speed:

| Component              | Target Latency | Optimization                              |
|------------------------|---------------|-------------------------------------------|
| Embedding generation   | < 50ms        | Use smaller embedding model, batch embeddings |
| Vector search          | < 100ms       | HNSW index, pre-filtering, warm cache     |
| Reranking              | < 200ms       | Lightweight reranker, limit candidates     |
| Total retrieval        | < 350ms       | All of the above + connection pooling      |

---

### Agent Performance Evaluation

For AI agents (Bedrock Agents, custom agents):

#### Task Completion Rates

- Define a set of evaluation tasks with known correct outcomes
- Run the agent against each task
- Measure: binary success/failure, partial completion, and time to completion
- Track across agent versions

#### Tool Usage Effectiveness

- Is the agent selecting the right tools for each task?
- Is the agent providing correct parameters to tools?
- How many tool calls does it take to complete a task (efficiency)?
- What is the tool call error rate?

**Evaluation metrics:**
- **Tool Selection Accuracy**: % of tool calls where the correct tool was chosen
- **Parameter Accuracy**: % of tool calls with correct parameters
- **Step Efficiency**: Number of steps to complete task vs. optimal path
- **Recovery Rate**: % of tool call failures the agent recovers from

#### Bedrock Agent Evaluations

Amazon Bedrock provides evaluation capabilities for agents:
- Test agents against defined scenarios
- Measure task completion and accuracy
- Evaluate agent reasoning chains (trace logs)
- Compare different agent configurations

> **EXAM TIP:** Bedrock Agents produce trace logs that show the agent's reasoning at each step — which tool it considered, why it chose a specific action, and what it observed. These traces are essential for debugging agent behavior.

---

### Reporting Systems

#### Visualization Tools

Build evaluation dashboards with:
- **CloudWatch Dashboards**: Real-time operational metrics
- **Amazon QuickSight**: Business-level evaluation reports
- **Grafana**: Detailed technical dashboards with alerting
- **Custom notebooks**: Jupyter/SageMaker Studio for deep-dive analysis

#### Automated Reporting

Schedule periodic evaluation reports:
- Daily: Token usage, cost, error rates, latency
- Weekly: Quality metric trends, user feedback summary
- Monthly: Model comparison reports, cost-performance analysis
- On-demand: Triggered by deployment or incident

#### Model Comparison Visualizations

Present model evaluation results clearly:

```
Quality vs. Cost Scatter Plot:

Quality │
  9.5   │                              ● Opus
  9.0   │                   ● Sonnet
  8.5   │          ● Llama 70B
  8.0   │
  7.5   │  ● Haiku
  7.0   │        ● Titan Express
  6.5   │
        └──────────────────────────────────
        $0     $3      $6     $9    $12   $15
                    Cost per 1M tokens

        (Ideal: upper-left quadrant — high quality, low cost)
```

---

### Deployment Validation

#### Synthetic User Workflows

Before production deployment, run synthetic tests that simulate real user behavior:

1. **Happy path tests**: Common queries that should work perfectly
2. **Edge case tests**: Unusual inputs, long inputs, empty inputs
3. **Adversarial tests**: Prompt injection attempts, jailbreak attempts
4. **Load tests**: Simulate production-level traffic to validate performance
5. **Integration tests**: Verify all RAG sources, tools, and APIs are connected

#### Hallucination Rate Validation

Before deploying any model change:
- Run a hallucination-specific evaluation dataset
- Measure groundedness (% of claims supported by context)
- Compare to the current production model
- Set a maximum acceptable hallucination rate (e.g., < 5%)
- Block deployment if threshold is exceeded

#### Semantic Drift Detection

Monitor for semantic drift — changes in the meaning or style of model outputs over time:

- Embed model outputs periodically and track embedding distribution
- Use statistical tests (KL divergence, Wasserstein distance) to detect distribution shifts
- Compare output distributions across time windows
- Alert when drift exceeds a threshold

> **EXAM TIP:** Semantic drift detection is about noticing that a model's outputs are changing in character over time, even if individual responses look acceptable. This is critical after model updates or when using models that the provider updates in-place.

---

## Task 5.2: Troubleshoot GenAI Applications

Troubleshooting GenAI systems requires a different mindset than traditional software debugging. The system has a **non-deterministic component** (the FM) that cannot be unit-tested in the traditional sense.

---

### Context Window Overflow Diagnostics

#### The Problem

Every FM has a maximum context window. Exceeding it causes errors or silent truncation:

- **Hard failure**: API returns an error (e.g., "Input is too long")
- **Silent truncation**: Input is truncated, and the model responds based on incomplete context
- **Degraded quality**: Even when within limits, very long contexts can degrade response quality (the "lost in the middle" phenomenon)

#### Diagnostic Steps

```
Symptom: Model returns errors or low-quality responses
         for long conversations or large RAG contexts
    │
    ▼
Step 1: Check error logs for token limit errors
    │    (Bedrock returns specific error codes)
    │
    ▼
Step 2: Count actual tokens in the request
    │    (Use tiktoken or model-specific tokenizer)
    │
    ▼
Step 3: Compare to model's context window limit
    │    (Claude 3: 200K, Titan: varies, Llama: 8K-128K)
    │
    ▼
Step 4: Identify the largest contributor
    │    ├── System prompt too long?
    │    ├── Too many RAG chunks injected?
    │    ├── Conversation history too long?
    │    └── User input itself too long?
    │
    ▼
Step 5: Apply targeted fix
         ├── Compress system prompt
         ├── Reduce top-k for RAG retrieval
         ├── Implement sliding window for history
         └── Summarize older conversation turns
```

#### Dynamic Chunking

When context overflows, dynamically adjust chunk sizes:

- Monitor available token budget (context window - system prompt - conversation history - output reserve)
- Adjust the number and size of RAG chunks to fit within budget
- Prioritize higher-relevance chunks when space is limited
- Implement a token budget allocator:

```
Total Context Window:         200,000 tokens
 - System Prompt:               2,000 tokens
 - Conversation History:       10,000 tokens
 - Output Reserve (maxTokens):  4,000 tokens
 ─────────────────────────────────────────────
 = Available for RAG Context: 184,000 tokens
```

#### Truncation-Related Errors

Signs that truncation is causing problems:
- Model ignores information that was at the beginning of the context
- Responses are inconsistent with the provided instructions
- Model "forgets" earlier parts of a conversation
- RAG responses don't reflect the retrieved documents

**Fixes:**
- Place the most important information at the beginning AND end of the context (primacy/recency effect)
- Use explicit markers: "IMPORTANT: The following information is critical..."
- Reduce total context size to stay well within limits
- Test with different context lengths to find the quality degradation point

> **EXAM TIP:** The "lost in the middle" phenomenon means LLMs pay more attention to the beginning and end of their context window. If critical information is buried in the middle of a long context, the model may ignore it. Place key information at the start or end.

---

### FM Integration Issues

#### Error Logging

Implement comprehensive error logging for FM integrations:

**Common Bedrock error codes:**
| Error Code               | Cause                                | Fix                                    |
|--------------------------|--------------------------------------|----------------------------------------|
| `ThrottlingException`    | Rate limit exceeded                  | Implement backoff, request limit increase |
| `ValidationException`    | Malformed request                    | Check request schema, token limits     |
| `ModelTimeoutException`  | Inference took too long              | Reduce input size, use faster model    |
| `ModelNotReadyException` | Model not available                  | Retry, check model availability        |
| `AccessDeniedException`  | IAM permissions issue                | Check IAM policies, model access       |
| `ServiceQuotaExceededException` | Account limit hit              | Request quota increase                 |

**Logging best practices:**
- Log every FM call with request ID, model ID, token counts, latency, and status
- Redact sensitive content (PII) from logs
- Include correlation IDs to trace requests across services
- Log the full error response body for debugging

#### Request Validation

Validate before sending to the FM:
- Input does not exceed the model's context window
- Request body conforms to the model's API schema
- Required parameters are present (modelId, contentType, body)
- Content type matches the model's expected format

#### Response Analysis

When responses are unexpected:

1. **Check the raw response**: Is the response empty, truncated, or malformed?
2. **Check stop reason**: Did the model stop because of `max_tokens`, `stop_sequence`, or `end_turn`?
3. **Check token counts**: Did the response use all available output tokens (possibly truncated)?
4. **Check content filters**: Was any content filtered by guardrails?
5. **Compare with a known-good prompt**: Isolate whether the issue is the prompt, the model, or the system

---

### Prompt Engineering Problems

#### Prompt Testing Frameworks

Build a systematic approach to prompt testing:

```
┌─────────────────────────────────────────────────┐
│            Prompt Testing Framework              │
│                                                  │
│  1. Define test cases (input → expected output)  │
│  2. Run each test case against the prompt        │
│  3. Score outputs (automated + manual)           │
│  4. Calculate aggregate metrics                  │
│  5. Compare against baseline prompt              │
│  6. Track prompt versions over time              │
└─────────────────────────────────────────────────┘
```

**Test case categories:**
- **Positive tests**: Normal inputs that should produce good responses
- **Negative tests**: Inputs that should be refused or handled gracefully
- **Boundary tests**: Inputs at the edge of expected behavior
- **Adversarial tests**: Inputs designed to break the prompt (injection, jailbreaks)
- **Format tests**: Inputs that test output formatting compliance
- **Multilingual tests**: Inputs in different languages (if applicable)

#### Version Comparison

Maintain a prompt version history and compare systematically:

```
Prompt v1.0 (Baseline)
    │
    ├── Accuracy: 82%
    ├── Hallucination Rate: 12%
    ├── Format Compliance: 90%
    └── Avg. Response Length: 250 tokens

Prompt v1.1 (Added examples)
    │
    ├── Accuracy: 87% (+5%)     ✓ Improved
    ├── Hallucination Rate: 8% (-4%)  ✓ Improved
    ├── Format Compliance: 95% (+5%)  ✓ Improved
    └── Avg. Response Length: 280 tokens (+30)  ≈ Acceptable

Prompt v1.2 (Compressed system prompt)
    │
    ├── Accuracy: 86% (-1%)     ≈ Within variance
    ├── Hallucination Rate: 9% (+1%)  ≈ Within variance
    ├── Format Compliance: 94% (-1%)  ≈ Within variance
    └── Avg. Response Length: 220 tokens (-60)  ✓ More efficient

    Decision: Deploy v1.2 (similar quality, lower cost)
```

#### Systematic Prompt Refinement

When a prompt isn't working:

1. **Identify the failure mode**: What specifically is going wrong?
   - Wrong format? → Add output format instructions and examples
   - Hallucinating? → Add "only use the provided context" instructions
   - Too verbose? → Add length constraints
   - Ignoring instructions? → Restructure prompt, use delimiters, add emphasis

2. **Hypothesize a fix**: Make ONE change at a time

3. **Test the fix**: Run against evaluation dataset

4. **Measure the impact**: Did the metric improve? Did any other metric degrade?

5. **Iterate**: Repeat until quality targets are met

> **EXAM TIP:** The exam tests prompt debugging. If a model is producing incorrect outputs, the troubleshooting approach is: (1) examine the full prompt including system prompt and context, (2) check if instructions are clear and unambiguous, (3) add examples (few-shot), (4) add explicit constraints. Don't jump to fine-tuning as a first solution.

---

### Retrieval System Issues

#### Relevance Analysis

When RAG retrieval returns irrelevant results:

**Diagnostic checklist:**
1. **Embedding model mismatch**: Are you using the same embedding model for indexing and querying?
2. **Chunk size issues**: Are chunks too large (diluting relevance) or too small (losing context)?
3. **Metadata filtering**: Are filters too restrictive (missing relevant docs) or too loose (returning noise)?
4. **Index staleness**: Has the source data changed but the index hasn't been rebuilt?
5. **Query-document mismatch**: Are queries phrased very differently from how documents are written?

#### Embedding Quality Diagnostics

When embeddings aren't producing good similarity matches:

- **Visualization**: Use t-SNE or UMAP to visualize embedding clusters. Are semantically similar documents clustered together?
- **Similarity distribution**: Plot the distribution of similarity scores. Is there clear separation between relevant and irrelevant?
- **Cross-model comparison**: Try a different embedding model. Does it produce better retrieval?
- **Embedding dimension**: Some models produce better results with higher dimensions (e.g., 1024 vs. 384)

**Common embedding problems:**
| Problem                        | Symptom                                    | Fix                                    |
|--------------------------------|--------------------------------------------|----------------------------------------|
| Wrong embedding model          | Low similarity for clearly related texts   | Switch to a better model (Titan v2, Cohere) |
| Dimension mismatch             | API errors or zero results                 | Ensure index and query use same dimensions |
| Encoding issues                | Garbled text in embeddings                 | Fix text preprocessing (UTF-8, cleanup) |
| Domain mismatch                | General model fails on specialized content | Use domain-adapted embeddings or fine-tune |
| Stale embeddings               | New documents not appearing in results     | Rebuild index, implement incremental indexing |

#### Drift Monitoring

Monitor for embedding drift and retrieval degradation over time:

- Track average retrieval relevance scores (should remain stable)
- Monitor the distribution of similarity scores
- Compare retrieval quality on a golden dataset periodically
- Alert when average relevance drops below a threshold
- Retrigger index rebuilds when drift is detected

#### Vectorization Issues

Common vectorization problems and solutions:

- **Text too long**: Chunk text before embedding (most embedding models have a max input length of 512-8192 tokens)
- **Text too short**: Very short texts produce poor embeddings. Consider concatenating with metadata.
- **Special characters**: Clean text before embedding (remove HTML, special formatting)
- **Language mismatch**: Use multilingual embedding models for non-English content
- **Numerical data**: Embedding models handle natural language better than raw numbers. Convert numerical data to natural language descriptions.

---

### Prompt Maintenance

#### Template Testing

Treat prompts as code — version, test, and deploy them systematically:

```
┌──────────────────────────────────────────────────────┐
│             Prompt Lifecycle Management               │
│                                                       │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐          │
│  │  Develop  │──│  Test    │──│  Stage    │──Deploy  │
│  │  Prompt   │  │  Against │  │  (Canary  │  to Prod │
│  │  v2.0     │  │  Eval    │  │   Test)   │          │
│  └──────────┘  │  Dataset  │  └───────────┘          │
│                └──────────┘                           │
│                     │                                 │
│                     ▼                                 │
│              Quality Gate                             │
│              (Pass/Fail)                              │
└──────────────────────────────────────────────────────┘
```

**Template testing best practices:**
- Store prompt templates in version control (Git)
- Use parameterized templates with variable substitution
- Test with a variety of variable values, not just happy-path inputs
- Validate that template rendering produces valid prompts
- Test for prompt injection vulnerabilities in user-provided variables

#### CloudWatch Logs for Prompt Debugging

Use CloudWatch Logs Insights to analyze prompt behavior:

```
# Find all requests where the model returned an error
fields @timestamp, @message
| filter modelId = "anthropic.claude-3-sonnet-20240229-v1:0"
| filter statusCode != 200
| sort @timestamp desc
| limit 20

# Analyze token usage distribution
fields @timestamp, inputTokenCount, outputTokenCount
| stats avg(inputTokenCount), max(inputTokenCount),
        avg(outputTokenCount), max(outputTokenCount)
  by bin(1h)

# Find unusually long responses (potential issues)
fields @timestamp, outputTokenCount, requestId
| filter outputTokenCount > 4000
| sort outputTokenCount desc
| limit 50
```

#### X-Ray Observability Pipelines

Use AWS X-Ray for end-to-end tracing of GenAI requests:

```
┌──────────────────────────────────────────────────────────────────┐
│                    X-Ray Trace View                              │
│                                                                  │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ API Gateway          │ 2ms                                  │ │
│  └─────────────────────────────────────────────────────────────┘ │
│    ┌───────────────────────────────────────────────────────────┐ │
│    │ Lambda Handler      │ 1850ms                              │ │
│    └───────────────────────────────────────────────────────────┘ │
│      ┌─────────────────┐                                        │
│      │ DynamoDB Read    │ 12ms                                   │
│      └─────────────────┘                                        │
│      ┌────────────────────────┐                                 │
│      │ Embed Query (Titan)    │ 35ms                            │
│      └────────────────────────┘                                 │
│      ┌──────────────────────────────┐                           │
│      │ OpenSearch Vector Search     │ 85ms                      │
│      └──────────────────────────────┘                           │
│      ┌──────────────────────────────────────────────────────┐   │
│      │ Bedrock: Claude Invoke                │ 1650ms        │   │
│      └──────────────────────────────────────────────────────┘   │
│      ┌────────────┐                                             │
│      │ DynamoDB   │ 8ms                                         │
│      │ Write      │                                             │
│      └────────────┘                                             │
│                                                                  │
│  Total Latency: 1852ms                                           │
│  FM Invocation: 89% of total                                     │
└──────────────────────────────────────────────────────────────────┘
```

**X-Ray instrumentation for GenAI:**
- Add custom subsegments for each FM invocation
- Annotate with model ID, token counts, and quality metadata
- Create service maps showing dependencies
- Use trace groups to segment by request type or user tier

#### Schema Validation

Validate prompt templates and responses against schemas:

**Input validation:**
- Ensure all required template variables are provided
- Validate variable types and formats
- Check that the rendered prompt doesn't exceed token limits
- Verify that user input is sanitized (no prompt injection)

**Output validation:**
- Parse structured outputs (JSON, XML) and validate against a schema
- Check that required fields are present in the response
- Validate data types in extracted information
- Fall back to retry with a corrective prompt if validation fails

```python
# Pseudocode for output validation
response = invoke_model(prompt)
try:
    parsed = json.loads(response)
    validate(parsed, expected_schema)
    return parsed
except (json.JSONDecodeError, ValidationError) as e:
    corrective_prompt = f"""
    Your previous response was not valid JSON.
    Error: {e}
    Please respond with valid JSON matching this schema:
    {expected_schema}
    """
    return invoke_model(corrective_prompt)
```

> **EXAM TIP:** The exam may present a scenario where a GenAI application intermittently fails. The correct troubleshooting approach uses: (1) Model Invocation Logs to examine request/response payloads, (2) X-Ray traces to identify latency bottlenecks, (3) CloudWatch Logs Insights for pattern analysis, and (4) CloudWatch Alarms for proactive alerting. Know this full observability stack.

---

## ASCII Diagrams

### Complete Evaluation Pipeline

```
┌──────────────────────────────────────────────────────────────────┐
│                    EVALUATION PIPELINE                            │
│                                                                   │
│  ┌───────────────┐                                               │
│  │  Evaluation   │   ┌──── Automated Metrics ────────────────┐   │
│  │  Dataset      │   │                                       │   │
│  │  (S3, JSONL)  │   │  • ROUGE / BLEU / BERTScore          │   │
│  └───────┬───────┘   │  • Hallucination detection            │   │
│          │           │  • Format compliance                   │   │
│          ▼           │  • Embedding similarity                │   │
│  ┌───────────────┐   └────────────────────────┬──────────────┘   │
│  │  Run Against  │                            │                  │
│  │  Model(s)     │──────────────┐             │                  │
│  └───────┬───────┘              │             │                  │
│          │                      │             │                  │
│          ▼                      ▼             ▼                  │
│  ┌───────────────┐   ┌──────────────┐  ┌──────────────┐        │
│  │  Collect      │   │ LLM-as-      │  │ Human        │        │
│  │  Responses    │   │ Judge        │  │ Evaluation   │        │
│  └───────┬───────┘   │ Scoring      │  │ (Ground      │        │
│          │           └──────┬───────┘  │  Truth)      │        │
│          │                  │          └──────┬───────┘        │
│          │                  │                 │                │
│          └──────────────────┼─────────────────┘                │
│                             │                                   │
│                             ▼                                   │
│                    ┌──────────────────┐                         │
│                    │  Aggregate       │                         │
│                    │  Scores &        │                         │
│                    │  Generate Report │                         │
│                    └────────┬─────────┘                         │
│                             │                                   │
│                    ┌────────┴────────┐                          │
│                    │                 │                          │
│                    ▼                 ▼                          │
│           ┌──────────────┐  ┌──────────────┐                   │
│           │  Dashboard   │  │  Quality     │                   │
│           │  (QuickSight │  │  Gate        │                   │
│           │   / Grafana) │  │  (Pass/Fail) │                   │
│           └──────────────┘  └──────────────┘                   │
└──────────────────────────────────────────────────────────────────┘
```

### Troubleshooting Decision Tree

```
                    ┌──────────────────────┐
                    │  GenAI App Problem   │
                    │  Reported            │
                    └──────────┬───────────┘
                               │
                    ┌──────────┴───────────┐
                    │  What type of issue? │
                    └──────────┬───────────┘
                               │
          ┌────────────────────┼────────────────────┐
          ▼                    ▼                    ▼
   ┌──────────────┐   ┌──────────────┐   ┌──────────────────┐
   │ ERROR /      │   │ QUALITY      │   │ PERFORMANCE      │
   │ FAILURE      │   │ DEGRADATION  │   │ (Latency/Cost)   │
   └──────┬───────┘   └──────┬───────┘   └──────┬───────────┘
          │                  │                    │
          ▼                  ▼                    ▼
   ┌──────────────┐   ┌──────────────┐   ┌──────────────────┐
   │ Check Bedrock│   │ Compare to   │   │ Check X-Ray      │
   │ error code   │   │ baseline     │   │ traces for       │
   │              │   │ (golden      │   │ latency          │
   │ Throttle?    │   │  dataset)    │   │ breakdown        │
   │ Validation?  │   │              │   │                  │
   │ Timeout?     │   │ Which metric │   │ FM invocation    │
   │ Auth?        │   │ degraded?    │   │ dominant?        │
   └──────┬───────┘   └──────┬───────┘   └──────┬───────────┘
          │                  │                    │
          ▼                  ▼                    ▼
   ┌──────────────┐   ┌──────────────┐   ┌──────────────────┐
   │ THROTTLE:    │   │ ACCURACY:    │   │ FM LATENCY:      │
   │ • Backoff    │   │ • Check      │   │ • Smaller model  │
   │ • Provision  │   │   prompt     │   │ • Shorter prompt │
   │   throughput │   │   changes    │   │ • Streaming      │
   │ • Reduce     │   │ • Check      │   │ • Caching        │
   │   concurrency│   │   retrieval  │   │                  │
   │              │   │ • Check model│   │ RETRIEVAL:       │
   │ VALIDATION:  │   │   version    │   │ • Index tuning   │
   │ • Check      │   │              │   │ • Pre-filtering  │
   │   token      │   │ HALLUCIN.:   │   │ • Cache results  │
   │   limits     │   │ • Grounding  │   │                  │
   │ • Check      │   │   check     │   │ INFRA:           │
   │   request    │   │ • Context    │   │ • Right-size     │
   │   format     │   │   quality   │   │ • Auto-scale     │
   │              │   │ • Guardrails │   │ • Region         │
   │ TIMEOUT:     │   │              │   │   proximity      │
   │ • Reduce     │   │ CONSISTENCY: │   │                  │
   │   input      │   │ • Lower      │   │ COST:            │
   │ • Faster     │   │   temperature│   │ • Model routing  │
   │   model      │   │ • Seed       │   │ • Caching        │
   │ • Streaming  │   │   parameter  │   │ • Batch where    │
   └──────────────┘   └──────────────┘   │   possible       │
                                         └──────────────────┘
```

### RAG Troubleshooting Flow

```
              ┌─────────────────────┐
              │  RAG Response is    │
              │  Incorrect          │
              └──────────┬──────────┘
                         │
              ┌──────────┴──────────┐
              │  Is the correct     │
              │  info in the        │
              │  knowledge base?    │
              └──────────┬──────────┘
                    ┌────┴────┐
                   Yes       No
                    │         │
                    ▼         ▼
         ┌──────────────┐  ┌──────────────────┐
         │ Was correct  │  │ INGESTION ISSUE  │
         │ doc retrieved?│  │ • Add missing    │
         └──────┬───────┘  │   documents      │
           ┌────┴────┐    │ • Check crawlers  │
          Yes       No    │ • Update sources  │
           │         │    └──────────────────┘
           ▼         ▼
    ┌────────────┐ ┌──────────────────┐
    │ GENERATION │ │ RETRIEVAL ISSUE  │
    │ ISSUE      │ │                  │
    │            │ │ • Check embedding│
    │ • Improve  │ │   model          │
    │   prompt   │ │ • Adjust chunk   │
    │ • Add      │ │   size           │
    │   grounding│ │ • Tune top-k     │
    │   instruct.│ │ • Add reranking  │
    │ • Use      │ │ • Fix metadata   │
    │   guardrails│ │   filters       │
    │ • Reduce   │ │ • Rebuild index  │
    │   context  │ │ • Try hybrid     │
    │   noise    │ │   search         │
    └────────────┘ └──────────────────┘
```

---

## Exam Tips Summary

### Quick-Fire Exam Tips for Domain 5

1. **Bedrock Model Evaluations**: Supports both automatic (metrics-based) and human evaluation. Evaluation datasets are JSONL on S3. Can compare multiple models side-by-side.

2. **LLM-as-a-Judge**: Use a more capable model to evaluate a less capable one. Validate against human judgments. Watch for position bias in A/B comparisons.

3. **RAG evaluation dimensions**: Retrieval (precision, recall, MRR, nDCG) and Generation (faithfulness, relevance, correctness). Evaluate both independently AND end-to-end.

4. **Quality gates in CI/CD**: Define threshold metrics, run evaluation suites automatically, block deployments that fail quality checks. This is a common exam pattern.

5. **A/B testing vs. Canary testing**: A/B = compare two variants simultaneously with split traffic. Canary = gradually roll out a new version to increasing % of traffic.

6. **Context window overflow**: Check token counts, identify the largest contributor (system prompt, RAG chunks, history), and apply targeted compression. Know the "lost in the middle" phenomenon.

7. **Troubleshooting stack**: Model Invocation Logs (request/response content) + X-Ray (latency tracing) + CloudWatch Logs Insights (pattern analysis) + CloudWatch Alarms (proactive alerts).

8. **Prompt debugging approach**: (1) Examine full prompt, (2) Check if instructions are clear, (3) Add examples, (4) Add constraints. Don't jump to fine-tuning.

9. **Embedding issues**: Same model for indexing and querying, check dimension consistency, validate with visualization (t-SNE), rebuild stale indices.

10. **Agent debugging**: Use Bedrock Agent trace logs to see the reasoning chain. Check tool selection accuracy, parameter correctness, and step efficiency.

11. **Hallucination detection**: Golden datasets, cross-model verification, groundedness scoring against provided context. Track as a continuous metric, not a one-time check.

12. **Regression testing**: Run full evaluation suite BEFORE and AFTER any change. Compare using statistical significance. Block deployment if any critical metric degrades.

13. **Semantic drift**: Monitor output embedding distributions over time. Use KL divergence or Wasserstein distance to detect shifts. Alert and investigate.

14. **Response validation**: Parse and validate structured outputs against schemas. Implement retry with corrective prompts on validation failure.

15. **Human feedback loop**: Collect explicit (ratings) + implicit (regeneration, abandonment) feedback. Analyze patterns. Feed insights back into prompt optimization and model selection.

16. **Retrieval debugging**: Check embedding model consistency, chunk size appropriateness, metadata filter accuracy, index freshness, and query-document vocabulary alignment.

17. **X-Ray for GenAI**: FM invocation is typically 80-95% of total latency. Add custom subsegments, annotate with token counts and model IDs. Use service maps for dependency visualization.

---

### Domain 5 Study Checklist

Before the exam, make sure you can:

- [ ] Explain the difference between reference-based and reference-free evaluation metrics
- [ ] Configure a Bedrock Model Evaluation job (automatic and human)
- [ ] Design an A/B testing setup for comparing two FM configurations
- [ ] Implement quality gates in a CI/CD pipeline for GenAI deployments
- [ ] Evaluate a RAG system across both retrieval and generation dimensions
- [ ] Use LLM-as-a-Judge with proper calibration and bias mitigation
- [ ] Diagnose context window overflow and apply targeted fixes
- [ ] Troubleshoot retrieval issues (embedding mismatch, chunk size, index staleness)
- [ ] Use Model Invocation Logs, X-Ray, and CloudWatch for FM troubleshooting
- [ ] Implement continuous evaluation with regression testing and drift detection
- [ ] Design a human feedback collection and analysis system
- [ ] Validate structured outputs with schema checking and corrective retry

---

> **Final Thought for Domain 5:** This domain is about building confidence that your GenAI system is working correctly and staying that way over time. The exam rewards candidates who think about evaluation as a continuous process, not a one-time activity. Every change (model update, prompt revision, RAG config tweak) needs evaluation before and after. And when things go wrong, systematic troubleshooting with the right AWS observability tools (Model Invocation Logs, X-Ray, CloudWatch) is the path to resolution. Think: Evaluate → Deploy → Monitor → Troubleshoot → Improve → Repeat.
