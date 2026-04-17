# Diagrams — Mermaid Reference

> Paste any of these into a Mermaid renderer (GitHub preview, VS Code Mermaid, mermaid.live) to view them.

---

## 1. AI / ML / DL / GenAI Hierarchy

```mermaid
flowchart TD
    AI["Artificial Intelligence<br/>Any machine that appears intelligent"]
    ML["Machine Learning<br/>Learns from data"]
    DL["Deep Learning<br/>Multi-layer neural networks"]
    GEN["Generative AI<br/>Models that generate new content"]
    FM["Foundation Models<br/>Large pretrained, adaptable"]
    LLM["Large Language Models"]
    AI --> ML --> DL --> GEN
    GEN --> FM --> LLM
```

---

## 2. ML Development Lifecycle

```mermaid
flowchart LR
    A[1. Business Framing] --> B[2. Data Collection]
    B --> C[3. Data Prep &<br/>Feature Engineering]
    C --> D[4. Model Training]
    D --> E[5. Evaluation]
    E -->|passes| F[6. Deployment]
    E -->|fails| D
    F --> G[7. Monitor &<br/>Maintain]
    G -->|drift| D
```

---

## 3. Three Layers of AWS AI Stack

```mermaid
flowchart TB
    subgraph L1["AI Services (API-level)"]
        Rek[Rekognition]
        Tra[Translate]
        Com[Comprehend]
        Tex[Textract]
        Trs[Transcribe]
        Pol[Polly]
        Lex[Lex]
        Ken[Kendra]
        Per[Personalize]
        Q[Amazon Q]
    end
    subgraph L2["ML Platform"]
        SM[SageMaker]
        BR[Bedrock]
    end
    subgraph L3["Frameworks & Infra"]
        EC2[EC2 GPU/Trainium/Inferentia]
        ECS[ECS/EKS]
        DLC[Deep Learning Containers]
    end
    L1 --> L2 --> L3
```

---

## 4. Transformer (High-Level)

```mermaid
flowchart TB
    IN[Input tokens] --> EMB[Token embeddings]
    EMB --> POS[Positional encoding]
    POS --> BLK[(Transformer block x N)]
    BLK --> OUT[Output logits / next token]
    subgraph block["Transformer block"]
        direction TB
        SA[Multi-head<br/>self-attention]
        A1[Residual + LayerNorm]
        FF[Feed-forward MLP]
        A2[Residual + LayerNorm]
        SA --> A1 --> FF --> A2
    end
```

---

## 5. RAG Architecture (Bedrock Knowledge Base)

```mermaid
flowchart LR
    U[User question] -->|embed| E[Embedding model<br/>Titan / Cohere]
    E --> VS[(Vector store<br/>OpenSearch / Aurora /<br/>Pinecone / Redis)]
    S3[(S3 / Confluence /<br/>SharePoint / Salesforce)] -->|chunk + embed| VS
    VS -->|top-K chunks| PB[Prompt builder]
    U --> PB
    PB --> FM[Foundation Model<br/>Claude / Nova]
    FM --> GR[Guardrails]
    GR --> ANS[Answer + citations]
```

---

## 6. Agents for Bedrock

```mermaid
flowchart LR
    User -->|InvokeAgent| Agent
    Agent -->|plan| FM[Foundation Model]
    Agent -->|action| AG[Action Group<br/>Lambda / OpenAPI]
    Agent -->|retrieve| KB[Knowledge Base]
    Agent -->|filter| GR[Guardrail]
    AG -->|API call| EXT[Internal API / CRM]
    KB --> VS[(Vector store)]
    Agent --> MEM[Session memory]
    Agent --> OUT[Final response]
```

---

## 7. SageMaker Pipeline Example

```mermaid
flowchart LR
    P[ProcessingStep<br/>data prep] --> T[TrainingStep]
    T --> E[EvaluationStep]
    E --> C{Accuracy > 0.85?}
    C -->|yes| R[RegisterModelStep]
    R --> D[CreateEndpointStep]
    C -->|no| F[Fail / notify]
```

---

## 8. Responsible AI Framework

```mermaid
mindmap
  root((Responsible AI))
    Fairness
      Detect bias - Clarify
      Mitigate - rebalancing / threshold
    Explainability
      SHAP / Clarify
      Model Cards
    Privacy & Security
      KMS / IAM / VPC
      Guardrails PII
      Macie / Comprehend
    Safety
      Guardrails content filters
      Human in loop A2I
    Controllability
      Versioning / Rollback
      Kill switch
    Veracity & Robustness
      RAG + grounding
      Evaluation + red team
    Transparency
      Model Cards
      AI Service Cards
      Citations
    Governance
      Model Registry
      Audit Manager
      ISO 42001 / NIST AI RMF
```

---

## 9. Shared Responsibility for Managed AI

```mermaid
flowchart TB
    subgraph AWS["AWS - Security OF the cloud"]
        infra[Global infra]
        svc[Managed service operation]
        fm[Foundation model weights]
    end
    subgraph You["You - Security IN the cloud"]
        data[Your data & prompts]
        iam[IAM / KMS]
        net[VPC endpoints / networking]
        app[App logic, guardrails, monitoring]
    end
```

---

## 10. Bedrock Guardrails Features

```mermaid
flowchart LR
    IN[User input / prompt] --> G{Guardrail}
    G -->|content filters| CF[Hate / Sexual / Violence /<br/>Insults / Misconduct / PromptAttack]
    G -->|denied topics| DT[Up to 30 topics]
    G -->|word filters| WF[Custom + profanity]
    G -->|PII| PII[Block / Mask / Custom regex]
    G -->|grounding| CG[Grounding + Relevance]
    G -->|auto reason| AR[Automated Reasoning]
    G --> FM[Foundation Model]
    FM --> OUT[Response]
    OUT --> G2{Guardrail - response}
    G2 --> FINAL[Final response]
```

---

## 11. Customization Ladder

```mermaid
flowchart LR
    PE[Prompt Engineering<br/>lowest cost] --> RAG[RAG<br/>medium cost]
    RAG --> FT[Fine-tune<br/>higher cost]
    FT --> CPT[Continued Pretraining<br/>highest cost]
    CPT --> SCR[Train from scratch<br/>rarely]
    CPT --> DIST[Distillation<br/>smaller student]
```

---

## 12. GenAI Security Scoping Matrix

```mermaid
flowchart LR
    S1[Scope 1<br/>Consumer app<br/>ChatGPT, Gemini]
    S2[Scope 2<br/>Enterprise app<br/>Q Business, Bedrock Studio]
    S3[Scope 3<br/>Pretrained FM via API<br/>Bedrock base model]
    S4[Scope 4<br/>Fine-tuned model<br/>Bedrock custom]
    S5[Scope 5<br/>Self-trained<br/>SageMaker from scratch]
    S1 --> S2 --> S3 --> S4 --> S5
```

---

## 13. Secure RAG Reference

```mermaid
flowchart LR
    Client -->|TLS| APIGW[API Gateway]
    APIGW -->|invoke| L[Lambda<br/>chat role]
    L -->|PrivateLink| BR[Bedrock]
    L -->|PrivateLink| KB[Knowledge Base]
    KB -->|KMS-encrypted| S3[(S3 docs)]
    KB -->|PrivateLink| OSS[(OpenSearch Serverless)]
    CT[CloudTrail] -.-> BR
    CW[CloudWatch] -.-> BR
    KMS[KMS CMK] -.-> S3
    KMS -.-> OSS
```

---

## 14. Model Selection Decision Tree

```mermaid
flowchart TD
    Q1{Knowledge needs<br/>to be fresh/private?}
    Q1 -->|yes| RAG[Use RAG]
    Q1 -->|no| Q2{Need persistent<br/>style/format?}
    Q2 -->|yes| FT[Fine-tune]
    Q2 -->|no| Q3{Multi-step<br/>tool use?}
    Q3 -->|yes| Agent[Bedrock Agent]
    Q3 -->|no| Q4{Multimodal?}
    Q4 -->|yes| MM[Claude 3 / Nova Pro]
    Q4 -->|no| Q5{Latency sensitive?}
    Q5 -->|yes| SMALL[Haiku / Nova Micro]
    Q5 -->|no| BAL[Sonnet / Nova Pro]
```

