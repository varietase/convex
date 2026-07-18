# convex — Agent Guide

## Project
convex is a read-only proof-of-comprehension layer for student/self-taught builders. It joins a deterministic code evidence graph to demonstrated learner state through teach-back. It is not an IDE, code generator, generic explainer, or graph product.

## Read order
1. `docs/DECISION-LEDGER.md` — live truth.
2. `docs/index.md` — one fact, one owner.
3. `docs/prd.md` — F/BR/INV requirements.
4. `docs/implementation-plan.md` and `docs/qa-test-plan.md` — build gates.

## Current architecture
Two repositories only for the hackathon: Vercel client (`xray-client`) calling the Hugging Face Docker Space FastAPI backend (`xray-backend`) directly over HTTPS — no BFF/proxy, access control is a CORS origin allowlist only. Backend uses deterministic Tree-sitter analysis, minimal LangChain/LangGraph, and GPT-5.6 only above the evidence graph. ADR-0002 local-first MCP App is future recommendation, not current work.

## Hard rules
- **INV-001:** never render a structural edge without deterministic file/line evidence.
- **INV-002:** never render a personal gap without repo evidence + validated attempt evidence.
- **INV-003:** never modify, commit, PR, execute, or request write credentials for user code.
- Never show mastery percentages or generic top-N learning lists.

## Before coding
Verify pinned framework/SDK APIs against official current docs; do not code fast-moving APIs from memory. Exact repo names, versions, commands, limits, and deployment IDs are still assumptions. Record them in the ledger/docs when chosen.

## Definition of done
A change ties to F-### and tests; touched INV-### remains enforced and audited; API surfaces declare auth; computed outputs cite EQ/DS derivations; no secrets/source/learner answers in logs; docs and ADR/ledger stay reconciled. Run the production sample smoke test before any demo.
