# Implementation Plan — five-hour build

## Build rule
Riskiest thing first: if deterministic evidence-backed edges do not work, stop—the remainder is a wrapper. Each gate reasserts INV-001–003. Current baseline stays Vercel client + Hugging Face Docker Space, called directly by the browser over a CORS-allowlisted origin — no BFF/proxy.

Three builder roles per `master-plan-implementation.md` §9, mapped onto the team's real assignments:
- **Builder A — client explorer:** Helena/Dia
- **Builder B — deterministic backend:** Joshua/Farhana
- **Builder C — teaching pipeline:** Farhana (shared with Builder B) with Abu on demo/acceptance across every gate

## 0:00–0:20 — Contracts, sample, and deployments
- **Everyone:** create the two repositories (`client` = `xray-client`, `model` = `xray-backend`); deploy a blank Vercel client; deploy a FastAPI `/health` endpoint to the Docker Space (port 7860); lock the sample repository; lock the data contracts; lock intake limits (40 files, 750KB total, 60KB/file, 5MB archive, 20MB extracted, 20s timeout); define stable ID formulas; add the invariant test file before feature code.
- **Gate:** client deployment opens; backend `/health` responds; both repositories share the same contract version; the demo sample and central path are known.

## 0:20–1:05 — Parallel foundation
- **Builder A:** establish dark-first token scaffolding from `design-system.md`; render mock symbols and edges; implement Inside/Around/Across controls; add selected-symbol state; add keyboard-focusable graph elements; add text-path placeholder; build the source pane.
- **Builder B:** implement sample intake; configure Tree-sitter parsers (JS/JSX/TS/TSX only); extract modules and symbols; create evidence references; return snapshot metadata.
- **Builder C:** define concept registry; define question specs; build LangGraph question pipeline with mocked evidence; define structured model schemas; add prohibited-language validator.
- **Gate:** sample source produces symbol records; mock graph can select a symbol; three mock question specs validate.

## 1:05–1:55 — F-001 evidence graph
- **Builder A:** connect UI to `POST /v1/analyses`; render real symbols with the neutral/coral graph palette; add edge evidence drawer; add non-color edge labels; keep cards rounded, outlined, and minimally elevated.
- **Builder B:** implement direct relative imports, same-file calls, named imported calls, module relationships; add unresolved-reference records; add provenance tests (exactly three evidence anchors per edge).
- **Builder C:** build evidence-linked pseudocode endpoint (`POST /v1/xray`); validate all returned evidence IDs; add cached sample explanation.
- **Gate:** a selected call edge exposes caller definition, call site, and callee definition; unsupported calls produce no edge; model output cannot modify the graph.

## 1:55–2:35 — F-002 semantic zoom and F-005 public intake
- **Builder A:** complete Inside/Around/Across behavior; preserve selected context across zoom levels; generate graph text alternatives; add smooth functional transitions and reduced-motion behavior.
- **Builder B:** implement bounded public snapshot intake; resolve the commit SHA; add archive-size and source-size guards; reject unsafe extraction paths and symlinks; add timeout handling.
- **Builder C:** implement deterministic concept occurrences; connect concept evidence to selected symbols; complete question selection from actual graph evidence.
- **Gate:** bundled sample works from the backend; one small public repository can be analyzed; zooming preserves selected symbol and path; repository concepts display without being labeled personal gaps.

## 2:35–3:20 — F-004 teach-back
- **Builder A:** build three-question interface; add one-submit evaluation flow; build Supported/Missing/Unsupported feedback sections; make source citations clickable.
- **Builder B:** produce required claims from graph evidence; build evidence packs for questions (`POST /v1/teachbacks/questions`); add allowlist validation; implement session-local learner-evidence format.
- **Builder C:** complete LangGraph answer-evaluation pipeline (`POST /v1/teachbacks/evaluate`); connect GPT-5.6 structured output; add model failure fallback; add wording restrictions.
- **Gate:** the learner can answer all three questions; every supported/missing feedback item cites source; unsupported claims say "not enough evidence"; no mastery wording appears.

## 3:20–3:50 — F-003 gap-map update
- **Builder A:** build gap cards with numeric score/rank; add repository and learner-evidence sections; clicking a gap selects the relevant symbol/path.
- **Builder B:** implement eligibility rules (repo evidence AND learner-answer evidence AND ≥1 missing/unsupported observation); implement session-local `gap_score = 70% learner_gap + 30% repository_relevance` ranking; ensure unknown concepts are omitted; return "no ranking changed" when appropriate.
- **Builder C:** generate concise rationale from validated evidence; add cached evaluation for the demo answers; verify no generic fallback concepts appear.
- **Hard MVP gate:** the complete loop works: sample → graph → evidence → three answers → feedback → updated gap map → return to code. Do not begin F-101 through F-104.

## 3:50–4:20 — Invariants and accessibility
- Run: edge provenance tests, unknown-evidence-ID tests, no-gap-before-answer tests, intake limit tests, read-only GitHub-adapter tests, keyboard-only graph traversal, visible focus check, reduced-motion check, dark-token contrast check, text-path check, model-unavailable check.
- **Gate:** hide or delete any feature that does not pass.

## 4:20–4:40 — Deployment reliability
- Set the backend CORS allowlist (deployed Vercel origin + local dev, no wildcard); store the model key only in Space secrets; confirm the backend listens on port 7860; verify the Vercel production environment points to the Space API; test a fresh browser session; test the bundled sample after a backend restart; test cached explanation and cached evaluation; record a backup demo video; capture one full-screen fallback screenshot.
- **Gate:** production sample loop succeeds after a cold restart.

## 4:40–5:00 — README and rehearsal
- Document: product problem, invariant spine, architecture, exact supported scope, read-only behavior, known limitations, Codex collaboration, main Codex `/feedback` Session ID, GPT-5.6 runtime responsibilities, demo path.
- **Gate:** run the sub-three-minute demo twice without stopping.

## Honest stopping point
At the 3:50 hard MVP gate, a coherent demo exists: pre-indexed sample → grounded edge → teach-back → updated gap. Cut public-repo intake breadth, decorative polish, non-essential animations, extra concepts, and all F-101–104 before cutting this loop.

## Global polish (post-hackathon)
Add one safe public fixture, observability/rollback, README/install/test path, <3-minute video, citation/error polish, Devpost copy, and deployment availability. Do not implement MCP App/local sidecar until after submission; ADR-0002 remains proposed.
