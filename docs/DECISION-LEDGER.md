# Decision Ledger — convex

> **What this is.** The append-only record of current truth, pivots, rejected approaches, naming decisions, and invariant audits. If another project document disagrees with this ledger, this ledger wins until reconciliation.
>
> **What this is not.** It does not freeze the product. It keeps change coherent and prevents rejected directions or speculative architecture from silently becoming current truth.
>
> **Last reconciled:** 2026-07-18 — backend contracts-and-health scaffold.

## 1. Names & immutable identifiers (read first)
| Name / ID | Kind | Where it appears | Rule |
|---|---|---|---|
| convex | Public product name | UI, pitch, README, judge-facing materials, and conversational references | Use lowercase `convex` consistently unless sentence casing or a logo asset requires otherwise. |
| comprehension control layer for code | Category phrase | Product and pitch copy | Use to distinguish the product from explainers and IDEs. |
| F-001–F-005, F-101–F-104 | Immutable feature IDs | Idea, PRD, downstream specifications, QA | Preserve IDs exactly; do not renumber during refinement. |
| INV-001–INV-003 | Immutable invariant IDs | Idea, PRD, security, design, QA | Preserve IDs and meanings exactly; changes require a logged invariant-change pivot. |
| Vercel client repository identifier | Technical ID | Deployment/config | Not supplied; do not invent [assumption]. |
| Hugging Face Docker Space repository identifier | Technical ID | Deployment/config | Not supplied; do not invent [assumption]. |

## 2. Current truth (confidence, not a gate)
| TRUE (shipped / decided, behaviorally supported) | PROVISIONAL (decided, not yet verified end-to-end) | UNVALIDATED (do not state as fact) |
|---|---|---|
| The product is convex. | The MVP can deliver the full proof-of-comprehension loop within the four-day build window. | Student builders will choose to pause shipping and use the product. |
| The wedge is proof-of-comprehension: deterministic structural evidence + learner-state/gap map + teach-back. | Deterministic analysis can reach the required precision on the selected demo repositories. | The product has a validated payer or viable revenue model. |
| The product is not a generic explainer, chatbot, code generator, or IDE. | A bundled sample or bounded public repository snapshot is sufficient for the MVP demo and first user tests. | Any institutional payer will enter an evaluation or purchase process. |
| Structural claims must trace to deterministic source evidence. | The client framework, graph renderer, deployment IDs, persistence mechanism, and measured runtime bounds remain to be chosen or verified [assumption]. | The tool improves seven-day retention or interview outcomes. |
| Learner recommendations must derive from the real repository and demonstrated answers. | The user-facing experience can meet the stated WCAG 2.2 AA target in the hackathon window. | Learner-state scoring thresholds or concept mastery levels are known. |
| The product is read-only on user code. | Deployment will remain accessible through Global judging as required by context. | Private repository intake, authentication, persistence, and multi-user behavior are part of MVP. |
| Current implementation baseline is two repositories: a Vercel-hosted client and a Hugging Face Docker Space backend using FastAPI, LangChain, and LangGraph. | The direct browser-to-Space contract integration remains to be verified. | A single-repository, local-only, desktop, IDE-native, or other architecture is current. |
| The backend scaffold pins FastAPI, Tree-sitter for JS/JSX/TS/TSX, LangChain/OpenAI, LangGraph, the `gpt-5.6` model alias, intake limits, and contract version `1.0.0`; 29 local tests and a live local HTTP health smoke pass. | The graph-grounded GPT-5.6 narrative/question/evaluation pipelines remain to be implemented and verified end to end. | Passing the scaffold proves Hugging Face production readiness or the full product loop. |
| MVP is F-001 through F-005; Final is F-101 through F-104. | Model-generated narrative can explain deterministic graph evidence without becoming the source of structural truth. | Unsupported structural relations can safely be inferred by a model. |

## 3. Pivots & decisions (newest first)
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
| Alternative client host or backend platform | Not the current architecture; recording alternatives as current would create implementation drift. | If Vercel or Hugging Face cannot satisfy judged availability or required functionality, supported by deployment evidence. |
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
- **Architecture detail risk:** Client framework, graph renderer, deployment IDs, persistence, session behavior, and measured runtime limits remain [assumption]; backend libraries, JS/TS language family, contract version, intake caps, and model alias are locked but not yet verified end to end on Hugging Face.
- **Operational risk:** The Vercel client and Hugging Face Docker Space must remain accessible through Global judging; monitoring and recovery details are [assumption].
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
