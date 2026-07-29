# `frontend/web/` — the web client

## Transport is load-bearing

The defaults will fail you on a long agent turn. These are not optional:

- **Raise the request timeout.** The AWS SDK's ~30s default kills long turns —
  `FetchHttpHandler({ requestTimeout: 300_000 })`.
- **Read the stream with a `getReader()` loop, not `for await…of`** — async iteration over response
  bodies is patchy before Chrome 124.
- **`break` explicitly on the terminal event.** Stream EOF does not propagate cleanly through CDN and
  Runtime proxies, so a loop waiting for EOF hangs.
- **Session ids must be ≥ 33 characters** — use a UUID. Reusing one pins session affinity to the same
  warm microVM.
- **Expose agent calls behind one transport function** so a change never touches call sites.

## Cache isolation — the leak that looks like a server breach

Any client cache keyed without the signed-in principal must be wiped by **one** mechanism that
observes identity change: a store middleware that resets every registered cache when the
authenticated user id changes or clears. Token refreshes with the same user id must not reset.

Per-call-site reset lists rot as caches are added, and the resulting leak renders one tenant's data
under the next account — indistinguishable from a server-side tenancy breach. When tenant data
"leaks," prove server-side isolation first, then hunt every client cache whose key omits the principal.

## Layout

```
web/src/
├── services/    # transport: the runtime client, the stream hook
├── pages/
└── components/
```
