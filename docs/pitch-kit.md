# Pitch Kit — convex

> **Use:** Manila live demo and Global Build Week submission. The Global voiceover target is 2:45 and must remain below 3:00 after final export.
> **Truth boundary:** Graph/MCP technology is not presented as novel. Payer, retention, broad language support, and production scale remain unvalidated. Unsupported implementation or event specifics are marked **[assumption]**.

## 1. Business narrative
convex is a comprehension control layer for student, hackathon, bootcamp, and self-taught builders who ship AI-written code faster than they can explain it. It reads a bounded repository snapshot, creates an evidence graph from deterministic source references, lets the builder trace a real path, asks them to explain that path back, and updates a separate learner-state graph from what the response demonstrated. We start narrow because teaching a false connection is worse than omitting one. Students are the users; there is no validated payer. Bootcamps, CS programs, hackathon organizers, and hiring platforms are payer hypotheses, not customers. The current proof is the working loop; the next test is whether builders return for a second change.

**One sentence:** Hover a function, trace the evidence-backed path around it, explain it back, and see what your response says to revisit next.

**Innovation line:** The graph is the evidence floor; proof-of-comprehension comes from joining a code-evidence graph with a separate learner-state graph through cited teach-back attempts.

## 2. Concise business model canvas
| Block | Current answer | Pitch beat |
|---|---|---|
| Value | See how your code connects, then test whether you can explain the path with every claim tied to evidence. | Demo |
| Users | Student, hackathon, bootcamp, and self-taught builders using coding agents. | Impact |
| Payer | None validated. Institutions and hiring/hackathon platforms are hypotheses only. | Honest model |
| Why this team | The team includes student builders in the target segment and can dogfood immediately; that is access, not market validation. | Team |
| Core work | Exact extraction, bounded GPT-5.6 reasoning, teach-back, transparent gap derivation, and reliable delivery. | Technology |
| Durable asset | Versioned evidence methods plus, only in future and with consent, longitudinal learner evidence. No such dataset exists today. | Wedge |
| Cost | Cloudflare/AWS EC2 hosting and GPT-5.6 calls; unit cost is unmeasured. | Feasibility |
| Channels | Manila room, Ateneo CS network, Global Build Week, student hackathon and bootcamp communities. | Reach |
| Ask | Twenty builders who will use it twice, plus one institution willing to define an evaluation—not just say it is interesting. | Close |

## 3. Global voiceover/demo script — target 2:45
Lead with the product. No title animation before the first interaction. The recording should show the premium dark-first interface directly: near-black canvas, off-white hierarchy, restrained coral focus, rounded outlined cards, and visible evidence actions.

| Time | On screen | Voiceover | Rubric it feeds |
|---|---|---|---|
| **0:00–0:18** | Cursor hovers a function; a small preview shows kind and `file:line`. Click to pin it. | “Start with one function an agent wrote. Hover to preview it; select it to pin the question: where does this fit?” | Design; Potential Impact |
| **0:18–0:45** | Zoom from function to its exact caller/callee path; relation labels appear. Open one evidence excerpt. | “Now zoom out. convex shows only connections found by deterministic analysis. This call opens to its exact source evidence. If the analyzer cannot establish a relationship, convex leaves it out.” | Technological Implementation; Design |
| **0:45–0:58** | Toggle `Text path`; ordered steps show symbol, relation, and location. | “The same path is available as ordered text, so the map remains understandable without color or a visual canvas.” | Design |
| **0:58–1:25** | Open teach-back; submit prepared natural-language answer; show Supported / Missing / Unsupported findings with citations. | “Then convex asks the builder to explain the path back. GPT-5.6 compares this response only with the bounded evidence packet and cites each finding. It critiques this answer, not the person.” | Quality of the Idea; Technological Implementation |
| **1:25–1:42** | Gap list visibly changes; expand “Why this changed.” | “That attempt changes the gap list. An item appears only when the repository contains the concept and the response provides learner evidence. No generic curriculum is passed off as personal.” | Quality of the Idea; Design |
| **1:42–2:05** | Split-screen diagram: code-evidence graph on left, learner-state graph on right; Cursor/Cody labels outside the product. | “This is not just Cursor or Cody. Those products can navigate, explain, and edit code. convex adds proof-of-comprehension: one graph records what the repository proves; a separate graph records only what this response demonstrated. The graph itself—and MCP—are not our novelty.” | Quality of the Idea |
| **2:05–2:25** | Two-repository architecture: Cloudflare Workers client → AWS EC2 directly → deterministic analyzer and GPT-5.6. | “The current build stays in two repositories: a Cloudflare Workers web client calling an AWS EC2 backend directly — FastAPI, deterministic analysis, minimal LangChain/LangGraph, and GPT-5.6 above the graph.” | Technological Implementation |
| **2:25–2:36** | Real Codex build artifact: session/commit/test clip. | “During the sprint, Codex helped us implement and test this path **[assumption—replace with the exact captured task and evidence before recording]**. We will submit the real main-thread `/feedback` Session ID.” | Technological Implementation |
| **2:36–2:45** | Return to changed gap list and student-builder use case. | “There is no validated payer yet. Next we test whether twenty builders use convex twice—and whether one institution defines a real evaluation. First, make the code explainable by its builder.” | Potential Impact |

### Recording and live-demo rules
- Dia drives and owns pacing; Abu voices the narrative. For Manila, keep the same first 1:42 and expand only if the organizer gives more time **[assumption]**.
- Use the known sample first. Keep `Pre-indexed sample` and `Read-only analysis` visible.
- English voiceover, captions, enlarged pointer, no accelerated speech. Resolution is 1080p **[assumption]**.
- Replace the Codex line with one verified task, artifact, and decision. If no artifact exists, do not record a generic “built with Codex” claim; the submission requirement is not met.
- If GPT-5.6 reasoning fails, continue with graph/source/text path and say the reasoning layer degraded safely. If backend fails, announce the sample fallback. If the client fails, identify the recording as fallback footage.

## 4. Rubric evidence map
| Criterion | Proof shown in the script |
|---|---|
| **Technological Implementation** | Working F-001–F-005 path; deterministic edge and source span; validated GPT-5.6 role; current two-repository architecture; one real Codex artifact required. |
| **Design** | Premium dark-first editorial hierarchy, immediate hover/select, preserved focus through zoom, clear states, keyboard-equivalent ordered text path, and gap change explained without color-only meaning. |
| **Potential Impact** | A concrete student/hackathon builder moment, reachable Manila/Ateneo cohort, honest repeat-use test, and no inflated payer claim. |
| **Quality of the Idea** | Proof-of-comprehension through two separated graphs and cited teach-back; no claim that code graphs, MCP, or code-aware explanation are new. |

## 5. The direct “not just Cursor/Cody” answer
**Say this first:** “Cursor and Cody help developers navigate, explain, and change code. convex asks whether the human can explain an evidence-backed path, then records what that response demonstrated in a separate learner-state graph.”

| Alternative | What it already does well | convex’s added proof | Claim we refuse |
|---|---|---|---|
| Cursor | Codebase-aware chat and agentic editing | Read-only path evidence → teach-back → changed gap list | That convex should replace an IDE/agent |
| Cody / Sourcegraph | Code search, navigation, and code-aware Q&A | A repo-specific check of the builder’s submitted explanation | That codebase-aware retrieval is unique |
| Code-graph/MCP systems | Symbols, imports/calls, paths, tool access | Separate learner evidence joined only through cited attempts | That graph or MCP infrastructure is novel |

**If pushed:** “A better explainer can produce better prose; it still does not prove the learner can reproduce the reasoning. convex separates repository truth from demonstrated learner evidence so one cannot overwrite the other.”

## 6. Technology truth in one answer
- Deterministic analysis creates supported symbols and exact import/call/containment edges with source spans.
- GPT-5.6 receives bounded evidence packets and returns typed narrative, three questions, and response findings with citations. Validators reject unknown citations. It cannot write graph records.
- The code-evidence graph and learner-state graph are separate. A gap item is a derived join requiring evidence from both.
- The repository is read-only. No source execution, write credential, commit, branch, or pull-request path exists.
- The current architecture remains a Cloudflare Workers client calling an AWS EC2 backend (FastAPI/LangChain/LangGraph) directly over HTTPS, no BFF/proxy. Future MCP/extension work is F-102, not the current build.
