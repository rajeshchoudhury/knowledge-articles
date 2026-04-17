# AWS SAP-C02 Practice Test 38 — Machine Learning and AI Services

> **Theme:** SageMaker, Bedrock, Rekognition, Comprehend, Kendra, Personalize — when to use which  
> **Questions:** 75 | **Time Limit:** 180 minutes  
> **Domain Distribution:** D1 ≈ 20 | D2 ≈ 22 | D3 ≈ 11 | D4 ≈ 9 | D5 ≈ 13

---

### Question 1
A retail company wants to build a product recommendation engine for their e-commerce platform. They have 5 years of historical purchase data, user browsing behavior, and product metadata. The recommendations need to update in real-time as users browse. The team has limited ML expertise. Which AWS service should the solutions architect recommend?

A) Build a custom recommendation model using Amazon SageMaker with a factorization machines algorithm.  
B) Use Amazon Personalize — import user interactions (purchases, views, clicks), item metadata, and user metadata as datasets. Create a solution using the User-Personalization recipe for real-time recommendations. Deploy a Personalize campaign for real-time API access. Use event trackers to capture real-time browsing events that update recommendations immediately.  
C) Use Amazon Kendra to search for relevant products based on user queries.  
D) Deploy a pre-built recommendation model from AWS Marketplace on SageMaker.

**Correct Answer: B**
**Explanation:** Amazon Personalize is purpose-built for recommendation systems. It automatically trains models using your interaction data without requiring ML expertise. The User-Personalization recipe handles the common "what should we recommend to this user" scenario. Event trackers enable real-time personalization by incorporating live browsing behavior. Option A requires ML expertise for feature engineering, model selection, and tuning. Option C is an enterprise search service, not a recommendation engine. Option D requires evaluation and integration effort.

---

### Question 2
A legal firm wants to build an intelligent document search system. Lawyers need to ask natural language questions like "What are the liability clauses in the Smith contract?" and get precise answers from thousands of legal documents stored in S3. The system should understand document context, not just keyword matching. What should the architect recommend?

A) Use Amazon OpenSearch with full-text search across the documents.  
B) Use Amazon Kendra — create a Kendra index, configure an S3 data source connector to ingest the legal documents, and use Kendra's natural language query capability. Kendra uses ML to understand query intent and returns precise answers extracted from documents (not just matching documents). Configure FAQ datasets for common legal questions. Enable Kendra's document enrichment for metadata extraction.  
C) Use Amazon Comprehend to analyze documents and build a custom search.  
D) Build a RAG (Retrieval Augmented Generation) pipeline using Bedrock with OpenSearch as the vector store.

**Correct Answer: B**
**Explanation:** Amazon Kendra is an intelligent enterprise search service that uses NLP to understand natural language queries and return precise answers from documents. It supports S3 connectors for automatic document ingestion, understands document formats (PDF, Word, HTML), and ranks results by relevance. For a legal firm with existing documents, Kendra provides the fastest path to intelligent search. Option A provides keyword search, not semantic understanding. Option C analyzes text but doesn't provide search. Option D works but requires more engineering effort for what Kendra provides natively.

---

### Question 3
A healthcare company needs to extract patient information from handwritten medical forms, including names, dates, medications, and dosages. The forms vary in format across different clinics. They need structured data output that can be stored in a database. What AWS services should the architect use?

A) Use Amazon Rekognition to read the handwritten text from forms.  
B) Use Amazon Textract to extract handwritten and printed text from forms, including key-value pairs and table data. For medical-specific entity extraction (medications, dosages, conditions), pipe the Textract output through Amazon Comprehend Medical, which identifies PHI (Protected Health Information) entities like medication names, dosages, diagnosis codes, and patient identifiers. Store structured results in DynamoDB.  
C) Use Amazon Transcribe to convert form images to text.  
D) Train a custom Amazon SageMaker model for handwritten form recognition.

**Correct Answer: B**
**Explanation:** Textract specializes in document text extraction — it handles handwriting, key-value pairs (form fields), and tables from scanned documents. Comprehend Medical adds healthcare-specific NER (Named Entity Recognition) — it identifies medical entities like medications (RxNorm), conditions (ICD-10), and dosages from unstructured text. This pipeline gives structured, medical-domain-enriched output. Option A — Rekognition does image analysis (objects, faces), not document text extraction. Option C — Transcribe converts audio to text, not images. Option D requires significant training data and ML expertise.

---

### Question 4
A media company wants to automatically moderate user-uploaded images and videos to detect inappropriate content (nudity, violence, offensive symbols). The moderation needs to work at scale (100,000 uploads per day) and flag content for human review when confidence is below a threshold. What should the architect design?

A) Hire a team of human moderators to review all uploads manually.  
B) Use Amazon Rekognition Content Moderation. For images, use the DetectModerationLabels API. For videos, use StartContentModeration for async processing. Set confidence thresholds — content above the threshold is automatically rejected, content below is queued for human review via Amazon Augmented AI (A2I). Use S3 event notifications to trigger Lambda → Rekognition for automatic processing of each upload.  
C) Train a custom image classification model on SageMaker for content moderation.  
D) Use Amazon Comprehend to analyze the text descriptions of images for inappropriate content.

**Correct Answer: B**
**Explanation:** Rekognition Content Moderation is pre-trained to detect inappropriate content categories (explicit nudity, suggestive, violence, disturbing, offensive). It returns confidence scores per category, enabling threshold-based automation. A2I provides a managed human review workflow for edge cases. The S3 → Lambda → Rekognition pipeline scales automatically. Option A doesn't scale. Option C requires labeled training data for moderation categories (expensive and time-consuming). Option D only analyzes text, not visual content.

---

### Question 5
A multinational corporation needs to analyze customer support emails in 15 languages to detect sentiment, extract key topics, and identify personally identifiable information (PII) for GDPR compliance. They receive 50,000 emails daily. What should the architect recommend?

A) Build custom NLP models for each language using SageMaker.  
B) Use Amazon Comprehend — it natively supports sentiment analysis, entity extraction, key phrase extraction, and PII detection across multiple languages. Create an async batch processing pipeline: S3 (email storage) → Lambda → Comprehend batch jobs (StartSentimentDetectionJob, StartPiiEntitiesDetectionJob, StartKeyPhrasesDetectionJob). Results are written to S3 and loaded into a data warehouse for analysis. Use Comprehend's language detection first to route emails to language-specific processing.  
C) Use Amazon Translate to convert all emails to English and then analyze with a single English NLP model.  
D) Use Amazon Kendra to search through emails for PII patterns.

**Correct Answer: B**
**Explanation:** Amazon Comprehend provides pre-trained NLP capabilities (sentiment, entities, key phrases, PII detection) across 12+ languages without requiring ML expertise. Batch APIs handle high volume efficiently. The pipeline automates ingestion, analysis, and storage. Language detection ensures correct model selection per email. Option A requires building 15 models (enormous effort). Option C — translation introduces errors and loses language-specific nuances. Option D — Kendra is for search, not NLP analysis.

---

### Question 6
A company wants to build a chatbot that can answer questions about their internal HR policies, benefits documentation, and employee handbook. The chatbot should generate natural-sounding responses, not just return document snippets. The source documents are updated quarterly. What architecture provides the most accurate responses?

A) Fine-tune a large language model (LLM) on the HR documents using SageMaker.  
B) Implement a Retrieval Augmented Generation (RAG) architecture using Amazon Bedrock and Amazon Kendra. Kendra indexes the HR documents and serves as the knowledge base. When a user asks a question, Kendra retrieves relevant document passages. These passages are provided as context to a Bedrock foundation model (Claude/Titan), which generates a natural-sounding answer grounded in the retrieved content. Quarterly document updates are handled by Kendra's sync scheduler.  
C) Use Amazon Lex for the chatbot with static responses programmed for each FAQ.  
D) Deploy a custom GPT model and hope it knows the company's HR policies.

**Correct Answer: B**
**Explanation:** RAG combines the retrieval accuracy of Kendra (finds relevant HR policy passages) with the generative capability of Bedrock LLMs (produces natural answers). This architecture avoids hallucination by grounding responses in actual documents. When documents update, Kendra re-syncs — no model retraining needed. Option A — fine-tuning is expensive and requires retraining with each document update. Option C can't handle free-form questions. Option D — a general LLM doesn't know company-specific policies and will hallucinate.

---

### Question 7
A manufacturing company wants to detect defects in products on their assembly line using computer vision. They have 10,000 images of defective products and 100,000 images of good products. The model needs to run inference at the edge (in the factory) with <100ms latency. What architecture should the architect design?

A) Upload images to S3 and call Rekognition's custom labels API for each image.  
B) Train a custom object detection model using Amazon SageMaker. Use SageMaker's built-in image classification algorithm or bring a PyTorch/TensorFlow model. After training, compile the model using SageMaker Neo for edge optimization. Deploy the compiled model to AWS IoT Greengrass on the factory's edge device for local inference with <100ms latency. Use SageMaker Edge Manager for model versioning and monitoring at the edge.  
C) Use Amazon Lookout for Vision, which is specifically designed for visual anomaly detection in manufacturing. Upload training images, and Lookout for Vision automatically trains a model. For edge deployment, export the model to AWS Panorama or a Greengrass device.  
D) Use Amazon Rekognition to detect objects in images.

**Correct Answer: C**
**Explanation:** Amazon Lookout for Vision is purpose-built for visual anomaly detection in manufacturing/industrial settings. It requires minimal ML expertise — you upload normal and anomalous images, and it automatically trains a model. It supports edge deployment via Panorama or Greengrass for low-latency inference. Option B works but requires more ML expertise. Option A doesn't support edge inference (requires round-trip to AWS). Option D — Rekognition's general object detection isn't tuned for manufacturing defect detection.

---

### Question 8
A financial services company needs to detect fraudulent transactions in real-time. They have historical transaction data with labeled fraud cases. The model must process transactions in under 50ms and handle 10,000 transactions per second. What should the architect design?

A) Use Amazon Fraud Detector, which is purpose-built for fraud detection. Upload historical transaction data with fraud labels. Fraud Detector automatically trains an ML model. Create a detector version and deploy it. Use the GetEventPrediction API for real-time scoring. For <50ms latency at 10K TPS, deploy behind SageMaker real-time inference endpoints with auto-scaling as a complement for custom features.  
B) Build a rules-based fraud detection system without ML.  
C) Use Amazon Comprehend to analyze transaction descriptions.  
D) Deploy an open-source fraud detection model on EC2 instances.

**Correct Answer: A**
**Explanation:** Amazon Fraud Detector is specifically designed for transaction fraud detection. It handles feature engineering, model training, and deployment automatically. It combines ML models with business rules for comprehensive fraud detection. The GetEventPrediction API provides real-time scoring. For extreme throughput requirements, the managed service handles scaling. Option B misses complex fraud patterns that ML detects. Option C analyzes text, not transaction patterns. Option D requires managing infrastructure and model operations.

---

### Question 9
A news organization wants to automatically generate summaries of long articles, translate them into 10 languages, and create audio versions for their podcast. The workflow must be fully automated. What pipeline should the architect design?

A) Hire multilingual writers to manually summarize and translate articles.  
B) Build an automated pipeline: (1) Amazon Bedrock (Claude/Titan) to generate article summaries from the full text. (2) Amazon Translate to translate summaries into 10 languages. (3) Amazon Polly to convert translated summaries into natural-sounding speech in each language. Orchestrate with Step Functions: S3 article upload → Lambda → Bedrock summarization → Translate → Polly → S3 audio output. Use Polly's Neural TTS for natural-sounding voices.  
C) Use Amazon Comprehend for summarization, Translate for translation, and Transcribe for audio.  
D) Use SageMaker to train custom models for each task.

**Correct Answer: B**
**Explanation:** This pipeline combines purpose-built AI services: Bedrock provides high-quality summarization using foundation models, Translate handles multi-language translation, and Polly converts text to speech with neural voices. Step Functions orchestrates the workflow. Each service scales independently. Option A doesn't scale. Option C — Comprehend doesn't summarize, and Transcribe converts speech-to-text (not text-to-speech). Option D requires training three separate models from scratch.

---

### Question 10
A company is building a customer service platform. They want to analyze customer call recordings to extract insights: transcribe calls, identify customer sentiment throughout the call, detect when a customer becomes frustrated, and extract key topics discussed. What AWS services should the architect use?

A) Use Amazon Rekognition to analyze call recordings.  
B) Use Amazon Transcribe to convert call recordings to text (with speaker diarization to separate agent/customer). Pipe the transcription to Amazon Comprehend for sentiment analysis (per utterance) and key phrase extraction. Use Amazon Transcribe Call Analytics, which provides turn-by-turn sentiment, interruption detection, talk time metrics, and issue detection automatically. Store results in S3 and visualize with QuickSight.  
C) Use Amazon Polly to process the audio recordings.  
D) Use Amazon Lex to replay the call recordings and detect intents.

**Correct Answer: B**
**Explanation:** Transcribe Call Analytics is specifically designed for contact center audio analysis. It provides transcription, speaker separation, turn-by-turn sentiment scores, interruptions, silence periods, and key topics — all in one API call. This identifies when customer frustration escalates (negative sentiment trend) and what topics caused it. Comprehend adds deeper NLP analysis on the transcript. Option A — Rekognition is for images/video. Option C — Polly is text-to-speech. Option D — Lex is a chatbot builder.

---

### Question 11
A company has deployed a SageMaker real-time inference endpoint for their ML model. The endpoint handles variable traffic — peak hours see 1,000 requests/second while off-peak drops to 10 requests/second. They want to minimize cost while maintaining <200ms latency during peaks. What should the architect configure?

A) Provision a fixed number of large instances to handle peak traffic at all times.  
B) Configure SageMaker inference auto-scaling based on the InvocationsPerInstance CloudWatch metric. Set a target tracking scaling policy with a target of 500 invocations per instance. Set minimum instance count to 1 and maximum to handle peak load. For faster scaling, use SageMaker Inference Recommender to identify the optimal instance type and configure step scaling policies for rapid scale-up.  
C) Use SageMaker Serverless Inference to handle all traffic.  
D) Deploy the model on Lambda with a 15-minute timeout.

**Correct Answer: B**
**Explanation:** SageMaker auto-scaling adjusts instance count based on traffic. Target tracking on InvocationsPerInstance maintains a target utilization level. Inference Recommender identifies the optimal instance type for cost/performance. Step scaling enables rapid scale-up for sudden traffic spikes. Minimum count of 1 ensures availability. Option A wastes money during off-peak. Option C — Serverless Inference has cold starts that may exceed 200ms latency at scale. Option D — Lambda has a 10GB memory limit and cold start issues for large ML models.

---

### Question 12
A healthcare AI company needs to deploy a custom large language model (LLM) with 70 billion parameters for medical text analysis. The model requires 140GB of GPU memory for inference. It must be deployed as a real-time endpoint. What SageMaker deployment configuration should the architect use?

A) Deploy on a single ml.p3.2xlarge instance with 16GB GPU memory.  
B) Deploy on SageMaker using a large model inference (LMI) container. Use ml.p4d.24xlarge instances (8 x A100 GPUs, 320GB GPU memory) with tensor parallelism to distribute the model across multiple GPUs. Use SageMaker's model parallel inference capabilities with DeepSpeed or Hugging Face's text-generation-inference container for efficient serving.  
C) Use SageMaker Serverless Inference for the 70B model.  
D) Split the model into 10 smaller models and deploy on separate endpoints.

**Correct Answer: B**
**Explanation:** A 70B parameter model at FP16 requires ~140GB GPU memory, which exceeds a single GPU's capacity. SageMaker LMI containers support tensor parallelism — splitting the model across multiple GPUs on a single instance (p4d.24xlarge has 8 A100s with 40GB each = 320GB total). DeepSpeed/text-generation-inference optimize serving performance. Option A — p3.2xlarge has only 16GB GPU memory. Option C — Serverless doesn't support LMI or multi-GPU models. Option D — model splitting is different from tensor parallelism and doesn't preserve the model's capabilities.

---

### Question 13
A company wants to use Amazon Bedrock to build a customer-facing AI assistant. They need to ensure that the AI doesn't generate harmful, biased, or off-topic responses. The assistant should stay focused on the company's product domain. What guardrails should the architect implement?

A) Rely on the foundation model's built-in safety training without additional guardrails.  
B) Use Amazon Bedrock Guardrails — configure content filters for hate, violence, sexual content, and insults with configurable thresholds. Define denied topics to prevent off-topic responses (e.g., political opinions, medical advice). Add word filters for company-specific blocked terms. Enable PII redaction to prevent the model from outputting sensitive data. Implement the guardrail as a layer between the application and the Bedrock model invocation.  
C) Implement prompt engineering without additional safety layers.  
D) Build a custom content moderation model that screens every Bedrock response.

**Correct Answer: B**
**Explanation:** Bedrock Guardrails provides managed content filtering, topic restriction, word filtering, and PII handling. It wraps the model invocation with configurable safety layers — no custom model needed. Content filters have adjustable thresholds (low/medium/high). Denied topics prevent the model from engaging in off-domain conversations. PII redaction protects sensitive data. Option A is insufficient for production use. Option C — prompt engineering helps but isn't reliable enough for content safety. Option D adds complexity that Guardrails handles natively.

---

### Question 14
A logistics company tracks thousands of delivery vehicles. They want to detect anomalous vehicle behavior (unusual routes, unexpected stops, speed anomalies) from GPS and sensor data without labeled examples of anomalies. What approach should the architect take?

A) Use Amazon Rekognition to detect vehicles from satellite imagery.  
B) Use Amazon Lookout for Metrics — ingest GPS/sensor time-series data (speed, location, stop duration) as metrics. Lookout for Metrics automatically detects anomalies in the metrics using ML, without requiring labeled training data (unsupervised learning). Configure SNS notifications for detected anomalies. For custom anomaly detection, use SageMaker with the Random Cut Forest (RCF) algorithm, which is designed for unsupervised anomaly detection on time-series/streaming data.  
C) Define static threshold alerts (speed > 80mph) using CloudWatch Alarms.  
D) Use Amazon Fraud Detector for vehicle anomaly detection.

**Correct Answer: B**
**Explanation:** Lookout for Metrics detects anomalies in time-series data using unsupervised ML — no labeled examples needed. It learns normal patterns and flags deviations. SageMaker's RCF algorithm is also designed for unsupervised anomaly detection. Both handle the "no labeled anomaly data" constraint. Option A — Rekognition processes images, not GPS/sensor data. Option C — static thresholds miss complex anomalies (e.g., unusual route even at normal speed). Option D is for transaction fraud, not vehicle behavior analysis.

---

### Question 15
A company is building a multi-modal search system where users can search products by uploading an image ("find similar products") or by text description. The search should understand visual similarity and semantic meaning. What architecture should the architect design?

A) Use Amazon Rekognition for image search and OpenSearch for text search, keeping them separate.  
B) Use Amazon Bedrock with multi-modal embedding models (Titan Multimodal Embeddings) to generate vector embeddings for both images and text descriptions. Store embeddings in Amazon OpenSearch Serverless (vector search) or Amazon Aurora with pgvector. When a user uploads an image or text, generate its embedding and perform a k-nearest-neighbors (kNN) search to find similar products. This unified embedding space allows cross-modal search.  
C) Use Amazon SageMaker to train a CLIP model from scratch.  
D) Store images in S3 and use S3 Select to search by metadata.

**Correct Answer: B**
**Explanation:** Multi-modal embeddings encode both images and text into the same vector space. Visually similar products and semantically similar descriptions produce nearby vectors. kNN search across this unified space enables "find similar by image" and "find similar by description" in a single system. Bedrock's Titan Multimodal Embeddings provide this without training. OpenSearch Serverless provides managed vector search. Option A creates two disconnected search systems. Option C requires extensive training. Option D doesn't support visual similarity.

---

### Question 16
A media company needs to generate automatic closed captions for live video streams in real-time. The streams are in English but captions are needed in English, Spanish, and French simultaneously. What should the architect design?

A) Hire human translators to provide real-time captioning.  
B) Use Amazon Transcribe Streaming for real-time speech-to-text conversion of the live video's audio track. Pipe the English transcript through Amazon Translate (real-time translation) for Spanish and French. Use Amazon IVS (Interactive Video Service) or MediaLive for the video stream with timed metadata for caption synchronization. The pipeline: audio stream → Transcribe Streaming → English caption + Translate → Spanish/French captions → embed as timed metadata in the video stream.  
C) Pre-translate all possible captions and select them during the stream.  
D) Use Amazon Polly to generate captions from the audio.

**Correct Answer: B**
**Explanation:** Transcribe Streaming provides real-time speech-to-text with low latency (partial results as they're recognized). Translate processes the transcript in near-real-time for Spanish and French. Timed metadata embeds captions synchronized with the video frame. This pipeline runs continuously during the live stream. Option A doesn't scale and is expensive. Option C is impossible for live, unscripted content. Option D — Polly is text-to-speech, not speech-to-text.

---

### Question 17
A pharmaceutical company needs to analyze clinical trial documents to extract relationships between drugs, conditions, dosages, and outcomes. The documents contain complex medical terminology. They want to identify potential adverse drug interactions mentioned in the literature. What should the architect recommend?

A) Use Amazon Comprehend for general entity extraction.  
B) Use Amazon Comprehend Medical to extract medical entities (medications, conditions, dosages, procedures) and their relationships from clinical text. Comprehend Medical's DetectEntities API identifies entity types and attributes. Use the InferRxNorm API to link medications to standard RxNorm codes and InferICD10CM for conditions. For relationship extraction (drug-condition interactions), use Comprehend Medical's relationship detection capabilities. Store extracted relationships in Amazon Neptune (graph database) for interaction analysis.  
C) Use Amazon Kendra to search for drug interactions in the documents.  
D) Build a custom NER model using SageMaker for medical entities.

**Correct Answer: B**
**Explanation:** Comprehend Medical is specifically designed for medical text analysis. It extracts medical entities (medication, condition, anatomy, procedure), normalizes them to standard codes (RxNorm, ICD-10), and detects relationships between entities. Neptune as a graph database naturally models drug-condition relationships, enabling graph queries for interaction patterns. Option A — general Comprehend doesn't understand medical terminology. Option C — Kendra searches documents but doesn't extract structured relationships. Option D requires labeled medical training data, which is expensive and requires domain expertise.

---

### Question 18
A company wants to use generative AI to create marketing content (product descriptions, social media posts, email campaigns) personalized for different customer segments. They want to ensure the generated content aligns with their brand voice and product catalog. What architecture should the architect design?

A) Use a generic LLM to generate content without any customization.  
B) Use Amazon Bedrock with a foundation model (Claude/Titan). Implement a Knowledge Base backed by S3 (containing brand guidelines, product catalog, past successful campaigns). Use Bedrock agents to orchestrate content generation: the agent retrieves relevant brand voice guidelines and product details from the knowledge base, then prompts the model with segment-specific instructions and the retrieved context. Fine-tune the model on the company's past marketing content using Bedrock's custom model training for brand-specific style.  
C) Hire copywriters for each customer segment.  
D) Use Amazon Personalize to generate marketing content.

**Correct Answer: B**
**Explanation:** Bedrock Knowledge Bases enable RAG with company-specific data (brand guidelines, product catalog), ensuring generated content is grounded in actual product information. Bedrock agents orchestrate the retrieval-generation workflow. Fine-tuning on past campaigns adapts the model's style to match the brand voice. Segment-specific prompts customize output per audience. Option A produces generic, off-brand content. Option C doesn't scale. Option D — Personalize provides recommendations, not content generation.

---

### Question 19
A security company processes surveillance video streams from 500 cameras. They need to detect specific persons of interest (from a watchlist) in real-time across all streams. When a match is detected, security personnel should be alerted within 5 seconds. What should the architect design?

A) Download video frames and process them with Amazon Rekognition batch API.  
B) Use Amazon Rekognition Video Streaming — create a Kinesis Video Stream for each camera. Use Rekognition's Stream Processor with a face collection (containing indexed faces of persons of interest). Rekognition continuously analyzes the video stream and publishes match notifications to a Kinesis Data Stream. A Lambda function processes matches and sends alerts via SNS within seconds. Scale by creating multiple stream processors.  
C) Use Amazon SageMaker with a custom facial recognition model.  
D) Store video frames in S3 and process them hourly.

**Correct Answer: B**
**Explanation:** Rekognition Video Streaming integrates with Kinesis Video Streams for real-time video analysis. The face collection stores indexed faces (watchlist). The stream processor continuously compares detected faces against the collection. Matches trigger Kinesis Data Stream events processed by Lambda for real-time alerting. This architecture handles 500 cameras with parallel stream processors. Option A — batch processing isn't real-time. Option C requires building and maintaining a custom model. Option D has unacceptable latency for security alerts.

---

### Question 20
A company wants to build a voice-controlled application that allows users to query their business data by speaking naturally (e.g., "What were last quarter's sales in the Northeast region?"). The system should understand intent, extract parameters, and query the database. What should the architect design?

A) Use Amazon Transcribe to convert speech to text and build custom intent parsing.  
B) Build a pipeline: Amazon Transcribe converts speech to text → Amazon Lex interprets the text (intent recognition: "QuerySales"; slot extraction: quarter="Q4", region="Northeast") → Lex fulfillment Lambda function queries the database → Lambda returns the result → Amazon Polly converts the text response to speech for the user. Lex provides the NLU (Natural Language Understanding) for intent and slot extraction.  
C) Use Amazon Kendra to search for the answer in documents.  
D) Use Amazon Bedrock to directly query the database from voice input.

**Correct Answer: B**
**Explanation:** This pipeline combines purpose-built services: Transcribe for accurate speech-to-text, Lex for NLU (understanding "last quarter's sales in the Northeast" means intent=QuerySales with specific parameters), Lambda for database query execution, and Polly for text-to-speech response. Lex's intent/slot model structured approach is reliable for database queries. Option A requires building custom NLU. Option C searches documents, not databases. Option D — Bedrock can't directly query databases without significant orchestration.

---

### Question 21
A company has deployed multiple ML models in production using SageMaker. They need to track model performance over time, detect when model accuracy degrades (data drift), and automatically trigger retraining. What should the architect implement?

A) Manually check model predictions weekly and retrain when accuracy drops.  
B) Use SageMaker Model Monitor to continuously evaluate inference data against the training data baseline. Configure data quality monitoring (detect feature drift), model quality monitoring (detect prediction accuracy degradation), and bias drift monitoring. When drift is detected, Model Monitor publishes CloudWatch metrics and events. Create an EventBridge rule that triggers a SageMaker Pipeline for automated retraining when drift thresholds are breached.  
C) Deploy new models monthly regardless of performance.  
D) Use CloudWatch metrics on endpoint invocation errors as a proxy for model quality.

**Correct Answer: B**
**Explanation:** SageMaker Model Monitor provides automated, continuous model evaluation. Data quality monitoring detects when input feature distributions shift from training data (data drift). Model quality monitoring tracks accuracy metrics against ground truth. Bias drift monitoring catches fairness degradation. CloudWatch/EventBridge integration enables automated retraining pipelines. Option A is manual and reactive. Option C wastes resources on unnecessary retraining. Option D — invocation errors don't indicate model quality degradation.

---

### Question 22
An insurance company needs to process claims documents automatically. Claims arrive as scanned PDFs containing forms, tables, handwritten notes, and attached photos (vehicle damage, property damage). The system should extract claim details, assess damage from photos, and route the claim for processing. What pipeline should the architect design?

A) Hire data entry operators to manually process claims.  
B) Build an intelligent document processing pipeline: (1) Amazon Textract AnalyzeDocument for forms and tables extraction (key-value pairs, structured data). (2) Amazon Textract AnalyzeExpense for receipt/invoice processing within the claim. (3) Amazon Rekognition Custom Labels to classify damage severity from photos (trained on labeled damage images). (4) Amazon Comprehend to extract relevant entities from handwritten notes. (5) Step Functions orchestrates the pipeline, aggregating all extracted data. (6) Results stored in DynamoDB with the claim routed to the appropriate processing queue based on damage severity and claim amount.  
C) Use a single Amazon Bedrock model for all document and image processing.  
D) Use Amazon Kendra to search for similar past claims.

**Correct Answer: B**
**Explanation:** This pipeline uses purpose-built AI services for each task: Textract for document extraction (forms, tables, receipts), Rekognition for image analysis (damage assessment), Comprehend for text analysis (handwritten notes). Step Functions orchestrates the multi-step workflow. Each service is optimized for its specific modality and task. Option A doesn't scale. Option C — a single model can't handle all modalities as effectively as purpose-built services. Option D searches existing claims but doesn't process new ones.

---

### Question 23
A company wants to provide real-time language translation in their customer support chat application. Agents speak English, and customers speak various languages. The translation must handle domain-specific terminology (product names, technical terms) correctly. What should the architect design?

A) Use Amazon Translate with real-time translation API.  
B) Use Amazon Translate with custom terminology. Create a custom terminology CSV file mapping domain-specific terms (product names, technical terms) to their translations in each supported language. Upload the terminology to Translate. When calling the TranslateText API, specify the custom terminology so Translate preserves these terms or translates them according to the mapping rather than generic translation. Integrate with Amazon Connect or the chat application via Lambda.  
C) Build a custom translation model using SageMaker.  
D) Use Amazon Comprehend to detect the customer's language, then use a third-party translation API.

**Correct Answer: B**
**Explanation:** Amazon Translate with custom terminology ensures domain-specific terms are translated correctly. Generic neural machine translation might mistranslate product names or technical terms. Custom terminology overrides generic translation for specified terms. The real-time API provides low-latency translation for chat. Option A misses domain-specific terminology handling. Option C requires massive parallel training data per language pair. Option D adds third-party dependency when AWS has a native service.

---

### Question 24
A company is building a generative AI application using Amazon Bedrock. They need to ensure that the model has access to their proprietary product data when generating responses. The product data changes daily. They want the most operationally efficient RAG implementation. What should the architect use?

A) Fine-tune the Bedrock model daily with the latest product data.  
B) Use Amazon Bedrock Knowledge Bases. Create a knowledge base with an S3 data source containing product documentation. Bedrock automatically chunks the documents, generates embeddings using the configured embedding model, and stores them in a managed vector store (Amazon OpenSearch Serverless). Configure a sync schedule to update daily. At query time, Bedrock retrieves relevant chunks, provides them as context to the foundation model, and generates grounded responses.  
C) Include all product data in the prompt (context window) for every request.  
D) Deploy a separate OpenSearch cluster and build a custom RAG pipeline.

**Correct Answer: B**
**Explanation:** Bedrock Knowledge Bases provides a fully managed RAG solution — automatic document chunking, embedding generation, vector storage, retrieval, and context augmentation. Daily sync updates the knowledge base without retraining. This is the most operationally efficient approach. Option A — daily fine-tuning is expensive and slow. Option C — product data will exceed the context window and is expensive per request. Option D works but requires managing the vector store and RAG pipeline manually.

---

### Question 25
A retail company wants to analyze customer reviews to understand product quality issues. They need to identify specific aspects of the product being discussed (battery life, screen quality, build quality) and the sentiment toward each aspect. Simple overall sentiment (positive/negative) is insufficient. What should the architect use?

A) Use Amazon Comprehend sentiment analysis for overall review sentiment.  
B) Use Amazon Comprehend custom entity recognition to identify product aspects (train with labeled examples of aspect mentions). Combine with Amazon Comprehend targeted sentiment analysis, which provides entity-level sentiment (sentiment for each detected entity/aspect within the text). Alternatively, use Amazon Bedrock with a foundation model prompted for aspect-based sentiment analysis, providing structured output (aspect: sentiment pairs).  
C) Use Amazon Personalize to analyze reviews.  
D) Use Amazon Kendra to search reviews for specific aspects.

**Correct Answer: B**
**Explanation:** Aspect-based sentiment analysis requires identifying both the aspect mentioned and the sentiment toward it within the same text. Comprehend's targeted sentiment provides entity-level sentiment. Custom entity recognition identifies domain-specific aspects. Alternatively, Bedrock with structured prompting can extract aspect-sentiment pairs in JSON format. Option A gives only overall sentiment (the review might be positive overall but negative about battery life). Option C is for recommendations. Option D is for search.

---

### Question 26
A company wants to use Amazon SageMaker for ML model training. Their training data is sensitive (healthcare records) and must remain encrypted at rest and in transit. Training must occur within their VPC without internet access. What security configurations should the architect implement?

A) Use default SageMaker configurations with no additional security.  
B) Configure SageMaker training jobs with: (1) VPC configuration — specify private subnets and security groups. (2) Network isolation flag to prevent any internet access from training containers. (3) KMS encryption key for training volume encryption (encrypts data at rest on training instances). (4) S3 data access via VPC endpoint (Gateway endpoint for S3). (5) Enable inter-container encryption for distributed training. (6) IAM role with least-privilege access to only the required S3 buckets and KMS keys.  
C) Encrypt data in S3 and assume SageMaker handles the rest.  
D) Use SageMaker Studio without any VPC configuration.

**Correct Answer: B**
**Explanation:** Comprehensive security requires multiple layers: VPC confinement keeps training within the private network. Network isolation prevents data exfiltration. KMS encrypts training data at rest. S3 VPC endpoint ensures data never leaves the AWS network. Inter-container encryption protects data between distributed training instances. IAM least-privilege limits access scope. Option A leaves data unprotected. Option C misses in-transit and compute-level encryption. Option D — Studio without VPC config allows public internet access.

---

### Question 27
A company has built an ML pipeline using SageMaker that includes data preparation, training, evaluation, and deployment steps. They want to automate the entire pipeline, trigger it when new training data arrives in S3, and implement a human approval step before deploying models to production. What should the architect design?

A) Use a series of Lambda functions triggered by S3 events with manual deployment.  
B) Create a SageMaker Pipeline that defines each step: Processing step (data preparation), Training step, Evaluation step (model metrics), Condition step (if accuracy > threshold), Register step (add model to Model Registry), and a callback step for human approval. Trigger the pipeline from an EventBridge rule when new data lands in S3 (via S3 event notifications to EventBridge). Use the SageMaker Model Registry for model versioning and approval workflow. The production endpoint updates only after human approval in the registry.  
C) Train models manually in SageMaker notebooks and deploy via CLI.  
D) Use AWS CodePipeline with custom build steps for ML.

**Correct Answer: B**
**Explanation:** SageMaker Pipelines provides ML-specific workflow orchestration with built-in step types for processing, training, evaluation, and deployment. The Model Registry adds versioning and approval workflow. EventBridge integration enables automated triggering. Condition steps implement quality gates. The human approval step prevents untested models from reaching production. Option A is fragile and lacks ML-specific features. Option C is manual. Option D — CodePipeline isn't optimized for ML workflows.

---

### Question 28
A company wants to deploy a foundation model from Amazon Bedrock for a production application. They need guaranteed throughput for their application and want to avoid being affected by shared capacity limitations. What deployment option should the architect choose?

A) Use the standard on-demand Bedrock API and hope for sufficient capacity.  
B) Purchase Provisioned Throughput for the Bedrock model. Provisioned Throughput reserves dedicated model inference capacity, guaranteeing a specific number of model units (MUs) for consistent throughput and latency. This isolates the workload from shared capacity constraints. Choose between 1-month or 6-month commitments for cost savings. For variable workloads, combine provisioned throughput for baseline with on-demand for bursts.  
C) Deploy the model on SageMaker instead of Bedrock for dedicated instances.  
D) Use multiple Bedrock models simultaneously to increase aggregate throughput.

**Correct Answer: B**
**Explanation:** Bedrock Provisioned Throughput provides dedicated inference capacity with guaranteed performance. Model units ensure consistent throughput regardless of other customers' usage. Commitments (1 or 6 months) provide cost savings over on-demand. This is the correct choice for production applications requiring predictable performance. Option A is subject to throttling under high shared demand. Option C works but requires managing inference infrastructure. Option D — multiple models don't guarantee per-model throughput.

---

### Question 29
A company collects customer feedback through multiple channels (email, chat, social media, surveys). They want to build a unified customer sentiment dashboard that processes all channels, identifies trending topics, and alerts when negative sentiment spikes for a product line. What should the architect design?

A) Use a single Comprehend API call per feedback item and store results in a spreadsheet.  
B) Build a real-time analytics pipeline: (1) All feedback channels feed into Amazon Kinesis Data Streams (or Firehose). (2) A Lambda function processes each record through Amazon Comprehend (DetectSentiment, DetectKeyPhrases, DetectEntities). (3) Results stream to Amazon OpenSearch for real-time dashboards and trend analysis. (4) CloudWatch metrics track sentiment scores per product line. (5) EventBridge rules trigger SNS alerts when negative sentiment exceeds thresholds. (6) Amazon QuickSight provides executive dashboards with historical trends.  
C) Use Amazon Personalize to track customer sentiment.  
D) Store all feedback in S3 and run monthly Comprehend batch jobs.

**Correct Answer: B**
**Explanation:** Real-time processing through Kinesis → Lambda → Comprehend enables immediate sentiment analysis across all channels. OpenSearch provides real-time search and visualization. CloudWatch metrics enable threshold-based alerting. QuickSight adds executive-friendly dashboards. The architecture handles multi-channel input and real-time alerting. Option A is manual and unscalable. Option C — Personalize is for recommendations. Option D has unacceptable latency for trending topic detection.

---

### Question 30
A company wants to use Amazon SageMaker for ML model training but has limited labelled training data (only 500 labeled images for a classification task with 50 categories). Training from scratch would likely result in poor accuracy. What technique should the architect recommend?

A) Collect more labeled data before training.  
B) Use transfer learning with SageMaker's built-in image classification algorithm. Start with a pre-trained model (ResNet, VGG trained on ImageNet) and fine-tune it on the 500 labeled images. The pre-trained model has already learned general image features (edges, shapes, textures), so fine-tuning on a small dataset adapts it to the specific classification task. Additionally, use SageMaker Ground Truth to efficiently label more data with a human-in-the-loop workflow that uses active learning to prioritize the most informative images for labeling.  
C) Use Amazon Rekognition Custom Labels, which is designed for small training datasets. Upload the 500 labeled images, and Rekognition Custom Labels automatically applies transfer learning and data augmentation to train a model with minimal data.  
D) Generate synthetic training data using SageMaker.

**Correct Answer: C**
**Explanation:** Rekognition Custom Labels is specifically designed for scenarios with limited training data (as few as 10 images per class). It automatically applies transfer learning, data augmentation, and hyperparameter optimization. With 500 images across 50 categories (10 per category), Custom Labels is the ideal choice. Option B also works but requires more ML expertise. Option A delays the project. Option D — synthetic data generation for images requires sophisticated models.

---

### Question 31
A logistics company wants to forecast demand for warehouse capacity across 200 locations for the next 3 months. They have 5 years of historical demand data including seasonal patterns. The forecast should account for external factors (holidays, promotions, weather). The team has no ML expertise. What should the architect recommend?

A) Build a custom time-series forecasting model using SageMaker DeepAR.  
B) Use Amazon Forecast — import historical demand data as a target time series and external factors (holidays, promotions, weather) as related time series. Forecast automatically selects the best algorithm, trains models, and generates probabilistic forecasts (P10, P50, P90) for each location. Create predictors and generate forecasts via the Forecast API. No ML expertise required.  
C) Use simple statistical methods (moving averages) in a spreadsheet.  
D) Use Amazon QuickSight for demand forecasting.

**Correct Answer: B**
**Explanation:** Amazon Forecast is a managed forecasting service that handles algorithm selection, training, and deployment. It supports related time series (external factors), generates probabilistic forecasts (helpful for capacity planning — P90 for worst-case), and scales to 200 locations. No ML expertise needed — the AutoML mode selects the best algorithm. Option A requires ML expertise. Option C misses complex patterns (seasonality × promotions × weather). Option D — QuickSight provides ML-powered forecasting but not at the sophistication of Forecast.

---

### Question 32
A media streaming company wants to generate thumbnails for their video content that capture the most interesting/representative frames. Currently, thumbnails are selected at fixed intervals (every 30 seconds), which often picks uninteresting frames. What should the architect use?

A) Manually select thumbnails for each video.  
B) Use Amazon Rekognition Video to analyze the video and detect shot boundaries, celebrity appearances, and scene types. Use the GetSegmentDetection API for shot detection and GetCelebrityRecognition for celebrity detection. Select frames with the highest visual interest (celebrities, action, key scenes). Alternatively, use Rekognition's DetectLabels on sampled frames to find frames with the most relevant labels for the content category.  
C) Use Amazon Textract to extract text from video frames as thumbnails.  
D) Generate thumbnails using Amazon Bedrock's image generation.

**Correct Answer: B**
**Explanation:** Rekognition Video provides shot detection (identifying distinct scenes), celebrity recognition, and label detection — enabling intelligent frame selection based on content relevance. Shot boundaries mark natural scene transitions. Celebrity frames are inherently interesting. Label detection identifies frames matching the content category (sports: action shots, cooking: plated dishes). Option A doesn't scale. Option C — Textract is for documents, not video. Option D generates synthetic images, not captures from the actual video.

---

### Question 33
A financial company has a SageMaker ML model in production. A new regulation requires them to explain every model prediction to regulators — why did the model approve/deny a loan application? The model is a gradient-boosted tree. What should the architect implement?

A) Retrain the model as a simple decision tree for easier interpretation.  
B) Use SageMaker Clarify for model explainability. Clarify provides SHAP (SHapley Additive exPlanations) values for each prediction, showing the contribution of each input feature to the output. Enable online explainability in the SageMaker endpoint to generate feature attributions with every prediction. Store explanations alongside predictions in S3 for regulatory audit. Use Clarify bias detection to ensure the model doesn't discriminate against protected classes.  
C) Log all input features and the model prediction, and let regulators infer the reasoning.  
D) Provide the model's source code to regulators as the explanation.

**Correct Answer: B**
**Explanation:** SageMaker Clarify provides SHAP-based feature attributions — for each prediction, it shows which features pushed the decision positive or negative and by how much. This enables per-decision explanations for regulators (e.g., "Income contributed +0.3, debt-to-income ratio contributed -0.5"). Bias detection ensures fairness across protected groups. Online explainability integrates with the inference endpoint. Option A sacrifices accuracy. Option C provides raw data without interpretation. Option D — model code doesn't explain individual predictions.

---

### Question 34
A company is building a document processing pipeline that handles multiple document types: invoices, receipts, W-2 forms, bank statements, and ID documents. Each document type requires different extraction logic. What is the most efficient approach?

A) Build a custom model for each document type using SageMaker.  
B) Use Amazon Textract's specialized APIs for different document types: AnalyzeExpense for invoices and receipts (extracts vendor, line items, totals, tax automatically), AnalyzeID for identity documents (extracts name, DOB, document number), and AnalyzeDocument with Queries for custom questions on any document type. Add Amazon Textract Lending for W-2 and bank statement processing. Use a Lambda function to classify the document type first (using Rekognition or Comprehend), then route to the appropriate Textract API.  
C) Use a single AnalyzeDocument call for all document types.  
D) Use Amazon Comprehend for all document extraction.

**Correct Answer: B**
**Explanation:** Textract provides specialized APIs optimized for different document types. AnalyzeExpense understands invoice/receipt layouts and semantics. AnalyzeID extracts standard identity fields. AnalyzeDocument with Queries enables natural language questions ("What is the total amount due?"). Textract Lending processes financial documents. Routing to the correct API ensures optimal extraction. Option A requires building and maintaining multiple custom models. Option C misses specialized extraction features. Option D — Comprehend is for text analysis, not document structure extraction.

---

### Question 35
A company using Amazon Personalize for recommendations notices that new users (with no interaction history) receive poor recommendations. How should the architect address the cold start problem for new users?

A) Wait until new users accumulate enough interactions before showing recommendations.  
B) Configure Amazon Personalize with a USER_PERSONALIZATION recipe that supports cold start. Provide user metadata (demographics, preferences from sign-up) in the Users dataset. Personalize uses metadata for cold-start users to find similar users with interaction history and bootstrap recommendations. Additionally, implement an exploration strategy (Personalize's exploration weight parameter) that balances between recommending popular items (safe for new users) and personalized items as interaction data grows.  
C) Show the same popular items to all new users without any personalization.  
D) Use Amazon Bedrock to generate recommendations for new users.

**Correct Answer: B**
**Explanation:** Personalize handles cold start through user metadata similarity and exploration. User metadata (age, location, signup preferences) helps Personalize find similar users with interaction history. The exploration weight balances between popular items (high confidence) and potentially personalized items (exploration). As the new user interacts, recommendations become increasingly personalized. Option A provides a poor first experience. Option C ignores available metadata. Option D isn't designed for recommendation systems.

---

### Question 36
A company deployed an Amazon SageMaker model endpoint that uses a custom inference container. They notice that the endpoint's model latency increases over time and eventually the endpoint starts returning errors. Restarting the endpoint fixes the issue temporarily. What is the most likely cause and how should the architect investigate?

A) The model is too large for the instance — use a larger instance type.  
B) The custom inference container likely has a memory leak. Investigate by: (1) Enable CloudWatch custom metrics from the container to track memory usage over time. (2) Use SageMaker's built-in metrics (MemoryUtilization) to confirm increasing memory consumption. (3) Enable logging in the container to CloudWatch Logs and look for out-of-memory errors. (4) Use Amazon SageMaker Debugger or container profiling to identify the leak source. Fix: optimize the container code, implement periodic garbage collection, or configure the endpoint's auto-scaling to rotate instances.  
C) The model weights are degrading over time and need retraining.  
D) SageMaker is throttling the endpoint.

**Correct Answer: B**
**Explanation:** Progressive latency increase followed by errors, resolved by restart, is the classic symptom of a memory leak in the inference container. Over time, the container consumes more memory, causing garbage collection pauses (increased latency), then out-of-memory errors. CloudWatch metrics (MemoryUtilization trending upward) confirm the diagnosis. The fix is in the container code. Option A — if the instance were too small, issues would appear immediately. Option C — model weights don't degrade without data drift. Option D — throttling is based on request rate, not uptime.

---

### Question 37
A company wants to create a virtual customer service agent that can handle complex multi-turn conversations, access real-time order status, process returns, and escalate to human agents when needed. The agent should understand context across multiple exchanges. What architecture should the architect design?

A) Use Amazon Lex with a single intent and hardcoded responses.  
B) Use Amazon Bedrock Agents. Define the agent with instructions describing its role and capabilities. Create action groups for: OrderStatus (calls Order API), ProcessReturn (calls Returns API), EscalateToHuman (routes to Amazon Connect). The Bedrock agent uses a foundation model for natural language understanding and multi-turn conversation context. Knowledge bases provide product information. The agent autonomously decides which action to invoke based on the conversation.  
C) Build a custom chatbot on EC2 using open-source NLP libraries.  
D) Use Amazon Lex for intent detection and Lambda for fulfillment with static conversation flows.

**Correct Answer: B**
**Explanation:** Bedrock Agents provide autonomous, multi-turn conversation handling powered by foundation models. Action groups define the APIs the agent can call. The agent reasons about which action to take based on the conversation, maintaining context across turns. Knowledge bases ground responses in product data. This handles complex, dynamic conversations unlike rigid intent-based bots. Option A can't handle complex conversations. Option C requires significant NLP engineering. Option D — Lex handles multi-turn but with predefined, rigid flows.

---

### Question 38
A real estate company has millions of property listing photos. They want to automatically tag photos with attributes (kitchen, bathroom, pool, garden, hardwood floors, granite countertops) to improve search functionality. Off-the-shelf models don't recognize real-estate-specific features. What should the architect recommend?

A) Use Amazon Rekognition's DetectLabels API for generic object detection.  
B) Use Amazon Rekognition Custom Labels. Create a training dataset with real-estate-specific labels (labeled by a human labeling team using SageMaker Ground Truth). Train a Custom Labels model that recognizes domain-specific features. Deploy the model and run inference on listing photos. For ongoing labeling, use SageMaker Ground Truth with active learning to reduce labeling effort over time.  
C) Use Amazon Bedrock with a multi-modal model to describe each photo.  
D) Hire a team to manually tag all photos.

**Correct Answer: B**
**Explanation:** Rekognition Custom Labels trains custom image classification/detection models with your specific labels. Real estate features (granite countertops, hardwood floors) aren't in generic models. Ground Truth streamlines the labeling process with human-in-the-loop workflows. Active learning prioritizes the most informative images for labeling, reducing total labeling effort. Option A — generic labels won't identify "hardwood floors" or "granite countertops." Option C can describe photos but isn't optimized for structured tagging at scale. Option D doesn't scale.

---

### Question 39
A company needs to implement real-time toxicity detection for their online gaming platform's chat system. Messages flow at 50,000 per second during peak hours. Toxic messages should be blocked before other users see them. The system must handle gaming slang and creative spelling used to evade filters. What should the architect design?

A) Use a word blocklist to filter toxic messages.  
B) Deploy a multi-layer content moderation pipeline: (1) First layer: Amazon Comprehend for real-time toxicity detection (DetectToxicContent API) categorizing messages as toxic/non-toxic with confidence scores. (2) Second layer: For messages near the confidence threshold, use Amazon Bedrock with a foundation model fine-tuned on gaming chat for nuanced toxicity detection (understands slang and evasion). (3) Queue borderline cases for Amazon A2I human review. Process through Kinesis Data Streams → Lambda → Comprehend → Bedrock (if needed) → allow/block decision. Cache known-toxic patterns in ElastiCache for instant blocking.  
C) Use Amazon Rekognition to moderate text content.  
D) Let users report toxic messages after the fact.

**Correct Answer: B**
**Explanation:** Multi-layer moderation handles both obvious toxicity (Comprehend, fast) and nuanced toxicity (Bedrock, more thorough). Comprehend's toxicity detection catches clear cases quickly. Bedrock with gaming-specific fine-tuning handles slang and creative evasion that rule-based systems miss. ElastiCache caching provides instant blocking of known patterns. A2I handles edge cases with human judgment. Option A is easily evaded. Option C — Rekognition is for images. Option D allows harm to occur before action.

---

### Question 40
A company has 10 million product images stored in S3. They want to build a visual search feature where users can upload a photo and find similar products. The system needs to return results in under 200ms. What architecture should the architect design?

A) Compare the uploaded image against all 10 million images using Rekognition CompareFaces.  
B) Build a visual search pipeline: (1) Offline: Use Amazon Bedrock Titan Multimodal Embeddings (or a SageMaker model) to generate vector embeddings for all 10 million product images. Store embeddings in Amazon OpenSearch Serverless with vector search enabled (k-NN index). (2) Online: When a user uploads an image, generate its embedding using the same model, then perform a k-nearest-neighbors search in OpenSearch to find the most similar product embeddings. Return the top results. The kNN search completes in milliseconds.  
C) Use Amazon Rekognition to label the uploaded image, then text-search for matching labels.  
D) Store all images in DynamoDB with metadata and use scan queries.

**Correct Answer: B**
**Explanation:** Vector similarity search is the standard approach for visual search. Embeddings encode visual features into numeric vectors. Similar images have nearby vectors. Pre-computing embeddings offline enables fast online search (kNN on vectors is extremely fast). OpenSearch Serverless with vector search handles 10M vectors efficiently. The 200ms latency requirement is easily met. Option A — comparing against 10M images one-by-one is impossibly slow. Option C — label matching loses visual nuance. Option D — DynamoDB scan doesn't support visual similarity.

---

### Question 41
A company wants to automatically generate alt-text descriptions for images on their website for accessibility compliance. The descriptions should be detailed and natural-sounding. They have 2 million existing images. What should the architect recommend?

A) Hire writers to create alt-text for all 2 million images.  
B) Use Amazon Bedrock with a multi-modal foundation model (Claude with vision capability). Send each image to the model with a prompt requesting a detailed, accessible description. Process the 2 million existing images in batch using a Step Functions workflow with Lambda → Bedrock. For new images, trigger automatically on S3 upload. Store alt-text in the content management system's database.  
C) Use Amazon Rekognition DetectLabels and concatenate the labels as alt-text.  
D) Use Amazon Textract to extract text from images as alt-text.

**Correct Answer: B**
**Explanation:** Multi-modal foundation models generate natural, detailed image descriptions that serve as high-quality alt-text. Unlike concatenated labels ("dog, park, ball"), the model produces "A golden retriever playing with a red ball in a sunny park." Batch processing handles the 2M backlog, and event-driven processing handles new uploads. Option A doesn't scale. Option C produces lists of labels, not natural descriptions. Option D extracts text within images, not descriptions of the image content.

---

### Question 42
A bank wants to implement document comparison for loan processing. Loan officers need to compare application documents against standard templates and identify discrepancies (missing fields, incorrect formatting, value mismatches). What should the architect use?

A) Use Amazon Textract to extract data from both the application and the template, then build a Lambda function that compares the extracted key-value pairs programmatically. Flag missing keys (required fields not present in the application), value format mismatches (date format, currency format), and anomalous values (income significantly different from credit report). Store comparison results in DynamoDB and notify loan officers via SNS.  
B) Use Amazon Rekognition to visually compare the documents.  
C) Have loan officers manually compare every document.  
D) Use Amazon Comprehend to summarize both documents and compare summaries.

**Correct Answer: A**
**Explanation:** Textract extracts structured data (key-value pairs, tables) from both documents, enabling programmatic comparison. Lambda applies business rules (required fields, format validation, anomaly detection). This automates what would otherwise be a manual, error-prone comparison. Option B — Rekognition does image analysis, not document data extraction and comparison. Option C doesn't scale. Option D — Comprehend summarizes text but doesn't extract and compare structured data.

---

### Question 43
A company is using Amazon SageMaker for model training. They want to optimize training costs for a deep learning model that takes 12 hours to train on a single ml.p3.16xlarge instance. The model supports checkpointing. What cost optimization strategies should the architect recommend? (Select TWO.)

A) Use SageMaker Managed Spot Training, which uses EC2 Spot Instances at up to 90% discount. Configure checkpointing to S3 so training can resume from the last checkpoint if a spot interruption occurs.  
B) Use SageMaker Savings Plans for consistent training workloads, committing to a specific compute usage ($/hour) for 1 or 3 years in exchange for up to 64% discount on SageMaker training instance usage.  
C) Use the smallest possible instance to minimize hourly cost.  
D) Run training in the most expensive Region for fastest completion.  
E) Disable checkpointing to reduce S3 costs.

**Correct Answer: A, B**
**Explanation:** (A) Managed Spot Training leverages unused EC2 capacity at massive discounts. Checkpointing ensures no work is lost during spot interruptions — training resumes from the last checkpoint. (B) Savings Plans provide committed-use discounts for predictable training workloads. These two strategies can be combined — use Spot for non-urgent training and Savings Plans for regular training schedules. Option C — smaller instances train slower, potentially costing more total. Option D — Region doesn't affect speed. Option E — losing training progress on interruption wastes money.

---

### Question 44
A company wants to use Amazon Comprehend to analyze customer feedback but needs to identify industry-specific entities (product model numbers, warranty types, service plan names) that Comprehend's pre-trained models don't recognize. What should the architect do?

A) Manually post-process Comprehend output to identify custom entities using regex.  
B) Train an Amazon Comprehend Custom Entity Recognition model. Prepare training data with annotated examples of the custom entities (product model numbers tagged as PRODUCT_MODEL, warranty types tagged as WARRANTY_TYPE). Upload the training data and create a custom entity recognizer. Use the custom recognizer in conjunction with the pre-built entity detection for comprehensive entity extraction.  
C) Use a different NLP service that recognizes these entities.  
D) Add the custom entity types to Comprehend's pre-trained model via the API.

**Correct Answer: B**
**Explanation:** Comprehend Custom Entity Recognition allows training on domain-specific entities without ML expertise. You provide annotated training data (examples of your custom entities in context), and Comprehend trains a custom recognizer. The custom model runs alongside the pre-built models, providing both standard entities (dates, people, organizations) and custom entities in a single analysis. Option A is fragile and misses complex patterns. Option C — Comprehend's custom training is designed for this. Option D — you can't modify pre-trained models.

---

### Question 45
A marketing company creates videos for social media. They want to automatically generate video highlights (short clips of the most engaging moments) from hour-long raw footage. The highlights should include moments with high action, emotional reactions, and key dialogue. What pipeline should the architect design?

A) Manually review and clip the footage.  
B) Build a multi-modal analysis pipeline: (1) Amazon Rekognition Video for shot detection, face emotion analysis (detecting excitement, surprise), and activity recognition. (2) Amazon Transcribe for audio transcription with word-level timestamps. (3) Amazon Comprehend for sentiment analysis on transcribed dialogue to identify emotionally charged segments. (4) A scoring Lambda function that combines visual interest (Rekognition), emotional reactions (face emotions), and dialogue sentiment (Comprehend) to rank each segment. (5) AWS Elemental MediaConvert to extract and concatenate the top-scored segments into a highlight reel.  
C) Use Amazon Bedrock to generate video highlights from text descriptions.  
D) Select video segments at fixed intervals (every 5 minutes) as highlights.

**Correct Answer: B**
**Explanation:** This pipeline combines visual analysis (Rekognition for action, emotions), audio analysis (Transcribe for dialogue), and NLP (Comprehend for sentiment) to holistically score each video segment. The scoring function weights contributions from each modality to rank segments by engagement potential. MediaConvert produces the final highlight reel. Option A doesn't scale. Option C — Bedrock processes text, not video editing. Option D ignores content quality.

---

### Question 46
A company has deployed an Amazon Bedrock-based application. Users report that the AI sometimes generates confidently stated but factually incorrect information about their products (hallucination). How should the architect reduce hallucination?

A) Use a different foundation model that doesn't hallucinate.  
B) Implement multiple guardrails against hallucination: (1) Use Bedrock Knowledge Bases (RAG) to ground responses in actual product documentation. (2) Add a system prompt that instructs the model to only answer from the provided context and say "I don't know" when information isn't in the knowledge base. (3) Configure Bedrock Guardrails with grounding checks that verify the response is supported by the retrieved context. (4) Implement citation extraction — require the model to cite specific source documents. (5) Add a verification step that checks key claims against a product database.  
C) Increase the model temperature for more creative responses.  
D) Fine-tune the model on the product catalog.

**Correct Answer: B**
**Explanation:** Hallucination reduction requires multiple layers: RAG grounds responses in source documents. System prompts constrain the model to provided context. Guardrails grounding checks verify responses against retrieved context. Citations enable verification. A database cross-check catches remaining errors. No single technique eliminates hallucination — the layered approach is essential. Option A — all LLMs can hallucinate. Option C — higher temperature increases hallucination risk. Option D — fine-tuning helps with style but doesn't prevent hallucination about specific facts.

---

### Question 47
A company is building a multilingual voice assistant for their global customer service. The assistant needs to detect the caller's language, converse in that language, access customer records, and perform actions (reschedule appointments, cancel orders). What architecture should the architect design?

A) Build separate voice assistants for each language.  
B) Build a unified pipeline: (1) Amazon Transcribe detects the caller's language and transcribes speech to text. (2) Amazon Lex (configured with multiple language models) processes the transcript for intent detection and slot filling. (3) Lambda fulfillment functions access customer records (DynamoDB) and perform actions via backend APIs. (4) Amazon Translate converts the response to the caller's language if the Lex model isn't available in that language. (5) Amazon Polly generates speech responses in the caller's language with neural voices. (6) Amazon Connect handles the telephony layer.  
C) Use a single English Lex bot and require all callers to speak English.  
D) Use Amazon Bedrock as the sole conversational engine without Lex.

**Correct Answer: B**
**Explanation:** This architecture handles the full voice assistant lifecycle: language detection (Transcribe), intent understanding (Lex), action execution (Lambda), response translation (Translate), speech generation (Polly), and telephony (Connect). Each service is optimized for its role. Lex supports multiple languages natively; Translate handles unsupported languages. Option A requires building and maintaining N separate systems. Option C excludes non-English speakers. Option D — Bedrock excels at conversation but Lex provides more structured intent/slot handling for transactional operations.

---

### Question 48
A company wants to implement an ML-powered search for their e-commerce site that understands natural language queries like "warm waterproof jacket under $200 for hiking." Traditional keyword search returns irrelevant results because it doesn't understand the semantic meaning. What should the architect design?

A) Use Amazon OpenSearch with keyword search and filters.  
B) Implement semantic search using Amazon Bedrock Titan Embeddings and Amazon OpenSearch Serverless. Generate text embeddings for all product descriptions and store them in OpenSearch's vector store. At query time, generate an embedding for the user's natural language query and perform kNN vector search to find semantically similar products. Combine with traditional keyword/filter search (hybrid search) for attributes like price (< $200). Use OpenSearch's hybrid scoring to rank results.  
C) Use Amazon Kendra for e-commerce product search.  
D) Use Amazon Personalize to return products matching the query.

**Correct Answer: B**
**Explanation:** Semantic search using embeddings understands that "warm waterproof jacket for hiking" relates to "insulated rain-resistant outdoor coat" even though the words are different. Vector search finds semantically similar products. Hybrid search combines semantic similarity (vector kNN) with attribute filtering (price < $200). This provides far better results than keyword matching alone. Option A misses semantic understanding. Option C is for enterprise document search, not product catalog search. Option D provides recommendations, not query-based search.

---

### Question 49
A healthcare company needs to de-identify patient records before using them for ML model training. The records contain names, dates, medical record numbers, phone numbers, and email addresses. The de-identification must comply with HIPAA Safe Harbor rules. What should the architect use?

A) Write regex patterns to find and replace PHI.  
B) Use Amazon Comprehend Medical's DetectPHI API to identify Protected Health Information (names, dates, addresses, phone numbers, email addresses, SSNs, medical record numbers) in the text. Create a Lambda function that receives Comprehend Medical's entity output and redacts/replaces each detected PHI entity with a placeholder (e.g., [NAME], [DATE]). For dates, implement HIPAA Safe Harbor date shifting (shift all dates by a consistent random offset per patient). Process records in batch from S3 through Step Functions.  
C) Manually review each record and remove PHI.  
D) Use Amazon Macie to detect PHI in the records.

**Correct Answer: B**
**Explanation:** Comprehend Medical DetectPHI is specifically designed to identify all categories of PHI defined by HIPAA. Automated redaction through Lambda replaces PHI entities with placeholders. Date shifting (consistent offset per patient) preserves relative date relationships (important for temporal ML features) while de-identifying absolute dates. Step Functions handles batch processing. Option A — regex misses complex patterns and variations. Option C doesn't scale. Option D — Macie detects PII in S3 objects but doesn't extract entity-level PHI for targeted redaction.

---

### Question 50
A company is using Amazon SageMaker to train a model and wants to ensure reproducibility — the ability to exactly reproduce any training run with the same results. What should the architect configure?

A) Just save the final model artifacts to S3.  
B) Implement comprehensive ML lineage tracking: (1) SageMaker Experiments to track all training runs with parameters, metrics, and artifacts. (2) Pin the SageMaker training container version and algorithm version. (3) Store training data in S3 with versioning enabled. (4) Use SageMaker Pipelines with fixed seed values for randomness. (5) Record the complete training configuration (hyperparameters, instance type, code version) in SageMaker Model Registry. (6) Use git integration to link training code to specific commits. (7) Record the SageMaker SDK and framework versions used.  
C) Take screenshots of the training configuration.  
D) Save the training notebook as documentation.

**Correct Answer: B**
**Explanation:** ML reproducibility requires tracking all variables: data version (S3 versioning), code version (git), container version (pinned), hyperparameters (Experiments), framework versions, and random seeds. SageMaker Experiments provides a structured way to track all these. Model Registry stores the complete model lineage. Pipelines ensure consistent execution. Without all components tracked, reproducing exact results is impossible. Option A loses everything except the final model. Option C/D are informal and incomplete.

---

### Question 51
A company is building a content recommendation system for their streaming platform. They have three types of recommendations needed: (1) "What to watch next" for a logged-in user, (2) "Popular in your area" for anonymous users, and (3) "Because you watched X" for specific item relationships. What Amazon Personalize configuration handles all three?

A) Create a single recipe for all recommendation types.  
B) Create three separate Amazon Personalize solutions, each with the appropriate recipe: (1) User-Personalization recipe for "what to watch next" — generates personalized recommendations based on user interaction history. (2) Popularity-Count recipe for "popular in your area" — combined with metadata filtering by location for anonymous users. (3) Similar-Items (SIMS) recipe for "because you watched X" — finds items frequently consumed together. Deploy a Personalize campaign for each solution. The application calls the appropriate campaign endpoint based on the recommendation context.  
C) Use Amazon Kendra for content recommendations.  
D) Build a simple "most popular" list for all recommendation types.

**Correct Answer: B**
**Explanation:** Amazon Personalize provides different recipes optimized for different recommendation patterns. User-Personalization handles the core personalized recommendation. Popularity-Count serves anonymous users (cold start). SIMS provides item-to-item similarities. Each recipe produces a different type of recommendation, and the application selects the appropriate campaign. Option A — no single recipe handles all patterns. Option C — Kendra is for search. Option D provides poor user experience for logged-in users.

---

### Question 52
A company has a SageMaker model that performs well on historical test data but poorly in production. Investigation reveals that production input data has different statistical properties than the training data. What is this problem and how should the architect address it?

A) The model needs more training data.  
B) This is data drift (also called dataset shift). Address it with: (1) SageMaker Model Monitor configured with data quality baselines from the training data — it continuously compares production input distributions to training distributions and alerts on drift. (2) Implement a SageMaker Pipeline that automatically retrains the model with recent production data when drift exceeds thresholds. (3) Use a sliding window training strategy — include the most recent N months of data in each retraining cycle. (4) Deploy a champion/challenger model pattern — new retrained models are validated against the current production model before promotion.  
C) Deploy the model on larger instances for better performance.  
D) Increase the model's complexity (more layers/parameters).

**Correct Answer: B**
**Explanation:** Data drift occurs when the production data distribution differs from training data (e.g., seasonal changes, user behavior shifts, market conditions). Model Monitor detects drift by comparing statistical properties. Automated retraining with recent data adapts the model. Sliding window ensures the model reflects current patterns. Champion/challenger prevents deploying inferior retrained models. Option A — more historical data doesn't address current distribution changes. Option C/D — the issue is data, not model capacity.

---

### Question 53
A company wants to add AI-powered image editing capabilities to their mobile app. Users should be able to remove backgrounds, change styles, and generate variations of uploaded images. What should the architect design?

A) Build custom image processing models on SageMaker.  
B) Use Amazon Bedrock with image generation models (Stable Diffusion/Titan Image Generator). For background removal, use Bedrock's inpainting capability — mask the background and generate a new one. For style changes, use the image-to-image generation with style prompts. For variations, use image variation generation. Expose these capabilities through an API Gateway → Lambda → Bedrock pipeline. Optimize mobile experience with presigned S3 URLs for image upload/download and API Gateway caching for common operations.  
C) Use Amazon Rekognition for all image editing tasks.  
D) Implement image editing using ImageMagick on Lambda.

**Correct Answer: B**
**Explanation:** Bedrock's image generation models support inpainting (background removal/replacement), style transfer (image-to-image), and variation generation — all through API calls. The serverless pipeline (API Gateway → Lambda → Bedrock) scales automatically. Presigned URLs optimize mobile bandwidth. Option A requires building custom models for each editing capability. Option C — Rekognition analyzes images but doesn't edit/generate them. Option D handles basic operations but not AI-powered editing (style transfer, intelligent background removal).

---

### Question 54
A company operates an ML platform with 50 data scientists. They need to provide each data scientist with a managed Jupyter notebook environment, share datasets securely, collaborate on notebooks, and control costs. What should the architect deploy?

A) Deploy individual EC2 instances with Jupyter for each data scientist.  
B) Deploy Amazon SageMaker Studio as the centralized ML IDE. Configure Studio domains with user profiles per data scientist. Use SageMaker Studio's built-in sharing for notebook collaboration. Configure lifecycle configurations to auto-stop idle notebook instances (reducing costs). Use S3 as the shared data lake with IAM policies for data access control. Set up SageMaker Studio kernel gateway instance types per user profile to right-size compute allocation.  
C) Use a single large EC2 instance running JupyterHub for all users.  
D) Use AWS Cloud9 for ML development.

**Correct Answer: B**
**Explanation:** SageMaker Studio provides managed Jupyter environments with user isolation, collaboration features, and cost controls. Per-user profiles enable access management. Lifecycle configurations auto-stop idle instances (critical cost control for 50 users). Shared S3 data lake with IAM provides secure data access. Kernel gateway configurations allow different compute sizes per user/task. Option A requires managing 50 instances. Option C has no isolation and resource contention. Option D isn't designed for ML development.

---

### Question 55
A company wants to automate the extraction of key terms and conditions from legal contracts using AI. The contracts are complex, multi-page documents with industry-specific legal language. Standard NER (named entity recognition) doesn't capture legal concepts. What approach should the architect take?

A) Use Amazon Comprehend's pre-trained NER for contract analysis.  
B) Combine multiple services: (1) Amazon Textract to extract text from contract PDFs with structure preservation (sections, paragraphs, tables). (2) Amazon Bedrock with a foundation model for contract analysis — prompt the model with the extracted text and specific questions ("What are the termination clauses?", "What are the payment terms?", "What are the liability limitations?"). The foundation model understands legal language and can extract complex clauses that NER can't capture. (3) Store extracted terms in a structured format (DynamoDB) for comparison and tracking.  
C) Use Amazon Kendra to search contracts for key terms.  
D) Train a custom SageMaker model for legal NER.

**Correct Answer: B**
**Explanation:** Legal clause extraction requires understanding context and language beyond what NER provides. Foundation models understand legal terminology and can extract complex, multi-sentence clauses in response to specific questions. Textract preserves document structure (sections, tables). The combination handles the complexity of legal documents. Option A — pre-trained NER doesn't understand legal concepts. Option C searches but doesn't extract and structure. Option D requires extensive labeled legal data.

---

### Question 56
A company has trained a custom ML model using SageMaker for customer churn prediction. They want to deploy it as an API that integrates with their existing application. The model receives batch prediction requests (100 customers at a time) during nightly processing. The inference workload is predictable and runs for 2 hours each night. What is the most cost-effective deployment option?

A) Deploy a real-time SageMaker endpoint running 24/7.  
B) Use SageMaker Batch Transform for the nightly batch prediction job. Batch Transform spins up inference instances, processes all records from S3 input, writes predictions to S3 output, and shuts down instances automatically. You pay only for the 2 hours of compute used. Schedule the job using EventBridge → Lambda → SageMaker API. For any real-time prediction needs, use SageMaker Serverless Inference which scales to zero when not in use.  
C) Deploy the model on a dedicated EC2 instance.  
D) Use Lambda with the model embedded in the function code.

**Correct Answer: B**
**Explanation:** Batch Transform is the most cost-effective option for scheduled batch workloads. Instances are created on-demand, process the batch, and are terminated automatically — you pay only for 2 hours. For a 2-hour nightly job, this costs ~90% less than a 24/7 real-time endpoint. EventBridge scheduling automates the workflow. Option A wastes 22 hours of compute daily. Option C requires managing infrastructure. Option D — ML models often exceed Lambda's size limits.

---

### Question 57
A company is building an AI-powered code review assistant that can analyze pull requests, identify potential bugs, suggest improvements, and explain code changes. The assistant should understand the project's codebase context. What architecture should the architect design?

A) Use a generic code generation model without project context.  
B) Use Amazon Bedrock with a code-specialized foundation model (Claude/CodeLlama). Implement a RAG architecture: index the project's codebase in a Bedrock Knowledge Base (using S3 as the data source for code files). When a PR is submitted, retrieve relevant code context from the knowledge base (related files, coding standards, past similar changes). Prompt the model with the PR diff and retrieved context for analysis. Integrate via GitHub/GitLab webhooks → API Gateway → Lambda → Bedrock.  
C) Use Amazon CodeGuru Reviewer for all code analysis needs.  
D) Use Amazon Comprehend to analyze code changes.

**Correct Answer: B**
**Explanation:** RAG with codebase context enables the model to understand project-specific patterns, conventions, and dependencies. The knowledge base contains the project's code, documentation, and coding standards. When reviewing a PR, relevant context is retrieved (related modules, similar past changes) and provided to the model alongside the diff. Option A lacks project context. Option C provides automated reviews but with fixed capabilities. Option D — Comprehend is for natural language text, not code analysis.

---

### Question 58
A retail company wants to implement "try before you buy" virtual fitting room technology. Customers upload a photo, and the system shows how clothing items would look on them. What AI services should the architect use?

A) Use Amazon Rekognition to detect body pose and overlay clothing images statically.  
B) Use Amazon Bedrock with image generation models that support image editing. Use Rekognition for body segmentation (detecting the person's body region in the uploaded photo). Use Bedrock's inpainting capability — mask the clothing area on the person and generate the new clothing item on the person's body using the product image as reference. Additionally, use SageMaker to train or deploy a specialized virtual try-on model (VITON-style architecture) for more accurate results. Serve through API Gateway → Lambda → processing pipeline.  
C) Use Amazon Polly to describe how the clothing would look.  
D) Use Photoshop on EC2 instances for each request.

**Correct Answer: B**
**Explanation:** Virtual try-on requires body segmentation (Rekognition), image generation with conditioning (Bedrock/SageMaker), and real-time serving. Bedrock's inpainting can place clothing items on body regions. For production quality, a specialized virtual try-on model on SageMaker provides more accurate fitting and draping. The API pipeline enables real-time processing from the mobile app. Option A — static overlay doesn't account for body shape and pose. Option C doesn't produce visual output. Option D doesn't scale and is too slow.

---

### Question 59
A media company wants to implement AI-powered content summarization at different levels: executive summary (2-3 sentences), detailed summary (1 page), and key takeaways (bullet points). The source documents are research reports averaging 50 pages. What is the most efficient architecture?

A) Use Amazon Comprehend for text summarization.  
B) Use Amazon Bedrock with a foundation model (Claude). For each document, make three API calls with different prompts specifying the desired summary format and length. For 50-page documents, use the model's large context window or implement a chunked summarization approach: split the document into chunks, summarize each chunk, then summarize the summaries (hierarchical summarization). Configure Bedrock Knowledge Bases with the documents for persistent access.  
C) Use Amazon Kendra to extract key passages as summaries.  
D) Train a custom summarization model using SageMaker.

**Correct Answer: B**
**Explanation:** Foundation models excel at flexible summarization — different prompts produce different summary formats from the same source. Large context models handle 50-page documents directly. Hierarchical summarization handles documents exceeding the context window. Three API calls with different format instructions (executive, detailed, bullet points) generate all three summary types efficiently. Option A — Comprehend doesn't provide summarization. Option C returns relevant passages, not coherent summaries. Option D requires extensive training data and effort.

---

### Question 60
A company needs to monitor their SageMaker model endpoints for bias. The model scores loan applications, and regulators require proof that the model doesn't discriminate based on race, gender, or age. What should the architect implement?

A) Manually review a sample of model predictions monthly.  
B) Configure Amazon SageMaker Clarify for continuous bias monitoring on the production endpoint. Define bias metrics (Demographic Parity Difference, Disparate Impact) for protected attributes (race, gender, age). Create a Model Monitor schedule that runs Clarify bias analysis on production inference data at regular intervals. Set CloudWatch alarms on bias metrics that alert when values exceed regulatory thresholds. Store all bias reports in S3 with versioning for regulatory compliance. Include pre-training data bias analysis using Clarify's data quality checks.  
C) Ensure the training data has equal representation and assume the model is fair.  
D) Remove protected attributes from the model input features.

**Correct Answer: B**
**Explanation:** SageMaker Clarify provides comprehensive bias detection — both pre-training (data imbalances) and post-training (model output bias). Continuous monitoring catches bias that emerges over time as production data shifts. Standard bias metrics (DPD, DI) are accepted by regulators. S3 storage of reports provides audit trails. CloudWatch alarms enable proactive response. Option A is infrequent and subjective. Option C — equal representation doesn't guarantee unbiased predictions (proxy variables). Option D — models can infer protected attributes from correlated features.

---

### Question 61
A manufacturing company wants to predict equipment failures before they occur using sensor data (temperature, vibration, pressure) from IoT devices. They have historical data with known failure events. What should the architect recommend?

A) Set static threshold alerts on sensor values.  
B) Use Amazon Lookout for Equipment for predictive maintenance. Upload historical sensor data with labeled failure events. Lookout for Equipment automatically trains an anomaly detection model tailored to the equipment's normal operating patterns. Deploy the model for real-time anomaly detection — it identifies subtle patterns preceding failures that static thresholds miss. Integrate IoT sensor data via AWS IoT Core → Kinesis → Lookout for Equipment inference endpoint. Alert maintenance teams via SNS when anomalies are detected.  
C) Use Amazon SageMaker to build a custom predictive maintenance model from scratch.  
D) Use Amazon Forecast to predict future sensor values.

**Correct Answer: B**
**Explanation:** Lookout for Equipment is purpose-built for industrial predictive maintenance. It understands multi-variate sensor data patterns and detects anomalies preceding equipment failure. It requires labeled historical data (normal operations + known failures) and automatically trains without ML expertise. The IoT integration pipeline enables real-time monitoring. Option A misses complex multi-sensor failure patterns. Option C works but requires ML expertise. Option D forecasts values but doesn't detect anomaly patterns.

---

### Question 62
A company wants to create a unified AI platform that allows different teams to use different foundation models (Claude, Titan, Llama) through a single interface. They need centralized access control, usage tracking, and cost allocation per team. What should the architect design?

A) Give each team direct access to Amazon Bedrock with their own API keys.  
B) Build a centralized AI gateway: Deploy an API Gateway with Lambda authorizer that authenticates team identity. Lambda backend routes requests to Amazon Bedrock's InvokeModel API with the specified model. Track usage per team using custom CloudWatch metrics (model invocations, token consumption, cost per team). Use IAM policies to control which teams can access which models. Implement caching in ElastiCache for repeated queries. Use AWS Budgets with team-specific cost allocation tags for chargeback.  
C) Deploy individual model instances per team using SageMaker.  
D) Use a third-party AI gateway service.

**Correct Answer: B**
**Explanation:** The centralized AI gateway pattern provides uniform access, governance, and cost tracking. API Gateway + Lambda handles authentication and routing. CloudWatch metrics track per-team usage. IAM controls model access per team. Caching reduces duplicate API calls. Cost allocation tags enable chargeback. This gives platform teams governance while teams get model flexibility. Option A lacks centralized control and cost tracking. Option C is expensive (dedicated instances per team). Option D adds third-party dependency.

---

### Question 63
A company is training a large ML model on SageMaker that requires 2TB of training data. Loading data from S3 at the start of training takes 45 minutes, delaying the training job. How should the architect reduce data loading time?

A) Use a smaller training dataset.  
B) Use SageMaker's Pipe mode (or Fast File mode) for data input instead of File mode. Pipe mode streams data directly from S3 into the training algorithm as it runs, eliminating the upfront download wait. Fast File mode uses a POSIX-compatible file system interface backed by S3, providing file-like access with streaming download. For repeated training with the same data, use Amazon FSx for Lustre integrated with SageMaker — FSx pre-loads S3 data into a high-performance file system, providing GB/s throughput to training instances.  
C) Compress the 2TB dataset to reduce download size.  
D) Copy the data to an EBS volume attached to the training instance before starting.

**Correct Answer: B**
**Explanation:** File mode downloads all data before training starts (45 minutes). Pipe mode streams data during training — training begins almost immediately. Fast File mode provides similar benefits with a file system interface. FSx for Lustre provides the highest performance (hundreds of GB/s aggregate throughput) and caches data for repeated training runs. Option A reduces data quality/quantity. Option C helps but still requires full download before training. Option D still requires downloading 2TB upfront.

---

### Question 64
A company wants to use AI to automatically categorize incoming customer support tickets into 25 categories (billing, technical, account, shipping, etc.) and assign priority (P1-P4). They have 100,000 historical tickets with category and priority labels. What should the architect use?

A) Use Amazon Comprehend's pre-trained topic detection.  
B) Train an Amazon Comprehend Custom Classification model with the 100,000 labeled tickets. Create two classifiers: one for category (25-class multi-class classification) and one for priority (4-class classification). The custom classifier learns from the labeled examples to classify new tickets. For real-time classification, use the Comprehend endpoint for synchronous inference. Integrate with the ticketing system via API Gateway → Lambda → Comprehend endpoint. Use Comprehend's confidence scores to route low-confidence classifications to human agents.  
C) Use Amazon Bedrock to classify each ticket with a prompt.  
D) Build keyword-matching rules for each category.

**Correct Answer: B**
**Explanation:** Comprehend Custom Classification trains on labeled data (100K tickets is excellent training data) to build domain-specific classifiers. Two separate classifiers handle category and priority independently. Real-time endpoints enable synchronous classification as tickets arrive. Confidence scores identify edge cases for human review. Option A — pre-trained topic detection finds general topics, not your 25 specific categories. Option C works but is more expensive per classification and less predictable than a trained classifier. Option D misses semantic variations.

---

### Question 65
A company has deployed multiple ML models on SageMaker endpoints. They want to consolidate models to reduce endpoint costs while maintaining the ability to route requests to the correct model. What should the architect use?

A) Deploy each model on its own endpoint with the smallest instance type.  
B) Use SageMaker Multi-Model Endpoints (MME). Deploy multiple models on a single endpoint — SageMaker dynamically loads and unloads models based on traffic patterns. Frequently accessed models stay in memory; infrequently accessed models are loaded on demand from S3. This shares the endpoint infrastructure (instances) across models. For models with predictable traffic, use SageMaker inference components (previously Multi-Container Endpoints) to co-locate models with guaranteed resource allocation per model.  
C) Merge all models into a single model.  
D) Use Lambda for all model inference.

**Correct Answer: B**
**Explanation:** Multi-Model Endpoints consolidate multiple models on shared infrastructure, significantly reducing costs (one endpoint instead of many). Dynamic model loading balances memory usage — hot models stay loaded, cold models are loaded on demand. Inference components provide more control for production workloads with predictable traffic. Option A still has per-endpoint base costs for each model. Option C — different models serve different purposes and can't be merged. Option D has cold start and size limitations for ML models.

---

### Question 66
A company wants to implement an AI-powered quality control system for their call center. The system should automatically score every customer call on metrics like agent courtesy, script adherence, issue resolution, and hold time. What should the architect design?

A) Have supervisors manually listen to random call samples.  
B) Use Amazon Transcribe Call Analytics as the foundation. It automatically provides: transcription with speaker diarization, turn-by-turn sentiment scores, interruption detection, non-talk time (hold time), and loudness scores. For script adherence, use Amazon Comprehend Custom Classification trained on compliant/non-compliant transcript segments. For resolution scoring, use Amazon Bedrock with a foundation model that evaluates the complete transcript against resolution criteria. Aggregate scores in a dashboard using Amazon QuickSight connected to the results stored in S3/Athena.  
C) Use Amazon Polly to replay calls at higher speed for faster review.  
D) Use Amazon Lex to detect call intents only.

**Correct Answer: B**
**Explanation:** Transcribe Call Analytics provides the speech analytics foundation (sentiment, interruptions, silence/hold detection). Comprehend Custom Classification scores script adherence by classifying transcript segments. Bedrock evaluates complex criteria like issue resolution. QuickSight provides management dashboards. This combination automates 100% call scoring (not just samples). Option A doesn't scale. Option C doesn't analyze content. Option D detects intents but doesn't score quality.

---

### Question 67
A company wants to use Amazon Bedrock but needs to ensure their proprietary data is not used to train the foundation models. They also need to keep all data within their VPC. What configurations should the architect implement?

A) Use the default Bedrock configuration.  
B) Configure Amazon Bedrock with VPC endpoints (PrivateLink) so all API calls stay within the VPC — no traffic traverses the public internet. Use Bedrock's data privacy commitment — by default, customer data is NOT used to train base models (this is a Bedrock guarantee, not a configuration). For additional control, enable AWS CloudTrail logging for all Bedrock API calls. Use IAM policies to restrict which models can be invoked and by which roles. For sensitive data, use customer-managed KMS keys for encryption of custom model training artifacts.  
C) Build a private deployment of the foundation model on SageMaker.  
D) Encrypt all prompts before sending to Bedrock.

**Correct Answer: B**
**Explanation:** Bedrock guarantees that customer data (inputs and outputs) is not used to train base models — this is a default policy. VPC endpoints (PrivateLink) ensure all Bedrock traffic stays private. CloudTrail provides audit logging. IAM policies control access. KMS encryption protects custom model artifacts. Option A — while Bedrock's defaults are secure, VPC endpoints and logging should be explicitly configured. Option C is unnecessary given Bedrock's privacy guarantees. Option D — encrypting prompts would make them unusable by the model.

---

### Question 68
A company is building a document workflow automation system. When a new document arrives (invoice, contract, form), the system should automatically: classify the document type, extract relevant fields, validate the data, and route it to the appropriate business process. What end-to-end architecture should the architect design?

A) Build a single large model that handles all steps.  
B) Build an intelligent document processing (IDP) pipeline using Step Functions: (1) Amazon Textract for text/structure extraction from the document. (2) Amazon Comprehend Custom Classification to classify the document type (invoice, contract, form). (3) Based on classification, route to the appropriate Textract API (AnalyzeExpense for invoices, AnalyzeDocument with Queries for contracts). (4) Lambda function validates extracted data against business rules (e.g., invoice total matches line items). (5) Invalid documents go to Amazon A2I for human review. (6) Valid documents are stored in DynamoDB and routed to the appropriate downstream system via EventBridge.  
C) Use Amazon Kendra to process all incoming documents.  
D) Store documents in S3 and let humans process them.

**Correct Answer: B**
**Explanation:** This IDP pipeline automates the full document lifecycle: classification determines the document type, specialized extraction gets the right data for each type, validation catches errors, A2I handles exceptions, and EventBridge routes validated documents. Step Functions orchestrates the multi-step workflow. Each service handles its specialty. Option A — a single model can't handle all steps optimally. Option C — Kendra searches documents but doesn't extract, validate, and route. Option D doesn't automate.

---

### Question 69
A company wants to implement anomaly detection on their application metrics (request latency, error rate, CPU utilization) without defining static thresholds. The system should learn normal patterns (including daily/weekly seasonality) and alert on deviations. What should the architect use?

A) Set static CloudWatch Alarms for each metric.  
B) Use Amazon CloudWatch Anomaly Detection. Enable anomaly detection on the relevant metrics — CloudWatch automatically builds a model of normal metric behavior, including daily and weekly seasonality patterns. Configure CloudWatch Alarms based on the anomaly detection band (alerts when the metric falls outside the expected range). For more complex multi-metric anomaly detection, use Amazon Lookout for Metrics which correlates anomalies across metrics and identifies root causes.  
C) Build a custom anomaly detection model using SageMaker.  
D) Use Amazon DevOps Guru for all metrics anomaly detection.

**Correct Answer: B**
**Explanation:** CloudWatch Anomaly Detection applies ML to learn metric patterns, automatically adjusting for seasonality. Alarms trigger when metrics deviate from the learned pattern (dynamic thresholds). Lookout for Metrics adds multi-metric correlation (e.g., latency spike + error rate increase = specific root cause). Both are managed services requiring no ML expertise. Option A — static thresholds don't adapt to seasonal patterns. Option C requires building and maintaining custom models. Option D — DevOps Guru is for operational insights, not general metric anomaly detection.

---

### Question 70
A company is training an ML model on SageMaker using sensitive customer data distributed across multiple AWS accounts. Data cannot be moved from its source accounts. How should the architect enable cross-account model training without data movement?

A) Copy all data to a central account for training.  
B) Use SageMaker with cross-account S3 access. Configure S3 bucket policies in each data account to grant read access to the SageMaker execution role in the training account. The training job specifies S3 paths from multiple accounts as input channels. For data that truly cannot leave the account, use SageMaker Federated Learning — train partial models on data in each account and aggregate model updates (not data) centrally. Alternatively, use SageMaker Processing jobs in each account and aggregate features.  
C) Use AWS DataSync to replicate data across accounts.  
D) Train separate models in each account.

**Correct Answer: B**
**Explanation:** Cross-account S3 access allows SageMaker in one account to read training data from other accounts without copying. For stricter data residency (data can't leave the account even for reading), federated learning trains on data locally and only shares model updates (gradients/parameters). This preserves data sovereignty. Option A violates the data movement restriction. Option C also moves data. Option D creates fragmented, potentially lower-quality models.

---

### Question 71
A company uses Amazon Personalize for recommendations. They notice that the model recommends the same popular items to most users, not providing truly personalized recommendations. The interaction dataset is heavily skewed — 80% of interactions are with the top 100 items (out of 50,000). How should the architect address this?

A) Remove popular items from the catalog.  
B) Adjust the Amazon Personalize solution configuration: (1) Increase the exploration weight in the User-Personalization recipe to increase diversity beyond popular items. (2) Add item metadata (category, attributes) to the Items dataset so Personalize can recommend similar items from underrepresented categories. (3) Use Personalize filters to exclude recently interacted items and promote items from underrepresented categories. (4) Implement business rules via filters (e.g., exclude items already purchased, boost new arrivals). (5) Consider the Personalized-Ranking recipe to re-rank a curated list that already includes diverse items.  
C) Add more interaction data for unpopular items by generating synthetic data.  
D) Switch to a simple collaborative filtering algorithm.

**Correct Answer: B**
**Explanation:** Popularity bias is a common recommendation system issue. Exploration weight balances exploitation (known popular items) with exploration (potentially relevant but less popular items). Item metadata enables content-based diversification. Filters enforce business rules (no repeat recommendations, category quotas). Personalized-Ranking re-ranks curated lists. These combined techniques increase recommendation diversity. Option A loses legitimate popular items. Option C — synthetic data introduces noise. Option D is less sophisticated than Personalize.

---

### Question 72
A company is deploying a text-to-SQL AI feature where users ask natural language questions about their data ("What were total sales by region last quarter?"), and the system generates and executes SQL queries. The database schema has 200 tables. What architecture ensures accurate SQL generation?

A) Use a generic LLM to generate SQL without schema context.  
B) Use Amazon Bedrock with a foundation model and provide database schema as context. Implement a multi-step pipeline: (1) Store the full schema (DDL, table descriptions, sample queries) in a Bedrock Knowledge Base. (2) When a user asks a question, retrieve the relevant table schemas from the knowledge base (RAG). (3) Prompt the model with the retrieved schemas and the user's question to generate SQL. (4) Validate the generated SQL syntax before execution. (5) Execute against a read-only database replica. (6) Return results to the user. Cache common query patterns for performance.  
C) Pre-build all possible SQL queries and match user questions to them.  
D) Use Amazon Athena's natural language query feature exclusively.

**Correct Answer: B**
**Explanation:** RAG retrieves relevant table schemas (from 200 tables, only the relevant ones) for context, enabling accurate SQL generation. The knowledge base stores schema details, sample queries, and business glossary. Validation prevents syntax errors. Read-only replica prevents accidental data modification. Caching handles common patterns efficiently. Option A — without schema context, SQL generation is inaccurate for 200 tables. Option C can't cover all possible questions. Option D — Athena NL query is limited in scope.

---

### Question 73
A healthcare company wants to use Amazon Bedrock for a patient-facing application that answers health questions. They must ensure the AI never provides specific medical diagnoses or treatment recommendations, always directs emergencies to 911, and includes disclaimers. What safety architecture should the architect implement?

A) Add a disclaimer to the system prompt and hope the model follows it.  
B) Implement comprehensive safety layers: (1) Bedrock Guardrails — configure denied topics for medical diagnosis and treatment recommendations. (2) System prompt with strict instructions: "You are a health information assistant. Never diagnose conditions. Never recommend specific treatments. Always include a disclaimer to consult a healthcare professional. For emergencies, immediately direct to 911." (3) Response post-processing Lambda that checks for diagnostic/treatment language using Amazon Comprehend Medical (if entities include treatments prescribed or diagnoses, flag and rewrite). (4) Pre-defined responses for emergency keywords. (5) Human-in-the-loop review for flagged responses via A2I.  
C) Use Amazon Comprehend Medical instead of Bedrock to avoid generative AI risks.  
D) Require users to sign a waiver before using the application.

**Correct Answer: B**
**Explanation:** Healthcare AI requires multiple safety layers — no single technique is sufficient. Guardrails block defined topics. System prompts guide the model. Post-processing with Comprehend Medical catches diagnostic language the model may still generate. Emergency keyword detection provides immediate redirection. A2I human review catches edge cases. This defense-in-depth approach is essential for healthcare applications. Option A is insufficient. Option C doesn't answer health questions. Option D doesn't prevent AI harm.

---

### Question 74
A company wants to reduce their SageMaker inference costs. They have 20 real-time endpoints, most receiving fewer than 100 requests per day but requiring sub-second response times when called. What should the architect recommend?

A) Keep all 20 real-time endpoints running.  
B) Migrate low-traffic endpoints to SageMaker Serverless Inference. Serverless endpoints scale to zero when not in use (no cost for idle time) and auto-provision capacity on demand. Configure provisioned concurrency for the minimum number of endpoints that need guaranteed cold-start-free responses. For endpoints with predictable traffic patterns, use SageMaker Inference auto-scaling with scale-to-zero capability. Keep high-traffic endpoints on dedicated real-time endpoints with right-sized instances.  
C) Replace all endpoints with Lambda functions.  
D) Run batch prediction jobs instead of real-time endpoints.

**Correct Answer: B**
**Explanation:** Serverless Inference is ideal for low-traffic endpoints — you pay only when the endpoint processes requests. At 100 requests/day, serverless costs a fraction of a dedicated endpoint. Provisioned concurrency addresses cold start concerns for latency-sensitive endpoints. High-traffic endpoints stay on dedicated instances for consistent performance. This tiered approach optimizes cost across all 20 endpoints. Option A wastes money on idle capacity. Option C may not support model sizes/frameworks. Option D changes the access pattern from real-time.

---

### Question 75
A company is building a multi-modal AI application that processes customer support interactions across channels: voice calls (audio), chat transcripts (text), screenshots of errors (images), and video screen recordings. They need to understand the full customer issue across all modalities. What comprehensive architecture should the architect design?

A) Build separate AI systems for each modality.  
B) Build a unified multi-modal processing pipeline: (1) Audio: Amazon Transcribe → text transcript + Amazon Comprehend for sentiment. (2) Text: Amazon Comprehend for entity extraction, key phrases, and sentiment. (3) Images: Amazon Rekognition for label detection + Amazon Textract for text extraction from screenshots + Amazon Bedrock with vision model for error analysis. (4) Video: Amazon Rekognition Video for visual analysis + Transcribe for audio track. (5) Unified analysis: Feed all extracted information into Amazon Bedrock (large context model) to synthesize a comprehensive issue summary across all modalities. (6) Store in OpenSearch for agent search. (7) Use Personalize to route to the most skilled agent for the issue type.  
C) Convert all modalities to text and process uniformly.  
D) Require customers to describe their issue in text only.

**Correct Answer: B**
**Explanation:** Each modality requires its specialized processing service, but the key innovation is the unified synthesis using Bedrock — the foundation model combines all extracted information (transcript, sentiment, error screenshots, video analysis) into a comprehensive understanding. This multi-modal fusion provides richer context than any single modality. Option A creates siloed understanding. Option C loses visual/audio information during conversion. Option D limits customer experience and loses rich diagnostic information.

---

## Answer Key

| # | Answer | # | Answer | # | Answer | # | Answer | # | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B | 31 | B | 46 | B | 61 | B |
| 2 | B | 17 | B | 32 | B | 47 | B | 62 | B |
| 3 | B | 18 | B | 33 | B | 48 | B | 63 | B |
| 4 | B | 19 | B | 34 | B | 49 | B | 64 | B |
| 5 | B | 20 | B | 35 | B | 50 | B | 65 | B |
| 6 | B | 21 | B | 36 | B | 51 | B | 66 | B |
| 7 | C | 22 | B | 37 | B | 52 | B | 67 | B |
| 8 | A | 23 | B | 38 | B | 53 | B | 68 | B |
| 9 | B | 24 | B | 39 | B | 54 | B | 69 | B |
| 10 | B | 25 | B | 40 | B | 55 | B | 70 | B |
| 11 | B | 26 | B | 41 | B | 56 | B | 71 | B |
| 12 | B | 27 | B | 42 | A | 57 | B | 72 | B |
| 13 | B | 28 | B | 43 | A,B | 58 | B | 73 | B |
| 14 | B | 29 | B | 44 | B | 59 | B | 74 | B |
| 15 | B | 30 | C | 45 | B | 60 | B | 75 | B |

---

### Domain Distribution
- **Domain 1 — Organizational Complexity:** Q5, Q13, Q15, Q22, Q26, Q27, Q28, Q44, Q46, Q50, Q54, Q57, Q60, Q62, Q64, Q67, Q68, Q70, Q73, Q75 (20)
- **Domain 2 — New Solutions:** Q1, Q2, Q3, Q4, Q6, Q7, Q8, Q14, Q17, Q18, Q19, Q20, Q24, Q29, Q31, Q37, Q39, Q47, Q48, Q51, Q55, Q61 (22)
- **Domain 3 — Continuous Improvement:** Q10, Q21, Q25, Q33, Q36, Q41, Q45, Q52, Q66, Q69, Q71 (11)
- **Domain 4 — Migration & Modernization:** Q9, Q16, Q32, Q34, Q40, Q42, Q49, Q53, Q58 (9)
- **Domain 5 — Cost Optimization:** Q11, Q12, Q23, Q30, Q35, Q38, Q43, Q56, Q59, Q63, Q65, Q72, Q74 (13)
