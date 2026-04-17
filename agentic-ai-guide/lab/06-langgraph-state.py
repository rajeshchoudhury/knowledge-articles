"""
Lab 06 — Explicit state machine with LangGraph

When your agent needs branching, retries, or multi-agent hand-offs, a
prebuilt ReAct agent isn't enough. LangGraph lets you draw the state
machine explicitly:

     ┌──────────┐     need tool?      ┌───────┐
     │  AGENT   │────────────────────▶│ TOOLS │
     └────┬─────┘                     └───┬───┘
          │ done                          │
          ▼                               │
       [END]  ◀───────────────────────────┘

Run:
    python 06-langgraph-state.py
"""

import os
from typing import Annotated, TypedDict
from dotenv import load_dotenv
from langchain_core.tools import tool
from langchain_core.messages import BaseMessage
from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import add_messages
from langgraph.prebuilt import ToolNode, tools_condition

load_dotenv()


# ---------- 1. TOOLS ----------------------------------------------------

@tool
def get_policy(policy_id: str) -> dict:
    """Return the policy record for a given policy_id."""
    db = {"P-1001": {"holder": "Alice", "sum_insured": 500_000}}
    return db.get(policy_id, {"error": "not_found"})


# ---------- 2. STATE ----------------------------------------------------

class AgentState(TypedDict):
    messages: Annotated[list[BaseMessage], add_messages]


# ---------- 3. MODEL ----------------------------------------------------

def build_model():
    if os.getenv("OPENAI_API_KEY"):
        from langchain_openai import ChatOpenAI
        llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)
    else:
        from langchain_aws import ChatBedrockConverse
        llm = ChatBedrockConverse(
            model="us.anthropic.claude-sonnet-4-5-20250929-v1:0",
            region_name=os.getenv("AWS_REGION", "us-east-1"),
        )
    return llm.bind_tools([get_policy])


# ---------- 4. NODES ----------------------------------------------------

model = build_model()


def agent_node(state: AgentState) -> AgentState:
    """The 'think' step: LLM decides to answer or call a tool."""
    return {"messages": [model.invoke(state["messages"])]}


tool_node = ToolNode([get_policy])


# ---------- 5. GRAPH ----------------------------------------------------

graph = StateGraph(AgentState)
graph.add_node("agent", agent_node)
graph.add_node("tools", tool_node)
graph.add_edge(START, "agent")
graph.add_conditional_edges("agent", tools_condition, {"tools": "tools", END: END})
graph.add_edge("tools", "agent")
app = graph.compile()


# ---------- 6. RUN ------------------------------------------------------

if __name__ == "__main__":
    print("Graph nodes:", list(app.get_graph().nodes))
    print("Graph edges:")
    for e in app.get_graph().edges:
        print(f"  {e.source} → {e.target}")

    q = "Who is the holder of policy P-1001?"
    print(f"\nUSER: {q}")
    for step in app.stream({"messages": [("user", q)]}, stream_mode="values"):
        last = step["messages"][-1]
        print(f"  [{last.type}] {last.content!r}")
