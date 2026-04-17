# 1.3 — ML Development Lifecycle & MLOps

## 1. The 7-Phase Lifecycle

```
 ┌────────────────┐   ┌────────────────┐   ┌────────────────┐
 │ 1. Business    │──▶│ 2. Data        │──▶│ 3. Data Prep & │
 │    Framing     │   │    Collection  │   │  Feature Eng   │
 └────────────────┘   └────────────────┘   └────────┬───────┘
                                                    │
 ┌────────────────┐   ┌────────────────┐   ┌────────▼───────┐
 │ 7. Monitor &   │◀──│ 6. Deployment  │◀──│ 4. Model       │
 │    Maintain    │   │                │   │    Training    │
 └────────────────┘   └────────────────┘   └────────┬───────┘
        │                                           │
        └────────────── retrain ◀─── 5. Evaluation ◀┘
```

### Phase 1 — Business Problem Framing
- Define the business outcome (not the model).
- Decide: is ML even the right tool?
- Identify success metrics (business KPI + ML metric).
- Identify risks (fairness, privacy, regulation).

### Phase 2 — Data Collection
- Identify sources (databases, APIs, logs, third-party, S3 data lakes).
- Check licensing and PII.
- Establish **data contracts** with upstream teams.
- AWS services: S3, Glue, Kinesis, DMS, Lake Formation.

### Phase 3 — Data Preparation & Feature Engineering
- Clean (nulls, outliers, dedupe, normalize).
- Encode categoricals (one-hot, embeddings, target encoding).
- Scale (standardization, min-max).
- Split (train / validation / test).
- Feature engineering: ratios, aggregates, date parts.
- AWS services:
  - **SageMaker Data Wrangler** — visual data prep with 300+ transforms.
  - **SageMaker Feature Store** — central online + offline feature repository.
  - **AWS Glue DataBrew** — visual data prep for analysts.
  - **SageMaker Ground Truth** / **Ground Truth Plus** — labeling.

### Phase 4 — Model Training
- Pick algorithm and framework.
- Hyperparameter tuning.
- Track experiments.
- AWS services:
  - **SageMaker Training Jobs** — managed training.
  - **SageMaker Experiments** — track runs.
  - **SageMaker Automatic Model Tuning** — hyperparameter optimization.
  - **SageMaker JumpStart** — pre-built models & solutions.
  - **SageMaker Autopilot** — AutoML (tries many algorithms automatically).
  - **SageMaker Canvas** — no-code ML for business analysts.

### Phase 5 — Evaluation
- Evaluate on the held-out test set.
- Compare against baselines (rule-based, previous model).
- Evaluate fairness and bias (SageMaker Clarify).
- Business stakeholder sign-off.

### Phase 6 — Deployment
Options:

| Pattern | Use when |
|---------|----------|
| **Real-time endpoint** | Interactive, <1s latency | `SageMaker Real-time Inference` |
| **Serverless endpoint** | Intermittent, spiky traffic | `SageMaker Serverless Inference` |
| **Asynchronous inference** | Large payloads, long-running | `SageMaker Async Inference` |
| **Batch transform** | Bulk, offline, no endpoint needed | `SageMaker Batch Transform` |
| **Edge** | IoT / no internet | **SageMaker Edge**, **AWS IoT Greengrass**, **AWS Panorama** |

Deployment strategies:
- **Blue/Green** — deploy new model alongside old, switch traffic.
- **Canary** — route small % to new model, ramp up.
- **Shadow / A-B test** — send copy of traffic to new model, compare; don't serve its output.
- **Rolling** — gradual replacement.

### Phase 7 — Monitoring & Maintenance
Watch for:
- **Data drift** — input distribution changes.
- **Concept drift** — relationship between X and y changes.
- **Model decay** — performance drops over time.
- **Bias drift** — fairness metrics worsen.
- **Feature attribution drift** — which features drive predictions changes.
- Latency, error rate, cost.

AWS services:
- **SageMaker Model Monitor** — data quality, model quality, bias drift, feature attribution drift.
- **SageMaker Clarify** — monitor bias.
- CloudWatch — latency, errors.

Triggers for retraining:
- Scheduled (weekly/monthly).
- Drift detected.
- Performance drop.
- New ground truth labels collected.

---

## 2. MLOps — Operationalizing ML

**MLOps** combines ML + DevOps + DataOps. Adds to DevOps:
- Data versioning (not just code)
- Model versioning
- Experiment tracking
- Continuous training (CT) in addition to CI/CD
- Monitoring for drift, not just crashes

### MLOps Maturity Levels (Google/AWS common framing)

| Level | Description |
|-------|-------------|
| **0** | Manual — Jupyter notebooks, manual training and deployment. |
| **1** | ML Pipeline — automated training pipeline, reproducible. |
| **2** | CI/CD — automated retraining, testing, deployment. |

### AWS Services for MLOps

- **SageMaker Pipelines** — purpose-built CI/CD for ML. DAG of steps (processing, training, evaluation, registration, deployment).
- **SageMaker Model Registry** — version and approve models.
- **SageMaker Projects** — templates with CodePipeline / CodeCommit integration.
- **SageMaker Experiments** — track every training run.
- **AWS Step Functions** — generic workflow orchestrator (often used for ML pipelines).
- **Amazon EventBridge** — trigger retraining on events (new data arrived).

### Example SageMaker Pipeline

```
ProcessingStep (data prep)
        │
TrainingStep
        │
EvaluationStep
        │
ConditionStep (accuracy > 0.85?)
        ├── Yes → RegisterModelStep → CreateEndpointStep
        └── No  → Fail / notify
```

---

## 3. Key Roles on an ML Team

| Role | Responsibility |
|------|----------------|
| **Data engineer** | Pipelines, data quality, feature stores |
| **Data scientist / ML researcher** | Exploration, model selection, experimentation |
| **ML engineer** | Training pipelines, deployment, MLOps |
| **DevOps / Platform** | Infra, IAM, networking |
| **Product / Business** | Framing, KPIs, acceptance |
| **Compliance / Risk** | Bias, privacy, governance, audit |

---

## 4. Common Pitfalls

1. **Training/serving skew** — features computed differently at train vs inference time. Prevent with a **feature store**.
2. **Data leakage** — leakage of future or target info into features.
3. **Wrong metric** — optimizing accuracy on imbalanced data.
4. **Ignoring baseline** — always compare to a simple rule.
5. **No monitoring** — model silently degrades in prod.
6. **Non-reproducible** — no experiment tracking, no data versioning.
7. **Prompting production** — using prompts as configuration without versioning for GenAI.
8. **Skipping responsible AI review** — hits you at audit time.

---

## 5. Quick Reference — AWS Service per Lifecycle Phase

| Phase | Primary services |
|-------|------------------|
| Framing | (process + Amazon Bedrock Studio for prototyping) |
| Data collection | S3, Glue, DMS, Kinesis, Data Exchange, Lake Formation |
| Labeling | SageMaker Ground Truth, Ground Truth Plus |
| Data prep | Data Wrangler, Glue DataBrew, Feature Store, Processing Jobs |
| Training | SageMaker Training, JumpStart, Autopilot, Bedrock fine-tuning |
| Evaluation | SageMaker Experiments, Clarify, Bedrock Model Evaluation |
| Deployment | SageMaker Endpoints (real-time, serverless, async), Batch Transform, Edge Manager, Bedrock on-demand / provisioned throughput |
| Monitoring | SageMaker Model Monitor, Clarify, CloudWatch, Bedrock model invocation logging |
| Orchestration | SageMaker Pipelines, Step Functions, EventBridge |
| Governance | Model Cards, Model Registry, ML Governance, AWS Audit Manager |

> Next — [1.4 AWS AI Services](./04-AWS-AI-Services.md)
