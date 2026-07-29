# `docs/arch/` — architecture narrative and diagrams

Living documentation of how the system is built: the compute paths, the data flow, the trust
boundaries, the state machines. If the architecture changes and these do not, that is a bug.

## Conventions

- **`images/`** — generated diagrams. Keep the *source* (a script, or a `.content.txt` prompt)
  beside the output so any diagram is regenerable rather than a mystery binary.
- One narrative per concern (`agents.md`, `security.md`) rather than one enormous file — they are
  read by different people at different times.
- Invariant specs that code cites as authority live **here**, not in `decisions/`. If source files
  depend on a document being current, it is documentation.

## Diagrams

Hand-drawn whiteboard boards can be generated from a text description — see the
`whiteboard-generation` skill in ContextEng. Commit the `.content.txt` source next to the `.jpg`;
the image is a raster that drifts on regeneration, so the text is the durable artifact.
