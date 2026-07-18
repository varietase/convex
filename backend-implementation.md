# Backend Implementation Plan — Two Developer Split

> **Checklist rule:** check an item only with its linked tests or a reproducible smoke result. Shared-contract items below are complete on `model/feat/shared-contract-gate`; all feature work remains open.

## Purpose and boundaries

This plan delivers the MVP backend loop for F-001 through F-005: bundled/public repository intake, deterministic evidence graph, grounded explanation, teach-back, and an evidence-backed gap update. The browser calls the Hugging Face FastAPI service directly over HTTPS; there is no BFF or repository-mutation capability.

The non-negotiable boundaries are:

- **INV-001:** render structural edges only when deterministic evidence supplies exactly three anchors: source definition, relationship site, and target definition.
- **INV-002:** render a concept gap only with both repository evidence and validated learner-attempt evidence.
- **INV-003:** never execute, modify, commit, push, or otherwise write user code.
- GPT-5.6 may explain or evaluate an evidence packet; it cannot create graph facts, concepts, or gap eligibility.

Canonical contracts and acceptance gates remain `docs/api-spec.md`, `docs/technical-design.md`, `docs/qa-test-plan.md`, and `docs/security-compliance.md`. This document assigns implementation ownership; it does not replace those documents.

## Shared contract gate — first 20–30 minutes

- [x] Freeze v1 Pydantic DTOs and pure service protocols under `app/domain/`. Changes afterward require a small, separate contract change before either implementation branch consumes them.
- [x] Freeze `POST /v1/analyses` to create and return an opaque `sessionId`; require that handle with `snapshotId` for xray and teach-back requests.
- [x] Freeze originless `GET /health` for platform probes only; require an exact allowlisted `Origin` before browser-facing route/body handling.
- [x] Keep `CONTRACT_VERSION = 1.0.0` as the pre-release v1 baseline; do not change it without an intentional compatibility decision.

```text
RepositoryInput -> SnapshotMaterializer -> SnapshotWorkspace
SnapshotWorkspace -> AnalysisEngine -> AnalysisBundle
AnalysisBundle -> EphemeralStore -> snapshot/session-scoped retrieval
EvidencePacket + selection -> ReasoningService -> explanation or question set
EvidencePacket + answers -> EvaluationService -> validated findings
AnalysisBundle + validated findings -> GapService -> eligible gap items
```

`SnapshotMaterializer`, `EphemeralStore`, and HTTP orchestration are platform-owned. `AnalysisEngine`, evidence packet construction, concept rules, reasoning, and gap derivation are evidence/agent-owned.

## Developer 1 — FastAPI, middleware, platform, and intake boundary

Suggested branch: `feat/api-platform`.

### Ownership

- `app/main.py`
- `app/api/**`
- `app/middleware/**`
- `app/store/**`
- `app/cleanup/**`
- FastAPI configuration, Docker/Hugging Face readiness, and deployment checks
- Public repository materialization and workspace safety boundary

### Deliverables

- [x] Activate `POST /v1/analyses`, `POST /v1/xray`, `POST /v1/teachbacks/questions`, and `POST /v1/teachbacks/evaluate` as thin adapters over injected services. Test doubles are allowed only in tests; production routes cannot return invented feature data. Implemented in `app/api/analyses.py`, `app/api/xray.py`, `app/api/teachbacks.py` with `Annotated[..., Depends(...)]` injection via `app/api/dependencies.py`.
- [x] Complete transport policy: request/contract headers, exact-origin/preflight behavior, canonical errors, timeout/concurrency/rate limits, and sanitized logs. Implemented in `app/middleware/rate_limit.py` (RateLimitMiddleware 60 rpm, ConcurrencyLimitMiddleware 20 max, TimeoutMiddleware 30s) and `app/api/errors.py` (canonical `{code, message}` envelope with domain→HTTP translation).
- [x] Implement ephemeral session/snapshot storage, ownership checks, TTL sweep, deletion cascade, and honest `410` after restart/expiration. Implemented in `app/store/ephemeral.py` with async lock, TTL sweep, cascade delete, and SessionNotFoundError→410 mapping.
- [x] Implement bundled-sample `SnapshotMaterializer` lookup. Implemented in `app/intake/sample_materializer.py` with manifest revalidation, file integrity checks, content-addressed commit_sha, and deterministic snapshot_id.
- [ ] Implement anonymous public-repository materialization with immutable commit resolution, DNS/IP/redirect checks, bounds, archive/path/link rejection, `finally` cleanup, and no code execution or Git mutation.
- [x] Wire health/readiness and Docker/Hugging Face deployment configuration on port 7860 with safe readiness metadata. Wired in `app/main.py` with all routers, middleware, error handlers, and `EphemeralSessionStore` + `BundledSampleMaterializer` on app state.

### Tests owned

- [x] Endpoint contract and error-envelope tests. 14 tests in `tests/test_endpoints.py`: route 201/200/410/422 responses, canonical `{code, message}` envelope shape, contract headers, validation errors.
- [x] Origin allowlist/preflight/originless-health tests.
- [x] Request ID and contract-version header tests.
- [x] Session isolation, expiration/restart, TTL cleanup, and log-redaction tests. 18 tests in `tests/test_store.py`: create, isolation, save/load, cascade delete, TTL sweep, honest 410 after restart.
- [ ] Intake limit, SSRF, redirect, traversal, link, archive, timeout, and cleanup tests (TC-011).
- [x] Deployment health and bundled-sample smoke tests. 7 tests in `tests/test_smoke.py`: health ok/degraded/headers/originless, sample through full stack, stable IDs, all routes registered.

## Developer 2 — deterministic evidence and grounded agent

Suggested first branch: `feat/deterministic-evidence`; follow with `feat/grounded-reasoning` after the evidence graph is integrated.

### Ownership

- `app/analysis/**`
- `app/evidence/**`
- `app/concepts/**`
- `app/reasoning/**`
- `app/learner/**`
- Analyzer, reasoning, and invariant fixtures/tests

### Delivery checklist

- [x] Configure JS, JSX, TypeScript, and TSX Tree-sitter parsers and analyze the bundled `xray-demo-v1` fixture. Verified by `model` commit `4b86a95`; the full 51-test backend suite passes.
- [ ] Extract modules, symbols, declaration spans, imports, direct calls, and unresolved references.
  - [x] Module records, named top-level function symbols, and identifier-only declaration spans are implemented in `model` commit `d151a11`; 61 backend tests pass.
  - [x] Static import references and unsupported dynamic-import records are implemented in `model` commit `9e03645`; 68 backend tests pass. Import target resolution remains open.
  - [x] Direct identifier call references plus explicit unsupported member, computed, optional, dynamic, and caller-scope records are implemented on `model/feat/direct-call-references`; 80 backend tests pass. Call target resolution and ambiguity classification remain open.
- [ ] Emit only exact relative imports and uniquely resolved same-file/named-import calls; omit dynamic, computed, reflective, injected, ambiguous, and parser-failed relations.
- [ ] Validate every published graph edge has the three required provenance anchors and snapshot-scoped spans/symbols.
- [ ] Implement versioned deterministic concept occurrences, evidence packet slicing, and required-claim construction using bounded packets only.
- [ ] Implement the minimal LangGraph typed call, schema/citation/prohibited-language validation, one retry, and deterministic fallback.
- [ ] Return exactly three grounded questions: relationship explanation, path prediction, and concept application.
- [ ] Validate `supported`/`missing`/`unsupported` claims and derive EQ-005 gaps only with repository evidence, learner-attempt evidence, and a missing/unsupported observation.

### Tests owned

- [ ] Symbol, import, call, unresolved-reference, and evidence-anchor fixtures (TC-001–TC-003).
  - [x] Sample symbol/declaration fixtures, export/nesting cases, duplicate-path rejection, and snapshot-ID validation are covered by `d151a11`.
  - [x] Raw import/call fixtures cover the bundled sample, supported import forms, dynamic imports, direct calls across JS/JSX/TS/TSX, unsupported call targets/scopes, stable ordering, and inventory validation. Resolution and evidence-anchor fixtures remain open.
- [ ] Graph invariant failures and model-invented-edge rejection (TC-N01–TC-N02).
- [ ] Gap eligibility and derivation tests (TC-006–TC-007, TC-N03–TC-N04).
- [ ] Exactly-three-question, citation-validation, unsupported-claim, prohibited-language, and model-unavailable tests (TC-008–TC-009).

## Integration and merge sequence

- [x] **0. Shared seam:** HTTP DTO, store, and domain-protocol review complete; contract tests pass.
- [ ] **1. Risk-first graph:** platform adapter with a test engine; sample parser, symbols, exact edges, and graph validator; sample exposes a cited central call edge.
- [ ] **2. Real analysis:** session-scoped bundle persistence and retrieval; connect the real analyzer and concept evidence; omit unsupported/ambiguous relations.
- [ ] **3. Teach-back:** question/evaluation adapters and scope checks; evidence packets, typed reasoning, and citation validation; return three grounded questions and cited feedback.
- [ ] **4. Gap and safety:** TTL, errors, rate limits, and public-intake safety; deterministic EQ-005 gap derivation; no gap before validated attempt evidence.
- [ ] **5. Release:** Space configuration, production checks, sample fallback, and model-unavailable behavior; production sample loop succeeds three times.

Merge the deterministic graph first because it is the highest-risk proof. The platform branch may use test doubles until that merge, then replaces them with the real services. Keep model reasoning in the second evidence/agent merge so model work cannot hide missing deterministic evidence.

## Completion gate

The backend is ready for client integration only when this complete loop passes:

```text
sample -> deterministic graph -> cited selected edge -> three teach-back answers
-> cited supported/missing/unsupported feedback -> eligible gap update -> return to source evidence
```

- [ ] Complete the end-to-end loop above against the bundled sample.
- [ ] Run all MVP and invariant cases.
- [ ] Validate the five documented endpoints and inspect sanitized success/error logs.
- [ ] Run the production bundled-sample smoke test.
- [ ] Keep F-101 through F-104 closed until every preceding completion item passes.
