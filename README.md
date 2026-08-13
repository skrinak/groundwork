# groundwork

### Start your next project on ground that already holds.

**A repository scaffold for software built with coding agents.** Every directory knows what belongs
in it. Every path tells a model how to treat what it finds. The guard that keeps it true is running
before you write a line of code.

Not a starter kit of dependencies you'll delete. A **structure** — the one that survives contact with
two years of decisions, a team, and an agent reading your tree at 3am with no tribal knowledge to
fall back on.

```bash
gh repo create my-product --template skrinak/groundwork --private --clone
cd my-product && make check-links     # already green
```

---

## Why this exists

Search solved *finding* files a decade ago. `grep` and semantic search answer **"what is this
about?"** better than any folder hierarchy ever did.

What they cannot answer — and what a model has no tribal knowledge to guess — is:

> **Is this true now? May I change it? Is something parsing it?**

Get that wrong and an agent loads a superseded design doc as current truth, then produces work that
is detailed, internally consistent, and **wrong**. The coherence is what makes it expensive: the
output looks *more* trustworthy than a hedged answer, it cites its source, and a reviewer nods.

You don't fix that by writing better documents. That superseded document *was* a good document. You
fix it by making "superseded" a property of **where the file sits and what its header says** —
visible before it is ever opened.

That is the whole idea. The tree stops being filing and becomes a **context-selection index**: the
one piece of metadata present in every listing, every search result, every tool output — for free,
before a single byte is read.

📖 **The full argument, with diagrams:**
[ContextEng · REPOSITORY_TAXONOMY.md](https://github.com/skrinak/ContextEng/blob/main/docs/REPOSITORY_TAXONOMY.md)

---

## What you get

| | |
|---|---|
| 🗂 **Seven buckets, one question each** | Classified by *how you must treat a file* — never by topic. `security/`, `qa/`, `evals/` are banned, and the README in each real bucket says why |
| 📝 **17 usage READMEs** | Every directory, code included, states its membership test **verbatim**. The rule travels with the folder instead of hiding in `CLAUDE.md` |
| ✅ **A guard, green on commit zero** | Validates every path reference in **every tracked text file** — source comments, not just markdown — plus status headers and root membership. With its own 33-case fixture suite |
| 🤖 **A contract agents follow** | `CLAUDE.md`, vendored from ContextEng and drift-checked in CI |
| 🧭 **Two compute paths, decided on purpose** | The deterministic-first gate, so the model is the *last* thing you reach for — not the first |
| 🏗 **AgentCore-first from t=0** | The agent loop runs on managed infrastructure from day one, not after a migration you keep postponing |

---

## The tree

```
my-product/
├── README.md          ← replace this (step 1 below)
├── CLAUDE.md             the contract · vendored, drift-checked
├── tasks.md              what's in flight, right now
│
├── docs/              📘 the system AS IT IS      → living
├── specs/             ⚙️  a machine parses this    → path is API
├── runbooks/          🔧 you'll run it again      → living
├── decisions/         🔒 a record of a moment     → frozen once terminal
├── vision/            🔭 the product we intend    → deliberately aspirational
├── .claude/           🤖 model-facing assets
├── scratch/           🧹 delete it, lose nothing  → ignored, never tracked
│
├── backend/
│   ├── runtime/          THE AGENT PATH — the LLM loop, on AgentCore
│   ├── lambda/           THE CRUD PATH — deterministic. no agent code, ever
│   └── infrastructure/   CDK for the CRUD plane
├── frontend/web/         the client · transport gotchas documented
│
├── utils/                tooling, incl. the guard
├── Makefile              make check-links
└── .github/workflows/    the guard + the contract drift check
```

**Root markdown is exactly three files.** It's the only place an agent reads *unconditionally*, so
it's the scarcest real estate you own. A fourth file there is almost always a `decisions/` record
that hasn't been filed yet.

---

## The rules that do the work

**Born in `decisions/`.** A new markdown file starts there with `> **Status:** Proposed` unless it
passes another bucket's test on day one. The asymmetry is deliberate — a one-time record misfiled as
living documentation quietly corrupts the bucket readers trust most, while documentation misfiled as
a record is obvious and harmless. **Optimize for the cheap mistake.**

**Frozen is a status, not a folder.** `Shipped` and `Superseded-by` freeze a record: append a header
line, never rewrite the body. `Proposed` and `In-progress` are live — edit freely. Freeze the whole
*directory* instead and you forbid maintaining the trackers that legitimately live there. A rule tied
to **location** eventually forbids something legitimate, because location is only a proxy.

**Never point a generator at a curated record.** Scorecards and eval output go to `decisions/evals/`
as dated files a tool owns outright. Aim a script at a hand-written record and every run silently
deletes the reasoning — the only part anyone needed.

**Ignoring a file is not filing it.** `.gitignore` protects the remote; the tree is what a reader and
a model actually see. An untracked transcript in `docs/` is still in `ls`, still in glob, still in a
file search — and it still makes `docs/`'s claim about itself. Transient output goes in `scratch/`,
whose test is *"could I delete this right now and lose nothing?"* — the narrowest bucket in the tree,
because here the penalty for misfiling is destruction rather than clutter.

---

## Start here

**1 · Replace this README.** It's the first thing an agent reads every session. Make it say what your
product *is*:

```markdown
# <Product>

<One paragraph: what it does, for whom, and the shape in one breath.>

## Getting started
    make check-links

## How this repository is organized
Every directory has a README stating what belongs in it. Read the one next to
the file you're about to create. Rules: CLAUDE.md.
```

**2 · Delete what you don't need.** No agent loop? `rm -rf backend/runtime` — the deterministic-first
gate in [`backend/README.md`](backend/README.md) tells you when. Don't keep empty directories "for
later": an empty directory is a claim about your architecture that isn't true yet, and the next
reader will believe it.

**3 · Write the brief, generate the PRD.** Use the
[PRD prompt](https://raw.githubusercontent.com/skrinak/ContextEng/refs/heads/main/prompts/PRD_DevelopmentPrompt.md),
land it at `docs/PRD.md`, then keep it current — it becomes the one document that earns *"read this
to understand the whole system."*

**4 · Record your first decision.** [`decisions/`](decisions/) already holds one, correctly
formatted, as a worked example. Copy its shape.

**5 · Keep the guard green.** `make check-links` on every change. It is the only thing standing
between this structure and the pile of undifferentiated markdown it exists to prevent.

---

## The guard

```bash
make check-links       # every reference, every status header, root membership
make check-links-test  # 33 fixtures — one per defect this has actually caught
```

It reads **every tracked text file**, because the largest class of rot lives in source comments,
invisible to a markdown-only linter. It resolves against the **git index**, not the working tree, so
it cannot pass on your laptop and fail in CI. It runs on **every push with no path filter**, because
a filter that must enumerate every linkable asset type is itself a recurring bug.

> **A green guard is evidence only to the extent the tool can see the failure.**
>
> The checker this replaced reported `doc links OK` throughout a 130-file restructure — while ~282
> stale references sat in source comments it could not read. Before trusting a clean run, ask what
> your checker physically cannot examine, and treat that blind spot as *unverified*, not *clean*.

It has already earned its keep: it failed on this scaffold and exposed a year-old defect in the
upstream contract — `CLAUDE.md` linked its own docs *relatively*, so every project ever seeded from
it inherited dead links.

---

## Where this came from

Distilled from [ContextEng](https://github.com/skrinak/ContextEng) — the methodology, the prompts and
the reasoning — and from production systems built with it, most recently [xact.ai](https://xact.ai).
Every convention here survived a real restructure, a real code review, or a real incident. None of it
is theory.

| | |
|---|---|
| **[ContextEng](https://github.com/skrinak/ContextEng)** | The method: prompts, AgentCore-first architecture, the taxonomy rationale |
| **[REPOSITORY_TAXONOMY.md](https://github.com/skrinak/ContextEng/blob/main/docs/REPOSITORY_TAXONOMY.md)** | Why classification is by treatment, why a code review lands in `decisions/`, the five-year stress test |
| **[AGENTCORE_FIRST.md](https://github.com/skrinak/ContextEng/blob/main/docs/AGENTCORE_FIRST.md)** | Read before designing a backend with an agent loop |

---

*Build on ground that holds.*
