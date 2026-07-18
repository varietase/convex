# Next Steps — convex Global Stage

**Maintained by:** Abu · **Updated:** 2026-07-19 · **Status:** active execution tracker

> **Scope:** this plan runs from now **through the final build and the Devpost submission** — not just the immediate next steps. It is the single doc the team follows. It is a plan, not canonical truth; the Decision Ledger still wins.
>
> **One-paragraph truth.** The thesis, the deterministic-analysis backend (300+ tests, feature-complete for F-001–F-005), the reasoning constraints, and a polished client are all real. What is left is **release coherence**: deploy the backend, wire the live client to it, and land the F-001→F-005 loop end to end. The backend code is done; the gap is deployment + integration, not features.
>
> **Deployment reality.** Client is **live on Cloudflare Workers (OpenNext)** at `https://convex.varietase.workers.dev` — it currently serves the static preview, not the wired loop. Backend deploys to a **Hugging Face Docker Space** (`model/DEPLOY.md`). Docs were reconciled Vercel → Cloudflare on 2026-07-19 (ADR-0003, ledger, CR-002).

---

## 1. Schedule (Jul 19 → 22)

**Deadline: Jul 22, 08:00 AM PHT (= Jul 21, 05:00 PM PT). Hard — no edits after.**
Joshua is lighter on **Jul 21–22**, but **Geinel covers his backend/integration work**, so we run at full pace across all days. Submit early (Tue) and keep Wed morning as buffer — good practice, not a constraint.

| Day (PHT) | Theme | End-of-day target |
|---|---|---|
| **Sun Jul 19** (today) | Unblock + deploy backend | Deploy creds in hand; backend live on the Space; `/health` green; sample `/v1/analyses` returns a real graph (curl is fine). `model` re-pinned to `d06dc29`. |
| **Mon Jul 20** | Wire the loop | Live client calls the live backend; sample loop works on `convex.varietase.workers.dev`. Backup demo video recorded. |
| **Tue Jul 21** | Polish + submit | a11y clean; final demo video; README/Codex write-up done; **Devpost submitted**. |
| **Wed Jul 22 (pre-8AM)** | Buffer | Final smoke ×3; live URL testable; submission confirmed. |

**What wins points (rubric = 4 × 25%, async video judging):** Technological Implementation (Codex use) · Design (a *complete, coherent* product, not a POC) · Potential Impact · Quality of Idea. Highest-leverage: (1) the live sample loop, (2) a crisp `<3-min` video, (3) documented Codex collaboration, (4) coherent accessible UI. Cut features before cutting these four.

---

## 2. Decisions

| # | Decision | Status | Owner |
|---|---|---|---|
| **D1** | **Re-pin `model` `80390bb` → `origin/main` (`d06dc29`)** — pinned `main.py` leaves `analysis_engine`/`evidence_service` unset; `d06dc29` wires them + adds public intake. (The Space deploys from `model` `main` = `d06dc29` already, so deploy is *not* blocked by the re-pin; re-pin keeps the root + local dev consistent.) | Open — do first | Joshua |
| ~~D2~~ | **Deployment = Cloudflare Workers** — live at `https://convex.varietase.workers.dev`. | ✅ Resolved 2026-07-19 (ADR-0003) | Abu |
| **D3** | **Session TTL value** — code = `ttl_seconds=1800` (30 min) vs docs 24h vs workspace 15 min. Pick one; align code + docs. | Open (quick) | Joshua |
| **D4** | **Static preview: label or replace?** — the live URL currently serves the keyword-match mock with pre-filled "Missing" gaps and no "illustrative" label. Replace with the real loop by Mon, or label it "Illustrative preview — not a live analysis." | Open | Abu + Helena/Dia |
| ~~D5~~ | ~~Obsidian-style repo graph~~ | ❌ **Dropped — out of scope for this build.** Not pursued. | — |

---

## 3. Critical path

```
Farhana (+ Geinel) obtain OpenAI key + HF access ─▶ Farhana/Geinel run model/DEPLOY.md ─▶ backend live on HF Space (/health green, keyed smoke ×3)
        │                                                                                          │
   Joshua re-pins model→d06dc29 (root consistency)                                                 ▼
        │                                          Jim builds the client API client + wires /v1/* to the live Space
        ▼                                                                                          │
   Helena/Dia build the real product surface (FocusWorkspace, EvidenceGraph, TeachBack, GapList) ──┘
        │
        ▼
   full loop on convex.varietase.workers.dev: sample ▶ graph ▶ evidence ▶ 3 answers ▶ feedback ▶ gap update ▶ back to source
        │
        ▼
   backup video (Mon) ─▶ polish + a11y + final video + Devpost submit (Tue) ─▶ confirm (Wed pre-8AM)
```

**The one blocker to clear first:** backend deployment. It is a ~15-minute configure-and-run runbook (`model/DEPLOY.md`), **not** an engineering problem — it's blocked on **access/credentials: a Hugging Face account + write token, and the OpenAI GPT-5.6 API key.** Clear those and the backend deploys today.

---

## 4. Workstreams and owners

Owners are point people, not fences (`context-team.md`). Check items only with a linked test or reproducible result.

### WS-A — Backend deploy + release coherence · Owner: **Joshua** · Execute/assist: **Geinel**, **Farhana**
- [ ] **Backend deployment to the HF Space** via `model/DEPLOY.md` — **owned by Joshua, executed by Geinel or Farhana** (Joshua is fixing the GitHub Actions workflow and is out 21–22). **Blockers: Hugging Face account/token + OpenAI GPT-5.6 key** (see §3). Steps: create Docker Space → push `model` `main` → set `OPENAI_API_KEY` secret + `XRAY_ENVIRONMENT=production` + `XRAY_CORS_ORIGINS=https://convex.varietase.workers.dev` → `/health` → `production_smoke.py` ×3 (keyless then keyed). *(F-005)*
- [ ] **D1 re-pin** `model` → `d06dc29` in root; `git submodule status` shows the new SHA; `uv run pytest` green on the pin. *(F-001)*
- [ ] Fix the GitHub Actions workflow bug (Joshua, in progress).
- [ ] Resolve **D3 (TTL)**; align code + `data-model.md` + README.
- [ ] Flip `backend-implementation.md` integration items **#3** (keyed teach-back) and **#5** (release) once the keyed smoke passes.
- [ ] **Handoff before Jul 21:** Joshua walks Geinel/Farhana through `DEPLOY.md` + where secrets live + how to redeploy.

### WS-B — Client ⇄ backend integration · Owner: **Jim** (dev) · Support: **Geinel**, **Joshua** (contract)
- [ ] Typed API client for the five endpoints with the `{code,message,limits?}` envelope; backend base URL via a Cloudflare env var; browser calls the Space directly (no BFF). *(api-spec.md)*
- [ ] Hold `sessionId`+`snapshotId` client-side; real selection drives `/v1/xray`; teach-back submit hits `/v1/teachbacks/evaluate` and renders **real** findings + gap list (replaces the keyword mock). *(F-002/F-003/F-004, INV-002)*
- [ ] Put the real loop on the live URL (route or replace the static preview). *(D4)*

### WS-C — Design system → real product UI · Owners: **Helena** + **Dia**
- [ ] Landmarks + `LiveRegion`: `AppHeader`, `RepositoryRail`, `FocusWorkspace`, `LearningRail`. *(design-system.md)*
- [ ] `EvidenceGraph` + `GraphLegend` + `PathList` text equivalent (ship together); `CodePane`; `EvidenceDrawer`; `OmittedNotice`. *(F-001/F-002, INV-001, a11y)*
- [ ] `TeachBackCard` → `ResponseFindings` → `GapList`/`GapItem` (rank + `gap_score`, never a %). *(F-003/F-004)*
- [ ] a11y gates (Tue focus): keyboard graph traversal, visible focus, non-color encoding, reduced motion, AA.
- [ ] **D4** illustrative label until the real loop lands; `ReadOnlyBadge` + `SampleBadge`.

### WS-D — Infra, CI, ops proof · Owners: **Farhana** + **Jim**
- [ ] HF Space secrets/variables + the keyed `production_smoke.py` ×3 (with Geinel). *(ops)*
- [ ] CI on PR: `cd model && uv run pytest` + client `typecheck`/`build`.
- [ ] Record deploy URLs in `ops.md`; capture backup demo video + fallback screenshot; lock one bounded public fixture for F-005.

### WS-E — Product & pitch · Owner: **Abu**
- [ ] `<3:00` demo video (Mon backup, Tue final); Devpost copy + **submit Tue**; Codex `/feedback` ID + Codex-collaboration write-up (Technical 25%); rehearse twice.

---

## 5. Onboarding Jim & Geinel (this morning)

Reading path (`index.md`): **Onboarding → Decision Ledger → Next Steps → role path.**

**Shared ramp (~45–60 min, together):** clone with `--recurse-submodules`; skim `onboarding.md` → `DECISION-LEDGER.md` (2026-07-19 entry) → this doc; internalize **INV-001/002/003**; run backend (`cd model && uv sync --frozen && uv run pytest && uv run uvicorn app.main:app --host 127.0.0.1 --port 7860`, hit `/health`); run client (`cd client && npm install && npm run dev`). Access: `varietase` GitHub org, Hugging Face (for the Space), Cloudflare. **Secrets live in the Space only — never in git or the client.**

- **Geinel (senior; covers Joshua 21–22):** pair with Joshua on `DEPLOY.md` + integration today so you can run and debug the backend solo while he's out.
- **Jim (dev + devops):** take the client API integration (WS-B). Buddy: Geinel/Joshua for the contract.

---

## 6. Docs reconciliation — ✅ applied 2026-07-19

Cross-doc sweep done (Vercel → Cloudflare Workers; backend truth made current): **ADR-0003** created, **ADR-0001** marked superseded (host only), **Decision Ledger** 2026-07-19 pivot + refreshed truth table, **CR-002** logged, and README/system-design/ops/api-spec/security/prd/release-gtm/pitch-kit/technical-design/onboarding/index/AGENTS/context/architecture-research/implementation-plan/master-plan updated. Env names fixed to `XRAY_CORS_ORIGINS` / `XRAY_MODEL_ID`. README `model/`-is-empty claim corrected.

**Residual (owner):** D3 TTL value → align code+docs (Joshua) · D4 HeroPreview illustrative label (Helena/Dia) · `model/README.md` still shows a `your-client.vercel.app` example — it's in the submodule, so **Joshua** fixes it in the `model` repo.

---

## 7. Definition of Done — Global submission

- [ ] Backend live on the Space; `/health` green; sample `/v1/analyses` returns a real graph with exactly three evidence anchors per edge. *(F-001, INV-001)*
- [ ] **Full loop works on `convex.varietase.workers.dev`**: sample → graph → evidence → 3 answers → Supported/Missing/Unsupported → gap update → back to source. *(F-001–F-004)*
- [ ] No `GapItem` before a validated attempt; no fabricated edges; read-only throughout. *(INV-001/002/003)*
- [ ] a11y: keyboard traversal, `PathList` text equivalent, non-color encoding, reduced motion, AA.
- [ ] No secrets/source/answers in logs or client bundle.
- [ ] `<3-min` video uploaded; README documents Codex use + dated commits + `/feedback` ID; Devpost complete; **submitted with buffer**.
- [ ] Production smoke passes ×3; deploy URLs recorded; backup video + fallback screenshot captured.
- [ ] F-101–F-104 deferred, not falsely green.

---

## 8. Risk register / cut order

1. **Biggest risk: deployment stays blocked on credentials.** Clear the HF access + OpenAI key **today** — **owner: Farhana (primary), Geinel (backup).** It's the whole critical path.
2. Record the **backup demo video** as soon as the loop works, in case of a bad day near the deadline.
3. Cut order when short on time: public-repo breadth beyond one fixture → decorative polish/animation → extra concepts. **Never cut the sample loop or the video.**
4. If integration slips: demo the real backend loop via a minimal wired surface, not the static `HeroPreview`.
5. If model calls are flaky at judging: lean on the deterministic graph + cached sample explanation/evaluation (design system specifies these degraded states).

---

## 9. Who does what — GC copy

> **Deadline: Jul 22, 8:00 AM PHT (= Jul 21, 5:00 PM PT). Scope: through final build + Devpost submission.** Full detail is above; this is your at-a-glance. ▶ = start here tomorrow.

**Abu — product / pitch / lead.** Own the demo script, the pitch, the demo video, the Devpost submission, and the Codex write-up.
▶ **Start:** write the 3-minute demo script + shot-list before we build the UI — every screen it needs is a spec for Helena/Dia/Jim.

**Joshua — backend lead.** Re-pin the model, finish the GitHub workflow, hand off `DEPLOY.md` (you're out 21–22).
▶ **Start:** re-pin `model` → `d06dc29` and push; then brief Geinel on `DEPLOY.md`.

**Geinel — senior dev (covers Joshua 21–22).** Deploy the backend to the HF Space; own backend/integration while Joshua's out. Backup on the credential unblock.
▶ **Start:** shadow Joshua on `DEPLOY.md`; be ready to run it solo the moment the OpenAI key + HF access land.

**Farhana — devops / AI-ML.** **Own the credential unblock** (OpenAI GPT-5.6 key + Hugging Face account/token); HF Space secrets + smoke; CI.
▶ **Start:** get the OpenAI key + HF token in hand today — this is the critical-path blocker for the whole team.

**Jim — dev + devops.** Build the client's API client and wire it to the live backend; then help with CI/deploy.
▶ **Start:** typed API client + first live `POST /v1/analyses` call rendering a real graph.

**Helena — UI/UX.** Build the real product surface from the design system (the demo's center).
▶ **Start:** `FocusWorkspace` + `EvidenceGraph` shell (with the `PathList` text equivalent).

**Dia — UI/UX.** Build the teach-back → findings → gap UI; own visual polish + a11y for the demo.
▶ **Start:** `TeachBackCard` + `ResponseFindings` + `GapList`.
