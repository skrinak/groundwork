# <PROJECT NAME>

> **Replace this file.** It is the first thing an agent reads every session, so it should say what
> this project *is* — the product, the customer, the shape in one breath — not how it was scaffolded.
> Scaffold provenance belongs in `decisions/`, not here. Delete this blockquote when you rewrite.

<One paragraph: what this product does and for whom.>

---

## Getting started

```bash
make check-links      # the taxonomy guard — green on commit zero
make help             # every target
```

## How this repository is organized

Every directory carries a `README.md` stating what belongs in it. That is the usage guide, and it is
also what makes the directory survive in git. **Read the one next to the file you are about to
create.**

Files are classified by *how a reader must treat them*, never by what they are about. Three
questions decide: **who reads it** · **does it describe the present or record a moment** · **does
anything parse the path**.

| Directory | Membership test | Lifecycle |
|---|---|---|
| **root** | An agent loads this unconditionally, every session | Living — exactly `README.md`, `CLAUDE.md`, `tasks.md` |
| [`docs/`](docs/) | "Describes the system **as it is** — if the system changes and this doesn't, that's a bug" | Living |
| [`specs/`](specs/) | "Code, tests or a tool **parses** this — the path is API" | Living, path-frozen |
| [`runbooks/`](runbooks/) | "A procedure an operator will execute **again**" | Living |
| [`decisions/`](decisions/) | "Records a moment. Would you edit the body to match today? Then it isn't one" | **Frozen once terminal** |
| [`vision/`](vision/) | "The product we **intend**, not the system that exists" | Living |
| [`.claude/`](.claude/) | "Consumed by the model or harness, not read by humans for understanding" | Consumable |

A new markdown file is **born in `decisions/` with `> **Status:** Proposed`** unless it passes
another bucket's test on day one.

Full rationale — why classification is by treatment rather than topic, why a code review lands in
`decisions/`, the definitions, and the five-year stress test:
**[ContextEng `docs/REPOSITORY_TAXONOMY.md`](https://github.com/skrinak/ContextEng/blob/main/docs/REPOSITORY_TAXONOMY.md)**

## The code tree

Two compute paths, which never call each other — they share state through the database. See
[`backend/README.md`](backend/README.md) for the split and [`CLAUDE.md`](CLAUDE.md) for the rules.

| Directory | What lives there |
|---|---|
| [`backend/runtime/`](backend/runtime/) | **Agent path.** The LLM loop, on AgentCore Runtime. Delete if your product has no agent loop. |
| [`backend/lambda/`](backend/lambda/) | **CRUD path.** Deterministic request/response. No agent code, ever. |
| [`backend/infrastructure/`](backend/infrastructure/) | CDK for the CRUD plane, auth and storage |
| [`frontend/web/`](frontend/web/) | The web client |
| [`utils/`](utils/) | Scripts and tooling, including the taxonomy guard |

## The guard

`make check-links` validates every path reference in **every tracked text file** — markdown links
*and* source comments — plus `decisions/` status headers and root-markdown membership. It runs in CI
on every push via [`.github/workflows/docs-links.yml`](.github/workflows/docs-links.yml).

It is green right now, on an empty project. Keep it that way: it is the only thing standing between
this taxonomy and the pile of undifferentiated markdown it exists to prevent.

## Scaffolded from

[ContextEng](https://github.com/skrinak/ContextEng) — the methodology, the prompts, and the
reasoning behind this structure.
