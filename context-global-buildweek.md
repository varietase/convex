---
# idea-forge context block — OpenAI Build Week Global
# TRANSITION TARGET: After Manila Buildathon (Sunday onward), polish + submit here.
team_size: 7               # Buildathon 5 + Geinel, Jim
mode: team                 # see context-team.md for roster + roles
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
  rubric:
    - Technological Implementation: 25% (How thoroughly and skillfully does the project use Codex?)
    - Design: 25% (Complete, coherent product experience — not just a proof of concept)
    - Potential Impact: 25% (Credible, specific case for solving a real problem for a real audience)
    - Quality of the Idea: 25% (How creative and novel is the concept vs existing solutions?)
  hard_requirements:
    - Must use Codex AND GPT-5.6
    - Demo video < 3 minutes, uploaded to YouTube (public)
    - Clear audio demo covering what you built + how you used Codex and GPT-5.6
    - Code repo (public or shared with testing@devpost.com + build-week-event@openai.com)
    - README describing Codex collaboration throughout the project
    - Provide /feedback Codex Session ID for main build thread
    - Text description of features and functionality
    - Working project accessible for testing (link, demo, or test build)
    - All materials in English
    - Must fit one of four tracks
  tracks:
    - "Apps for Your Life: Consumer apps — productivity, creativity, home, family, travel, health, personal finance"
    - "Work & Productivity: Tools for teams — workflow automation, customer support, analytics, sales, back-office"
    - "Developer Tools: Testing, DevOps, agentic workflows, security"
    - "Education: AI for education — students, teachers, educational organizations"
  prizes_per_track:
    first: "$15,000 + Dev Day passes (2) + OpenAI promotion + Meet Codex Team + Pro Account 1yr"
    second: "$10,000 + OpenAI promotion + Pro Account 1yr"
---

# Build Context — OpenAI Build Week Global (TRANSITION TARGET)

## Strategy

We build at Manila Buildathon on July 18 (Saturday). Starting **Sunday July 19
PHT**, we transition to Global submission mode: polish, document, and submit by
the deadline.

**Manila is the build sprint. Global is the submission stage.**

## Critical Dates (all Pacific Time unless noted)

| Date | Event |
|------|-------|
| July 13, 9 AM PT | Submission period opens |
| July 17, 12 PM PT | Credit request form deadline |
| **July 18 (Sat)** | **Manila Buildathon — our build day** |
| **July 19–20** | **Transition: polish, video, README, submit** |
| **July 21, 5 PM PT** | **SUBMISSION DEADLINE** (= July 22, 8 AM PHT) |
| July 22 – Aug 5 | Judging period |
| ~Aug 12, 2 PM PT | Winners announced |

## Submission Checklist (what Devpost requires)

- [ ] Project built with Codex + GPT-5.6
- [ ] Track selected (one of four)
- [ ] Text description of features and functionality
- [ ] Demo video (<3 min) on YouTube (public)
  - Clear audio
  - Shows what you built
  - Shows how you used Codex and GPT-5.6
- [ ] Code repo URL (public, or shared with testing@devpost.com + build-week-event@openai.com)
- [ ] README with:
  - How you collaborated with Codex throughout
  - Where Codex accelerated workflow
  - Key product/engineering/design decisions
  - How GPT-5.6 and Codex contributed to final result
- [ ] /feedback Codex Session ID for main build thread
- [ ] Working project accessible for testing (URL, demo instance, or test build)
- [ ] For plugins/dev tools: installation instructions, supported platforms, way to test without rebuilding

## Judging — Two Stages

### Stage 1: Pass/Fail
- Does the project reasonably fit the theme?
- Does it reasonably apply Codex/GPT-5.6?

### Stage 2: Scoring (equally weighted)

| Criterion | What judges look for |
|-----------|---------------------|
| **Technological Implementation** | Thorough, skillful use of Codex. Genuine effort. Working, non-trivial implementation. |
| **Design** | Complete, coherent product experience. Not just a technical proof of concept. |
| **Potential Impact** | Credible, specific case for solving a real problem for a real audience. Solution actually addresses that problem. |
| **Quality of the Idea** | Creative and novel concept. Differs from existing solutions. |

Tie-breaker: highest score in first criterion, then second, etc.

## Rules That Matter for Us

1. **New or meaningfully extended** — pre-existing projects must document what was added during the submission period (July 13–21). Timestamped Codex session logs or dated commit history required.
2. **One project, one prize** — each project eligible for one prize only.
3. **Multiple submissions allowed** — but each must be unique and substantially different.
4. **Original work** — solely owned, no IP violations.
5. **No financial/preferential support from OpenAI/Devpost** for the project's development.
6. **Project must function** — capable of being installed and running consistently on intended platform.

## Pre-Existing Work Policy

Since we're building at Manila on July 18 (within the submission period), our
work is **newly created during the Hackathon Submission Period**. This is ideal —
no need to document "prior vs new" work. Just keep clean commit history from
July 18 onward.

## Transition Plan (Post-Manila)

### Saturday Evening (July 18, after event)
- Clean up code from build sprint
- Ensure all commits have clear messages
- Note Codex Session IDs used

### Sunday–Monday (July 19–21 PT deadline)
- Record 3-minute demo video → upload to YouTube
- Write comprehensive README (Codex collaboration story)
- Polish the product experience (design criterion)
- Ensure project is accessible for testing
- Fill out Devpost submission form completely
- Submit before July 21, 5 PM PT (= July 22, 8 AM PHT)

## What This Means for Manila Build Decisions

Every decision at Manila should optimize for Global scoring:
1. **Don't just hack a POC** — judges penalize "just a proof of concept." Build a coherent product experience.
2. **Document Codex usage as you go** — don't reconstruct later. Save session IDs, note decisions.
3. **Pick a real problem for a real audience** — "Potential Impact" requires a credible, specific case.
4. **Be creative** — "Quality of the Idea" rewards novelty. Don't build another chatbot wrapper.
5. **Make it work end-to-end** — "Technological Implementation" requires a non-trivial, working implementation.

## Eligible Countries & Us

Philippines is listed under OpenAI's supported countries for API access. We are eligible.

---

## FAQ — Quick Reference

### Participation

| Question | Answer |
|----------|--------|
| Solo or team? | Both. Individual, team, or organization. |
| Team size limit? | No limit, but some prizes have their own team-size restrictions. Check prize details. |
| Pre-existing projects? | Allowed — must clearly document what's new. Provide evidence Codex/GPT-5.6 was used during submission period (timestamped logs, commit history). |
| Multiple tracks? | No. One project → one track. Pick the closest match. |
| Team in different countries? | Yes, if each member meets eligibility for their country. |
| Need to be a pro developer? | No. Education track explicitly welcomes students/educators/learners. All tracks open to anyone eligible. |

### Tracks

1. **Apps for Your Life** — consumer/personal
2. **Work and Productivity** — teams/business
3. **Developer Tools** — testing, DevOps, agentic, security
4. **Education** — students, teachers, educational orgs

### Tools & Requirements

| Question | Answer |
|----------|--------|
| Must use Codex? | **Yes.** Required. Must be demonstrated in text description, demo video, README. Provide /feedback Session ID. |
| Must use GPT-5.6? | **Yes.** Must be clearly referenced in demo video and code repo/README. |
| Other models/tools? | Allowed (standard libs, frameworks, third-party SDKs) — but Codex + GPT-5.6 must be **meaningful**, not incidental or decorative. |
| What counts as "using Codex"? | Building your project with it — ChatGPT app, Codex CLI, IDE extension, or SDK. Verified via /feedback Session ID from main build thread. |
| Open source libraries? | Yes. Comply with licenses. Disclose pre-existing code and third-party work. |

### /feedback Session ID

- Run `/feedback` in the Codex thread where you did the **majority of your core work**.
- It generates a unique Session ID → paste into submission form.
- If multiple threads: pick the most representative one. Document other Codex contributions in README.

### Codex Credits

| Detail | Info |
|--------|------|
| Amount | $100 free per registered participant |
| Request form | https://forms.gle/Ncu6iGkaHq1SwUmEA |
| **Deadline** | **Friday July 17, 12:00 PM PT** — form closes permanently |
| One code per Entrant | Yes |
| Run out? | Codex usage stops. No auto-charge unless you turned on "Auto top-up" in Settings → Usage. |
| Check balance | chatgpt.com → Settings → Usage |
| API credits? | Not provided separately — only Codex credits distributed for this event. |
| Can build with API? | Yes, but project must use Codex and/or GPT-5.6 to be eligible. Extra usage beyond credits is your responsibility. |

### Submissions — What's Required

1. Working project built with Codex + GPT-5.6
2. Chosen track (one of four)
3. Text description — what you built and how it works
4. Public YouTube demo video (≤ 3 min, voiceover required)
5. Code repo URL — public (with licensing) OR private shared with `testing@devpost.com` + `build-week-event@openai.com`
6. README with: setup instructions, sample data if needed, how to run/test, how Codex accelerated workflow, key decisions, how GPT-5.6 integrated
7. /feedback Codex Session ID from primary build thread
8. For plugins/dev tools: installation instructions, supported platforms, way for judges to test without rebuilding

### Demo Video Requirements

| Requirement | Detail |
|-------------|--------|
| Length | ≤ 3 minutes (judges not required to watch beyond 3 min) |
| Platform | YouTube, public |
| Audio | **Voiceover required** — screencast with background music won't cut it |
| AI narration? | Allowed — TTS or AI voice tools fine, as long as narration covers required points |
| Language | English, or provide English translation |
| Must cover | (1) What your project does, (2) How you used Codex to build it (workflow, key moments, decisions), (3) How GPT-5.6 is integrated and what it's doing |
| Show Codex interface? | Not required, but showing it in action is a strong signal to judges |

**What makes a great video:** Record as you go, not the night before. Show a real working product. Clear problem statement, crisp demo, honest explanation of tool usage. Don't rush, don't pad.

### Judging

| Question | Answer |
|----------|--------|
| Do judges test my project? | They may but aren't required to. They'll use your demo link/sandbox/test account. Make README and instructions clear. |
| Can I update after deadline? | **No.** No changes after July 21, 5:00 PM PT. |
| Can I edit before deadline? | Yes — you can edit your submission until the deadline closes. |

### Devpost Hackathons Plugin (Optional)

- Install in Codex inside ChatGPT — loads full Build Week context (rules, tracks, submission form, resources)
- **Not required.** No judging advantage.
- Requires Devpost account. Free.
- Commands: `$find-hackathons`, `$start-hackathon`, `$resources`, `$prepare-submission`, `$submit`
- Can help ideate, plan, prepare submission, do security/eligibility audit
- **Not the source of truth** — Official Rules always win on conflicts
- Sessions in plugin count as Codex sessions, but chatting ≠ building — judges evaluate the actual project
- Recommended: Use Codex in **ChatGPT desktop app** (macOS/Windows) for best experience

### Support

- Discord: `#build-week-chat` in OpenAI Discord
- Discussion Board on Devpost
