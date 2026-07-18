# ADR-0003 — Client deployment on Cloudflare Workers (OpenNext)

- **Date:** 2026-07-19
- **Status:** Accepted
- **Supersedes:** ADR-0001's client-host choice only (Vercel). The rest of ADR-0001 stands.
- **Context:** ADR-0001 named a Vercel web client as the baseline, but that was never deployed. The client was built and shipped on **Cloudflare Workers via OpenNext** (`@opennextjs/cloudflare`, `wrangler`, worker name `convex`) and is **live at `https://convex.varietase.workers.dev`**. The docs still said "Vercel" in ~20 places, so reality and documentation had diverged. This ADR records the platform as it actually is.
- **Options considered:**
  1. **Re-platform back to Vercel to match the old docs.** Throws away working, deployed infrastructure for no product gain during the submission window.
  2. **Keep Cloudflare Workers (OpenNext) and reconcile the docs.** Matches shipped reality; costs a documentation sweep and a new backend-base-URL/CORS wiring note.
  3. **Cloudflare Pages instead of Workers.** Not what was built; the live deployment is a Worker (`*.workers.dev`).
- **Decision:** Host the client on **Cloudflare Workers (OpenNext)** at `https://convex.varietase.workers.dev`. **The architecture from ADR-0001 is otherwise unchanged:** exactly two repositories, the browser calls the Hugging Face Docker Space (`xray-backend`, FastAPI, port 7860) **directly** over HTTPS JSON, **no BFF/proxy**, and access control remains an explicit FastAPI CORS allowlist (the deployed Cloudflare origin plus local development origins), never a wildcard. Only the client's hosting platform changed from Vercel to Cloudflare.
- **Consequences:**
  - The backend `XRAY_CORS_ORIGINS` allowlist must include `https://convex.varietase.workers.dev`.
  - The client's backend base URL (the HF Space origin it calls) is configured as a Cloudflare environment variable.
  - No server-held backend credential exists on the client host; the model key lives only in Hugging Face Space secrets (unchanged from ADR-0001).
  - All canonical docs are reconciled from "Vercel" to "Cloudflare Workers" (see Decision Ledger 2026-07-19 entry). ADR-0001 is marked *Superseded by ADR-0003* for the host choice; its two-repo/direct-call/CORS decision remains in force.
  - Rollback means reverting the Cloudflare Worker to the previous deployment and the Space to the previous known-good image/commit.
