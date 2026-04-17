# D1.1 — Agentic Loops & Core API

> **Weight on exam**: ~8 of the 60 questions (Domain 1 is 27 %, and this subtopic is ~½ of Domain 1).

## 1. Why This Topic Matters

An **agentic loop** is the beating heart of every production Claude application. Every other topic on this exam — multi-agent orchestration, hooks, session management, context handling — sits on top of the agentic loop. If you understand the loop, every downstream question becomes easier. If you don't, you will fail Domain 1 and almost certainly fail the exam.

Unlike a plain chat completion (one request, one response, done), an agentic loop lets Claude **iteratively plan, act, observe, and decide whether to continue**. That iterative control flow is what makes agents "agentic." The exam writer knows this and tests it relentlessly.

## 2. The Canonical Loop

### 2.1 Lifecycle (conceptual)

```
┌──────────────────────────────────────────────────────────┐
│                                                          │
│   1. USER sends a message (+ tools available)            │
│                          │                               │
│                          ▼                               │
│   2. CLAUDE responds with either:                        │
│         • text content  (stop_reason = "end_turn")       │
│         • tool call     (stop_reason = "tool_use")       │
│                          │                               │
│                          ▼                               │
│   3. If tool_use:                                        │
│         a. YOU execute the tool                          │
│         b. YOU append {type: "tool_result"} to messages  │
│         c. GOTO step 2                                   │
│                                                          │
│   4. If end_turn: exit, return the final text            │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### 2.2 The control signal: `stop_reason`

`stop_reason` is the **only reliable signal** the Anthropic API exposes for "is Claude done?" It can take several values; the two that matter most are:

| `stop_reason` value | Meaning | Loop action |
|---|---|---|
| `"tool_use"` | Claude wants to call a tool | **Continue** the loop |
| `"end_turn"` | Claude is done (output is text-only) | **Exit** the loop |
| `"max_tokens"` | Response truncated by `max_tokens` cap | Either raise or retry with higher cap |
| `"stop_sequence"` | Custom stop sequence hit | Usually exit |

> **Exam trap #1**: The exam will ask which field you should check. The answer is *always* `stop_reason`. Distractor answers will tempt you to inspect `content[0].text` or a custom flag Claude "says" in its output. Don't fall for it.

### 2.3 The canonical Python implementation

```python
import anthropic

client = anthropic.Anthropic()

tools = [{
    "name": "lookup_customer",
    "description": "Look up customer by email",
    "input_schema": {
        "type": "object",
        "properties": {"email": {"type": "string"}},
        "required": ["email"]
    }
}]

messages = [{"role": "user", "content": "Find customer [email protected]"}]

while True:
    response = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=4096,
        tools=tools,
        messages=messages,
    )

    # --- THE ONE LINE THAT MATTERS ---
    if response.stop_reason == "end_turn":
        break

    if response.stop_reason == "tool_use":
        tool_block = next(b for b in response.content if b.type == "tool_use")
        tool_result = execute_tool(tool_block.name, tool_block.input)

        messages.append({"role": "assistant", "content": response.content})
        messages.append({
            "role": "user",
            "content": [{
                "type": "tool_result",
                "tool_use_id": tool_block.id,
                "content": tool_result,
            }]
        })
```

**Why this is correct:**
- Termination is deterministic (the model's own structured signal).
- Tool results are threaded back in the exact format the API expects (`tool_result` with `tool_use_id`).
- No arbitrary iteration caps, no natural-language parsing.

## 3. Four Anti-Patterns (the exam WILL test these)

### 3.1 ❌ Parsing natural language for termination

```python
# DO NOT DO THIS
while True:
    response = get_response()
    text = response.content[0].text
    if "task complete" in text.lower() or "i'm done" in text.lower():
        break
```

**Why it's wrong**:
- Claude may phrase completion differently every time: "Task complete", "All done", "Finished", "Nothing more to do."
- The model may say "done" in the middle of a longer message and then keep going.
- Localization breaks it entirely (Spanish output? German?).
- Text content is **for the user**, not for control flow.

### 3.2 ❌ Arbitrary iteration caps as the *primary* stop mechanism

```python
# DO NOT DO THIS
for i in range(10):                           # "just stop after 10 tool calls"
    response = get_response()
    handle(response)
```

**Why it's wrong**:
- Genuinely complex tasks (e.g., exploring a codebase) may need 25+ iterations.
- Trivial tasks may complete in 2 iterations — the cap doesn't help.
- You end up with agents that are cut off mid-action OR loop pointlessly until the cap hits.

**Defensive use**: An iteration cap is fine as a *safety net* (e.g., `if iterations > 100: raise`), but **never** as the primary signal.

### 3.3 ❌ Checking token counts

```python
# DO NOT DO THIS
if response.usage.output_tokens < 50:
    break
```

Claude sometimes emits a short text block mid-task ("Let me check..."). Token count is not correlated with task completion.

### 3.4 ❌ Checking whether `content` contains any `text` block

```python
# DO NOT DO THIS
if any(b.type == "text" for b in response.content):
    break
```

Claude can emit **both** text ("I'll look this up...") **and** a `tool_use` block in the same response. If you bail on any text, you skip tool calls.

## 4. `content` Blocks — What's Inside a Response

A single Claude response's `content` is a list of typed blocks. Common types:

| Block type | Purpose |
|---|---|
| `"text"` | Natural-language output to the user |
| `"tool_use"` | A structured tool invocation with `id`, `name`, `input` |
| `"thinking"` | (Extended-thinking models only) Internal reasoning that you generally do not surface |
| `"tool_result"` | (User → assistant direction only) Result of a tool call |

**Critical rule**: When you append the assistant's response back into `messages`, you must include the **entire `response.content` list**, not just the tool_use or just the text. Chopping out blocks breaks the next turn.

## 5. Advanced: Parallel Tool Calls

A single response may contain **multiple `tool_use` blocks**. This happens when Claude decides to call two independent tools simultaneously:

```json
{
  "stop_reason": "tool_use",
  "content": [
    {"type": "text", "text": "Let me check the weather and flights in parallel."},
    {"type": "tool_use", "id": "toolu_1", "name": "get_weather", "input": {...}},
    {"type": "tool_use", "id": "toolu_2", "name": "search_flights", "input": {...}}
  ]
}
```

Your loop must handle this:

```python
if response.stop_reason == "tool_use":
    # Execute ALL tool_use blocks — possibly in parallel
    tool_results = []
    for block in response.content:
        if block.type == "tool_use":
            result = execute_tool(block.name, block.input)
            tool_results.append({
                "type": "tool_result",
                "tool_use_id": block.id,
                "content": result,
            })

    messages.append({"role": "assistant", "content": response.content})
    messages.append({"role": "user", "content": tool_results})
```

Missing this is a common bug — the loop works, but every second response is processed incorrectly.

## 6. The Agent SDK (what the exam actually calls you to know)

The **Claude Agent SDK** wraps the loop above into a higher-level abstraction:

```python
from claude_agent import Agent

agent = Agent(
    model="claude-sonnet-4-20250514",
    tools=[lookup_customer, update_account],
    system="You are a helpful assistant.",
)

result = agent.run("Find customer [email protected] and update the name.")
```

The SDK:
- Handles the loop for you (no manual `while True`)
- Handles parallel tool calls
- Handles structured errors
- Exposes **hooks** (`PreToolUse`, `PostToolUse`)
- Supports **subagent spawning** via the `Task` tool

> **Exam framing**: When the exam says "using the Agent SDK," it means *all of the above come for free.* Your job is still to understand **why** the loop behaves the way it does — because when things break in production, you won't be reading SDK source code; you'll be reasoning about `stop_reason`, tool appending, and context.

## 7. Tool-Result Content — Strings vs Structured

`tool_result.content` can be:
- A **string** (most common, quickest to set up)
- A **list of blocks** (e.g., `[{"type": "text", "text": "..."}, {"type": "image", ...}]`) — for multi-modal tool outputs

Both are valid. Prefer strings unless you need images or multi-part responses.

## 8. Error Handling Inside the Loop

### 8.1 Tool errors

When a tool fails, wrap the error in a **structured error object** (see D2.2) and include `"is_error": true` on the `tool_result` block:

```python
messages.append({
    "role": "user",
    "content": [{
        "type": "tool_result",
        "tool_use_id": tool_block.id,
        "content": json.dumps({
            "isError": True,
            "errorCategory": "timeout",
            "isRetryable": True,
            "context": {"attempted": "customer lookup", "service": "customer-db"}
        }),
        "is_error": True,      # API-level flag
    }]
})
```

Claude sees `is_error: True` and can decide to retry, try an alternative, or give up. This is the primary mechanism behind *graceful agent degradation*.

### 8.2 API errors

API errors (rate limits, 5xx, timeouts) should be caught and retried with exponential backoff. A production loop looks like:

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(stop=stop_after_attempt(5), wait=wait_exponential(multiplier=1, max=30))
def call_claude(messages, tools):
    return client.messages.create(model=..., tools=tools, messages=messages)
```

## 9. When to Use an Agent vs. a Single-Shot Call

An agentic loop is NOT free — it costs tokens, latency, and complexity. Use it when:

- The task requires **multiple tool invocations** in unknown order.
- The **next step depends on** the previous step's result.
- Errors need to trigger **fallback paths**.

Use a single-shot call with forced `tool_use` when:
- The task is **structured extraction** with a known schema.
- There is only **one tool** to call, or zero (pure text output).
- Latency is critical (< 2 s end-to-end).

## 10. Exam-Style Questions — Self-Quiz

> **Q**: You are writing a Python agent that calls a weather tool. The assistant text says "All done!" but `stop_reason == "tool_use"`. What should the loop do?
>
> **A**: Continue the loop — `stop_reason` is the signal, not text.

> **Q**: An iteration cap of 10 is the sole termination condition. What problem does this introduce?
>
> **A**: Genuinely complex tasks get cut off; genuinely simple tasks still waste iterations until the cap. Iteration caps are safety nets, not primary controls.

> **Q**: A response has 3 `tool_use` blocks. How many tool_result entries should the next user message contain?
>
> **A**: Exactly 3 — one per `tool_use_id`. Missing any will cause a 400 error on the next call.

## 11. The Mental Model to Keep

The agentic loop is a **feedback control system**, not a Chain-of-Thought prompt. Claude acts → you observe → you report observation → Claude acts again. The only way Claude tells you "I've completed the task" is by emitting `stop_reason = "end_turn"`. Any other signal is guesswork.

Understanding this one mental model correctly is the difference between a 60 % exam score and an 80 % one.

---

### Key Takeaways
- ✅ **Always check `stop_reason`** — `"tool_use"` continue, `"end_turn"` exit.
- ✅ Thread **full `response.content`** back into messages.
- ✅ Handle **parallel tool calls** (multiple `tool_use` blocks in one response).
- ✅ Structure errors inside `tool_result` with `is_error: True`.
- ❌ Never parse natural language for termination.
- ❌ Never use iteration caps as primary termination.
- ❌ Never bail on any `text` block presence.

Next → [`02-Multi-Agent-Orchestration.md`](02-Multi-Agent-Orchestration.md)
