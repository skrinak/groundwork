# `services/` — transport

Everything that talks to a backend. Isolated here so a transport change (a new timeout, a retry
policy, a different streaming shape) touches one directory instead of every call site.

Typical contents:

| File | Responsibility |
|---|---|
| `runtimeClient.ts` | SigV4-signed client for the agent path, with the raised timeout |
| `useDialogueStream.ts` | The `getReader()` loop, event parsing, explicit terminal `break` |
| `invokeRuntimeOnce.ts` | Single-shot agent invoke for non-streaming ops |

Expose agent mutations through your data layer's escape hatch (RTK Query's `queryFn`, or equivalent)
so components never construct a request themselves.
