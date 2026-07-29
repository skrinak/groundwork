# `utils/` — scripts and tooling

Executable helpers: backfills, one-off migrations, probes, generators, and the taxonomy guard.

## What ships with the scaffold

| Script | Purpose |
|---|---|
| `check_doc_links.py` | The taxonomy guard — every path reference in every tracked text file, plus `decisions/` status headers and root-markdown membership. Run with `make check-links`. |

## Conventions

- **Never call `python` or `pip` directly** — use `uv run` for execution and `uv add` / `uv pip` for
  packages.
- A script that writes into `decisions/` must write to `decisions/evals/` with a dated filename.
  **Never point a generator at a curated record** — it overwrites the human verdict every run.
- A destructive script gets a `--dry-run` that is the *default*, and an explicit `--apply`. The dry
  run should print exactly what the real run would change.
- Put the "how to run this" in the module docstring, not in a wiki.
