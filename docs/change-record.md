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

## CR-003 — FMD 4.2 → 4.3 living-execution migration
- **Status:** Applied
- **Date:** 2026-07-20
- **Owner:** Abu
- **Change:** Upgraded the vendored FMD factory 4.2.0 → 4.3.0 (`fmd/VERSION`; ADR-0007). Made `docs/implementation-plan.md` the sole living execution-state owner: stable `TASK-###` rows (status, one owner, dependencies, bounded write scope, work ref, executable gate/evidence), a categorized derived view (blockers/ready/blocked/deferred/in-review-done), a dependency graph, and the checkpoint/branch/PR protocol; the Manila five-hour schedule is preserved un-rewritten as its Appendix A. Re-labeled `docs/next-steps.md` as historical/detail background pointing to the living plan. Replaced the "Decision Ledger wins on disagreement" rule everywhere it appeared (`README.md`, `docs/index.md`, `docs/DECISION-LEDGER.md`, `AGENTS.md`, `docs/onboarding.md`) with FMD 4.3 concern-based ownership: product → PRD, architecture → system design, test intent → QA plan, execution state → implementation plan, decisions/pivots/names/immutable IDs → this ledger and ADRs. Seeded 12 `TASK-###` rows from `docs/next-steps.md`, the Decision Ledger, and read-only repository/submodule inspection (no invented facts): credential unblock, model re-pin, HF Space deploy, TTL reconciliation, client API wiring, evidence/graph UI, teach-back/gap UI, live-loop cutover, verified full loop, deferred CI, demo script, and final submission.
- **Reason:** FMD 4.2 docs drifted every sprint and no artifact owned trustworthy execution state (ADR-0007's trigger); the "ledger wins" framing also conflicted with the new concern-ownership model and needed reconciling everywhere it was asserted, not just in the plan.
- **Architecture:** Unchanged — two repositories, Cloudflare Workers client + Hugging Face Docker Space backend, direct browser→Space call, CORS allowlist, no BFF/proxy. No code, dependencies, secrets, deployment configuration, or submodule pins were touched; `client`/`model` pre-existing local modifications were left untouched.
- **Invariants touched:** INV-001 kept; INV-002 kept; INV-003 kept.
- **Docs affected:** `README.md`, `AGENTS.md`, `docs/index.md`, `docs/DECISION-LEDGER.md`, `docs/onboarding.md`, `docs/implementation-plan.md`, `docs/next-steps.md` (re-labeled, not deleted), this change record.
- **Validation required:** `python3 fmd/tools/check-implementation-plan.py docs/implementation-plan.md` and `--strict` both `APPROVE` with zero same-wave write-scope overlaps; `git diff --check` clean.

## CR-004 — Hybrid repository connection shell and final-product copy
- **Status:** Applied
- **Date:** 2026-07-21
- **Owner:** Helena / Codex
- **Change:** Reconciled docs with the client-side repository onboarding updates: shared Add Repository Link modal, public GitHub URL validation, MCP placeholder connection/selector for private/local repository access, centralized repository state, `/dashboard`, source-aware repository switching, and removal of Varietas-specific roadmap/preview copy in favor of general GitHub/local repository language.
- **Reason:** The product surface is no longer just a demo for Varietas repositories; it now presents the final-product repository connection model while keeping backend/MCP support honest as placeholder/future work.
- **Architecture:** Backend architecture remains Cloudflare Workers client + Hugging Face Docker Space direct API. The new MCP path is client-side scaffolding only until a local MCP host contract, security review, and tests exist.
- **Invariants touched:** INV-001 kept; INV-002 kept; INV-003 kept. The frontend still must not request write credentials, perform GitHub OAuth, store provider tokens, or mutate repositories.
- **Docs affected:** `README.md`, `AGENTS.md`, `docs/prd.md`, `docs/system-design.md`, `docs/technical-design.md`, `docs/qa-test-plan.md`, `docs/security-compliance.md`, `docs/design-system.md`, `docs/onboarding.md`, `docs/index.md`, `docs/implementation-plan.md`, `docs/DECISION-LEDGER.md`, this change record.
- **Validation required:** `git diff --check` clean; implementation-plan checker unavailable in this checkout; client verification lives in the client worktree (`npx tsc --noEmit --incremental false`, `npm run build`).

Future changes append CR-005+. Never rewrite this record; supersede it.
