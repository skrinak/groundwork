# `specs/` — machine-parsed contracts. The path is API.

> **Membership test**
> "Code, tests, or an external tool **parses** this — the path itself is API."

**Lifecycle: living, and path-frozen.** Content changes as the contract evolves. The *path* does not.
Moving a file here is a breaking change even when the bytes are identical, because something resolves
it at runtime — a test fixture, a CI job, a code generator, or a repository you do not own.

## What belongs here

- OpenAPI / GraphQL / Smithy schemas
- JSON Schema and validation contracts
- Fixtures a test suite loads by path
- Any file whose *shape* is agreed with a consumer

## The rule that matters

Before moving or renaming anything here, find every consumer. `grep` the repo, then check
downstream repos and any published raw URL.

**A stub that returns 200 fails silently.** Leaving a "moved" pointer at a URL that automation
`curl`s does not preserve the contract — the consumer receives a redirect note with a success code
and no way to detect the difference. If machines consume it, the payload stays put and the pointer
goes at the *new* location. If humans consume it, a 404 then a pointer is fine, because a human
reads the pointer.

## Suggested layout

```
specs/
├── api/openapi/v1.yaml     # the HTTP contract
└── contracts/              # internal contracts validated in CI
```

Prose *about* an interface is documentation — that goes in [`docs/`](../docs/). This directory is
only for what a machine reads.
