# 1.1 — AI, ML, Deep Learning, and Generative AI Concepts

## 1. The Hierarchy of Terms

```
                 ┌────────────────────────────────────────┐
                 │      ARTIFICIAL INTELLIGENCE (AI)      │
                 │  Any technique that makes machines     │
                 │  exhibit "intelligent" behavior.       │
                 │  ┌──────────────────────────────────┐  │
                 │  │     MACHINE LEARNING (ML)        │  │
                 │  │  Learns patterns from data       │  │
                 │  │  rather than explicit rules.     │  │
                 │  │  ┌────────────────────────────┐  │  │
                 │  │  │    DEEP LEARNING (DL)      │  │  │
                 │  │  │  ML with multi-layer       │  │  │
                 │  │  │  neural networks.          │  │  │
                 │  │  │  ┌──────────────────────┐  │  │  │
                 │  │  │  │  GENERATIVE AI       │  │  │  │
                 │  │  │  │  DL that GENERATES   │  │  │  │
                 │  │  │  │  new content.        │  │  │  │
                 │  │  │  └──────────────────────┘  │  │  │
                 │  │  └────────────────────────────┘  │  │
                 │  └──────────────────────────────────┘  │
                 └────────────────────────────────────────┘
```

| Term | One-line definition | Example |
|------|---------------------|---------|
| **AI** | The broad discipline of making machines act intelligently. | A rule-based chatbot. |
| **ML** | A subset of AI where algorithms learn patterns from data. | Spam classifier trained on labeled emails. |
| **Deep Learning** | ML using neural networks with many hidden layers. | Image classification with a CNN. |
| **Generative AI** | DL models that generate new content (text, images, audio, code). | GPT-4, Claude, Stable Diffusion. |
| **Foundation Model (FM)** | A large pretrained model (often generative) that can be adapted to many tasks. | Anthropic Claude, Amazon Nova, Meta Llama. |
| **LLM** | A foundation model that generates and understands natural language. | Claude, GPT-4. |

---

## 2. Data — The Lifeblood of ML

### Structured vs Unstructured vs Semi-Structured

| Type | Characteristic | Examples | Typical storage |
|------|---------------|----------|-----------------|
| **Structured** | Rows & columns, strict schema | RDBMS tables, CSV with types | RDS, Redshift |
| **Semi-structured** | Has tags/keys but not rigid schema | JSON, XML, log files | S3, DynamoDB, OpenSearch |
| **Unstructured** | No predefined schema | Images, video, free text, audio | S3 |

### Labeled vs Unlabeled Data

- **Labeled data** — each example has a known target output (e.g., email + "spam"/"ham"). Needed for **supervised learning**.
- **Unlabeled data** — raw inputs only. Used in **unsupervised** or **self-supervised** learning.
- **Amazon SageMaker Ground Truth** and **Ground Truth Plus** help create labeled datasets using human annotators or automated labeling.

### Tabular / Time-Series / Text / Image / Audio

- **Tabular** — classic columns and rows. ML algorithms: XGBoost, Linear Regression, Random Forests.
- **Time-series** — ordered by time with temporal dependence. Models: ARIMA, Prophet, Amazon Forecast's DeepAR+.
- **Text** — natural language, tokenized for model input. Models: BERT, transformer LLMs.
- **Image** — pixel arrays. Models: CNNs, ViT (vision transformers).
- **Audio** — waveforms / spectrograms. Models: wav2vec, Whisper.

### Data Quality Dimensions

1. **Accuracy** — values match reality.
2. **Completeness** — no missing fields.
3. **Consistency** — same value across systems.
4. **Timeliness** — fresh enough for the use case.
5. **Uniqueness** — no duplicates.
6. **Validity** — conforms to defined format.
7. **Relevance** — actually relates to the task.

> The exam often asks "what's the problem with this scenario?" — the answer is usually a data-quality or bias issue.

---

## 3. Core ML Concepts

### 3.1 Features, Labels, Samples

- **Feature (independent variable / X)** — input attribute (e.g., `square_feet`).
- **Label (dependent variable / y)** — the target the model learns to predict (e.g., `price`).
- **Sample (observation / row)** — one data point.
- **Feature engineering** — manually crafting features (ratios, dates, one-hot encoding) to improve model performance.

### 3.2 Training, Validation, Test Sets

| Set | Purpose | Typical split |
|-----|---------|---------------|
| Training | Model learns parameters | 60–80% |
| Validation | Tune hyperparameters, avoid overfit | 10–20% |
| Test | Final unbiased performance estimate | 10–20% |

**Data leakage** — when information from the test set sneaks into training (e.g., same customer in both). Leads to over-optimistic metrics.

### 3.3 Parameters vs Hyperparameters

- **Parameters** — learned by the model during training (e.g., weights in a neural net).
- **Hyperparameters** — set **before** training (e.g., learning rate, batch size, number of layers, regularization strength). Tuned via search (grid, random, Bayesian) — SageMaker **Automatic Model Tuning** does this for you.

### 3.4 Overfitting vs Underfitting

| Symptom | Overfitting | Underfitting |
|---------|-------------|--------------|
| Train error | Very low | High |
| Validation/Test error | High | High |
| Cause | Model too complex, too little data, trained too long | Model too simple, too few features, too little training |
| Remedies | More data, regularization (L1/L2), dropout, early stopping, simpler model, cross-validation | Bigger model, more features, feature engineering, longer training |

**Bias–variance tradeoff** —
- **High bias** (underfit) — model assumptions too simple; misses real patterns.
- **High variance** (overfit) — model memorizes noise; fails on new data.
- Good models balance both.

### 3.5 Loss Functions & Optimizers

- **Loss function** — numerical measure of prediction error (e.g., MSE for regression, cross-entropy for classification).
- **Optimizer** — algorithm that updates weights to minimize loss (SGD, Adam, AdamW).
- **Gradient descent** — iteratively steps weights in the direction of steepest loss decrease.

### 3.6 Regularization

Reduces overfitting by penalizing complexity.
- **L1 (Lasso)** — penalty on absolute weights; drives some weights to zero (feature selection).
- **L2 (Ridge)** — penalty on squared weights; shrinks weights without zeroing.
- **Dropout** — randomly zero out neurons during training (neural nets).
- **Early stopping** — stop training when validation loss stops improving.

---

## 4. Neural Networks & Deep Learning

### 4.1 The Neuron

A neuron computes: `output = activation( Σ (wᵢ × xᵢ) + b )`
- `wᵢ` are weights, `b` is bias, `activation` is a non-linear function (ReLU, sigmoid, tanh, GELU).

### 4.2 Common Architectures

| Architecture | Typical use | Key idea |
|--------------|-------------|----------|
| **Feedforward NN (MLP)** | Tabular, generic | Fully connected layers |
| **Convolutional NN (CNN)** | Images, video | Convolutional filters capture spatial patterns |
| **Recurrent NN (RNN / LSTM / GRU)** | Sequences, pre-transformer NLP | Hidden state carries info through time |
| **Transformer** | Modern NLP, vision, audio, multimodal | Self-attention — every token attends to every other |
| **Diffusion** | Image/video generation | Iteratively denoise random noise into an image |
| **GAN** | Image generation pre-diffusion | Generator + Discriminator adversarial training |
| **Autoencoder / VAE** | Dimensionality reduction, generation | Encode to latent space then decode |

### 4.3 Why Deep Learning Won

- Massive data availability
- GPU / TPU / Trainium parallelism
- Better architectures (transformers, residual connections)
- Transfer learning — pretrain once, adapt cheaply

---

## 5. Generative AI — Why It's Different

### 5.1 Traditional ML vs Generative AI

| Dimension | Traditional ML | Generative AI |
|-----------|---------------|---------------|
| Output | Prediction / class / number | New content (text, image, audio, code) |
| Training data | Task-specific, labeled | Huge unlabeled corpora (self-supervised) + optional fine-tuning |
| Model size | KB to GB | GB to TB (billions to trillions of parameters) |
| Customization | Retrain | Prompt, RAG, fine-tune, continued pretraining |
| Usage cost | Train once, cheap to infer | Expensive to train, per-token inference cost |
| Core AWS service | SageMaker | **Bedrock** (plus SageMaker JumpStart) |

### 5.2 Key Generative AI Terms

- **Token** — chunk of text (roughly ¾ of a word in English). Models price per 1K tokens input + 1K tokens output.
- **Context window** — max tokens the model can consider in one call (e.g., 200K for Claude Sonnet, 2M for some Google models).
- **Embedding** — a numerical vector representing the semantic meaning of text/image. Used for search and RAG.
- **Prompt** — the input text you send.
- **Completion / Response** — what the model returns.
- **Temperature** — randomness. 0 = deterministic (factual Q&A); higher = more creative.
- **Top-p (nucleus sampling)** — sample from the smallest set of tokens whose cumulative probability ≥ p.
- **Top-k** — sample from the k most likely tokens.
- **Hallucination** — model confidently returns incorrect information. Mitigated with RAG and guardrails.
- **Grounding** — giving the model real documents so its answer is based on facts, not just training data.

---

## 6. Common ML Tasks You Should Recognize

| Task | Example | Typical metric |
|------|---------|----------------|
| Binary classification | Fraud / not fraud | Accuracy, Precision, Recall, F1, AUC-ROC |
| Multi-class classification | Cat / Dog / Bird | Accuracy, macro-F1 |
| Regression | House price | RMSE, MAE, R² |
| Clustering | Customer segments | Silhouette, Davies-Bouldin |
| Anomaly detection | Unusual login | Precision@k, AUC-PR |
| Ranking / Recommendation | Amazon product ranks | NDCG, MAP |
| Object detection | Bounding boxes in images | mAP, IoU |
| Segmentation | Pixel-level class | IoU, Dice |
| Translation | English → French | BLEU |
| Summarization | Article → TL;DR | ROUGE |
| Question answering | Given passage, answer a question | Exact Match, F1, BERTScore |

### Precision vs Recall (must know)

- **Precision** = TP / (TP + FP) — of everything I flagged, how many were right?
- **Recall (sensitivity)** = TP / (TP + FN) — of everything that was truly positive, how many did I catch?
- **F1** = harmonic mean of Precision & Recall.
- **Choose precision** when false positives are costly (spam filter should not flag legit emails).
- **Choose recall** when false negatives are costly (cancer screening must catch every case).

### Confusion Matrix
```
                    Predicted
                 +───────+───────+
                 │  Pos  │  Neg  │
           Pos   │  TP   │  FN   │
 Actual         +───────+───────+
           Neg   │  FP   │  TN   │
                 +───────+───────+
```

---

## 7. When NOT to Use ML

The exam sometimes asks this. Avoid ML when:
- You can solve it with deterministic rules (e.g., leap year check).
- You do not have enough good data.
- You cannot tolerate a probabilistic answer.
- The cost / risk / latency / explainability requirements cannot be met.
- There's no obvious business value.

**If rules work, use rules.** ML is a tool, not a religion.

---

## 8. AWS Compute for AI

| Option | Purpose |
|--------|---------|
| EC2 with NVIDIA GPU (P4, P5, G5, G6) | General ML training/inference |
| **AWS Trainium** (Trn1, Trn2) | Custom silicon for ML training — lower cost per training job |
| **AWS Inferentia** (Inf1, Inf2) | Custom silicon for ML inference — lower cost per inference |
| SageMaker managed instances | Abstracted compute for training & endpoints |
| Bedrock | Serverless — no instance selection needed for on-demand |

**Remember** — Trainium is for training, Inferentia is for inference. Both are AWS custom silicon.

---

## 9. Summary Cheat Table

| Concept | One-liner |
|---------|-----------|
| AI ⊃ ML ⊃ DL ⊃ GenAI | Nested subsets |
| Supervised | Labeled data |
| Unsupervised | No labels; find structure |
| Reinforcement | Trial and error with reward |
| Overfitting | Great on train, bad on test |
| Regularization | Penalize complexity |
| Transformer | Self-attention architecture powering modern LLMs |
| Embedding | Semantic vector |
| Hallucination | Confidently wrong output |
| RAG | Retrieve first, then generate |
| Temperature | Controls randomness |

> Next — [1.2 Types of Machine Learning](./02-ML-Types.md)
