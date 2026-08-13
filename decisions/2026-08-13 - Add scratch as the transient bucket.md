# Add `scratch/` as the transient bucket

> **Status:** Proposed

## Context

The taxonomy had six buckets and every one of them implies retention: `specs/` is a contract,
`docs/` must be true now, `runbooks/` must still execute, `decisions/` is frozen truth, `vision/` is
intent, `.claude/` is harness-facing. Nothing described a file with **no** obligation, so the
placement algorithm fell through to rule 6 — "otherwise `decisions/`" — for artifacts that decide
nothing and record no reasoning.

The existing answer was name-based: `.gitignore` matched `tmp.md`, `2do.md` and `**/tmp.html` at any
depth, with the correct diagnosis that scratch files are a credential-leak vector and that the habit
migrates between directories.

It was tested by a real case. A conversation export landed at the repository root as `dev_setup.md`
— 265KB of terminal transcript. It matched none of the patterns, it violated the closed root, and it
sat untracked in a working tree where two `git add -A` invocations could have swept it into a commit.
Asking where the taxonomy said it belonged produced no good answer.

Two properties of the current agent workflow make that gap widen rather than stay static:

1. **Volume.** Agent sessions emit transcripts, tool output, generated diffs and screenshots
   continuously. The six buckets were designed for artifacts a human decided to keep.
2. **Placement pressure.** Transient output lands in whichever directory the work was happening in,
   so it accumulates inside the buckets whose trustworthiness is the whole point.

## Decision

Add **`scratch/`** as a seventh bucket, with the membership test *"could I delete this right now and
lose nothing?"*

- **Contents are never tracked; the README always is** (`scratch/*` + `!scratch/README.md`), so the
  membership test ships in a fresh clone and the directory is a true claim rather than an empty one.
- **Anyone may delete the contents at any time, without asking.** That is the stated contract, and it
  is what makes the bucket safe to use and self-cleaning.
- **It is the narrowest bucket, never a default.** The `decisions/`-is-the-default asymmetry inverts
  here: misfiling *into* `decisions/` is cheap and obvious, while misfiling into `scratch/` is
  punished by silent destruction. Passing requires an affirmative "nothing is lost."
- **The name patterns stay** as a backstop for scratching in place, demoted from primary mechanism.
- **Visible, not `.scratch/`** — the inherited credential hazard is better served by a mess you see
  than one you forget.

## Alternatives considered

**Keep it name-based.** Rejected: it enumerates, and the enumeration is the bug — the same objection
this repo already makes to `paths:` filters in CI. `dev_setup.md` matched nothing.

**Keep transient files out of the repository entirely.** Purest, and still correct for anything with
a real home elsewhere. Rejected as *the rule* because the scaffold already concedes the habit
migrates; a convention nobody follows is not a convention.

**Route them to `decisions/evals/`.** Rejected: that bucket is for generated artifacts a human
re-reads, carrying a `> **Generated artifact**` header and a producing command. A transcript is not
evidence anyone returns to.

**A dotted `.scratch/`.** Rejected on the credential argument above.

## Consequences

- The placement algorithm gains a step 0, phrased so only true transients pass: *was it emitted by a
  tool or a session rather than authored, and does everything durable in it already live elsewhere?*
  **This step is not yet in `CLAUDE.md`**, which is vendored from ContextEng and drift-checked by
  `contract-sync`; hand-editing the copy would be reverted by the next `make vendor`. The change must
  land upstream, and until it does the rule lives in `scratch/README.md` and the root `README.md`.
- `make check-links` is unaffected by design. Its existence oracle is built from the git index, so
  ignored contents are outside its view automatically — which is required, not incidental, because
  transient files quote paths that have since moved and would otherwise hold CI hostage forever.
- The bucket count in `README.md` moves from six to seven and the README count from 16 to 17.
- A new failure mode is introduced and accepted: someone files something durable here and loses it.
  The membership test, the narrowness rule, and the "mine it, then delete the ore" instruction in
  `scratch/README.md` exist to make that mistake hard rather than impossible.

## References

- [`scratch/README.md`](../scratch/README.md) — the membership test and the agent instructions
- [REPOSITORY_TAXONOMY.md](https://github.com/skrinak/ContextEng/blob/main/docs/REPOSITORY_TAXONOMY.md)
  — classification by treatment, which is the axis `scratch/` extends to zero
