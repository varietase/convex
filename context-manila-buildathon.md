---
# idea-forge context block — OpenAI Build Week Manila
# PRIMARY FOCUS: This is our day-one target. Build here, then transition to Global.
team_size: 5               # Abu, Helena, Dia, Joshua, Farhana
mode: team                 # see context-team.md for roster + roles
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
  rubric:
    - Demo quality: judged live, working prototype required
    - Use of Codex: central to the build process
    - Creativity and impact: real problem, real audience
  hard_requirements:
    - Must use Codex (GPT-5.6 family)
    - Must produce a working, demoable prototype by 2:45 PM
    - Must demo live (3:00-4:00 PM window)
    - Bring own laptop + charger
    - Attend full day in person
  prizes:
    first: USD 5,000 in Codex credits
    second: USD 2,500 in Codex credits
    third: USD 1,000 in Codex credits
  credits: Codex credits & API credits distributed to participants
---

# Build Context — OpenAI Build Week Manila (PRIMARY)

## Strategy

Manila Buildathon is our **primary focus**. We build here first. Everything we
produce on July 18 must be **dual-purpose**: win locally AND be submittable to
the Global Build Week (submission deadline July 21, 5 PM PT).

**After Sunday (July 20 PHT / July 19 PT), we transition to Global stage.**

## Timeline (PHT, July 18)

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

## Build Constraints (Manila-specific)

1. **~5.5 hours of actual build time** (Sprint 1 + Sprint 2). Plan scope accordingly.
2. **Live demo required** — not a pitch deck, not a video. Working software.
3. **No prior Codex experience required** — but you should be ready to build.
4. **Single day** — no overnight polish. What you demo is what you submit.

## Eligible Build Directions (from event page)

- Agentic coding tools and workflows (developer leverage with Codex)
- AI-native products (AI central to the experience)
- Developer tools (build, test, debug, document, ship)
- Evals and reliability tooling (measure + improve agent performance)
- Domain agents (solve real problems for a specific community/industry)

## Alignment with Global Build Week

Everything built here MUST also satisfy Global requirements:
- Use **Codex AND GPT-5.6** (both required for Global)
- Fit one of the four Global tracks: Apps for Your Life, Work & Productivity, Developer Tools, Education
- Be documentable with timestamped Codex session logs / commit history
- Keep README documentation of Codex collaboration as you go (required for Global submission)

## What We Need Ready Before the Day

- [ ] OpenAI account + Codex downloaded
- [ ] API credits secured (request form deadline: July 17, 12 PM PT = July 18 3 AM PHT — CUTTING IT CLOSE)
- [ ] Devpost account created + registered for Global Build Week
- [ ] idea.md frozen (or at minimum: problem statement + target segment locked)
- [ ] Tech stack decided (minimize setup time on the day)
- [ ] Repo initialized with README structure that satisfies Global submission requirements

## Post-Manila Transition Plan

After demos on Saturday July 18:
1. **Saturday evening**: Clean up code, improve README, record demo video
2. **Sunday July 19–20**: Polish, extend, document Codex collaboration thoroughly
3. **Monday July 21 (before 5 PM PT = Tuesday July 22, 8 AM PHT)**: Submit to Global Build Week on Devpost

## Notes

- Manila judging criteria are less formally specified than Global — focus on **working demo + clear problem solved + creative use of Codex**
- Global judging is equally weighted across: Technical Implementation, Design, Potential Impact, Quality of Idea
- Build for Global criteria from the start — Manila's lighter rubric is a subset
