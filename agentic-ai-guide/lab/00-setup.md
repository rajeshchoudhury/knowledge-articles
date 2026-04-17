# Lab 00 — Environment Setup

This lab is run **locally on your laptop**. Everything works on macOS, Linux
or WSL2. You need:

- Python 3.10+
- Node.js 18+ (only for MCP servers in Lab 05)
- JDK 17 (only for Lab 07)
- An API key for **one** of:
  - AWS Bedrock (recommended — used by both LangChain and Strands)
  - OpenAI (`OPENAI_API_KEY`)
  - Anthropic (`ANTHROPIC_API_KEY`)

---

## 1. Create a virtualenv

```bash
cd agentic-ai-guide/lab
python3 -m venv .venv
source .venv/bin/activate
```

## 2. Install Python dependencies

```bash
pip install -r requirements.txt
```

`requirements.txt` is already in this folder. It pins:

```
langchain>=0.3
langchain-core>=0.3
langchain-openai>=0.2
langchain-anthropic>=0.2
langchain-aws>=0.2
langgraph>=0.2
strands-agents>=0.1
strands-agents-tools>=0.1
mcp>=1.0
faiss-cpu>=1.8
python-dotenv>=1.0
fastapi>=0.115
uvicorn>=0.30
```

## 3. Configure credentials

Create a `.env` file in `lab/` (next to `requirements.txt`):

```env
# Pick ONE provider
OPENAI_API_KEY=sk-...
# ANTHROPIC_API_KEY=sk-ant-...
# AWS_REGION=us-east-1           # for Bedrock
# AWS_PROFILE=default            # for Bedrock
```

For AWS Bedrock: make sure you've **enabled model access** in the Bedrock
console for Claude or Nova.

## 4. Smoke test

```bash
python 01-hello-llm.py
```

Expected output (example):

```
Hello! I'm an AI assistant. How can I help you today?
```

If that prints, you're ready for Lab 02.

---

## Troubleshooting

| Symptom                              | Fix                                            |
| ------------------------------------ | ---------------------------------------------- |
| `AuthenticationError`                | Check `.env` values; `source .venv/bin/activate`|
| `AccessDeniedException` (Bedrock)    | Enable the model in the AWS Bedrock console    |
| `ModuleNotFoundError: strands`       | `pip install strands-agents strands-agents-tools` |
| Slow first call                      | Cold-start for Bedrock; retry                  |
