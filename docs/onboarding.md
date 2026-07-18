# Onboarding — X-Ray

## What this is
A read-only proof-of-comprehension layer for AI-assisted code. Start with [`index.md`](index.md); do not treat it as a code generator or IDE.

## Read first
1. [`index.md`](index.md) — source-of-truth ownership.
2. [`prd.md`](prd.md) — F-001–005 MVP and INV-001–003.
3. [`implementation-plan.md`](implementation-plan.md) — 5.5-hour build gates.
4. [`system-design.md`](system-design.md) — two-repo architecture.

## Run locally
Exact repository names, commands, and pinned versions do not exist yet [assumption]. At scaffold: document prerequisites in each repo README; run the Hugging Face/FastAPI backend first, verify authenticated health and sample; then run the Vercel client/BFF and complete the sample loop. Never put secrets in `.env.example` values.

## Where things live
- Vercel client repository: UI + BFF/proxy [identifier pending].
- Hugging Face repository: FastAPI + deterministic parser + minimal LangChain/LangGraph [identifier pending].
- This planning repo: `idea.md`, `context.md`, `brand.md`, `architecture-research.md`, and `/docs`.

## Conventions
Preserve F/API/BR/INV/EQ/DS IDs. Structural changes start in canonical docs, then reconcile. Mark assumptions. Never create graph edges from model output, generic personal gaps, or repository write paths. Capture Codex decisions and `/feedback` ID during build.
