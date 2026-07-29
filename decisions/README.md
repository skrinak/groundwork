# `decisions/` — one-time records, frozen once terminal

> **Membership test**
> "This records a moment. If you'd edit the body to reflect today's system, it doesn't belong here."

**This is the default home for a new markdown file.** A new document is born here with
`> **Status:** Proposed` unless it passes another bucket's test on day one. The asymmetry is
deliberate: a one-time record misfiled as living documentation quietly corrupts the bucket readers
trust most, while documentation misfiled here is obvious and harmless — someone opens it, sees a
stale header on a file describing the present, and moves it. **Optimize for the cheap mistake.**

## What belongs here

Design docs · execution ledgers and task trackers · code reviews · postmortems · incident writeups ·
spikes and investigations · audits · vendor correspondence (`vendor/`) · anything answering
*"we looked, this is what we found, this is what we resolved to do."*

## The status header — required, first lines after the H1

```markdown
# 2026-07-28 - Thing We Decided

> **Status:** Proposed
> **Pairs-with:** 2026-07-28 - Thing We Decided - Fix Plan.md
```

CI fails on any record here without it. That one line is what turns "is this still true?" from a
judgement call into a lookup — the highest-leverage convention in the whole taxonomy.

| Status | Meaning | Frozen? |
|---|---|---|
| `Proposed` | Written, not agreed or executed | No — **live, edit freely** |
| `In-progress` | Being executed now; an open tracker or ledger | No — **live, edit freely** |
| `Shipped (YYYY-MM-DD)` | Executed. Now describes history | **Yes** |
| `Superseded-by: <path>` | A later record replaced it. The pointer is mandatory | **Yes** |

`Pairs-with:` links a design to its ledger, or a review to its fix plan, so finding one finds the other.

## The freeze rule — status, not directory

A record with a **terminal** status (`Shipped`, `Superseded-by`) is frozen: **append** a status-header
line, never rewrite the body. A `Proposed` or `In-progress` record is **live** — edit it freely until
it goes terminal.

Freezing the whole directory instead would forbid maintaining the in-flight trackers that legitimately
live here, so the next engineer to fix an invariant would be barred from updating the document
defining it. A rule tied to *location* eventually forbids something legitimate, because location is
only a proxy. Tie it to the property you actually care about.

**Still allowed once frozen:** appending a status line, and repairing a link whose target moved. That
is navigation metadata, not the decision — otherwise every file move strands the historical record.

**If a terminal record needs body edits, it is misfiled.** It is documentation. Move it to
[`docs/`](../docs/).

## Naming

`YYYY-MM-DD - Title.md`. Chronological by default, so sharding by year (`decisions/2026/`) at ~100
files needs no renames.

## Generated output goes in [`evals/`](evals/)

A scorecard a script writes is data, not a decision. Never point a generator at a curated record —
it overwrites the human verdict on every run.
