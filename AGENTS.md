# convex — Agent Guide

## Project
convex is a read-only proof-of-comprehension layer for student/self-taught builders. It joins a deterministic code evidence graph to demonstrated learner state through teach-back. It is not an IDE, code generator, generic explainer, or graph product.

## Read order
1. `docs/index.md` — §0 ownership map: which doc owns which concern.
2. `docs/implementation-plan.md` — **living execution state** (what is ready/blocked/in-review/done, owners, dependencies, gates). Read before coding.
3. `docs/prd.md` — F/BR/INV product requirements.
4. `docs/qa-test-plan.md` — test intent and traceability.
5. `docs/DECISION-LEDGER.md` — decisions, pivots, rejected approaches, names/immutable IDs.

## Canonical ownership (FMD 4.3 — no single doc "wins" every disagreement)
Product behavior/features/journeys/invariants → `docs/prd.md`. Architecture/components/deployment → `docs/system-design.md`. Test intent/traceability → `docs/qa-test-plan.md`. Current execution state/task ownership/dependencies/gates → `docs/implementation-plan.md`. Decisions/pivots/rejected approaches/names/immutable IDs/decision assumptions → `docs/DECISION-LEDGER.md` and ADRs. A decision that affects product behavior or architecture is recorded in the ledger **and** reconciled into its owning doc in the same checkpoint; the ledger does not silently override the PRD/system design/QA plan. A disagreement is a failed checkpoint to reconcile, not a winner to pick.

## Current architecture
Two repositories only for the hackathon backend loop: Cloudflare Workers client (`xray-client`, live at `https://convex.varietase.workers.dev`) calling the Hugging Face Docker Space FastAPI backend (`xray-backend`) directly over HTTPS — no BFF/proxy, access control is a CORS origin allowlist only. Backend uses deterministic Tree-sitter analysis, minimal LangChain/LangGraph, and GPT-5.6 only above the evidence graph. The client worktree also contains a final-product repository connection shell (public GitHub link, MCP placeholder, `/dashboard`); treat MCP as scaffolding until the local host contract, security review, and tests exist. ADR-0002 local-first MCP App is future recommendation, not live backend work.

## Hard rules
- **INV-001:** never render a structural edge without deterministic file/line evidence.
- **INV-002:** never render a personal gap without repo evidence + validated attempt evidence.
- **INV-003:** never modify, commit, PR, execute, or request write credentials for user code.
- Never show mastery percentages or generic top-N learning lists.

## Before coding
Verify pinned framework/SDK APIs against official current docs; do not code fast-moving APIs from memory. Exact repo names, versions, commands, limits, and deployment IDs are still assumptions. Record them in the ledger/docs when chosen.

## Living plan + team delivery (FMD 4.3)
Read [`docs/implementation-plan.md`](docs/implementation-plan.md) before coding — it is the one execution-state home. `TASK-###` IDs are stable (never renumber/reuse; `T-###` is security threats only).
- **Start a task:** if the plan steward pre-filled `Owner` for you, start it — do not re-claim or reassign. Otherwise claim a `ready`, unowned task. Either way: set `in_progress`, create `task/TASK-###-short-slug` from the current default branch, fill `Work ref`. One task, one owner, one branch.
- Stay inside the row's `Write scope`; same-wave tasks are parallel only when scopes are disjoint. Checkpoint with the steward before touching a shared/out-of-scope file.
- **When done (your own checkpoint, in the same PR, before review):** run `python3 fmd/tools/check-implementation-plan.py docs/implementation-plan.md` and fix any REJECT; attach observed evidence to `Gate / evidence` (`result: PASS`, `CI: green`, or `artifact: <URL>`); set your row to `in_review`; update PRD/system-design/QA **only if intended behavior actually changed**.
- **After merge, the plan steward — not you — sets `done`**, once integrated and the gate still passes on the current base.
- Run a checkpoint on any task state change, accepted decision/pivot, discovered dependency/failed assumption, time/team/scope/rubric change, or session/handoff/demo/milestone end. Chat is not completion evidence; observe branch/PR/code/tests/deploy state. Decisions/pivots go to the ledger/ADRs, not task status history.
- The team uses the markdown plan + chat; GitHub Projects/Issues, CI enforcement, CODEOWNERS, and host automation are intentionally deferred.

## Definition of done
A change ties to F-### and tests; touched INV-### remains enforced and audited; API surfaces declare auth; computed outputs cite EQ/DS derivations; no secrets/source/learner answers in logs. The `TASK-###` row carries current status, work ref, and observed gate evidence, and `check-implementation-plan.py` passes; docs and ADR/ledger stay reconciled at their owning doc. Run the production sample smoke test before any demo.
