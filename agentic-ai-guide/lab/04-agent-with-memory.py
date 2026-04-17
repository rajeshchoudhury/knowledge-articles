"""
Lab 04 — Add Memory (short-term + long-term)

Short-term: multi-turn conversation — agent remembers what user said before.
Long-term : a FAISS vector store acts as a "knowledge base" that the agent
            can retrieve from via a `kb_search` tool (RAG pattern).

Run:
    python 04-agent-with-memory.py
"""

import os
from dotenv import load_dotenv
from langchain_core.tools import tool
from langchain_core.documents import Document
from langchain_community.vectorstores import FAISS
from langgraph.prebuilt import create_react_agent
from langgraph.checkpoint.memory import MemorySaver

load_dotenv()


# ---------- 1. LONG-TERM MEMORY: build a tiny vector KB -----------------

def build_embeddings():
    if os.getenv("OPENAI_API_KEY"):
        from langchain_openai import OpenAIEmbeddings
        return OpenAIEmbeddings(model="text-embedding-3-small")
    from langchain_aws import BedrockEmbeddings
    return BedrockEmbeddings(model_id="amazon.titan-embed-text-v2:0")


KNOWLEDGE_BASE = [
    "AUTO policies cover own damage, third-party, and theft. Claims require FIR within 24h for theft.",
    "HOME policies cover fire, flood, earthquake. Burglary cover is optional add-on.",
    "LIFE policies have a 15-day free-look period. Death benefit is tax-free under sec 10(10D).",
    "All claims must be intimated within 7 days via the customer portal or helpdesk.",
]

docs = [Document(page_content=t, metadata={"id": i}) for i, t in enumerate(KNOWLEDGE_BASE)]
vs = FAISS.from_documents(docs, build_embeddings())


# ---------- 2. TOOLS ----------------------------------------------------

@tool
def kb_search(query: str) -> list[str]:
    """Search the insurance knowledge base and return the top 3 chunks."""
    hits = vs.similarity_search(query, k=3)
    return [h.page_content for h in hits]


@tool
def get_policy(policy_id: str) -> dict:
    """Return the policy record for a given policy_id (e.g. P-1001)."""
    db = {
        "P-1001": {"holder": "Alice", "type": "AUTO",  "sum_insured": 500_000},
        "P-1002": {"holder": "Bob",   "type": "HOME",  "sum_insured": 2_000_000},
    }
    return db.get(policy_id, {"error": "not_found"})


# ---------- 3. MODEL ----------------------------------------------------

def build_model():
    if os.getenv("OPENAI_API_KEY"):
        from langchain_openai import ChatOpenAI
        return ChatOpenAI(model="gpt-4o-mini", temperature=0)
    from langchain_aws import ChatBedrockConverse
    return ChatBedrockConverse(
        model="us.anthropic.claude-sonnet-4-5-20250929-v1:0",
        region_name=os.getenv("AWS_REGION", "us-east-1"),
    )


# ---------- 4. AGENT WITH CHECKPOINTER (short-term memory) --------------

SYSTEM = """You are an insurance helpdesk.
Use `kb_search` to answer policy questions from the knowledge base.
Use `get_policy` to look up specific policies.
If the user refers to something they said earlier, use the conversation
history to answer coherently.
"""


def main() -> None:
    checkpointer = MemorySaver()  # stores conversation per thread_id
    agent = create_react_agent(
        model=build_model(),
        tools=[kb_search, get_policy],
        prompt=SYSTEM,
        checkpointer=checkpointer,
    )

    cfg = {"configurable": {"thread_id": "user-42"}}

    turns = [
        "Hi, my policy id is P-1001.",
        "What does my policy cover?",
        "And what is the free-look period for LIFE policies?",
        "Remind me — whose policy did I mention earlier?",
    ]

    for q in turns:
        print(f"\n=== USER: {q}")
        out = agent.invoke({"messages": [("user", q)]}, config=cfg)
        print(f"=== AGENT: {out['messages'][-1].content}")


if __name__ == "__main__":
    main()
