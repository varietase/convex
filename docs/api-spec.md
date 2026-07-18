# API Specification — X-Ray

> **Purpose:** Versioned contracts between browser, Vercel BFF, and Hugging Face backend. All bodies are JSON unless noted.

## Overview
- Browser base: same-origin `/api/v1` on Vercel.
- Backend base: `/internal/v1` on the Hugging Face Space; never called by browser [assumption].
- Resource IDs are opaque UUIDv4 strings [assumption]. Times are RFC 3339 UTC.
- Every response carries `X-Request-ID`; JSON successes also include `request_id` (204 has no body). Errors use `{request_id, code, message, retryable, details?}`.
- Repository contents, evidence packets, and learner responses are not accepted in query strings.

## Authentication & authorization
**Browser tier [assumption].** API-001 creates an ephemeral, signed, `HttpOnly`, `Secure`, `SameSite=Strict` cookie plus a CSRF token. There is no account or durable identity in MVP. Mutations require the cookie, CSRF header, and allowed `Origin`. Reads require the cookie. A session may access only resources bearing its `session_id`; mismatches return 404 to avoid enumeration.

**Backend tier [assumption].** The Vercel BFF attaches `Authorization: Bearer <server-held credential>` and `X-XRay-Session` to every Space call. FastAPI validates the credential with constant-time comparison and authorizes every resource against the signed session context. The browser never receives this credential. Credential rotation accepts old and new values for a short deployment overlap [assumption].

## Common schemas
```json
RepositoryInput = {"kind":"sample"|"public_repo","sample_id":"string?","url":"https://…?","revision":"full-commit-sha?"}
SourceSpan = {"evidence_span_id":"uuid","file_path":"string","start_line":1,"start_column":0,"end_line":1,"end_column":1,"excerpt_text":"bounded string"}
EvidenceRef = {"evidence_span_id":"uuid","snapshot_id":"uuid","span":SourceSpan,"content_hash":"sha256","extractor_version":"string"}
Job = {"job_id":"uuid","status":"queued|fetching|parsing|indexing|ready|failed","expires_at":"date-time"}
```

Persisted citation IDs are `SourceSpan.span_id` values, serialized as `evidence_span_id`. API responses expand each ID into an `EvidenceRef` with its parent snapshot, `SourceFile.content_hash`, bounded excerpt, and extractor version. The full source file is not retained.

All structural `Edge` objects contain `from_symbol_id`, `to_symbol_id`, `edge_type`, and non-empty `evidence_refs` (INV-001). All `GapItem` objects contain non-empty `repo_evidence_refs`, `attempt_evidence_refs`, `priority_tier`, and derivation IDs (INV-002).


## Browser-facing endpoints
### API-001 — POST `/api/v1/sessions` — Create ephemeral session
- **Serves:** F-005
- **Request:** empty body; allowed `Origin` required [assumption].
- **Response 201:** `{session:{session_id, expires_at}, csrf_token}` and signed cookie.
- **Auth/authz:** no prior auth; safe because it creates only an empty, rate-limited session. Cookie binds subsequent resources. No repository access.
- **Errors:** `ORIGIN_DENIED`, `RATE_LIMITED`, `SERVICE_UNAVAILABLE`.

### API-002 — POST `/api/v1/sessions/{session_id}/analyses` — Start analysis
- **Serves:** F-001, F-005
- **Request:** `RepositoryInput`; public repos require full immutable commit SHA [assumption].
- **Response 202:** `Job` plus `analysis_id`.
- **Auth/authz:** matching session cookie + `X-CSRF-Token` + allowed origin; session may create only its own analysis.
- **Errors:** `INVALID_SOURCE`, `REVISION_REQUIRED`, `UNSUPPORTED_HOST`, `UNSUPPORTED_LANGUAGE`, `INTAKE_LIMIT_EXCEEDED`, `RATE_LIMITED`.

### API-003 — GET `/api/v1/analyses/{analysis_id}/events` — Analysis progress
- **Serves:** F-001, F-005
- **Response 200:** `text/event-stream`; events `{event_id, stage, message, terminal, occurred_at}`. `Last-Event-ID` supported [assumption].
- **Auth/authz:** session cookie; analysis must belong to session.
- **Errors:** `NOT_FOUND`, `SESSION_EXPIRED`, `EVENT_STREAM_UNAVAILABLE`.

### API-004 — GET `/api/v1/analyses/{analysis_id}/graph?symbol_id=&depth=1` — Evidence graph slice
- **Serves:** F-001, F-002
- **Response 200:** `{snapshot, symbols, edges, concepts, omitted_relationships, text_path, derivation}`. `depth` is fixed to 1 in MVP [assumption].
- **Auth/authz:** session cookie; analysis ownership required.
- **Errors:** `NOT_FOUND`, `ANALYSIS_NOT_READY`, `INVALID_SELECTION`.

### API-005 — POST `/api/v1/analyses/{analysis_id}/narratives` — Grounded semantic-zoom narrative
- **Serves:** F-002
- **Request:** `{selection:{symbol_ids, edge_ids}, view:"pseudocode"|"module_role"|"path_explanation"}`.
- **Response 200:** `{sections:[{kind,text,evidence_refs}], derivation}`; deterministic graph slice remains available if narrative fails.
- **Auth/authz:** cookie + CSRF + origin; ownership required.
- **Errors:** `INVALID_SELECTION`, `EVIDENCE_BUDGET_EXCEEDED`, `MODEL_UNAVAILABLE`, `MODEL_OUTPUT_REJECTED`.

### API-006 — POST `/api/v1/analyses/{analysis_id}/teach-back/questions` — Create question set
- **Serves:** F-004
- **Request:** `{selection:{symbol_ids,edge_ids}}`.
- **Response 201:** `{question_set_id, questions:[{question_id,prompt,question_type,target_concept_ids,target_evidence_refs}], count_derivation}` with exactly three questions.
- **Auth/authz:** cookie + CSRF + origin; ownership required.
- **Errors:** `INSUFFICIENT_EVIDENCE`, `MODEL_UNAVAILABLE`, `MODEL_OUTPUT_REJECTED`.

### API-007 — POST `/api/v1/question-sets/{question_set_id}/attempts` — Submit teach-back
- **Serves:** F-003, F-004
- **Request:** `{question_id, response_text}`; UTF-8, 1–4,000 characters [assumption].
- **Response 201:** `{attempt_id, feedback:{claims:[{disposition,text,feedback,evidence_refs}]}, affected_concepts, derivation}`. No score or mastery label.
- **Auth/authz:** cookie + CSRF + origin; question set/session ownership required; one active submission per question/idempotency key [assumption].
- **Errors:** `INVALID_RESPONSE`, `NOT_FOUND`, `MODEL_UNAVAILABLE`, `MODEL_OUTPUT_REJECTED`, `CONFLICT`.

### API-008 — GET `/api/v1/sessions/{session_id}/gaps` — List eligible concept gaps
- **Serves:** F-003
- **Response 200:** `{items:[GapItem], derivation}`. Items sort by EQ-005 categorical order, then stable concept ID; no opaque score.
- **Auth/authz:** session cookie; path session must equal authenticated session.
- **Errors:** `NOT_FOUND`, `SESSION_EXPIRED`.

### API-009 — DELETE `/api/v1/sessions/{session_id}` — Delete session
- **Serves:** F-003–F-005, INV-003
- **Response 204:** empty; repeated deletion is idempotent.
- **Auth/authz:** cookie + CSRF + origin; only own session. Clears cookie after delete request is accepted.
- **Errors:** `NOT_FOUND`, `DELETE_IN_PROGRESS`.

### API-010 — GET `/api/v1/health` — Judge-facing health
- **Serves:** operational availability
- **Response 200/503:** `{status:"ok"|"degraded", sample_ready, backend_reachable, checked_at}`; no secret/config detail.
- **Auth/authz:** none; safe, read-only, rate-limited, and reveals only coarse status. It does not expose backend health payload or resource IDs.
- **Errors:** `RATE_LIMITED`.

## Backend-only endpoints
Every backend endpoint requires the BFF bearer credential and accepts no browser cookie. API-101–API-105 and API-107–API-108 also require signed `X-XRay-Session`; API-106 is the bearer-authenticated, non-session health exception. Resource endpoints authorize ownership against the session claim.

### API-101 — POST `/internal/v1/analyses` — Execute bounded analysis
- **Serves:** F-001, F-005
- **Request/response:** normalized API-002 request; returns API-002 job/analysis shape.
- **Auth/authz:** valid backend credential; session claim may create resources only for itself. On first authorized use, the backend atomically creates an `AnalysisSession` projection from signed `session_id` and `expires_at` if absent [assumption]; CSRF state remains BFF-only.
- **Errors:** same as API-002 plus `BACKEND_AUTH_FAILED`.

### API-102 — GET `/internal/v1/analyses/{analysis_id}/events` — Backend progress stream
- **Serves:** F-001, F-005
- **Response:** SSE shape from API-003.
- **Auth/authz:** backend credential + owning session claim.
- **Errors:** `BACKEND_AUTH_FAILED`, `NOT_FOUND`.

### API-103 — GET `/internal/v1/analyses/{analysis_id}/graph` — Backend graph slice
- **Serves:** F-001, F-002
- **Request/response:** validated API-004 query/shape.
- **Auth/authz:** backend credential + owning session claim.
- **Errors:** `BACKEND_AUTH_FAILED`, `ANALYSIS_NOT_READY`, `INVALID_SELECTION`.

### API-104 — POST `/internal/v1/reasoning` — Narrative or questions
- **Serves:** F-002, F-004
- **Request:** discriminated union `{task:"narrative"|"questions", analysis_id, selection, view?}`.
- **Response:** API-005 or API-006 payload.
- **Auth/authz:** backend credential + owning session claim; backend reconstructs evidence packet rather than trusting supplied evidence.
- **Errors:** `BACKEND_AUTH_FAILED`, `INSUFFICIENT_EVIDENCE`, `MODEL_OUTPUT_REJECTED`.

### API-105 — POST `/internal/v1/question-sets/{question_set_id}/attempts` — Evaluate and persist
- **Serves:** F-003, F-004
- **Request/response:** API-007 body/shape.
- **Auth/authz:** backend credential + owning session claim.
- **Errors:** `BACKEND_AUTH_FAILED`, `INVALID_RESPONSE`, `MODEL_OUTPUT_REJECTED`, `CONFLICT`.

### API-106 — GET `/internal/v1/health` — Authenticated dependency health
- **Serves:** operations
- **Response 200/503:** coarse parser/sample/model-configuration readiness; never returns secret values.
- **Auth/authz:** backend bearer credential; read-only but protected because it exposes internal dependency state.
- **Errors:** `BACKEND_AUTH_FAILED`.

### API-107 — GET `/internal/v1/sessions/{session_id}/gaps` — Backend gap read
- **Serves:** F-003
- **Request/response:** API-008 query/shape.
- **Auth/authz:** backend credential + session claim exactly matching the path session; every gap must reference repository and attempt evidence owned by that session.
- **Errors:** `BACKEND_AUTH_FAILED`, `NOT_FOUND`, `SESSION_EXPIRED`.

### API-108 — DELETE `/internal/v1/sessions/{session_id}` — Backend session deletion
- **Serves:** F-003–F-005, INV-003
- **Response 204:** cascade deletion accepted; repeated request remains 204 even when backend session state is already absent.
- **Auth/authz:** backend credential + session claim exactly matching the path session. No bulk or cross-session deletion route exists.
- **Errors:** `BACKEND_AUTH_FAILED`, `DELETE_IN_PROGRESS`.

## Canonical error codes
| Code | HTTP | Meaning |
|---|---:|---|
| `BACKEND_AUTH_FAILED` | 401 | BFF credential/session signature invalid |
| `ORIGIN_DENIED` | 403 | Browser origin or CSRF validation failed |
| `NOT_FOUND` | 404 | Resource absent or not owned by session |
| `SESSION_EXPIRED` | 410 | Ephemeral session no longer exists |
| `DELETE_IN_PROGRESS` | 409 | Session deletion has already begun |
| `CONFLICT` | 409 | Idempotency/submission state conflict |
| `INVALID_SOURCE`, `INVALID_RESPONSE`, `INVALID_SELECTION` | 422 | Contract validation failure |
| `EVIDENCE_BUDGET_EXCEEDED` | 422 | Safe bounded packet cannot be formed |
| `UNSUPPORTED_HOST`, `UNSUPPORTED_LANGUAGE`, `REVISION_REQUIRED` | 422 | Intake outside MVP boundary |
| `INTAKE_LIMIT_EXCEEDED` | 413 | Byte/file/line bound exceeded |
| `RATE_LIMITED` | 429 | Request/concurrency quota exceeded |
| `ANALYSIS_NOT_READY` | 409 | Graph requested before ready |
| `INSUFFICIENT_EVIDENCE` | 422 | Safe output cannot be grounded |
| `MODEL_UNAVAILABLE`, `SERVICE_UNAVAILABLE` | 503 | Dependency unavailable |
| `MODEL_OUTPUT_REJECTED` | 502 | Structured/citation validation failed |
| `EVENT_STREAM_UNAVAILABLE`, `UPSTREAM_TIMEOUT` | 504 | Long-running dependency timed out |

## Rate limits [assumption]
Per ephemeral session and source IP: 3 session creations/hour/IP, 3 analyses/session/hour, 10 reasoning calls/session/hour, 10 attempt submissions/session/hour, 60 read requests/minute, one concurrent analysis/session, and two concurrent analyses per Space instance. Breach returns 429 with `Retry-After`. Limits are operational assumptions to tune from observed judge traffic; they do not authorize user tracking beyond retention in `data-model.md`.

## Versioning
Major version is in the path. Additive fields may appear within v1; clients ignore unknown response fields. Breaking changes require `/v2`. Each derived response includes schema/analyzer/rule/equation versions. Deprecation is documented in both repositories and supported through one coordinated deployment overlap [assumption].