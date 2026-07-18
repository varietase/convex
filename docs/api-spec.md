# API Specification — convex

> **Purpose:** Versioned contract between the browser (`xray-client` on Cloudflare Workers) and the backend (`xray-backend`, FastAPI on a Hugging Face Docker Space, port 7860). The browser calls the backend directly over HTTPS JSON — there is no BFF/proxy and no internal API mirror. Endpoints are synchronous; the MVP avoids queues, polling, and background jobs.

## Overview
- Backend base: the deployed Hugging Face Space origin, called directly by the browser.
- Access control: FastAPI CORS allowlist (deployed Cloudflare origin `https://convex.varietase.workers.dev` + local development origins), never a wildcard. There is no session cookie, CSRF token, or bearer credential. `POST /v1/analyses` creates an opaque `sessionId`; the browser holds and resubmits it with each later request so the backend can scope ephemeral state.
- Request/session/artifact IDs are opaque UUIDv4 strings [assumption]. Snapshot, symbol, and structural-edge IDs are opaque 64-character SHA-256 values derived from immutable evidence using the formulas in `technical-design.md`; times are RFC 3339 UTC.
- Every response carries `X-Request-ID`; JSON successes also include `request_id`. Errors use `{code, message, limits?}` per the schema below.
- Repository contents, evidence packets, and learner responses are not accepted in query strings.
- There are intentionally no repository-mutation endpoints (no commit/push/PR/write route of any kind).

## Common schemas
```json
RepositoryInput =
  {"type":"sample","sample_id":"xray-demo-v1"}
  | {"type":"github_public","owner":"string","repo":"string","ref":"string"}

SessionScope = {
  "sessionId":"opaque UUIDv4",
  "snapshotId":"64-character SHA-256 ID"
}

EvidenceRef = {
  "id":"string","snapshotId":"string","commitSha":"string","filePath":"string",
  "startLine":1,"startColumn":0,"endLine":1,"endColumn":1,
  "snippet":"bounded string","fileHash":"sha256"
}

StructuralEdge = {
  "id":"string","kind":"calls"|"imports"|"module-import",
  "sourceId":"string","targetId":"string",
  "evidence":{"sourceDefinitionRef":EvidenceRef,"relationshipRef":EvidenceRef,"targetDefinitionRef":EvidenceRef},
  "resolutionMethod":"same-file-identifier"|"named-relative-import"|"namespace-relative-import"|"relative-module-import",
  "callArguments":["string"]?
}

ApiError = {
  "code":"ORIGIN_NOT_ALLOWED"|"UNSUPPORTED_SOURCE"|"LIMIT_EXCEEDED"|"ANALYSIS_TIMEOUT"|"REPOSITORY_NOT_FOUND"|"NOT_ENOUGH_EVIDENCE"|"MODEL_UNAVAILABLE",
  "message":"string",
  "limits":{"key":0}?
}
```

Every rendered `StructuralEdge` carries exactly three evidence anchors (INV-001); an edge with fewer is never emitted — the relationship becomes an unresolved reference instead. Every `ConceptGap` returned by teach-back evaluation carries both `repositoryEvidenceRefIds` and `learnerEvidenceIds` (INV-002).

## Endpoints

### `GET /health`
- **Serves:** deployment and model/parser readiness.
- **Response 200/503:** `{request_id,status:"ok"|"degraded",sample_ready,parser_ready,model_configured,checked_at,contract_version,analyzer_version}`; no secret/config detail. Headers include the same `X-Request-ID` and `X-Contract-Version`.
- **Auth/authz:** none; safe and read-only. An originless platform probe is permitted; a request that supplies `Origin` must supply an exact allowlisted browser origin.
- **Errors:** none beyond standard 5xx.

### `POST /v1/analyses`
- **Serves:** F-001, F-005
- **Request:** `RepositoryInput`. For `github_public`, `ref` may be a branch/tag/commit; the backend resolves it to a concrete commit SHA and analyzes that immutable snapshot.
- **Response 200:** `{sessionId, snapshotId, commitSha, symbols:[Symbol], edges:[StructuralEdge], unresolvedReferences:[UnresolvedReference], analyzerVersion}`. The backend creates the opaque `sessionId`; it is required alongside `snapshotId` for later xray and teach-back calls.
- **Behavior:** synchronous — the response is returned once analysis completes or the 20-second intake/analysis timeout is reached. Oversized/out-of-bounds input (40 files, 750KB total, 60KB/file, 5MB compressed, 20MB extracted) is rejected outright with `LIMIT_EXCEEDED`, never silently truncated.
- **Errors:** `UNSUPPORTED_SOURCE`, `LIMIT_EXCEEDED`, `ANALYSIS_TIMEOUT`, `REPOSITORY_NOT_FOUND`.

### `POST /v1/xray`
- **Serves:** F-002
- **Request:** `{sessionId, snapshotId, selection:{symbolId, edgeIds?}, view:"pseudocode"|"module_role"}`.
- **Response 200:** `XRayExplanation` — `{role:{text,evidenceRefIds}, pseudocode:[{text,evidenceRefIds}], concepts:[{conceptId,explanation,evidenceRefIds}], uncertainties:[string]}`. Every statement cites evidence IDs already present in the graph; a statement referencing an unknown ID is discarded before the response is returned. If no valid statement remains, the response says "Not enough evidence to provide this explanation."
- **Errors:** `NOT_ENOUGH_EVIDENCE`, `MODEL_UNAVAILABLE`.

### `POST /v1/teachbacks/questions`
- **Serves:** F-004
- **Request:** `{sessionId, snapshotId, selection:{symbolId, edgeIds?}}`.
- **Response 200:** `{questions:[QuestionSpec]}` with exactly three entries, each grounded in deterministic evidence (relationship-explanation, path-prediction, concept-application).
- **Errors:** `NOT_ENOUGH_EVIDENCE`, `MODEL_UNAVAILABLE`.

### `POST /v1/teachbacks/evaluate`
- **Serves:** F-003, F-004
- **Request:** `{sessionId, snapshotId, answers:[{questionId, responseText}]}`. Exactly three bounded answers are required for a completed question set.
- **Response 200:** `{evaluations:[QuestionEvaluation], learnerEvidence:[LearnerEvidence], conceptGaps:[ConceptGap]}`. `QuestionEvaluation` separates `supported`/`missing`/`unsupported` claims per question, each citing evidence IDs; unsupported claims read "not enough evidence." `conceptGaps` includes only concepts with both repository evidence and learner-answer evidence, ranked by `gap_score = 70% learner_gap + 30% repository_relevance`. No feedback text claims mastery or complete understanding.
- **Errors:** `NOT_ENOUGH_EVIDENCE`, `MODEL_UNAVAILABLE`.

## Canonical error codes
| Code | HTTP | Meaning |
|---|---:|---|
| `ORIGIN_NOT_ALLOWED` | 403 | A non-health request omits `Origin`, or any request supplies an origin outside the exact allowlist; rejected before route/body handling |
| `UNSUPPORTED_SOURCE` | 422 | Private repo, unsupported language, or malformed source reference |
| `LIMIT_EXCEEDED` | 413 | File count/size/archive/timeout bound exceeded — rejected, not truncated |
| `ANALYSIS_TIMEOUT` | 504 | Intake/analysis exceeded the 20-second bound |
| `REPOSITORY_NOT_FOUND` | 404 | Public repository or ref could not be resolved |
| `NOT_ENOUGH_EVIDENCE` | 422 | The call target is dynamically computed or otherwise undeterminable; safe output cannot be grounded |
| `MODEL_UNAVAILABLE` | 503 | GPT-5.6 dependency unavailable; deterministic graph content still returned where applicable |

Examples:
- "This snapshot contains 63 supported source files; the MVP limit is 40."
- "No JavaScript or TypeScript source files were found."
- "The call target is dynamically computed; not enough evidence to establish an edge."
- "Explanation is temporarily unavailable. Structural evidence remains available."

## Versioning
Major version is in the path (`/v1`). Additive fields may appear within v1; clients ignore unknown response fields. Breaking changes require `/v2`. Each response includes the analyzer version used to produce it.
