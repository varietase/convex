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
- [x] Implement anonymous public-repository materialization with immutable commit resolution, DNS/IP/redirect checks, bounds, archive/path/link rejection, `finally` cleanup, and no code execution or Git mutation.
  - [x] `PublicRepositoryMaterializer` (with `app/intake/ssrf.py`, `github_fetcher.py`, `composite.py`, `cleanup.py`) resolves the ref to an immutable commit SHA and fetches a GitHub archive over an allowlisted-HTTPS, GET-only, credential-free boundary — never a git clone. `app/intake/ssrf.py` validates scheme/userinfo/host/port and rejects loopback/link-local/metadata/private/reserved/multicast resolved IPs before every request and on each redirect hop. Extraction is stdlib `tarfile` with per-member validation (no `extract`/`extractall`, no tar metadata): symlink/hardlink/special/traversal/absolute-path/nested-archive/submodule members fail closed, only JS/JSX/TS/TSX files are written, and the 40-file / 750KB-source / 60KB-file / 5MB-archive / 20MB-extracted / 20s-timeout bounds reject outright (413 `LIMIT_EXCEEDED` with a `limits` payload; 504 `ANALYSIS_TIMEOUT`; 404 `REPOSITORY_NOT_FOUND`; 422 for malformed refs or unsupported language). The temp workspace is deleted on every failure path inside `materialize` and via a route-level `finally` after analysis; the bundled sample fixture is structurally never deletable. Repository code is data — never executed, installed, or mutated (INV-003/TC-N05). `CompositeMaterializer` dispatches sample vs `github_public` in `create_app`. Verified on `model/feat/public-intake`; full 361-test suite passes with no network access in tests.
- [x] Wire health/readiness and Docker/Hugging Face deployment configuration on port 7860 with safe readiness metadata. Wired in `app/main.py` with all routers, middleware, error handlers, and `EphemeralSessionStore` + `BundledSampleMaterializer` on app state.

### Tests owned

- [x] Endpoint contract and error-envelope tests. `tests/test_endpoints.py`: route 200/410/422 responses (analyses standardized on 200 per api-spec), canonical `{code, message}` envelope shape, contract headers, validation errors.
- [x] Origin allowlist/preflight/originless-health tests.
- [x] Request ID and contract-version header tests.
- [x] Session isolation, expiration/restart, TTL cleanup, and log-redaction tests. 18 tests in `tests/test_store.py`: create, isolation, save/load, cascade delete, TTL sweep, honest 410 after restart.
- [x] Intake limit, SSRF, redirect, traversal, link, archive, timeout, and cleanup tests (TC-011).
  - [x] `tests/test_ssrf.py` covers scheme/userinfo/host/port rejection and every disallowed IPv4/IPv6 range (loopback, RFC1918, link-local, metadata `169.254.169.254`, ULA, v4-mapped, multicast, unspecified), mixed public/private resolution, and redirect-hop re-validation + cap. `tests/test_public_intake.py` covers traversal, absolute-path, symlink, hardlink, nested-archive, submodule, mixed-prefix, and every bound (per-file / count / total-source / extracted / archive-download cap via `httpx.MockTransport`) plus timeout→504, 404 propagation, unsupported-language→422, malformed-identifier pre-fetch rejection, snapshot determinism, and a temp-dir scan proving every failure path cleans up. `tests/test_public_intake_endpoints.py` drives the `github_public` path through `create_app` for the 200 graph (TC-010 public face), 413-with-limits, 404, 422, and sample regression; `tests/test_invariants.py` adds the TC-N05 no-execution/no-credential static scan.
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
- [x] Extract modules, symbols, declaration spans, imports, direct calls, and unresolved references.
  - [x] Module records, named top-level function symbols, and identifier-only declaration spans are implemented in `model` commit `d151a11`; 61 backend tests pass.
  - [x] Static import references and unsupported dynamic-import records are implemented in `model` commit `9e03645`; 68 backend tests pass. Broader import target resolution remains open.
  - [x] Direct identifier call references plus explicit unsupported member, computed, optional, dynamic, and caller-scope records are implemented in `model` commit `864f68b`; 80 backend tests pass. Cross-module target resolution remains open.
  - [x] Reconciled: the "broader import" and "cross-module" resolution residuals above were closed by the same-file and named-relative-import resolution stints (next item); all remaining unsupported forms are captured as explicit unresolved-reference records by design. Nothing open.
- [x] Emit only exact relative imports and uniquely resolved same-file/named-import calls; omit dynamic, computed, reflective, injected, ambiguous, and parser-failed relations.
  - [x] Unique, unshadowed same-file identifier calls now emit internal three-anchor edges on `model/feat/same-file-call-resolution`; imported bindings are deferred, while missing, ambiguous, shadowed, and mutated targets remain unresolved. The full 95-test backend suite passes.
  - [x] Exact named-relative imports now resolve the bundled `buildReport -> normalizeScore` call with `named-relative-import` and three anchors on `model/feat/named-relative-import-resolution`; 105 backend tests pass. Namespace/default/module relationships and broad path rules remain open.
  - [x] Reconciled: namespace/default/module relationships are required omissions under this item's own rule — they are recorded as explicit unresolved references and never emitted as edges, which the resolution fixtures verify. The item is satisfied as written; nothing open in MVP scope.
- [x] Validate every published graph edge has the three required provenance anchors and snapshot-scoped spans/symbols.
  - [x] `DeterministicAnalysisEngine` now produces an immutable, persistence-safe bundle and validates snapshots, symbols, bounded spans, stable edge IDs, exact endpoint declarations, call ownership, and all three provenance anchors before returning. Verified on `model/feat/analysis-engine-bundle` with 92 focused Developer 2 tests. Platform injection/API projection remain open.
  - [x] Reconciled: edge validation itself is complete; the "platform injection/API projection" residual is Developer 1's application-factory work, tracked in integration item 1 — not part of this item.
- [x] Implement versioned deterministic concept occurrences, evidence packet slicing, and required-claim construction using bounded packets only. All three components below are complete; nothing open.
  - [x] `DeterministicEvidenceService` slices a validated analysis bundle into a detached, stable, bounded packet: selected symbol, incident/explicit edges, endpoint symbols, and complete three-anchor evidence only. Unknown/unrelated selections, invalid bundles, and over-budget packets fail closed; no partial edge evidence is emitted. Verified on `model/feat/evidence-packet-slicer` with 98 focused evidence/graph tests.
  - [x] The initial deterministic concept registry maps every published direct call edge to one versioned `function-composition` occurrence. Each occurrence has a content-derived ID and is bound to its edge, both endpoint symbols, and all three existing provenance anchors; missing, stale, reordered, or corrupted occurrences reject the bundle. Packets include occurrences only when their full edge evidence is included. Verified on `model/feat/concept-occurrences` with 111 focused evidence/graph tests.
  - [x] `build_required_claims` turns the first stably ordered packet edge into exactly three internal targets — relationship explanation, path prediction, and concept application — each bound to the matching `function-composition` occurrence and complete three-anchor evidence. Empty/malformed packets and reordered/corrupted claim sets fail closed. Verified on `model/feat/required-claim-targets` with 115 focused evidence/graph tests.
- [x] Implement the minimal LangGraph typed call, schema/citation/prohibited-language validation, one retry, and deterministic fallback.
  - [x] `GroundedReasoningService` runs `call_model -> validate -> (one retry) -> deterministic fallback` on the `/v1/xray` explain path and is wired into the application factory. Pure validators — not the prompt — enforce span-ID citations, relationship-span mapping for call/import claims, concept binding, unknown-field rejection, and the prohibited mastery/percentage lexicon; the deterministic fallback passes the same validators and returns the "Not enough evidence" literal for edgeless packets. `MODEL_UNAVAILABLE` now maps to 503 with the canonical envelope, and runtime model failure returns a 200 deterministic fallback, never 5xx. `questions`/`evaluate` raise a clean not-implemented pending the teach-back stints. Verified on `model/feat/grounded-reasoning` commit `ee88c96`; the full 234-test backend suite passes with no OpenAI network access in tests.
- [x] Return exactly three grounded questions: relationship explanation, path prediction, and concept application.
  - [x] `POST /v1/teachbacks/questions` now returns exactly three ordered grounded questions built on `build_required_claims`, phrased by the model through a second LangGraph pipeline. Pure question validators — not the prompt — enforce the exact-three order, per-claim anchor-span binding, packet concept binding, repo-specific symbol mention, and the shared prohibited lexicon; question IDs are deterministic UUIDv5 values derived from required-claim IDs so evaluation can re-derive them without persistence. Runtime model failure retries once then serves deterministic template questions at 200; keyless deployments return the 503 `MODEL_UNAVAILABLE` envelope; ungroundable selections return the new 422 `NOT_ENOUGH_EVIDENCE` envelope. This stint also pins the public `QuestionSpec` contract (`questionId`, `questionType`, `prompt`, `conceptId`, `evidenceRefIds`). Verified on `model/feat/grounded-questions` commit `cad942f`; the full 262-test backend suite passes with no OpenAI network access in tests.
- [x] Validate `supported`/`missing`/`unsupported` claims and derive EQ-005 gaps only with repository evidence, learner-attempt evidence, and a missing/unsupported observation.
  - [x] `POST /v1/teachbacks/evaluate` re-derives the canonical primary-edge question set from the bundle (`canonical_selection`, replacing the broken selection-less packet call), requires submitted answers to match the issued question IDs exactly (mismatch → 422 `NOT_ENOUGH_EVIDENCE`), and runs a third LangGraph pipeline over the typed `EvaluationOutput` contract. Pure validators — not the prompt — enforce per-question kind coverage, anchor-span citations, packet concept binding, the unsupported "not enough evidence" copy, and the prohibited lexicon over claim text and feedback. Gap derivation is deterministic and model-free: `app/learner/gaps.py` pins the EQ-005 formula (`gap_score = 0.70*learner_gap + 0.30*repository_relevance`) and emits a `ConceptGap` — additively extended with `gapScore`, `rank`, and `reasonCodes` alongside the new `LearnerEvidence` DTO — only with repository occurrence evidence, learner-attempt evidence, and ≥1 missing/unsupported observation (INV-002 fail-closed). Runtime model failure retries once then fails closed at 200 with empty claim lists and zero gaps; keyless deployments return the 503 `MODEL_UNAVAILABLE` envelope. Verified on `model/feat/grounded-evaluation` commit `80390bb`; the full 300-test backend suite passes with no OpenAI network access in tests.

### Tests owned

- [x] Symbol, import, call, unresolved-reference, and evidence-anchor fixtures (TC-001–TC-003).
  - [x] Sample symbol/declaration fixtures, export/nesting cases, duplicate-path rejection, and snapshot-ID validation are covered by `d151a11`.
  - [x] Raw import/call fixtures cover the bundled sample, supported import forms, dynamic imports, direct calls across JS/JSX/TS/TSX, unsupported call targets/scopes, stable ordering, and inventory validation. Resolution and evidence-anchor fixtures remain open.
  - [x] Same-file resolution fixtures cover unique and recursive calls, ambiguity, lexical/import shadowing, mutation, missing targets, stable edge IDs, imported-call deferral, inventory mismatch, and exact three-anchor provenance. Complete graph fixtures remain open.
  - [x] Named-relative fixtures cover the bundled central edge, same-file edge composition, exact-path rules, missing/ambiguous exports, duplicate bindings, unsupported import kinds, non-relative imports, and path escape rejection. Namespace/module and API projection fixtures remain open.
  - [x] Reconciled: the resolution, evidence-anchor, and complete-graph residuals above were closed by the later resolution/engine/packet stints; namespace/module forms are covered as rejection and unresolved-reference fixtures per the omission rule; API projection fixtures belong to Developer 1's graph-response work (integration item 1). TC-001–TC-003 are fully covered for Developer 2's scope.
- [x] Graph invariant failures and model-invented-edge rejection (TC-N01–TC-N02).
  - [x] Bundle-level negative fixtures reject invented endpoints, missing/swapped anchors, wrong snapshot/hash, oversized excerpts, duplicate edge IDs, malformed workspaces, and parser failures. Model-facing invented-citation and ungrounded relationship-claim rejection is now covered for xray narratives (`ee88c96`), for questions, including out-of-claim-span citations (`cad942f`), and for evaluation, where fabricated or out-of-anchor citations force the fail-closed zero-gap result (`80390bb`).
- [x] Gap eligibility and derivation tests (TC-006–TC-007, TC-N03–TC-N04).
  - [x] The TC-006 property (no GapItem without both non-empty evidence classes) and the exact EQ-005 matrix are covered in `tests/test_gap_derivation.py`; TC-007 (no mastery/percentage copy) is asserted over the full serialized evaluate response; TC-N03 (concept without repository evidence) and TC-N04 (no attempt evidence) never render a gap (`80390bb`).
- [x] Exactly-three-question, citation-validation, unsupported-claim, prohibited-language, and model-unavailable tests (TC-008–TC-009).
  - [x] Citation-validation, prohibited-language, retry/fallback, and model-unavailable (503 envelope) tests cover the explain path in `tests/test_reasoning_validation.py`, `tests/test_reasoning_service.py`, and endpoint additions (`ee88c96`). Exactly-three-question fixtures (count, order, span/concept binding, repo-specificity, deterministic IDs, template fallback, 503/422 envelopes) are covered in `tests/test_question_validation.py`, `tests/test_question_service.py`, and endpoint additions (`cad942f`). Unsupported-claim fixtures (disposition separation, the "not enough evidence" copy literal, fail-closed zero-gap fallback, answer-mismatch 422) are covered in `tests/test_evaluation_validation.py`, `tests/test_evaluation_service.py`, and endpoint additions (`80390bb`).

## Integration and merge sequence

- [x] **0. Shared seam:** HTTP DTO, store, and domain-protocol review complete; contract tests pass.
- [x] **1. Risk-first graph:** platform adapter with a test engine; sample parser, symbols, exact edges, and graph validator; sample exposes a cited central call edge.
  - [x] The real Developer 2 engine runs bundled workspace -> deterministic bundle -> validated central named-import edge and persists through `EphemeralSessionStore`. `create_app` now wires `DeterministicAnalysisEngine` and `DeterministicEvidenceService` by default, and `POST /v1/analyses` returns the projected graph inline per api-spec (`{sessionId, snapshotId, commitSha, symbols, edges, unresolvedReferences, analyzerVersion}`, standardized on 200): the sample exposes the central `buildReport -> normalizeScore` edge with three expanded `EvidenceRef` anchors whose IDs join the span-ID strings the reasoning endpoints cite. New `Symbol`, `UnresolvedReference`, and `AnalysisResponse` contracts pin the previously undocumented payload shapes. Verified on `model/feat/graph-projection`; the full 308-test backend suite passes, and the smoke test now runs the real engine through pure `create_app` defaults with no test doubles.
- [x] **2. Real analysis:** session-scoped bundle persistence and retrieval; connect the real analyzer and concept evidence; omit unsupported/ambiguous relations.
  - [x] Persistence/retrieval pre-existed in `EphemeralSessionStore`; the real analyzer and concept evidence are now connected application-wide via the `create_app` default wiring. Unsupported/ambiguous relations are omitted from `edges` and surfaced as typed `unresolvedReferences` (reason + candidate symbols), verified by projection fixtures (ambiguous/missing targets never project an edge). Concepts are intentionally absent from the analyses payload per api-spec — they surface through the xray/teach-back paths.
- [ ] **3. Teach-back:** question/evaluation adapters and scope checks; evidence packets, typed reasoning, and citation validation; return three grounded questions and cited feedback.
  - [x] Developer 2 side complete on `model/feat/grounded-evaluation` (`80390bb`): question/evaluation reasoning, canonical scope checks, packet slicing, citation validation, three grounded questions, and cited supported/missing/unsupported feedback with the deterministic EQ-005 gap update all run through the real stack in tests. The formerly open production injection is resolved by the `create_app` default wiring on `model/feat/graph-projection`; the remaining gap for this item is a keyed end-to-end run of the live teach-back loop.
- [x] **4. Gap and safety:** TTL, errors, rate limits, and public-intake safety; deterministic EQ-005 gap derivation; no gap before validated attempt evidence.
  - [x] TTL sweep, canonical errors, and rate/concurrency limits pre-existed; deterministic EQ-005 gap derivation with INV-002 fail-closed eligibility landed on `model/feat/grounded-evaluation` (`80390bb`). The public-intake safety boundary (SSRF, bounds, archive/path/link rejection, `finally` cleanup, no code execution) completes this item on `model/feat/public-intake`; the real-network manual check is deferred to the release stint.
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
