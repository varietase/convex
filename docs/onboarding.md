# Onboarding — X-Ray

## What this is
A read-only proof-of-comprehension layer for AI-assisted code. Start with [`index.md`](index.md); do not treat it as a code generator or IDE.

## Read first
1. [`index.md`](index.md) — source-of-truth ownership.
2. [`prd.md`](prd.md) — F-001–005 MVP and INV-001–003.
3. [`implementation-plan.md`](implementation-plan.md) — five-hour build gates.
4. [`system-design.md`](system-design.md) — two-repo architecture.

## Run locally
Exact commands and pinned versions do not exist yet [assumption]. At scaffold: document prerequisites in each repo README; run the Hugging Face/FastAPI backend first, verify `/health` and the sample flow; then run the Vercel client and complete the sample loop by calling the backend directly (CORS-allowlisted origin — no BFF/proxy). Never put secrets in `.env.example` values.

## Where things live
- Vercel client repository: `client` (`xray-client`) — UI, calls the backend directly.
- Hugging Face repository: `model` (`xray-backend`) — FastAPI + deterministic parser + minimal LangChain/LangGraph.
- This planning repo (`convex`): `idea.md`, `context.md`, `brand.md`, `architecture-research.md`, `master-plan-implementation.md`, and `/docs`.

## Conventions
Preserve F/API/BR/INV/EQ/DS IDs. Structural changes start in canonical docs, then reconcile. Mark assumptions. Never create graph edges from model output, generic personal gaps, or repository write paths. Capture Codex decisions and `/feedback` ID during build.
