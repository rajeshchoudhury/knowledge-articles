# 1.2 — Types of Machine Learning

There are **three** main learning paradigms, plus two important hybrids.

---

## 1. Supervised Learning

**You give the model labeled data.** It learns a mapping `f: X → y`.

### Sub-types

| Sub-type | Output | Examples |
|----------|--------|----------|
| **Regression** | Continuous number | Forecast revenue, predict house price, ETA prediction |
| **Classification (binary)** | Two classes | Fraud / not fraud, spam / ham |
| **Classification (multi-class)** | N classes | Cat / Dog / Bird |
| **Multi-label classification** | Multiple labels per item | Tags on a photo |
| **Ranking** | Order of items | Search result ranking |

### Common supervised algorithms
- **Linear Regression** — regression baseline.
- **Logistic Regression** — binary classification with a probability.
- **Decision Trees / Random Forests** — interpretable, great on tabular.
- **Gradient Boosted Trees (XGBoost, LightGBM)** — top performer on tabular.
- **Support Vector Machines (SVM)** — margin-based classifier.
- **K-Nearest Neighbors (KNN)** — instance-based; classify by closest neighbors.
- **Naive Bayes** — probabilistic classifier, assumes feature independence. Great for text.
- **Neural Networks / Deep Learning** — images, text, audio.

### AWS services using supervised learning
- SageMaker built-in algorithms: Linear Learner, XGBoost, KNN, Factorization Machines, Image Classification, Object Detection.
- Amazon Rekognition (image/video classification).
- Amazon Comprehend (text classification, entity extraction).
- Amazon Fraud Detector.

---

## 2. Unsupervised Learning

**No labels.** The model finds structure on its own.

### Sub-types

| Sub-type | Goal | Examples |
|----------|------|----------|
| **Clustering** | Group similar items | Customer segmentation |
| **Dimensionality reduction** | Compress features while preserving info | PCA for visualization, autoencoders |
| **Association rule mining** | Find co-occurring items | "People who bought X also bought Y" |
| **Anomaly detection** | Find outliers | Fraud, defect detection |
| **Density estimation** | Estimate the probability distribution | Novelty detection |

### Common unsupervised algorithms
- **K-Means** — partition into k clusters.
- **Hierarchical clustering** — build a dendrogram.
- **DBSCAN** — density-based clustering, finds arbitrary shapes and noise.
- **PCA (Principal Component Analysis)** — linear dimensionality reduction.
- **t-SNE / UMAP** — non-linear visualization of high-dim data.
- **Isolation Forest, One-Class SVM** — anomaly detection.
- **Random Cut Forest (RCF)** — the AWS SageMaker anomaly detection algorithm, used in Kinesis Data Analytics.

### AWS services using unsupervised learning
- SageMaker K-Means, PCA, Random Cut Forest, IP Insights.
- Amazon Lookout for Equipment (anomalies in industrial sensor data).
- Amazon Lookout for Metrics (anomalies in business metrics).
- Amazon Lookout for Vision (defect detection).
- Amazon OpenSearch anomaly detection.

---

## 3. Reinforcement Learning (RL)

**Agent learns by trial and error.** It takes actions in an environment, observes rewards, and learns a policy that maximizes cumulative reward.

### Key terms
- **Agent** — the learner.
- **Environment** — everything the agent interacts with.
- **State (s)** — current situation.
- **Action (a)** — what the agent does.
- **Reward (r)** — feedback signal (+ or −).
- **Policy (π)** — strategy mapping states to actions.
- **Episode** — one run from start to end.
- **Exploration vs exploitation** — tradeoff between trying new actions vs using known good ones.

### Algorithms
- Q-Learning, Deep Q-Networks (DQN)
- Policy gradient methods (REINFORCE, PPO, A3C)
- Actor-Critic
- **RLHF (Reinforcement Learning from Human Feedback)** — how LLMs like Claude and GPT are aligned with human preferences.

### AWS services
- **AWS DeepRacer** — 1/18th scale car that learns to race via RL. Educational.
- **SageMaker RL** — managed RL training.
- **Amazon Bedrock** uses RLHF behind the scenes in its FMs.

### When to pick RL
- Sequential decisions, no labeled "right answer" (games, robotics, trading, dynamic pricing, resource allocation).
- You can define a reward function.
- You can simulate the environment cheaply.

---

## 4. Semi-Supervised Learning

**A little labeled + a lot of unlabeled.** Labels are expensive; use the unlabeled data to learn representations that help the labeled task.

Common pattern:
1. Self-supervised pretraining on unlabeled data.
2. Supervised fine-tuning on a small labeled set.

This is how foundation models are trained.

---

## 5. Self-Supervised Learning

**Labels generated automatically from the data itself.** No human labeling needed.

- **Masked language modeling** — hide a word, predict it (BERT).
- **Next-token prediction** — predict the next token given previous (GPT, Claude).
- **Contrastive learning** — learn that two augmented views of the same image are "similar" (CLIP, SimCLR).

This is the primary training paradigm for LLMs and other foundation models.

---

## 6. Transfer Learning

Take a model pretrained on a large general dataset and **adapt it to your domain** with much less data.

### Approaches
- **Feature extraction** — freeze the base model, train only a new head.
- **Fine-tuning** — unfreeze some/all layers and continue training on domain data.
- **Domain adaptation / continued pretraining** — pretrain further on domain corpus.
- **Adapters / LoRA (Low-Rank Adaptation)** — parameter-efficient fine-tuning; train small extra weights, keep base frozen.

Transfer learning is the backbone of modern DL applications — use a pretrained BERT/ResNet/LLM and adapt to your use case.

---

## 7. Decision Tree — Which Paradigm?

```
Do you have labels for the task?
├── Yes
│   ├── Lots of labels → Supervised
│   └── A few labels + lots of unlabeled → Semi-supervised / Transfer learning
├── No
│   ├── You want to find structure → Unsupervised
│   └── You have a reward signal & sequential decisions → Reinforcement learning
```

---

## 8. Exam-Ready Mapping: Problem → Paradigm

| Scenario | Paradigm |
|----------|----------|
| Predict if a transaction is fraudulent | Supervised (binary classification) |
| Segment customers into marketing groups without prior labels | Unsupervised (clustering) |
| Forecast next week's demand | Supervised (regression / time-series) |
| Train a bot to play a game | Reinforcement |
| Auto-train an LLM on a web-scale corpus | Self-supervised |
| Adapt a pretrained BERT to legal documents with 2,000 examples | Transfer learning / fine-tuning |
| Detect anomalies in server logs | Unsupervised (anomaly detection) |
| Align an LLM to be helpful and harmless | RLHF |
| Find which products are bought together | Association rule mining (unsupervised) |
| Translate English to Spanish | Supervised (seq-to-seq) |

---

> Next — [1.3 ML Lifecycle](./03-ML-Lifecycle.md)
