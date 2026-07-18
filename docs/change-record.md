# Change Records — convex

## CR-001 — Solution spine and FMD suite
- **Status:** Locked for hackathon planning
- **Date:** 2026-07-18
- **Owner:** Abu
- **Change:** Expanded problem-only `idea.md` with F-001–005 MVP, F-101–104 final vision, value proposition, and success metrics; generated the FMD suite.
- **Reason:** FMD required stable feature IDs; the team needed an executable plan before the Manila sprint.
- **Architecture:** Kept the user-provided Vercel client + Hugging Face FastAPI/LangChain/LangGraph backend. Added local-first MCP App architecture only as proposed ADR-0002.
- **Innovation:** Defined convex as proof-of-comprehension—deterministic code evidence joined to demonstrated learner state—not explain-code, graph visualization, MCP, or an IDE alone.
- **Invariants touched:** INV-001 kept; INV-002 kept; INV-003 kept.
- **Docs affected:** `idea.md`, `context.md`, `brand.md`, `architecture-research.md`, and all `/docs` artifacts.
- **Validation required:** F/INV traceability, architecture consistency, API auth, methods transparency, design banned-copy, and QA exit gates.

## CR-002 — Cloudflare Workers deployment + backend-truth reconciliation
- **Status:** Applied
- **Date:** 2026-07-19
- **Owner:** Abu
- **Change:** Reconciled all docs from the never-deployed Vercel client to the shipped **Cloudflare Workers (OpenNext)** client (live at `https://convex.varietase.workers.dev`); recorded the backend F-001–F-005 feature-complete milestone (300+ tests) and the pending `model` re-pin (`80390bb` → `origin/main` `d06dc29`).
- **Reason:** Docs said "Vercel" in ~20 places and still described a contracts-and-health backend scaffold; both had drifted from shipped reality.
- **Architecture:** Unchanged except the client host — two repositories, direct browser→Space call, CORS allowlist, no BFF/proxy. Recorded in ADR-0003 (supersedes ADR-0001's host choice only).
- **Invariants touched:** INV-001 kept; INV-002 kept; INV-003 kept.
- **Docs affected:** README, AGENTS, context, DECISION-LEDGER, ADR-0001/0003, system-design, ops, api-spec, security-compliance, prd, release-gtm, pitch-kit, technical-design, onboarding, index, architecture-research, implementation-plan, master-plan-implementation, next-steps.

Future changes append CR-003+. Never rewrite this record; supersede it.
