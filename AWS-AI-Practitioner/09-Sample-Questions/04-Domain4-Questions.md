# Domain 4 — Sample Questions (Responsible AI)

---

**Q1.** Which AWS service provides **pre-training** bias metrics on a dataset?
- A. Amazon Macie
- B. SageMaker Clarify
- C. Amazon A2I
- D. CloudWatch

<details><summary>Answer</summary>**B.** Clarify offers 7+ pre-training bias metrics and 13+ post-training metrics.</details>

---

**Q2.** A company wants to document the intended use, training data, and performance of a custom fraud detection model. Which artifact?
- A. AI Service Card
- B. SageMaker Model Card
- C. Personalize recipe
- D. Glue Data Catalog entry

<details><summary>Answer</summary>**B.** Model Cards describe customer-built models; AI Service Cards describe AWS services.</details>

---

**Q3.** Which Bedrock Guardrails feature automatically detects and masks PII like SSN, credit card, or email?
- A. Denied topics
- B. Word filters
- C. Sensitive information filters
- D. Contextual grounding check

<details><summary>Answer</summary>**C.** Sensitive information filters detect PII (built-in + custom regex) and can block or mask.</details>

---

**Q4.** Which is a typical AWS responsible AI dimension?
- A. Retries
- B. Explainability
- C. Autoscaling
- D. Throughput

<details><summary>Answer</summary>**B.** Explainability (plus fairness, privacy, safety, controllability, veracity, transparency, governance).</details>

---

**Q5.** Which AWS service can detect PII in S3 buckets at scale to audit training data?
- A. Amazon Macie
- B. AWS Config
- C. CloudTrail
- D. Amazon Polly

<details><summary>Answer</summary>**A.** Macie classifies and finds PII in S3.</details>

---

**Q6.** When a business team asks for "explanations" of per-row predictions from a tabular classifier, which is the best technique?
- A. SHAP values via SageMaker Clarify
- B. CloudWatch metrics
- C. Confusion matrix
- D. BLEU score

<details><summary>Answer</summary>**A.** SHAP via Clarify for per-prediction attributions.</details>

---

**Q7.** Which of the following is TRUE about **AI Service Cards**?
- A. You author them for your custom models.
- B. AWS publishes them to describe an AWS AI service's intended use and limitations.
- C. They are only for Bedrock.
- D. They replace Guardrails.

<details><summary>Answer</summary>**B.** AWS publishes AI Service Cards for its services.</details>

---

**Q8.** A low-confidence prediction in a medical billing system must be reviewed by a human. Which service?
- A. Amazon A2I
- B. SageMaker Ground Truth
- C. CloudTrail
- D. Comprehend Medical

<details><summary>Answer</summary>**A.** Amazon Augmented AI injects human review.</details>

---

**Q9.** Which of the following is the BEST mitigation for a biased training dataset that under-represents a group?
- A. Add noise to labels
- B. Collect more data from the under-represented group or apply re-weighting
- C. Reduce learning rate
- D. Increase batch size

<details><summary>Answer</summary>**B.** Fix the data distribution, or re-weight.</details>

---

**Q10.** Which term refers to a model output that's fluent and confident but factually wrong?
- A. Perplexity
- B. Hallucination
- C. Drift
- D. Overfit

<details><summary>Answer</summary>**B.** Hallucination.</details>

---

**Q11.** Which of the following is NOT a Guardrails content-filter category?
- A. Hate
- B. Sexual
- C. Prompt attacks
- D. Latency

<details><summary>Answer</summary>**D.** Categories include hate, insults, sexual, violence, misconduct, prompt attacks.</details>

---

**Q12.** A team wants to ensure responses are consistent with a defined HR policy (rule-based). Which Guardrails feature?
- A. Contextual grounding check
- B. Automated Reasoning check
- C. Word filter
- D. Denied topic

<details><summary>Answer</summary>**B.** Automated Reasoning checks claims against formal rules.</details>

---

**Q13.** Which of these enables bias drift detection over time in a deployed model?
- A. SageMaker Model Monitor (bias drift)
- B. Amazon Polly
- C. Amazon Comprehend
- D. AWS Budgets

<details><summary>Answer</summary>**A.** Model Monitor includes bias drift using Clarify.</details>

---

**Q14.** Which is TRUE about disparate impact (80% rule)?
- A. Protected group rate must be ≥ 80% of the reference group rate
- B. Protected group rate must be ≤ 80% of the reference group rate
- C. It's about precision
- D. It applies only to image models

<details><summary>Answer</summary>**A.** Selection rate ratio must be ≥ 80%.</details>

---

**Q15.** Which of the following is TRUE about explainability for LLMs?
- A. Chain-of-thought is a guaranteed accurate explanation of the model's internal reasoning.
- B. Explainability for LLMs is hard; citations, attention maps, and CoT are partial tools.
- C. SHAP explains every LLM decision.
- D. Perplexity explains predictions.

<details><summary>Answer</summary>**B.** LLMs are hard to explain precisely; we use partial tools.</details>

---

**Q16.** Which technique reduces the chance of prompt injection from retrieved documents?
- A. Embed retrieved text directly as part of the system prompt
- B. Treat retrieved content as untrusted; wrap in delimiters; apply Guardrails
- C. Increase temperature
- D. Remove guardrails

<details><summary>Answer</summary>**B.** Defense in depth.</details>

---

**Q17.** Which of these is a valid **fairness** metric?
- A. Equalized odds
- B. BLEU
- C. RMSE
- D. Perplexity

<details><summary>Answer</summary>**A.** Equalized odds is a group-fairness metric.</details>

---

**Q18.** Which is the BEST fit to detect PHI in medical text for a HIPAA workflow?
- A. Amazon Comprehend Medical
- B. Amazon Polly
- C. Amazon Transcribe
- D. Amazon Rekognition

<details><summary>Answer</summary>**A.** Comprehend Medical detects PHI.</details>

---

**Q19.** Which is a typical consequence of lack of transparency?
- A. Improved model size
- B. Regulatory and trust issues
- C. Better training speed
- D. Lower memory usage

<details><summary>Answer</summary>**B.** Lack of transparency drives compliance and user trust issues.</details>

---

**Q20.** Which is TRUE about AWS AI Service Cards?
- A. Only available for Bedrock models
- B. Cover a range of services (Rekognition, Textract, Transcribe, Comprehend, Titan, Nova, Guardrails, Q Business, etc.)
- C. Are auto-generated per customer
- D. Are the same as Model Cards

<details><summary>Answer</summary>**B.** Multiple services have service cards.</details>

---

**Q21.** Which is a primary AWS tool to manage and centralize bias/explainability reports and model documentation?
- A. SageMaker ML Governance dashboards (Model Cards + Model Registry)
- B. CloudTrail
- C. Amazon Polly
- D. AWS Config

<details><summary>Answer</summary>**A.** ML Governance aggregates cards and registry states.</details>

---

**Q22.** Which dimension of responsible AI covers "ability to supervise, steer, and disable the system"?
- A. Fairness
- B. Controllability
- C. Explainability
- D. Veracity

<details><summary>Answer</summary>**B.** Controllability.</details>

---

**Q23.** Which of these dimensions addresses "accurate and reliable outputs under distribution shift"?
- A. Veracity & Robustness
- B. Privacy
- C. Controllability
- D. Transparency

<details><summary>Answer</summary>**A.** Veracity & Robustness.</details>

---

**Q24.** A retail company wants to ensure GenAI responses do not mention competitor products. Best Guardrail feature?
- A. Word filter + Denied topic
- B. Temperature
- C. Streaming
- D. Batch inference

<details><summary>Answer</summary>**A.** Word filter for specific terms; denied topic for broader exclusions.</details>

---

**Q25.** Which describes **ISO/IEC 42001**?
- A. An AWS proprietary certification
- B. An international AI Management System standard
- C. A Bedrock model
- D. A SageMaker feature

<details><summary>Answer</summary>**B.** ISO 42001 = AI management standard; AWS is certified.</details>

---

**Q26.** Which of these is a **sensitive information filter** action in Guardrails?
- A. BLOCK or MASK
- B. Zero-shot learning
- C. BM25
- D. Temperature

<details><summary>Answer</summary>**A.** Filters can block or mask PII with placeholders.</details>

---

**Q27.** Why is model distillation sometimes considered a responsible-AI benefit?
- A. It increases hallucination
- B. It makes models smaller, faster, cheaper; enables edge/on-prem and lower carbon
- C. It removes fairness issues
- D. It stops training

<details><summary>Answer</summary>**B.** Efficient models have operational and environmental benefits.</details>

---

**Q28.** Which is a proper scope for human-in-the-loop?
- A. Every single inference, always
- B. High-stakes or low-confidence decisions where human judgment adds value
- C. Never
- D. Only training

<details><summary>Answer</summary>**B.** HITL is targeted, not universal.</details>

---

**Q29.** Which of these is TRUE about Clarify for Foundation Models?
- A. It doesn't evaluate toxicity.
- B. It can evaluate toxicity, bias, stereotyping, factual knowledge, robustness on FMs.
- C. It trains models from scratch.
- D. It runs only in Bedrock.

<details><summary>Answer</summary>**B.** Clarify FM evaluation includes several LLM-centric metrics.</details>

---

**Q30.** Which is a component of **responsible AI governance**?
- A. Random model deployments
- B. Risk assessment, approval workflows, audit trail
- C. Hidden prompts
- D. No monitoring

<details><summary>Answer</summary>**B.** Governance = process + oversight + traceability.</details>

---

**Q31.** Which is the BEST approach when users can submit text that may contain PII you must not log?
- A. Log everything
- B. Sanitize/redact PII before logging (Comprehend / Guardrails) and encrypt logs
- C. Disable guardrails
- D. Increase verbosity

<details><summary>Answer</summary>**B.** Sanitize and encrypt — defense in depth.</details>

---

**Q32.** Which is NOT typically a responsible-AI safeguard for an LLM agent with tools?
- A. User confirmation on destructive actions
- B. Least-privilege tool IAM roles
- C. Unlimited tool-call iterations
- D. Output validation and monitoring

<details><summary>Answer</summary>**C.** Cap iterations.</details>

---

**Q33.** Which is the BEST technique to **mitigate bias** after deployment?
- A. Monitor fairness metrics over time and retrain or adjust thresholds if drift occurs
- B. Ignore it unless users complain
- C. Increase temperature
- D. Delete monitoring

<details><summary>Answer</summary>**A.** Active monitoring and remediation.</details>

---

**Q34.** A model was trained using historical hiring decisions that show gender bias. Best first step?
- A. Retrain with the same data
- B. Audit and remediate the data (remove biased labels; add representative examples); consider fairness-aware training
- C. Encrypt the dataset
- D. Switch instance type

<details><summary>Answer</summary>**B.** Data bias requires data-level fixes.</details>

---

**Q35.** Which is NOT a Responsible AI dimension commonly associated with AWS?
- A. Fairness
- B. Safety
- C. Transparency
- D. SEO Optimization

<details><summary>Answer</summary>**D.** Not an AI dimension.</details>

---

**Q36.** Which service is best for discovery of sensitive data in S3 training corpora?
- A. Amazon Macie
- B. Amazon Comprehend
- C. AWS CloudTrail
- D. AWS Glue

<details><summary>Answer</summary>**A.** Macie for S3-level discovery.</details>

---

**Q37.** Which best describes the relationship between **transparency** and **explainability**?
- A. Identical
- B. Transparency is about documentation of system behavior; explainability is about reasoning behind specific predictions
- C. Transparency requires GPUs; explainability doesn't
- D. They are unrelated

<details><summary>Answer</summary>**B.** Transparency = docs; explainability = prediction rationale.</details>

---

**Q38.** Which prevents a generative agent from producing output on a broad category of topics (e.g., "no investment advice")?
- A. Denied topic in Guardrails
- B. Learning rate decay
- C. Stop sequences
- D. Automatic model tuning

<details><summary>Answer</summary>**A.** Denied topics are topic-level blocks.</details>

---

**Q39.** Which of these is a lawful basis under GDPR?
- A. Consent
- B. Contract
- C. Legitimate interest
- D. All of the above

<details><summary>Answer</summary>**D.** GDPR recognizes six lawful bases.</details>

---

**Q40.** Which of these should be captured in a SageMaker Model Card?
- A. Intended use, out-of-scope uses, training data, evaluation results, caveats
- B. The CEO's calendar
- C. Training instance billing codes
- D. Only hyperparameters

<details><summary>Answer</summary>**A.** Standard Model Card content.</details>

---

**Q41.** Which is TRUE about Bedrock's contextual grounding check?
- A. Only runs on training data
- B. Scores response groundedness and query relevance against provided reference material
- C. Replaces fine-tuning
- D. Does not require source context

<details><summary>Answer</summary>**B.** Grounding + relevance scoring against context.</details>

---

**Q42.** Which is TRUE about Nova Canvas / Reel outputs?
- A. They contain invisible watermarks by default
- B. They are unwatermarked
- C. They are always unlabeled
- D. They require provisioning S3 buckets for every user

<details><summary>Answer</summary>**A.** Amazon's image/video generators include invisible watermarks.</details>

---

**Q43.** An organization wants to standardize AI governance with an ISMS-like system specifically for AI. Which framework/standard?
- A. NIST AI RMF (voluntary framework) or ISO/IEC 42001 (certifiable management standard)
- B. HIPAA
- C. PCI DSS
- D. CCPA

<details><summary>Answer</summary>**A.** Both are appropriate; ISO 42001 is the AI management system standard.</details>

---

**Q44.** Which action is typical to reduce feedback-loop bias in a recommender?
- A. Only expose user to top recommendations
- B. Inject exploration (diverse recommendations), cap exposure, monitor demographic parity of exposure
- C. Increase training frequency only
- D. Disable monitoring

<details><summary>Answer</summary>**B.** Exploration + monitoring reduces runaway feedback loops.</details>

---

**Q45.** Which of these is a valid RAG risk that Guardrails help mitigate?
- A. Slow indexing
- B. Retrieval bringing malicious instructions that hijack the LLM
- C. Vector DB sharding
- D. Embedding dimensionality

<details><summary>Answer</summary>**B.** Prompt attacks / indirect injection via retrieved docs.</details>

---

**Q46.** Which is the BEST practice for training-data provenance?
- A. Record source, license, consent, version, and data card per dataset
- B. Rely on memory
- C. Use only unstructured blobs
- D. Discard after training

<details><summary>Answer</summary>**A.** Lineage + data cards + licensing tracking.</details>

---

**Q47.** Which of these can LLM-as-a-judge evaluations do?
- A. Rate outputs against a rubric at scale
- B. Automatically debug code
- C. Render images
- D. Retrain the model

<details><summary>Answer</summary>**A.** Scalable rubric-based grading.</details>

---

**Q48.** Which is TRUE about the interplay of Bedrock Guardrails and Agents?
- A. Guardrails cannot be used with agents.
- B. Guardrails can be attached to an agent and evaluated at each FM step.
- C. Guardrails replace the agent's instructions.
- D. Agents are immune to prompt injection.

<details><summary>Answer</summary>**B.** Guardrails applied at each step of the agent loop.</details>

---

**Q49.** Which artifact helps auditors confirm a model's pre-approval review?
- A. SageMaker Model Registry approval history + Model Card
- B. EC2 AMI
- C. S3 versioning
- D. CloudFront distribution

<details><summary>Answer</summary>**A.** Registry + Model Card provide audit evidence.</details>

---

**Q50.** Which is the BEST way to address "right to be forgotten" in an LLM system with RAG?
- A. Impossible; LLMs remember everything
- B. Delete documents from the KB and re-index; retain deletion logs; if PII was fine-tuned in, plan re-train without that data
- C. Increase temperature
- D. Disable guardrails

<details><summary>Answer</summary>**B.** RAG makes right-to-erasure tractable; fine-tuned data is harder.</details>
