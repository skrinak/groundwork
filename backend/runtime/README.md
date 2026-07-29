# `backend/runtime/` — the agent path

The LLM loop, running on Amazon Bedrock AgentCore Runtime. Invoked **directly from the browser** over
SigV4 with Cognito Identity Pool credentials — no API Gateway hop, no proxy fleet.

> **No agent loop in this product? Delete this directory.** See the deterministic-first gate in
> [`../README.md`](../README.md). An empty `runtime/` is a claim about your architecture that isn't
> true yet.

## Layout

```
runtime/
├── app/coordinator/          # the container source
│   ├── main.py               # BedrockAgentCoreApp entrypoint + op dispatch
│   ├── runner.py             # one function per op
│   ├── domain/               # your orchestration doctrine + state object — THE PRODUCT IP
│   ├── agents/               # framework-agnostic agent/tool factory
│   └── memory/               # AgentCore Memory client
└── agentcore/
    ├── agentcore.json        # runtime + memory + gateway + evaluator declaration
    └── schemas/              # OpenAPI/Smithy schemas for Gateway tool targets
```

## What the SDK already owns — do not rebuild it

The HTTP server on `:8080`, SSE framing, the `/ping` health route, and a worker event loop on a
background thread. The entrypoint is three lines.

## What you own

- **A uniform streaming envelope on every op** — `*_started` immediately → `heartbeat {elapsedS}`
  every ~2s once work exceeds ~5s → terminal `*_complete`. Use it even for sub-second ops so the
  frontend never branches on op shape.
- **Prompt caching** on every system prompt. Keep the cached prefix byte-stable — a timestamp or a
  UUID in the prompt silently invalidates it.
- **Status-aware ops** — bake state-machine short-circuits in from the start.
- **The orchestration doctrine** — deterministic code decides *when* to call the model. The
  orchestrator is plumbing, not an agent. This is the IP; everything else is rented infrastructure.

## Gotchas that cost a cycle

- `asyncio.run()` raises inside the Runtime loop, and `nest_asyncio` breaks the server. Lean on the
  SDK's worker loop, or use a `ThreadPoolExecutor` with its own loop.
- Avoid directory names that collide with top-level dependency packages — a CodeZip build drops them.
- The agent SDK ships in this container's own `pyproject.toml`. **Never a Lambda Layer.**
