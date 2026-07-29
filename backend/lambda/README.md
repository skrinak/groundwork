# `backend/lambda/` — the CRUD path. No agent code.

Deterministic request/response handlers behind API Gateway. This is where **most** of a healthy
product lives: lookups, rules, validation, joins, writes — everything plain code can compute without
a model call.

> **The one hard rule: no agent loop here.** Not "prefer not to." An agent loop in a Lambda hits the
> 29-second API Gateway sync timeout and forces a self-invoke plus frontend-polling state machine —
> a permanent class of async-versus-state races. The agent path is
> [`../runtime/`](../runtime/).

A single bounded model call inside an otherwise deterministic handler (a classifier, an extractor, a
judge) is **fine** and expected — that is rung 2 of the deterministic-first gate. The banned thing is
the *loop*.

## Layout

```
lambda/
├── <resource>/handler.py     # one directory per resource
└── shared/                   # db client, auth utils, response helpers
```

`shared/` is bundled into every function that imports it, so **editing one file there changes every
function's asset hash** and redeploys all of them. Diff with `--method=template` before deploying;
the default diff under-reports this.

## Conventions

- Python 3.12, strict typing
- `logging.getLogger(__name__)`, never `print()` — OTEL attaches trace context to every log line
- Least-privilege IAM per function, granted in the CDK stack, never a shared catch-all role
- One handler, one responsibility. Consolidate related routes behind a dispatcher only when you are
  approaching the CloudFormation 500-resource-per-stack ceiling — and then deliberately.
