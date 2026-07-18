# Security & Compliance / Threat Model — convex

> **Scope:** Public hackathon deployment with bounded public repositories, ephemeral learner responses, and no source-code writes.

## Data classification
| Data | Class | Location | Rule |
|---|---|---|---|
| Bundled sample and public snapshot full content | Public, user-selected | Space transient workspace | Delete after parsing; do not log source |
| Bounded cited source excerpts | Public-derived / session-confidential | Space ephemeral store | Minimum necessary lines; 24h TTL [assumption] |
| Evidence graph and file paths | Public-derived / session-confidential | Space ephemeral store; direct HTTPS in transit | Session-local authorization; 24h TTL [assumption] |
| Teach-back response and learner state | User content / potentially personal | Browser session state (session-local, client-held) | Never persisted server-side beyond the active session |
| Backend/model credentials | Secret | HF Space secret store | Never expose to browser or logs |
| Sanitized operational metadata | Internal | platform logs | No source, prompt, answer, token, or credential bodies |

MVP does not solicit names, email, accounts, private repositories, or repository credentials. Public code may still contain accidentally committed secrets; convex treats all source as sensitive in handling and never includes unrelated source in model evidence packets.

## Authn / authz model
- **Browser → Space:** the browser calls the FastAPI backend directly over HTTPS. The sole browser-origin boundary is an explicit CORS allowlist (the deployed Cloudflare origin plus local development origins), never a wildcard; non-health requests without an origin and requests with a disallowed origin fail before body handling. Originless `GET /health` is permitted solely for platform probes. There is no session cookie, CSRF token, or bearer credential.
- **Authorization:** `POST /v1/analyses` creates an opaque UUIDv4 `sessionId`; the browser holds and resubmits it with `snapshotId` for all later operations. The backend has no durable per-user identity, admin route, or cross-session endpoint; scope mismatches return 404 without existence disclosure.
- **Repository authority:** only anonymous read of allowlisted public HTTPS hosts or bundled sample IDs; no OAuth, SSH keys, write token, git push, or provider mutation API (INV-003).
- Exact CORS allowlist entries are an implementation detail pending scaffold validation.


## Threat model
| T-ID | STRIDE | Vector / impact | Mitigation | Enforces |
|---|---|---|---|---|
| T-001 | Spoofing | Forged/guessed session identifier accesses another session's graph or response | Opaque session-scoped IDs, ownership checks, 404 on mismatch, short TTL | INV-002, BR-004 |
| T-002 | Spoofing | Request from a disallowed origin reaches the backend | FastAPI CORS allowlist rejects non-allowlisted origins before body processing | BR-010 |
| T-003 | Tampering | Model output inserts a structural edge or false citation | Separate schemas, graph writes unavailable to model path, citation allowlist, fail-closed invariant validator | INV-001, BR-001–003 |
| T-004 | Tampering | Crafted archive/path overwrites files or escapes workspace | Stream extraction, normalized relative paths, reject links/special files/nested archives, isolated workspace | INV-003, BR-007 |
| T-005 | Tampering | Repo build scripts execute during analysis | Never install dependencies or run repository code; parser-only pipeline; least-privilege container | INV-003 |
| T-006 | Repudiation | Cannot explain why a gap/category appeared | Derivation records with equation, datasets, rule/model versions, evidence IDs; sanitized request IDs | INV-002, BR-004–005 |
| T-007 | Information disclosure | Source/learner text leaks in logs or model packets | Body-redaction, no prompt/source logging, minimum evidence slices, TTL, deletion endpoint | INV-002, BR-007 |
| T-008 | Information disclosure | SSRF reaches metadata/private services | HTTPS host allowlist, DNS/IP validation before and after redirect, reject private/link-local/metadata ranges, egress policy where available [assumption] | INV-003 |
| T-009 | Information disclosure | Public repo contains secrets copied to model | Bounded selected evidence only; secret-pattern redaction/abort [assumption]; user warning; never log packets | INV-003 |
| T-010 | Denial of service | Large/decompression-bomb repo exhausts Space | Streaming byte/file/line/time caps, no nested archives, concurrency and rate limits, cleanup | BR-006 |
| T-011 | Denial of service | Model or Space cold start breaks demo | Explicit progress/timeouts, one retry, circuit response, versioned pre-indexed sample | BR-009–010 |
| T-012 | Elevation | Client changes session/resource IDs or internal fields | FastAPI schema validation; backend reconstructs evidence packets from server-side state, not client-asserted fields | INV-001–003 |
| T-013 | Elevation | Future MCP caller gains write/tool access | Future threat review; sidecar tools read-only and no shell/editor mutation authority | INV-003 |
| T-014 | Tampering | Parser ambiguity teaches a false path | Deep single-family support, exact-only edges, fixture precision gate, omit ambiguity | INV-001 |

## Abuse & safety-specific risks
| Risk | Who is harmed | Trigger | Guard |
|---|---|---|---|
| False mental model | Learner | Fabricated or ambiguous edge | Deterministic exact-only graph, evidence links, “not enough evidence” (INV-001) |
| Unfair learner judgment | Learner | Evaluation treated as ability/mastery | Critique response only; binary supported/missing/unsupported evidence; no score/mastery language claim (INV-002) |
| Generic curriculum disguised as personal | Learner | Concept shown without attempt evidence | Gap eligibility requires repo + learner evidence (INV-002) |
| Source damage | Repository owner | Analyzer executes or writes | Parser-only, no credentials, no mutation surface (INV-003) |
| Third-party code exposure | Repository owner/contributor | Public code unnecessarily sent to model | Minimum evidence packet, transient storage, source-license notice [assumption] |
| Demo deception | Judges/users | Pre-indexed sample shown as live result | Explicit sample label and immutable sample version |

## Compliance obligations
- **Privacy:** MVP intentionally minimizes personal data and provides session deletion/TTL. Applicable privacy-law roles, region, and controller contact are not supplied [assumption]; do not claim certification or full legal compliance. Publish a plain retention notice before external use.
- **Repository licenses/terms:** analyze only user-selected public content, preserve provenance, do not republish full source, and verify repository-host/model-provider terms [assumption]. Public availability is not a universal reuse license.
- **Accessibility:** target WCAG 2.2 AA from PRD/brand: keyboard graph traversal, visible focus, non-color states, reduced motion, and text path alternatives.
- **Children/education:** no age assurance or school deployment is designed [assumption]. Do not solicit sensitive student records; institutional/child use needs separate review.
- No claim of SOC 2, ISO 27001, FERPA, COPPA, GDPR certification, or security audit is made.

## Secrets handling
- Store the model provider key (`OPENAI_API_KEY`) in Hugging Face Space runtime secrets only. The Cloudflare Workers client holds no backend credential — there is nothing to relay.
- Never prefix server-only secrets for client exposure, return them from health APIs, copy them into logs, or include values in docs.
- Use separate preview/production values [assumption]. Rotate on suspected exposure; revoke old value.
- Repository intake receives no provider token in MVP. Any code path requesting GitHub write/private-repo OAuth fails security review.

## Audit & logging
Log: request ID, hashed ephemeral session ID, route, status, duration bucket, analyzer/rule/schema version, model request ID, error code, rate-limit event, deletion completion, and invariant violation. Do not log source text, full repository URL/query, file contents, learner response, model prompt/output body, auth headers, API keys, or evidence packet. Retain sanitized logs 7 days [assumption] and anonymous counters 30 days [assumption]. Audit derivations live only with the 24-hour session.

## Incident response basics
1. **Detect:** `/health`, 5xx/rate/invariant counters, smoke test, user report.
2. **Contain:** disable public-repo intake or model reasoning independently; keep clearly labeled sample mode if safe. Revoke credentials for suspected secret exposure.
3. **Eradicate:** patch affected repository, rotate secrets, delete active sessions/transient workspaces, rebuild image.
4. **Recover:** deploy backend, verify `/health` and sample flow, redeploy client if needed, run full loop and negative security tests.
5. **Notify/document:** product lead + backend/DevOps point person; assess whether repository owners/model provider/platform must be notified [assumption]. Record timeline without sensitive payloads.

## Pre-milestone hard-gate checklist
- [ ] The five documented endpoints (`GET /health`, `POST /v1/analyses`, `POST /v1/xray`, `POST /v1/teachbacks/questions`, `POST /v1/teachbacks/evaluate`) match `api-spec.md`; no undocumented network route. — 2026-07-18
- [ ] Browser bundle contains no backend/model secret; secret scan passes. — 2026-07-18
- [ ] SSRF, path traversal, symlink, nested archive, oversize, timeout, and cleanup tests pass. — 2026-07-18
- [ ] INV-001 test rejects an evidence-less edge; held-out rendered edges have 100% observed precision and uncertain relations remain omitted. — 2026-07-18
- [ ] INV-002 test rejects a gap missing either evidence class; no score/mastery copy. — 2026-07-18
- [ ] INV-003 static/runtime checks confirm no write token, repository mutation API, code execution, commit, or PR path. — 2026-07-18
- [ ] Session isolation, CORS-origin allowlist, expiration, and deletion tests pass. — 2026-07-18
- [ ] Logs inspected under success/error paths contain no source, response, prompt, or secret body. — 2026-07-18
- [ ] Pre-indexed fallback is visibly labeled and cannot be confused with submitted-repo analysis. — 2026-07-18
- [ ] Decision ledger, ADR-0001, and current deployment agree; ADR-0002 remains future-only. — 2026-07-18
