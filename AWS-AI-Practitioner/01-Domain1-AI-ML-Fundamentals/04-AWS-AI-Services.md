# 1.4 — AWS Managed AI Services Catalog

> The exam tests whether you can pick the right managed service for a given use case. Do not memorize API names — memorize **what each service does** and **when to use it**.

## The Three Layers of AWS AI/ML Stack

```
┌─────────────────────────────────────────────────────────────┐
│   AI SERVICES (pre-trained, API-level — no ML skills)       │
│   Rekognition | Transcribe | Polly | Translate |            │
│   Comprehend | Textract | Lex | Kendra | Personalize |      │
│   Forecast | Fraud Detector | Lookout | Q                   │
├─────────────────────────────────────────────────────────────┤
│   ML SERVICES (build/train/deploy your own models)          │
│   Amazon SageMaker (Studio, Canvas, JumpStart, etc.)        │
│   Amazon Bedrock (Foundation Models as a service)           │
├─────────────────────────────────────────────────────────────┤
│   ML FRAMEWORKS & INFRASTRUCTURE                            │
│   EC2 (GPU/Trainium/Inferentia), EKS, ECS, Deep Learning    │
│   AMIs, Deep Learning Containers                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 1. Vision Services

### Amazon Rekognition
- Pre-trained computer vision API for **images and video**.
- Features:
  - Object & scene detection
  - Face detection, analysis, comparison
  - **Face search** against collections (not for mass surveillance; has responsible-use policies)
  - Celebrity recognition
  - Text in image (small-scale — Textract is better for documents)
  - Content moderation (unsafe content detection)
  - PPE (personal protective equipment) detection
  - Custom Labels — train your own object detector with as few as 10 images
  - Video: person tracking, activity recognition, segment detection (shot/tech cues)
- **Use cases:** photo tagging, moderation, identity verification.
- Streams from Kinesis Video Streams for real-time analysis.

### Amazon Lookout for Vision
- **Industrial defect detection** in images (scratches, dents, missing components).
- Train with as few as 30 anomaly-free images.

### AWS Panorama
- **Computer vision at the edge**. Appliance or SDK that runs CV models on-premises (e.g., factory floor cameras).

### Amazon Textract
- **OCR with structure** — extracts printed and handwritten text, forms (key-value), and tables.
- Supports signature detection, identity document analysis (passports, driver's licenses), expense analysis (invoices, receipts), lending analysis.
- Much more capable than Rekognition for documents.

---

## 2. Speech Services

### Amazon Transcribe
- **Speech to text**.
- Features: multi-speaker diarization, custom vocabulary, language ID, real-time streaming.
- **Transcribe Medical** — HIPAA-eligible, medical terminology.
- **Transcribe Call Analytics** — call center insights (sentiment, issue detection, categorization).
- **PII redaction** in transcripts.

### Amazon Polly
- **Text to speech**.
- Many voices and languages.
- **Neural TTS** for natural-sounding voices.
- **Newscaster / Conversational / Generative** speaking styles.
- **SSML** (Speech Synthesis Markup Language) for fine control.
- Lexicons for brand/domain pronunciation.
- **Speech marks** for lip-sync / captions.

---

## 3. Language / NLP Services

### Amazon Translate
- Neural machine translation across 75+ languages.
- Custom terminology and parallel data for brand-specific translation.
- Real-time and batch.

### Amazon Comprehend
- Pre-trained NLP. Features:
  - Language detection
  - **Entity recognition** (people, places, dates, quantities)
  - **Key phrase extraction**
  - **Sentiment analysis** (positive, negative, neutral, mixed)
  - **Targeted sentiment** (per-entity sentiment)
  - **Syntax analysis** (POS tags)
  - **Topic modeling**
  - **PII detection and redaction**
  - **Custom classification** and **custom entity recognition** (train with your own labels)
- **Comprehend Medical** — HIPAA-eligible, medical entities, PHI detection, ICD-10 + RxNorm ontology linking.

### Amazon Lex
- **Conversational chatbots and voicebots**. Same engine as Alexa.
- Intents, slots, utterances, fulfillment (typically Lambda).
- Integrates with Amazon Connect (contact centers).
- **Lex V2** supports multiple languages and streaming.

### Amazon Kendra
- **Enterprise intelligent search** with natural language queries.
- Connectors to SharePoint, Salesforce, ServiceNow, Confluence, S3, Google Drive, etc.
- Returns passages and answers, not just links.
- Frequently used as a retriever in RAG (pre-Bedrock Knowledge Bases).

---

## 4. Specialized AI Services

### Amazon Personalize
- **Real-time recommendations** (Amazon.com-style).
- You upload interactions, users, items.
- Recipes: user personalization, similar items, personalized ranking, trending now, next best action.
- Business metrics optimization.

### Amazon Forecast
- **Time-series forecasting** (retail demand, cloud capacity, financial planning).
- Incorporates related time-series and metadata.
- Algorithms include ARIMA, ETS, Prophet, DeepAR+, CNN-QR.
- (Transitioning — SageMaker Canvas & Bedrock increasingly replace it.)

### Amazon Fraud Detector
- Pre-built ML models for common fraud use cases (online fraud, transaction fraud, account takeover).
- Provide historical fraud data; it trains on AWS Amazon's fraud expertise.

### Amazon Lookout for Metrics
- Anomaly detection on **business metrics** (revenue, active users, conversion rate).

### Amazon Lookout for Equipment
- Predictive maintenance from **industrial sensor data**.

### Amazon Monitron
- End-to-end **equipment monitoring** hardware+service — sensors + gateway + ML.

### Amazon HealthLake, Amazon Comprehend Medical, Amazon Transcribe Medical
- HIPAA-eligible healthcare AI services.

### AWS DeepRacer, DeepLens, DeepComposer
- Educational services for RL, CV, music generation.

---

## 5. Amazon Q — The Generative AI Assistant Family

> **This is a major exam topic. Know each variant.**

### Q Business
- **Enterprise AI assistant** grounded in your company's data.
- Connects to 40+ data sources (S3, Salesforce, SharePoint, Jira, Confluence, ServiceNow, Slack, Teams, Gmail, etc.).
- Respects document-level permissions.
- Web experience, Slack/Teams plugins, browser extension.
- Q Apps — no-code generative apps built from Q conversations.
- Q Business is IAM Identity Center integrated (SSO, groups).

### Q Developer (formerly CodeWhisperer + new features)
- **Coding assistant** — autocomplete, chat, code transformation (e.g., Java 8 → Java 17), security scanning, unit test generation.
- IDE plugins: VS Code, JetBrains, Visual Studio, Eclipse, CLI, SageMaker Studio, Cloud9.
- Tiers: Free and Pro.
- Has **inline code suggestions** and **agent for software development** (multi-step tasks).

### Q in QuickSight
- **Natural-language BI** — ask questions of dashboards, generate narratives, build dashboards from prompts.

### Q in Connect
- **Live agent assist** in Amazon Connect contact centers — surfaces answers and drafts responses in real time during a call.

### Q in AWS (Management Console / Chat)
- In-console assistant that answers AWS questions, explains resources, and helps troubleshoot.

---

## 6. The Core ML Platform

### Amazon SageMaker (covered in depth in `05-SageMaker-Overview.md`)
- Build-train-deploy for **your own** models.
- Not a pre-trained API — you own the model.

### Amazon Bedrock (covered in depth in `02-Domain2/03-Amazon-Bedrock.md`)
- Serverless **foundation models** as a service.
- Anthropic Claude, Amazon Nova & Titan, Meta Llama, Mistral, Cohere, Stability AI, AI21.
- Plus: Knowledge Bases, Agents, Guardrails, Model Evaluation, Flows, Studio.

---

## 7. Decision Matrix — Pick the Right Service

| Need | Service |
|------|---------|
| Detect objects in photos | Rekognition |
| Detect defects in factory photos | Lookout for Vision |
| OCR a scanned invoice with tables | Textract |
| Convert a podcast to text | Transcribe |
| Redact PII from a call transcript | Transcribe + Comprehend (PII) |
| Read menu text aloud in 20 languages | Translate + Polly |
| Find sentiment in customer reviews | Comprehend |
| Extract medical entities from doctor notes | Comprehend Medical |
| Build a chatbot for flight booking | Lex + Lambda |
| Enterprise search across SharePoint + Confluence | Kendra (or Q Business) |
| Product recommendations on your site | Personalize |
| Forecast next 12 weeks of demand | Forecast or SageMaker Canvas or Bedrock |
| Detect fraudulent new-account signups | Fraud Detector |
| Detect anomalies in AWS bill by service | Lookout for Metrics |
| Predictive maintenance from sensors | Lookout for Equipment / Monitron |
| Generate a marketing tagline from a product description | Bedrock |
| Summarize internal wiki articles | Bedrock (+ Knowledge Bases for RAG) |
| Ask questions of your company docs with RAG | Q Business **or** Bedrock Knowledge Bases |
| Write code faster | Q Developer |
| Ask a dashboard "why did revenue drop?" | Q in QuickSight |
| Train a custom image classifier | Rekognition Custom Labels or SageMaker |
| Deploy a PyTorch model you built | SageMaker |

---

## 8. HIPAA / FedRAMP / GDPR — Eligibility Notes

Many AI services are **HIPAA eligible** (covered under AWS BAA) — Transcribe, Transcribe Medical, Comprehend, Comprehend Medical, Textract, Polly, Translate, Rekognition, SageMaker, Bedrock (for many models), Kendra, Lex, Personalize, Forecast.

Always verify current eligibility on the AWS compliance page — but for the exam, know that **most mainstream AI services are HIPAA eligible**.

> Next — [1.5 SageMaker Deep Dive](./05-SageMaker-Overview.md)
