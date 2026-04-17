# Domain 1 — Sample Questions (AI/ML Fundamentals)

50 questions. Each with answer and detailed explanation. Cover the answer with your hand, choose, then reveal.

---

**Q1.** A company wants to group its customers by purchasing behavior without any predefined labels. Which type of ML is most appropriate?
- A. Supervised learning
- B. Unsupervised learning
- C. Reinforcement learning
- D. Self-supervised learning

<details><summary>Answer</summary>**B.** No labels and the goal is to find structure — this is classic unsupervised clustering (e.g., K-Means).</details>

---

**Q2.** A model achieves 99% accuracy on training data but 62% on validation data. What is happening, and what is the best first fix?
- A. Underfitting — increase model complexity.
- B. Overfitting — apply regularization or collect more data.
- C. Data leakage — remove features.
- D. Model drift — retrain.

<details><summary>Answer</summary>**B.** Large gap between train and validation accuracy is overfitting. Regularization, dropout, more data, or a simpler model help.</details>

---

**Q3.** A bank needs to forecast next quarter's loan demand based on 3 years of daily data. Which AWS service is most appropriate?
- A. Amazon Rekognition
- B. Amazon Forecast (or SageMaker Canvas time-series)
- C. Amazon Comprehend
- D. Amazon Kendra

<details><summary>Answer</summary>**B.** Forecast / Canvas specialize in time-series forecasting. Rekognition is vision, Comprehend is NLP, Kendra is search.</details>

---

**Q4.** Which statement best describes the relationship between AI, ML, and Deep Learning?
- A. AI is a subset of ML.
- B. Deep Learning is a superset of ML.
- C. ML is a subset of AI, and Deep Learning is a subset of ML.
- D. They are independent disciplines.

<details><summary>Answer</summary>**C.** AI ⊃ ML ⊃ DL (⊃ GenAI).</details>

---

**Q5.** Which metric should you prefer for a highly imbalanced binary classification problem (e.g., rare fraud)?
- A. Accuracy
- B. AUC-PR (area under precision-recall)
- C. R²
- D. BLEU

<details><summary>Answer</summary>**B.** For imbalanced classes, accuracy is misleading; AUC-PR captures performance on the minority (positive) class. R² is regression, BLEU is translation.</details>

---

**Q6.** A data scientist wants to share features between model training and real-time inference to avoid training/serving skew. Which service helps?
- A. SageMaker Data Wrangler
- B. SageMaker Feature Store
- C. SageMaker Ground Truth
- D. SageMaker Canvas

<details><summary>Answer</summary>**B.** Feature Store has online + offline stores for exactly this scenario.</details>

---

**Q7.** Which AWS service is best for OCR of scanned invoices containing tables and key-value pairs?
- A. Rekognition
- B. Comprehend
- C. Textract
- D. Transcribe

<details><summary>Answer</summary>**C.** Textract extracts text, forms (KV), and tables — purpose-built for documents.</details>

---

**Q8.** A business analyst with no ML experience needs to build a predictive model from a CSV file of customer data. Which AWS service is most suitable?
- A. SageMaker Studio
- B. SageMaker Canvas
- C. SageMaker JumpStart
- D. SageMaker Pipelines

<details><summary>Answer</summary>**B.** Canvas is a no-code visual interface for business analysts. Studio is IDE-style; JumpStart is pretrained models; Pipelines is CI/CD.</details>

---

**Q9.** Which chip is designed specifically for cost-efficient ML training on AWS?
- A. AWS Inferentia
- B. AWS Trainium
- C. AWS Graviton
- D. AWS Nitro

<details><summary>Answer</summary>**B.** Trainium for training, Inferentia for inference. Graviton is general-purpose ARM; Nitro is the hypervisor stack.</details>

---

**Q10.** A company wants to detect anomalies in real-time streaming metrics like website conversion rate. Which service is a fit?
- A. Amazon Lookout for Vision
- B. Amazon Lookout for Metrics
- C. Amazon Forecast
- D. Amazon Fraud Detector

<details><summary>Answer</summary>**B.** Lookout for Metrics is purpose-built for business-metric anomalies.</details>

---

**Q11.** Which ML type is best described by "an agent learns by interacting with an environment and receiving rewards"?
- A. Supervised learning
- B. Reinforcement learning
- C. Self-supervised learning
- D. Transfer learning

<details><summary>Answer</summary>**B.** Definition of RL.</details>

---

**Q12.** Which SageMaker capability automatically tries multiple algorithms and hyperparameters on tabular data and returns a leaderboard?
- A. SageMaker JumpStart
- B. SageMaker Autopilot
- C. SageMaker Data Wrangler
- D. SageMaker Pipelines

<details><summary>Answer</summary>**B.** Autopilot = AutoML for tabular.</details>

---

**Q13.** A team wants to reduce training cost by up to 90% and can tolerate interruptions. Which option should they enable?
- A. Multi-Model Endpoints
- B. Managed Spot Training
- C. Provisioned Throughput
- D. Multi-AZ

<details><summary>Answer</summary>**B.** Managed Spot Training uses Spot capacity for up to 90% savings.</details>

---

**Q14.** Which label best describes "splitting text into units the model can process (~4 chars per unit in English)"?
- A. Embedding
- B. Token
- C. Parameter
- D. Vector

<details><summary>Answer</summary>**B.** Tokens are the units of input/output; cost is billed per 1K tokens.</details>

---

**Q15.** Which AWS service produces natural-sounding speech from text in dozens of voices and languages?
- A. Transcribe
- B. Polly
- C. Lex
- D. Translate

<details><summary>Answer</summary>**B.** Polly is text-to-speech.</details>

---

**Q16.** For a large payload (500 MB) processed asynchronously in up to 15 minutes, which SageMaker inference option is best?
- A. Real-time endpoint
- B. Serverless inference
- C. Asynchronous inference
- D. Multi-container endpoint

<details><summary>Answer</summary>**C.** Async inference is designed for large payloads and long processing.</details>

---

**Q17.** What does the "ROC-AUC" metric measure?
- A. Training time
- B. Model's ability to rank positives above negatives across thresholds
- C. Mean squared error
- D. Regularization strength

<details><summary>Answer</summary>**B.** AUC-ROC captures ranking quality independent of threshold.</details>

---

**Q18.** Which service is designed to label datasets using human workers or automated labeling with active learning?
- A. SageMaker Ground Truth
- B. SageMaker Studio
- C. Amazon A2I
- D. Amazon Mechanical Turk

<details><summary>Answer</summary>**A.** Ground Truth is the AWS labeling service (Mechanical Turk is one of its workforce options).</details>

---

**Q19.** Which type of learning uses a base model pretrained on general data and fine-tunes it on a small domain dataset?
- A. Reinforcement learning
- B. Transfer learning
- C. Semi-supervised learning
- D. Self-supervised learning

<details><summary>Answer</summary>**B.** Transfer learning is the canonical pretrain-then-fine-tune approach.</details>

---

**Q20.** A team is considering whether to use ML for a use case. Which is the strongest indicator that ML is NOT appropriate?
- A. There's a well-defined business value.
- B. The problem can be solved with deterministic rules.
- C. There is a lot of historical labeled data.
- D. Pattern detection is required.

<details><summary>Answer</summary>**B.** If deterministic rules work, use rules — ML is unnecessary complexity.</details>

---

**Q21.** What does "regularization" address in ML?
- A. Data labeling errors
- B. Model overfitting
- C. Feature scaling
- D. Class imbalance

<details><summary>Answer</summary>**B.** Regularization (L1, L2, dropout) penalizes complexity to reduce overfitting.</details>

---

**Q22.** Which service is best for a real-time chatbot that recognizes intents and slots?
- A. Amazon Lex
- B. Amazon Kendra
- C. Amazon Comprehend
- D. Amazon Polly

<details><summary>Answer</summary>**A.** Lex is Amazon's intent-based chatbot engine (same as Alexa).</details>

---

**Q23.** To detect bias in a trained classifier across a protected attribute, which AWS service is most appropriate?
- A. SageMaker Model Monitor (model quality)
- B. SageMaker Clarify (post-training bias)
- C. Amazon Macie
- D. Amazon Comprehend

<details><summary>Answer</summary>**B.** Clarify is the AWS service for bias detection and explainability.</details>

---

**Q24.** Which is NOT a deployment strategy for rolling out a new ML model?
- A. Blue/Green
- B. Canary
- C. Shadow / A-B testing
- D. L2 regularization

<details><summary>Answer</summary>**D.** L2 regularization is a training-time technique, not a deployment strategy.</details>

---

**Q25.** Which AWS service provides enterprise semantic search over connected content sources with natural-language answers?
- A. OpenSearch Service
- B. Kendra
- C. Lex
- D. Comprehend

<details><summary>Answer</summary>**B.** Kendra is the managed enterprise search service with NL queries.</details>

---

**Q26.** What is the purpose of `SageMaker Model Monitor`?
- A. Track training hyperparameters
- B. Detect data quality, model quality, bias, and feature attribution drift in production
- C. Version and approve models
- D. Run distributed training jobs

<details><summary>Answer</summary>**B.** Model Monitor watches endpoints and emits drift metrics.</details>

---

**Q27.** Which combination lets you host hundreds of per-customer models efficiently on one SageMaker endpoint?
- A. Multi-Container Endpoint
- B. Multi-Model Endpoint
- C. Serverless Inference
- D. Batch Transform

<details><summary>Answer</summary>**B.** MME loads models on demand and shares an instance, reducing cost.</details>

---

**Q28.** Which metric is most appropriate when false negatives are very costly (e.g., missing a cancer diagnosis)?
- A. Precision
- B. Recall
- C. F1
- D. AUC-ROC

<details><summary>Answer</summary>**B.** Recall ensures you catch positives even at the cost of more FPs.</details>

---

**Q29.** The goal is to allow non-developers to build generative AI applications using enterprise data with a visual builder. Which service?
- A. AWS DeepComposer
- B. Amazon Bedrock Studio
- C. AWS Glue
- D. Amazon SageMaker Canvas

<details><summary>Answer</summary>**B.** Bedrock Studio (via IAM Identity Center) provides a visual builder for GenAI apps.</details>

---

**Q30.** Amazon Personalize is most commonly used for:
- A. Summarizing meetings
- B. Real-time product and content recommendations
- C. Transcribing customer calls
- D. OCR on documents

<details><summary>Answer</summary>**B.** Personalize = real-time recommendations using Amazon.com-style algorithms.</details>

---

**Q31.** Which pair correctly identifies AWS custom silicon for ML?
- A. Trainium (training), Inferentia (inference)
- B. Inferentia (training), Trainium (inference)
- C. Graviton (training), Nitro (inference)
- D. Neuron (training), Tensor (inference)

<details><summary>Answer</summary>**A.** Trainium for training, Inferentia for inference.</details>

---

**Q32.** Which describes a `feature` and a `label`?
- A. A feature is the target, a label is the input.
- B. A feature is an input attribute, a label is the target output.
- C. Features are neurons, labels are weights.
- D. Features are test data, labels are train data.

<details><summary>Answer</summary>**B.** Features = inputs (X), labels = target (y).</details>

---

**Q33.** Which AWS service is tailored to extract medical entities and link them to ICD-10 / RxNorm ontologies?
- A. Amazon Comprehend Medical
- B. Amazon HealthLake
- C. Amazon Transcribe Medical
- D. Amazon Rekognition

<details><summary>Answer</summary>**A.** Comprehend Medical focuses on extracting medical entities and ontology linking.</details>

---

**Q34.** Which architecture is best suited to image classification?
- A. Transformer decoder only
- B. Convolutional Neural Network (CNN)
- C. Recurrent Neural Network
- D. Autoencoder

<details><summary>Answer</summary>**B.** CNNs capture spatial patterns efficiently. (Vision Transformers also work but CNN is the classic answer.)</details>

---

**Q35.** Which pipeline step in SageMaker Pipelines conditionally registers a model only if evaluation metrics meet a threshold?
- A. ProcessingStep
- B. TrainingStep
- C. ConditionStep followed by RegisterModelStep
- D. EndpointStep

<details><summary>Answer</summary>**C.** A ConditionStep gates the RegisterModelStep based on metrics.</details>

---

**Q36.** Which AWS service lets you quickly deploy a pretrained open-source model with one click?
- A. SageMaker JumpStart
- B. Amazon Rekognition Custom Labels
- C. Amazon Forecast
- D. SageMaker Canvas

<details><summary>Answer</summary>**A.** JumpStart offers one-click deployment and fine-tuning for many pretrained models.</details>

---

**Q37.** Which category of metric is BLEU?
- A. Classification metric
- B. Regression metric
- C. Machine translation metric
- D. Clustering metric

<details><summary>Answer</summary>**C.** BLEU measures n-gram overlap with reference translations.</details>

---

**Q38.** To detect clothing defects on a factory line with only 30 "normal" photos, which AWS service is most fitting?
- A. Rekognition
- B. Lookout for Vision
- C. Panorama
- D. Textract

<details><summary>Answer</summary>**B.** Lookout for Vision is specifically tuned for industrial anomaly/defect detection with few normal images.</details>

---

**Q39.** Which is TRUE about SageMaker Clarify?
- A. It is a visual data-prep tool.
- B. It provides bias analysis (pre-/post-training) and SHAP-based explanations.
- C. It replaces SageMaker Model Monitor.
- D. It stores labeled data.

<details><summary>Answer</summary>**B.** Clarify provides bias metrics and SHAP explanations. Data Wrangler is data prep; Ground Truth handles labels; Model Monitor is drift.</details>

---

**Q40.** Which service tracks each training run's hyperparameters, metrics, and artifacts for comparison?
- A. SageMaker Experiments
- B. SageMaker Debugger
- C. SageMaker Profiler
- D. SageMaker Clarify

<details><summary>Answer</summary>**A.** Experiments = run tracking.</details>

---

**Q41.** The `IAM policy` attached to a SageMaker training job (execution role) must include access to which of the following by default?
- A. S3 (data + output), ECR (container), CloudWatch Logs
- B. Route 53 and CloudFront
- C. Elastic Beanstalk and CodeDeploy
- D. DynamoDB and Redshift

<details><summary>Answer</summary>**A.** Training reads data from S3, pulls images from ECR, and writes logs to CloudWatch.</details>

---

**Q42.** Which of the following is a **hyperparameter**?
- A. The learned weight of a neuron
- B. Learning rate
- C. Output probability
- D. Gradient value

<details><summary>Answer</summary>**B.** Learning rate is set before training; weights are learned parameters.</details>

---

**Q43.** A company wants to compile a trained model to run efficiently on an edge device. Which service assists?
- A. SageMaker Neo
- B. SageMaker Edge Manager
- C. Panorama
- D. All of the above can play a role

<details><summary>Answer</summary>**D.** Neo compiles/optimizes models; Panorama runs CV at the edge on appliances; Edge Manager (legacy) manages edge fleet.</details>

---

**Q44.** Which AWS service can automatically pull a batch of low-confidence predictions for human review?
- A. SageMaker Ground Truth
- B. Amazon A2I (Augmented AI)
- C. AWS Audit Manager
- D. AWS Config

<details><summary>Answer</summary>**B.** A2I creates human review workflows with confidence-based triggers.</details>

---

**Q45.** Which of the following is a classic unsupervised algorithm?
- A. XGBoost
- B. K-Means
- C. Linear Regression
- D. Random Forest

<details><summary>Answer</summary>**B.** K-Means is clustering (unsupervised).</details>

---

**Q46.** Which SageMaker feature allows blocking all network access from the training container?
- A. VPC Mode
- B. Network Isolation
- C. Interface Endpoint
- D. Private Subnet

<details><summary>Answer</summary>**B.** Network Isolation disables all container networking. VPC Mode still allows VPC traffic.</details>

---

**Q47.** An architect needs to recommend an ML approach for a legacy rules-based system that categorizes tickets with 80% accuracy using fixed regex rules. The team has 50,000 labeled examples and wants to improve accuracy. Best approach?
- A. Rewrite with more complex regex
- B. Train a text classifier (Comprehend Custom Classification or SageMaker)
- C. Use Rekognition
- D. Use DeepRacer

<details><summary>Answer</summary>**B.** Text classification with labeled data is a supervised ML sweet spot.</details>

---

**Q48.** For call center audio, which pairing produces call summaries with sentiment?
- A. Polly + Translate
- B. Transcribe Call Analytics + Bedrock
- C. Rekognition Video + Lex
- D. Textract + Kendra

<details><summary>Answer</summary>**B.** Transcribe Call Analytics transcribes with sentiment/categories; Bedrock summarizes.</details>

---

**Q49.** Which is NOT one of the 7 ML lifecycle phases described in this study package?
- A. Data collection
- B. Business problem framing
- C. Model deployment
- D. Model watermarking

<details><summary>Answer</summary>**D.** Watermarking is a GenAI output control, not a lifecycle phase.</details>

---

**Q50.** Which AWS service is a hardware/software-as-a-service offering to monitor industrial equipment via attached sensors and ML?
- A. Amazon Monitron
- B. Amazon Forecast
- C. AWS Panorama
- D. Amazon Lookout for Metrics

<details><summary>Answer</summary>**A.** Monitron includes the sensors, gateway, and ML service for equipment monitoring.</details>
