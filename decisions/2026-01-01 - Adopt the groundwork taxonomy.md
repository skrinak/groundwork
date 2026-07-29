# Adopt the groundwork taxonomy

> **Status:** Shipped (2026-01-01) — scaffolded from [skrinak/groundwork](https://github.com/skrinak/groundwork)

**This file is a worked example.** It is here so the conventions are concrete rather than described,
and so your `decisions/` directory is never an intimidating empty room. Rewrite it with your real
adoption date and rationale, or delete it once you have written a record of your own — either is
correct. What it demonstrates is worth keeping:

- the `YYYY-MM-DD - Title.md` filename
- the `> **Status:**` header as the **first line after the H1** — CI fails without it
- a body written in the past tense, because a record describes a moment rather than the present
- a **Consequences** section, which is the part future readers actually come back for

---

## Context

This project needed a place for non-code files before it had any. The default outcome is a `docs/`
directory that becomes a landfill: design notes, runbooks, API schemas, meeting outputs and dead
drafts in one flat pile, where nothing tells a reader — human or agent — whether a given file is
current, binding, or long superseded.

That ambiguity is cheap while one person holds the whole history in their head, and expensive the
moment anyone else arrives. An agent has no history at all.

## Decision

Adopt the groundwork taxonomy in full:

- Files are classified by **how a reader must treat them** — audience, lifecycle, bindingness —
  never by topic. No `security/`, `qa/`, or `evals/` directories.
- **Root markdown is exactly three files:** `README.md`, `CLAUDE.md`, `tasks.md`.
- A new markdown file is **born in `decisions/`** with `> **Status:** Proposed` unless it passes
  another bucket's membership test on day one.
- **Freezing attaches to status, not directory.** Terminal (`Shipped`, `Superseded-by`) records are
  append-only; `Proposed` and `In-progress` records stay live and editable.
- The taxonomy is **enforced in CI**, not merely documented — `make check-links` on every push.

## Alternatives considered

| Option | Why not |
|---|---|
| One flat `docs/` directory | The failure mode this exists to prevent. Nothing distinguishes current documentation from a superseded design doc, so readers learn to trust none of it. |
| Topic directories (`security/`, `qa/`) | Shreds one concern across four lifecycles — a threat model, a rotation runbook, an audit and an auth contract are four different *kinds* of file. And there is never a rule for where the next new artifact type goes. |
| Convention without enforcement | Conventions decay at exactly the rate they go unchecked. Without CI this is a preference, and preferences lose to deadlines. |

## Consequences

- Anyone — including an agent with no context — can tell current documentation from a historical
  record **by path and header alone**, before opening the file.
- Some friction on file creation: you must decide what a file *is* before deciding where it goes.
  That is the cost, and it is paid once per file instead of on every future read.
- CI can fail on a documentation-only change. Intended: a broken reference is a defect, and the
  cheapest moment to fix one is before it lands.
- `decisions/` will grow. Shard it by year (`decisions/2027/`) at roughly 100 flat files; the
  filenames are already chronological, so nothing needs renaming.

## References

- [REPOSITORY_TAXONOMY.md](https://github.com/skrinak/ContextEng/blob/main/docs/REPOSITORY_TAXONOMY.md)
  — the full rationale, definitions, and the five-year stress test
- [`../CLAUDE.md`](../CLAUDE.md) — the taxonomy as an enforceable constraint
- [`README.md`](README.md) — the status vocabulary and the freeze rule
