# PRD — convex

> **Purpose:** Define the product the team must build for the first dependency phase. This document translates `idea.md`, `context.md`, and `brand.md` into testable product requirements.

## Overview & goals
convex is a comprehension control layer for code. It helps a builder see how code in a repository fits together and prove they understand it. The product wedge is proof-of-comprehension: deterministic structural evidence, a learner-state/concept-gap map, and repo-specific teach-back. It is not a generic explainer, chatbot, code generator, or IDE.

The MVP must produce one demoable loop: inspect a bounded read-only repository, trace an evidence-backed connection, answer a repo-specific teach-back question, and see the learner-state/gap map update. Structural truth comes from deterministic analysis; model-generated narrative may explain that truth but may not create it.

## Product outcomes
- Give builders an evidence-backed mental model of their own repository.
- Make comprehension observable through teach-back rather than inferred from content consumption.
- Rank learning gaps from repository evidence and demonstrated answers, not generic curriculum.
- Preserve trust through read-only access, visible source locations, explicit uncertainty, and a calm premium interface that keeps evidence visually primary.
- Ship a clear judged demo within the four-day build window and remain accessible through Global judging.

## Personas & use cases
- **Primary — student or hackathon builder:** has shipped AI-assisted code and needs to explain how a function connects to the rest of the project before a demo, judging Q&A, or interview.
- **Secondary — career-switcher or bootcamp finisher:** needs to walk through a portfolio repository and identify concepts they cannot yet explain.
- **Demo operator [assumption]:** uses a bundled sample or bounded public repository snapshot to show the proof-of-comprehension loop reliably.

## User stories
### Student or hackathon builder
- As a builder, I want to select a symbol and trace its evidence-backed callers, callees, imports, and module role so that I can explain how it fits into my project.
- As a builder, I want explanations at multiple levels of abstraction so that I can move from code to pseudocode to system role without losing context.
- As a builder, I want a ranked map of concepts evidenced in my repository and gaps evidenced by my answers so that I know what to learn next.
- As a builder, I want repo-specific teach-back prompts and evidence-grounded feedback so that I can prove comprehension rather than merely read an explanation.
- As a builder, I want analysis to remain read-only so that learning cannot change or damage my code.
- As a builder, I want to start with a public GitHub repository link or connect a local MCP host for private/local repositories, so that repository access matches the sensitivity of my code.

### Career-switcher or bootcamp finisher
- As a portfolio owner, I want to rehearse repository walkthrough questions so that I can discover weak explanations before an interview.
- As a portfolio owner, I want every structural claim linked to a source location so that I can verify the product's feedback.

## User journeys
- **UJ-000 — Connect a repository:** A builder chooses the primary public-repository path by entering a valid GitHub URL, or chooses the secondary MCP path for private/local repositories. The MCP path is handled by the local MCP host; the frontend never performs GitHub OAuth or stores GitHub access tokens.
- **UJ-001 — Trace a real connection:** A builder opens a connected repository snapshot, selects a symbol, inspects its source reference, and follows at least one deterministic edge to understand a cross-file path.
- **UJ-002 — Change explanatory altitude:** From the selected symbol, the builder moves among source, pseudocode, callers/callees, module role, and associated concepts while retaining the selected context.
- **UJ-003 — Prove comprehension:** After tracing a path, the builder answers a repo-specific prediction or explanation question; the system evaluates the response against graph evidence and reports what was supported, missing, or unsupported.
- **UJ-004 — Inspect the learner-state/gap map:** The builder views a short ranked list of concepts derived from repository evidence and demonstrated teach-back performance, then chooses the next concept to revisit.
- **UJ-005 — Complete the judge demo:** A demo operator [assumption] loads a known-safe sample, traces one evidence-backed path, completes one teach-back, and shows the resulting gap-map update without any repository mutation.

## Feature list and release separation
### MVP — required for the first working proof-of-comprehension loop
| F-ID | Feature | Priority | Solves (problem) | Notes |
|---|---|---|---|---|
| F-001 | Evidence-backed repository graph | MVP | Builders cannot see how agent-written code connects across files. | Deterministic symbols, imports, calls, module relationships, and source references; enforces INV-001. |
| F-002 | Semantic zoom explorer | MVP | Snippet explanations operate at the wrong altitude. | Keeps selected context across source, pseudocode, graph neighborhood, module role, and concepts. |
| F-003 | Personal concept-gap map | MVP | Generic curricula do not reflect the learner's repository or demonstrated gaps. | Ranked from real repository concepts and learner answers; enforces INV-002. |
| F-004 | Teach-back verification loop | MVP | Reading an explanation does not prove comprehension. | Three repo-specific prediction/explanation questions, graph-grounded evaluation, and gap-map update. |
| F-005 | Demo-safe repository intake | MVP | Setup friction threatens activation and the judged demo. | Bundled sample or bounded public repository snapshot; read-only; enforces INV-003. |

### Final — explicitly outside MVP unless the MVP loop is complete
| F-ID | Feature | Priority | Solves (problem) | Notes |
|---|---|---|---|---|
| F-101 | Comprehension-delta ledger | Final | New AI-assisted changes can add unknown surfaces over time. | Compares code changes with demonstrated knowledge. |
| F-102 | MCP repository connection and in-workflow surface | Final | Private/local repository access and separate surfaces add workflow friction. | Uses a local MCP host for private/local repository discovery and later brings the same read-only map and teach-back loop into supported hosts without becoming an IDE. |
| F-103 | Cross-repository learner graph | Final | A single-repository learner model loses longitudinal progress. | Private learner state across projects, independent of a single model vendor. |
| F-104 | Agent teaching contract | Final | Coding agents lack a standard way to query which concepts need explanation. | Read-only MCP tools; deterministic graph remains structural truth. |

## Business rules
- **BR-001 — Evidence provenance:** Every displayed structural edge SHALL expose a concrete source reference to the analyzed repository snapshot.
- **BR-002 — Evidence boundary:** Model-generated prose MAY explain deterministic evidence but SHALL NOT create or promote a structural edge.
- **BR-003 — Unsupported relationships:** When deterministic analysis cannot support a relationship, the product SHALL say "not enough evidence" and omit the edge.
- **BR-004 — Gap-map eligibility:** A concept SHALL appear in the gap map only when linked to evidence in the analyzed repository and learner-state evidence from demonstrated answers; initial learner state before an answer is unknown [assumption].
- **BR-005 — Teach-back feedback:** Feedback SHALL critique the explanation and cite supporting evidence; it SHALL NOT claim that a learner "fully understands" or has "mastered" a concept.
- **BR-006 — Intake boundary:** Repository intake SHALL accept only a bundled sample or a bounded public repository snapshot in MVP; exact size, language, and timeout limits are [assumption] until technical design.
- **BR-007 — Read-only operation:** Analysis SHALL NOT modify files, commits, branches, pull requests, or repository settings.
- **BR-008 — Accessibility:** The user-facing graph SHALL support keyboard traversal, visible focus, non-color status indicators, reduced motion, text alternatives for graph paths, and AA contrast for documented semantic token pairs, targeting WCAG 2.2 AA.
- **BR-009 — MVP gate:** Final features F-101 through F-104 SHALL NOT displace completion of the F-001 through F-005 end-to-end demo loop.
- **BR-010 — Architecture baseline:** Current implementation SHALL use two repositories: a Cloudflare Workers-hosted client and a Hugging Face Docker Space backend using FastAPI, LangChain, and LangGraph. Any replacement is a future decision, not current architecture.
- **BR-011 — Hybrid repository connection:** The final-product onboarding SHALL present public repository links and MCP-connected private/local repositories as distinct paths. Public GitHub repositories MAY be entered as `https://github.com/{owner}/{repo}`; private and local repositories SHALL be selected through MCP rather than pasted manually.
- **BR-012 — MCP credential boundary:** The frontend SHALL NOT perform GitHub OAuth, store GitHub access tokens, or communicate directly with GitHub for private repository discovery. MCP authentication and repository listing are owned by the local MCP host. Current client MCP connection is a placeholder shell until the backend/MCP contract is implemented.

## Hard rules / must-never (invariant spine)
- **INV-001** — **never fabricate structural edges.** The system SHALL NEVER show a call, import, or data-flow edge that is not traceable to a concrete symbol reference in the actual code and produced by deterministic static analysis. IF a model proposes an unsupported structural relationship, THEN the system SHALL omit it and report "not enough evidence." LLM narrative sits on top of the graph; it never invents the graph.
- **INV-002** — **the concept-gap list is derived from the user's real repo, never a generic top-N.** The system SHALL NEVER show a concept-gap item that is not personalized from the actual repository and learner-state evidence. IF the system cannot personalize from the actual code, THEN the system SHALL not show the item.
- **INV-003** — **read-only on the user's code.** The system SHALL NEVER modify, commit, or open a pull request against the user's code. IF an operation would write to the repository, THEN the system SHALL block or refuse it.

## User flows
### UF-000 — Hybrid repository onboarding
1. The builder opens the landing page and clicks **Add Repository Link**.
2. The product opens the repository connection modal, not an inline form embedded in the page.
3. For a public repository, the builder enters a GitHub URL in the form `https://github.com/{owner}/{repo}`.
4. The Continue/Add Repository action stays disabled until the URL is non-empty, syntactically valid, and matches the GitHub owner/repository format.
5. On valid public submission, the selected repository is stored in centralized client state and the builder lands on `/dashboard`.
6. If the builder needs private or local repository access, they choose **Connect with MCP**. The public URL form disappears before the MCP connection dialog opens.
7. The MCP dialog shows Waiting, Connecting, Connected, or Failed states. In the current client build this is a backend-ready placeholder; final behavior is local MCP host connection, GitHub authentication inside MCP, repository selection, and dashboard navigation.
8. Once a repository is selected, public and MCP sources use the same dashboard layout: repository status, sidebar sections, and placeholder workspace panels until analysis data is wired.

### UF-001 — Repository to evidence-backed path
1. The builder chooses a connected repository source. MVP analysis accepts a bundled sample or supported bounded public repository snapshot; final-product onboarding also includes MCP-selected private/local repositories once the MCP backend exists.
2. The client requests analysis from the backend without requesting repository write permission.
3. The backend deterministically extracts supported symbols and relationships with source locations.
4. The builder selects a symbol and sees its source, supported callers/callees/imports, and module context.
5. The builder follows an edge and can inspect the concrete source references at both ends.
6. If evidence is absent or ambiguous, the system omits the relationship and says "not enough evidence."

### UF-002 — Evidence to teach-back
1. The builder starts teach-back from the selected symbol or traced path.
2. The system asks a repo-specific prediction or explanation question grounded in available evidence.
3. The builder submits an explanation.
4. The system compares the explanation with deterministic graph evidence and returns evidence-cited feedback.
5. The system identifies supported, missing, and unsupported parts without judging the learner.
6. The learner-state/gap map updates from the demonstrated answer.

### UF-003 — Gap to next learning action
1. The builder opens the concept-gap map.
2. The system shows only concepts tied to repository evidence and demonstrated answers.
3. The builder selects a ranked gap and returns to the relevant symbols and paths.
4. The builder may attempt another teach-back to produce new learner-state evidence.

### UF-004 — Demo-safe run
1. The demo operator [assumption] opens the deployed Cloudflare Workers client (`https://convex.varietase.workers.dev`).
2. The operator loads the known sample through the Hugging Face Docker Space backend.
3. The operator completes UF-001 and UF-002.
4. The operator shows an updated gap map and evidence citation.
5. The operator confirms no source mutation is requested or performed.

## Acceptance criteria
### MVP acceptance criteria
- **F-001 / AC-001:** WHEN analysis completes for a supported repository snapshot, the system SHALL display supported symbols and structural edges with concrete source locations.
- **F-001 / AC-002:** WHEN a user opens an edge, the system SHALL expose the source evidence used to establish both endpoints and the relationship.
- **F-001 / AC-003:** IF deterministic analysis does not establish a proposed relationship, THEN the system SHALL omit that relationship and report "not enough evidence."
- **F-002 / AC-004:** WHEN a user selects a symbol, the system SHALL provide source, pseudocode, callers/callees, module role, and repository-derived concept views where evidence exists.
- **F-002 / AC-005:** WHEN a user changes semantic-zoom level, the system SHALL preserve the selected symbol or path context.
- **F-002 / AC-006:** WHILE a graph path is displayed, the system SHALL provide keyboard traversal and a text alternative for that path.
- **F-003 / AC-007:** WHEN the system displays a concept-gap item, it SHALL cite repository evidence and learner-answer evidence that caused the ranking.
- **F-003 / AC-008:** WHEN a teach-back result changes the learner state, the system SHALL update the affected gap-map ranking or explicitly show that no ranking changed.
- **F-003 / AC-009:** IF repository and learner-state evidence are insufficient for a concept, THEN the system SHALL not present that concept as a personalized gap.
- **F-004 / AC-010:** WHEN a user starts teach-back, the system SHALL present three prediction or explanation questions tied to the analyzed repository evidence.
- **F-004 / AC-011:** WHEN a user submits a teach-back response, the system SHALL return feedback distinguishing supported, missing, and unsupported claims with source citations.
- **F-004 / AC-012:** WHEN feedback is shown, the system SHALL critique the explanation and SHALL NOT claim that the learner is fully understood, mastered, or guaranteed to know a concept.
- **F-005 / AC-013:** WHEN a user selects the bundled sample or submits a supported bounded public repository snapshot, the system SHALL analyze it without requesting write access.
- **F-005 / AC-014:** IF intake exceeds an implemented bound or uses an unsupported format, THEN the system SHALL refuse analysis with a clear, non-destructive explanation; exact bounds are [assumption] pending technical design.
- **F-005 / AC-015:** WHILE repository analysis and exploration occur, the system SHALL NOT modify repository contents, commits, branches, pull requests, or settings.
- **F-005 / AC-016:** WHEN the user clicks **Add Repository Link** from the landing page or nav, the same repository connection modal SHALL open; the full form SHALL NOT remain inline in the landing page content.
- **F-005 / AC-017:** WHEN the user clicks **Connect with MCP** from the repository-link modal, the public URL form SHALL close before the MCP connection UI appears.

### Final acceptance criteria — not MVP build commitments
- **F-101 / AC-101:** WHERE the comprehension-delta ledger is included, WHEN a supported code change introduces new repository concepts or structural surfaces, the system SHALL compare them with demonstrated learner state and identify newly unknown surfaces with evidence.
- **F-102 / AC-102:** WHERE the MCP repository connection or in-workflow MCP surface is included, WHEN a supported MCP host exposes repositories, the system SHALL list selectable repositories and expose the same evidence-backed graph and teach-back loop without editing code or becoming an editor.
- **F-102 / AC-105:** WHERE private/local repository access is included, WHEN GitHub authentication is required, the frontend SHALL delegate authentication to the local MCP host and SHALL NOT store provider access tokens.
- **F-103 / AC-103:** WHERE the cross-repository learner graph is included, WHEN a learner authorizes a supported project, the system SHALL keep repository evidence distinct while updating a private longitudinal learner model; authorization and privacy specifics are [assumption].
- **F-104 / AC-104:** WHERE the agent teaching contract is included, WHEN an authorized coding agent asks which concepts need explanation, the system SHALL return only read-only learner-gap and deterministic repository evidence through supported tools.

### Invariant acceptance criteria
- **INV-001 / AC-INV-001:** The system SHALL NEVER render a structural edge created solely by model inference.
- **INV-002 / AC-INV-002:** The system SHALL NEVER render a generic top-N concept list as a personal concept-gap map.
- **INV-003 / AC-INV-003:** The system SHALL NEVER write to, commit to, or open a pull request against an analyzed repository.

## Non-goals
- Code generation, autonomous code changes, or repository write operations.
- A generic snippet explainer, general-purpose chatbot, or AI tutor chat surface.
- An IDE, editor, debugger, linter, style enforcer, complexity dashboard, or PR-review product.
- Team collaboration, enterprise monorepo support, or shared maps in MVP.
- Private repository analysis through the backend, broad language coverage, or production-scale multi-tenancy in MVP [assumption]. The current MCP UI is a placeholder shell, not private-repository analysis support.
- F-101, F-102, F-103, and F-104 in the MVP build.

## Dependencies
### Current implementation baseline
- **Repository 1 — client:** Cloudflare Workers-hosted web client (OpenNext) implemented with Next.js App Router and TypeScript. The current client includes a final-product repository connection shell: public GitHub URL validation, MCP placeholder connection/selector, centralized repository state, and `/dashboard`.
- **Repository 2 — backend:** Hugging Face Docker Space running the lockfile-pinned FastAPI, Tree-sitter, LangChain/OpenAI, and LangGraph stack in `model`; Docker port 7860, contract `1.0.0`, `gpt-5.6`, and ephemeral behavior are locked. The deployed Space identifier and measured runtime behavior remain [assumption].
- The browser SHALL call the five-route `/v1` backend contract directly; only `GET /health` is active in the first scaffold slice, and feature routes activate with their owning gates.
- The deployment must remain available through Global judging.

### Product and delivery dependencies
- Tree-sitter 0.26 with pinned JavaScript and TypeScript grammars for JS/JSX/TS/TSX symbols, imports, calls, and module relationships; supported-edge precision/coverage still requires fixture validation.
- Bundled sample `xray-demo-v1`, currently a minimal named-relative-import/call fixture; the final judge-facing sample and central path remain to be selected [assumption].
- Meaningful use of Codex and GPT-5.6, with exact product and build responsibilities still [assumption].
- Public or judge-accessible deployment, a sub-three-minute English voiceover demo, a repository/README describing Codex collaboration, and the main Codex `/feedback` Session ID.
- Accessibility and visual-system implementation for the documented dark-first tokens, keyboard graph traversal, visible focus, non-color states, reduced motion, AA contrast checks, and graph-path text alternatives.

### Alternatives — not current architecture
- A single repository, local desktop app, IDE-native implementation, other client host, other backend host, or replacement backend framework is not current architecture.
- Such alternatives remain provisional until evidence forces a logged platform decision; generic-explainer and IDE directions are rejected product directions.

## Success measures
- **Activation:** A first-time user selects a function, follows at least one evidence-backed edge, and completes one teach-back question in one session.
- **Comprehension signal:** The user correctly explains one previously unknown call or dependency path without reading generated prose verbatim, evaluated by a graph-grounded rubric and human spot-check in the demo cohort.
- **Trust:** Zero fabricated structural edges in the held-out demo set; target at least 70% precision for supported edge types, omitting unsupported or ambiguous edges.
- **Retention signal:** At least 5 of the first 20 users inspect a second code change or repository within 7 days; this is post-demo validation, not an MVP acceptance gate.
- **Commercial signal:** One institutional conversation reaches a concrete evaluation or purchase process; no revenue target exists because no payer is validated.

## Open questions
- Can the pinned JS/JSX/TS/TSX Tree-sitter lane meet the trust target on the held-out demo set?
- What repository size, file-count, and analysis-time bounds define "bounded" intake?
- What exact learner-state representation and rubric update gap rankings without overstating comprehension?
- Which parts of analysis, narration, and teach-back use Codex versus GPT-5.6?
- What API contract connects the Cloudflare Workers client to the Hugging Face Docker Space?
- What exact MCP host contract will replace the placeholder client adapter for private/local repository discovery?
- What persistence, authentication, rate limits, and operational monitoring are required for judged availability [assumption]?
- Which sample path creates the clearest sub-three-minute proof-of-comprehension demo?
