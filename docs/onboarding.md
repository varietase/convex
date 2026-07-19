# Onboarding — convex

## What this is
A read-only proof-of-comprehension layer for AI-assisted code. Start with [`index.md`](index.md); do not treat it as a code generator or IDE.

## Read first
1. [`index.md`](index.md) — §0 source-of-truth ownership map (which doc owns which concern).
2. [`implementation-plan.md`](implementation-plan.md) — the **living execution plan**: current `TASK-###` state, owners, dependencies, gates, and what to do next. Read before coding.
3. [`prd.md`](prd.md) — F-001–005 MVP and INV-001–003.
4. [`system-design.md`](system-design.md) — two-repo architecture.
5. [`DECISION-LEDGER.md`](DECISION-LEDGER.md) — decisions, pivots, names/immutable IDs.

## Run locally
The backend requires Python 3.12–3.14 and `uv`: `cd model`, copy `.env.example` to `.env`, run `uv sync --frozen`, then `uv run uvicorn app.main:app --host 127.0.0.1 --port 7860`; run `uv run pytest` for its current gate. The client (`cd client`) runs with `npm install` then `npm run dev`; verify with `npm run typecheck` and `npm run build`; deploy with `npm run deploy` (OpenNext → Cloudflare Workers). Verify `/health`, then run the client against the Space origin directly (CORS-allowlisted origin — no BFF/proxy). Never put secrets in `.env.example` values.

## Where things live
- Cloudflare Workers client repository: `client` (`xray-client`), live at `https://convex.varietase.workers.dev` — UI, calls the backend directly.
- Hugging Face repository: `model` (`xray-backend`) — FastAPI + deterministic parser + minimal LangChain/LangGraph.
- This planning repo (`convex`): `idea.md`, `context.md`, `brand.md`, `architecture-research.md`, `master-plan-implementation.md`, and `/docs`.

## Conventions
Preserve F/API/BR/INV/EQ/DS IDs. Structural changes start in canonical docs, then reconcile. Mark assumptions. Never create graph edges from model output, generic personal gaps, or repository write paths. Capture Codex decisions and `/feedback` ID during build.
