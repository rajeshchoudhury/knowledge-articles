"""
FastAPI sidecar that exposes the lab-04 agent over HTTP.
Used by lab 07 (Java / Spring Boot client).

Run:
    uvicorn agent_server:app --port 8000 --reload
"""

import os
from dotenv import load_dotenv
from fastapi import FastAPI
from pydantic import BaseModel
from langchain_core.tools import tool
from langgraph.prebuilt import create_react_agent
from langgraph.checkpoint.memory import MemorySaver

load_dotenv()

app = FastAPI(title="Agent Sidecar")


# ---------- tools -------------------------------------------------------

POLICY_DB = {
    "P-1001": {"holder": "Alice", "type": "AUTO", "sum_insured": 500_000},
    "P-1002": {"holder": "Bob",   "type": "HOME", "sum_insured": 2_000_000},
}


@tool
def get_policy(policy_id: str) -> dict:
    """Return the policy record for a given policy_id."""
    return POLICY_DB.get(policy_id, {"error": "not_found"})


# ---------- model -------------------------------------------------------

def build_model():
    if os.getenv("OPENAI_API_KEY"):
        from langchain_openai import ChatOpenAI
        return ChatOpenAI(model="gpt-4o-mini", temperature=0)
    from langchain_aws import ChatBedrockConverse
    return ChatBedrockConverse(
        model="us.anthropic.claude-sonnet-4-5-20250929-v1:0",
        region_name=os.getenv("AWS_REGION", "us-east-1"),
    )


agent = create_react_agent(
    model=build_model(),
    tools=[get_policy],
    prompt="You are an insurance helpdesk. Use tools for lookups.",
    checkpointer=MemorySaver(),
)


# ---------- HTTP API ----------------------------------------------------

class ChatIn(BaseModel):
    thread_id: str
    message: str


class ChatOut(BaseModel):
    reply: str
    steps: int


@app.get("/health")
def health() -> dict:
    return {"status": "ok"}


@app.post("/chat", response_model=ChatOut)
def chat(req: ChatIn) -> ChatOut:
    cfg = {"configurable": {"thread_id": req.thread_id}}
    result = agent.invoke({"messages": [("user", req.message)]}, config=cfg)
    return ChatOut(reply=result["messages"][-1].content, steps=len(result["messages"]))
