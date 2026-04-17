# AWS Certified AI Practitioner (AIF-C01) — Complete Study Package

> A comprehensive, architect-level study package covering every aspect of the AWS Certified AI Practitioner exam. If you work through every article, diagram, flashcard, code sample, and practice question here, you will pass with ease.

---

## Exam At A Glance

| Item | Detail |
|---|---|
| **Exam code** | AIF-C01 |
| **Level** | Foundational |
| **Length** | 90 minutes |
| **Number of questions** | 65 (50 scored + 15 unscored) |
| **Question formats** | Multiple choice, multiple response, ordering, matching, case study |
| **Passing score** | 700 / 1000 (scaled) |
| **Cost** | USD $100 |
| **Delivery** | Pearson VUE testing center or online proctored |
| **Prerequisite** | None (recommended: 6 months of general AWS exposure) |
| **Validity** | 3 years |

---

## Exam Domains & Weights

| # | Domain | Weight |
|---|--------|--------|
| 1 | Fundamentals of AI and ML | **20%** |
| 2 | Fundamentals of Generative AI | **24%** |
| 3 | Applications of Foundation Models | **28%** |
| 4 | Guidelines for Responsible AI | **14%** |
| 5 | Security, Compliance, and Governance for AI Solutions | **14%** |

---

## Package Contents

### 0. [Study Plan](./00-Study-Plan.md)
6-week, 4-week, and 2-week accelerated plans with daily tasks, checkpoints and self-assessments.

### 1. Domain 1 — Fundamentals of AI and ML
- [01 — AI, ML, Deep Learning Concepts](./01-Domain1-AI-ML-Fundamentals/01-AI-ML-Concepts.md)
- [02 — Types of Machine Learning](./01-Domain1-AI-ML-Fundamentals/02-ML-Types.md)
- [03 — ML Development Lifecycle (MLOps)](./01-Domain1-AI-ML-Fundamentals/03-ML-Lifecycle.md)
- [04 — AWS Managed AI Services Catalog](./01-Domain1-AI-ML-Fundamentals/04-AWS-AI-Services.md)
- [05 — Amazon SageMaker Deep Dive](./01-Domain1-AI-ML-Fundamentals/05-SageMaker-Overview.md)

### 2. Domain 2 — Fundamentals of Generative AI
- [01 — Generative AI Fundamentals](./02-Domain2-Generative-AI/01-GenAI-Fundamentals.md)
- [02 — Foundation Models & Transformer Architecture](./02-Domain2-Generative-AI/02-Foundation-Models.md)
- [03 — Amazon Bedrock Deep Dive](./02-Domain2-Generative-AI/03-Amazon-Bedrock.md)
- [04 — Prompt Engineering](./02-Domain2-Generative-AI/04-Prompt-Engineering.md)
- [05 — Generative AI Use Cases](./02-Domain2-Generative-AI/05-Use-Cases.md)

### 3. Domain 3 — Applications of Foundation Models
- [01 — Model Selection Criteria](./03-Domain3-Foundation-Models/01-Model-Selection.md)
- [02 — Retrieval Augmented Generation (RAG)](./03-Domain3-Foundation-Models/02-RAG.md)
- [03 — Fine-Tuning & Customization](./03-Domain3-Foundation-Models/03-Fine-Tuning.md)
- [04 — Evaluation & Metrics](./03-Domain3-Foundation-Models/04-Evaluation.md)
- [05 — Agents and Orchestration](./03-Domain3-Foundation-Models/05-Agents.md)

### 4. Domain 4 — Guidelines for Responsible AI
- [01 — Responsible AI Principles](./04-Domain4-Responsible-AI/01-Responsible-AI.md)
- [02 — Bias, Fairness & Explainability](./04-Domain4-Responsible-AI/02-Bias-Fairness.md)
- [03 — Transparency & Model Cards](./04-Domain4-Responsible-AI/03-Transparency.md)
- [04 — AWS Responsible AI Tools (Guardrails, Clarify, etc.)](./04-Domain4-Responsible-AI/04-AWS-Tools.md)

### 5. Domain 5 — Security, Compliance, Governance
- [01 — Security for AI Workloads](./05-Domain5-Security-Governance/01-Security.md)
- [02 — Compliance Frameworks](./05-Domain5-Security-Governance/02-Compliance.md)
- [03 — IAM for AI Services](./05-Domain5-Security-Governance/03-IAM-AI.md)
- [04 — Data & Model Governance](./05-Domain5-Security-Governance/04-Governance.md)

### 6. [Flash Cards](./06-Flash-Cards/)
- [AI/ML Fundamentals](./06-Flash-Cards/01-AI-ML-Cards.md)
- [Generative AI](./06-Flash-Cards/02-GenAI-Cards.md)
- [AWS Services](./06-Flash-Cards/03-Services-Cards.md)
- [Security & Responsible AI](./06-Flash-Cards/04-Security-Cards.md)

### 7. [Diagrams](./07-Diagrams/Diagrams.md)
Mermaid diagrams: transformer architecture, RAG flow, Bedrock agents, SageMaker pipeline, responsible AI framework, shared responsibility model.

### 8. [Code Samples](./08-Code-Samples/)
- [Bedrock — invoke models, streaming, converse API, guardrails](./08-Code-Samples/bedrock-examples.py)
- [RAG with Bedrock Knowledge Bases](./08-Code-Samples/rag-examples.py)
- [SageMaker training & deployment](./08-Code-Samples/sagemaker-examples.py)
- [Agents for Bedrock](./08-Code-Samples/agents-example.py)

### 9. [Sample Questions & Answers](./09-Sample-Questions/)
- Per-domain question sets (200+ questions with detailed explanations)
- [Practice Exam 1 (65 questions)](./09-Sample-Questions/06-Practice-Exam-1.md)
- [Practice Exam 2 (65 questions)](./09-Sample-Questions/07-Practice-Exam-2.md)
- [Practice Exam 3 (65 questions)](./09-Sample-Questions/08-Practice-Exam-3.md)

### 10. [Cheat Sheets](./10-Cheat-Sheets/)
- [Services Cheat Sheet](./10-Cheat-Sheets/Services-Cheat-Sheet.md)
- [Bedrock Cheat Sheet](./10-Cheat-Sheets/Bedrock-Cheat-Sheet.md)
- [Exam Day Tips](./10-Cheat-Sheets/Exam-Day-Tips.md)

---

## How To Use This Package

1. **Start with the [Study Plan](./00-Study-Plan.md)** — pick the schedule that matches your available time.
2. **Read each domain's articles in order**, then review the corresponding flash cards.
3. **Run the code samples** against a real AWS account (free-tier eligible where possible). Reading code is not a substitute for running it.
4. **Take the per-domain quiz** at the end of each domain, reviewing every wrong answer thoroughly.
5. **Take the three practice exams** under timed, closed-book conditions during the final week.
6. **Skim the cheat sheets** the day before the exam.

---

## Architect's "Must Know Cold" List

If you are an architect short on time, memorize these items. Most exam questions map to one of them.

1. **Bedrock** — serverless access to foundation models (FMs) via a single API; supports Anthropic Claude, Amazon Nova/Titan, Meta Llama, Mistral, Cohere, Stability AI, AI21. Data stays in your account. Supports fine-tuning, provisioned throughput, Knowledge Bases (RAG), Agents, Guardrails, Model Evaluation.
2. **SageMaker** vs **Bedrock** — SageMaker = build/train/deploy *your own* models. Bedrock = consume *pretrained* foundation models via API.
3. **Amazon Q** — enterprise generative AI assistant. Q Business (enterprise search/chat), Q Developer (coding assistant, formerly CodeWhisperer), Q in QuickSight, Q in Connect.
4. **Managed AI services** — Rekognition (images/video), Transcribe (speech-to-text), Polly (text-to-speech), Translate, Comprehend (NLP), Textract (OCR + forms/tables), Kendra (enterprise search), Lex (chatbots), Personalize (recommendations), Forecast (time-series), Fraud Detector, Lookout (vision/equipment/metrics), Panorama (edge CV).
5. **RAG** — when to use it (ground answers in your data, reduce hallucination, avoid retraining). Know vector DBs: **OpenSearch Serverless**, **Aurora PostgreSQL (pgvector)**, **Neptune Analytics**, **Pinecone**, **Redis Enterprise Cloud**, **MongoDB Atlas**.
6. **Fine-tuning vs continued pretraining vs RAG vs prompt engineering** — cost, data needs, use cases, and when to choose each (big exam topic).
7. **Prompt engineering techniques** — zero-shot, one-shot, few-shot, chain-of-thought (CoT), ReAct, self-consistency, tree-of-thoughts. Know prompt injection and mitigation.
8. **Evaluation metrics** — ROUGE (summarization), BLEU (translation), BERTScore, perplexity, human evaluation, Bedrock Model Evaluation (automatic and human).
9. **Responsible AI** — fairness, explainability, transparency, privacy, safety, controllability, veracity, governance. **SageMaker Clarify** (bias + explainability), **Bedrock Guardrails** (content filters, denied topics, PII redaction, contextual grounding checks), **AI Service Cards**, **SageMaker Model Cards**.
10. **Security** — data stays in customer account with Bedrock; encryption with KMS at rest and TLS in transit; VPC endpoints (PrivateLink); IAM least privilege; CloudTrail logging; Bedrock model invocation logging; Macie for PII discovery.
11. **Shared responsibility** — AWS secures the infrastructure and the foundation models; you secure your data, prompts, fine-tuning data, and IAM.
12. **Cost optimization** — on-demand vs provisioned throughput; batch inference; model distillation; choose smallest model that meets quality bar; caching; prompt compression.

---

## Key Reference Links

- Official exam guide: `https://aws.amazon.com/certification/certified-ai-practitioner/`
- AWS Skill Builder (free AI Practitioner learning plan)
- AWS Bedrock User Guide
- AWS SageMaker Developer Guide
- AWS Well-Architected Machine Learning Lens
- AWS Responsible Use of AI Guide

---

Good luck! Work the plan, trust the process, and you will pass.
