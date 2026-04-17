"""
Amazon Bedrock — Example Calls

Covers:
  1. Converse API (unified chat) with Anthropic Claude and Amazon Nova
  2. Streaming responses
  3. Tool (function) calling
  4. Text embeddings with Amazon Titan Embeddings V2
  5. Image generation with Amazon Nova Canvas / Titan Image Generator
  6. Apply Guardrail (standalone and in Converse)
  7. List foundation models
  8. Prompt caching (Claude and Nova via system block cache points)

Before running:
  - pip install boto3
  - aws configure
  - In the Bedrock console, request access to each model used.
"""

import base64
import json
from pathlib import Path

import boto3


REGION = "us-east-1"
bedrock = boto3.client("bedrock", region_name=REGION)
runtime = boto3.client("bedrock-runtime", region_name=REGION)


# 1. Converse API — unified across chat models
def converse_claude_haiku(user_message: str) -> str:
    response = runtime.converse(
        modelId="anthropic.claude-3-haiku-20240307-v1:0",
        system=[{"text": "You are a concise and friendly assistant."}],
        messages=[{"role": "user", "content": [{"text": user_message}]}],
        inferenceConfig={"temperature": 0.2, "maxTokens": 400, "topP": 0.9},
    )
    return response["output"]["message"]["content"][0]["text"]


def converse_nova_pro(user_message: str) -> str:
    response = runtime.converse(
        modelId="amazon.nova-pro-v1:0",
        system=[{"text": "You are a precise research assistant."}],
        messages=[{"role": "user", "content": [{"text": user_message}]}],
        inferenceConfig={"temperature": 0.0, "maxTokens": 800},
    )
    return response["output"]["message"]["content"][0]["text"]


# 2. Streaming
def converse_stream(user_message: str) -> None:
    response = runtime.converse_stream(
        modelId="anthropic.claude-3-haiku-20240307-v1:0",
        messages=[{"role": "user", "content": [{"text": user_message}]}],
        inferenceConfig={"temperature": 0.3, "maxTokens": 500},
    )
    for event in response["stream"]:
        if "contentBlockDelta" in event:
            delta = event["contentBlockDelta"]["delta"]
            if "text" in delta:
                print(delta["text"], end="", flush=True)
    print()


# 3. Tool (function) calling via Converse
TOOL_SPEC = {
    "toolSpec": {
        "name": "get_weather",
        "description": "Get current weather for a city.",
        "inputSchema": {
            "json": {
                "type": "object",
                "properties": {
                    "city": {"type": "string", "description": "City name"}
                },
                "required": ["city"],
            }
        },
    }
}


def tool_use_loop(user_message: str) -> str:
    messages = [{"role": "user", "content": [{"text": user_message}]}]
    for _ in range(5):
        resp = runtime.converse(
            modelId="anthropic.claude-3-haiku-20240307-v1:0",
            messages=messages,
            toolConfig={"tools": [TOOL_SPEC]},
        )
        msg = resp["output"]["message"]
        messages.append(msg)

        if resp["stopReason"] == "tool_use":
            for block in msg["content"]:
                if "toolUse" in block:
                    tu = block["toolUse"]
                    # Fake implementation:
                    result = {"temp_f": 74, "condition": "sunny", "city": tu["input"]["city"]}
                    messages.append({
                        "role": "user",
                        "content": [{
                            "toolResult": {
                                "toolUseId": tu["toolUseId"],
                                "content": [{"json": result}],
                            }
                        }],
                    })
        else:
            # End of loop — extract text
            return "".join(
                b.get("text", "") for b in msg["content"] if "text" in b
            )
    return "(tool-use loop limit reached)"


# 4. Embeddings with Titan V2
def embed_titan(text: str) -> list[float]:
    body = {"inputText": text, "dimensions": 1024, "normalize": True}
    resp = runtime.invoke_model(
        modelId="amazon.titan-embed-text-v2:0",
        body=json.dumps(body),
        contentType="application/json",
    )
    out = json.loads(resp["body"].read())
    return out["embedding"]


# 5. Image generation with Amazon Nova Canvas
def generate_image(prompt: str, out_path: str = "image.png") -> None:
    body = {
        "taskType": "TEXT_IMAGE",
        "textToImageParams": {"text": prompt},
        "imageGenerationConfig": {
            "numberOfImages": 1,
            "height": 1024,
            "width": 1024,
            "cfgScale": 8.0,
            "seed": 42,
        },
    }
    resp = runtime.invoke_model(
        modelId="amazon.nova-canvas-v1:0",
        body=json.dumps(body),
        contentType="application/json",
    )
    out = json.loads(resp["body"].read())
    img_b64 = out["images"][0]
    Path(out_path).write_bytes(base64.b64decode(img_b64))
    print(f"Saved {out_path}")


# 6. Guardrail — standalone ApplyGuardrail
def apply_guardrail_example(guardrail_id: str, version: str, text: str) -> dict:
    return runtime.apply_guardrail(
        guardrailIdentifier=guardrail_id,
        guardrailVersion=version,
        source="INPUT",
        content=[{"text": {"text": text}}],
    )


# Guardrail within Converse
def converse_with_guardrail(user_message: str, guardrail_id: str, version: str) -> str:
    resp = runtime.converse(
        modelId="anthropic.claude-3-haiku-20240307-v1:0",
        messages=[{"role": "user", "content": [{"text": user_message}]}],
        guardrailConfig={
            "guardrailIdentifier": guardrail_id,
            "guardrailVersion": version,
            "trace": "enabled",
        },
    )
    return resp["output"]["message"]["content"][0]["text"]


# 7. List foundation models (control-plane client)
def list_models() -> None:
    paginator = bedrock.get_paginator("list_foundation_models")
    for page in paginator.paginate():
        for m in page["modelSummaries"]:
            print(f"{m['modelId']:70s} providers={m['providerName']}")


# 8. Prompt caching (Claude / Nova). Add cachePoint blocks to stable prefixes.
def converse_with_cache(system_context: str, user_question: str) -> str:
    resp = runtime.converse(
        modelId="anthropic.claude-3-5-sonnet-20240620-v1:0",
        system=[
            {"text": system_context},
            {"cachePoint": {"type": "default"}},  # cache everything above
        ],
        messages=[{"role": "user", "content": [{"text": user_question}]}],
        inferenceConfig={"temperature": 0.2, "maxTokens": 600},
    )
    usage = resp.get("usage", {})
    print(
        f"input={usage.get('inputTokens')} cacheRead={usage.get('cacheReadInputTokens')} "
        f"cacheWrite={usage.get('cacheWriteInputTokens')} output={usage.get('outputTokens')}"
    )
    return resp["output"]["message"]["content"][0]["text"]


if __name__ == "__main__":
    print("Converse (Haiku):", converse_claude_haiku("Summarize RAG in 2 sentences."))
    print()
    print("Converse (Nova Pro):", converse_nova_pro("What is vector search?"))
    print()
    print("--- streaming ---")
    converse_stream("List 3 benefits of Amazon Bedrock.")
    print()
    print("--- tool use ---")
    print(tool_use_loop("What's the weather in Seattle?"))
    print()
    vec = embed_titan("Amazon Bedrock is a managed GenAI service.")
    print(f"Embedding length: {len(vec)}")
