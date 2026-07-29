# tasks.md

The in-flight work ledger. One of exactly three files at the repository root, because an agent loads
it every session — it answers "what is happening right now?"

**Keep it current or delete the stale parts.** A ledger nobody trusts is worse than no ledger: it
gets skimmed, and the skimming becomes a habit.

## Format

Section per workstream. Checkbox per task, with a status tag and a one-line outcome once done —
the outcome is the part future-you needs, not the checkbox.

```markdown
## <Workstream> — <what it delivers>

Tracking `decisions/YYYY-MM-DD - Design.md`. That record holds the full task detail
(verification criteria, dependencies, parallel markers); this file tracks section-level status.

- [x] 1. <Task> `[completed]` — <what actually happened, incl. anything surprising>
- [ ] 2. <Task> `[in-progress]`
- [ ] 3. <Task> `[pending]` [PARALLEL: 4]
- [ ] 4. **USER: <thing only a human can do>** `[pending — user-owned]`
```

## Conventions

- **Detail lives in `decisions/`, status lives here.** Do not duplicate a task list into both — they
  drift, and then neither is trusted.
- **Mark user-owned items explicitly.** Secret rotation, account provisioning, vendor approvals. They
  block, and an agent cannot clear them.
- **Archive completed workstreams into `decisions/` at release boundaries.** A finished ledger *is* a
  record; leaving it here makes root markdown grow without bound.
- **Never rename this file** — no `TASKS.md`, no `todo.md`. Root markdown is exactly three files.

---

## Getting started

- [ ] 1. Replace `README.md` with what this project actually is `[pending]`
- [ ] 2. Write the opening brief and generate `docs/PRD.md` `[pending]`
- [ ] 3. Delete the buckets and code directories this project does not need `[pending]`
- [ ] 4. Record the first architectural decision in `decisions/` `[pending]`
