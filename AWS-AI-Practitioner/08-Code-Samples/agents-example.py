"""
Bedrock Agents — Create, Prepare, and Invoke

Precondition: You have created:
  - An agent in the Bedrock console
  - An action group backed by a Lambda function
  - (optionally) attached a Knowledge Base
  - (optionally) attached a Guardrail
  - The agent has been prepared (`PrepareAgent`) and an alias created

This file shows how to invoke the agent from an application and stream its
response & trace events.
"""

import json
import uuid

import boto3


REGION = "us-east-1"
AGENT_ID = "AGENT0000"          # replace
AGENT_ALIAS_ID = "ALIAS0000"    # replace
client = boto3.client("bedrock-agent-runtime", region_name=REGION)


def invoke_agent(prompt: str, session_id: str | None = None) -> str:
    session_id = session_id or str(uuid.uuid4())
    response = client.invoke_agent(
        agentId=AGENT_ID,
        agentAliasId=AGENT_ALIAS_ID,
        sessionId=session_id,
        enableTrace=True,
        inputText=prompt,
    )
    completion = ""
    for event in response["completion"]:
        if "chunk" in event:
            completion += event["chunk"]["bytes"].decode("utf-8")
        elif "trace" in event:
            _render_trace(event["trace"])
    return completion


def _render_trace(trace: dict) -> None:
    """Pretty-print trace events for debugging / observability."""
    t = trace.get("trace", {})
    for key in ("preProcessingTrace", "orchestrationTrace", "postProcessingTrace"):
        section = t.get(key)
        if not section:
            continue
        for sub_key, sub_val in section.items():
            if sub_key == "rationale":
                print(f"[{key}.rationale] {sub_val.get('text','')[:200]}")
            elif sub_key == "invocationInput":
                ag = sub_val.get("actionGroupInvocationInput")
                kb = sub_val.get("knowledgeBaseLookupInput")
                if ag:
                    print(f"[action group] {ag['actionGroupName']} "
                          f".{ag.get('function') or ag.get('apiPath')} "
                          f"params={ag.get('parameters')}")
                if kb:
                    print(f"[kb lookup] {kb['text'][:120]}")
            elif sub_key == "observation":
                obs_type = sub_val.get("type")
                print(f"[observation:{obs_type}] "
                      f"{json.dumps(sub_val, default=str)[:200]}")


if __name__ == "__main__":
    print(invoke_agent("I need to check the status of order 123 and open a ticket if delayed."))
