# Decision Ledger — convex

> **What this is.** The append-only record of decisions, pivots, rejected approaches, naming decisions, immutable IDs, decision assumptions, and invariant audits. Under FMD 4.3 it owns *decision history* — not a veto over every other doc. Concern ownership: product behavior → `docs/prd.md`; architecture/deployment → `docs/system-design.md`; test intent → `docs/qa-test-plan.md`; **current execution state → `docs/implementation-plan.md`**; decisions/pivots/names/immutable IDs → this ledger and ADRs. A decision that affects product behavior or architecture is recorded here **and** reconciled into its owning doc in the same checkpoint; this ledger does not silently override the PRD, system design, or QA plan. A disagreement is a failed checkpoint to reconcile, not a winner to pick.
>
> **What this is not.** It does not freeze the product, and it is no longer the "live truth" tracker for execution status — that moved to the living implementation plan. It keeps change coherent and prevents rejected directions or speculative architecture from silently becoming current truth.
>
> **Last reconciled:** 2026-07-20 — FMD 4.2.0 → 4.3.0 migration (execution state moved to `docs/implementation-plan.md`; ownership framing updated; ADR-0007). Prior: 2026-07-19 — Cloudflare Workers client deployment (ADR-0003) + backend grounded-reasoning/graph-projection/public-intake milestone; client live at `https://convex.varietase.workers.dev`.

## 1. Names & immutable identifiers (read first)
| Name / ID | Kind | Where it appears | Rule |
|---|---|---|---|
| convex | Public product name | UI, pitch, README, judge-facing materials, and conversational references | Use lowercase `convex` consistently unless sentence casing or a logo asset requires otherwise. |
| comprehension control layer for code | Category phrase | Product and pitch copy | Use to distinguish the product from explainers and IDEs. |
| F-001–F-005, F-101–F-104 | Immutable feature IDs | Idea, PRD, downstream specifications, QA | Preserve IDs exactly; do not renumber during refinement. |
| INV-001–INV-003 | Immutable invariant IDs | Idea, PRD, security, design, QA | Preserve IDs and meanings exactly; changes require a logged invariant-change pivot. |
| Client repository + deployment | Technical ID | Deployment/config | Repo `varietase/client` (`xray-client`); deployed on Cloudflare Workers (OpenNext) as worker `convex`, live at `https://convex.varietase.workers.dev`. |
| AWS EC2 instance identifier | Technical ID | Deployment/config | Not supplied; do not invent [assumption]. |

## 2. Current truth (confidence, not a gate)
| TRUE (shipped / decided, behaviorally supported) | PROVISIONAL (decided, not yet verified end-to-end) | UNVALIDATED (do not state as fact) |
|---|---|---|
| The product is convex. | The MVP can deliver the full proof-of-comprehension loop within the four-day build window. | Student builders will choose to pause shipping and use the product. |
| The wedge is proof-of-comprehension: deterministic structural evidence + learner-state/gap map + teach-back. | Deterministic analysis can reach the required precision on the selected demo repositories. | The product has a validated payer or viable revenue model. |
| The product is not a generic explainer, chatbot, code generator, or IDE. | A bundled sample or bounded public repository snapshot is sufficient for the MVP demo and first user tests. | Any institutional payer will enter an evaluation or purchase process. |
| Structural claims must trace to deterministic source evidence. | The client framework, graph renderer, deployment IDs, persistence mechanism, and measured runtime bounds remain to be chosen or verified [assumption]. | The tool improves seven-day retention or interview outcomes. |
| Learner recommendations must derive from the real repository and demonstrated answers. | The user-facing experience can meet the stated WCAG 2.2 AA target in the hackathon window. | Learner-state scoring thresholds or concept mastery levels are known. |
| The product is read-only on user code. | Deployment will remain accessible through Global judging as required by context. | Private repository intake, authentication, persistence, and multi-user behavior are part of MVP. |
| Current implementation baseline is two repositories: a Cloudflare Workers-hosted client and an AWS EC2 backend using FastAPI, LangChain, and LangGraph. | The direct browser-to-EC2 contract integration remains to be verified. | A single-repository, local-only, desktop, IDE-native, or other architecture is current. |
| The backend implements the full F-001–F-005 surface: deterministic Tree-sitter analysis, a three-anchor evidence graph, grounded GPT-5.6 explain/question/evaluate pipelines, deterministic EQ-005 gap derivation, and fail-closed public-repo intake; 300+ local tests pass with no network access in tests. | End-to-end verification on the deployed EC2 backend (keyed model run + production smoke ×3) remains open; the root `model` pin (`80390bb`) must move to `origin/main` (`d06dc29`) to serve the wired graph. | That local tests pass proves the deployed backend is healthy before a keyed production smoke. |
| MVP is F-001 through F-005; Final is F-101 through F-104. | The client worktree now includes a final-product repository connection shell: public GitHub URL path, MCP placeholder path, shared `/dashboard`, and no frontend GitHub OAuth/token storage. | Unsupported structural relations can safely be inferred by a model. |

## 3. Pivots & decisions (newest first)
### 2026-07-21 — D5: `api-spec.md` reconciled to the shipped backend contract (docs were wrong, not the code)
- **Type:** documentation-vs-code reconciliation (same class as D3/TASK-004: match shipped code)
- **Change:** `docs/api-spec.md` is corrected against the `model` submodule at pin `46ce4cd`. (1) The sample input field is `sampleId`, not `sample_id` — the model declares `Field(alias="sampleId")` and only tolerates snake_case via `populate_by_name=True`. (2) `/v1` response bodies carry **no** `request_id`; every `/v1` model is `extra="forbid"` with no such field, so the ID is header-only (`X-Request-ID`). Only `GET /health` repeats it in-body. (3) Five reachable error codes were undocumented: `SESSION_NOT_FOUND` (410), `SNAPSHOT_NOT_FOUND` (404), `WORKSPACE_ACCESS_DENIED` (403), `VALIDATION_ERROR` (422), `INTERNAL_ERROR` (500). (4) Eight schemas were referenced but never defined (`Symbol`, `UnresolvedReference`, `Selection`, `QuestionSpec`, `ClaimFinding`, `QuestionEvaluation`, `LearnerEvidence`, `ConceptGap`) and are now specified. (5) `data-model.md` §TeachBackQuestion's `question_type` enum (`prediction`/`explanation`) was stale; the shipped enum is the three-value grounding.
- **Why:** The `model` submodule had never been initialized in this worktree, so the client contract was being written from docs alone. Initializing it (TASK-005) exposed the drift. `SESSION_NOT_FOUND` matters most: it is the ordinary 1800s-TTL expiry every idle tab hits, and an undocumented code would have surfaced to learners as a generic failure instead of "analyze again."
- **Invalidated:** `sample_id` as the sample-input field name; "JSON successes also include `request_id`" as a `/v1` statement; the claim that the seven documented error codes are the complete set; `prediction|explanation` as the teach-back question-type enum.
- **Kept:** All backend behavior. No endpoint, status code, invariant, or payload changed — this records what the backend has been doing since `46ce4cd`. Status codes remain intentionally many-to-one with codes (403/404/422 are each shared), so clients branch on `code`.
- **Open:** The deployed EC2 instance is not verified to be running `46ce4cd`; this reconciliation is true of that pin, not proven of production. Confirm at TASK-009 (full-loop verification).
- **Recorded as:** This entry; `docs/api-spec.md`; `docs/data-model.md`; implementation-plan TASK-017 + §7 change log. PRD/system-design/QA untouched — no product or architecture truth changed.

### 2026-07-21 — Hybrid repository connection shell for final-product UX
- **Type:** product-surface + architecture placeholder
- **Change:** The client experience now presents repository onboarding as two paths: primary **Add Repository Link** for public GitHub repositories and secondary **Connect with MCP** for private/local repositories. All landing/nav Add Repository Link actions open one shared modal; the form is not left inline on the landing page. The MCP path closes the public form before showing Waiting/Connecting/Connected/Failed placeholder UI and a searchable repository selector. Both public and MCP selections route to the same `/dashboard` shell.
- **Why:** The product is moving from a demo-specific repository story to a final-product flow that can support public GitHub repositories, private repositories through a local MCP host, and local repositories without changing the dashboard experience.
- **Invalidated:** UI/documentation copy that frames the flow around Varietas repositories or implies the only product journey is a bundled/sample repository. Also invalidated: any frontend plan that asks users to paste private repository URLs or perform GitHub OAuth in the web app.
- **Kept:** The shipped backend authority is still the Cloudflare Workers client calling the AWS EC2 FastAPI backend directly for F-001-F-005. Real MCP host authentication, private/local repository indexing, and MCP App surfaces remain future backend/MCP work until the local host contract, security review, and tests exist.
- **Recorded as:** PRD UF-000/BR-011/BR-012/AC-016/AC-017/AC-105; system design DF-000 and MCP adapter boundary; technical design A-000; QA TC-012; security credential boundary; design-system modal/dashboard specs; this ledger; CR-005.

### 2026-07-20 — Backend deployment pivot: Hugging Face Docker Space → AWS EC2
- **Type:** platform
- **Change:** Backend deployment target changed from Hugging Face Docker Space to AWS EC2. The application (FastAPI, Tree-sitter, LangChain/LangGraph, GPT-5.6) is unchanged; only the hosting platform moved. HF write token is no longer needed; OpenAI API key is configured on the EC2 instance directly.
- **Why:** Cost control (EC2 allows stopping/starting vs always-on Space billing); credential simplification (only OpenAI key needed, no HF token); deployment flexibility.
- **Invalidated:** 'Hugging Face Docker Space' as the current backend host; 'Space secrets' as the credential mechanism; 'port 7860 on a Docker Space' as the deployment topology (app may still use 7860 internally but is hosted on EC2, not HF); the operational risk about 'Space is not yet deployed (blocked on Hugging Face access)' — EC2 is now deployed.
- **Open:** Exact EC2 endpoint URL/IP not yet recorded in this repo; monitoring/alerting on EC2 to be confirmed; whether the instance is behind a load balancer or direct.
- **Recorded as:** This ledger entry; AGENTS.md updated in commit 4570339; docs reconciled in this checkpoint.

### 2026-07-20 — Adopt FMD 4.3 living-execution model
- **Type:** process
- **Change:** Upgraded the vendored factory FMD 4.2.0 → 4.3.0. `docs/implementation-plan.md` became the **living execution-state owner** (stable `TASK-###` rows: status, one owner, dependencies, bounded write scope, work ref, executable gate/evidence; derived waves + ready/blocked/parallel/cut view). Canonical ownership is now by concern (PRD = product, system design = architecture, QA = test intent, implementation plan = execution state, this ledger + ADRs = decisions/history); the old "if a doc disagrees, the ledger wins" rule is retired in favor of reconcile-at-owner. `docs/next-steps.md` was re-labeled historical/detail background and points active status to the living plan.
- **Why:** FMD 4.2 docs drifted each sprint and no artifact owned trustworthy execution state; ADR-0007 records the factory-side rationale. A team using markdown + chat needs one honest "what's next" surface with a deterministic structural gate (`check-implementation-plan.py`).
- **Invalidated:** the framing that this ledger is "live/current truth" that overrides other docs; that `next-steps.md` is the active execution tracker; that `implementation-plan.md` is only the historical Manila five-hour schedule (now its Appendix A).
- **Open:** the 12 seeded `TASK-###` rows are honest but mostly `blocked`/`ready`; nothing is verified `done`. External blocker TASK-001 (OpenAI + Hugging Face credentials) still gates the deploy→integration→loop chain. D3 (session TTL) is directed to 1800s to match shipped code but its ledger/`data-model.md` reconciliation is TASK-004's execution.
- **Recorded as:** ADR-0007 (factory); this entry; docs reconciled in the same migration checkpoint — `index.md`, `AGENTS.md`, `onboarding.md`, and this ledger's ownership framing. No code, submodules, secrets, deployment config, or host automation were touched.

### 2026-07-19 — Cloudflare Workers client deployment + backend feature-complete milestone
- **Type:** platform + implementation
- **Change:** (1) Client host Vercel → **Cloudflare Workers (OpenNext)**, live at `https://convex.varietase.workers.dev` (ADR-0003; supersedes ADR-0001's host choice only). (2) The backend is now feature-complete for F-001–F-005 — deterministic evidence graph, grounded explain/question/evaluate pipelines, EQ-005 gap derivation, and fail-closed public-repo intake — with 300+ passing tests.
- **Why:** The client was built and deployed on Cloudflare, never Vercel, so the docs had drifted from reality. The backend advanced well past the contracts-and-health scaffold this ledger last recorded.
- **Invalidated:** "Vercel-hosted client" as current truth; the "29 tests / reasoning pipelines remain to be implemented" scaffold status; the glossary implication that a Vercel BFF/proxy holds a credential (there is no BFF).
- **Open:** The root pins the `model` submodule at `80390bb`, where `create_app` leaves `analysis_engine`/`evidence_service` unset; `origin/main` (`d06dc29`) wires them and adds public intake. Re-pin + deploy to a Hugging Face Space (blocked on HF access + the model API key) + a keyed production smoke ×3 remain before the loop is live end to end.
- **Recorded as:** ADR-0003; `docs/next-steps.md`; canonical docs reconciled Vercel → Cloudflare in this change. Architecture otherwise unchanged — two repositories, direct browser→Space call, CORS allowlist, no BFF/proxy.

### 2026-07-18 — Freeze the browser session and origin boundary for v1
- **Type:** implementation
- **Change:** `POST /v1/analyses` creates and returns an opaque UUIDv4 `sessionId` with `snapshotId`; `/v1/xray` and both teach-back routes require both identifiers. Originless `GET /health` is permitted for platform probes; every other browser-facing request requires an exact configured `Origin` before route/body handling.
- **Why:** The prior endpoint schemas omitted the session handle required by the data/security model, while the middleware allowed originless feature requests. Freezing both seams lets the platform and evidence/agent lanes work independently against one explicit v1 contract.
- **Invalidated:** The implication that a session was created by an undocumented endpoint, or that an originless feature request could enter route handling.
- **Recorded as:** `model` branch `feat/shared-contract-gate`; API, data, technical, system, security, and backend implementation documents reconciled. The v1 major path and `1.0.0` contract version remain unchanged because this baseline has not been released.

### 2026-07-18 — Lock the first backend contract and readiness scaffold
- **Type:** implementation
- **Change:** provisional backend versions and UUIDv4 graph IDs → lockfile-pinned Python 3.12 backend, contract `1.0.0`, analyzer `xray-js-ts-1`, current FastAPI/Tree-sitter/LangChain/LangGraph/OpenAI integrations, `gpt-5.6`, content-derived SHA-256 snapshot/symbol/edge IDs, the documented intake limits, and sample `xray-demo-v1` with a named-import/call central path
- **Why:** The 0:00–0:20 gate requires a reproducible health surface, shared contract, sample, limits, stable IDs, and invariant tests before feature work. Current official API checks prevent coding fast-moving dependencies from memory.
- **Invalidated:** The API-spec assumption that graph resource IDs are random UUIDv4 values; claims that backend dependency versions, supported language family, limits, or local commands are still wholly undecided.
- **Recorded as:** `model` branch `feat/contracts-health`; canonical API/data/technical documents reconciled in this change. Live Hugging Face and Vercel deployment identifiers remain open.

### Initial dependency phase — Lock the proof-of-comprehension wedge
- **Type:** use-case
- **Change:** broad code explanation / visualization → proof-of-comprehension through deterministic evidence, learner-state/gap mapping, and teach-back
- **Why:** Generic explanation is already commoditized and does not show whether the learner can explain the repository. The differentiated demo must connect structural truth to demonstrated understanding.
- **Invalidated:** Claims that an explanation, visualization, or chatbot response alone constitutes comprehension.
- **Recorded as:** This ledger; no ADR supplied.

### Initial dependency phase — Establish the current two-repository baseline
- **Type:** platform
- **Change:** unspecified implementation topology → Vercel-hosted client repository plus Hugging Face Docker Space repository running FastAPI, LangChain, and LangGraph
- **Why:** `context.md` states this as the implementation baseline and requires availability through Global judging.
- **Invalidated:** Claims that single-repository, local-only, desktop, IDE-native, or alternative cloud layouts are current architecture.
- **Recorded as:** This ledger; no ADR supplied.

### Initial dependency phase — Separate MVP from final product
- **Type:** zoom-in
- **Change:** full product surface → MVP F-001 through F-005 first; Final F-101 through F-104 only after the core loop works
- **Why:** The four-day judged build rewards one clear end-to-end demo over broad, broken scope.
- **Invalidated:** Claims that longitudinal tracking, an MCP/extension surface, cross-repository learner state, or agent teaching tools are MVP requirements.
- **Recorded as:** This ledger; no ADR supplied.

## 4. Rejected approaches (what was considered and killed)
| Approach considered | Rejected because | Would revisit if |
|---|---|---|
| Generic "explain this code" product | Produces prose but does not establish repo-level structural truth, personalized gaps, or proof that the learner can explain the code. | Never as the product wedge; explanations may remain a subordinate view grounded in deterministic evidence. |
| AI tutor chatbot as the primary experience | Turns the product into open-ended Q&A and makes unsupported claims difficult to constrain; the unit is evidence + gap map + teach-back. | Only as a constrained interaction over cited evidence, without replacing the core loop. |
| IDE or code editor | Competes with mature coding tools, expands scope, and conflicts with the read-only comprehension contract. | Never as an IDE; an in-workflow read-only surface may be considered under F-102. |
| Code generator, debugger, linter, or PR-review tool | Solves a different job and risks moving attention away from proving comprehension. | Only after a separate product decision and invariant audit; not in the current product. |
| Standalone visualization as the product | A graph alone does not create a learning outcome; prior code-map products show weak value when detached from a specific learner goal. | If paired with observable teach-back and learner-state outcomes; that paired form is the current wedge. |
| Single-repository architecture | Conflicts with the current context-defined deployment baseline. | If deployment constraints make two repositories infeasible and a logged platform decision supersedes the baseline. |
| Alternative client host or backend platform | Not the current architecture; recording alternatives as current would create implementation drift. | If Cloudflare or AWS EC2 cannot satisfy judged availability or required functionality, supported by deployment evidence. |
| Alternative backend framework or orchestration stack | FastAPI, LangChain, and LangGraph are the current baseline. Alternatives are unsupported specifics until evaluated. | If an implementation test shows the baseline cannot deliver the MVP loop in time and the platform decision is logged. |

## 5. Invariant audit
| Phase | INV-### | Change that touched it | Audit verdict |
|---|---|---|---|
| Backend scaffold 2026-07-18 | INV-001 | Added strict structural-edge schema and stable evidence ID formulas. | **Kept:** every edge requires source definition, relationship site, and target definition; extra/model-only evidence fields fail validation. |
| Backend scaffold 2026-07-18 | INV-002 | Added strict concept-gap evidence schema. | **Kept:** repository and learner-attempt evidence arrays are both required and non-empty. |
| Backend scaffold 2026-07-18 | INV-003 | Added the five-route contract registry and activated only read-only `/health`. | **Kept:** no mutation route exists; wildcard/disallowed browser origins fail closed. |
| Initial dependency phase | INV-001 | Defined graph extraction, semantic zoom, teach-back evaluation, and narrative boundary. | **Kept:** every structural edge requires deterministic source evidence; unsupported edges are omitted. |
| Initial dependency phase | INV-002 | Defined learner-state and concept-gap behavior. | **Kept:** every shown gap requires repository and demonstrated-answer evidence; generic top-N lists are blocked. |
| Initial dependency phase | INV-003 | Defined repository intake and the two-repository deployment baseline. | **Kept:** intake and all downstream behavior remain read-only; writes, commits, and pull requests are forbidden. |

## 6. Open items / risks
- **Adoption risk:** The primary user may not pause to prove comprehension during a time-pressured build; behavior remains unvalidated.
- **Technical trust risk:** Supported static analysis must reach at least 70% precision on the held-out demo set, with unsupported edges omitted.
- **Scope risk:** The MVP must keep F-001 through F-005 as one loop; adding F-101 through F-104 before that loop works is a scope failure.
- **Architecture detail risk:** Client framework, graph renderer, deployment IDs, persistence, session behavior, and measured runtime limits remain [assumption]; backend libraries, JS/TS language family, contract version, intake caps, and model alias are locked but not yet verified end to end on the deployed EC2 instance.
- **Operational risk:** The Cloudflare Workers client and AWS EC2 backend must remain accessible through Global judging; the EC2 instance is deployed but monitoring, alerting, and recovery details remain [assumption].
- **Payer risk:** No payer has been found; institutional buyers and purchase intent remain unvalidated.
- **Accessibility risk:** Full keyboard graph traversal and text-equivalent paths may be difficult in the build window but remain part of the brand baseline.
- **Evidence risk:** Dates and claims imported from `idea.md` require source verification before external publication where not already verified.

## 7. Feature and invariant spine
### MVP
- **F-001 — Evidence-backed repository graph**
- **F-002 — Semantic zoom explorer**
- **F-003 — Personal concept-gap map**
- **F-004 — Teach-back verification loop**
- **F-005 — Demo-safe repository intake**

### Final
- **F-101 — Comprehension-delta ledger**
- **F-102 — In-workflow MCP App / extension surface**
- **F-103 — Cross-repository learner graph**
- **F-104 — Agent teaching contract**

### Invariants
- **INV-001** — **never fabricate structural edges.** Every call, import, or data-flow edge shown to the user must be traceable to a concrete symbol reference in the actual code, produced by deterministic static analysis. LLM narrative sits on top of the graph; it never invents the graph.
- **INV-002** — **the concept-gap list is derived from the user's real repo, never a generic top-N.** If the product cannot personalize from the actual code, it does not show a list.
- **INV-003** — **read-only on the user's code.** Never modify, never commit, never PR.

## References
- `idea.md` — problem, evidence, feature spine, success metrics, constraints, and invariant spine.
- `context.md` — hackathon constraints and the current two-repository implementation baseline.
- `brand.md` — positioning, voice, copy constraints, visual direction, and accessibility baseline.
- `docs/prd.md` — current product requirements and EARS acceptance criteria.
- `fmd/templates/decision-ledger.md` — artifact structure.
