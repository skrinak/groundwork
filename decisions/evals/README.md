# `decisions/evals/` — generated artifacts, not records

Everything here is **machine-written data**. A scorecard a script produces is evidence; the verdict a
human writes on top of it is the decision. They have different authors, different lifecycles, and
they belong in different places.

## The convention

| | Generated artifact (here) | Curated record (`decisions/`) |
|---|---|---|
| Written by | a script, every run | a human, once |
| Filename | `YYYY-MM-DD-<slug>.md` (`-2`, `-3` on a same-day re-run) | `YYYY-MM-DD - Title.md` |
| Header | `> **Generated artifact**` + the command that produced it | `> **Status:**` |
| Edited | **never** — a re-run writes a *new* dated file | header only, once terminal |
| Status lint | exempt | enforced |

A curated record **cites** the artifact it drew its verdict from. Then regenerating the evidence can
never rewrite the conclusion.

## The rule

> **Never point a generator at a curated record.**

If a tool writes it, the destination is a dated file the tool owns exclusively. Pointing a benchmark
script at a hand-maintained record means every run silently deletes the reasoning — the only part
anyone needed.

## Header for generated files

```markdown
# Scorecard — <what was measured>

> **Generated artifact** — produced by `<command>` on <date>. Written once, never
> hand-edited; re-running writes a new dated file.
```
