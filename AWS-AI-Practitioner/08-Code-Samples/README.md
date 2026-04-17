# Code Samples

All examples use the **AWS SDK for Python (boto3)**. Install:

```bash
pip install boto3
```

Configure credentials via `aws configure`, an IAM role, or environment variables.

> **Request model access first** — in the Bedrock console → Model access → request the models you plan to use (Anthropic Claude, Amazon Nova, Titan Embeddings, etc.).

Files
- `bedrock-examples.py` — Converse API, streaming, embeddings, image gen, guardrails, prompt caching.
- `rag-examples.py` — Bedrock Knowledge Base creation + query.
- `agents-example.py` — Invoke a Bedrock Agent with an action group.
- `sagemaker-examples.py` — Training, deployment, invocation, Clarify.
- `prompt-engineering-examples.py` — zero/few-shot/CoT patterns.
