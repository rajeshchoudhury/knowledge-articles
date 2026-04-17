"""
Lab 02 — Your first LangChain ReAct agent

Scenario: a tiny "insurance helpdesk" agent that can
  1. look up a policy by id (custom tool)
  2. compute a premium (custom tool)
  3. do arithmetic (prebuilt-like calculator tool)

What to notice:
- Tools are plain Python functions decorated with @tool.
- The LLM decides at runtime which tool to call, and in what order.
- Framework handles the ReAct loop (THINK → ACT → OBSERVE → RESPOND).

Run:
    python 02-langchain-agent.py
"""

import os
from dotenv import load_dotenv
from langchain_core.tools import tool
from langgraph.prebuilt import create_react_agent

load_dotenv()


# ---------- 1. CUSTOM TOOLS ---------------------------------------------

FAKE_POLICY_DB = {
    "P-1001": {"holder": "Alice",   "type": "AUTO",  "sum_insured": 500_000},
    "P-1002": {"holder": "Bob",     "type": "HOME",  "sum_insured": 2_000_000},
    "P-1003": {"holder": "Charlie", "type": "LIFE",  "sum_insured": 10_000_000},
}

RATE_PER_LAKH = {"AUTO": 1200, "HOME": 350, "LIFE": 800}


@tool
def get_policy(policy_id: str) -> dict:
    """Return the policy record for a given policy_id (e.g. P-1001).
    If not found returns {'error': 'not_found'}."""
    return FAKE_POLICY_DB.get(policy_id, {"error": "not_found"})


@tool
def compute_premium(policy_type: str, sum_insured: float) -> dict:
    """Compute annual premium. policy_type must be AUTO | HOME | LIFE.
    sum_insured is in rupees. Returns {'premium': number}."""
    policy_type = policy_type.upper()
    if policy_type not in RATE_PER_LAKH:
        return {"error": f"unknown policy type {policy_type}"}
    lakhs = sum_insured / 100_000
    return {"premium": round(lakhs * RATE_PER_LAKH[policy_type], 2)}


@tool
def calculator(expression: str) -> str:
    """Evaluate a simple arithmetic expression, e.g. '12 * (3 + 4)'."""
    allowed = set("0123456789+-*/(). ")
    if not set(expression) <= allowed:
        return "error: illegal characters"
    return str(eval(expression))  # safe because of whitelist check


# ---------- 2. PICK A MODEL ---------------------------------------------

def build_model():
    if os.getenv("OPENAI_API_KEY"):
        from langchain_openai import ChatOpenAI
        return ChatOpenAI(model="gpt-4o-mini", temperature=0)
    from langchain_aws import ChatBedrockConverse
    return ChatBedrockConverse(
        model="us.anthropic.claude-sonnet-4-5-20250929-v1:0",
        region_name=os.getenv("AWS_REGION", "us-east-1"),
    )


# ---------- 3. BUILD & RUN THE AGENT ------------------------------------

SYSTEM = """You are an insurance helpdesk agent.
You help users look up their policy and compute premiums.
Always use tools for policy lookup and premium math — never guess.
Be concise and friendly.
"""


def main() -> None:
    agent = create_react_agent(
        model=build_model(),
        tools=[get_policy, compute_premium, calculator],
        prompt=SYSTEM,
    )

    questions = [
        "What is on policy P-1002?",
        "Compute the premium for a HOME policy with sum insured 2,000,000.",
        "For policy P-1003, what would the annual premium be?",
    ]

    for q in questions:
        print(f"\n=== USER: {q}")
        result = agent.invoke({"messages": [("user", q)]})
        for m in result["messages"]:
            role = m.type.upper()
            content = m.content if isinstance(m.content, str) else str(m.content)
            print(f"  [{role}] {content[:300]}")


if __name__ == "__main__":
    main()
