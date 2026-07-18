# Decision Ledger — ConveX

> **What this is.** The append-only record of current truth, pivots, rejected approaches, naming decisions, and invariant audits. If another project document disagrees with this ledger, this ledger wins until reconciliation.
>
> **What this is not.** It does not freeze the product. It keeps change coherent and prevents rejected directions or speculative architecture from silently becoming current truth.
>
> **Last reconciled:** initial first-dependency-phase generation; calendar date not supplied [assumption].

## 1. Names & immutable identifiers (read first)
| Name / ID | Kind | Where it appears | Rule |
|---|---|---|---|
| ConveX | Public product name | UI, pitch, README, judge-facing materials | Fixed casing: capital `C`, lower `onve`, capital `X`. Never `Convex`, `CONVEX`, `conveX`, or `Convex Lens`. Use on first and subsequent mentions. |
| comprehension control layer for code | Category phrase | Product and pitch copy | Use to distinguish the product from explainers and IDEs. |
| X-Ray / X-Ray for AI Code | **Deprecated public name** | Legacy references only | Replace on sight. Kept in the ledger for pivot history only. |
| F-001–F-005, F-101–F-104 | Immutable feature IDs | Idea, PRD, downstream specifications, QA | Preserve IDs exactly; do not renumber during refinement. |
| INV-001–INV-003 | Immutable invariant IDs | Idea, PRD, security, design, QA | Preserve IDs and meanings exactly; changes require a logged invariant-change pivot. |
| Vercel client repository identifier | Technical ID | Deployment/config | Not supplied; do not invent [assumption]. |
| Hugging Face Docker Space repository identifier | Technical ID | Deployment/config | Not supplied; do not invent [assumption]. |

## 2. Current truth (confidence, not a gate)
| TRUE (shipped / decided, behaviorally supported) | PROVISIONAL (decided, not yet verified end-to-end) | UNVALIDATED (do not state as fact) |
|---|---|---|
| The product is X-Ray for AI Code, shortened to X-Ray. | The MVP can deliver the full proof-of-comprehension loop within the four-day build window. | Student builders will choose to pause shipping and use the product. |
| The wedge is proof-of-comprehension: deterministic structural evidence + learner-state/gap map + teach-back. | Deterministic analysis can reach the required precision on the selected demo repositories. | The product has a validated payer or viable revenue model. |
| The product is not a generic explainer, chatbot, code generator, or IDE. | A bundled sample or bounded public repository snapshot is sufficient for the MVP demo and first user tests. | Any institutional payer will enter an evaluation or purchase process. |
| Structural claims must trace to deterministic source evidence. | The exact client framework, graph renderer, static-analysis libraries, and model configuration remain to be chosen [assumption]; supported languages (JS/JSX/TS/TSX) and intake bounds are now decided (see 2026-07-18 alignment pivot). | The tool improves seven-day retention or interview outcomes. |
| Learner recommendations must derive from the real repository and demonstrated answers. | The user-facing experience can meet the stated WCAG 2.2 AA target in the hackathon window. | Learner-state scoring thresholds or concept mastery levels are known. |
| The product is read-only on user code. | Deployment will remain accessible through Global judging as required by context. | Private repository intake, authentication, persistence, and multi-user behavior are part of MVP. |
| Current implementation baseline is two repositories: a Vercel-hosted client and a Hugging Face Docker Space backend (FastAPI, LangChain, LangGraph) called directly by the browser over a CORS origin allowlist — no BFF/proxy (see 2026-07-18 alignment pivot). | Codex and GPT-5.6 will be used meaningfully, but exact responsibilities are not yet specified [assumption]. | A single-repository, local-only, desktop, IDE-native, or other architecture is current. |
| MVP is F-001 through F-005; Final is F-101 through F-104. | Model-generated narrative can explain deterministic graph evidence without becoming the source of structural truth. | Unsupported structural relations can safely be inferred by a model. |

## 3. Pivots & decisions (newest first)
### 2026-07-18 — Rename X-Ray → ConveX and lock the optical visual system
- **Type:** brand / naming
- **Change:** public name `X-Ray for AI Code` → **`ConveX`** (fixed casing). Visual language formalized as a physical-optics metaphor: focus, focal plane, exposure, semantic zoom, refraction.
- **Why:** “X-Ray” implied medical/scanning imagery and conflicted with the read-only, evidence-first product voice. The optical metaphor maps directly to F-002 (semantic zoom) and preserves the anti-positioning against IDEs and generic explainers.
- **Kept unchanged:** all F-IDs (F-001–F-005, F-101–F-104), INV-001–003, EQ-###/DS-### methods, API-### contracts, TC-### tests, two-repo architecture, and MVP scope. This is a naming and visual-language pivot, not a product pivot.
- **Corrected in the process (do not reintroduce):**
  - Amber is **Attention**, never `Learned` / `Mastered` / `Understood` / `Verified concept`.
  - 1× view is **Source** / **Source Evidence**, never `Code Editor`.
  - Semantic zoom uses a **three-position segmented control**, not a continuous slider; labeled `1× Source`, `5× Structure`, `10× Concepts`.
  - **No data-flow** rendering or copy until deterministic support ships; only `calls`, `imports`, `contains`.
  - Gradients and hue may **not** carry relationship-type meaning alone.
  - Blur is optional decoration only and must never obscure source excerpts, `file:line` refs, evidence controls, the text path, required labels, or focused elements.
  - `#4E5565` is a border/disabled color, not a text color; muted readable text uses `#B7C3D4` (or `#AAB2C0`), contrast-tested.
  - 10× Concepts keeps **Concepts in this code** and **Suggested for your next explanation** as separate panes; no personalized curriculum before a validated attempt.
- **Invalidated:** any doc, asset, or copy that says `X-Ray`, `Learned`, `Mastered`, `Verified concept`, `Cannot explain` (as a claim about the person), `data-flow` (as a rendered edge type), `Code Editor` (for the 1× view), or presents semantic zoom as a slider.
- **Recorded as:** this entry; canonical brand in `brand.md`. Downstream docs (`idea.md`, `docs/prd.md`, `docs/design-system.md`, `docs/pitch-kit.md`, `docs/release-gtm.md`, `docs/system-design.md`, `docs/technical-design.md`, `docs/index.md`, `AGENTS.md`, `CLAUDE.md`, `.cursorrules`, ADRs, hooks, and the four `.claude/agents/*.md`) still contain the old name and require a follow-up name-only pass. Behavior unchanged.

### 2026-07-18 — Align build to `master-plan-implementation.md`
- **Type:** platform + methods + scope
- **Change (four locked decisions):**
  1. **BFF/proxy removed.** The browser calls the Hugging Face FastAPI backend directly over HTTPS. The sole access-control boundary is a FastAPI CORS origin allowlist (deployed Vercel origin + local dev, never a wildcard). No session cookie, CSRF token, or server-held backend credential. Learner/analysis state is client-held in the browser session and resubmitted per request.
  2. **Five synchronous REST endpoints** replace the abstract `API-001–API-108` scheme: `GET /health`, `POST /v1/analyses`, `POST /v1/xray`, `POST /v1/teachbacks/questions`, `POST /v1/teachbacks/evaluate`. No queues, polling, SSE, or background jobs.
  3. **Concrete intake bounds and language set.** 40 files, 750 KB total supported source, 60 KB per file, 5 MB compressed archive, 20 MB extracted, 20-second intake/analysis timeout; languages JS/JSX/TS/TSX. Out-of-bounds input is rejected outright, never silently truncated. Every rendered edge requires three provenance anchors (source definition, relationship site, target definition).
  4. **Numeric `gap_score` replaces categorical tiers.** `gap_score = 0.70·learner_gap + 0.30·repository_relevance` for eligible concepts, ordering the gap list. The old `Next/Soon/Later` tiers and `REPEATED_GAP/OBSERVED_GAP` signals are retired, along with the High/Medium/Low confidence rubric. Structural facts are binary (all three anchors or omitted); model output is binary (passes validation or is discarded). `gap_score` is a ranking value, never a "% understood" or mastery claim.
- **Why:** The five-hour build cannot afford a credential-relay layer; direct-to-backend with a CORS allowlist is the honest, buildable contract. Concrete bounds and a numeric ranking remove `[assumption]` ambiguity that blocked implementation.
- **Kept unchanged:** F-001–F-005, F-101–F-104, INV-001–003, the read-only contract, two-repository baseline (ADR-0001), and the deterministic-graph / model-narrates-only boundary.
- **Invalidated:** any doc or copy asserting a BFF/proxy, server-held backend credential, session cookie/CSRF, `API-001–API-108` IDs, SSE progress, `5 MiB / 500 files / 100,000 lines / 60s` bounds, "TS/JS only" (now JS/JSX/TS/TSX), categorical `Next/Soon/Later` gap tiers, or a High/Medium/Low confidence rubric.
- **Recorded as:** this entry; propagated by commit `2b52e8f` across 15 docs (`AGENTS.md`, `system-design`, `security-compliance`, `api-spec`, `methods`, `design-system`, `technical-design`, `data-model`, `implementation-plan`, `qa-test-plan`, `release-gtm`, `ops`, `onboarding`, `pitch-kit`, `index`, ADR-0001) plus this ledger and the reconciled `prd.md`.

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
| Initial dependency phase | INV-001 | Defined graph extraction, semantic zoom, teach-back evaluation, and narrative boundary. | **Kept:** every structural edge requires deterministic source evidence; unsupported edges are omitted. |
| Initial dependency phase | INV-002 | Defined learner-state and concept-gap behavior. | **Kept:** every shown gap requires repository and demonstrated-answer evidence; generic top-N lists are blocked. |
| Initial dependency phase | INV-003 | Defined repository intake and the two-repository deployment baseline. | **Kept:** intake and all downstream behavior remain read-only; writes, commits, and pull requests are forbidden. |

## 6. Open items / risks
- **Adoption risk:** The primary user may not pause to prove comprehension during a time-pressured build; behavior remains unvalidated.
- **Technical trust risk:** Supported static analysis must reach at least 70% precision on the held-out demo set, with unsupported edges omitted.
- **Scope risk:** The MVP must keep F-001 through F-005 as one loop; adding F-101 through F-104 before that loop works is a scope failure.
- **Architecture detail risk:** Client framework, graph renderer, static-analysis libraries, supported languages, repository bounds, model configuration, persistence, and API contract are [assumption].
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
