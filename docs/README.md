# `docs/` — human-readable documentation of the system as it is

> **Membership test**
> "This describes the system **as it is** — if the system changes and this file doesn't, that's a bug."

**Lifecycle: living.** Every file here carries an obligation. When the thing it describes changes,
this changes in the same commit. That obligation is the entire value of the bucket: a reader — human
or model — can trust that anything here is current *without checking*.

That trust is why one misfiled record is expensive. A design doc or a review parked here is stale
the day it lands, and it teaches every future reader that `docs/` can't be trusted. If you would not
maintain it forever, it belongs in [`decisions/`](../decisions/).

## What belongs here

- The authoritative system inventory (`PRD.md` — what the system consists of, right now)
- Architecture narratives and generated diagrams (`arch/`)
- Public API reference written as prose for humans
- Invariant specs that code cites as authority — if 14 source files depend on a document being
  current, it is documentation, not a record
- Compliance and security posture as it currently stands

## What does not

| Not this | Goes to |
|---|---|
| A design doc for work not yet done | [`decisions/`](../decisions/) — and it freezes when the work ships |
| A code review, postmortem, audit | [`decisions/`](../decisions/) |
| An OpenAPI file a tool parses | [`specs/`](../specs/) — the path is API there |
| A deploy or migration procedure | [`runbooks/`](../runbooks/) |
| Where the product is going | [`vision/`](../vision/) |

## The test that catches drift

Ask: *if I changed the system tomorrow and forgot this file, would that be a bug?*

**Yes** → it belongs here. **No** → it is a record; file it in `decisions/` and let it freeze.

## Suggested first file

`docs/PRD.md` — the living inventory of what the system consists of. Generate the first version with
the [PRD prompt](https://raw.githubusercontent.com/skrinak/ContextEng/refs/heads/main/prompts/PRD_DevelopmentPrompt.md),
then keep it current as the system moves. It is the one document that earns "read this to understand
the whole system."
