# Flash Cards — Responsible AI, Security, Governance

| Q | A |
|---|---|
| 8 AWS responsible AI dimensions | Fairness, Explainability, Privacy & Security, Safety, Controllability, Veracity & Robustness, Transparency, Governance |
| Bias (ML) | Systematic error leading to unfair/incorrect outcomes |
| Sampling bias | Training data not representative of real population |
| Label bias | Historical labels reflect past discrimination |
| Confirmation bias | Engineers accept results matching expectations |
| Feedback-loop bias | Model's outputs shape future training data |
| Demographic parity | Equal positive rate across groups |
| Equalized odds | Equal TPR and FPR across groups |
| Disparate impact 80% rule | Selection rate ≥ 80% of best group |
| Pre-training bias tool | SageMaker Clarify (data analysis) |
| Post-training bias tool | SageMaker Clarify (predictions) |
| SHAP | Shapley values for per-prediction feature attribution |
| Global vs local explanation | Overall feature importance vs single prediction attribution |
| Counterfactual explanation | Minimal feature change that flips the prediction |
| HITL for ML | Amazon A2I |
| When to use A2I | Low-confidence, high-stakes, regulated decisions |
| Model card | You document your custom model |
| AI Service Card | AWS documents an AWS AI service |
| RAG citations | Source references returned with answer |
| Agent trace | Step-by-step reasoning and tool calls |
| Guardrails content filter categories | Hate, insults, sexual, violence, misconduct, prompt attacks |
| Guardrails filter strengths | NONE/LOW/MEDIUM/HIGH |
| Guardrails denied topics | Natural-language topic definitions (up to 30) |
| Guardrails word filters | Custom words + profanity list |
| Guardrails sensitive information | PII detect & block/mask + custom regex |
| Contextual grounding check | Grounding + relevance scoring vs retrieved context |
| Automated Reasoning check | Formal-logic verification vs policy |
| Apply Guardrail standalone | `ApplyGuardrail` API |
| Model Monitor types | Data quality, model quality, bias drift, feature attribution drift |
| Secret store | AWS Secrets Manager |
| KMS customer-managed key | You own rotation, policy, grants |
| Encryption in transit | TLS 1.2+; VPC endpoints for private traffic |
| Encryption at rest | KMS for S3, EBS, SageMaker, Bedrock, vector DBs |
| Data residency control | Choose the AWS region |
| Does Bedrock train on your data? | No |
| Model invocation logging | Opt-in logging of prompts + completions to CloudWatch / S3 |
| Least privilege IAM | Scope actions to specific model ARNs |
| SCP purpose | Organization-wide guardrails on what accounts can do |
| Shared responsibility (AI) | AWS secures infra + FM; you secure data, IAM, prompts, monitoring |
| HIPAA evidence | AWS BAA via AWS Artifact |
| GDPR | EU data protection; requires lawful basis, subject rights, DPIA |
| Article 22 GDPR | Right not to be subject to solely-automated decisions with significant effects |
| CCPA | California privacy; opt-out, access, deletion |
| PCI DSS | Cardholder data — rarely in LLMs; tokenize |
| SOC 1/2/3 | Control assurance reports (via Artifact) |
| ISO 27001 | Infosec management system |
| ISO/IEC 42001 | AI Management System standard (AWS is certified) |
| NIST AI RMF | US voluntary AI risk framework (Govern/Map/Measure/Manage) |
| EU AI Act tiers | Unacceptable, High, Limited, Minimal risk |
| GenAI Security Scoping Matrix | 5 scopes: Consumer, Enterprise, Pretrained, Fine-tuned, Self-trained |
| Well-Architected ML Lens | ML-specific AWS best practices blueprint |
| Service for PII in S3 | Amazon Macie |
| Service for PII in text | Comprehend PII / Guardrails |
| Audit framework evidence | AWS Audit Manager |
| Config change tracking | AWS Config |
| Security findings hub | AWS Security Hub |
| Threat detection | GuardDuty |
| Identity federation for Q Business | IAM Identity Center |
| Private Bedrock access | VPC Interface endpoint (PrivateLink) |
| Restrict model access org-wide | SCP with Deny NotResource |
| Bedrock custom model serving requirement | Provisioned Throughput |
| Cost optimization tactics | Smaller model, batch inference, prompt caching, cap max tokens, RAG over fine-tune |
| HIPAA-eligible AI services | Most — Bedrock (many models), SageMaker, Comprehend (incl. Medical), Transcribe (incl. Medical), Textract, Translate, Polly, Rekognition, Kendra, Lex, Personalize, Forecast, Fraud Detector, Q (many regions) |
| Sovereign / FedRAMP High region | AWS GovCloud (US) |
| Responsible AI docs published by vendor | Model cards (Anthropic, Meta) + AWS AI Service Cards |
| Generative AI output watermarking | Nova Canvas / Reel (invisible watermark) |

