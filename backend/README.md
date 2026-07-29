# `backend/` — two compute paths that never call each other

The single most consequential structural decision in this scaffold. Two paths, chosen per
requirement, sharing state only through the database — never through each other.

```
Browser
  ├─ Agent path (the LLM loop):   SigV4 → AgentCore Runtime → Bedrock · Memory · Gateway · Identity
  └─ CRUD path (deterministic):   JWT → API Gateway (REST) → Lambda → DynamoDB
```

| Directory | Path | Rule |
|---|---|---|
| [`runtime/`](runtime/) | **Agent** | The LLM loop lives here and nowhere else |
| [`lambda/`](lambda/) | **CRUD** | Deterministic request/response. **No agent code, ever** |
| [`infrastructure/`](infrastructure/) | Both | CDK for the CRUD plane, auth, storage. The agent plane is its own CDK app under `runtime/agentcore/` |

## Choosing the path — the deterministic-first gate

Route each requirement down three rungs and stop at the first that works:

1. **Plain code computes it** — a lookup, a rule, arithmetic, a validation, a join. → CRUD path, **no model call**.
2. **Judgement in one bounded spot** — a router, classifier, extractor, judge. → a single structured model call *inside* deterministic code.
3. **Genuinely un-hardcodable but verifiable** → an agent loop on the Runtime.

The model is the slowest, costliest, least reproducible component. Reach for it last. Most features
are rung 1, and a healthy project has far more CRUD than agent code.

> "AgentCore from t=0" means rung 3 *already runs on AgentCore* — not that every feature starts at
> rung 3.

## No agent loop in this product?

Then you are a rung-1 and rung-2 project, which is a perfectly good place to be. **Delete
`runtime/`.** Keep `lambda/` and `infrastructure/`. Nothing else in the scaffold assumes an agent
loop exists — the documentation taxonomy, the guard and CI are all independent of it.

Do not keep an empty `runtime/` "for later." An empty directory is a claim about the architecture
that isn't true yet, and the next reader will believe it.

## Why the paths must not call each other

A Lambda that invokes the agent loop reintroduces the 29-second API Gateway timeout the Runtime
exists to escape, and forces a polling state machine on the frontend — a permanent class of
async-versus-state races. If both paths need the same state, they both read the database.
