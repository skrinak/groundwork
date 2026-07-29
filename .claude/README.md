# `.claude/` — model-facing assets

> **Membership test**
> "Consumed by the model or the harness, not read by humans for understanding."

Not documentation. Nobody reads this directory to learn how the system works — the harness loads it.

## Contents

| Path | What it is |
|---|---|
| `settings.json` | Permissions and configuration for the coding agent |
| `skills/` | Packaged capabilities: a `SKILL.md` manifest plus its scripts and examples |
| `commands/` | Custom slash commands |
| `hooks/` | Pre/post tool-call automation |

## Rules

- **`settings.local.json` is gitignored** — personal overrides never get committed.
- A skill is **self-contained**: its manifest, scripts and examples live together in its own
  directory, so it can be copied to another repo whole. A skill that reaches outside its directory
  breaks the moment it is reused.
- **Never instruct a reader to overwrite `SKILL.md`** — its YAML frontmatter is what makes the skill
  discoverable, and clobbering it silently de-registers the skill.
- Secrets never live here. This directory is committed.
