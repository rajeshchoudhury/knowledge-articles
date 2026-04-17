# Flash Cards — AI / ML Fundamentals

> Cover the right column, quiz yourself on the left.

| Q | A |
|---|---|
| Define AI, ML, DL, GenAI in one line each | AI = any intelligent behavior; ML = learns from data; DL = ML with deep neural nets; GenAI = DL that generates new content |
| Supervised learning | Learns a function from labeled (X, y) pairs |
| Unsupervised learning | Finds structure in unlabeled data (clustering, anomaly detection) |
| Reinforcement learning | Agent learns by reward signals from environment |
| Self-supervised learning | Labels auto-generated from data (e.g., next-token prediction) |
| Semi-supervised | Small labeled + large unlabeled |
| Transfer learning | Start from a pretrained model, adapt to your task |
| Overfitting | Low train error, high test error — model memorized |
| Underfitting | High error everywhere — model too simple |
| Fix overfitting | More data, regularization, dropout, early stopping, simpler model |
| Bias–variance tradeoff | High bias = underfit; high variance = overfit |
| Parameters vs hyperparameters | Parameters learned during training; hyperparameters set before training |
| L1 vs L2 regularization | L1 zeroes weights (feature selection); L2 shrinks weights |
| Structured vs unstructured data | Rows/columns vs free text/images/audio |
| Label | The target output in supervised learning |
| Feature | An input attribute |
| Feature engineering | Crafting features to improve learning |
| Data leakage | Test-set info leaks into training → inflated metrics |
| Training/validation/test split | Train model / tune hyperparams / final eval |
| Epoch | One pass over the entire training dataset |
| Batch size | Samples per gradient update |
| Learning rate | Size of each weight update step |
| Loss function (classification) | Cross-entropy |
| Loss function (regression) | MSE / MAE |
| Gradient descent | Iteratively adjust weights to minimize loss |
| Classic ML algorithms for tabular | Linear Regression, Logistic Regression, Decision Trees, Random Forests, XGBoost, KNN, Naive Bayes |
| CNN use case | Images (spatial patterns) |
| RNN/LSTM use case | Sequences (pre-transformer) |
| Transformer idea | Self-attention — every token attends to every other |
| Confusion matrix | TP / FP / FN / TN table |
| Precision | TP / (TP + FP) |
| Recall | TP / (TP + FN) |
| F1 | Harmonic mean of precision and recall |
| AUC-ROC | Area under ROC curve — discrimination for any threshold |
| When to use AUC-PR | Highly imbalanced class problem |
| RMSE | Square root of MSE (regression) |
| Three main ML paradigms | Supervised, Unsupervised, Reinforcement |
| K-Means | Unsupervised clustering into k centroids |
| PCA | Unsupervised dimensionality reduction |
| Random Cut Forest | SageMaker anomaly detection algorithm |
| XGBoost | Gradient boosted trees, top tabular algorithm |
| AWS custom silicon for training | AWS Trainium |
| AWS custom silicon for inference | AWS Inferentia |
| Labeling service from AWS | SageMaker Ground Truth (+ Ground Truth Plus) |
| Feature Store purpose | Share features between training and real-time inference |
| Online vs offline feature store | Online: low-latency lookup; Offline: batch history in S3 |
| Data Wrangler purpose | Visual data prep inside SageMaker Studio |
| Autopilot | AutoML — tries many algorithms on tabular data |
| SageMaker Canvas | No-code ML for business users |
| JumpStart | One-click pretrained models & solutions |
| Automatic Model Tuning | Hyperparameter optimization (Bayesian / random / hyperband / grid) |
| Managed Spot Training benefit | Up to 90% cheaper training |
| Real-time vs Async vs Batch Transform | ms-s endpoint / large payload queued / offline bulk |
| Serverless Inference | Pay-per-use endpoint, cold-starts OK |
| Multi-Model Endpoint | Host many models on one endpoint |
| Shadow test | Mirror traffic to a new model, don't serve output |
| Model Monitor capabilities | Data quality, model quality, bias drift, feature attribution drift |
| Clarify capabilities | Pre-training bias, post-training bias, explainability (SHAP) |
| Model Cards | Document a model's intended use, data, metrics, caveats |
| Model Registry | Version and approve models |
| Pipelines | DAG for ML CI/CD (process, train, evaluate, register, deploy) |
| SageMaker Experiments | Track runs, metrics, params |
| Debugger | Live tensor inspection during training |
| SageMaker Neo | Compile models for target hardware |
| VPC Mode (SageMaker) | Training and endpoints inside your VPC |
| Network Isolation | Container has no network access |
| Edge deployment options | IoT Greengrass + Neo, Panorama |
| Rekognition | Image/video analysis (objects, faces, text, moderation) |
| Textract | OCR + forms + tables + IDs + invoices |
| Transcribe | Speech-to-text (batch + streaming; Medical) |
| Polly | Text-to-speech (Neural, Generative) |
| Translate | Neural machine translation |
| Comprehend | NLP: entities, sentiment, key phrases, PII, custom classification |
| Lex | Chatbots (Alexa engine) |
| Kendra | Intelligent enterprise search |
| Personalize | Real-time recommendations |
| Forecast | Time-series forecasting |
| Fraud Detector | Pre-built online fraud models |
| Lookout for Vision | Image defect detection |
| Lookout for Equipment | Predictive maintenance from sensors |
| Lookout for Metrics | Anomaly detection on business metrics |
| Panorama | CV at the edge (on-prem) |
| Bedrock | Serverless foundation models as a service |
| Q Business | Enterprise AI chat with your data |
| Q Developer | Coding assistant in IDE |
| Q in QuickSight | NL BI queries & narratives |
| Q in Connect | Contact-center live agent assist |
| DeepRacer | 1/18 RL race car for learning |
| ML services layer (3 layers) | AI services / ML services / Infrastructure |
| Well-Architected lens for ML | "Machine Learning Lens" |
| Service to label data | SageMaker Ground Truth |
| Service for auto feature prep | SageMaker Data Wrangler |
| Service to host a pretrained FM | Amazon Bedrock |
| Service to train your own model | SageMaker |

Target: memorize ≥ 90% of the right column before the exam.
