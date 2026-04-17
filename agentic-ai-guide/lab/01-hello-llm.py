"""
Lab 01 — Hello LLM (no agent, no tools)

Goal: confirm your credentials work and you can talk to an LLM.

This is the single-shot baseline. Later labs wrap this same LLM in an
agent loop.
"""

import os
from dotenv import load_dotenv

load_dotenv()


def hello_openai() -> str:
    from langchain_openai import ChatOpenAI

    llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
    return llm.invoke("Say hello in one sentence.").content


def hello_bedrock() -> str:
    from langchain_aws import ChatBedrockConverse

    llm = ChatBedrockConverse(
        model="us.anthropic.claude-sonnet-4-5-20250929-v1:0",
        region_name=os.getenv("AWS_REGION", "us-east-1"),
    )
    return llm.invoke("Say hello in one sentence.").content


if __name__ == "__main__":
    if os.getenv("OPENAI_API_KEY"):
        print("[OpenAI]", hello_openai())
    else:
        print("[Bedrock]", hello_bedrock())
