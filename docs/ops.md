# OPS — Operations & Observability Runbook — X-Ray

> **Scope:** Keep the two-repository hackathon MVP testable through judging. This is not a production SRE commitment.

## Deploy
### Environments
- **Preview:** Vercel preview + non-production Hugging Face Space/config [assumption].
- **Judging:** Vercel production + Hugging Face Docker Space production. Repository identifiers are intentionally not invented.

### Backend first
1. Build the Docker image with lockfile-pinned dependencies; validate FastAPI, Tree-sitter grammar, LangChain/LangGraph, and model SDK versions against official docs at scaffold [assumption].
2. Run unit/fixture tests, including invariant tests and the pre-indexed sample.
3. Deploy the Space exposing one application port.
4. Set Space secrets by name, run authenticated API-106, then run sample analysis.

### Frontend/BFF second
1. Run type, unit, contract, accessibility, and build checks.
2. Set Vercel environment variables by name.
3. Deploy preview; run full sample loop against production-like backend.
4. Promote to production and run the same smoke test.

### Rollback
Rollback Vercel to the previous deployment and the Space to the previous known-good image/commit. Keep API v1 backward compatible across the overlap. If live analysis is unhealthy, keep the UI available in explicit sample-fallback mode; never fabricate a successful analysis.

## Configuration & secrets
| Name | Runtime | Purpose |
|---|---|---|
| `XRAY_BACKEND_BASE_URL` | Vercel | Space origin |
| `XRAY_BACKEND_TOKEN` | Vercel + Space | BFF-to-Space authentication |
| `XRAY_SESSION_SIGNING_KEY` | Vercel | Ephemeral cookie signing |
| `XRAY_ALLOWED_ORIGINS` | Vercel + Space | Origin/host validation |
| `OPENAI_API_KEY` | Space | GPT-5.6 calls |
| `XRAY_MODEL_NAME` | Space | Pinned GPT-5.6 identifier [assumption] |
| `XRAY_LIMIT_*` | Space | Intake/time bounds from API spec |
| `XRAY_SAMPLE_MANIFEST` | Space | Immutable fallback sample version |

Use Vercel and Hugging Face secret stores, never repository files. Rotate backend and signing credentials after exposure or team-member departure; invalidate active ephemeral sessions when signing keys rotate.


## Observability
Use structured logs on both platforms with shared `request_id` and hashed ephemeral `session_id`. Never log source, learner answers, prompts, cookies, URLs with query strings, or secret values.

### Signals
| SLI | Measurement | Why |
|---|---|---|
| Frontend availability | API-010 success and page load | Judge access |
| Backend reachability | Authenticated API-106 via BFF | Detect cold/down Space |
| End-to-end sample success | Scheduled/manual sample loop | Core demo truth |
| Analysis success by stage | terminal ready/failed counts | Locate fetch/parser/model failures |
| Analysis stage latency | coarse stage duration buckets | Cold start/bounds tuning |
| Invariant rejects | evidence-edge/gap validation rejects | Trust regression |
| Model output rejects | schema/citation validation failure | Safe model degradation |
| Cleanup lag | expired workspaces/sessions past TTL | Privacy/storage control |
| Fallback use | explicit sample loads | Reliability signal, not hidden success |

Platform log/metric retention must match `data-model.md`; provider defaults need review [assumption].

## Alerts & thresholds [assumption]
These are initial hackathon thresholds, not measured SLOs:
- **Page immediately:** API-010 fails 2 consecutive 1-minute checks; authenticated API-106 fails after one warm-up retry; sample loop fails; any invariant violation is published; suspected secret exposure.
- **Investigate within 30 minutes:** >20% analysis failure over 10 requests; >20% model-output rejection over 10 calls; p95 analysis exceeds the 60-second bound; cleanup lag exceeds 30 minutes; disk >80%; repeated 429 during judge test.
- **No page:** a single user input rejection, intentionally omitted ambiguous edge, or one model retry that succeeds.

Alert destination/owner tooling is [assumption]. During Manila, Farhana is first DevOps responder and Joshua first backend responder per team context; Global adds Jim/Geinel.

## Runbook — common incidents
### Space cold/unavailable
- **Symptom:** API-010 degraded; BFF gets timeout/503.
- **Diagnose:** call API-106 through authenticated BFF path; inspect Space build/runtime status and latest deployment.
- **Fix:** allow one warm-up retry; rollback failed image; reduce concurrency. Offer visibly labeled pre-indexed sample while live analysis is unavailable.
- **Verify:** API-106 then full sample graph → question → attempt → gap loop.

### Public repository fetch fails
- **Symptom:** `INVALID_SOURCE`, timeout, or bounds error.
- **Diagnose:** check sanitized reason code, host allowlist, immutable revision, redirect/IP decision, limit bucket.
- **Fix:** do not bypass security. Correct allowlist/config or ask for a supported repository/revision; use sample for demo.
- **Verify:** malicious/private-IP cases still reject and known bounded fixture succeeds.

### Parser produces missing/wrong edge
- **Symptom:** expected edge omitted or invariant validator rejects graph.
- **Diagnose:** reproduce against pinned fixture; inspect parser/rule versions and exact spans.
- **Fix:** prefer omission. Update deterministic rule + fixture; never patch output with GPT-5.6.
- **Verify:** evidence-line assertions pass; held-out fixtures show 100% observed precision for rendered edges and at least 70% supported-relationship coverage. Any uncertain relation remains omitted.

### Model unavailable or invalid output
- **Symptom:** `MODEL_UNAVAILABLE` or `MODEL_OUTPUT_REJECTED`.
- **Diagnose:** model config/credential, provider status, schema/citation error counters; do not inspect user body in logs.
- **Fix:** rotate credential if needed, rollback prompt/schema mismatch, permit one retry. Keep deterministic graph usable and sample questions available if explicitly labeled.
- **Verify:** one typed call passes citation validation; invalid fabricated ID is rejected.

### Session loss after restart
- **Symptom:** 410 on previously active analysis.
- **Diagnose:** compare Space restart/deploy time; confirm no persistence promise was made.
- **Fix:** explain expiration and start a new analysis or sample. Do not reconstruct learner state from logs.
- **Verify:** new session works and stale resource remains inaccessible.

### Cross-session access suspected
- **Symptom:** resource appears under wrong session or unusual 404/auth events.
- **Diagnose:** disable affected routes; run ownership tests using two fresh sessions; inspect sanitized request IDs.
- **Fix:** patch authorization, rotate signing key/backend token, invalidate sessions, delete transient state.
- **Verify:** full session-isolation suite and manual two-session attempt.

### Secret exposure
- **Symptom:** secret scan/provider alert or credential in client/log.
- **Fix:** disable endpoint, revoke/rotate immediately, purge deploy artifact/log where supported, redeploy, invalidate sessions, assess notification.
- **Verify:** old credential fails; browser bundle/log sample contains no value.

## Backup & recovery
MVP user/session data is intentionally ephemeral and is **not backed up**. Recovery means redeploying code/config and recreating a session, not restoring learner responses. Back up/version in source control only: both application repositories, lockfiles, Docker config, schemas, Tree-sitter queries, concept rules, method registry, test fixtures, and pre-indexed sample artifact. Secrets are recreated from approved team secret stores, never backups in the repository.

Before judging, export or tag a known-good deployment identifier for each repository [assumption] and test rollback once. Restore test: deploy backend artifact, pass API-106 and invariant fixtures, deploy Vercel artifact, complete the end-to-end sample loop. External durable storage or learner-state backup is future scope requiring an ADR and privacy review.

## Judge-day checklist
- [ ] Production page and API-010 load from a clean browser.
- [ ] Backend authenticated health passes after warm-up.
- [ ] Bundled sample full loop passes and sample version is visible.
- [ ] One bounded public fixture passes; one oversize/unsafe fixture rejects safely.
- [ ] GPT-5.6 structured output and invalid-citation rejection both tested.
- [ ] No secrets/source/learner text appear in inspected logs or browser bundle.
- [ ] Rollback IDs and responders are written in the private team channel [assumption].
- [ ] Demo operator knows the honest fallback and retry script.