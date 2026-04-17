# 1.5 — Amazon SageMaker Deep Dive

Amazon SageMaker is the AWS service for **building, training, and deploying ML models**. The exam expects you to recognize the major sub-capabilities and when to use each.

---

## 1. SageMaker Family Overview

```
┌──────────────────────── Amazon SageMaker ─────────────────────────┐
│                                                                   │
│  ┌────── Build ──────┐ ┌───── Train ─────┐ ┌───── Deploy ─────┐   │
│  │ Studio            │ │ Training Jobs   │ │ Real-time        │   │
│  │ Notebooks         │ │ Automatic Tuning│ │ Serverless       │   │
│  │ Data Wrangler     │ │ Experiments     │ │ Async            │   │
│  │ Feature Store     │ │ Debugger        │ │ Batch Transform  │   │
│  │ Ground Truth      │ │ Profiler        │ │ Multi-Model      │   │
│  │ JumpStart         │ │ Distributed     │ │ Multi-Container  │   │
│  │ Canvas            │ │ Spot training   │ │ Edge Manager     │   │
│  │ Autopilot         │ │                 │ │ Shadow tests     │   │
│  └───────────────────┘ └─────────────────┘ └──────────────────┘   │
│                                                                   │
│  ┌── Monitor/Govern ──┐ ┌── Orchestrate ──┐ ┌───── Security ───┐  │
│  │ Model Monitor      │ │ Pipelines       │ │ VPC, KMS, IAM    │  │
│  │ Model Cards        │ │ Projects        │ │ Network isolation│  │
│  │ Model Registry     │ │ Step Functions  │ │ PrivateLink      │  │
│  │ Clarify            │ │                 │ │                  │  │
│  │ ML Governance      │ │                 │ │                  │  │
│  └────────────────────┘ └─────────────────┘ └──────────────────┘  │
└───────────────────────────────────────────────────────────────────┘
```

---

## 2. SageMaker Studio

Web-based IDE for ML. Built on JupyterLab but integrates every SageMaker feature (training, deployment, experiments, Canvas, Data Wrangler, Pipelines, Model Registry, JumpStart, Bedrock integration).

**Studio Notebooks** — managed Jupyter kernels. Per-user, pay per instance-hour when active.

**Studio Classic** vs **Studio (new UI)** — the new UI is default. Exam won't quiz on UI differences.

---

## 3. Data Preparation

### SageMaker Data Wrangler
- **Visual data prep** tool inside Studio.
- 300+ built-in transformations (handle missing, encode, scale, date parts, joins).
- Data quality and insights report.
- Outputs a processing job or export a Python notebook.
- Sources: S3, Redshift, Athena, Snowflake, Databricks.

### SageMaker Ground Truth
- **Human labeling** service for datasets.
- Built-in workflows: image classification, bounding boxes, semantic segmentation, text classification, NER, custom.
- Label sources: public workforce (Mechanical Turk), private workforce (your own employees), vendor workforces.
- **Active learning** — the service automatically labels easy examples and routes hard ones to humans.
- **Ground Truth Plus** — AWS-managed turnkey service where AWS experts deliver labeled data.

### SageMaker Feature Store
- Central repository for features.
- **Online Store** — low-latency key lookup (for real-time inference).
- **Offline Store** — historical features in S3 (for training).
- Eliminates training/serving skew because both consume the same feature definitions.

### SageMaker Processing Jobs
- Run data preprocessing, feature engineering, model evaluation, as managed containers.
- Built-in containers for Spark and Scikit-learn; bring your own image for anything else.

---

## 4. Training

### SageMaker Training Jobs
- Launch managed containers on ephemeral infra for training.
- Data read from S3 (File mode, Pipe mode, FastFile mode) or EFS / FSx for Lustre.
- Output (the model artifact) saved to S3.
- **Managed Spot Training** — up to 90% savings by using EC2 Spot.

### Built-in Algorithms
A curated list of SageMaker algorithms optimized for AWS. Know these by category (you don't need to memorize the details but recognize the names):

| Category | Algorithms |
|----------|-----------|
| Linear models | Linear Learner |
| Trees / boosting | XGBoost |
| Clustering | K-Means |
| Dim. reduction | PCA |
| Anomaly detection | Random Cut Forest, IP Insights |
| Computer vision | Image Classification, Object Detection, Semantic Segmentation |
| NLP | BlazingText (word2vec-like), Object2Vec, Seq2Seq |
| Recommender | Factorization Machines, Neural Topic Model, LDA |
| Forecasting | DeepAR |
| Matrix factorization | Factorization Machines |
| Reinforcement learning | RL Estimators |

### Frameworks
Bring your own training script with managed containers for TensorFlow, PyTorch, MXNet, Hugging Face, Scikit-learn, XGBoost. Or bring **Your Own Container (BYOC)**.

### SageMaker JumpStart
- **Model hub** with hundreds of open-source and proprietary foundation models and solutions.
- One-click fine-tune and deploy.
- Overlaps with Bedrock but gives more control (your own model, your own instance).

### SageMaker Autopilot
- **AutoML** — give it tabular data and a target, it tries many algorithms/pipelines, returns a leaderboard plus full source code (no black box).

### SageMaker Canvas
- **No-code ML for business analysts**.
- Point-and-click, connects to data sources, auto-EDA, auto-model, what-if analysis.
- Now includes generative AI features (Bedrock-powered chat with your data, forecasting, sentiment).

### Automatic Model Tuning (Hyperparameter Optimization)
- **Bayesian, random, hyperband, grid** search.
- Define objective metric, ranges, max jobs.

### Experiments
- Track metrics, hyperparameters, artifacts for every run.

### Debugger
- Emits tensor values during training, detects common issues (vanishing gradients, loss not decreasing).

### Distributed Training
- **Data parallelism** — each GPU trains on a different data shard.
- **Model parallelism** — split a very large model across GPUs.
- SageMaker supports both with its own libraries optimized for AWS networking.

---

## 5. Deployment

| Deployment option | Latency | Use case |
|-------------------|---------|----------|
| **Real-time endpoint** | ms–s | Live apps |
| **Serverless Inference** | Slight cold start | Spiky traffic, dev/test |
| **Async Inference** | Seconds–minutes | Large payloads (video, large docs), queued |
| **Batch Transform** | Batch job | Offline scoring |

### Multi-Model Endpoint (MME)
Host **many models on one endpoint**. Models loaded on demand. Great for per-customer or per-segment models.

### Multi-Container Endpoint
One endpoint, multiple containers (e.g., model + preprocessor).

### Inference Recommender
Tests your model across instance types and gives you recommendations on cost/latency.

### Shadow Testing
Send a copy of production traffic to a new model without serving its output to users. Compare performance before switching.

### Edge
- **SageMaker Edge Manager** (sunset-track — exam won't emphasize).
- **AWS IoT Greengrass** + **SageMaker Neo** — compile models for edge devices.

### SageMaker Neo
- **Model compilation/optimization** for target hardware (CPU, GPU, or edge devices) — smaller, faster inference.

---

## 6. Monitoring & Governance

### SageMaker Model Monitor
- Schedules batch jobs against a live endpoint.
- Four monitor types:
  1. **Data quality** — input drift vs baseline.
  2. **Model quality** — prediction quality vs ground truth (requires labels later).
  3. **Bias drift** — fairness metrics.
  4. **Feature attribution drift** — which features drive predictions.
- Emits CloudWatch metrics; can trigger retraining.

### SageMaker Clarify
- **Pre-training bias** — detect bias in training data (21+ metrics like class imbalance, Difference in Positive Proportions).
- **Post-training bias** — bias in model predictions.
- **Explainability** — SHAP-based feature importance per prediction and globally.
- For **foundation models**, Clarify adds LLM evaluation (toxicity, bias, robustness).

### SageMaker Model Cards
- Document intended use, training data, evaluation results, caveats. Part of responsible AI workflow.

### SageMaker Model Registry
- Version, approve, and deploy models in a lifecycle (Pending → Approved → Rejected).

### SageMaker ML Governance
- Dashboards for model cards, audit reports, role manager, permissions.

---

## 7. Pipelines & Orchestration

### SageMaker Pipelines
- Purpose-built CI/CD for ML.
- DAG of steps: ProcessingStep, TrainingStep, TransformStep, CreateModelStep, ConditionStep, RegisterModelStep, etc.
- Integrates with Model Registry and EventBridge.

### SageMaker Projects
- MLOps templates bundling Pipelines + CodeCommit + CodePipeline + CloudFormation.

---

## 8. Security Features

- **VPC Mode** — run training/inference inside your VPC (no public internet).
- **Network Isolation** — container has no network access at all.
- **PrivateLink (VPC Endpoints)** — private connectivity to SageMaker APIs.
- **KMS encryption** — at rest (S3, EBS) and for notebook root volumes.
- **IAM roles** — role passed to training jobs and endpoints (service role / execution role).
- **Tags + ABAC** for fine-grained control.
- **Root access disabled** on notebooks for sensitive environments.

---

## 9. SageMaker vs Bedrock — The Big One

| Dimension | SageMaker | Bedrock |
|-----------|-----------|---------|
| Goal | Build **your own** models | Use **pretrained foundation** models |
| Infrastructure | You pick instances | Fully serverless |
| Models | Open source + custom | Anthropic, Amazon, Meta, Mistral, Cohere, Stability AI, AI21 |
| Fine-tuning | Full control, any framework | Managed fine-tuning for supported models |
| Ops burden | Higher | Very low |
| Best for | Custom ML, tabular, CV, niche DL | GenAI applications quickly |
| Pricing | Per-instance hour | Per-token (on-demand) or provisioned throughput |

**They are not mutually exclusive.** Real architectures use both — Bedrock for chat/RAG with foundation models, SageMaker for custom classifiers and recommenders.

---

## 10. SageMaker Pricing Dimensions (high level)

- Instance hours for notebooks, training, processing, endpoints.
- Data transfer.
- Features like Ground Truth (per label), Canvas (per user + per compute).
- Savings plans available for SageMaker.

---

## 11. Recognize These Flags — Exam

- **"Visually prep tabular data for a data scientist"** → Data Wrangler.
- **"Share features between training and inference"** → Feature Store.
- **"Non-technical analyst wants to build a model"** → Canvas.
- **"Auto-try many algorithms on tabular data"** → Autopilot.
- **"Start from a pretrained model in one click"** → JumpStart.
- **"Detect if incoming data drifts from training"** → Model Monitor.
- **"Audit bias in a trained model"** → Clarify.
- **"Document the model for compliance"** → Model Cards.
- **"Orchestrate a training+deployment pipeline with approvals"** → Pipelines + Model Registry.
- **"Train a huge model across many GPUs"** → SageMaker Distributed Training.
- **"Save up to 90% on training"** → Managed Spot Training.
- **"Deploy a model that only runs a few times a day"** → Serverless Inference.
- **"Large input payload, 15-minute inference"** → Async Inference.
- **"Hundreds of per-customer models on one endpoint"** → Multi-Model Endpoint.
- **"No internet access allowed from the training container"** → Network Isolation.

> Next — [2.1 Generative AI Fundamentals](../02-Domain2-Generative-AI/01-GenAI-Fundamentals.md)
