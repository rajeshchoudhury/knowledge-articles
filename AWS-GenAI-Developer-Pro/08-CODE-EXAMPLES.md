# 08 — Code Examples Guide: AWS Generative AI Developer – Professional (AIP-C01)

> Production-quality Python/Boto3 examples covering every key exam scenario.
> Each example is self-contained, includes error handling, and notes exam-relevant details.

---

## Section 1: Amazon Bedrock Basics

### 1.1 Invoke a Model (Claude) — Synchronous

```python
import boto3
import json

bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

def invoke_claude(prompt: str, max_tokens: int = 512) -> str:
    """Invoke Claude on Bedrock using the Messages API (synchronous)."""
    body = json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": max_tokens,
        "messages": [
            {"role": "user", "content": prompt}
        ]
    })

    try:
        response = bedrock_runtime.invoke_model(
            modelId="anthropic.claude-3-sonnet-20240229-v1:0",
            contentType="application/json",
            accept="application/json",
            body=body,
        )
        result = json.loads(response["body"].read())
        return result["content"][0]["text"]

    except bedrock_runtime.exceptions.ThrottlingException:
        raise RuntimeError("Rate limit exceeded — implement backoff")
    except bedrock_runtime.exceptions.ModelTimeoutException:
        raise RuntimeError("Model invocation timed out")
    except bedrock_runtime.exceptions.ValidationException as e:
        raise ValueError(f"Invalid request: {e}")

# --- usage ---
answer = invoke_claude("Explain the shared responsibility model in AWS.")
print(answer)

# Expected response shape from the raw API:
# {
#   "id": "msg_...",
#   "type": "message",
#   "role": "assistant",
#   "content": [{"type": "text", "text": "The shared responsibility..."}],
#   "stop_reason": "end_turn",
#   "usage": {"input_tokens": 14, "output_tokens": 237}
# }
#
# EXAM NOTE: invoke_model returns a StreamingBody in response["body"].
# You must call .read() to get bytes, then json.loads() to parse.
# The modelId uses the full ARN-style ID or the shorthand shown above.
```

### 1.2 Invoke a Model with Streaming Response

```python
import boto3
import json

bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

def invoke_claude_streaming(prompt: str, max_tokens: int = 1024):
    """Stream tokens from Claude — lower time-to-first-token for UX."""
    body = json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "max_tokens": max_tokens,
        "messages": [{"role": "user", "content": prompt}],
    })

    response = bedrock_runtime.invoke_model_with_response_stream(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        contentType="application/json",
        accept="application/json",
        body=body,
    )

    full_text = ""
    for event in response["body"]:
        chunk = json.loads(event["chunk"]["bytes"])
        if chunk["type"] == "content_block_delta":
            token = chunk["delta"]["text"]
            full_text += token
            print(token, end="", flush=True)
    print()
    return full_text

# EXAM NOTE: Streaming is critical for chat UIs — it reduces perceived latency.
# The event stream yields: message_start → content_block_start →
# content_block_delta (repeated) → content_block_stop → message_delta → message_stop.
```

### 1.3 Use the Converse API for Multi-Turn Conversations

```python
import boto3

bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

def multi_turn_converse():
    """
    The Converse API provides a model-agnostic interface for conversations.
    Swap modelId and everything else stays the same.
    """
    messages = []

    turns = [
        "What is Amazon Bedrock?",
        "How does it compare to SageMaker for LLM deployment?",
        "Summarize the key differences in a table.",
    ]

    for user_msg in turns:
        messages.append({"role": "user", "content": [{"text": user_msg}]})

        response = bedrock_runtime.converse(
            modelId="anthropic.claude-3-sonnet-20240229-v1:0",
            messages=messages,
            inferenceConfig={
                "maxTokens": 1024,
                "temperature": 0.3,
                "topP": 0.9,
            },
            system=[{"text": "You are a concise AWS solutions architect."}],
        )

        assistant_msg = response["output"]["message"]
        messages.append(assistant_msg)

        print(f"User: {user_msg}")
        print(f"Assistant: {assistant_msg['content'][0]['text'][:200]}...")
        print(f"  Tokens — in: {response['usage']['inputTokens']}, "
              f"out: {response['usage']['outputTokens']}")
        print()

    return messages

# EXAM NOTE: The Converse API is the RECOMMENDED approach for new applications.
# It works across ALL Bedrock models with the same request format.
# Key advantages: built-in conversation history, tool use, guardrail integration.
# converse_stream() is the streaming variant.
```

### 1.4 Invoke a Model with Image Input (Multimodal)

```python
import boto3
import base64
from pathlib import Path

bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

def analyze_image(image_path: str, question: str) -> str:
    """Send an image + text prompt to Claude (vision)."""
    image_bytes = Path(image_path).read_bytes()
    media_type = "image/png" if image_path.endswith(".png") else "image/jpeg"

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "image": {
                            "format": media_type.split("/")[1],
                            "source": {"bytes": image_bytes},
                        }
                    },
                    {"text": question},
                ],
            }
        ],
        inferenceConfig={"maxTokens": 1024},
    )
    return response["output"]["message"]["content"][0]["text"]

# --- usage ---
# result = analyze_image("architecture.png", "Describe this AWS architecture diagram.")

# EXAM NOTE: Multimodal input is supported via the Converse API.
# Supported image formats: png, jpeg, gif, webp.
# Max image size: 3.75 MB per image; up to 20 images per request.
# The image can be passed as raw bytes (source.bytes) or S3 URI.
```

### 1.5 List Available Foundation Models

```python
import boto3

bedrock = boto3.client("bedrock", region_name="us-east-1")

def list_models(provider: str | None = None, output_modality: str | None = None):
    """List foundation models available in Bedrock, with optional filters."""
    kwargs = {}
    if provider:
        kwargs["byProvider"] = provider
    if output_modality:
        kwargs["byOutputModality"] = output_modality

    response = bedrock.list_foundation_models(**kwargs)

    for model in response["modelSummaries"]:
        print(f"{model['modelId']:55s}  "
              f"provider={model['providerName']:15s}  "
              f"modalities={model.get('outputModalities', [])}")
    return response["modelSummaries"]

# --- usage ---
# list_models(provider="anthropic")
# list_models(output_modality="EMBEDDING")

# EXAM NOTE: Use the 'bedrock' client (control plane) not 'bedrock-runtime'.
# Filters: byProvider, byCustomizationType, byOutputModality,
#           byInferenceType (ON_DEMAND | PROVISIONED).
```

### 1.6 Get Model Details

```python
import boto3

bedrock = boto3.client("bedrock", region_name="us-east-1")

def get_model_info(model_id: str):
    """Retrieve detailed information about a foundation model."""
    response = bedrock.get_foundation_model(modelIdentifier=model_id)
    model = response["modelDetails"]
    print(f"Model:       {model['modelId']}")
    print(f"Provider:    {model['providerName']}")
    print(f"Input:       {model['inputModalities']}")
    print(f"Output:      {model['outputModalities']}")
    print(f"Streaming:   {model.get('responseStreamingSupported', False)}")
    print(f"Customise:   {model.get('customizationsSupported', [])}")
    return model

# EXAM NOTE: This is useful for checking whether a model supports
# fine-tuning, streaming, or specific modalities before writing code.
```

---

## Section 2: Amazon Bedrock Knowledge Bases

### 2.1 Create a Knowledge Base

```python
import boto3
import json
import time

bedrock_agent = boto3.client("bedrock-agent", region_name="us-east-1")

def create_knowledge_base(
    name: str,
    role_arn: str,
    embedding_model_arn: str,
    collection_arn: str,
    vector_index_name: str,
) -> dict:
    """
    Create a Bedrock Knowledge Base backed by OpenSearch Serverless.
    """
    response = bedrock_agent.create_knowledge_base(
        name=name,
        description="Product documentation knowledge base",
        roleArn=role_arn,
        knowledgeBaseConfiguration={
            "type": "VECTOR",
            "vectorKnowledgeBaseConfiguration": {
                "embeddingModelArn": embedding_model_arn,
                # e.g. "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"
            },
        },
        storageConfiguration={
            "type": "OPENSEARCH_SERVERLESS",
            "opensearchServerlessConfiguration": {
                "collectionArn": collection_arn,
                "vectorIndexName": vector_index_name,
                "fieldMapping": {
                    "vectorField": "embedding",
                    "textField": "text",
                    "metadataField": "metadata",
                },
            },
        },
    )
    kb = response["knowledgeBase"]
    print(f"Created KB: {kb['knowledgeBaseId']} — status: {kb['status']}")
    return kb

# EXAM NOTE: Supported vector stores — OpenSearch Serverless, Aurora PostgreSQL
# (pgvector), Pinecone, Redis Enterprise Cloud, MongoDB Atlas.
# The embedding model must be enabled in your account (Model Access).
# The IAM role needs bedrock:InvokeModel on the embedding model + vector-store access.
```

### 2.2 Create a Data Source for the Knowledge Base

```python
def create_s3_data_source(
    knowledge_base_id: str,
    bucket_arn: str,
    prefix: str = "",
) -> dict:
    """Attach an S3 bucket as a data source to an existing knowledge base."""
    response = bedrock_agent.create_data_source(
        knowledgeBaseId=knowledge_base_id,
        name="s3-docs-source",
        description="Product documentation from S3",
        dataSourceConfiguration={
            "type": "S3",
            "s3Configuration": {
                "bucketArn": bucket_arn,
                "inclusionPrefixes": [prefix] if prefix else [],
            },
        },
        vectorIngestionConfiguration={
            "chunkingConfiguration": {
                "chunkingStrategy": "FIXED_SIZE",
                "fixedSizeChunkingConfiguration": {
                    "maxTokens": 300,
                    "overlapPercentage": 20,
                },
            }
        },
    )
    ds = response["dataSource"]
    print(f"Data source created: {ds['dataSourceId']}")
    return ds

# EXAM NOTE: Chunking strategies available:
#   FIXED_SIZE  — uniform chunks (maxTokens + overlapPercentage)
#   NONE        — each file = one chunk (good for small files)
#   HIERARCHICAL — parent/child chunks for better context
#   SEMANTIC    — LLM-based boundary detection
# Supported data source types: S3, Web Crawler, Confluence, Salesforce, SharePoint.
```

### 2.3 Start Ingestion Job (Sync Data)

```python
def start_ingestion(knowledge_base_id: str, data_source_id: str) -> str:
    """Trigger a sync job to ingest documents from the data source."""
    response = bedrock_agent.start_ingestion_job(
        knowledgeBaseId=knowledge_base_id,
        dataSourceId=data_source_id,
    )
    job_id = response["ingestionJob"]["ingestionJobId"]
    print(f"Ingestion started: {job_id}")

    while True:
        status_resp = bedrock_agent.get_ingestion_job(
            knowledgeBaseId=knowledge_base_id,
            dataSourceId=data_source_id,
            ingestionJobId=job_id,
        )
        status = status_resp["ingestionJob"]["status"]
        print(f"  Status: {status}")
        if status in ("COMPLETE", "FAILED"):
            stats = status_resp["ingestionJob"].get("statistics", {})
            print(f"  Documents scanned: {stats.get('numberOfDocumentsScanned', 0)}")
            print(f"  Documents indexed: {stats.get('numberOfNewDocumentsIndexed', 0)}")
            print(f"  Documents failed:  {stats.get('numberOfDocumentsFailed', 0)}")
            break
        time.sleep(10)

    return job_id

# EXAM NOTE: Ingestion is async. Poll with get_ingestion_job.
# Incremental sync only processes new/modified files.
```

### 2.4 Query a Knowledge Base (RetrieveAndGenerate)

```python
bedrock_agent_runtime = boto3.client("bedrock-agent-runtime", region_name="us-east-1")

def retrieve_and_generate(knowledge_base_id: str, query: str) -> dict:
    """
    Single API call: retrieve relevant docs and generate an answer.
    This is the simplest RAG pattern with Bedrock.
    """
    response = bedrock_agent_runtime.retrieve_and_generate(
        input={"text": query},
        retrieveAndGenerateConfiguration={
            "type": "KNOWLEDGE_BASE",
            "knowledgeBaseConfiguration": {
                "knowledgeBaseId": knowledge_base_id,
                "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0",
                "retrievalConfiguration": {
                    "vectorSearchConfiguration": {
                        "numberOfResults": 5,
                        "overrideSearchType": "HYBRID",
                    }
                },
                "generationConfiguration": {
                    "inferenceConfig": {
                        "textInferenceConfig": {
                            "maxTokens": 1024,
                            "temperature": 0.2,
                        }
                    }
                },
            },
        },
    )
    answer = response["output"]["text"]
    citations = response.get("citations", [])
    print(f"Answer: {answer[:300]}...")
    for i, c in enumerate(citations):
        for ref in c.get("retrievedReferences", []):
            loc = ref["location"]
            print(f"  Citation {i}: {loc.get('s3Location', {}).get('uri', 'N/A')}")
    return response

# EXAM NOTE: RetrieveAndGenerate = fully managed RAG (retrieve + augment + generate).
# overrideSearchType can be HYBRID or SEMANTIC.
# HYBRID combines keyword (BM25) + vector search for better recall.
# Citations are returned automatically — critical for trustworthy AI.
```

### 2.5 Retrieve Documents Only (Without Generation)

```python
def retrieve_only(knowledge_base_id: str, query: str, top_k: int = 5) -> list:
    """Retrieve relevant chunks without invoking the generation model."""
    response = bedrock_agent_runtime.retrieve(
        knowledgeBaseId=knowledge_base_id,
        retrievalQuery={"text": query},
        retrievalConfiguration={
            "vectorSearchConfiguration": {
                "numberOfResults": top_k,
                "overrideSearchType": "HYBRID",
            }
        },
    )
    results = []
    for r in response["retrievalResults"]:
        results.append({
            "text": r["content"]["text"],
            "score": r["score"],
            "source": r["location"].get("s3Location", {}).get("uri", ""),
        })
        print(f"  Score {r['score']:.4f} — {results[-1]['source']}")
    return results

# EXAM NOTE: Use retrieve() when you want to:
#   - Implement custom prompting on retrieved context
#   - Apply your own reranking
#   - Feed results to a different model or downstream pipeline
# This gives you full control over the generation step.
```

### 2.6 Create Knowledge Base with Different Chunking Strategies

```python
# Hierarchical chunking — parent chunks for context, child chunks for precision
hierarchical_config = {
    "chunkingConfiguration": {
        "chunkingStrategy": "HIERARCHICAL",
        "hierarchicalChunkingConfiguration": {
            "levelConfigurations": [
                {"maxTokens": 1500},   # parent chunk
                {"maxTokens": 300},    # child chunk
            ],
            "overlapTokens": 60,
        },
    }
}

# Semantic chunking — uses an FM to detect natural breakpoints
semantic_config = {
    "chunkingConfiguration": {
        "chunkingStrategy": "SEMANTIC",
        "semanticChunkingConfiguration": {
            "maxTokens": 300,
            "bufferSize": 0,
            "breakpointPercentileThreshold": 95,
        },
    }
}

# EXAM NOTE:
# FIXED_SIZE   — fast, simple, good default. Overlap prevents losing context at boundaries.
# HIERARCHICAL — best for long documents; retrieves child chunk but uses parent for context.
# SEMANTIC     — highest quality boundaries; uses embeddings to detect topic shifts.
# NONE         — each document = one chunk. Use only for short, atomic documents.
```

---

## Section 3: Amazon Bedrock Agents

### 3.1 Create an Agent

```python
import boto3

bedrock_agent = boto3.client("bedrock-agent", region_name="us-east-1")

def create_agent(name: str, role_arn: str, model_id: str) -> dict:
    """Create a Bedrock Agent with a system instruction."""
    response = bedrock_agent.create_agent(
        agentName=name,
        agentResourceRoleArn=role_arn,
        foundationModel=model_id,
        instruction=(
            "You are an order management assistant. "
            "Help users check order status, process returns, and answer product questions. "
            "Always confirm the order ID before taking any action."
        ),
        idleSessionTTLInSeconds=600,
    )
    agent = response["agent"]
    print(f"Agent created: {agent['agentId']} — status: {agent['agentStatus']}")
    return agent

# EXAM NOTE: After creating an agent you must call prepare_agent() before invoking it.
# The agent uses ReAct (Reasoning + Acting) to decide which tools to call.
# foundationModel accepts shorthand IDs like "anthropic.claude-3-sonnet-20240229-v1:0".
```

### 3.2 Create an Action Group with Lambda Function

```python
def create_action_group(
    agent_id: str,
    agent_version: str,
    lambda_arn: str,
) -> dict:
    """
    Attach an action group to an agent.
    The API schema tells the agent what actions are available.
    """
    api_schema = {
        "openapi": "3.0.0",
        "info": {"title": "Order API", "version": "1.0.0"},
        "paths": {
            "/orders/{orderId}": {
                "get": {
                    "summary": "Get order status",
                    "operationId": "getOrderStatus",
                    "parameters": [
                        {
                            "name": "orderId",
                            "in": "path",
                            "required": True,
                            "schema": {"type": "string"},
                            "description": "The unique order identifier",
                        }
                    ],
                    "responses": {"200": {"description": "Order details"}},
                }
            },
            "/orders/{orderId}/return": {
                "post": {
                    "summary": "Process a return",
                    "operationId": "processReturn",
                    "parameters": [
                        {
                            "name": "orderId",
                            "in": "path",
                            "required": True,
                            "schema": {"type": "string"},
                        }
                    ],
                    "requestBody": {
                        "content": {
                            "application/json": {
                                "schema": {
                                    "type": "object",
                                    "properties": {
                                        "reason": {"type": "string"},
                                    },
                                }
                            }
                        }
                    },
                    "responses": {"200": {"description": "Return confirmation"}},
                }
            },
        },
    }

    import json

    response = bedrock_agent.create_agent_action_group(
        agentId=agent_id,
        agentVersion=agent_version,
        actionGroupName="OrderManagement",
        actionGroupExecutor={"lambda": lambda_arn},
        apiSchema={"payload": json.dumps(api_schema)},
        description="Manage customer orders — lookup and returns",
    )
    print(f"Action group created: {response['agentActionGroup']['actionGroupId']}")
    return response["agentActionGroup"]

# EXAM NOTE: Action groups connect agents to external tools via Lambda.
# The OpenAPI schema is how the agent understands available actions and parameters.
# After adding/modifying action groups, call prepare_agent() again.
# Lambda receives: apiPath, httpMethod, parameters, requestBody.
```

### 3.3 Associate a Knowledge Base with an Agent

```python
def associate_kb_with_agent(agent_id: str, agent_version: str, kb_id: str) -> dict:
    """Let the agent query a knowledge base as part of its reasoning."""
    response = bedrock_agent.associate_agent_knowledge_base(
        agentId=agent_id,
        agentVersion=agent_version,
        knowledgeBaseId=kb_id,
        description="Product catalog and FAQ documentation",
        knowledgeBaseState="ENABLED",
    )
    print(f"KB {kb_id} associated with agent {agent_id}")

    bedrock_agent.prepare_agent(agentId=agent_id)
    print("Agent prepared — ready for invocation")
    return response

# EXAM NOTE: The agent decides autonomously whether to query the KB
# based on the user's question and the KB description you provide.
# A good description helps the agent route queries correctly.
```

### 3.4 Invoke an Agent

```python
import uuid

bedrock_agent_runtime = boto3.client("bedrock-agent-runtime", region_name="us-east-1")

def invoke_agent(agent_id: str, agent_alias_id: str, prompt: str) -> str:
    """Invoke a prepared agent and collect the full response."""
    response = bedrock_agent_runtime.invoke_agent(
        agentId=agent_id,
        agentAliasId=agent_alias_id,
        sessionId=str(uuid.uuid4()),
        inputText=prompt,
    )

    full_response = ""
    for event in response["completion"]:
        if "chunk" in event:
            full_response += event["chunk"]["bytes"].decode("utf-8")

    print(f"Agent response: {full_response[:500]}")
    return full_response

# EXAM NOTE: agentAliasId is required — create an alias pointing to a version.
# Use "TSTALIASID" for the automatically-created test alias during development.
# sessionId enables multi-turn conversations; reuse the same ID.
# The response is streamed via EventStream.
```

### 3.5 Create a Multi-Agent Orchestration

```python
def create_supervisor_agent(
    name: str,
    role_arn: str,
    sub_agent_ids: list[dict],
) -> dict:
    """
    Create a supervisor agent that delegates to specialized sub-agents.
    Requires the multi-agent collaboration feature.
    """
    response = bedrock_agent.create_agent(
        agentName=name,
        agentResourceRoleArn=role_arn,
        foundationModel="anthropic.claude-3-sonnet-20240229-v1:0",
        instruction=(
            "You are a supervisor agent. Route customer queries to the appropriate "
            "specialist agent: OrderAgent for order issues, ProductAgent for product "
            "questions, BillingAgent for payment and billing concerns."
        ),
        agentCollaboration="SUPERVISOR",
    )
    agent_id = response["agent"]["agentId"]

    for sub in sub_agent_ids:
        bedrock_agent.associate_agent_collaborator(
            agentId=agent_id,
            agentVersion="DRAFT",
            agentDescriptor={"aliasArn": sub["alias_arn"]},
            collaborationInstruction=sub["instruction"],
            collaboratorName=sub["name"],
            relayConversationHistory="TO_COLLABORATOR",
        )

    bedrock_agent.prepare_agent(agentId=agent_id)
    return response["agent"]

# EXAM NOTE: Multi-agent collaboration supports SUPERVISOR and SUPERVISOR_ROUTER modes.
# SUPERVISOR   — the supervisor reasons about which sub-agent to call.
# SUPERVISOR_ROUTER — faster, classifier-based routing without full reasoning.
# relayConversationHistory controls whether chat context flows to sub-agents.
```

---

## Section 4: Amazon Bedrock Guardrails

### 4.1 Create a Guardrail with Content Filters

```python
import boto3

bedrock = boto3.client("bedrock", region_name="us-east-1")

def create_content_filter_guardrail() -> dict:
    """Create a guardrail with content-level filtering for harmful categories."""
    response = bedrock.create_guardrail(
        name="content-safety-guardrail",
        description="Block harmful content across all categories",
        blockedInputMessaging="Your request contains content that violates our policy.",
        blockedOutputsMessaging="The response was filtered due to content policy.",
        contentPolicyConfig={
            "filtersConfig": [
                {"type": "SEXUAL",     "inputStrength": "HIGH", "outputStrength": "HIGH"},
                {"type": "VIOLENCE",   "inputStrength": "HIGH", "outputStrength": "HIGH"},
                {"type": "HATE",       "inputStrength": "HIGH", "outputStrength": "HIGH"},
                {"type": "INSULTS",    "inputStrength": "MEDIUM", "outputStrength": "HIGH"},
                {"type": "MISCONDUCT", "inputStrength": "HIGH", "outputStrength": "HIGH"},
                {"type": "PROMPT_ATTACK", "inputStrength": "HIGH", "outputStrength": "NONE"},
            ]
        },
    )
    print(f"Guardrail created: {response['guardrailId']} v{response['version']}")
    return response

# EXAM NOTE: PROMPT_ATTACK filters jailbreak attempts — only applies to INPUT.
# Strength levels: NONE, LOW, MEDIUM, HIGH.
# Higher strength = more aggressive filtering (more false positives).
# After creating, call create_guardrail_version() for production use.
```

### 4.2 Create a Guardrail with Denied Topics

```python
def create_topic_guardrail() -> dict:
    """Block specific topics the model should never discuss."""
    response = bedrock.create_guardrail(
        name="topic-guardrail",
        description="Prevent discussion of competitors and investment advice",
        blockedInputMessaging="This topic is outside my scope.",
        blockedOutputsMessaging="I cannot provide information on that topic.",
        topicPolicyConfig={
            "topicsConfig": [
                {
                    "name": "CompetitorDiscussion",
                    "definition": "Any discussion comparing our products to competitor products or recommending competitor solutions",
                    "examples": [
                        "How does your product compare to Google Cloud?",
                        "Should I use Azure instead?",
                    ],
                    "type": "DENY",
                },
                {
                    "name": "InvestmentAdvice",
                    "definition": "Providing specific investment recommendations, stock picks, or financial planning advice",
                    "examples": [
                        "Should I buy AWS stock?",
                        "What stocks should I invest in?",
                    ],
                    "type": "DENY",
                },
            ]
        },
    )
    return response

# EXAM NOTE: Topic filters use an LLM classifier — they understand semantic meaning,
# not just keyword matching. Provide clear definitions and 2+ examples per topic.
```

### 4.3 Create a Guardrail with PII Filters

```python
def create_pii_guardrail() -> dict:
    """Filter or mask personally identifiable information."""
    response = bedrock.create_guardrail(
        name="pii-protection-guardrail",
        description="Detect and mask PII in inputs and outputs",
        blockedInputMessaging="Please do not include personal information.",
        blockedOutputsMessaging="Response contained PII and was filtered.",
        sensitiveInformationPolicyConfig={
            "piiEntitiesConfig": [
                {"type": "EMAIL",              "action": "ANONYMIZE"},
                {"type": "PHONE",              "action": "ANONYMIZE"},
                {"type": "US_SOCIAL_SECURITY_NUMBER", "action": "BLOCK"},
                {"type": "CREDIT_DEBIT_CARD_NUMBER",  "action": "BLOCK"},
                {"type": "NAME",               "action": "ANONYMIZE"},
                {"type": "ADDRESS",            "action": "ANONYMIZE"},
            ],
            "regexesConfig": [
                {
                    "name": "InternalAccountId",
                    "description": "Internal account identifiers",
                    "pattern": r"ACCT-\d{8,12}",
                    "action": "ANONYMIZE",
                }
            ],
        },
    )
    return response

# EXAM NOTE: ANONYMIZE replaces PII with a placeholder (e.g. {EMAIL}).
# BLOCK stops the entire request/response.
# regexesConfig lets you define custom PII patterns beyond the built-in types.
# PII detection is powered by Amazon Comprehend under the hood.
```

### 4.4 Create a Guardrail with Word Filters

```python
def create_word_filter_guardrail() -> dict:
    """Block specific words and phrases — exact match and profanity."""
    response = bedrock.create_guardrail(
        name="word-filter-guardrail",
        description="Block profanity and competitor brand names",
        blockedInputMessaging="Please rephrase your request.",
        blockedOutputsMessaging="Response was filtered.",
        wordPolicyConfig={
            "wordsConfig": [
                {"text": "CompetitorBrandX"},
                {"text": "internal-codename-project-z"},
            ],
            "managedWordListsConfig": [
                {"type": "PROFANITY"},
            ],
        },
    )
    return response

# EXAM NOTE: Word filters are exact (case-insensitive) string matches.
# PROFANITY uses a managed word list — you don't need to enumerate bad words.
# Use word filters for brand protection and internal term leakage prevention.
```

### 4.5 Apply Guardrail to Model Invocation

```python
def invoke_with_guardrail(
    prompt: str,
    guardrail_id: str,
    guardrail_version: str = "DRAFT",
) -> str:
    """Invoke a model with a guardrail applied via the Converse API."""
    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        guardrailConfig={
            "guardrailIdentifier": guardrail_id,
            "guardrailVersion": guardrail_version,
            "trace": "enabled",
        },
        inferenceConfig={"maxTokens": 512},
    )

    stop_reason = response["stopReason"]
    if stop_reason == "guardrail_intervened":
        print("GUARDRAIL BLOCKED the response")
        trace = response.get("trace", {}).get("guardrail", {})
        print(f"  Trace: {trace}")
    else:
        print(f"Response: {response['output']['message']['content'][0]['text'][:300]}")

    return response

# EXAM NOTE: stopReason == "guardrail_intervened" means the guardrail blocked.
# Enable trace to debug which filter triggered.
# Guardrails can also be applied to RetrieveAndGenerate and Agent invocations.
# Use guardrailVersion "DRAFT" for testing, numbered versions for production.
```

### 4.6 Test Guardrail with ApplyGuardrail API

```python
def test_guardrail(guardrail_id: str, text: str) -> dict:
    """Test a guardrail independently — without invoking a model."""
    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

    response = bedrock_runtime.apply_guardrail(
        guardrailIdentifier=guardrail_id,
        guardrailVersion="DRAFT",
        source="INPUT",
        content=[{"text": {"text": text}}],
    )

    print(f"Action: {response['action']}")  # GUARDRAIL_INTERVENED or NONE
    for assessment in response.get("assessments", []):
        print(f"  Topic policy: {assessment.get('topicPolicy', {})}")
        print(f"  Content policy: {assessment.get('contentPolicy', {})}")
        print(f"  Word policy: {assessment.get('wordPolicy', {})}")
        print(f"  Sensitive info: {assessment.get('sensitiveInformationPolicy', {})}")
    return response

# EXAM NOTE: ApplyGuardrail is useful for:
#   - Pre-screening user input before sending to a model
#   - Testing guardrail configurations without consuming model tokens
#   - Applying guardrails to non-Bedrock models (e.g., SageMaker endpoints)
# source must be "INPUT" or "OUTPUT".
```

---

## Section 5: Amazon Bedrock Prompt Management

### 5.1 Create a Prompt Template

```python
import boto3

bedrock_agent = boto3.client("bedrock-agent", region_name="us-east-1")

def create_prompt(name: str) -> dict:
    """Create a managed prompt template in Bedrock."""
    response = bedrock_agent.create_prompt(
        name=name,
        description="Summarization prompt for support tickets",
        defaultVariant="v1",
        variants=[
            {
                "name": "v1",
                "modelId": "anthropic.claude-3-sonnet-20240229-v1:0",
                "templateType": "TEXT",
                "templateConfiguration": {
                    "text": {
                        "text": (
                            "Summarize the following support ticket in 3 bullet points.\n"
                            "Ticket category: {{category}}\n"
                            "Ticket content:\n{{ticket_text}}\n\n"
                            "Summary:"
                        ),
                        "inputVariables": [
                            {"name": "category"},
                            {"name": "ticket_text"},
                        ],
                    }
                },
                "inferenceConfiguration": {
                    "text": {
                        "maxTokens": 256,
                        "temperature": 0.2,
                    }
                },
            }
        ],
    )
    print(f"Prompt created: {response['id']}")
    return response

# EXAM NOTE: Prompt Management separates prompt engineering from application code.
# Variables use {{variable_name}} syntax.
# Variants let you A/B test different prompts or models.
```

### 5.2 Create Prompt Versions

```python
def create_prompt_version(prompt_id: str) -> dict:
    """Create an immutable version of a prompt for production use."""
    response = bedrock_agent.create_prompt_version(
        promptIdentifier=prompt_id,
        description="Production-ready v1 after testing",
    )
    print(f"Version created: {response['version']}")
    return response

# EXAM NOTE: Versions are immutable snapshots. DRAFT is always mutable.
# Use versioned prompts in production, DRAFT for development.
# Prompt Flows reference specific prompt versions.
```

### 5.3 Use Parameterized Prompts

```python
def invoke_managed_prompt(prompt_arn: str, variables: dict) -> str:
    """Invoke a model using a managed prompt template with variables filled in."""
    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        promptVariables={k: {"text": v} for k, v in variables.items()},
        messages=[],
        additionalModelRequestFields={
            "promptArn": prompt_arn,
        },
    )
    return response["output"]["message"]["content"][0]["text"]

# Alternative: Resolve the prompt client-side
def resolve_and_invoke(prompt_id: str, version: str, variables: dict) -> str:
    """Fetch prompt template, fill variables, then invoke."""
    prompt_resp = bedrock_agent.get_prompt(
        promptIdentifier=prompt_id,
        promptVersion=version,
    )
    template = prompt_resp["variants"][0]["templateConfiguration"]["text"]["text"]
    for key, value in variables.items():
        template = template.replace(f"{{{{{key}}}}}", value)

    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")
    response = bedrock_runtime.converse(
        modelId=prompt_resp["variants"][0]["modelId"],
        messages=[{"role": "user", "content": [{"text": template}]}],
    )
    return response["output"]["message"]["content"][0]["text"]
```

---

## Section 6: Vector Store Operations

### 6.1 OpenSearch Service — Create Vector Index

```python
from opensearchpy import OpenSearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
import boto3

def create_opensearch_vector_index(host: str, region: str = "us-east-1"):
    """Create an OpenSearch index with k-NN vector field for semantic search."""
    credentials = boto3.Session().get_credentials()
    awsauth = AWS4Auth(
        credentials.access_key,
        credentials.secret_key,
        region,
        "es",
        session_token=credentials.token,
    )

    client = OpenSearch(
        hosts=[{"host": host, "port": 443}],
        http_auth=awsauth,
        use_ssl=True,
        connection_class=RequestsHttpConnection,
    )

    index_body = {
        "settings": {
            "index": {
                "knn": True,
                "knn.algo_param.ef_search": 512,
            }
        },
        "mappings": {
            "properties": {
                "embedding": {
                    "type": "knn_vector",
                    "dimension": 1024,  # Titan Embed v2 dimension
                    "method": {
                        "engine": "faiss",
                        "name": "hnsw",
                        "space_type": "l2",
                        "parameters": {
                            "ef_construction": 512,
                            "m": 16,
                        },
                    },
                },
                "text": {"type": "text"},
                "metadata": {"type": "object", "enabled": True},
            }
        },
    }

    response = client.indices.create(index="documents", body=index_body)
    print(f"Index created: {response}")
    return client

# EXAM NOTE: k-NN plugin supports FAISS and NMSLIB engines.
# space_type: l2 (Euclidean), cosinesimil (cosine), innerproduct (dot product).
# HNSW is the recommended algorithm for most use cases (good recall vs speed tradeoff).
# dimension must match your embedding model (Titan v2 = 1024, Titan v1 = 1536).
```

### 6.2 OpenSearch Service — Index Documents with Embeddings

```python
def index_documents(client: OpenSearch, documents: list[dict]):
    """Generate embeddings and index documents into OpenSearch."""
    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")
    import json

    for doc in documents:
        embedding_resp = bedrock_runtime.invoke_model(
            modelId="amazon.titan-embed-text-v2:0",
            contentType="application/json",
            accept="application/json",
            body=json.dumps({
                "inputText": doc["text"],
                "dimensions": 1024,
                "normalize": True,
            }),
        )
        embedding = json.loads(embedding_resp["body"].read())["embedding"]

        client.index(
            index="documents",
            body={
                "text": doc["text"],
                "embedding": embedding,
                "metadata": doc.get("metadata", {}),
            },
        )

    client.indices.refresh(index="documents")
    print(f"Indexed {len(documents)} documents")

# EXAM NOTE: Titan Embed Text v2 supports configurable dimensions (256, 512, 1024).
# normalize=True outputs unit vectors — required for cosine similarity.
# Batch embedding is more efficient; process documents in chunks of 25-50.
```

### 6.3 OpenSearch Service — Semantic Search

```python
import json

def semantic_search(client: OpenSearch, query: str, k: int = 5) -> list:
    """Perform k-NN vector search in OpenSearch."""
    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

    query_embedding_resp = bedrock_runtime.invoke_model(
        modelId="amazon.titan-embed-text-v2:0",
        contentType="application/json",
        accept="application/json",
        body=json.dumps({
            "inputText": query,
            "dimensions": 1024,
            "normalize": True,
        }),
    )
    query_vector = json.loads(query_embedding_resp["body"].read())["embedding"]

    search_body = {
        "size": k,
        "_source": ["text", "metadata"],
        "query": {
            "knn": {
                "embedding": {
                    "vector": query_vector,
                    "k": k,
                }
            }
        },
    }

    response = client.search(index="documents", body=search_body)
    results = []
    for hit in response["hits"]["hits"]:
        results.append({
            "text": hit["_source"]["text"],
            "score": hit["_score"],
            "metadata": hit["_source"].get("metadata", {}),
        })
    return results
```

### 6.4 Aurora pgvector — Create Table and Index

```python
import psycopg2

def setup_pgvector(host: str, dbname: str, user: str, password: str):
    """Set up Aurora PostgreSQL with pgvector extension for vector storage."""
    conn = psycopg2.connect(host=host, dbname=dbname, user=user, password=password)
    conn.autocommit = True
    cur = conn.cursor()

    cur.execute("CREATE EXTENSION IF NOT EXISTS vector;")

    cur.execute("""
        CREATE TABLE IF NOT EXISTS documents (
            id          SERIAL PRIMARY KEY,
            content     TEXT NOT NULL,
            embedding   vector(1024),
            metadata    JSONB DEFAULT '{}'::jsonb,
            created_at  TIMESTAMP DEFAULT NOW()
        );
    """)

    # IVFFlat index for approximate nearest neighbor search
    cur.execute("""
        CREATE INDEX IF NOT EXISTS documents_embedding_idx
        ON documents
        USING ivfflat (embedding vector_cosine_ops)
        WITH (lists = 100);
    """)

    # HNSW index (better recall, higher memory)
    cur.execute("""
        CREATE INDEX IF NOT EXISTS documents_embedding_hnsw_idx
        ON documents
        USING hnsw (embedding vector_cosine_ops)
        WITH (m = 16, ef_construction = 256);
    """)

    print("pgvector table and indexes created")
    cur.close()
    conn.close()

# EXAM NOTE: pgvector supports two index types:
#   IVFFlat — faster build, lower memory, good for large datasets. Requires lists tuning.
#   HNSW   — better recall, more memory, good default choice.
# Operators: vector_cosine_ops (cosine), vector_l2_ops (L2), vector_ip_ops (inner product).
# Aurora PostgreSQL 15.4+ supports pgvector natively.
```

### 6.5 Generate Embeddings Using Amazon Titan

```python
import boto3
import json

bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

def generate_embedding(text: str, dimensions: int = 1024) -> list[float]:
    """Generate a text embedding using Amazon Titan Embed V2."""
    response = bedrock_runtime.invoke_model(
        modelId="amazon.titan-embed-text-v2:0",
        contentType="application/json",
        accept="application/json",
        body=json.dumps({
            "inputText": text,
            "dimensions": dimensions,
            "normalize": True,
        }),
    )
    result = json.loads(response["body"].read())
    return result["embedding"]

def generate_embeddings_batch(texts: list[str], dimensions: int = 1024) -> list:
    """Generate embeddings for a batch of texts."""
    return [generate_embedding(text, dimensions) for text in texts]

# EXAM NOTE: Amazon Titan Embed V2 supports:
#   - Text input up to 8,192 tokens
#   - Configurable output dimensions: 256, 512, 1024
#   - Smaller dimensions = faster search, lower cost, slightly less accuracy
#   - normalize=True is recommended for cosine similarity
# Titan Embed V1 always outputs 1536 dimensions (not configurable).
# Cohere Embed is the other Bedrock embedding model — supports search_document
# and search_query input types.
```

### 6.6 Hybrid Search Implementation

```python
def hybrid_search(client: OpenSearch, query: str, k: int = 5) -> list:
    """Combine keyword (BM25) and vector search for better retrieval."""
    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

    query_embedding_resp = bedrock_runtime.invoke_model(
        modelId="amazon.titan-embed-text-v2:0",
        contentType="application/json",
        accept="application/json",
        body=json.dumps({"inputText": query, "dimensions": 1024, "normalize": True}),
    )
    query_vector = json.loads(query_embedding_resp["body"].read())["embedding"]

    search_body = {
        "size": k,
        "_source": ["text", "metadata"],
        "query": {
            "hybrid": {
                "queries": [
                    {"match": {"text": {"query": query}}},
                    {"knn": {"embedding": {"vector": query_vector, "k": k}}},
                ]
            }
        },
        "search_pipeline": "hybrid-search-pipeline",
    }

    response = client.search(index="documents", body=search_body)
    return [
        {"text": h["_source"]["text"], "score": h["_score"]}
        for h in response["hits"]["hits"]
    ]

# Pre-requisite: create the search pipeline
def create_hybrid_pipeline(client: OpenSearch):
    """Set up normalization pipeline for hybrid search score fusion."""
    pipeline_body = {
        "description": "Hybrid search with score normalization",
        "phase_results_processors": [
            {
                "normalization-processor": {
                    "normalization": {"technique": "min_max"},
                    "combination": {
                        "technique": "arithmetic_mean",
                        "parameters": {"weights": [0.3, 0.7]},
                    },
                }
            }
        ],
    }
    client.transport.perform_request(
        "PUT", "/_search/pipeline/hybrid-search-pipeline", body=pipeline_body
    )

# EXAM NOTE: Hybrid search = BM25 (keyword) + k-NN (semantic).
# Score normalization is required because BM25 and k-NN scores are on different scales.
# Weights control the balance: higher vector weight favors semantic relevance.
# This is what Bedrock Knowledge Bases uses internally when overrideSearchType="HYBRID".
```

---

## Section 7: RAG Implementation

### 7.1 Complete RAG Pipeline (Embed → Search → Generate)

```python
import boto3
import json

bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

def rag_pipeline(query: str, opensearch_client, index: str = "documents") -> str:
    """Full custom RAG pipeline: embed query → retrieve → generate answer."""

    # Step 1: Embed the query
    embed_resp = bedrock_runtime.invoke_model(
        modelId="amazon.titan-embed-text-v2:0",
        contentType="application/json",
        accept="application/json",
        body=json.dumps({"inputText": query, "dimensions": 1024, "normalize": True}),
    )
    query_vector = json.loads(embed_resp["body"].read())["embedding"]

    # Step 2: Retrieve relevant chunks
    search_resp = opensearch_client.search(
        index=index,
        body={
            "size": 5,
            "_source": ["text", "metadata"],
            "query": {"knn": {"embedding": {"vector": query_vector, "k": 5}}},
        },
    )
    chunks = [hit["_source"]["text"] for hit in search_resp["hits"]["hits"]]

    if not chunks:
        return "No relevant documents found."

    # Step 3: Build augmented prompt
    context = "\n\n---\n\n".join(chunks)
    augmented_prompt = (
        f"Answer the question based on the following context.\n\n"
        f"Context:\n{context}\n\n"
        f"Question: {query}\n\n"
        f"If the context does not contain the answer, say 'I don't have enough "
        f"information to answer that question.' Do not make up information."
    )

    # Step 4: Generate answer
    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": augmented_prompt}]}],
        inferenceConfig={"maxTokens": 1024, "temperature": 0.1},
    )
    return response["output"]["message"]["content"][0]["text"]

# EXAM NOTE: Custom RAG gives you full control over each stage.
# Key tuning points: chunk size, top-k, prompt template, temperature.
# Temperature 0.1-0.3 is recommended for factual RAG to reduce hallucination.
```

### 7.2 Document Chunking Strategies

```python
def fixed_size_chunking(text: str, chunk_size: int = 500, overlap: int = 100) -> list[str]:
    """Split text into fixed-size chunks with overlap."""
    words = text.split()
    chunks = []
    start = 0
    while start < len(words):
        end = start + chunk_size
        chunk = " ".join(words[start:end])
        chunks.append(chunk)
        start += chunk_size - overlap
    return chunks


def hierarchical_chunking(text: str) -> dict:
    """Create parent-child chunk hierarchy for multi-level retrieval."""
    paragraphs = text.split("\n\n")
    parent_chunk_size = 5
    hierarchy = []

    for i in range(0, len(paragraphs), parent_chunk_size):
        parent_text = "\n\n".join(paragraphs[i : i + parent_chunk_size])
        children = [p.strip() for p in paragraphs[i : i + parent_chunk_size] if p.strip()]
        hierarchy.append({
            "parent": parent_text,
            "children": children,
            "parent_id": f"parent_{i // parent_chunk_size}",
        })
    return hierarchy


def semantic_chunking(text: str, threshold: float = 0.5) -> list[str]:
    """
    Split by semantic similarity between consecutive sentences.
    When similarity drops below threshold, start a new chunk.
    """
    import re
    sentences = re.split(r'(?<=[.!?])\s+', text)
    if len(sentences) <= 1:
        return [text]

    embeddings = generate_embeddings_batch(sentences, dimensions=256)

    chunks = []
    current_chunk = [sentences[0]]

    for i in range(1, len(sentences)):
        similarity = cosine_similarity(embeddings[i - 1], embeddings[i])
        if similarity < threshold:
            chunks.append(" ".join(current_chunk))
            current_chunk = [sentences[i]]
        else:
            current_chunk.append(sentences[i])

    if current_chunk:
        chunks.append(" ".join(current_chunk))
    return chunks


def cosine_similarity(a: list[float], b: list[float]) -> float:
    dot = sum(x * y for x, y in zip(a, b))
    norm_a = sum(x * x for x in a) ** 0.5
    norm_b = sum(x * x for x in b) ** 0.5
    return dot / (norm_a * norm_b) if norm_a and norm_b else 0.0

# EXAM NOTE:
# Fixed-size   — simplest, works well for uniform documents.
# Hierarchical — retrieve child for precision, return parent for context window.
# Semantic     — highest quality but slowest; needs embedding calls per sentence.
# Bedrock KB supports all three via vectorIngestionConfiguration.
```

### 7.3 Query Expansion for Better Retrieval

```python
def expand_query(original_query: str) -> list[str]:
    """Use an LLM to generate multiple search queries from one question."""
    prompt = (
        f"Generate 3 alternative search queries for the following question. "
        f"Each query should capture a different aspect or use different terminology.\n\n"
        f"Original question: {original_query}\n\n"
        f"Return only the queries, one per line."
    )

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-haiku-20240307-v1:0",
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 200, "temperature": 0.7},
    )
    expanded = response["output"]["message"]["content"][0]["text"].strip().split("\n")
    return [original_query] + [q.strip().lstrip("0123456789.-) ") for q in expanded if q.strip()]

# EXAM NOTE: Query expansion improves recall by covering different phrasings.
# Use a fast/cheap model (Haiku) for query expansion, then a stronger model for generation.
# Also called "multi-query retrieval" or "HyDE" (Hypothetical Document Embedding).
```

### 7.4 Reranking Retrieved Documents

```python
def rerank_with_llm(query: str, documents: list[str], top_n: int = 3) -> list[str]:
    """Use an LLM to rerank retrieved documents by relevance."""
    doc_list = "\n".join(f"[{i}] {doc[:500]}" for i, doc in enumerate(documents))
    prompt = (
        f"Given the query and documents below, return the indices of the top {top_n} "
        f"most relevant documents in order of relevance. Return only the indices as "
        f"a comma-separated list.\n\n"
        f"Query: {query}\n\nDocuments:\n{doc_list}"
    )

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-haiku-20240307-v1:0",
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 50, "temperature": 0.0},
    )
    indices_str = response["output"]["message"]["content"][0]["text"].strip()
    try:
        indices = [int(i.strip()) for i in indices_str.split(",")]
        return [documents[i] for i in indices if i < len(documents)]
    except (ValueError, IndexError):
        return documents[:top_n]

# EXAM NOTE: Reranking is a two-stage retrieval pattern:
#   Stage 1: Fast retrieval (vector search) — high recall, lower precision
#   Stage 2: Reranking — reorder by true relevance, higher precision
# Reranking is especially helpful when top-k is large (retrieve 20, rerank to 5).
```

---

## Section 8: Prompt Engineering

### 8.1 Zero-Shot Prompting

```python
def zero_shot_classify(text: str) -> str:
    """Classify text with no examples — relies on model's pre-trained knowledge."""
    prompt = (
        "Classify the following customer review as POSITIVE, NEGATIVE, or NEUTRAL. "
        "Respond with only the classification label.\n\n"
        f"Review: {text}\n\nClassification:"
    )
    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 10, "temperature": 0.0},
    )
    return response["output"]["message"]["content"][0]["text"].strip()

# EXAM NOTE: Zero-shot works best with capable models and clear instructions.
# Setting temperature=0.0 makes output deterministic for classification tasks.
```

### 8.2 Few-Shot Prompting

```python
def few_shot_entity_extraction(text: str) -> str:
    """Extract entities using few-shot examples to guide the model."""
    prompt = """Extract product names and prices from the text. Return JSON.

Example 1:
Text: "The new iPhone 15 Pro costs $999 and the AirPods Pro are $249."
Output: [{"product": "iPhone 15 Pro", "price": "$999"}, {"product": "AirPods Pro", "price": "$249"}]

Example 2:
Text: "We ordered 10 Dell monitors at $350 each."
Output: [{"product": "Dell monitors", "price": "$350"}]

Example 3:
Text: "The software license is free but support costs $500/year."
Output: [{"product": "software license", "price": "free"}, {"product": "support", "price": "$500/year"}]

Now extract from this text:
Text: "{text}"
Output:"""

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 256, "temperature": 0.0},
    )
    return response["output"]["message"]["content"][0]["text"].strip()

# EXAM NOTE: Few-shot prompting provides examples to demonstrate the desired format.
# 3-5 examples is the sweet spot. More examples = better accuracy, but higher token cost.
# Examples should cover edge cases (free items, ranges, etc.).
```

### 8.3 Chain-of-Thought Prompting

```python
def chain_of_thought(question: str) -> str:
    """Improve reasoning accuracy by asking the model to think step-by-step."""
    prompt = (
        f"{question}\n\n"
        "Let's think through this step by step:\n"
        "1. First, identify the key information.\n"
        "2. Then, apply the relevant logic.\n"
        "3. Finally, state the answer.\n"
    )
    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 1024, "temperature": 0.2},
    )
    return response["output"]["message"]["content"][0]["text"]

# EXAM NOTE: Chain-of-thought significantly improves math, logic, and multi-step
# reasoning tasks. Variants include:
#   - "Think step by step" (basic CoT)
#   - Numbered steps (structured CoT)
#   - "Show your work" (detailed CoT)
# CoT increases output tokens but improves accuracy on complex tasks.
```

### 8.4 System Prompt with Role Definition

```python
def role_based_conversation(user_message: str) -> str:
    """Use system prompts to define the assistant's persona and constraints."""
    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        system=[
            {
                "text": (
                    "You are a senior AWS solutions architect with 15 years of experience. "
                    "You specialize in serverless architectures and cost optimization.\n\n"
                    "Guidelines:\n"
                    "- Always recommend Well-Architected Framework best practices\n"
                    "- Provide specific AWS service recommendations with justification\n"
                    "- Include estimated costs when relevant\n"
                    "- If you're unsure about pricing, say so rather than guessing\n"
                    "- Format responses with clear headings and bullet points"
                )
            }
        ],
        messages=[{"role": "user", "content": [{"text": user_message}]}],
        inferenceConfig={"maxTokens": 1024, "temperature": 0.3},
    )
    return response["output"]["message"]["content"][0]["text"]

# EXAM NOTE: System prompts set the model's behavior for the entire conversation.
# They're processed once and apply to all turns.
# Best practices: be specific, include constraints, define output format.
# In the Converse API, system prompts are a top-level parameter (not in messages).
```

### 8.5 Structured Output with JSON Schema

```python
def structured_output(text: str) -> dict:
    """Force the model to return structured JSON matching a schema."""
    prompt = (
        "Analyze the following text and extract structured information.\n\n"
        f"Text: {text}\n\n"
        "Return a JSON object matching this exact schema:\n"
        "{\n"
        '  "sentiment": "positive" | "negative" | "neutral",\n'
        '  "confidence": 0.0-1.0,\n'
        '  "topics": ["string"],\n'
        '  "entities": [{"name": "string", "type": "PERSON|ORG|PRODUCT"}],\n'
        '  "summary": "one sentence summary"\n'
        "}\n\n"
        "Return ONLY valid JSON, no other text."
    )
    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 512, "temperature": 0.0},
    )
    import json
    raw = response["output"]["message"]["content"][0]["text"]
    raw = raw.strip().removeprefix("```json").removesuffix("```").strip()
    return json.loads(raw)

# EXAM NOTE: For reliable structured output:
#   - Set temperature=0 for deterministic output
#   - Provide an explicit JSON schema
#   - Say "Return ONLY valid JSON" to avoid markdown wrapping
#   - Some models support response_format: {"type": "json_object"} natively
```

### 8.6 Prompt Chaining with Bedrock Prompt Flows

```python
def create_prompt_flow(name: str, role_arn: str) -> dict:
    """Create a Prompt Flow that chains multiple steps together."""
    flow_definition = {
        "nodes": [
            {
                "name": "Input",
                "type": "Input",
                "configuration": {"input": {}},
                "outputs": [
                    {"name": "document", "type": "String"},
                ],
            },
            {
                "name": "Summarize",
                "type": "Prompt",
                "configuration": {
                    "prompt": {
                        "sourceConfiguration": {
                            "inline": {
                                "modelId": "anthropic.claude-3-haiku-20240307-v1:0",
                                "templateType": "TEXT",
                                "templateConfiguration": {
                                    "text": {
                                        "text": "Summarize: {{document}}",
                                        "inputVariables": [{"name": "document"}],
                                    }
                                },
                                "inferenceConfiguration": {
                                    "text": {"maxTokens": 256, "temperature": 0.2}
                                },
                            }
                        }
                    }
                },
                "inputs": [
                    {"name": "document", "type": "String", "expression": "$.data"},
                ],
                "outputs": [{"name": "modelCompletion", "type": "String"}],
            },
            {
                "name": "ExtractKeyPoints",
                "type": "Prompt",
                "configuration": {
                    "prompt": {
                        "sourceConfiguration": {
                            "inline": {
                                "modelId": "anthropic.claude-3-haiku-20240307-v1:0",
                                "templateType": "TEXT",
                                "templateConfiguration": {
                                    "text": {
                                        "text": "Extract key points as bullet list: {{summary}}",
                                        "inputVariables": [{"name": "summary"}],
                                    }
                                },
                                "inferenceConfiguration": {
                                    "text": {"maxTokens": 256, "temperature": 0.2}
                                },
                            }
                        }
                    }
                },
                "inputs": [
                    {"name": "summary", "type": "String", "expression": "$.data"},
                ],
                "outputs": [{"name": "modelCompletion", "type": "String"}],
            },
            {
                "name": "Output",
                "type": "Output",
                "configuration": {"output": {}},
                "inputs": [
                    {"name": "document", "type": "String", "expression": "$.data"},
                ],
            },
        ],
        "connections": [
            {"name": "c1", "source": "Input",            "target": "Summarize",        "configuration": {"data": {"sourceOutput": "document", "targetInput": "document"}}},
            {"name": "c2", "source": "Summarize",         "target": "ExtractKeyPoints", "configuration": {"data": {"sourceOutput": "modelCompletion", "targetInput": "summary"}}},
            {"name": "c3", "source": "ExtractKeyPoints",  "target": "Output",           "configuration": {"data": {"sourceOutput": "modelCompletion", "targetInput": "document"}}},
        ],
    }

    bedrock_agent = boto3.client("bedrock-agent", region_name="us-east-1")
    response = bedrock_agent.create_flow(
        name=name,
        executionRoleArn=role_arn,
        definition=flow_definition,
    )
    print(f"Flow created: {response['id']}")
    return response

# EXAM NOTE: Prompt Flows enable visual prompt chaining without code.
# Node types: Input, Output, Prompt, KnowledgeBase, Condition, Lambda, Iterator.
# Flows are versioned and can be invoked via the API.
# Use flows when you need deterministic multi-step pipelines.
```

---

## Section 9: Model Deployment with SageMaker

### 9.1 Deploy a Model from SageMaker JumpStart

```python
import boto3
from sagemaker.jumpstart.model import JumpStartModel

def deploy_jumpstart_model(model_id: str = "meta-textgeneration-llama-3-8b") -> str:
    """Deploy a foundation model from SageMaker JumpStart."""
    model = JumpStartModel(
        model_id=model_id,
        instance_type="ml.g5.2xlarge",
        env={
            "MAX_INPUT_LENGTH": "4096",
            "MAX_TOTAL_TOKENS": "8192",
        },
    )

    predictor = model.deploy(
        initial_instance_count=1,
        endpoint_name=f"{model_id.replace('.', '-')}-endpoint",
    )
    print(f"Endpoint deployed: {predictor.endpoint_name}")
    return predictor.endpoint_name

# EXAM NOTE: JumpStart provides 400+ pre-trained models.
# Models are deployed to SageMaker endpoints (you manage infrastructure).
# Instance selection matters: g5 for GPU, inf2 for AWS Inferentia.
# Unlike Bedrock (serverless), SageMaker endpoints have ongoing compute costs.
```

### 9.2 Create a SageMaker Endpoint

```python
import sagemaker
from sagemaker.huggingface import HuggingFaceModel

def create_custom_endpoint(
    model_data: str,
    role: str,
    instance_type: str = "ml.g5.2xlarge",
) -> str:
    """Deploy a custom Hugging Face model to a SageMaker endpoint."""
    huggingface_model = HuggingFaceModel(
        model_data=model_data,  # s3://bucket/model.tar.gz
        role=role,
        transformers_version="4.37.0",
        pytorch_version="2.1.0",
        py_version="py310",
        env={
            "HF_MODEL_ID": "sentence-transformers/all-MiniLM-L6-v2",
            "HF_TASK": "feature-extraction",
        },
    )

    predictor = huggingface_model.deploy(
        initial_instance_count=1,
        instance_type=instance_type,
        endpoint_name="custom-embedding-endpoint",
    )
    return predictor.endpoint_name

# EXAM NOTE: SageMaker supports Hugging Face, PyTorch, TensorFlow containers.
# model_data points to a tar.gz in S3 containing model artifacts.
# Auto-scaling can be configured after deployment via Application Auto Scaling.
```

### 9.3 Invoke a SageMaker Endpoint

```python
import boto3
import json

sagemaker_runtime = boto3.client("sagemaker-runtime", region_name="us-east-1")

def invoke_endpoint(endpoint_name: str, prompt: str) -> str:
    """Invoke a deployed SageMaker endpoint for text generation."""
    payload = json.dumps({
        "inputs": prompt,
        "parameters": {
            "max_new_tokens": 512,
            "temperature": 0.3,
            "top_p": 0.9,
            "do_sample": True,
        },
    })

    response = sagemaker_runtime.invoke_endpoint(
        EndpointName=endpoint_name,
        ContentType="application/json",
        Accept="application/json",
        Body=payload,
    )
    result = json.loads(response["Body"].read().decode())
    return result[0]["generated_text"]

# EXAM NOTE: invoke_endpoint is synchronous (up to 60s timeout).
# invoke_endpoint_async is for long-running inference (up to 15 min).
# invoke_endpoint_with_response_stream supports token streaming.
# The payload format depends on the serving container (TGI, vLLM, etc.).
```

### 9.4 Register Model in SageMaker Model Registry

```python
from sagemaker.model import ModelPackage
import sagemaker

def register_model(
    model_data: str,
    image_uri: str,
    model_package_group: str,
) -> str:
    """Register a model version in SageMaker Model Registry for governance."""
    sess = sagemaker.Session()

    model_package = sess.sagemaker_client.create_model_package(
        ModelPackageGroupName=model_package_group,
        ModelPackageDescription="Fine-tuned LLM v2 for customer support",
        InferenceSpecification={
            "Containers": [
                {
                    "Image": image_uri,
                    "ModelDataUrl": model_data,
                    "Framework": "PYTORCH",
                }
            ],
            "SupportedContentTypes": ["application/json"],
            "SupportedResponseMIMETypes": ["application/json"],
            "SupportedRealtimeInferenceInstanceTypes": ["ml.g5.2xlarge"],
        },
        ModelApprovalStatus="PendingManualApproval",
        ModelMetrics={
            "ModelQuality": {
                "Statistics": {
                    "ContentType": "application/json",
                    "S3Uri": "s3://bucket/metrics/quality.json",
                },
            },
        },
    )
    arn = model_package["ModelPackageArn"]
    print(f"Model registered: {arn}")
    return arn

# EXAM NOTE: Model Registry tracks model versions, approval status, and lineage.
# Approval statuses: PendingManualApproval, Approved, Rejected.
# Integrates with CI/CD pipelines — approve → auto-deploy to production.
# Model cards can be attached for documentation and governance.
```

---

## Section 10: Security and Governance

### 10.1 PII Detection with Amazon Comprehend

```python
import boto3

comprehend = boto3.client("comprehend", region_name="us-east-1")

def detect_pii(text: str) -> list[dict]:
    """Detect PII entities in text using Amazon Comprehend."""
    response = comprehend.detect_pii_entities(
        Text=text,
        LanguageCode="en",
    )
    entities = []
    for entity in response["Entities"]:
        entities.append({
            "type": entity["Type"],
            "score": entity["Score"],
            "text": text[entity["BeginOffset"]:entity["EndOffset"]],
            "begin": entity["BeginOffset"],
            "end": entity["EndOffset"],
        })
        print(f"  PII found: {entity['Type']} — '{entities[-1]['text']}' "
              f"(confidence: {entity['Score']:.2f})")
    return entities

# detect_pii("Call John Smith at 555-123-4567 or email john@example.com")
# Output:
#   PII found: NAME — 'John Smith' (confidence: 0.99)
#   PII found: PHONE — '555-123-4567' (confidence: 0.99)
#   PII found: EMAIL — 'john@example.com' (confidence: 0.99)

# EXAM NOTE: Comprehend detects PII types: NAME, ADDRESS, EMAIL, PHONE,
# SSN, CREDIT_DEBIT_NUMBER, DATE_TIME, BANK_ACCOUNT_NUMBER, etc.
# Use as a pre-processing step before sending data to an FM.
# Bedrock Guardrails PII filters use Comprehend under the hood.
```

### 10.2 Data Masking Before FM Invocation

```python
def mask_pii_and_invoke(text: str) -> str:
    """Mask PII before sending to an FM, then unmask in the response."""
    pii_entities = detect_pii(text)

    masked_text = text
    pii_map = {}
    for i, entity in enumerate(sorted(pii_entities, key=lambda e: -e["begin"])):
        placeholder = f"[{entity['type']}_{i}]"
        pii_map[placeholder] = entity["text"]
        masked_text = masked_text[:entity["begin"]] + placeholder + masked_text[entity["end"]:]

    print(f"Masked text: {masked_text}")

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": masked_text}]}],
        inferenceConfig={"maxTokens": 512},
    )
    answer = response["output"]["message"]["content"][0]["text"]

    for placeholder, original in pii_map.items():
        answer = answer.replace(placeholder, original)

    return answer

# EXAM NOTE: This mask-invoke-unmask pattern keeps PII out of model context.
# Alternative: Use Bedrock Guardrails ANONYMIZE action for automatic masking.
# For compliance (GDPR, HIPAA), masking is preferred over relying on the model
# not to leak PII in its response.
```

### 10.3 Enable Bedrock Model Invocation Logging

```python
import boto3

bedrock = boto3.client("bedrock", region_name="us-east-1")

def enable_model_invocation_logging(
    log_group_name: str,
    s3_bucket: str,
    role_arn: str,
):
    """Enable logging of all Bedrock model invocations for audit."""
    bedrock.put_model_invocation_logging_configuration(
        loggingConfig={
            "cloudWatchConfig": {
                "logGroupName": log_group_name,
                "roleArn": role_arn,
                "largeDataDeliveryS3Config": {
                    "bucketName": s3_bucket,
                    "keyPrefix": "bedrock-logs/large-data/",
                },
            },
            "s3Config": {
                "bucketName": s3_bucket,
                "keyPrefix": "bedrock-logs/invocations/",
            },
            "textDataDeliveryEnabled": True,
            "imageDataDeliveryEnabled": True,
            "embeddingDataDeliveryEnabled": True,
        }
    )
    print("Model invocation logging enabled")

# EXAM NOTE: Logs capture: input prompt, output, model ID, latency, token counts.
# CloudWatch for real-time alerting; S3 for long-term storage and analysis.
# textDataDeliveryEnabled logs actual prompt/response text (privacy consideration).
# This is an account-level setting — applies to ALL Bedrock invocations.
```

### 10.4 Create VPC Endpoint for Bedrock

```python
import boto3

ec2 = boto3.client("ec2", region_name="us-east-1")

def create_bedrock_vpc_endpoint(
    vpc_id: str,
    subnet_ids: list[str],
    security_group_ids: list[str],
):
    """Create a VPC endpoint so Bedrock calls never traverse the public internet."""
    response = ec2.create_vpc_endpoint(
        VpcEndpointType="Interface",
        VpcId=vpc_id,
        ServiceName="com.amazonaws.us-east-1.bedrock-runtime",
        SubnetIds=subnet_ids,
        SecurityGroupIds=security_group_ids,
        PrivateDnsEnabled=True,
    )
    endpoint_id = response["VpcEndpoint"]["VpcEndpointId"]
    print(f"VPC endpoint created: {endpoint_id}")

    # Also create endpoint for control-plane operations
    ec2.create_vpc_endpoint(
        VpcEndpointType="Interface",
        VpcId=vpc_id,
        ServiceName="com.amazonaws.us-east-1.bedrock",
        SubnetIds=subnet_ids,
        SecurityGroupIds=security_group_ids,
        PrivateDnsEnabled=True,
    )
    return endpoint_id

# EXAM NOTE: Two endpoints needed:
#   bedrock-runtime — for invoke_model, converse, etc.
#   bedrock         — for control-plane (list_models, create_guardrail, etc.)
# PrivateDnsEnabled=True routes SDK calls through the endpoint automatically.
# Combined with a VPC endpoint policy, this restricts which models can be invoked.
```

### 10.5 IAM Policy for Bedrock Access (Least Privilege)

```python
import json

least_privilege_policy = {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowSpecificModelInvocation",
            "Effect": "Allow",
            "Action": [
                "bedrock:InvokeModel",
                "bedrock:InvokeModelWithResponseStream",
            ],
            "Resource": [
                "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet*",
                "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2*",
            ],
        },
        {
            "Sid": "AllowKnowledgeBaseQuery",
            "Effect": "Allow",
            "Action": [
                "bedrock:Retrieve",
                "bedrock:RetrieveAndGenerate",
            ],
            "Resource": "arn:aws:bedrock:us-east-1:123456789012:knowledge-base/KB_ID",
        },
        {
            "Sid": "AllowAgentInvocation",
            "Effect": "Allow",
            "Action": "bedrock:InvokeAgent",
            "Resource": "arn:aws:bedrock:us-east-1:123456789012:agent-alias/AGENT_ID/*",
        },
        {
            "Sid": "DenyExpensiveModels",
            "Effect": "Deny",
            "Action": "bedrock:InvokeModel",
            "Resource": "arn:aws:bedrock:*::foundation-model/anthropic.claude-3-opus*",
        },
    ],
}

# EXAM NOTE: Key IAM actions for Bedrock:
#   bedrock:InvokeModel         — call a model
#   bedrock:Retrieve            — query a knowledge base (docs only)
#   bedrock:RetrieveAndGenerate — query a knowledge base (docs + generation)
#   bedrock:InvokeAgent         — invoke an agent
#   bedrock:ApplyGuardrail      — test a guardrail
# Resource-level permissions let you restrict access to specific models.
# Use Deny statements to prevent cost overruns (block expensive models).
# Condition keys: bedrock:InferenceProfileArn for cross-region inference.

def create_iam_policy(policy_name: str):
    iam = boto3.client("iam")
    iam.create_policy(
        PolicyName=policy_name,
        PolicyDocument=json.dumps(least_privilege_policy),
        Description="Least-privilege Bedrock access for application tier",
    )
```

---

## Section 11: Monitoring and Observability

### 11.1 CloudWatch Custom Metrics for Token Usage

```python
import boto3
import json

cloudwatch = boto3.client("cloudwatch", region_name="us-east-1")
bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

def invoke_and_track(prompt: str, model_id: str, app_name: str) -> str:
    """Invoke a model and publish token usage metrics to CloudWatch."""
    response = bedrock_runtime.converse(
        modelId=model_id,
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 1024},
    )

    usage = response["usage"]
    text = response["output"]["message"]["content"][0]["text"]

    cloudwatch.put_metric_data(
        Namespace="GenAI/Bedrock",
        MetricData=[
            {
                "MetricName": "InputTokens",
                "Value": usage["inputTokens"],
                "Unit": "Count",
                "Dimensions": [
                    {"Name": "ModelId", "Value": model_id},
                    {"Name": "Application", "Value": app_name},
                ],
            },
            {
                "MetricName": "OutputTokens",
                "Value": usage["outputTokens"],
                "Unit": "Count",
                "Dimensions": [
                    {"Name": "ModelId", "Value": model_id},
                    {"Name": "Application", "Value": app_name},
                ],
            },
            {
                "MetricName": "TotalTokens",
                "Value": usage["inputTokens"] + usage["outputTokens"],
                "Unit": "Count",
                "Dimensions": [
                    {"Name": "ModelId", "Value": model_id},
                    {"Name": "Application", "Value": app_name},
                ],
            },
        ],
    )
    return text

# EXAM NOTE: Bedrock publishes built-in metrics to CloudWatch:
#   Invocations, InvocationLatency, InputTokenCount, OutputTokenCount, etc.
# Custom metrics add application-level dimensions (which app, which user tier).
# Use these for per-application cost allocation and anomaly detection.
```

### 11.2 X-Ray Tracing for FM API Calls

```python
from aws_xray_sdk.core import xray_recorder, patch_all
import boto3
import json

patch_all()  # Automatically instruments boto3, requests, etc.

@xray_recorder.capture("bedrock_invoke")
def traced_invoke(prompt: str) -> str:
    """Invoke Bedrock with X-Ray tracing for end-to-end visibility."""
    subsegment = xray_recorder.current_subsegment()
    subsegment.put_annotation("model_id", "anthropic.claude-3-sonnet-20240229-v1:0")
    subsegment.put_annotation("prompt_length", len(prompt))

    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 512},
    )

    usage = response["usage"]
    subsegment.put_metadata("input_tokens", usage["inputTokens"])
    subsegment.put_metadata("output_tokens", usage["outputTokens"])
    subsegment.put_metadata("latency_ms", response["ResponseMetadata"]["HTTPHeaders"].get("x-amzn-requestid"))

    return response["output"]["message"]["content"][0]["text"]

# EXAM NOTE: X-Ray traces show the full request lifecycle:
#   Lambda → Bedrock Runtime → Model → Response
# Annotations are indexed and searchable; metadata is not.
# Use annotations for filter expressions: annotation.model_id = "claude-3-sonnet"
# patch_all() instruments all boto3 calls automatically.
```

### 11.3 CloudWatch Logs Insights Query for Prompt Analysis

```python
import boto3
import time

logs = boto3.client("logs", region_name="us-east-1")

def query_bedrock_logs(log_group: str, hours: int = 24) -> list:
    """Run a Logs Insights query to analyze Bedrock invocation patterns."""
    query = """
    fields @timestamp, modelId, inputTokenCount, outputTokenCount
    | filter inputTokenCount > 0
    | stats
        count() as invocations,
        sum(inputTokenCount) as total_input_tokens,
        sum(outputTokenCount) as total_output_tokens,
        avg(inputTokenCount) as avg_input_tokens,
        max(inputTokenCount) as max_input_tokens,
        percentile(inputTokenCount, 95) as p95_input_tokens
      by modelId
    | sort total_input_tokens desc
    """

    start_time = int((time.time() - hours * 3600) * 1000)
    end_time = int(time.time() * 1000)

    start_resp = logs.start_query(
        logGroupName=log_group,
        startTime=start_time,
        endTime=end_time,
        queryString=query,
    )
    query_id = start_resp["queryId"]

    while True:
        result = logs.get_query_results(queryId=query_id)
        if result["status"] == "Complete":
            break
        time.sleep(2)

    for row in result["results"]:
        fields = {f["field"]: f["value"] for f in row}
        print(f"Model: {fields.get('modelId', 'N/A'):50s}  "
              f"Invocations: {fields.get('invocations', 0):>8s}  "
              f"Total tokens: {fields.get('total_input_tokens', 0):>12s}")

    return result["results"]

# EXAM NOTE: Requires model invocation logging to be enabled (see 10.3).
# Logs Insights is powerful for ad-hoc analysis of invocation patterns.
# Use for: cost analysis, abuse detection, prompt length distribution, model usage.
```

### 11.4 Cost Tracking per Model Invocation

```python
BEDROCK_PRICING = {
    "anthropic.claude-3-sonnet-20240229-v1:0": {"input": 0.003, "output": 0.015},
    "anthropic.claude-3-haiku-20240307-v1:0":   {"input": 0.00025, "output": 0.00125},
    "amazon.titan-embed-text-v2:0":             {"input": 0.00002, "output": 0.0},
}

def estimate_cost(model_id: str, input_tokens: int, output_tokens: int) -> float:
    """Estimate cost for a Bedrock invocation (per 1K tokens)."""
    pricing = BEDROCK_PRICING.get(model_id)
    if not pricing:
        raise ValueError(f"Unknown model: {model_id}")
    cost = (input_tokens / 1000 * pricing["input"]) + (output_tokens / 1000 * pricing["output"])
    return round(cost, 6)


def invoke_with_cost_tracking(prompt: str, model_id: str) -> dict:
    """Invoke a model and return the response with cost estimate."""
    response = bedrock_runtime.converse(
        modelId=model_id,
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 512},
    )
    usage = response["usage"]
    cost = estimate_cost(model_id, usage["inputTokens"], usage["outputTokens"])

    return {
        "text": response["output"]["message"]["content"][0]["text"],
        "input_tokens": usage["inputTokens"],
        "output_tokens": usage["outputTokens"],
        "estimated_cost_usd": cost,
    }

# EXAM NOTE: Bedrock pricing is per 1K tokens (input and output priced separately).
# On-Demand: pay per token, no commitment.
# Provisioned Throughput: reserved capacity for consistent performance.
# Batch Inference: up to 50% discount for non-real-time workloads.
```

### 11.5 Alert on Anomalous Token Usage

```python
def create_token_usage_alarm(model_id: str, threshold: int = 1_000_000):
    """Create a CloudWatch alarm for excessive token usage."""
    cloudwatch = boto3.client("cloudwatch", region_name="us-east-1")

    cloudwatch.put_metric_alarm(
        AlarmName=f"HighTokenUsage-{model_id.replace('.', '-').replace(':', '-')}",
        AlarmDescription=f"Alert when {model_id} token usage exceeds threshold",
        Namespace="GenAI/Bedrock",
        MetricName="TotalTokens",
        Dimensions=[{"Name": "ModelId", "Value": model_id}],
        Statistic="Sum",
        Period=3600,
        EvaluationPeriods=1,
        Threshold=threshold,
        ComparisonOperator="GreaterThanThreshold",
        AlarmActions=["arn:aws:sns:us-east-1:123456789012:genai-alerts"],
        TreatMissingData="notBreaching",
    )
    print(f"Alarm created for {model_id} at threshold {threshold}")

# EXAM NOTE: Use CloudWatch Alarms + SNS for operational alerts.
# Monitor: token usage spikes, latency increases, error rates.
# TreatMissingData="notBreaching" avoids false alarms during low-traffic periods.
# Combine with AWS Budgets for cost-based alerting.
```

---

## Section 12: Model Evaluation

### 12.1 Create an Automatic Evaluation Job in Bedrock

```python
import boto3

bedrock = boto3.client("bedrock", region_name="us-east-1")

def create_evaluation_job(
    job_name: str,
    model_id: str,
    dataset_s3_uri: str,
    output_s3_uri: str,
    role_arn: str,
) -> str:
    """Create an automatic model evaluation job in Bedrock."""
    response = bedrock.create_evaluation_job(
        jobName=job_name,
        roleArn=role_arn,
        evaluationConfig={
            "automated": {
                "datasetMetricConfigs": [
                    {
                        "taskType": "Summarization",
                        "dataset": {
                            "name": "BuiltIn.Summarization.GigaWord",
                        },
                        "metricNames": [
                            "BertScore",
                            "Rouge",
                        ],
                    }
                ]
            }
        },
        inferenceConfig={
            "models": [
                {
                    "bedrockModel": {
                        "modelIdentifier": model_id,
                        "inferenceParams": '{"maxTokens": 512, "temperature": 0.0}',
                    }
                }
            ]
        },
        outputDataConfig={"s3Uri": output_s3_uri},
    )
    print(f"Evaluation job created: {response['jobArn']}")
    return response["jobArn"]

# EXAM NOTE: Bedrock supports automatic evaluation with built-in metrics:
#   - BertScore (semantic similarity)
#   - Rouge (overlap-based summarization metric)
#   - Accuracy (classification tasks)
# Task types: Summarization, QA, Classification, TextGeneration.
# You can use built-in datasets or bring your own (JSONL format).
```

### 12.2 LLM-as-a-Judge Evaluation

```python
def llm_as_judge(prompt: str, response_a: str, response_b: str) -> dict:
    """Use a strong model to evaluate and compare two model outputs."""
    judge_prompt = f"""You are an impartial judge evaluating two AI responses.

User prompt: {prompt}

Response A:
{response_a}

Response B:
{response_b}

Evaluate both responses on these criteria (score 1-5 each):
1. Accuracy — factual correctness
2. Relevance — addresses the question directly
3. Completeness — covers all aspects
4. Clarity — well-structured and clear

Return your evaluation as JSON:
{{
  "response_a": {{"accuracy": N, "relevance": N, "completeness": N, "clarity": N, "total": N}},
  "response_b": {{"accuracy": N, "relevance": N, "completeness": N, "clarity": N, "total": N}},
  "winner": "A" or "B" or "TIE",
  "reasoning": "brief explanation"
}}"""

    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        messages=[{"role": "user", "content": [{"text": judge_prompt}]}],
        inferenceConfig={"maxTokens": 512, "temperature": 0.0},
    )
    import json
    raw = response["output"]["message"]["content"][0]["text"]
    raw = raw.strip().removeprefix("```json").removesuffix("```").strip()
    return json.loads(raw)

# EXAM NOTE: LLM-as-a-Judge is used when human evaluation is too expensive.
# Bedrock supports this natively via "human" evaluation config with model judges.
# Best practice: use a stronger model as judge than the models being evaluated.
# Mitigate position bias by swapping A/B order and averaging scores.
```

### 12.3 Custom Evaluation Metrics

```python
import math
from collections import Counter

def compute_bleu(reference: str, candidate: str, max_n: int = 4) -> float:
    """Compute BLEU score — measures n-gram overlap."""
    ref_tokens = reference.lower().split()
    cand_tokens = candidate.lower().split()

    if not cand_tokens:
        return 0.0

    brevity_penalty = min(1.0, math.exp(1 - len(ref_tokens) / len(cand_tokens)))

    precisions = []
    for n in range(1, max_n + 1):
        ref_ngrams = Counter(zip(*[ref_tokens[i:] for i in range(n)]))
        cand_ngrams = Counter(zip(*[cand_tokens[i:] for i in range(n)]))
        matches = sum((cand_ngrams & ref_ngrams).values())
        total = max(sum(cand_ngrams.values()), 1)
        precisions.append(matches / total)

    if any(p == 0 for p in precisions):
        return 0.0
    log_avg = sum(math.log(p) for p in precisions) / max_n
    return brevity_penalty * math.exp(log_avg)


def compute_rouge_l(reference: str, candidate: str) -> float:
    """Compute ROUGE-L score — longest common subsequence based."""
    ref_tokens = reference.lower().split()
    cand_tokens = candidate.lower().split()

    m, n = len(ref_tokens), len(cand_tokens)
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if ref_tokens[i - 1] == cand_tokens[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])

    lcs = dp[m][n]
    precision = lcs / n if n else 0
    recall = lcs / m if m else 0
    f1 = 2 * precision * recall / (precision + recall) if (precision + recall) else 0
    return f1


def evaluate_rag_response(query: str, reference: str, generated: str) -> dict:
    """Evaluate a RAG response with multiple metrics."""
    return {
        "bleu": round(compute_bleu(reference, generated), 4),
        "rouge_l": round(compute_rouge_l(reference, generated), 4),
        "length_ratio": round(len(generated.split()) / max(len(reference.split()), 1), 2),
    }

# EXAM NOTE: Common evaluation metrics:
#   BLEU     — n-gram precision (machine translation origin)
#   ROUGE    — recall-based (summarization)
#   BERTScore — semantic similarity using embeddings
#   Faithfulness — does the answer stick to the context? (RAG-specific)
#   Relevance — does the answer address the question?
```

### 12.4 A/B Testing Framework for Model Comparison

```python
import random
import time

def ab_test_models(
    prompts: list[str],
    model_a: str,
    model_b: str,
) -> dict:
    """Compare two models across a set of prompts with latency and cost tracking."""
    results = {"model_a": [], "model_b": []}

    for prompt in prompts:
        for label, model_id in [("model_a", model_a), ("model_b", model_b)]:
            start = time.time()
            response = bedrock_runtime.converse(
                modelId=model_id,
                messages=[{"role": "user", "content": [{"text": prompt}]}],
                inferenceConfig={"maxTokens": 512, "temperature": 0.0},
            )
            latency = time.time() - start
            usage = response["usage"]

            results[label].append({
                "prompt": prompt[:80],
                "response": response["output"]["message"]["content"][0]["text"],
                "input_tokens": usage["inputTokens"],
                "output_tokens": usage["outputTokens"],
                "latency_s": round(latency, 3),
            })

    for label in ["model_a", "model_b"]:
        entries = results[label]
        avg_latency = sum(e["latency_s"] for e in entries) / len(entries)
        total_tokens = sum(e["input_tokens"] + e["output_tokens"] for e in entries)
        print(f"{label}: avg_latency={avg_latency:.3f}s  total_tokens={total_tokens}")

    return results

# EXAM NOTE: A/B testing helps select the right model based on:
#   - Quality (use LLM-as-Judge to score outputs)
#   - Latency (time to first token + total generation time)
#   - Cost (token counts × pricing)
#   - Throughput (requests per minute under load)
# Bedrock's model evaluation job automates this at scale.
```

---

## Section 13: Enterprise Integration Patterns

### 13.1 Lambda Function for Bedrock Integration

```python
import json
import boto3

bedrock_runtime = boto3.client("bedrock-runtime")

def lambda_handler(event, context):
    """AWS Lambda function that wraps Bedrock model invocation."""
    try:
        body = json.loads(event.get("body", "{}"))
        prompt = body.get("prompt")
        if not prompt:
            return {"statusCode": 400, "body": json.dumps({"error": "prompt is required"})}

        model_id = body.get("model_id", "anthropic.claude-3-haiku-20240307-v1:0")
        max_tokens = min(body.get("max_tokens", 512), 4096)

        response = bedrock_runtime.converse(
            modelId=model_id,
            messages=[{"role": "user", "content": [{"text": prompt}]}],
            inferenceConfig={"maxTokens": max_tokens, "temperature": 0.3},
        )

        usage = response["usage"]
        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({
                "response": response["output"]["message"]["content"][0]["text"],
                "usage": {
                    "input_tokens": usage["inputTokens"],
                    "output_tokens": usage["outputTokens"],
                },
            }),
        }

    except bedrock_runtime.exceptions.ThrottlingException:
        return {"statusCode": 429, "body": json.dumps({"error": "Rate limited"})}
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}

# EXAM NOTE: Lambda + Bedrock is the standard serverless GenAI pattern.
# Lambda timeout: max 15 minutes (enough for most FM calls).
# Memory: set 256MB+ for Bedrock calls (SDK overhead).
# Cold starts: use provisioned concurrency for latency-sensitive apps.
# The Lambda execution role needs bedrock:InvokeModel permission.
```

### 13.2 Step Functions Workflow for Agent Orchestration

```python
import json

step_functions_definition = {
    "Comment": "GenAI document processing pipeline",
    "StartAt": "ExtractText",
    "States": {
        "ExtractText": {
            "Type": "Task",
            "Resource": "arn:aws:lambda:us-east-1:123456789012:function:extract-text",
            "Next": "ClassifyDocument",
            "Retry": [
                {"ErrorEquals": ["States.TaskFailed"], "IntervalSeconds": 5, "MaxAttempts": 3, "BackoffRate": 2.0}
            ],
        },
        "ClassifyDocument": {
            "Type": "Task",
            "Resource": "arn:aws:states:::bedrock:invokeModel",
            "Parameters": {
                "ModelId": "anthropic.claude-3-haiku-20240307-v1:0",
                "ContentType": "application/json",
                "Accept": "application/json",
                "Body": {
                    "anthropic_version": "bedrock-2023-05-31",
                    "max_tokens": 100,
                    "messages": [
                        {
                            "role": "user",
                            "content.$": "States.Format('Classify this document as INVOICE, CONTRACT, or REPORT. Respond with only the label.\n\nDocument: {}', $.extracted_text)",
                        }
                    ],
                },
            },
            "ResultPath": "$.classification",
            "Next": "RouteByType",
        },
        "RouteByType": {
            "Type": "Choice",
            "Choices": [
                {
                    "Variable": "$.classification.Body.content[0].text",
                    "StringEquals": "INVOICE",
                    "Next": "ProcessInvoice",
                },
                {
                    "Variable": "$.classification.Body.content[0].text",
                    "StringEquals": "CONTRACT",
                    "Next": "ProcessContract",
                },
            ],
            "Default": "ProcessGeneric",
        },
        "ProcessInvoice":  {"Type": "Task", "Resource": "arn:aws:lambda:us-east-1:123456789012:function:process-invoice", "End": True},
        "ProcessContract": {"Type": "Task", "Resource": "arn:aws:lambda:us-east-1:123456789012:function:process-contract", "End": True},
        "ProcessGeneric":  {"Type": "Task", "Resource": "arn:aws:lambda:us-east-1:123456789012:function:process-generic", "End": True},
    },
}

# EXAM NOTE: Step Functions has NATIVE Bedrock integration (optimized connector).
# No Lambda needed for the FM call — direct "bedrock:invokeModel" resource.
# Use Choice states to branch based on model output (classification → routing).
# Retry/Catch handles throttling and transient errors.
# Step Functions Express Workflows: up to 5 min, lower cost, higher throughput.
# Step Functions Standard Workflows: up to 1 year, exactly-once execution.
```

### 13.3 EventBridge Integration for Async Processing

```python
import boto3
import json

events = boto3.client("events", region_name="us-east-1")

def send_to_eventbridge(document_id: str, text: str, source: str = "app.document-processor"):
    """Publish an event for asynchronous GenAI processing."""
    events.put_events(
        Entries=[
            {
                "Source": source,
                "DetailType": "DocumentSubmitted",
                "Detail": json.dumps({
                    "document_id": document_id,
                    "text": text[:10000],
                    "submitted_at": "2026-04-17T12:00:00Z",
                }),
                "EventBusName": "genai-processing",
            }
        ]
    )

# EventBridge rule (configured via console/CDK):
# {
#   "source": ["app.document-processor"],
#   "detail-type": ["DocumentSubmitted"]
# }
# Target: Lambda function, Step Functions, or SQS queue

# EXAM NOTE: EventBridge decouples producers from consumers.
# Pattern: User submits doc → EventBridge → Lambda (Bedrock call) → Store result.
# Benefits: retry built-in, multiple targets, event archiving, replay.
# Use for workloads where real-time response isn't needed.
```

### 13.4 API Gateway with Bedrock Backend

```python
import boto3
import json

apigateway = boto3.client("apigateway", region_name="us-east-1")

api_gateway_openapi = {
    "openapi": "3.0.1",
    "info": {"title": "GenAI API", "version": "1.0"},
    "paths": {
        "/chat": {
            "post": {
                "x-amazon-apigateway-integration": {
                    "type": "aws_proxy",
                    "httpMethod": "POST",
                    "uri": "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:123456789012:function:bedrock-chat/invocations",
                    "passthroughBehavior": "when_no_match",
                },
                "x-amazon-apigateway-request-validator": "all",
            }
        }
    },
    "x-amazon-apigateway-request-validators": {
        "all": {"validateRequestBody": True, "validateRequestParameters": True}
    },
}

# EXAM NOTE: API Gateway → Lambda → Bedrock is the standard REST API pattern.
# Key configurations:
#   - Usage plans + API keys for rate limiting per client
#   - WAF integration for request filtering
#   - Request/response transformation with mapping templates
#   - Cognito authorizer for user authentication
# For streaming responses, use Lambda function URLs or WebSocket API.
# API Gateway timeout: 29 seconds — may be tight for large model calls.
```

### 13.5 Exponential Backoff and Retry Logic

```python
import time
import random
from botocore.exceptions import ClientError

def invoke_with_retry(
    prompt: str,
    model_id: str = "anthropic.claude-3-sonnet-20240229-v1:0",
    max_retries: int = 5,
    base_delay: float = 1.0,
    max_delay: float = 60.0,
) -> str:
    """Invoke Bedrock with exponential backoff and jitter."""
    bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

    for attempt in range(max_retries + 1):
        try:
            response = bedrock_runtime.converse(
                modelId=model_id,
                messages=[{"role": "user", "content": [{"text": prompt}]}],
                inferenceConfig={"maxTokens": 512},
            )
            return response["output"]["message"]["content"][0]["text"]

        except ClientError as e:
            error_code = e.response["Error"]["Code"]

            if error_code == "ThrottlingException" and attempt < max_retries:
                delay = min(base_delay * (2 ** attempt), max_delay)
                jitter = random.uniform(0, delay * 0.5)
                wait_time = delay + jitter
                print(f"Throttled (attempt {attempt + 1}). Retrying in {wait_time:.1f}s")
                time.sleep(wait_time)
            elif error_code == "ModelTimeoutException" and attempt < max_retries:
                time.sleep(base_delay)
            else:
                raise

    raise RuntimeError("Max retries exceeded")

# EXAM NOTE: Bedrock uses token-bucket rate limiting.
# Exponential backoff + jitter prevents thundering herd.
# boto3 has built-in retry (standard mode: 3 retries) but custom logic gives
# more control for GenAI-specific error handling.
# Configure retries in boto3: Config(retries={"max_attempts": 5, "mode": "adaptive"})
```

### 13.6 Circuit Breaker Pattern Implementation

```python
import time
from enum import Enum

class CircuitState(Enum):
    CLOSED = "closed"
    OPEN = "open"
    HALF_OPEN = "half_open"


class CircuitBreaker:
    """Circuit breaker for FM API calls — prevents cascading failures."""

    def __init__(self, failure_threshold: int = 5, recovery_timeout: int = 60):
        self.failure_threshold = failure_threshold
        self.recovery_timeout = recovery_timeout
        self.failure_count = 0
        self.state = CircuitState.CLOSED
        self.last_failure_time = 0

    def call(self, func, *args, **kwargs):
        if self.state == CircuitState.OPEN:
            if time.time() - self.last_failure_time > self.recovery_timeout:
                self.state = CircuitState.HALF_OPEN
            else:
                raise RuntimeError("Circuit breaker is OPEN — calls are blocked")

        try:
            result = func(*args, **kwargs)
            if self.state == CircuitState.HALF_OPEN:
                self.state = CircuitState.CLOSED
                self.failure_count = 0
            return result

        except Exception as e:
            self.failure_count += 1
            self.last_failure_time = time.time()
            if self.failure_count >= self.failure_threshold:
                self.state = CircuitState.OPEN
                print(f"Circuit OPEN after {self.failure_count} failures")
            raise


# --- usage ---
breaker = CircuitBreaker(failure_threshold=5, recovery_timeout=60)

def safe_invoke(prompt: str) -> str:
    return breaker.call(invoke_with_retry, prompt)

# EXAM NOTE: Circuit breaker prevents overloading a failing downstream service.
# States: CLOSED (normal) → OPEN (blocking) → HALF_OPEN (testing recovery).
# Combine with fallback models: if primary model circuit opens, route to a cheaper model.
```

---

## Section 14: Advanced Patterns

### 14.1 Semantic Caching Implementation

```python
import json
import hashlib
import time

class SemanticCache:
    """Cache FM responses by semantic similarity to avoid redundant calls."""

    def __init__(self, opensearch_client, index: str = "prompt_cache", ttl_hours: int = 24):
        self.client = opensearch_client
        self.index = index
        self.ttl_hours = ttl_hours
        self.bedrock_runtime = boto3.client("bedrock-runtime", region_name="us-east-1")

    def _embed(self, text: str) -> list[float]:
        resp = self.bedrock_runtime.invoke_model(
            modelId="amazon.titan-embed-text-v2:0",
            contentType="application/json",
            accept="application/json",
            body=json.dumps({"inputText": text, "dimensions": 256, "normalize": True}),
        )
        return json.loads(resp["body"].read())["embedding"]

    def get(self, prompt: str, threshold: float = 0.95) -> str | None:
        """Check cache for a semantically similar prompt."""
        embedding = self._embed(prompt)
        result = self.client.search(
            index=self.index,
            body={
                "size": 1,
                "query": {"knn": {"embedding": {"vector": embedding, "k": 1}}},
                "_source": ["response", "timestamp"],
            },
        )
        hits = result["hits"]["hits"]
        if hits and hits[0]["_score"] >= threshold:
            cached = hits[0]["_source"]
            age_hours = (time.time() - cached["timestamp"]) / 3600
            if age_hours < self.ttl_hours:
                return cached["response"]
        return None

    def put(self, prompt: str, response: str):
        """Store a prompt-response pair in the cache."""
        embedding = self._embed(prompt)
        self.client.index(
            index=self.index,
            body={
                "prompt": prompt,
                "response": response,
                "embedding": embedding,
                "timestamp": time.time(),
            },
        )


def cached_invoke(cache: SemanticCache, prompt: str, model_id: str) -> str:
    """Try cache first, fall back to model invocation."""
    cached = cache.get(prompt)
    if cached:
        print("Cache HIT")
        return cached

    print("Cache MISS — invoking model")
    response = bedrock_runtime.converse(
        modelId=model_id,
        messages=[{"role": "user", "content": [{"text": prompt}]}],
        inferenceConfig={"maxTokens": 512},
    )
    text = response["output"]["message"]["content"][0]["text"]
    cache.put(prompt, text)
    return text

# EXAM NOTE: Semantic caching reduces costs and latency for repeated similar queries.
# Threshold tuning: 0.95+ for strict matching, 0.85-0.90 for broader matching.
# Use lower-dimension embeddings (256) for cache to minimize storage and search cost.
# Alternative: ElastiCache with exact-match hashing for deterministic queries.
```

### 14.2 Model Routing Based on Query Complexity

```python
def classify_complexity(query: str) -> str:
    """Use a fast model to classify query complexity for routing."""
    response = bedrock_runtime.converse(
        modelId="anthropic.claude-3-haiku-20240307-v1:0",
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "text": (
                            f"Classify the complexity of this query as SIMPLE, MODERATE, or COMPLEX.\n"
                            f"SIMPLE: factual lookup, yes/no, short answer.\n"
                            f"MODERATE: explanation, comparison, moderate reasoning.\n"
                            f"COMPLEX: multi-step reasoning, analysis, creative writing, code generation.\n\n"
                            f"Query: {query}\n\nComplexity:"
                        )
                    }
                ],
            }
        ],
        inferenceConfig={"maxTokens": 10, "temperature": 0.0},
    )
    return response["output"]["message"]["content"][0]["text"].strip().upper()


MODEL_ROUTER = {
    "SIMPLE":   "anthropic.claude-3-haiku-20240307-v1:0",
    "MODERATE": "anthropic.claude-3-sonnet-20240229-v1:0",
    "COMPLEX":  "anthropic.claude-3-sonnet-20240229-v1:0",
}


def routed_invoke(query: str) -> dict:
    """Route queries to the optimal model based on complexity."""
    complexity = classify_complexity(query)
    model_id = MODEL_ROUTER.get(complexity, MODEL_ROUTER["MODERATE"])
    print(f"Complexity: {complexity} → routing to {model_id}")

    response = bedrock_runtime.converse(
        modelId=model_id,
        messages=[{"role": "user", "content": [{"text": query}]}],
        inferenceConfig={"maxTokens": 1024},
    )
    return {
        "complexity": complexity,
        "model": model_id,
        "response": response["output"]["message"]["content"][0]["text"],
    }

# EXAM NOTE: Model routing optimizes cost without sacrificing quality.
# Route simple queries to fast/cheap models (Haiku) and complex to capable ones.
# The classification call (Haiku) is ~10x cheaper than using Sonnet for everything.
# Production: use a fine-tuned classifier or prompt-length heuristics for routing.
```

### 14.3 Batch Inference with Bedrock

```python
import boto3
import json

bedrock = boto3.client("bedrock", region_name="us-east-1")

def create_batch_inference_job(
    job_name: str,
    model_id: str,
    input_s3_uri: str,
    output_s3_uri: str,
    role_arn: str,
) -> str:
    """
    Submit a batch inference job for offline processing.
    Input: JSONL file in S3 with one request per line.
    """
    response = bedrock.create_model_invocation_job(
        jobName=job_name,
        modelId=model_id,
        roleArn=role_arn,
        inputDataConfig={
            "s3InputDataConfig": {
                "s3Uri": input_s3_uri,
                "s3InputFormat": "JSONL",
            }
        },
        outputDataConfig={
            "s3OutputDataConfig": {
                "s3Uri": output_s3_uri,
            }
        },
    )
    job_arn = response["jobArn"]
    print(f"Batch job submitted: {job_arn}")
    return job_arn

# Input JSONL format (one per line):
# {"recordId": "1", "modelInput": {"anthropic_version": "bedrock-2023-05-31", "max_tokens": 256, "messages": [{"role": "user", "content": "Summarize: ..."}]}}
# {"recordId": "2", "modelInput": {"anthropic_version": "bedrock-2023-05-31", "max_tokens": 256, "messages": [{"role": "user", "content": "Summarize: ..."}]}}

# EXAM NOTE: Batch inference offers up to 50% cost savings vs on-demand.
# No real-time latency guarantee — results may take hours.
# Use for: document processing pipelines, bulk classification, data enrichment.
# Max job size: limited by S3 object size and model quotas.
```

### 14.4 Token Counting and Cost Estimation

```python
def estimate_tokens(text: str) -> int:
    """Rough token estimation (~ 4 chars per token for English text)."""
    return max(len(text) // 4, 1)


def estimate_conversation_cost(
    messages: list[dict],
    model_id: str,
    max_output_tokens: int = 512,
) -> dict:
    """Estimate cost before making an API call."""
    pricing = BEDROCK_PRICING.get(model_id, {"input": 0.003, "output": 0.015})

    total_input_text = ""
    for msg in messages:
        for content in msg.get("content", []):
            if isinstance(content, dict) and "text" in content:
                total_input_text += content["text"]

    est_input_tokens = estimate_tokens(total_input_text)
    est_output_tokens = max_output_tokens

    est_cost = (
        (est_input_tokens / 1000 * pricing["input"])
        + (est_output_tokens / 1000 * pricing["output"])
    )

    return {
        "estimated_input_tokens": est_input_tokens,
        "estimated_output_tokens": est_output_tokens,
        "estimated_cost_usd": round(est_cost, 6),
        "model_id": model_id,
    }

# EXAM NOTE: Token counting is model-specific. Claude uses ~4 chars/token for English.
# For accurate counts, use the model's tokenizer (tiktoken for GPT, etc.).
# The Converse API response always includes exact token counts in the usage field.
# Use estimates for cost budgeting and request-level spending limits.
```

### 14.5 Dynamic Model Selection with AppConfig

```python
import boto3
import json

appconfig = boto3.client("appconfig", region_name="us-east-1")
appconfigdata = boto3.client("appconfigdata", region_name="us-east-1")

def get_model_config(app_id: str, env_id: str, config_id: str) -> dict:
    """Fetch model configuration from AWS AppConfig for dynamic routing."""
    session = appconfigdata.start_configuration_session(
        ApplicationIdentifier=app_id,
        EnvironmentIdentifier=env_id,
        ConfigurationProfileIdentifier=config_id,
        RequiredMinimumPollIntervalInSeconds=15,
    )
    token = session["InitialConfigurationToken"]

    config_resp = appconfigdata.get_latest_configuration(ConfigurationToken=token)
    config = json.loads(config_resp["Configuration"].read())
    return config

# AppConfig configuration example:
# {
#   "default_model": "anthropic.claude-3-sonnet-20240229-v1:0",
#   "fallback_model": "anthropic.claude-3-haiku-20240307-v1:0",
#   "max_tokens": 1024,
#   "temperature": 0.3,
#   "feature_flags": {
#     "enable_guardrails": true,
#     "enable_caching": true,
#     "enable_streaming": false
#   }
# }

def invoke_with_dynamic_config(prompt: str, config: dict) -> str:
    """Use AppConfig-driven settings for model invocation."""
    model_id = config.get("default_model", "anthropic.claude-3-haiku-20240307-v1:0")

    try:
        response = bedrock_runtime.converse(
            modelId=model_id,
            messages=[{"role": "user", "content": [{"text": prompt}]}],
            inferenceConfig={
                "maxTokens": config.get("max_tokens", 512),
                "temperature": config.get("temperature", 0.3),
            },
        )
        return response["output"]["message"]["content"][0]["text"]

    except Exception:
        fallback = config.get("fallback_model")
        if fallback and fallback != model_id:
            response = bedrock_runtime.converse(
                modelId=fallback,
                messages=[{"role": "user", "content": [{"text": prompt}]}],
                inferenceConfig={"maxTokens": 512},
            )
            return response["output"]["message"]["content"][0]["text"]
        raise

# EXAM NOTE: AppConfig enables changing model config without redeploying code.
# Supports gradual rollouts, feature flags, and instant rollbacks.
# Deployment strategies: AllAtOnce, Linear, Canary.
# Use for: model version upgrades, A/B testing, kill switches.
```

---

## Section 15: CDK/CloudFormation

### 15.1 CDK Stack for Bedrock Knowledge Base

```python
from aws_cdk import (
    Stack,
    aws_bedrock as bedrock,
    aws_iam as iam,
    aws_s3 as s3,
    aws_opensearchserverless as oss,
    RemovalPolicy,
)
from constructs import Construct


class BedrockKnowledgeBaseStack(Stack):
    def __init__(self, scope: Construct, id: str, **kwargs):
        super().__init__(scope, id, **kwargs)

        docs_bucket = s3.Bucket(
            self, "DocsBucket",
            removal_policy=RemovalPolicy.DESTROY,
            auto_delete_objects=True,
        )

        collection = oss.CfnCollection(
            self, "VectorCollection",
            name="kb-vectors",
            type="VECTORSEARCH",
        )

        kb_role = iam.Role(
            self, "KBRole",
            assumed_by=iam.ServicePrincipal("bedrock.amazonaws.com"),
            inline_policies={
                "bedrock-kb": iam.PolicyDocument(
                    statements=[
                        iam.PolicyStatement(
                            actions=["bedrock:InvokeModel"],
                            resources=["arn:aws:bedrock:*::foundation-model/amazon.titan-embed-text-v2:0"],
                        ),
                        iam.PolicyStatement(
                            actions=["s3:GetObject", "s3:ListBucket"],
                            resources=[docs_bucket.bucket_arn, f"{docs_bucket.bucket_arn}/*"],
                        ),
                        iam.PolicyStatement(
                            actions=["aoss:APIAccessAll"],
                            resources=[collection.attr_arn],
                        ),
                    ]
                )
            },
        )

        kb = bedrock.CfnKnowledgeBase(
            self, "KnowledgeBase",
            name="product-docs-kb",
            role_arn=kb_role.role_arn,
            knowledge_base_configuration=bedrock.CfnKnowledgeBase.KnowledgeBaseConfigurationProperty(
                type="VECTOR",
                vector_knowledge_base_configuration=bedrock.CfnKnowledgeBase.VectorKnowledgeBaseConfigurationProperty(
                    embedding_model_arn="arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0",
                ),
            ),
            storage_configuration=bedrock.CfnKnowledgeBase.StorageConfigurationProperty(
                type="OPENSEARCH_SERVERLESS",
                opensearch_serverless_configuration=bedrock.CfnKnowledgeBase.OpenSearchServerlessConfigurationProperty(
                    collection_arn=collection.attr_arn,
                    vector_index_name="documents",
                    field_mapping=bedrock.CfnKnowledgeBase.OpenSearchServerlessFieldMappingProperty(
                        vector_field="embedding",
                        text_field="text",
                        metadata_field="metadata",
                    ),
                ),
            ),
        )

        bedrock.CfnDataSource(
            self, "S3DataSource",
            knowledge_base_id=kb.attr_knowledge_base_id,
            name="docs-source",
            data_source_configuration=bedrock.CfnDataSource.DataSourceConfigurationProperty(
                type="S3",
                s3_configuration=bedrock.CfnDataSource.S3DataSourceConfigurationProperty(
                    bucket_arn=docs_bucket.bucket_arn,
                ),
            ),
        )

# EXAM NOTE: CDK L1 constructs (Cfn*) map directly to CloudFormation resources.
# L2 constructs (higher-level) may not be available yet for newer Bedrock resources.
# The stack creates: S3 bucket → OpenSearch Serverless collection → IAM role → KB → Data source.
```

### 15.2 CDK Stack for Complete RAG Pipeline

```python
from aws_cdk import (
    Stack,
    Duration,
    aws_lambda as _lambda,
    aws_apigateway as apigw,
    aws_iam as iam,
    aws_logs as logs,
)
from constructs import Construct


class RagPipelineStack(Stack):
    def __init__(self, scope: Construct, id: str, knowledge_base_id: str, **kwargs):
        super().__init__(scope, id, **kwargs)

        rag_function = _lambda.Function(
            self, "RagHandler",
            runtime=_lambda.Runtime.PYTHON_3_12,
            handler="index.handler",
            code=_lambda.Code.from_asset("lambda/rag"),
            timeout=Duration.seconds(120),
            memory_size=512,
            environment={
                "KNOWLEDGE_BASE_ID": knowledge_base_id,
                "MODEL_ID": "anthropic.claude-3-sonnet-20240229-v1:0",
            },
            log_retention=logs.RetentionDays.ONE_WEEK,
        )

        rag_function.add_to_role_policy(iam.PolicyStatement(
            actions=[
                "bedrock:InvokeModel",
                "bedrock:RetrieveAndGenerate",
                "bedrock:Retrieve",
            ],
            resources=["*"],
        ))

        api = apigw.RestApi(
            self, "RagApi",
            rest_api_name="RAG API",
            deploy_options=apigw.StageOptions(
                throttling_rate_limit=100,
                throttling_burst_limit=50,
                logging_level=apigw.MethodLoggingLevel.INFO,
            ),
        )

        chat_resource = api.root.add_resource("chat")
        chat_resource.add_method(
            "POST",
            apigw.LambdaIntegration(rag_function, timeout=Duration.seconds(29)),
        )

# EXAM NOTE: This stack creates a production-ready RAG API:
#   API Gateway → Lambda → Bedrock (RetrieveAndGenerate)
# Key settings: Lambda timeout (120s), API GW timeout (29s max), throttling.
# In production, add: Cognito authorizer, WAF, custom domain, caching.
```

### 15.3 CloudFormation Template for Bedrock Guardrails

```python
import json

cfn_template = {
    "AWSTemplateFormatVersion": "2010-09-09",
    "Description": "Bedrock Guardrails for content safety",
    "Parameters": {
        "Environment": {
            "Type": "String",
            "Default": "production",
            "AllowedValues": ["development", "staging", "production"],
        }
    },
    "Resources": {
        "ContentSafetyGuardrail": {
            "Type": "AWS::Bedrock::Guardrail",
            "Properties": {
                "Name": {"Fn::Sub": "content-safety-${Environment}"},
                "Description": "Content safety guardrail for production applications",
                "BlockedInputMessaging": "Your request was blocked by our content policy.",
                "BlockedOutputsMessaging": "The response was filtered by our content policy.",
                "ContentPolicyConfig": {
                    "FiltersConfig": [
                        {"Type": "SEXUAL",        "InputStrength": "HIGH",   "OutputStrength": "HIGH"},
                        {"Type": "VIOLENCE",      "InputStrength": "HIGH",   "OutputStrength": "HIGH"},
                        {"Type": "HATE",          "InputStrength": "HIGH",   "OutputStrength": "HIGH"},
                        {"Type": "INSULTS",       "InputStrength": "MEDIUM", "OutputStrength": "HIGH"},
                        {"Type": "MISCONDUCT",    "InputStrength": "HIGH",   "OutputStrength": "HIGH"},
                        {"Type": "PROMPT_ATTACK", "InputStrength": "HIGH",   "OutputStrength": "NONE"},
                    ]
                },
                "SensitiveInformationPolicyConfig": {
                    "PiiEntitiesConfig": [
                        {"Type": "EMAIL",                       "Action": "ANONYMIZE"},
                        {"Type": "PHONE",                       "Action": "ANONYMIZE"},
                        {"Type": "US_SOCIAL_SECURITY_NUMBER",   "Action": "BLOCK"},
                        {"Type": "CREDIT_DEBIT_CARD_NUMBER",    "Action": "BLOCK"},
                    ]
                },
                "TopicPolicyConfig": {
                    "TopicsConfig": [
                        {
                            "Name": "InvestmentAdvice",
                            "Definition": "Providing specific investment or financial planning advice",
                            "Examples": [
                                "What stocks should I buy?",
                                "Is this a good investment?",
                            ],
                            "Type": "DENY",
                        }
                    ]
                },
                "WordPolicyConfig": {
                    "ManagedWordListsConfig": [{"Type": "PROFANITY"}],
                },
            },
        },
        "GuardrailVersion": {
            "Type": "AWS::Bedrock::GuardrailVersion",
            "Properties": {
                "GuardrailIdentifier": {"Fn::GetAtt": ["ContentSafetyGuardrail", "GuardrailId"]},
                "Description": "Initial production version",
            },
        },
    },
    "Outputs": {
        "GuardrailId": {
            "Value": {"Fn::GetAtt": ["ContentSafetyGuardrail", "GuardrailId"]},
            "Export": {"Name": {"Fn::Sub": "${AWS::StackName}-GuardrailId"}},
        },
        "GuardrailVersion": {
            "Value": {"Fn::GetAtt": ["GuardrailVersion", "Version"]},
        },
    },
}

# Save as template.json
with open("guardrail-template.json", "w") as f:
    json.dump(cfn_template, f, indent=2)

# EXAM NOTE: CloudFormation supports Bedrock resources natively:
#   AWS::Bedrock::Guardrail, AWS::Bedrock::GuardrailVersion,
#   AWS::Bedrock::KnowledgeBase, AWS::Bedrock::DataSource,
#   AWS::Bedrock::Agent, AWS::Bedrock::AgentAlias, AWS::Bedrock::Flow.
# Use Fn::GetAtt to reference resource attributes (GuardrailId, Version).
# Cross-stack references via Exports let you share resource IDs.
# Always parameterize environment to reuse templates across dev/staging/prod.
```

---

## Quick Reference: Key Exam Distinctions

| Topic | Key Detail |
|-------|-----------|
| **Converse vs InvokeModel** | Converse is model-agnostic and recommended; InvokeModel uses model-specific payloads |
| **Retrieve vs RetrieveAndGenerate** | Retrieve returns docs only; R&G does full RAG in one call |
| **bedrock vs bedrock-runtime** | Control plane (create/list) vs data plane (invoke/apply) |
| **Guardrail ANONYMIZE vs BLOCK** | ANONYMIZE replaces PII with placeholders; BLOCK stops the entire request |
| **Fixed vs Semantic chunking** | Fixed is fast/simple; Semantic uses embeddings for quality boundaries |
| **SageMaker vs Bedrock** | SageMaker = managed infrastructure; Bedrock = serverless/fully managed |
| **Step Functions direct integration** | Use `bedrock:invokeModel` resource ARN — no Lambda needed |
| **Batch inference** | Up to 50% cheaper; JSONL input/output in S3; no real-time guarantees |
| **AppConfig** | Dynamic model switching without redeployment; supports canary/linear rollouts |
| **VPC endpoints** | Two needed: `bedrock` (control plane) + `bedrock-runtime` (data plane) |
