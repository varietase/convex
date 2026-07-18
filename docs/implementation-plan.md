# Implementation Plan — 5.5-hour Manila build

## Build rule
Riskiest thing first: if deterministic evidence-backed edges do not work, stop—the remainder is a wrapper. Each gate reasserts INV-001–003. Current baseline stays Vercel client + Hugging Face Docker Space.

## 0:00–0:30 — Scaffold and contracts
- **Build:** two repos, pinned dependencies, FastAPI health, Vercel shell/BFF stub, shared API schemas, sample fixture.
- **Owners:** Joshua/Farhana backend; Helena/Dia client; Abu demo/acceptance.
- **Gate:** both apps boot; client reaches authenticated backend health; secrets absent from bundles/logs.

## 0:30–1:45 — Deterministic graph spike (F-001, F-005)
- Parse only TS/JS family [assumption]; emit symbols, exact imports/direct calls, source spans; pre-index sample artifact.
- Reject ambiguity, dynamic calls, unsafe/big inputs; never run repo code.
- **Gate:** TC-001–003 and TC-N01/N02/N05 pass; one demo path has 100% observed edge precision. If this fails by 1:45, freeze intake to the bundled sample—do not ship generic explain chat.

## 1:45–2:45 — Demo explorer (F-002)
- Build three-pane shell, graph + path-list, evidence popover, semantic zoom rail, named loading/error/sample states.
- Wire deterministic graph first; add GPT-5.6 pseudocode/path narrative only through cited evidence schema.
- **Gate:** select function → edge lights → click source proof → zoom without losing focus; keyboard path works; invalid citation rejects.

## 2:45–3:45 — Teach-back and gap derivation (F-003, F-004)
- Minimal LangGraph call→validate→one-retry workflow; exactly three questions; evaluate claims; apply EQ-005; show reason/evidence.
- **Gate:** answer question → supported/missing/unsupported feedback → gap changes; no score/mastery/generic concept; TC-006–009 + INV-002 negatives pass.

## 3:45–4:30 — End-to-end hardening
- Complete BFF auth/session, CSRF/origin, limits, cleanup, deterministic-only degradation, pre-index sample fallback.
- **Gate:** TC-010/011, session isolation, log inspection, API contracts, health check; production sample loop succeeds.

## 4:30–5:00 — Design and accessibility pass
- Final tokens/copy, focus order, graph text alternative, contrast/reduced motion, responsive demo viewport.
- **Gate:** core journey keyboard-only; banned-copy grep clean; sample badge visible.

## 5:00–5:30 — Rehearse and freeze
- Record backup demo, warm backend, run smoke test, save Codex `/feedback` Session ID, clean commits, capture README decisions.
- **Gate:** 90-second live sequence works three times; one-click sample fallback; owners can answer Q&A.

## Honest stopping point
At 3:45, a coherent demo exists: pre-indexed sample → grounded edge → teach-back → updated gap. Cut public-repo intake breadth, animations, extra concepts, and all F-101–104 before cutting this loop.

## Global polish (post-Manila)
Add one safe public fixture, observability/rollback, README/install/test path, <3-minute video, citation/error polish, Devpost copy, and deployment availability. Do not implement MCP App/local sidecar until after submission; ADR-0002 remains proposed.
