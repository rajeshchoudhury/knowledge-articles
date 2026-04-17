# Generative AI — RAG Pattern with Amazon Bedrock

```mermaid
graph LR
  Docs[(Corporate docs in S3)] --> Ingest["Bedrock Knowledge Base<br/>ingestion job"]
  Ingest --> Vec[(Vector store:<br/>OpenSearch Serverless / Aurora PG / Pinecone)]
  User((User)) --> App["Web/Mobile App"]
  App --> APIG["API Gateway"]
  APIG --> Lambda["Lambda"]
  Lambda --> KB["Bedrock Knowledge Base<br/>retrieve_and_generate"]
  KB --> Vec
  KB --> FM["Bedrock Foundation Model<br/>(Claude / Llama / Titan / Nova)"]
  FM --> KB
  KB --> Lambda
  Lambda --> App
  Guardrails["Bedrock Guardrails"] -. filter .-> FM
  Cognito["Cognito"] -. authn .-> APIG
```

**Why this pattern**
- Foundation Models don't know your private data. **RAG** (Retrieval
  Augmented Generation) adds your knowledge by embedding your docs into
  a vector DB and retrieving relevant chunks at query time.
- **Knowledge Bases for Amazon Bedrock** wraps this pattern.
- **Guardrails** enforce deny topics, PII filtering, and hallucination
  checks.
- Use **Agents** for tool-using LLM workflows (call APIs, Lambdas).
