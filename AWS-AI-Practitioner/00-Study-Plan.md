# Study Plan — AWS Certified AI Practitioner (AIF-C01)

Three plans are provided. Pick one based on time available.

---

## Plan A — 6-Week Thorough Plan (8–10 hrs/week)

Recommended for most candidates, especially if AI/ML is new to you.

### Week 1 — Foundations of AI / ML
| Day | Topic | Materials |
|-----|-------|-----------|
| Mon | What AI/ML/DL actually are | `01-Domain1/01-AI-ML-Concepts.md` |
| Tue | Supervised / Unsupervised / RL | `01-Domain1/02-ML-Types.md` |
| Wed | ML lifecycle + MLOps | `01-Domain1/03-ML-Lifecycle.md` |
| Thu | Model types (regression, classification, clustering) | Continue `02-ML-Types.md` |
| Fri | Neural networks + deep learning intuition | `01-Domain1/01-AI-ML-Concepts.md` |
| Sat | Flash cards 1 + Domain 1 quiz (first 25 Qs) | `06-Flash-Cards/01`, `09-Sample-Questions/01` |
| Sun | Review wrong answers, read explanations | — |

### Week 2 — AWS AI Services & SageMaker
| Day | Topic |
|-----|-------|
| Mon | AWS managed AI services catalog (Rekognition, Comprehend, etc.) |
| Tue | Textract, Transcribe, Polly, Translate, Lex |
| Wed | Personalize, Forecast, Fraud Detector, Kendra |
| Thu | Amazon Q (Business, Developer, QuickSight, Connect) |
| Fri | SageMaker: Studio, Training Jobs, Endpoints, Pipelines |
| Sat | SageMaker: JumpStart, Canvas, Data Wrangler, Feature Store |
| Sun | Domain 1 quiz (remaining), run code sample `sagemaker-examples.py` |

### Week 3 — Generative AI & Bedrock
| Day | Topic |
|-----|-------|
| Mon | What is GenAI; how FMs differ from traditional ML |
| Tue | Transformer architecture, tokens, embeddings |
| Wed | Bedrock overview, models available, pricing modes |
| Thu | Invoke, Converse, streaming, provisioned throughput |
| Fri | Prompt engineering (zero/one/few-shot, CoT, ReAct) |
| Sat | Prompt injection + mitigation; Flash cards 2 |
| Sun | Domain 2 quiz; run `bedrock-examples.py` |

### Week 4 — Applications of Foundation Models
| Day | Topic |
|-----|-------|
| Mon | Model selection criteria (cost, latency, context, modality) |
| Tue | RAG: what, why, architecture, vector DBs |
| Wed | Bedrock Knowledge Bases end-to-end |
| Thu | Fine-tuning, continued pretraining, model distillation |
| Fri | Evaluation: ROUGE, BLEU, BERTScore, Bedrock Model Evaluation |
| Sat | Agents for Bedrock, function calling, ReAct loop |
| Sun | Domain 3 quiz; run `rag-examples.py` and `agents-example.py` |

### Week 5 — Responsible AI, Security, Governance
| Day | Topic |
|-----|-------|
| Mon | Responsible AI pillars |
| Tue | Bias, fairness, explainability (SageMaker Clarify) |
| Wed | Bedrock Guardrails deep dive |
| Thu | AI Service Cards, Model Cards, data cards |
| Fri | Security: encryption, VPC endpoints, IAM, CloudTrail |
| Sat | Compliance (HIPAA, GDPR, SOC), shared responsibility |
| Sun | Domain 4 + 5 quizzes; flash cards 3 + 4 |

### Week 6 — Practice Exams & Weak Spot Review
| Day | Activity |
|-----|----------|
| Mon | Practice Exam 1 (timed, 90 min), grade, note weak domain |
| Tue | Review every wrong answer; re-read the relevant article |
| Wed | Practice Exam 2; grade; deep dive on mistakes |
| Thu | Cheat sheets; re-drill flashcards until 100% recall |
| Fri | Practice Exam 3; should score ≥ 80% |
| Sat | Final review: Bedrock + Responsible AI + Security cheat sheets |
| Sun | Rest. Exam day tips review. Sleep well. |

---

## Plan B — 4-Week Accelerated Plan (12–15 hrs/week)

Compress Weeks 1–2 into Week 1, Weeks 3–4 into Weeks 2–3, Week 5 into late Week 3, Week 6 unchanged.

| Week | Goals |
|------|-------|
| 1 | Domains 1 + 2 (all articles, flash cards, quizzes) |
| 2 | Domain 3 + half of Domain 4 |
| 3 | Domain 4 + 5; start practice exams |
| 4 | Three practice exams + targeted review |

---

## Plan C — 2-Week Sprint (20+ hrs/week, for experienced architects)

| Day | Focus |
|-----|-------|
| 1 | Read all Domain 1 articles; skim SageMaker; run a Bedrock sample |
| 2 | Domain 2 articles + prompt engineering lab |
| 3 | Domain 3 articles + RAG lab |
| 4 | Domain 3 agents + fine-tuning |
| 5 | Domain 4 (Responsible AI) end-to-end |
| 6 | Domain 5 (Security & Governance) end-to-end |
| 7 | Flash cards × 4; Practice Exam 1 |
| 8 | Review mistakes; re-read weak domain articles |
| 9 | Practice Exam 2; review |
| 10 | Targeted re-reading; cheat sheets |
| 11 | Practice Exam 3 |
| 12 | Review mistakes |
| 13 | Final flash cards; cheat sheets |
| 14 | Rest + exam |

---

## Self-Assessment Checkpoints

After each domain, you should be able to answer:

### Domain 1
- [ ] Explain the difference between AI, ML, DL, and Generative AI in one sentence each.
- [ ] Name at least 6 AWS managed AI services and what they do.
- [ ] Describe the ML lifecycle in 7 phases.
- [ ] Pick the right service for: OCR, recommendations, forecasting, chatbots, document search.

### Domain 2
- [ ] Explain a transformer, an embedding, and a token.
- [ ] Describe the Bedrock model families and at least one differentiator for each.
- [ ] Apply 5 different prompt-engineering techniques.
- [ ] Explain prompt injection and list mitigations.

### Domain 3
- [ ] Draw the RAG architecture from memory, including the vector DB, retriever, and generator.
- [ ] Compare prompt engineering vs RAG vs fine-tuning vs continued pretraining (cost, data, use case).
- [ ] Explain what an agent is and the ReAct loop.
- [ ] Name three GenAI evaluation metrics.

### Domain 4
- [ ] Name all 8 AWS responsible AI dimensions.
- [ ] Explain what SageMaker Clarify does (pre-training + post-training).
- [ ] Explain every feature of Bedrock Guardrails.
- [ ] Explain an AI Service Card vs a SageMaker Model Card.

### Domain 5
- [ ] Draw the shared responsibility model for managed AI.
- [ ] Explain how data is protected in Bedrock (KMS, VPC endpoints, no training on your data).
- [ ] Explain IAM least privilege for Bedrock.
- [ ] Name the relevant AWS compliance certifications for an AI workload.

---

## Daily Habits

- **30 min flash-card drill** every day once you start Week 2.
- **1 hands-on exercise per week** in an AWS account — run a model, invoke Bedrock, create a KB.
- **Keep a "confused list"** — every concept you had to re-read. Review weekly until empty.

---

Good luck. Trust the plan.
