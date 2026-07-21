# Documentation Index — convex

**Maintained by:** Abu · **Last updated:** 2026-07-20 · **FMD:** 4.3.0

> **How to use this index.** Each document owns one concern (see the map below). Under FMD 4.3 there is no single doc that "wins" every disagreement — ownership is by concern: product behavior lives in the PRD, architecture in System Design, test intent in the QA Plan, **current execution state in the Implementation Plan**, and decisions/pivots/names/immutable IDs in the Decision Ledger and ADRs. If two documents disagree, that is a failed checkpoint: reconcile it at the concern's owning doc rather than letting either silently override. Start with the four marked ⭐ below — they're the minimum context for any builder joining mid-sprint.

## 0. Source-of-truth map

| Concern | Canonical owner | What's inside (one-liner) |
|---|---|---|
| Decisions, pivots, rejected approaches, names/immutable IDs | ⭐ [Decision Ledger](DECISION-LEDGER.md) | The append-only record of decisions, pivots, rejected approaches, frozen names/IDs, and decision assumptions. It owns *decision history*, not current execution state or product/architecture truth — those live in their own docs below. If you're unsure whether something was *decided*, check here first. |
| Problem, segment, feature/invariant origin | [idea.md](../idea.md) | The original problem statement, peer-reviewed evidence, target users, kill criteria, and the feature/invariant spine (F-001–F-005, INV-001–003). This is where we explain *why* we're building convex. |
| Build context and rubric | [context.md](../context.md) | Hackathon rules, team size, time budget, judging rubric, and hard submission requirements (Codex use, YouTube demo, etc.). Read this to know what we're being scored on. |
| Brand and voice | [brand.md](../brand.md) | Product name, category phrase, visual direction, UI copy rules (say/don't-say), and accessibility baseline. Governs all user-facing text and design decisions. |
| Visual philosophy | [Visual Direction](visual-direction.md) | Premium dark-first editorial visual language: mood, composition, shape, motion, imagery, color philosophy, and UI principles. Use before implementing detailed UI tokens. |
| Product, journeys, F/BR/INV IDs | ⭐ [PRD](prd.md) | Testable product requirements: user stories, acceptance criteria in EARS format, business rules, user flows, and the MVP vs. Final feature split. The contract between product and engineering. |
| Architecture and topology | [System Design](system-design.md) | High-level architecture: context diagram, component responsibilities, data flows, deployment topology, and technology choices with rationale. Shows *how the pieces connect*. |
| Algorithms/modules | [Technical Design](technical-design.md) | Low-level design: module breakdown per repository, class/function signatures, algorithm pseudocode (intake, parser, gap derivation), sequence diagrams, and error handling. The implementation reference. |
| API contracts | [API Spec](api-spec.md) | Every endpoint (API-001–API-108) with request/response schemas, auth requirements, error codes, and rate limits. Frontend and backend must agree on these shapes. |
| Entities, retention, privacy | [Data Model](data-model.md) | All persisted and ephemeral entities (symbols, edges, sessions, attempts, gap items), their relationships, lifecycle/TTL rules, and privacy boundaries. |
| Ranking/count equations and confidence | [Methods](methods.md) | The glass-box ledger: every displayed number or category resolves to an equation (EQ-###) and dataset (DS-###) with stated confidence. No hidden scoring. |
| UI tokens, components, states, copy | [Design System](design-system.md) | CSS tokens, semantic/component styling, component inventory with states, interaction patterns, accessibility contracts, graph/chart encoding rules, and exact copy for every UI condition. The frontend implementation spec. |
| Tests and traceability | ⭐ [QA Plan](qa-test-plan.md) | Test cases (TC-001–TC-011, TC-N01–N05), traceability matrix linking each F-ID to tests, invariant negative tests, API/security gates, and exit criteria. |
| Auth, threats, compliance | [Security](security-compliance.md) | Threat model, SSRF/traversal/injection mitigations, credential handling, session isolation, log sanitization, and INV-003 enforcement specifics. |
| Current execution state, task ownership, dependencies, gates | ⭐ [Implementation Plan](implementation-plan.md) | **The living execution-state owner (FMD 4.3):** stable `TASK-###` rows with status, one owner each, dependencies, bounded write scopes, work refs, executable gates, and the derived ready/blocked/parallel/cut view + waves. Check here for what to do next. The historical Manila five-hour schedule is preserved as its Appendix A. |
| Global-stage rationale (historical) | [Next Steps](next-steps.md) | **Historical background** behind the living plan: day-by-day ship reasoning, critical-path analysis, workstreams, blockers, onboarding notes, and GC copy. Superseded as the execution tracker by the Implementation Plan; retained for provenance. |
| Build-time agent roster | [SAD](sad.md) | Which AI agents help build convex (graph-engineer, product-ui-engineer, reasoning-engineer, trust-reviewer), their boundaries, and what they must not do. |
| Deployment and incidents | [Ops](ops.md) | Deployment steps for Cloudflare Workers and HF Space, health checks, monitoring, rollback procedures, and incident response for judging availability. |
| Release and validation | [Release/GTM](release-gtm.md) | Release phases (M0–M3, G1–G3), scope-cut order, rollout strategy, launch checklist, and submission deadlines. The ship plan. |
| Demo narrative and Q&A | [Pitch Kit](pitch-kit.md) | The 2:45 voiceover script, rubric evidence map, "not just Cursor/Cody" answer, and live-demo rules. Dia and Abu use this to rehearse. |
| Contributor orientation | [Onboarding](onboarding.md) | Quick-start for anyone joining the team: environment setup, conventions, where to find things, and first-task suggestions. |
| Locked-doc changes | [Change Records](change-record.md) | Formal change log for any post-freeze edits to locked documents. Required during G3 judging hold. |
| Significant technical decisions | [ADRs](adr/) | ADR-0001 (two-repo baseline) and ADR-0002 (future local-first MCP recommendation). Platform decisions that override downstream assumptions. |
| Researched architecture recommendation | [Architecture Research](../architecture-research.md) | Deep research on HF Spaces, MCP Apps, Tree-sitter, existing code-graph products, and the recommended post-hackathon architecture. Future only — does not change the current build. |

## 1. Reading paths by role

| You are… | Read these first |
|---|---|
| **Backend (Joshua, Farhana)** | Decision Ledger → Implementation Plan → Technical Design → API Spec → QA Plan → Security |
| **Frontend (Helena, Dia)** | Decision Ledger → Implementation Plan → Visual Direction → Design System → PRD (user flows) → API Spec → QA Plan |
| **Demo / Product (Abu, Dia)** | Decision Ledger → PRD → Pitch Kit → Implementation Plan → Brand → Visual Direction |
| **Joining mid-sprint (Geinel, Jim)** | Onboarding → Decision Ledger → Implementation Plan → your role path above |

## 2. Suite status
All listed documents are **planning-ready**. Assumptions remain explicitly marked `[assumption]`; implementation evidence will move them in the Decision Ledger. Start with the four ⭐ documents.

## 3. Health check
- [x] Every F-001–F-005 has tests; F-101–F-104 are traced and deferred.
- [x] INV-001–003 each reach PRD, security, design banned-copy, and QA negative tests.
- [x] All five endpoints declare auth/authz (CORS allowlist only, no BFF/proxy).
- [x] Every displayed rank/count is owned by EQ-### / DS-### methods.
- [x] Current backend architecture is two repos; the active client is a public-GitHub-URL-only dashboard preview with no MCP/private/local path. The bundled sample remains backend/demo scope until client API integration lands.
- [ ] Backend commands, dependency pins, contract/analyzer versions, stable IDs, sample fixture, and intake caps are locked; replace remaining client pins, deployment repository IDs, and measured runtime limits during their gates.

## 4. Key terms (quick glossary)
| Term | Meaning |
|---|---|
| F-001–F-005 | MVP feature IDs (evidence graph, semantic zoom, gap map, teach-back, intake). Immutable. |
| F-101–F-104 | Future feature IDs. Not in MVP scope. F-102/private-local access is cut from the current build and requires a fresh decision after the public/sample loop is verified. |
| INV-001–003 | Hard invariants: no fabricated edges, no generic gap lists, read-only on user code. |
| `[assumption]` | A value or detail that is decided for planning but not yet verified end-to-end. |
| EQ-### / DS-### | Equation and dataset IDs from the Methods doc. Every number shown to a user must trace to one. |
| API-### | Endpoint IDs from the API Spec. Frontend and backend share these as the contract. |
| TC-### / TC-N## | Test case IDs (positive and negative/invariant tests). |
| BFF | Backend-for-Frontend — a proxy layer that would hold a backend credential. **Not used in convex:** the browser calls the HF Space directly (ADR-0001 / ADR-0003). |

