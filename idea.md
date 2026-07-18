---
status: draft
schema_version: 2.1.0
origin: Abu — student hackathon builder who has personally shipped code (and led teams shipping code) at hackathons where the AI wrote parts he could not later explain or maintain. The Manila team (5 builders, incl. 1st-year students) fits the same profile; two are 3rd-years who watch the juniors accrue this gap in real time. Unfair advantage = we ARE the segment and can dogfood tomorrow.
payer_status: none-found
---

# Idea: convex — the comprehension gap builders accrue when they ship faster than they learn

## 1. Problem statement

A builder — usually self-taught, often a student, often mid-hackathon — asks an AI agent to write a piece of their project. It works. They ship. But when a teammate, a judge, an interviewer, or a future version of themselves asks *how does this function connect to the rest of the code, and what concepts is it built on*, they can't answer. The gap isn't in generating code; it's in **understanding the code that already sits in their repo**. Every additional agent-written commit widens the gap between what's in the codebase and what's in their head. The pain is chronic (not acute) — a slow-burn erosion of the ability to reason about, maintain, or extend their own work — and it compounds every time they lean on the agent instead of reading the diff.

## 2. Target segment

**Who suffers:** self-taught / hackathon / bootcamp / student builders using AI coding agents (Copilot, Cursor, Claude Code, Codex) on their own projects — with two sharpened profiles worth naming this week:

- **1st- and 2nd-year CS students shipping at hackathons.** Building 24–72h projects with AI agents, submitting them, then failing to explain what they built in the judging Q&A or a follow-on internship interview. The Manila team includes four of these; Abu is one. We can interview five of them by Saturday.
- **Career-switchers / bootcamp finishers.** Just built portfolio projects with AI help; can't answer walkthrough questions in interviews; the "explain every line back" test is where the offer decides ([interviewcoder.co, 2026-01](https://www.interviewcoder.co/blog/github-copilot-for-coding-interviews)).

Frequency: every project. Volume: 84% of developers already use or plan to use AI coding tools; 44% of learners specifically used AI-enabled tools to learn code in 2025, up from 37% in 2024 (Stack Overflow Developer Survey 2025).

> [!evidence] Type: said | Source: so-devsurvey-2025 | Tier: analyst | COI: no | Date: 2025-07-29

**Who pays:** **none-found.** The sufferer is a student or hobbyist with near-zero willingness to pay for a learning tool (historical pattern in dev-education products). Plausible-but-unvalidated payer candidates: (a) bootcamps and CS programs that want measurable learning outcomes, (b) hackathon organizers who want judging depth, (c) hiring platforms that want interview-ready portfolios. None of these have been probed. Honest read: this is a **real problem that is not yet a venture.** For a hackathon demo it's a legitimate build; for a company it would need a payer path found before Series A math applies.

## 3. Evidence

- **"Comprehension debt" is a named, measured phenomenon in AI-assisted software work.** A 2026 qualitative study of undergraduate SE projects identifies four accumulation patterns — AI-as-black-box acceptance, context-mismatch debt, dependency-induced atrophy, and verification-bypass — plus one mitigating pattern where students use GenAI as a *comprehension scaffold* rather than a generator ([arXiv 2604.13277, "Comprehension Debt in GenAI-Assisted Software Engineering Projects"](https://arxiv.org/abs/2604.13277)).
  > [!evidence] Type: did | Source: arxiv-2604.13277 | Tier: peer | COI: no | Date: 2026-04-11

- **CS1 students succeed only 32.5% of the time at understanding LLM-generated code** across 160 task instances (n=32), with "indiscriminate struggles across demographic populations" — code comprehension is the barrier for beginners writing with LLMs ([arXiv 2504.19037, "'I Would Have Written My Code Differently'"](https://arxiv.org/abs/2504.19037)).
  > [!evidence] Type: did | Source: arxiv-2504.19037 | Tier: peer | COI: no | Date: 2026-04-22

- **Programming students get trapped in a "vicious cycle" of submitting wrong generated code and re-prompting for a fix instead of reading and understanding it** ([arXiv 2501.10091, "How Do Programming Students Use Generative AI?"](https://arxiv.org/abs/2501.10091)). This is the behavioral signature of the gap — not "they can't code," but "they can't stop long enough to read what they shipped."
  > [!evidence] Type: did | Source: arxiv-2501.10091 | Tier: peer | COI: no | Date: 2025-02-20

- **Trust in AI output is falling while usage rises** — 84% use/plan to use AI tools, only 29% trust output accuracy (down from 40% in 2024), 46% actively distrust it, and 66% say the top frustration is "AI solutions that are almost right, but not quite" (Stack Overflow Developer Survey 2025, ~49,000 respondents, 177 countries).
  > [!evidence] Type: said | Source: so-devsurvey-2025 | Tier: analyst | COI: no | Date: 2025-07-29

- **Interviewers now decide hire/reject on whether the candidate can explain every line back and debug a planted bug in their AI-assisted code** — the *comprehension* test, not the *generation* test, is what filters ([interviewcoder.co, 2026-01](https://www.interviewcoder.co/blog/github-copilot-for-coding-interviews)).
  > [!evidence] Type: said | Source: interviewcoder-2026-01 | Tier: media | COI: no | Date: 2026-01-01

- **The gap is being named in the trade press.** Coined phrase: "comprehension debt" ([TechRadar Pro, 2025](https://www.techradar.com/pro/the-rise-of-comprehension-debt-in-the-age-of-ai-coding)); "knowledge debt" ([arXiv 2607.06101, 2026](https://arxiv.org/html/2607.06101v1)); "cognitive debt" ([devtoollab, 2026](https://devtoollab.com/blog/cognitive-debt-ai-coding)). Multiple independent framings converge on the same pain in ~12 months — a signal, not a fashion, though whether the three frames describe the *same* phenomenon or overlapping ones is not yet established. [unverified]
  > [!evidence] Type: said | Source: techradar-comprehension-debt | Tier: media | COI: no | Date: 2025-07-15

### Four tests

| Test | Pass/Fail | Why |
|------|-----------|-----|
| Real (does it happen?) | **PASS** | Documented behaviorally in three peer studies (arxiv-2604.13277, 2504.19037, 2501.10091); named in trade press. |
| Large (enough people?) | **PASS** | 84% of developers use/plan to use AI tools; 44% of learners specifically. Millions of students in the exact profile. |
| Significant (do they care?) | **MED** | They care about interview outcomes and judging feedback — proven. They care about "learning" in the abstract — historically less proven (weak willingness to pay for education). |
| Urgent (now, not someday?) | **MED** | This is a slow-burn / chronic pain, not an acute one. The world doesn't end tomorrow if this gap isn't closed. Owner-honest: this is a nice-to-have with a compounding cost, not a fire. |

## 4. Root cause (the WHY)

Five-whys from the symptom:

1. A builder can't explain their own code. **Why?** They didn't read the code before shipping it.
2. Why not? Reading unfamiliar code is slow; the agent produced it faster than a human can absorb it, and there's no pressure at the moment of acceptance to stop and understand.
3. Why is there no pressure? Because the code passes tests / runs / demos correctly — the local feedback loop rewards *shipping*, not *comprehending*.
4. Why doesn't tooling supply that comprehension in-loop? Existing "explain this snippet" features answer a local, isolated question (*what does this function do?*) — they don't answer the structural one (*how does this connect to the rest of the codebase, and what concepts is it built on?*).
5. Why don't they answer the structural question? Because doing so requires (a) a call/data-flow graph of the actual repo, (b) an LLM narrative grounded in that graph rather than in the snippet, and (c) a personalized synthesis of what the builder doesn't-yet-know relative to what their code depends on. That pipeline was not reliably buildable until recently.

**Structural root cause:** the learning loop that used to happen naturally — reading, blocking, googling, forum-diving — was **short-circuited** by the agent. Nothing structurally replaced it inside the workflow. See also [arXiv 2607.06101 on "Knowledge Debt"](https://arxiv.org/html/2607.06101v1): the incidental-learning pathway is gone, and no in-loop scaffold has taken its place.

**Why is this still unsolved today?** "Explain this snippet" *has* been solved and is now a commodity across Copilot, Cursor, and Claude Code (see §5) — but explaining a *snippet* was the wrong unit. The unit that maps to comprehension debt is the **repo-level connection map + personalized concept gap**, and that is not on any incumbent's shipped feature list.

**Why now — the enabling shift (four-forces).**
- **Pull moved (up):** code-aware agents (Codex, Claude Code, Cursor 2.0) can now reliably ground explanations in a call graph of the actual repo — not just a text snippet — in 2025–26. That capability was flaky ~two years ago.
- **Push moved (up):** trust in raw AI output collapsed from 40% → 29% in one year (Stack Overflow 2025) *while* adoption kept rising — builders are actively looking for tools that let them verify without slowing them down.
- **Habit moved (down):** hackathon and portfolio culture now assumes AI in the loop; there is no "old workflow" to snap back to. Reading every line by hand is not the fallback anymore.
- **Anxiety unchanged:** low. A read-only comprehension tool has essentially no downside risk for the user.

> [!evidence] Type: said | Source: so-devsurvey-2025 | Tier: analyst | COI: no | Date: 2025-07-29

The force that recently moved most is **Pull** (agents that can ground explanations in structural facts about the codebase, not just guess from the snippet). That was the missing enabler.

## 5. Market & alternatives

**Bottom-up sizing (reachable this week, not top-down).** The immediately reachable audience is Ateneo CS student hackathon builders and Manila-region student devs — low hundreds, easily. The next ring is Southeast Asian bootcamp/CS-student cohorts and global student hackathon communities (MLH, DevPost, HackerEarth) — hundreds of thousands globally. Reachability channels we can hit this week: (a) the Manila Buildathon room July 18, (b) the Ateneo CS student network, (c) the OpenAI Build Week Discord / Devpost community, (d) student-focused subreddits. This is a *distribution-abundant* segment, not a *willingness-to-pay-abundant* one — the sizing question that matters is retention and reach, not ARR.

**Top-3 alternatives + failure modes:**

1. **"Explain this code" inside Copilot / Cursor / Claude Code / Cody.** The commodity option. Right-click → Explain, or chat with the file open. Ships in all four major agents ([Cursor forum thread confirms explain-code UX, 2025-01](https://forum.cursor.com/t/feature-request-dedicated-explain-code-command/147925); [Sourcegraph 5.0 Cody blog confirms codebase-aware Q&A, 2023](https://sourcegraph.com/blog/release-5-0); [2026 comparison confirming all three agents ship this](https://www.cosmicjs.com/blog/claude-code-vs-github-copilot-vs-cursor-which-ai-coding-agent-should-you-use-2026)). **Key failure:** answers a local, isolated *snippet* question; does not produce a structural map across levels of abstraction, and does not build a personalized concept-gap list from the user's actual repo. It teaches this line, not the *codebase*.
   > [!evidence] Type: did | Source: cursor-forum-explain-code | Tier: forum | COI: no | Date: 2025-01-04
   > [!evidence] Type: did | Source: sourcegraph-cody-5.0 | Tier: primary | COI: yes | Date: 2023-03-23
   > [!evidence] Type: did | Source: cosmicjs-2026-comparison | Tier: media | COI: no | Date: 2026-02-27

2. **Do nothing / "I'll learn it later."** The default. **Key failure:** the comprehension gap compounds silently until it surfaces in a demo Q&A, an interview walkthrough, or a maintenance bug — always at the worst moment. Behaviorally observed as the "vicious cycle" pattern in arxiv-2501.10091 (see §3).
   > [!evidence] Type: did | Source: arxiv-2501.10091 | Tier: peer | COI: no | Date: 2025-02-20

3. **Read a tutorial / take a course on the concepts you *think* you're missing.** Generic curriculum, generic order, disconnected from what's in the builder's actual repo. **Key failure:** high friction, wrong altitude — a tutorial on "React hooks" doesn't help you understand *how the hook the agent wrote in your file connects to the state in a sibling component you didn't touch.* [unverified]

**Prior attempts (the graveyard):** codebase-map / visualization tools have been tried and mostly died. Naming them matters because we need to answer *why they failed, and what recently moved that changes it.*

- **CodeSee (2020–2024) — shut down 2024** after raising ~$10M total (including a $7M secondary seed in 2022). Post-mortem cites "misalignment between the product's perceived value and the market's demand" — dev teams didn't buy a standalone visualization surface separate from where they already worked ([ideaproof.io failure analysis](https://ideaproof.io/failure/codesee); [TechCrunch 2022 funding coverage](https://techcrunch.com/2022/01/20/codesee-pulls-in-a-7m-secondary-seed-to-build-out-code-visualization-platform/)).
  > [!evidence] Type: did | Source: ideaproof-codesee | Tier: analyst | COI: no | Date: 2025-01-22
  > [!evidence] Type: did | Source: techcrunch-codesee-7m | Tier: media | COI: no | Date: 2022-01-20

- **Sourcetrail (2016–2021) — archived December 14, 2021.** Open-sourced first, then discontinued for lack of a maintainer team and commercial viability ([GitHub repo archive notice](https://github.com/CoatiSoftware/Sourcetrail); [Coati Software EOL post referenced in Issue #1214](https://github.com/CoatiSoftware/Sourcetrail/issues/1214)).
  > [!evidence] Type: did | Source: github-sourcetrail-archive | Tier: primary | COI: no | Date: 2021-12-14

- **Sourcegraph (still alive) — code navigation and cross-repo jump-to-definition for engineering teams**, plus Cody for codebase-aware chat. Targets professional teams with big repos and mature workflows. **Not a competitor for the student / hackathon builder** — pricing, positioning, and setup friction all point at enterprise ([Sourcegraph docs / code navigation](https://sourcegraph.com/docs/code-navigation/precise-code-navigation)). Relevant only as evidence that *codebase-scale navigation is a real, funded, useful thing* — just not for this segment.
  > [!evidence] Type: did | Source: sourcegraph-code-navigation | Tier: primary | COI: yes | Date: 2024-01-01

**What the graveyard teaches (problem-space only, not solution-design):** the failed attempts were **standalone visualization surfaces detached from a learning goal, for teams**, in an era when the enabling AI narrative layer didn't exist. The unmet piece isn't "draw a graph" — that's largely commoditized via static analysis. It's the combination *structural map + personalized concept synthesis + delivered in the builder's actual workflow*, for the individual learner rather than the team. The force that recently moved (code-aware LLMs that can narrate a graph) is exactly what those tools were missing.

**Existing spend + switching cost (incumbent hold).** Almost none — this is the honest and inconvenient half. The commodity "Explain this" feature is bundled into an editor the builder already pays for or gets free (Copilot ~$10/mo, Cursor free/hobby, Claude Code free with API), so nobody is *separately* paying to solve comprehension debt today. That's simultaneously the opportunity ("no one owns this budget line") and the problem ("no one has proven anyone will spend on this budget line"). Switching cost from "the built-in Explain button" is near-zero — the user just doesn't open the new thing. This constrains the honest pitch: **not "capture spend from an incumbent," but "prove someone new will start spending / stay engaged."**

## 6. Value proposition

For self-taught and student builders who ship agent-written code faster than they can understand it, convex is a **comprehension control layer for code** that turns a repository into an evidence-backed mental model and tests what the builder can actually explain, unlike IDE explain buttons that produce one-off prose, because every structural claim traces to deterministic code evidence and every learning recommendation adapts to the builder's demonstrated gaps.

## 7. Feature set

**MVP**
- **F-001 — Evidence-backed repository graph** → extracts symbols, imports, calls, and module relationships with deterministic source references, solving the inability to see how agent-written code connects across files while enforcing INV-001.
- **F-002 — Semantic zoom explorer** → lets the builder move from a selected symbol to pseudocode, callers/callees, module role, and concepts without losing context, solving the wrong-altitude failure of snippet explanations.
- **F-003 — Personal concept-gap map** → derives a short, ranked "learn these next" list from concepts present in the repository and the builder's demonstrated answers, solving generic curriculum mismatch while enforcing INV-002.
- **F-004 — Teach-back verification loop** → asks three repo-specific prediction/explanation questions, evaluates the builder's response against graph evidence, and updates the gap map, solving the core problem that reading an explanation does not prove comprehension.
- **F-005 — Demo-safe repository intake** → analyzes a bundled sample repository or a bounded public repository snapshot without modifying it, solving setup friction while enforcing INV-003.

**Final**
- **F-101 — Comprehension-delta ledger** → compares agent-generated code changes with the builder's demonstrated knowledge and identifies newly introduced unknown surfaces over time.
- **F-102 — In-workflow MCP App / extension surface** → brings the same interactive graph and teach-back loop into supported coding-agent hosts without becoming an IDE or granting write access.
- **F-103 — Cross-repository learner graph** → preserves a private, longitudinal model of concepts the builder has demonstrated across projects, separate from any single model vendor.
- **F-104 — Agent teaching contract** → exposes read-only MCP tools that let any coding agent ask which concepts need explanation before or after a change, while the deterministic graph remains the source of structural truth.

## 8. Success metrics

**Hackathon activation:** a first-time user selects a function, follows at least one evidence-backed edge, and completes one teach-back question in a single session.

**Comprehension signal:** after using convex, the user correctly explains one previously unknown call/dependency path without reading the generated explanation verbatim; measured by a graph-grounded teach-back rubric and a human spot-check during the demo cohort.

**Retention signal:** at least 5 of the first 20 users return to inspect a second code change or repository within 7 days; below this triggers the pre-registered retention kill criterion.

**Trust signal:** zero fabricated structural edges in the held-out demo set; target ≥70% precision for supported edge types, with unsupported or ambiguous edges omitted rather than guessed.

**Revenue:** no revenue target yet because payer_status is none-found. The next commercial signal is one institutional pilot conversation that advances beyond interest to a concrete evaluation or purchase process.

## 9. Constraints, risks & kill criteria

**Single riskiest assumption:** that student / hackathon builders will actually *use* a comprehension tool when the pressure at the moment of shipping is "just ship." The honest failure mode is not "we can't build it" — the honest failure mode is **"they don't open it, because reading is friction, and every prior tool that asked them to stop-and-read lost."**

**Kill criteria (pre-registered, falsifiable, written *before* we go build):**

- **Retention kill.** In a 20-user cohort (Manila team + Ateneo CS network), fewer than 5 users open the tool a second time within 7 days of first use → the problem is real but this framing isn't pull-worthy. Kill.
- **Interview-signal kill.** In 5 pre-build user conversations this week (student hackathon builders + bootcamp finishers), fewer than 3 volunteer "I've shipped code I can't explain" *without* being asked leading questions → the pain isn't top-of-mind. Kill, or narrow the segment.
- **Technical kill.** The structural-map component (call / data-flow edges from the user's actual repo) has < 70% precision on a held-out sample of student hackathon projects at demo time → the *non-commodity* half of the concept is unbuildable in the time window. Kill — because "commodity explainer alone" is explicitly a losing pitch (see §5).
- **Payer kill (for the venture question only, not the hackathon build).** Zero of three probed institutional payer candidates (bootcamp, hackathon org, hiring platform) express any purchase intent within 60 days of a working prototype → this stays a hackathon project, not a company.

**Invariants (`INV-###` — the hard rules that hold across every pivot):**

- **INV-001** — **never fabricate structural edges.** Every call, import, or data-flow edge shown to the user must be traceable to a concrete symbol reference in the actual code, produced by deterministic static analysis. LLM narrative sits *on top* of the graph; it never *invents* the graph. Reason: a comprehension tool that hallucinates connections doesn't just fail — it *teaches wrong mental models*, which is worse than not existing.
- **INV-002** — **the concept-gap list is derived from the user's real repo, never a generic top-N.** If we can't personalize from the actual code, we don't show a list. Reason: a generic "learn these next" is the wrapper failure mode; personalization is the entire non-commodity axis.
- **INV-003** — **read-only on the user's code.** Never modify, never commit, never PR. Reason: comprehension is a trust surface; the moment the tool touches the code it becomes a code-editing tool with a different (and much harder) contract.

## 10. Out of scope (for now)

- Not a code generator. If the user wants a code generator, they already have four.
- Not a debugger. Explaining a bug is downstream of understanding the code; not this brief.
- Not a code-review / PR-review product. That's a team surface with different buyers and workflows.
- Not a linter, style enforcer, or complexity metric.
- Not for large enterprise monorepos (first). Sizing above assumes student-scale repos; enterprise scale is a different technical + go-to-market problem.
- Not a team-collaboration surface. One user, their repo, their understanding. Team shared maps is CodeSee's dead territory — do not re-enter it in v1.
- Not an "AI tutor" chatbot. The unit is the map + gap-list, not a Q&A loop.
