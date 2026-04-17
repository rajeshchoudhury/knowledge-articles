"""
Amazon Bedrock Knowledge Bases — RAG Examples

Preconditions (do via console or CloudFormation):
  1. Create an S3 bucket and upload PDFs / docs.
  2. Create a vector store (OpenSearch Serverless collection is easiest).
  3. Create a Bedrock Knowledge Base pointing at the bucket & collection,
     with Titan Embeddings V2 as the embedding model.
  4. Sync the data source.
  5. Note the KB ID and model ARN.

This file shows runtime querying only.
"""

import json

import boto3


REGION = "us-east-1"
KB_ID = "KB1234567890"   # replace
MODEL_ARN = "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-haiku-20240307-v1:0"
runtime = boto3.client("bedrock-agent-runtime", region_name=REGION)


# 1. RetrieveAndGenerate — fully managed RAG in one call
def ask(question: str) -> dict:
    resp = runtime.retrieve_and_generate(
        input={"text": question},
        retrieveAndGenerateConfiguration={
            "type": "KNOWLEDGE_BASE",
            "knowledgeBaseConfiguration": {
                "knowledgeBaseId": KB_ID,
                "modelArn": MODEL_ARN,
                "retrievalConfiguration": {
                    "vectorSearchConfiguration": {
                        "numberOfResults": 5,
                        "overrideSearchType": "HYBRID",
                    }
                },
                "generationConfiguration": {
                    "promptTemplate": {
                        "textPromptTemplate": (
                            "You are a helpful assistant.\n"
                            "Use ONLY the following CONTEXT to answer.\n"
                            "If the answer is not in the CONTEXT, say you don't know.\n"
                            "Cite sources with numbered references.\n\n"
                            "CONTEXT:\n$search_results$\n\n"
                            "QUESTION: $query$"
                        )
                    },
                    "inferenceConfig": {
                        "textInferenceConfig": {
                            "temperature": 0.0,
                            "maxTokens": 600,
                        }
                    },
                },
            },
        },
    )
    return resp


def pretty(resp: dict) -> None:
    print("Answer:", resp["output"]["text"])
    for i, c in enumerate(resp.get("citations", []), 1):
        for ref in c.get("retrievedReferences", []):
            print(f"  [{i}] {ref['location']}: {ref['content']['text'][:120]}...")


# 2. Retrieve only — when you want to construct the prompt yourself
def retrieve_only(query: str) -> list[dict]:
    resp = runtime.retrieve(
        knowledgeBaseId=KB_ID,
        retrievalQuery={"text": query},
        retrievalConfiguration={
            "vectorSearchConfiguration": {"numberOfResults": 8}
        },
    )
    return resp["retrievalResults"]


# 3. Filtering by metadata (requires metadata.json in the KB source)
def ask_with_filter(question: str, tenant_id: str) -> dict:
    return runtime.retrieve_and_generate(
        input={"text": question},
        retrieveAndGenerateConfiguration={
            "type": "KNOWLEDGE_BASE",
            "knowledgeBaseConfiguration": {
                "knowledgeBaseId": KB_ID,
                "modelArn": MODEL_ARN,
                "retrievalConfiguration": {
                    "vectorSearchConfiguration": {
                        "numberOfResults": 5,
                        "filter": {"equals": {"key": "tenant_id", "value": tenant_id}},
                    }
                },
            },
        },
    )


if __name__ == "__main__":
    pretty(ask("What is our leave policy for new hires?"))
    print("---")
    for r in retrieve_only("onboarding checklist"):
        print(f"{r['score']:.3f} {r['location']}")
