# convex

convex is a read-only comprehension control layer for code. It helps builders see how a repository fits together, trace exact evidence, explain a path back in their own words, and receive a repository-specific concept-gap map.

This repository is the shared system-context and planning hub for the hackathon build. It owns the product requirements, architecture, API contract, data model, security rules, design system, QA plan, operations runbook, pitch context, and implementation schedule. The client and backend implementation repositories are separate workspaces, with this README collecting the important context in one place.

## Current Status

- Public name: `convex`
- Category: comprehension control layer for code
- Build context: OpenAI Build Week, Manila build sprint plus Global submission
- MVP scope: F-001 through F-005 only
- Current architecture: Cloudflare Workers web client (live at `https://convex.varietase.workers.dev`) plus Hugging Face Docker Space backend
- Client context: sibling [client README](../client/README.md)
- Backend/model context: `model/` contains the Hugging Face FastAPI backend (`xray-backend`) — deterministic Tree-sitter analysis, evidence graph, grounded GPT-5.6 reasoning, and gap derivation, with a 300+ test suite (tracked as a submodule)
- Source of truth: [docs/DECISION-LEDGER.md](docs/DECISION-LEDGER.md)

If any document disagrees with the Decision Ledger, the Decision Ledger wins until the docs are reconciled.

## Product Boundary

convex is not an IDE, code generator, autonomous agent, PR-review tool, linter, debugger, generic snippet explainer, chatbot, or standalone graph product.

The product wedge is proof of comprehension:

1. Deterministic repository evidence.
2. Evidence-backed semantic zoom.
3. Repo-specific teach-back.
4. Validated learner evidence.
5. Transparent concept-gap ranking.

The MVP demo loop is:

```text
Intake -> Focus -> Trace evidence -> Teach back -> Review changed gap list
```

A coherent demo means a user can load a known sample or bounded public repository snapshot, inspect a real symbol or edge with exact source evidence, answer three repo-specific questions, receive supported/missing/unsupported feedback with citations, and see a personalized gap list update.

## Hard Invariants

These are non-negotiable and appear across the PRD, architecture, API spec, security plan, design system, QA plan, and agent guide.

| ID | Rule | Implementation meaning |
|---|---|---|
| INV-001 | Never fabricate structural edges | Every rendered call/import/module edge must come from deterministic static analysis and carry source evidence. Unsupported or ambiguous relationships are omitted and shown as "not enough evidence." |
| INV-002 | Never show generic personal gaps | A personal gap requires both repository evidence and validated teach-back attempt evidence. Repository concepts may exist without becoming personal gaps. |
| INV-003 | Stay read-only on user code | No commits, PRs, branch changes, provider write tokens, repository mutation APIs, package installs, build scripts, or execution of repository code. |

Also forbidden: mastery percentages, "fully understands" claims, generic top-N curricula disguised as personalization, and model-created graph truth.

## Feature Spine

### MVP

| ID | Feature | Required behavior |
|---|---|---|
| F-001 | Evidence-backed repository graph | Deterministic symbols, imports, calls, module relationships, and source references. |
| F-002 | Semantic zoom explorer | Source, pseudocode, connections, module role, and concepts preserve the same selected symbol/path. |
| F-003 | Personal concept-gap map | Ranked from real repository concepts and validated teach-back performance. |
| F-004 | Teach-back verification loop | Three repo-specific prediction/explanation questions, evidence-grounded feedback, and gap-map update. |
| F-005 | Demo-safe repository intake | Bundled sample or bounded public repository snapshot, analyzed read-only. |

### Future Only

| ID | Feature | Status |
|---|---|---|
| F-101 | Comprehension-delta ledger | Deferred |
| F-102 | In-workflow MCP App / extension surface | Deferred |
| F-103 | Cross-repository learner graph | Deferred |
| F-104 | Agent teaching contract | Deferred |

Do not start F-101 through F-104 until the complete F-001 through F-005 loop works.

## Workspace Map

| Path | Role | Notes |
|---|---|---|
| [convex/](.) | Context and planning repository | Shared source for product, architecture, API, data, design, QA, ops, pitch, and implementation docs. |
| [../client/](../client/) | Current client workspace | Next.js App Router marketing/product surface for convex. Its README states the current product boundary and run commands. |
| [model/](model/) | Backend workspace (submodule) | Hugging Face Docker Space / FastAPI `xray-backend`: deterministic analysis, evidence graph, grounded reasoning, gap derivation, and a 300+ test suite. See `model/DEPLOY.md` for the Space runbook. |
| [docs/](docs/) | Formal documentation suite | Canonical planning docs. Start with `docs/index.md` and the Decision Ledger. |
| [docs/adr/](docs/adr/) | Architecture decisions | ADR-0001 is current; ADR-0002 is a future recommendation only. |
| [hooks/](hooks/) | Git hook context | Decision-ledger hook notes. |

## Architecture

The accepted hackathon baseline is exactly two implementation repositories:

```text
Browser
  |
  | HTTPS JSON
  v
Cloudflare Workers web client (`xray-client`)
  |
  | HTTPS JSON API, direct browser call
  v
Hugging Face Docker Space (`xray-backend`), port 7860
  FastAPI
    -> deterministic Tree-sitter pipeline
    -> ephemeral evidence/session store
    -> minimal LangChain/LangGraph
    -> GPT-5.6 for narrative/questions/evaluation only
```

There is no BFF/proxy layer in the current design. The browser calls the FastAPI backend directly. The access-control boundary is a FastAPI CORS allowlist for the deployed Cloudflare origin and local development origins. The allowlist must never be `*`.

The backend owns intake validation, parsing, deterministic graph construction, evidence slicing, concept rules, model-output validation, learner evidence, gap derivation, TTL cleanup, and sample fallback. The frontend owns intake UX, semantic zoom, graph/source/path views, teach-back UX, gap review, evidence drawers, accessibility behavior, and visible provenance.

## Data Flow

1. The user selects the bundled sample or submits a supported public repository snapshot.
2. The backend validates source, host, revision, archive paths, symlinks, file counts, byte limits, and time bounds before parsing.
3. The analyzer parses JS/JSX/TS/TSX files and emits only exact symbols and structural relationships with file/line evidence.
4. Unsupported or ambiguous references become unresolved references, not speculative edges.
5. The UI lets the user pin a symbol or path and change semantic altitude without losing context.
6. For narrative, pseudocode, and teach-back, GPT-5.6 receives bounded evidence packets, not unrestricted repository contents.
7. Model output must pass schema validation and evidence-ID allowlist checks.
8. The user submits teach-back answers.
9. Evaluation separates supported, missing, and unsupported claims, with citations.
10. EQ-005 derives eligible concept gaps only when repository evidence and learner-answer evidence are both present.

## API Contract

The API is synchronous and versioned under `/v1`. There are no queues, polling endpoints, background-job entities, repository-write endpoints, or internal API mirrors.

| Endpoint | Serves | Purpose |
|---|---|---|
| `GET /health` | Ops | Reports backend, parser, sample, and model readiness without exposing secrets. |
| `POST /v1/analyses` | F-001, F-005 | Analyzes a sample or bounded public repository snapshot and returns symbols, edges, unresolved references, and analyzer version. |
| `POST /v1/xray` | F-002 | Returns cited pseudocode, module role, concepts, and uncertainty text for a selected symbol/path. |
| `POST /v1/teachbacks/questions` | F-004 | Returns exactly three repo-specific questions grounded in deterministic evidence. |
| `POST /v1/teachbacks/evaluate` | F-003, F-004 | Evaluates teach-back answers, returns evidence-cited findings, learner evidence, and eligible concept gaps. |

Canonical error codes include `UNSUPPORTED_SOURCE`, `LIMIT_EXCEEDED`, `ANALYSIS_TIMEOUT`, `REPOSITORY_NOT_FOUND`, `NOT_ENOUGH_EVIDENCE`, and `MODEL_UNAVAILABLE`.

MVP intake limits from the current docs:

| Limit | Value |
|---|---:|
| Supported files | 40 max |
| Total supported source | 750KB max |
| Per-file source | 60KB max |
| Compressed archive | 5MB max |
| Extracted archive | 20MB max |
| Intake/analysis timeout | 20 seconds |

Oversized or unsafe inputs are rejected outright. They are never silently truncated.

## Logical Data Model

The MVP model is ephemeral and session-scoped. Storage technology is intentionally not prescribed.

Core entities:

- `AnalysisSession`
- `RepositorySnapshot`
- `SourceFile`
- `SourceSpan`
- `Symbol`
- `EvidenceEdge`
- `ConceptEvidence`
- `NarrativeArtifact`
- `TeachBackQuestion`
- `TeachBackAttempt`
- `EvaluationClaim`
- `LearnerConceptState`
- `GapItem`
- `DerivationRecord`

Important model rules:

- Code evidence and learner evidence stay separate.
- A `GapItem` is a derived join, not a model opinion.
- Every `EvidenceEdge` has exactly three provenance anchors: source definition, relationship site, and target definition.
- There is no `confidence` field for structural truth. An edge is either established or omitted.
- There is no source mutation entity, provider write token, commit, branch, or PR model.
- Full source files exist only in the transient workspace; the backend persists only bounded cited excerpts until TTL.
- MVP sessions are disposable, with a 24-hour TTL assumed in the docs.

## Methods and Ranking

Every displayed number, count, category, progress value, or priority must resolve to an equation ID and input dataset IDs from [docs/methods.md](docs/methods.md).

Key equations:

| ID | Output |
|---|---|
| EQ-001 | Intake manifest counts and bounds checks |
| EQ-002 | Structural graph counts |
| EQ-003 | Repository concept exposure |
| EQ-004 | Teach-back question progress |
| EQ-005 | Gap eligibility and ranking |
| EQ-006 | Evidence citation count |
| EQ-101 | Future comprehension-delta category |

The current gap ranking formula is:

```text
gap_score = 0.70 * learner_gap + 0.30 * repository_relevance
```

`gap_score` is a ranking value only. It must not be shown as a mastery score, comprehension percentage, or proof that the learner knows or does not know something outside the submitted explanation.

## Client Context

The current client context lives in [../client/README.md](../client/README.md).

It describes a Next.js App Router surface for convex, derived from the planning docs in this repository. It explicitly avoids code-generation, repository-editing, pull-request, commit, IDE, and autonomous-agent claims.

Client commands:

```bash
npm install
npm run dev
```

Verification commands:

```bash
npm run typecheck
npm run build
```

The client README notes that production builds may need to run outside restricted Windows sandboxing because Next spawns compiler processes.

## Backend / Model Context

The backend described by the docs is `xray-backend`: a Hugging Face Docker Space running FastAPI on port `7860`, with deterministic Tree-sitter analysis, minimal LangChain/LangGraph, GPT-5.6 calls, and ephemeral storage.

Expected backend modules from the technical design:

| Module | Responsibility |
|---|---|
| `api` | FastAPI validation, CORS allowlist, five documented endpoints |
| `intake` | Read-only source validation and bounded public snapshot materialization |
| `analysis` | Tree-sitter parsing and evidence graph construction |
| `evidence` | Immutable graph and provenance queries |
| `concepts` | Versioned deterministic concept rules |
| `reasoning` | Typed GPT-5.6 narrative/question/evaluation calls |
| `learner` | Attempt recording and eligible gap derivation |
| `cleanup` | Workspace deletion and TTL sweep |

`convex/model/` contains the `xray-backend` implementation and its test suite (tracked as a submodule). Use [docs/system-design.md](docs/system-design.md), [docs/technical-design.md](docs/technical-design.md), [docs/api-spec.md](docs/api-spec.md), and [docs/data-model.md](docs/data-model.md) as the backend contract, and `model/DEPLOY.md` for the Hugging Face Space deployment runbook.

## Security and Privacy

MVP security posture:

- No accounts, names, email, private repository intake, repository credentials, OAuth, SSH keys, or write scopes.
- Public repository source is still treated as sensitive during processing.
- Full source is deleted after parsing.
- Evidence excerpts, graph state, teach-back answers, learner state, gaps, and derivations are session-confidential and TTL-bound.
- Logs must not include source text, learner responses, prompts, model output bodies, full URLs with query strings, cookies, credentials, or evidence packets.
- Model provider credentials live only in Hugging Face Space secrets.
- The Cloudflare Workers client holds no backend/model secret in the current direct-call architecture.
- SSRF, path traversal, symlink, nested archive, decompression bomb, timeout, parser ambiguity, model citation, CORS, session isolation, and cleanup cases are hard security gates.

If live analysis is unavailable, the product may show a visibly labeled pre-indexed sample. It must never pretend sample fallback is a successful live analysis of a submitted repository.

## UX and Visual System

The product should feel like a premium dark-first editorial instrument for understanding code: quiet, exact, composed, and evidence-first.

Core visual rules:

- Near-black canvas, off-white text, neutral grays for surfaces and structure.
- Warm coral accent for action, focus, selection, and meaningful learning-state changes.
- Thin outlines, stable rails, rounded cards, minimal shadows.
- Evidence, source locations, edge labels, and proof actions are visually primary.
- Generated prose is useful, but always secondary to evidence.
- No sci-fi scanning, playful gamification, decorative blobs, heavy gradients, fake progress, or color-only meaning.

The required product landmarks are:

- `AppHeader`
- `RepositoryRail`
- `FocusWorkspace`
- `LearningRail`
- `LiveRegion`

Graph and chart states must have text equivalents and non-color encoding. Keyboard graph traversal, visible focus, reduced motion, AA contrast, and text alternatives for graph paths are required.

## QA Gates

The MVP exits only when these are true:

- Every rendered edge resolves to existing symbols and exactly three source-span evidence anchors.
- Ambiguous/dynamic calls are omitted with "not enough evidence."
- Rendered-edge observed precision is 100% on held-out fixtures.
- Selected symbol/path persists across semantic zoom levels.
- Graph traversal works by keyboard and has equivalent text paths.
- No `GapItem` appears without both repository evidence and validated attempt evidence.
- Question generation returns exactly three repo-specific questions with valid concept/span IDs.
- Evaluation rejects fabricated citations and unsupported structural claims.
- Bundled sample and one bounded immutable public fixture complete the full loop.
- Unsafe/private/oversize/unsupported sources fail closed and clean up workspace.
- Logs and browser bundles contain no secrets, source, learner answers, prompts, or model body content.
- Production sample E2E passes three times.
- F-101 through F-104 tests remain skipped/deferred, not falsely green.

## Operations

Deployment order:

1. Deploy backend first.
2. Verify `GET /health`.
3. Run sample analysis through `POST /v1/analyses`.
4. Deploy frontend with the backend origin configured.
5. Run the full sample loop from a clean browser.

Important runtime configuration:

| Name | Runtime | Purpose |
|---|---|---|
| `XRAY_BACKEND_BASE_URL` | Cloudflare | Space origin the browser calls directly |
| `XRAY_CORS_ORIGINS` | Space | CORS allowlist |
| `OPENAI_API_KEY` | Space | GPT-5.6 calls |
| `XRAY_MODEL_ID` | Space | Pinned GPT-5.6 identifier |
| `XRAY_LIMIT_*` | Space | Intake and timeout bounds |
| `XRAY_SAMPLE_MANIFEST` | Space | Immutable fallback sample version |

Rollback means reverting the Cloudflare Worker to the previous deployment and the Space to the previous known-good image/commit. User/session data is intentionally ephemeral and is not backed up.

## Build Plan

The five-hour build plan is risk-first:

1. Contracts, sample, and deployments.
2. Parallel foundation for client explorer, deterministic backend, and teaching pipeline.
3. F-001 evidence graph.
4. F-002 semantic zoom and F-005 public intake.
5. F-004 teach-back.
6. F-003 gap-map update.
7. Invariants and accessibility.
8. Deployment reliability.
9. README and rehearsal.

The honest stopping point is the full pre-indexed sample loop: sample -> grounded edge -> teach-back -> updated gap list. Cut public-repo breadth, decorative polish, extra concepts, and all future features before cutting that loop.

## Codex and GPT-5.6 Responsibilities

Codex is a build-time collaborator: use it to implement scoped features, keep docs reconciled, write tests, debug contracts, and preserve the invariant spine.

GPT-5.6 is a controlled runtime component: it may produce cited narrative, pseudocode, question text, and evaluation claims over bounded evidence packets. It must not create symbols, structural edges, concept evidence, scores, ranks, or repository truth.

## Documentation Map

Start here:

| Doc | Owns |
|---|---|
| [docs/DECISION-LEDGER.md](docs/DECISION-LEDGER.md) | Live truth, decisions, pivots, rejected directions, immutable IDs |
| [docs/index.md](docs/index.md) | Documentation map and reading paths |
| [docs/prd.md](docs/prd.md) | Product requirements, features, user journeys, acceptance criteria |
| [docs/implementation-plan.md](docs/implementation-plan.md) | Time-boxed build schedule and gates |
| [docs/qa-test-plan.md](docs/qa-test-plan.md) | Test cases, traceability, invariant negative tests |

Core system docs:

| Doc | Owns |
|---|---|
| [idea.md](idea.md) | Original problem, segment, evidence, feature spine, risks |
| [context.md](context.md) | Hackathon requirements and build context |
| [brand.md](brand.md) | Name, promise, voice, copy rules, accessibility baseline |
| [docs/system-design.md](docs/system-design.md) | High-level architecture and data flow |
| [docs/technical-design.md](docs/technical-design.md) | Modules, functions, algorithms, sequence diagrams |
| [docs/api-spec.md](docs/api-spec.md) | Five endpoint contracts and error codes |
| [docs/data-model.md](docs/data-model.md) | Entities, relationships, constraints, retention |
| [docs/methods.md](docs/methods.md) | Equations, datasets, gap ranking, traceability |
| [docs/security-compliance.md](docs/security-compliance.md) | Threat model, privacy, secrets, logs, incident response |
| [docs/design-system.md](docs/design-system.md) | UX components, tokens, states, interaction patterns |
| [docs/visual-direction.md](docs/visual-direction.md) | Brand-level visual philosophy |
| [docs/ops.md](docs/ops.md) | Deploy, rollback, observability, runbooks |
| [docs/release-gtm.md](docs/release-gtm.md) | Release phases, scope cuts, launch checklist |
| [docs/pitch-kit.md](docs/pitch-kit.md) | Demo script, business narrative, judge Q&A |
| [docs/onboarding.md](docs/onboarding.md) | Contributor quick-start |
| [AGENTS.md](AGENTS.md) | Agent guide and definition of done |

Architecture decisions:

| ADR | Status |
|---|---|
| [ADR-0001](docs/adr/ADR-0001-two-repository-hackathon-baseline.md) | Two-repository baseline: direct browser calls + CORS allowlist. Client **host superseded by ADR-0003** (Vercel → Cloudflare Workers) |
| [ADR-0002](docs/adr/ADR-0002-future-local-first-mcp-app.md) | Future recommendation only: local-first sidecar, MCP server, and MCP App after the MVP loop is validated |
| [ADR-0003](docs/adr/ADR-0003-cloudflare-workers-client-deployment.md) | Accepted: client on Cloudflare Workers (OpenNext), live at `https://convex.varietase.workers.dev`; supersedes ADR-0001's host choice only |

Event and team context:

| Doc | Owns |
|---|---|
| [context-master.md](context-master.md) | Combined Manila and Global Build Week context |
| [context-manila-buildathon.md](context-manila-buildathon.md) | Manila day-one plan |
| [context-global-buildweek.md](context-global-buildweek.md) | Global submission requirements |
| [context-team.md](context-team.md) | Team roles and working model |
| [master-plan-implementation.md](master-plan-implementation.md) | Expanded implementation plan and demo script |
| [architecture-research.md](architecture-research.md) | Researched architecture recommendation and future product surface |

## Contributor Definition of Done

For any change:

- Tie the work to an F-ID.
- Identify touched invariants and keep them enforced.
- Keep API surfaces aligned with [docs/api-spec.md](docs/api-spec.md).
- Include tests appropriate to the risk.
- Ensure computed outputs cite EQ/DS derivations.
- Preserve read-only repository handling.
- Avoid secrets/source/learner answers in logs.
- Keep design language evidence-first and accessible.
- Update the Decision Ledger or ADRs when a real decision changes.
- Run the production sample smoke test before any demo.
