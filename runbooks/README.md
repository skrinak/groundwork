# `runbooks/` — procedures an operator will execute again

> **Membership test**
> "A step-by-step procedure an operator will execute **again**."

**Lifecycle: living.** A runbook that no longer matches reality is worse than no runbook, because it
is followed under pressure. When the procedure changes, this changes.

## What belongs here

Deploys and rollbacks · migrations · environment and account setup · incident response · test plans ·
key rotation · anything you would hand someone at 2am.

## What does not

| Not this | Goes to |
|---|---|
| A record of **one** execution | [`decisions/`](../decisions/) |
| A postmortem of a run that went wrong | [`decisions/`](../decisions/) |
| A CI pipeline definition | `.github/workflows/` — the harness parses it |
| Prose about how the system works | [`docs/`](../docs/) |

The distinction from `decisions/` is **repeat execution**. A migration runbook is run again by the
next person; the writeup of the migration you actually performed is a record and freezes.

## What a good one contains

1. **Preconditions** — what must be true before step one, and how to verify each
2. **Numbered steps**, each with the exact command and its expected output
3. **A verification step** that fails loudly rather than assuming success
4. **A rollback**, written before the procedure is first used, not after it first fails
5. **The gotchas that cost someone a cycle** — this is the part that makes a runbook worth more than
   the command history it was derived from
