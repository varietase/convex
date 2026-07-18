# Backend Implementation Plan — Two Developer Split

## Purpose and boundaries

This plan delivers the MVP backend loop for F-001 through F-005: bundled/public repository intake, deterministic evidence graph, grounded explanation, teach-back, and an evidence-backed gap update. The browser calls the Hugging Face FastAPI service directly over HTTPS; there is no BFF or repository-mutation capability.

The non-negotiable boundaries are:

- **INV-001:** render structural edges only when deterministic evidence supplies exactly three anchors: source definition, relationship site, and target definition.
- **INV-002:** render a concept gap only with both repository evidence and validated learner-attempt evidence.
- **INV-003:** never execute, modify, commit, push, or otherwise write user code.
- GPT-5.6 may explain or evaluate an evidence packet; it cannot create graph facts, concepts, or gap eligibility.

Canonical contracts and acceptance gates remain `docs/api-spec.md`, `docs/technical-design.md`, `docs/qa-test-plan.md`, and `docs/security-compliance.md`. This document assigns implementation ownership; it does not replace those documents.

## Shared contract gate — first 20–30 minutes

Both developers complete this before parallel implementation.

1. Freeze the v1 Pydantic DTOs and pure service protocols under `app/domain/`. Changes afterward require a small, separate contract change before either implementation branch consumes them.
2. Add an opaque `sessionId` to the analysis response and require it on xray and teach-back requests. The client holds and resubmits this handle; the backend uses it to scope ephemeral snapshot, evidence, questions, and learner state. This reconciles the data/security model with the endpoint schemas.
3. Decide and document originless health-check behavior. Recommended policy: permit originless `GET /health` for platform probes; require an exact allowlisted `Origin` for browser POST requests.
4. Freeze the service seams below and test them with fakes. Keep `CONTRACT_VERSION = 1.0.0` unless an intentional breaking API change is approved.

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

1. Activate `POST /v1/analyses`, `POST /v1/xray`, `POST /v1/teachbacks/questions`, and `POST /v1/teachbacks/evaluate` as thin adapters over injected services. Test doubles are allowed only in tests; production routes cannot return invented feature data.
2. Complete transport policy:
   - request ID and contract-version headers on success and error responses;
   - exact-origin allowlist and preflight handling;
   - canonical error envelope and HTTP mapping;
   - bounded request timeout, concurrency/rate limiting, and `Retry-After`;
   - sanitized logs with no source, repository URL/query, learner answer, prompt, model packet, or secret body.
3. Implement ephemeral session/snapshot storage, ownership checks, TTL sweep, deletion cascade, and honest `410` after restart/expiration.
4. Implement `SnapshotMaterializer`:
   - bundled-sample lookup;
   - anonymous HTTPS public-repository fetch and immutable commit resolution;
   - DNS/IP/redirect validation and host allowlist;
   - archive/file/source/timeout limits;
   - rejection of traversal, absolute paths, symlinks, hardlinks, submodules, nested archives, and special files;
   - `finally` cleanup and no dependency install, shell command, interpreter, or Git mutation.
5. Wire Health/readiness and Docker deployment configuration. Preserve port 7860 and report only safe readiness metadata.

### Tests owned

- Endpoint contract and error-envelope tests.
- Origin allowlist/preflight/originless-health tests.
- Request ID and contract-version header tests.
- Session isolation, expiration/restart, TTL cleanup, and log-redaction tests.
- Intake limit, SSRF, redirect, traversal, link, archive, timeout, and cleanup tests (TC-011).
- Deployment health and bundled-sample smoke tests.

## Developer 2 — deterministic evidence and grounded agent

Suggested first branch: `feat/deterministic-evidence`; follow with `feat/grounded-reasoning` after the evidence graph is integrated.

### Ownership

- `app/analysis/**`
- `app/evidence/**`
- `app/concepts/**`
- `app/reasoning/**`
- `app/learner/**`
- Analyzer, reasoning, and invariant fixtures/tests

### Delivery order

1. Configure JS, JSX, TypeScript, and TSX Tree-sitter parsers and analyze the bundled `xray-demo-v1` fixture.
2. Extract modules, symbols, declaration spans, imports, direct calls, and unresolved references.
3. Emit only exact, supported structural relations:
   - direct relative module imports;
   - named and namespace relative imports;
   - uniquely resolved same-file identifier calls;
   - uniquely resolved named imported calls.

   Dynamic imports, computed calls, reflection, runtime dependency injection, ambiguous re-exports, parser failures, and unresolved targets produce no edge.
4. Validate each graph before publication. Every edge must contain the exact three provenance anchors and all referenced spans/symbols must belong to the immutable snapshot.
5. Implement versioned deterministic concept occurrences, evidence packet slicing, and required-claim construction. Model-facing functions receive only bounded evidence packets, never a workspace or full repository.
6. Implement the minimal LangGraph flow: typed GPT-5.6 request → strict schema/citation/prohibited-language validation → one retry → deterministic unavailable/not-enough-evidence fallback.
7. Return exactly three grounded teach-back questions: relationship explanation, path prediction, and concept application.
8. Validate claim dispositions as `supported`, `missing`, or `unsupported`; then derive gaps with EQ-005. A gap requires repository evidence, learner-attempt evidence, and at least one missing/unsupported observation. Never show mastery, a percentage, or a generic concept list.

### Tests owned

- Symbol, import, call, unresolved-reference, and evidence-anchor fixtures (TC-001–TC-003).
- Graph invariant failures and model-invented-edge rejection (TC-N01–TC-N02).
- Gap eligibility and derivation tests (TC-006–TC-007, TC-N03–TC-N04).
- Exactly-three-question, citation-validation, unsupported-claim, prohibited-language, and model-unavailable tests (TC-008–TC-009).

## Integration and merge sequence

| Slice | Platform developer | Evidence/agent developer | Gate |
|---|---|---|---|
| 0. Shared seam | HTTP DTO review and store protocol | Domain/protocol review | Contract compiles and fakes pass. |
| 1. Risk-first graph | `/v1/analyses` adapter with fake engine | Sample parser, symbols, exact edges, graph validator | Sample exposes a cited central call edge. |
| 2. Real analysis | Persist/retrieve analysis bundle by session | Connect real analyzer and concept evidence | Unsupported/ambiguous relations are omitted. |
| 3. Teach-back | Question/evaluation route adapters and session checks | Evidence packets, typed reasoning, citation validator | Three grounded questions and cited feedback work. |
| 4. Gap and safety | TTL, errors, rate limits, public-intake safety | Deterministic EQ-005 gap derivation | No gap before validated attempt evidence. |
| 5. Release | Space configuration and production checks | Sample fallback and model-unavailable behavior | Production sample loop succeeds three times. |

Merge the deterministic graph first because it is the highest-risk proof. The platform branch may use test doubles until that merge, then replaces them with the real services. Keep model reasoning in the second evidence/agent merge so model work cannot hide missing deterministic evidence.

## Completion gate

The backend is ready for client integration only when this complete loop passes:

```text
sample -> deterministic graph -> cited selected edge -> three teach-back answers
-> cited supported/missing/unsupported feedback -> eligible gap update -> return to source evidence
```

Before a demo or deployment, run all MVP and invariant cases, validate the five documented endpoints, inspect sanitized success/error logs, and run the production bundled-sample smoke test. Do not begin F-101 through F-104 until this loop works end to end.
