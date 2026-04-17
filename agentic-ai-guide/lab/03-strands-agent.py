"""
Lab 03 — Same agent, rewritten with AWS Strands

Compare this to lab 02. Same business logic, dramatically less boilerplate.
Strands is "model-driven": you just pass tools + prompt and call the Agent.

Run:
    python 03-strands-agent.py
"""

import os
from dotenv import load_dotenv
from strands import Agent, tool
from strands_tools import calculator  # prebuilt skill/tool

load_dotenv()


# ---------- 1. CUSTOM TOOLS (identical to lab 02) -----------------------

FAKE_POLICY_DB = {
    "P-1001": {"holder": "Alice",   "type": "AUTO",  "sum_insured": 500_000},
    "P-1002": {"holder": "Bob",     "type": "HOME",  "sum_insured": 2_000_000},
    "P-1003": {"holder": "Charlie", "type": "LIFE",  "sum_insured": 10_000_000},
}

RATE_PER_LAKH = {"AUTO": 1200, "HOME": 350, "LIFE": 800}


@tool
def get_policy(policy_id: str) -> dict:
    """Return the policy record for a given policy_id (e.g. P-1001)."""
    return FAKE_POLICY_DB.get(policy_id, {"error": "not_found"})


@tool
def compute_premium(policy_type: str, sum_insured: float) -> dict:
    """Compute annual premium. policy_type = AUTO | HOME | LIFE.
    sum_insured in rupees. Returns {'premium': number}."""
    policy_type = policy_type.upper()
    if policy_type not in RATE_PER_LAKH:
        return {"error": f"unknown policy type {policy_type}"}
    return {"premium": round((sum_insured / 100_000) * RATE_PER_LAKH[policy_type], 2)}


# ---------- 2. BUILD & RUN ---------------------------------------------

SYSTEM = """You are an insurance helpdesk agent.
You help users look up their policy and compute premiums.
Always use tools for policy lookup and premium math — never guess.
Be concise and friendly.
"""


def main() -> None:
    agent = Agent(
        model="us.anthropic.claude-sonnet-4-5-20250929-v1:0",  # Bedrock inference profile
        system_prompt=SYSTEM,
        tools=[get_policy, compute_premium, calculator],
    )

    for q in [
        "What is on policy P-1002?",
        "Compute the premium for a HOME policy with sum insured 2,000,000.",
        "For policy P-1003, what would the annual premium be?",
    ]:
        print(f"\n=== USER: {q}")
        response = agent(q)
        print(f"=== AGENT: {response}")


if __name__ == "__main__":
    main()
