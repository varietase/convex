# Release / Go-to-Market & Roadmap — convex

> **Purpose:** Ship one reliable proof-of-comprehension loop in the Manila build sprint, then harden and package the same two-repository build for Global judging.
> **Scope:** F-001–F-005 are the release. F-101–F-104 are future gates, not current claims.

## Release objective and hard gates
A release candidate passes only when a clean-browser user can load a visibly labeled sample, hover then select a function, zoom out to an evidence-backed path, open `file:line` proof or the equivalent text path, submit one repo-specific teach-back, and see the eligible gap list change.

- **INV-001:** every rendered structural edge has deterministic source evidence; uncertainty is omitted.
- **INV-002:** every personal gap item has both repository and learner-attempt evidence; no generic list.
- **INV-003:** intake and analysis are read-only; no write credential, mutation route, commit, branch, or pull request.
- **Architecture:** keep the current two repositories: Vercel web client calling the Hugging Face Docker Space (FastAPI, deterministic analysis, minimal LangChain/LangGraph, GPT-5.6 above the graph) directly over HTTPS — no BFF/proxy; access control is a CORS origin allowlist.
- **Scope rule:** cut breadth and polish before cutting provenance, teach-back, text-path access, sample labeling, or the gap update.

## Release plan & phases
| Phase | Window / owners | Deliverable | Entry gate | Exit gate |
|---|---|---|---|---|
| **M0 — Spine** | Manila Sprint 1, Jul 18 9:45–12:00 PHT; Joshua + Farhana backend, Helena + Dia frontend, Abu product | Pre-indexed sample, selected function, exact edge, evidence drawer, text path | Environments open; demo fixture fixed | Local/preview `focus → edge → file:line` works; no evidence-less edge can render |
| **M1 — Full loop** | Manila Sprint 2, 1:00–2:15 PHT; all five | F-001–F-005: intake, semantic zoom, teach-back, gap update | M0 passes | Clean browser completes the target loop; failure states and keyboard path work |
| **M2 — Freeze** | 2:15–2:45 PHT; Abu go/no-go, Farhana deploy, Joshua technical gate, Dia demo | Known-good Vercel deployment + Space image/commit + recorded fallback | M1 and hard gates pass | Deployment IDs recorded; rollback tested once; two timed rehearsals; no discretionary change after 2:30 |
| **M3 — Manila demo** | 3:00–4:00 judging window; Dia drives, Abu narrates, Joshua technical standby, Farhana ops | Working sample-first live demo | Health checks pass; Space warmed | Core loop shown honestly; judge questions and incidents captured |
| **G1 — Global hardening** | Jul 18 evening–Jul 20; Manila five + Geinel + Jim | Fix incidents; accessibility/responsive polish; README; reliable judge path | Manila artifact tagged | Full checks pass; judge can test without rebuilding; Codex and GPT-5.6 roles documented with real artifacts |
| **G2 — Submission** | Before Jul 21 5 PM PT / Jul 22 8 AM PHT; Dia + Abu story, Helena visuals, Joshua + Geinel review, Farhana + Jim ops | Public YouTube voiceover under 3 minutes, Devpost entry, repo access, live URL | G1 frozen | Links work logged-out; actual `/feedback` Session ID supplied; submission confirmation saved |
| **G3 — Judging hold** | Jul 22–Aug 5; Farhana + Jim first ops, Joshua + Geinel technical | Frozen judge build | G2 submitted | Availability monitored; only security/reliability fixes with change note and repeated smoke test |

## Manila scope cuts, in order
1. Remove decorative depth effects, non-essential animation, and secondary visual polish while keeping the dark-first token system legible.
2. Remove arbitrary public-repository intake from the live path; keep the honest sample.
3. Disable generated narrative if necessary; keep deterministic graph, source, and text path.
4. Reduce extra concepts and non-demo screens; preserve the three-question contract where generated.
5. Never cut source evidence, read-only handling, sample labeling, text-path equivalence, or teach-back-to-gap change.

## Rollout strategy
### Deployment order
1. Pin and test the backend image; deploy the Hugging Face Space first.
2. Calling the backend directly, pass `GET /health`, invariant fixtures, sample analysis, and `graph → questions → attempt → gaps` smoke.
3. Deploy Vercel preview against that backend; pass contract, keyboard, responsive, clean-session, and secret-bundle checks.
4. Promote that exact preview; repeat the smoke from a logged-out browser. A second-network check is **[assumption]** if connectivity permits.
5. Record known-good identifiers for both repositories in the private team channel **[assumption]**.

### Feature isolation and fallback
Runtime switches for public-repository intake and model-backed views are **[assumption]**. They may degrade optional paths but must never hide sample labeling or evidence provenance.

| Failure | User-visible result | Action / owner | Preserved rule |
|---|---|---|---|
| Space cold/down | One warm-up retry, degraded health, explicit sample option | Farhana checks `GET /health`; rollback image if needed | No fake live result |
| Public fetch fails | Canonical reason and sample option | Do not bypass host/bounds; Farhana | INV-003 |
| Parser is uncertain | Edge absent; “not enough evidence” | Joshua fixes deterministic rule/fixture later | INV-001 |
| GPT-5.6 unavailable or output rejected | Graph, source, and text path remain; reasoning view unavailable | One validated retry; Joshua/Farhana disable or rollback model path | Graph truth unchanged |
| Session lost | Expiry message; new session or sample | Start fresh; never reconstruct from logs | Ephemeral-state honesty |
| Vercel regression | Previous known-good client | Farhana/Jim roll back Vercel | API v1 overlap |
| Security/invariant breach | Affected route disabled | Rotate if needed, delete transient state, patch, rerun gates | Safety before availability |

### Rollback decision and mechanics
- **Immediate rollback/disable:** any published edge without evidence, gap without both evidence classes, cross-session access, repository mutation path, exposed secret, or broken clean-browser loop.
- **Degrade then investigate:** model citation rejection, one public fetch failure, or an intentionally omitted ambiguous edge.
- Vercel returns to the previous deployment; the Space returns to the previous known-good image/commit. API v1 stays backward compatible through overlap. Recovery creates new ephemeral sessions; it does not restore learner responses.
- Fallback hierarchy: live bounded repository → live sample → visibly labeled pre-indexed sample → recorded local run for presentation only. The operator says which layer is shown.

## Launch checklist
### Product and design
- [ ] F-001–F-005 pass as one loop; F-101–F-104 are not shown as shipped.
- [ ] Exact demo path and response are rehearsed; sample identity/version remains visible.
- [ ] Screens use the documented near-black/off-white/neutral/coral system, rounded outlined cards, thin borders, minimal shadows, and no decorative gradients.
- [ ] Every stage edge and feedback finding opens evidence; ambiguous relations remain absent.
- [ ] Graph works by keyboard; ordered text path exposes the same relations and evidence actions.
- [ ] Status uses shape/icon/label, not color alone; focus, reduced-motion behavior, and documented dark-token contrast pairs pass.
- [ ] Loading, unsupported, expired, model-unavailable, and fallback states are understandable within the premium dark-first visual language.
- [ ] User-facing copy contains no personal grade, numeric understanding indicator, generic personal list, or claim that the system knows the learner.

### Technical, security, and operations
- [ ] Frontend type/unit/contract/accessibility/build checks and backend fixture/invariant/API checks pass.
- [ ] The five documented endpoints match the spec; no backend/model secret reaches browser or logs.
- [ ] SSRF, traversal, links/archives, oversize, timeout, cleanup, CORS-origin allowlist, and two-session isolation tests pass.
- [ ] INV-001 and INV-002 negative fixtures fail closed; held-out rendered edges have 100% observed precision.
- [ ] INV-003 checks find no write credential, repository execution, mutation API, commit, or pull-request path.
- [ ] Success/error log samples contain no source, full repository URL/query, response, prompt, or secret.
- [ ] `GET /health` passes after warm-up; known-good IDs and responders are recorded; rollback is tested.

### Manila and Global
- [ ] Dia drives; Abu narrates; Joshua owns technical Q&A; Farhana watches health/rollback.
- [ ] Demo browser, chargers, fallback recording, and hotspot **[assumption]** are ready.
- [ ] Global track selection is explicit; Education is recommended **[assumption]**, with Developer Tools the alternative.
- [ ] YouTube video is English, public, audible, captioned, and below 3:00 after processing.
- [ ] Video shows the product, one real Codex build contribution, and GPT-5.6’s bounded runtime role.
- [ ] README has setup/test path, actual Codex collaboration, decisions, GPT-5.6 integration, and supported platform.
- [ ] Repository is public or shared with required judge addresses; test link works logged-out.
- [ ] Actual main-thread `/feedback` Session ID is supplied; no placeholder is submitted.
- [ ] Devpost confirmation is saved before the hard deadline.
