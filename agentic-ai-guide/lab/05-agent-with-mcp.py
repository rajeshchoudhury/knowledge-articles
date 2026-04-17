"""
Lab 05 — Plug in an MCP server (filesystem)

We use the official MCP filesystem server (Node). The agent gets new tools
(`read_file`, `write_file`, `list_directory`, …) without any glue code —
MCP is the glue.

Prereq:
    npm -v           # 18+
    npx -y @modelcontextprotocol/server-filesystem ./  # verify once

Run:
    python 05-agent-with-mcp.py
"""

import os
from dotenv import load_dotenv
from strands import Agent
from strands.tools.mcp import MCPClient
from mcp import stdio_client, StdioServerParameters

load_dotenv()

# Spawn the MCP filesystem server (Node) and give it access to the lab folder
fs_client = MCPClient(lambda: stdio_client(
    StdioServerParameters(
        command="npx",
        args=["-y", "@modelcontextprotocol/server-filesystem", os.path.abspath(".")],
    )
))


SYSTEM = """You are a developer assistant with filesystem tools via MCP.
You can list, read, and write files under the current project.
Always confirm before writing. Prefer minimal, precise edits.
"""


def main() -> None:
    with fs_client:
        tools = fs_client.list_tools_sync()
        print(f"Discovered {len(tools)} MCP tools: {[t.tool_name for t in tools]}")

        agent = Agent(
            model="us.anthropic.claude-sonnet-4-5-20250929-v1:0",
            system_prompt=SYSTEM,
            tools=tools,
        )

        for q in [
            "List the files in the current directory.",
            "Read the file 01-hello-llm.py and summarize what it does in 2 lines.",
        ]:
            print(f"\n=== USER: {q}")
            print(f"=== AGENT: {agent(q)}")


if __name__ == "__main__":
    main()
