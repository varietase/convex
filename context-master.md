# MASTER CONTEXT — OpenAI Build Week (Manila + Global)

> **What this is:** the single, comprehensive source of truth for the **general** context of our
> hackathon — team, events, timeline, rules, judging, submission, credits, logistics. It is a
> **superset** of `context-team.md`, `context-manila-buildathon.md`, and `context-global-buildweek.md`
> (nothing from them is dropped).
>
> **What this is NOT:** this doc is deliberately **idea-free.** Candidate ideas, the decision framework,
> and the supporting research all live in **`context-ideas.md`** (a living doc — more ideas are still
> coming). Keep this file general; put anything idea-specific there.
>
> **Owner:** Abu (Product Lead) · **Updated:** 2026-07-17 (Fri) ~00:50 PHT
> **Idea status:** NOT locked — team picks at the **Fri-night meeting**. Candidates tracked in
> `context-ideas.md`. Repo gets initialized *after* the pick.

## Contents
0. TL;DR  ·  1. Team  ·  2. Two events + strategy  ·  3. Master timeline  ·  4. Manila (detailed)  ·
5. Global (detailed)  ·  6. Judging  ·  7. Submission requirements + checklist  ·  8. Demo video spec  ·
9. Codex credits  ·  10. Rules  ·  11. Codex usage discipline  ·  12. Full FAQ  ·  13. Devpost plugin +
support  ·  14. Build & execution discipline  ·  15. Links  ·  16. CEF context blocks

---

## 0. TL;DR

- **Two events, one build.** We build once at **Manila Buildathon (Sat July 18)**, then polish and
  submit that same project to the **Global Build Week on Devpost (deadline Tue July 22, 8 AM PHT)**.
  *Manila is the build sprint; Global is the submission stage.*
- **What we build** is decided at the **Fri-night meeting** — candidates are in `context-ideas.md`, and
  more are still coming. This doc stays idea-agnostic.
- **Both tools are required:** every submission must use **Codex AND GPT-5.6** meaningfully.
- **Build for Global's four equally-weighted axes from minute one** — Technological Implementation,
  Design, Potential Impact, Quality of the Idea (§6). Manila's lighter rubric is a subset, so it's covered.
- **Don't ship a bare proof-of-concept** — judges explicitly penalize it. Ship a coherent product.
- **Capture Codex evidence live** — the `/feedback` Session ID and clean commit history are free points
  on the most-winnable axis (§11).

---

## 1. Team

### How we work (read this first)
Roles below are **primary hats, not fences.** They say where each person *defaults* and who to go to
*first* — nothing more. Anyone can jump in on anything they're needed for or curious about. Overlap is
intentional: pair up, swap, help across areas freely. When two people share a hat, that's a feature —
more hands, less bottleneck.

**The only rule:** if something's on fire and it's nobody's clear job, the point-person for that area
makes the call so it doesn't slip. That's the one bit of structure — everything else is fluid.

### Manila Buildathon team — 5 people (Sat July 18)
| Person | Primary hats | Also jumps in on |
|--------|--------------|------------------|
| **Abu** (me) | Product lead + team lead ("CEO") | Pitch/story, wherever needed |
| **Helena** | UI/UX design | Frontend, demo polish |
| **Dia** | UI/UX + pitching | Design, demo narrative |
| **Joshua** | Lead dev + AI/ML | Anything technical (most senior dev) |
| **Farhana** | DevOps + dev + AI/ML + data | Backend, infra, model work |

### Global Build Week team — 7 people (the 5 above + 2)
| Person | Primary hats | Also jumps in on |
|--------|--------------|------------------|
| **Geinel** | Lead dev (with Joshua) | Architecture, anything technical (senior dev) |
| **Jim** | Dev + DevOps + cloud + data | Infra, backend, data pipelines |

### Experience levels
- **3rd years (most dev experience): Joshua, Geinel.** Lean on them for architecture and hard technical
  calls. They're the dev anchors.
- **1st years: Abu, Helena, Dia, Farhana.** Everyone still builds — juniors ship real work, seniors
  unblock and review.

### Light point-people (defaults, not silos — anyone can help on any of these)
- **Product / direction:** Abu
- **Design (UI/UX):** Helena + Dia
- **Pitch / story / demo:** Dia (Abu co-owns the narrative)
- **Frontend:** Helena + Dia (with dev support)
- **AI / ML:** Joshua + Farhana (co-own equally)
- **Backend / dev:** Joshua → + Geinel on Global
- **DevOps / infra / cloud:** Farhana → + Jim on Global
- **Data:** Farhana + Joshua → + Jim on Global

### On Abu's title
Functionally you're the **Product Lead** — you own *what* we build and *why*, and you lead the team.
"CEO" is fine as the external/pitch label. "Product Manager" fits if you're steering scope and priorities
without coding much; "Product Lead" is the cleaner catch-all. Pick whichever you'll say out loud without
flinching. It matters way less than the product being good.

---

## 2. The two events + strategy

| | **Manila Buildathon** (PRIMARY — build day) | **Global Build Week** (TRANSITION — where we win) |
|---|---|---|
| **Role** | Where we actually build | Where we submit + get judged |
| **Format** | Live, in-person, single day; demo + judging 3–4 PM | Async submission on Devpost |
| **Date** | **Sat July 18**, 9 AM–5 PM PHT | Submit by **Mon July 21, 5 PM PT = Tue July 22, 8 AM PHT** |
| **Venue** | Leong Hall, Ateneo de Manila University | Online (openai.devpost.com) |
| **Build time** | **~5.5 h** (Sprint 1 + Sprint 2) | Polish window July 19–21 |
| **Team** | 5 (Abu, Helena, Dia, Joshua, Farhana) | 7 (the 5 + Geinel + Jim) |
| **Deliverable** | Working prototype, **live demo** | Repo + README + <3-min YouTube video + /feedback ID |
| **Prizes** | $5,000 / $2,500 / $1,000 Codex credits | **$15,000 / $10,000 per track** + DevDay passes + Pro yr |
| **Rubric** | Lighter (demo + Codex use + creativity/impact) | 4 equally-weighted criteria (§6) |

**Strategy:** We build at Manila on July 18. Starting **Sunday July 19 PHT** we transition to Global
submission mode: polish, document, submit by the deadline. Everything built on Saturday must be
**dual-purpose** — win the room locally AND satisfy every Global requirement. Build for Global's four
axes from minute one; Manila's lighter rubric is a subset, so it's covered automatically.

---

## 3. Master timeline & critical dates (PT with PHT conversion; PHT = PT + 15 h)

| When (PT) | When (PHT) | Event | Status |
|---|---|---|---|
| Jul 13, 9 AM | Jul 14, 12 AM | Global submission window opens | ✅ open |
| **Jul 17, 12 PM** | **Jul 18, 3 AM** | **Codex credit request form CLOSES** (cutting it close) | ⏳ submitting now |
| — | **Fri Jul 17, night** | **Team meeting → pick the idea + recap roles** | ⏳ next |
| — | **Sat Jul 18, 9 AM–5 PM** | **Manila Buildathon — build day** (demo 3–4 PM) | ⏳ |
| Jul 19–20 | Jul 20–21 | **Transition:** clean code, record video, write README, polish | ⏳ |
| **Jul 21, 5 PM** | **Jul 22, 8 AM** | **GLOBAL SUBMISSION DEADLINE** (hard — no edits after) | ⏳ |
| Jul 22 – Aug 5 | — | Judging period | — |
| ~Aug 12, 2 PM | ~Aug 13, 5 AM | Winners announced | — |

### Manila day-of schedule (PHT, July 18)
| Time | Phase |
|------|-------|
| 8:00–9:00 AM | Registration, breakfast, team formation |
| 9:00–9:45 AM | Welcome, Codex briefing, kickoff |
| 9:45 AM–12:00 PM | **Build Sprint 1** |
| 12:00–1:00 PM | Lunch |
| 1:00–2:45 PM | **Build Sprint 2** + mentor support |
| 2:45–3:00 PM | Submission + demo setup |
| 3:00–4:00 PM | **Demos and judging** |
| 4:00–4:15 PM | Awards |
| 4:15–5:00 PM | Closing + community time |

### Global transition plan (post-Manila)
**Saturday evening (Jul 18, after event):** clean up code from the sprint; ensure all commits have clear
messages; note the Codex Session IDs used.
**Sunday–Monday (Jul 19–21 PT deadline):** record the 3-min demo video → upload to YouTube; write the
comprehensive README (Codex collaboration story); polish the product experience (Design criterion);
ensure the project is accessible for testing; fill out the Devpost form completely; **submit before
July 21, 5 PM PT (= July 22, 8 AM PHT).** Draft early, submit with buffer.

---

## 4. Manila Buildathon — detailed (PRIMARY)

**Facts:** OpenAI Build Week Manila · Sat 2026-07-18 · Leong Hall, Ateneo de Manila University ·
9:00 AM–5:00 PM PHT · Theme: *"Build something real with Codex — any direction welcome."* ·
Prizes: **$5,000 / $2,500 / $1,000** in Codex credits (1st/2nd/3rd). Codex + API credits distributed
to participants.

### Build constraints (Manila-specific)
1. **~5.5 hours of actual build time** (Sprint 1 + Sprint 2). Plan scope accordingly.
2. **Live demo required** — not a pitch deck, not a video. Working software.
3. **No prior Codex experience required** — but be ready to build.
4. **Single day — no overnight polish.** What you demo is what you submit locally.

### Eligible build directions (from the event page)
- **Agentic coding tools and workflows** (developer leverage with Codex)
- **AI-native products** (AI central to the experience)
- **Developer tools** (build, test, debug, document, ship)
- **Evals and reliability tooling** (measure + improve agent performance)
- **Domain agents** (solve real problems for a specific community/industry)

### Alignment with Global Build Week
Everything built here MUST also satisfy Global:
- Use **Codex AND GPT-5.6** (both required for Global).
- Fit one of the four Global tracks (Apps for Your Life / Work & Productivity / Developer Tools / Education).
- Be documentable with **timestamped Codex session logs / commit history.**
- Keep **README documentation of Codex collaboration as you go** (required for Global submission).

### What we need ready before the day
- [ ] OpenAI account + Codex downloaded ✅
- [ ] Codex credits secured (form deadline Jul 17, 12 PM PT = Jul 18, 3 AM PHT — **cutting it close**) ⏳
- [ ] Devpost account created + registered for Global Build Week ✅
- [ ] `idea.md` frozen (or at minimum: problem statement + target segment locked) — **Fri night**
- [ ] Tech stack decided (minimize setup time on the day)
- [ ] Repo initialized with a README structure that satisfies Global submission requirements — **after the pick**

### Manila judging notes
Manila's criteria are less formally specified than Global — focus on **working demo + clear problem
solved + creative use of Codex.** Global judging is equally weighted across Technical Implementation,
Design, Potential Impact, Quality of Idea. **Build for Global criteria from the start** — Manila's
lighter rubric is a subset.

---

## 5. Global Build Week — detailed (TRANSITION TARGET)

**Facts:** OpenAI Build Week (Global Hackathon) · Sponsor: OpenAI OpCo, LLC · Administrator: Devpost,
Inc. · openai.devpost.com · Theme: *"Build any project with Codex and GPT-5.6."* · Format: async
submission — video demo (<3 min) + code repo + README.

**Prizes per track (4 tracks):**
- **1st place:** $15,000 + up to 2 DevDay/Exchange passes (~$650 each) + OpenAI promotion + Meet the
  Codex Team + Pro account (1 yr).
- **2nd place:** $10,000 + OpenAI promotion + Pro account (1 yr).
- Each project is eligible for **one** prize.

**Tracks:**
1. **Apps for Your Life** — consumer apps: productivity, creativity, home, family, travel, health,
   personal finance.
2. **Work & Productivity** — team tools: workflow automation, customer support, analytics, sales,
   back-office.
3. **Developer Tools** — testing, DevOps, agentic workflows, security.
4. **Education** — AI for education: students, teachers, educational organizations.

### What Manila build decisions mean for Global
Every decision at Manila should optimize for Global scoring:
1. **Don't just hack a POC** — judges penalize "just a proof of concept." Build a coherent product.
2. **Document Codex usage as you go** — don't reconstruct later. Save session IDs, note decisions.
3. **Pick a real problem for a real audience** — *Potential Impact* requires a credible, specific case.
4. **Be creative** — *Quality of the Idea* rewards novelty. Don't build another chatbot wrapper.
5. **Make it work end-to-end** — *Technological Implementation* requires a non-trivial working build.

### Pre-existing work policy
Because we build at Manila on July 18 (inside the submission period), our work is **newly created during
the Hackathon Submission Period** — ideal, no need to separate "prior vs new" work. Just keep a clean
commit history from July 18 onward. (Pre-existing projects would need timestamped Codex logs / dated
commits proving work added during the window; not our situation.)

### Eligibility
Philippines is listed under OpenAI's supported countries for API access → **we are eligible.** A team
appoints one **Representative** (Abu) authorized to submit on the team's behalf. Excluded regions and
promotion-entity affiliates don't apply to us.

---

## 6. Judging (Global — two stages)

**Stage 1 (pass/fail):** does it reasonably fit the theme and reasonably use Codex/GPT-5.6?
**Stage 2 (scored — four equally-weighted criteria):**

| Criterion | What judges look for |
|-----------|---------------------|
| **Technological Implementation** | Thorough, skillful use of Codex. Genuine effort. Working, non-trivial implementation. |
| **Design** | Complete, coherent product experience. **Not just a technical proof of concept.** |
| **Potential Impact** | Credible, specific case for solving a **real problem for a real audience.** Solution actually addresses it. |
| **Quality of the Idea** | Creative and novel concept. **Differs from existing solutions.** |

**Tie-breaker:** highest score on the first criterion, then the next, in order. If still tied, the panel
votes.

**Judging methodology:** may use expert panels, peer review, and/or automated AI analysis, in one or more
rounds. **Judges include** OpenAI product/technical staff — Thibault Sottiaux (Head of Product & Platform),
Kath Korevec, Tara Seshan, Leah Belsky (VP of Education), Peter Steinberger (MTS). Real Codex builders:
they will *feel* dev-tooling pain and *smell* a wrapper.

---

## 7. Global submission requirements + checklist

- [ ] Project built with **Codex AND GPT-5.6** (both required — meaningful, not incidental/decorative)
- [ ] **One track** selected (pick the closest match to whatever we build)
- [ ] **Text description** of features + functionality
- [ ] **Demo video < 3 min**, public on **YouTube**, voiceover required (see §8)
- [ ] **Code repo URL** — public (with a license) OR private + shared with `testing@devpost.com` **and**
  `build-week-event@openai.com`
- [ ] **README** with: setup/run instructions, sample data if needed, how you collaborated with Codex
  throughout, where Codex accelerated the work, key product/eng/design decisions, how GPT-5.6 + Codex
  contributed to the final result
- [ ] **/feedback Codex Session ID** from the main build thread (see §12)
- [ ] **Working project accessible for testing** (link, demo instance, or test build; include login creds
  if private)
- [ ] **If we build a plugin / developer tool:** install instructions, supported platforms, and a way for
  judges to test **without rebuilding from scratch** (demo instance / sandbox / test account)
- [ ] All materials in **English** (or provide English translations)

**Multiple submissions** are allowed but each must be unique and substantially different. **No edits after**
the deadline; you may edit freely *before* it.

---

## 8. Demo video requirements (detailed)

| Requirement | Detail |
|-------------|--------|
| Length | **≤ 3 minutes** (judges aren't required to watch past 3 min) |
| Platform | **YouTube, public** |
| Audio | **Voiceover required** — a screencast with only background music won't cut it |
| AI narration? | **Allowed** — TTS / AI voice is fine as long as it covers the required points |
| Language | English, or provide an English translation |
| Must cover | (1) what the project does, (2) **how you used Codex to build it** (workflow, key moments, decisions), (3) **how GPT-5.6 is integrated** and what it's doing |
| Show Codex interface? | Not required, but showing it in action is a **strong signal** to judges |
| No | Third-party trademarks or copyrighted music without permission |

**What makes a great video:** record as you go, not the night before; show a real working product; clear
problem statement, crisp demo, honest explanation of tool usage; don't rush, don't pad.

---

## 9. Codex credits

| Detail | Info |
|--------|------|
| Amount | **$100** free Codex credits per registered entrant |
| Request form | https://forms.gle/Ncu6iGkaHq1SwUmEA |
| **Deadline** | **Fri Jul 17, 12:00 PM PT = Sat Jul 18, 3:00 AM PHT** — closes permanently |
| Required on form | A **CATEGORY from the hackathon** + 1–2 sentences on the project (no category / too short / spammy = auto-declined). *(Our submitted answer is recorded in `context-ideas.md`.)* |
| One code per entrant | Yes. First-come, first-served while supplies last. Allow ~24 h to process. |
| Validity | Must be used by **Jul 21, 5 PM PT**; valid 14 days after redemption |
| Run out? | Codex usage stops; **no auto-charge** unless "Auto top-up" is on (Settings → Usage) |
| Check balance | chatgpt.com → Settings → Usage |
| API credits? | Not provided separately for Global — only Codex credits. You *can* build with the API, but the project must use Codex + GPT-5.6; extra usage beyond credits is your responsibility. |

**Don't submit a second form unless you get a denial.** By submitting you agree to the OpenAI Services
Agreement. Credits have no cash value.

---

## 10. Rules that matter for us

1. **New / meaningfully-extended work only** — building at Manila (inside the window) makes us "newly
   created." Keep clean commit history as proof.
2. **One project → one prize → one track.** Pick the closest track.
3. **Original work, solely owned**, no IP violations. Open-source libs OK if you comply with licenses and
   **build something that enhances them** (don't just wrap an OSS tool).
4. **No financial/preferential support** from OpenAI/Devpost for the project's development.
5. **Must function** — installable and running consistently on its intended platform, as shown in the video.
6. **Third-party integrations** — only if you're authorized under their terms/licensing.
7. **No edits after** Jul 21, 5 PM PT. Draft early, submit with buffer.
8. **Additional charges** beyond the provided credits are the entrant's responsibility — monitor usage.

---

## 11. Codex usage discipline (don't lose the easy points)

*Use of Codex* is weighted heavily and is the cheapest axis to win — but only if we capture evidence live:
- **Run `/feedback` in the main build thread** and save the **Session ID** the moment core work is done.
  Losing this is a self-inflicted wound.
- **Keep clean, timestamped commit history** from July 18 onward.
- **Narrate Codex decisions in the README as they happen** ("Codex generated X; we chose Y because Z").
- **Dogfood Codex where the product allows** — showing Codex in action on camera is a strong signal.

---

## 12. Full FAQ

### Participation
| Question | Answer |
|----------|--------|
| Solo or team? | Both. Individual, team, or organization. |
| Team size limit? | No hard limit, but some prizes have team-size restrictions (e.g., DevDay passes cap at 2). |
| Pre-existing projects? | Allowed — must clearly document what's new, with evidence Codex/GPT-5.6 was used during the window (timestamped logs / commit history). **Not our case — we build fresh.** |
| Multiple tracks? | No. One project → one track. Pick the closest match. |
| Team in different countries? | Yes, if each member meets eligibility for their country. |
| Need to be a pro developer? | No. Education track explicitly welcomes students/educators/learners; all tracks open to anyone eligible. |

### Tools & requirements
| Question | Answer |
|----------|--------|
| Must use Codex? | **Yes.** Required. Demonstrated in text description, demo video, README. Provide /feedback Session ID. |
| Must use GPT-5.6? | **Yes.** Must be clearly referenced in the demo video and repo/README. |
| Other models/tools? | Allowed (standard libs, frameworks, third-party SDKs) — but Codex + GPT-5.6 must be **meaningful**, not decorative. |
| What counts as "using Codex"? | Building your project with it — ChatGPT app, Codex CLI, IDE extension, or SDK. Verified via the /feedback Session ID from the main build thread. |
| Open-source libraries? | Yes. Comply with licenses. Disclose pre-existing code and third-party work. |

### /feedback Session ID
- Run `/feedback` in the Codex thread where you did the **majority of your core work**.
- It generates a unique **Session ID** → paste into the submission form.
- Multiple threads? Pick the most representative one; document other Codex contributions in the README.

### Judging
| Question | Answer |
|----------|--------|
| Do judges test my project? | They **may** but aren't required to; they'll use your demo link/sandbox/test account. Make the README and instructions clear. |
| Update after the deadline? | **No.** No changes after Jul 21, 5:00 PM PT. |
| Edit before the deadline? | **Yes** — edit your submission freely until the deadline closes. |

---

## 13. Devpost Hackathons plugin (optional) + support

**Devpost plugin (optional, no judging advantage):**
- Install in Codex inside ChatGPT — loads Build Week context (rules, tracks, submission form, resources).
- **Not required.** You can do everything via openai.devpost.com. Requires a free Devpost account.
- Commands: `$find-hackathons`, `$start-hackathon`, `$resources`, `$prepare-submission`, `$submit`.
  Can help ideate, plan, prepare the submission, run a security/eligibility audit.
- **Not the source of truth** — the Official Rules and Hackathon Website win on any conflict; plugin output
  can be inaccurate. Verify against the rules.
- Plugin sessions count as Codex sessions, but **chatting ≠ building** — judges evaluate the actual project.
- Recommended: use Codex in the **ChatGPT desktop app** (macOS/Windows) for the best experience.

**Support:** `#build-week-chat` in the OpenAI Discord · the Devpost Discussion Board · support@devpost.com.

---

## 14. Build & execution discipline (idea-agnostic)

Whatever we pick Fri night, these hold:
- **Scope brutally for ~5.5 h.** Ship a working skeleton early; cut anything that doesn't show in the demo
  or move a judging axis. One use case working end-to-end beats broad-and-broken.
- **The demo is the deliverable.** Name the on-screen **before → after** *before* writing meaningful code.
  If you can't name it, it's not demoable yet.
- **Build a coherent product, not a POC** — the Design axis explicitly penalizes "just a proof of concept."
- **Make the audience concrete** — *Potential Impact* needs a specific, credible "who is this for and why
  does it matter to them."
- **Protect the free points** — `/feedback` Session ID + clean commit history + README-as-you-go.
- **Validate before committing** if the idea's demand is unproven — pitch it in one sentence to a few
  builders Saturday AM; a wince-and-nod means go, a shrug means switch.

---

## 15. Reference links
- Hackathon home: https://openai.devpost.com · Official rules: https://openai.devpost.com/rules
- Credit form: https://forms.gle/Ncu6iGkaHq1SwUmEA
- Codex hooks docs: https://developers.openai.com/codex/hooks/
- GPT-5.6 docs: https://developers.openai.com/api/docs/guides/latest-model?model=gpt-5.6
- Codex quickstart: https://learn.chatgpt.com/docs/quickstart
- Supported countries: https://platform.openai.com/docs/supported-countries
- Repo sharing (if private): `testing@devpost.com` + `build-week-event@openai.com`
- Support: `#build-week-chat` in OpenAI Discord · support@devpost.com

---

## 16. CEF / idea-forge context blocks (preserved verbatim)

These are the machine-readable context blocks the idea-forge (CEF) framework consumes. Preserved so the
framework integration isn't lost.

**Manila (PRIMARY — day-one target):**
```yaml
team_size: 5               # Abu, Helena, Dia, Joshua, Farhana
mode: team                 # see §1 for roster + roles
build_type: hackathon
time_budget: 6h            # ~9:00 AM to 3:00 PM build time (two sprints + setup)
judged: true
computes_numbers: false
exposed_surface: true
outlives_demo: true        # what we build here transitions to Global Build Week
selection_mode: auto
competition:
  name: OpenAI Build Week Manila
  theme: "Build something real with Codex — any direction welcome"
  format: "Live demo + judging (3:00-4:00 PM), single day event"
  date: 2026-07-18 (Saturday)
  venue: Leong Hall, Ateneo de Manila University
  time: 9:00 AM - 5:00 PM (PHT)
  prizes: { first: USD 5,000 credits, second: USD 2,500 credits, third: USD 1,000 credits }
```

**Global (TRANSITION TARGET — polish + submit here):**
```yaml
team_size: 7               # Buildathon 5 + Geinel, Jim
mode: team
build_type: hackathon
time_budget: 8d            # July 13–21 submission window (we enter via Manila on July 18)
judged: true
competes_numbers: false
exposed_surface: true
outlives_demo: false       # judging only — no production commitment
selection_mode: auto
competition:
  name: OpenAI Build Week (Global Hackathon)
  theme: "Build any project with Codex and GPT-5.6"
  format: "Async submission on Devpost — video demo (<3 min) + code repo + README"
  sponsor: OpenAI OpCo, LLC
  administrator: Devpost, Inc.
  website: openai.devpost.com
  rubric:   # four equally-weighted criteria (25% each)
    - Technological Implementation
    - Design
    - Potential Impact
    - Quality of the Idea
```
