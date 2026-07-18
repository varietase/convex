# convex — Revised Five-Hour Implementation Plan

## Applicability verdict

**Yes—F-001 through F-005 belong in the MVP.** They make the idea substantially stronger because the product is no longer merely:

> Repository graph + personalized recommendations

It becomes:

> **Repository evidence → teach-back → demonstrated comprehension gaps**

That is a much more defensible product loop.

The business rules, invariants, user flows, acceptance criteria, non-goals, and two-repository architecture should replace the looser assumptions in the original master plan. 

| Feature                                    | Applicability                      | Required change to the original plan                                                                                                                                                       |
| ------------------------------------------ | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **F-001 Evidence-backed repository graph** | Fully applicable                   | Every edge must include source provenance. Remove uncertain or model-inferred graph edges entirely.                                                                                        |
| **F-002 Semantic zoom explorer**           | Fully applicable                   | Preserve the selected symbol/path across source, pseudocode, neighborhood, module, and concept views. Add accessible text paths.                                                           |
| **F-003 Personal concept-gap map**         | Applicable with a major correction | Repository occurrence alone cannot establish a personal gap. Before teach-back, show **concepts observed in this repository**. Only create gap items after learner-answer evidence exists. |
| **F-004 Teach-back verification loop**     | Essential and previously missing   | This becomes the proof-of-comprehension mechanism and must precede the personalized gap map.                                                                                               |
| **F-005 Demo-safe repository intake**      | Fully applicable                   | Bundle a guaranteed sample and support a tightly bounded public GitHub snapshot without requesting write access.                                                                           |
| **F-101–F-104**                            | Applicable after MVP               | Preserve stable APIs and identifiers now, but do not implement these features during the five-hour build.                                                                                  |

## Important corrections to the previous plan

The earlier plan needs six concrete changes.

1. **The original “Learn Next” list was too early.**
   Repository frequency shows relevance, not lack of understanding. The initial state must be “unknown,” not “gap.”

2. **Teach-back is now part of the central demo, not a later enhancement.**
   The gap map depends on evidence produced by F-004.

3. **The single Next.js application architecture is no longer valid.**
   Use the mandated Vercel client and Hugging Face Docker Space backend.

4. **Every structural edge needs three provenance points:**
   the source definition, the relationship site, and the target definition.

5. **Remove “data-flow map” from the MVP claim.**
   Show deterministic call, import, and module relationships. Arguments may be displayed as call-site annotations, but not promoted into whole-program data-flow edges.

6. **Accessibility is a release requirement, not polish.**
   Keyboard traversal, visible focus, non-color indicators, reduced motion, and graph text alternatives must be implemented alongside the graph.

---

# 1. Revised product loop

The canonical MVP experience should be:

```text
Load repository snapshot
        ↓
Build deterministic evidence graph
        ↓
Select a symbol
        ↓
Zoom from source → neighborhood → module context
        ↓
Inspect the source evidence behind an edge
        ↓
Answer three repository-specific teach-back questions
        ↓
Receive Supported / Missing / Not supported feedback
        ↓
Update the personal concept-gap map
        ↓
Select a gap and return to the relevant code path
```

## Revised demo beat

Replace the original:

> Hover function → map lights up → receive three learning topics

With:

> **Select function → inspect an evidence-backed path → answer three questions → watch the personalized gap map update → jump from a gap back to the responsible code.**

That extra verification step is the product’s strongest differentiator.

---

# 2. Locked five-hour MVP scope

## Included

| Area          | Five-hour implementation                                                                          |
| ------------- | ------------------------------------------------------------------------------------------------- |
| Languages     | JavaScript, JSX, TypeScript, and TSX                                                              |
| Intake        | Bundled sample plus bounded public GitHub snapshot                                                |
| Symbols       | Named functions, named arrow functions, exported functions, route handlers, and supported methods |
| Relationships | Direct relative imports, same-file calls, resolvable imported calls, and module imports           |
| Evidence      | File, line/column range, source excerpt, snapshot SHA, and analyzer version                       |
| Semantic zoom | Inside, Around, Across                                                                            |
| Explanation   | Evidence-linked role and pseudocode                                                               |
| Teach-back    | Exactly three questions per attempt                                                               |
| Feedback      | Supported, missing, and unsupported claims                                                        |
| Learner state | Current browser session only                                                                      |
| Gap map       | Only concepts supported by repository and learner-answer evidence                                 |
| Deployment    | Vercel client plus Hugging Face Docker Space backend                                              |
| Operation     | Entirely read-only                                                                                |

## Explicitly excluded

* Data-flow edges
* Runtime tracing
* Dynamic dispatch resolution
* Private repositories
* Repository authentication
* Persistent learner accounts
* Databases
* Cross-repository profiles
* MCP or IDE surfaces
* Code generation
* Pull requests or repository changes
* Generic tutor chat
* Generic top-N concept recommendations
* Full TypeScript compiler-level symbol resolution
* More than one language family

## Proposed intake bounds

These convert the current assumptions into concrete implementation decisions:

| Limit                                 |                                           MVP value |
| ------------------------------------- | --------------------------------------------------: |
| Supported source files                |                                          40 maximum |
| Total supported source size           |                                              750 KB |
| Maximum individual source file        |                                               60 KB |
| Maximum downloaded compressed archive |                                                5 MB |
| Maximum extracted archive             |                                               20 MB |
| Intake and analysis timeout           |                                          20 seconds |
| Supported extensions                  |                        `.js`, `.jsx`, `.ts`, `.tsx` |
| Snapshot source                       | Default branch or supplied public branch/tag/commit |
| Repository permissions                |                        None requested from the user |

Reject the repository rather than silently analyzing a truncated subset. Silent truncation could produce a misleading graph.

---

# 3. Implementation architecture

```text
┌──────────────────────────────────────────────────────────┐
│ Vercel Client                                            │
│ Next.js + TypeScript + React Flow                        │
│                                                          │
│ Intake                                                   │
│ Source viewer                                            │
│ Semantic zoom graph                                      │
│ Edge evidence drawer                                     │
│ Teach-back form                                          │
│ Session-local learner state                              │
│ Concept-gap map                                          │
└──────────────────────────┬───────────────────────────────┘
                           │ HTTPS JSON API
                           ▼
┌──────────────────────────────────────────────────────────┐
│ Hugging Face Docker Space                                │
│ FastAPI + LangChain + LangGraph                          │
│                                                          │
│  ┌──────────────── Deterministic lane ─────────────────┐ │
│  │ Snapshot intake                                     │ │
│  │ Tree-sitter parsing                                 │ │
│  │ Symbol table                                        │ │
│  │ Import/call resolution                              │ │
│  │ Evidence provenance                                 │ │
│  │ Concept occurrence detection                        │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌────────────────── Model-assisted lane ──────────────┐ │
│  │ Evidence-linked pseudocode                          │ │
│  │ Question phrasing                                   │ │
│  │ Natural-language answer assessment                  │ │
│  │ Evidence-cited feedback wording                     │ │
│  └─────────────────────────────────────────────────────┘ │
│                                                          │
│       Model-assisted lane cannot mutate graph data       │
└──────────────────────────────────────────────────────────┘
```

Hugging Face Docker Spaces support custom Docker applications such as FastAPI, with the exposed application port configured through the Space metadata; the standard Docker Space port is `7860`. Runtime secrets can be supplied through Space settings rather than exposed to the browser. ([Hugging Face][1])

Use Tree-sitter’s Python bindings with pinned JavaScript and TypeScript grammars for deterministic syntax extraction. Tree-sitter provides official bindings across languages, including Python, and produces syntax trees without requiring an LLM. ([Tree-sitter][2])

Use LangGraph only for the teach-back and explanation workflows. Its `StateGraph` model is suitable for a controlled sequence of state transformations; it should not sit between the parser and structural graph. ([Docs by LangChain][3])

Use GPT-5.6 for evidence-constrained explanation and answer assessment, returning schema-constrained output. OpenAI currently exposes GPT-5.6 through the API, and Structured Outputs support developer-supplied schemas; schema adherence does not make the semantic content automatically correct, so evidence-ID validation remains necessary. ([OpenAI Developers][4])

## Non-negotiable architecture rule

```text
Static analyzer → structural graph
LLM → prose over structural graph
```

There must be no reverse path from the LLM into the graph.

---

# 4. Repository structure

## Repository 1 — `xray-client`

```text
xray-client/
├── app/
│   ├── page.tsx
│   ├── layout.tsx
│   └── globals.css
├── components/
│   ├── intake/
│   │   ├── RepositoryIntake.tsx
│   │   └── IntakeStatus.tsx
│   ├── explorer/
│   │   ├── Workspace.tsx
│   │   ├── SourcePane.tsx
│   │   ├── PseudocodePane.tsx
│   │   ├── EvidenceGraph.tsx
│   │   ├── SymbolNode.tsx
│   │   ├── EdgeEvidenceDrawer.tsx
│   │   ├── SemanticZoomControls.tsx
│   │   └── GraphTextAlternative.tsx
│   ├── teachback/
│   │   ├── TeachBackPanel.tsx
│   │   ├── QuestionCard.tsx
│   │   └── FeedbackPanel.tsx
│   └── gaps/
│       ├── RepositoryConcepts.tsx
│       ├── ConceptGapMap.tsx
│       └── GapCard.tsx
├── lib/
│   ├── api.ts
│   ├── reducer.ts
│   ├── graph-layout.ts
│   └── evidence-links.ts
├── contracts/
│   └── api.ts
└── data/
    └── emergency-demo-fallback.json
```

Use one `useReducer`-based application store. A new global state framework is unnecessary for this scope.

Recommended state:

```ts
type AppState = {
  analysis: AnalysisBundle | null;
  selectedSymbolId: string | null;
  selectedEdgeId: string | null;
  selectedPath: string[];
  zoomLevel: "inside" | "around" | "across";
  questions: TeachBackQuestion[];
  answers: Record<string, string>;
  learnerEvidence: LearnerEvidence[];
  conceptGaps: ConceptGap[];
};
```

## Repository 2 — `xray-backend`

```text
xray-backend/
├── app/
│   ├── main.py
│   ├── api/
│   │   ├── analysis.py
│   │   ├── xray.py
│   │   └── teachback.py
│   ├── domain/
│   │   ├── models.py
│   │   ├── errors.py
│   │   └── ids.py
│   ├── intake/
│   │   ├── sample.py
│   │   ├── github_snapshot.py
│   │   ├── limits.py
│   │   └── safe_extract.py
│   ├── analysis/
│   │   ├── parser.py
│   │   ├── symbols.py
│   │   ├── imports.py
│   │   ├── calls.py
│   │   ├── modules.py
│   │   ├── concepts.py
│   │   └── provenance.py
│   ├── teaching/
│   │   ├── question_specs.py
│   │   ├── question_graph.py
│   │   ├── evaluation_graph.py
│   │   ├── gap_ranking.py
│   │   └── prompts.py
│   └── fixtures/
│       ├── demo_repo/
│       ├── demo_manifest.json
│       └── demo_analysis.json
├── tests/
│   ├── test_edges.py
│   ├── test_invariants.py
│   ├── test_intake.py
│   ├── test_teachback.py
│   └── test_gap_map.py
├── requirements.txt
├── Dockerfile
└── README.md
```

The backend should allow only the deployed Vercel origin and local development origins through FastAPI CORS configuration—not a wildcard. FastAPI provides `CORSMiddleware` for this cross-origin client/backend arrangement. ([FastAPI][5])

---

# 5. API contract

Use synchronous endpoints for the hackathon. Avoid queues, polling, and background jobs.

## Endpoints

| Method and path                 | Responsibility                                                        |
| ------------------------------- | --------------------------------------------------------------------- |
| `GET /health`                   | Deployment and model/parser readiness                                 |
| `POST /v1/analyses`             | Load a sample or public snapshot and return deterministic analysis    |
| `POST /v1/xray`                 | Generate evidence-linked pseudocode and module explanation            |
| `POST /v1/teachbacks/questions` | Return three questions tied to selected evidence                      |
| `POST /v1/teachbacks/evaluate`  | Evaluate answers and return learner-state changes plus gap-map update |

There are intentionally no repository mutation endpoints.

## Analysis request

```json
{
  "source": {
    "type": "sample",
    "sample_id": "xray-demo-v1"
  }
}
```

Or:

```json
{
  "source": {
    "type": "github_public",
    "owner": "example",
    "repo": "project",
    "ref": "main"
  }
}
```

The backend must resolve the supplied ref to a concrete commit SHA and analyze that immutable snapshot.

GitHub’s public repository APIs can be read without user-granted repository write access. Git tree data can be retrieved for public resources without authentication, though unauthenticated REST access is rate-limited, making the bundled sample and caching especially important for the judged demo. ([GitHub Docs][6])

## Error contract

```ts
type ApiError = {
  code:
    | "UNSUPPORTED_SOURCE"
    | "LIMIT_EXCEEDED"
    | "ANALYSIS_TIMEOUT"
    | "REPOSITORY_NOT_FOUND"
    | "NOT_ENOUGH_EVIDENCE"
    | "MODEL_UNAVAILABLE";
  message: string;
  limits?: Record<string, number>;
};
```

Examples:

* “This snapshot contains 63 supported source files; the MVP limit is 40.”
* “No JavaScript or TypeScript source files were found.”
* “The call target is dynamically computed; not enough evidence to establish an edge.”
* “Explanation is temporarily unavailable. Structural evidence remains available.”

---

# 6. Core evidence data model

## Evidence references

```ts
type EvidenceRef = {
  id: string;
  snapshotId: string;
  commitSha: string;
  filePath: string;
  startLine: number;
  startColumn: number;
  endLine: number;
  endColumn: number;
  snippet: string;
  fileHash: string;
};
```

## Symbols

```ts
type SymbolRecord = {
  id: string;
  name: string;
  kind:
    | "function"
    | "component"
    | "method"
    | "route-handler"
    | "module";
  moduleId: string;
  exported: boolean;
  definitionRef: EvidenceRef;
  conceptOccurrenceIds: string[];
};
```

## Structural edges

Every rendered edge needs three evidence anchors.

```ts
type StructuralEdge = {
  id: string;
  kind: "calls" | "imports" | "module-import";
  sourceId: string;
  targetId: string;

  evidence: {
    sourceDefinitionRef: EvidenceRef;
    relationshipRef: EvidenceRef;
    targetDefinitionRef: EvidenceRef;
  };

  resolutionMethod:
    | "same-file-identifier"
    | "named-relative-import"
    | "namespace-relative-import"
    | "relative-module-import";

  callArguments?: string[];
};
```

Do not include a `confidence: "medium"` option. A relationship is either deterministically established or omitted.

## Unresolved references

```ts
type UnresolvedReference = {
  name: string;
  sourceRef: EvidenceRef;
  reason:
    | "dynamic-call"
    | "ambiguous-symbol"
    | "external-module"
    | "unsupported-syntax";
  message: "not enough evidence";
};
```

An unresolved reference may appear in a diagnostic list, but never as a dotted, faded, or speculative graph edge.

## Stable identifiers

Generate IDs from immutable evidence:

```text
snapshot_id =
  hash(repository + commit_sha + analyzer_version)

symbol_id =
  hash(snapshot_id + file_path + kind + name + start_position)

edge_id =
  hash(kind + source_symbol_id + target_symbol_id + relationship_position)
```

These stable IDs cost little now and prepare the architecture for F-101 later without implementing the ledger.

---

# 7. Feature implementation order

The feature IDs describe release priority, but they are not the optimal build order.

The implementation dependency order should be:

```text
F-005 intake
   ↓
F-001 graph and provenance
   ↓
F-002 semantic zoom
   ↓
F-004 teach-back
   ↓
F-003 personal gap map
```

F-003 must follow F-004 because a personal gap cannot exist without learner-answer evidence.

---

## F-005 — Demo-safe repository intake

### Implementation

For the bundled sample:

* Store sample source files in the backend.
* Analyze them using the same deterministic analyzer used for public repositories.
* Commit a precomputed analysis JSON as a fallback.
* Include a manifest containing file hashes and analyzer version.
* Return the pinned sample snapshot ID.

For public repositories:

1. Validate the URL or owner/repository fields.
2. Accept only public GitHub repositories.
3. Resolve the requested ref to a commit SHA.
4. Download a read-only archive or retrieve its public tree.
5. Stream with a compressed-size cap.
6. Extract into a temporary directory using path-traversal-safe extraction.
7. Reject symlinks and archive entries outside the temporary root.
8. Apply source-file and byte limits.
9. Analyze the snapshot.
10. Delete the temporary directory.

### Read-only proof

The GitHub adapter should expose only methods such as:

```py
get_repository()
resolve_ref()
download_snapshot()
```

It should not contain methods named:

```text
commit
push
create_branch
create_pull_request
update_file
delete_file
```

---

## F-001 — Evidence-backed repository graph

### Supported deterministic resolution

Implement only:

1. Function declarations.
2. Named arrow functions assigned to variables.
3. Named function expressions.
4. Exported route handlers.
5. Same-file calls through direct identifiers.
6. Calls through directly imported identifiers.
7. Namespace-import member calls where the target export is unambiguous.
8. Relative module imports.

Example:

```ts
import { validateProject } from "../lib/validateProject";

async function submitProject(project: Project) {
  const result = validateProject(project);
}
```

Produces:

```text
submitProject ──calls──▶ validateProject
```

Evidence:

* `submitProject` definition
* `validateProject(project)` call site
* `validateProject` definition

### Do not resolve

* Computed property calls
* Dependency injection
* Runtime aliases
* Reflection
* Calls through arbitrary object mutation
* External packages whose target source is outside the snapshot
* Framework runtime behavior
* JSX rendering as a function call
* Re-exports that cannot be unambiguously followed

External imports may appear as source metadata, but not as graph edges when the target endpoint has no source reference inside the analyzed snapshot.

---

## F-002 — Semantic zoom explorer

Use three stable levels.

### Inside

Show:

* Selected source
* Evidence-linked pseudocode
* Inputs visible in syntax
* Return statements
* Direct side-effect syntax
* Concepts present in the selected function

Every pseudocode step should link to one or more evidence references.

```ts
type PseudocodeStep = {
  text: string;
  evidenceRefIds: string[];
};
```

### Around

Show:

* Direct callers
* Direct callees
* Import relationships
* Call arguments
* Unresolved references
* An ordered text path

Example text alternative:

```text
Selected path:
ProjectForm.submitProject
calls validateProject at ProjectForm.tsx:28
then calls createProject at ProjectForm.tsx:34
createProject is defined in api/projects.ts:11
```

### Across

Show:

* Module-level graph
* Selected symbol’s module
* Modules importing or imported by that module
* Repository concept occurrences
* Personal gap map after teach-back

### Context preservation

Changing zoom level must not reset:

* Selected symbol
* Selected path
* Source position
* Open evidence drawer
* Teach-back target

### Accessibility implementation

React Flow includes keyboard-focusable nodes and edges and screen-reader support, but the application must still add its own visible focus, text alternatives, labels, and reduced-motion behavior to meet the stated WCAG target. ([React Flow][7])

Implement:

* `nodesFocusable={true}`
* `edgesFocusable={true}`
* `disableKeyboardA11y={false}`
* Explicit node and edge `aria-label` values
* Enter/Space activation
* Visible focus outlines
* Text labels such as “calls” and “imports”
* Shape or icon differences in addition to color
* `prefers-reduced-motion`
* A synchronized text representation of the highlighted path

---

## F-004 — Teach-back verification loop

This is the heart of the revised MVP.

### Question generation strategy

Do not ask the model to freely invent questions.

The deterministic system first builds three `QuestionSpec` objects from available evidence. GPT-5.6 may improve wording, but it cannot change the expected claims or evidence IDs.

```ts
type QuestionSpec = {
  id: string;
  type:
    | "relationship-explanation"
    | "path-prediction"
    | "concept-application";
  selectedSymbolId: string;
  promptTemplate: string;
  requiredClaims: RequiredClaim[];
  allowedEvidenceRefIds: string[];
  conceptIds: string[];
};

type RequiredClaim = {
  id: string;
  description: string;
  evidenceRefIds: string[];
  conceptIds: string[];
};
```

### The three question types

#### Question 1 — Direct relationship

> “Which directly resolved functions does `submitProject` call, and where are those calls made?”

Grounded in outgoing call edges.

#### Question 2 — Path prediction

> “Starting at `submitProject`, what is the next module on the highlighted path, and which call site transfers control there?”

Grounded in a selected two- or three-edge path.

#### Question 3 — Concept application

> “The selected function contains two `await` expressions. Explain what must finish before execution continues at each cited line.”

Grounded in deterministic async syntax and the selected function’s source.

If evidence for one template is unavailable, substitute another deterministic template. Never ask a question whose expected answer depends on runtime behavior the analyzer cannot establish.

### Evaluation workflow

Use a LangGraph pipeline:

```text
Validate request
      ↓
Load question specifications and evidence
      ↓
Extract learner claims from each answer
      ↓
Compare claims with required evidence
      ↓
Reject unknown model-supplied evidence IDs
      ↓
Classify Supported / Missing / Unsupported
      ↓
Create learner-state evidence
      ↓
Recalculate eligible concept gaps
      ↓
Compose evidence-cited feedback
```

Suggested LangGraph state:

```py
class TeachBackState(TypedDict):
    questions: list[QuestionSpec]
    answers: list[LearnerAnswer]
    evidence_allowlist: dict[str, EvidenceRef]
    model_assessments: list[ClaimAssessment]
    validated_assessments: list[ClaimAssessment]
    learner_evidence: list[LearnerEvidence]
    concept_gaps: list[ConceptGap]
    feedback: TeachBackFeedback
```

### Structured evaluation output

```ts
type QuestionEvaluation = {
  questionId: string;

  supported: Array<{
    learnerClaim: string;
    feedback: string;
    evidenceRefIds: string[];
  }>;

  missing: Array<{
    expectedClaim: string;
    feedback: string;
    evidenceRefIds: string[];
  }>;

  unsupported: Array<{
    learnerClaim: string;
    feedback: "not enough evidence";
  }>;
};
```

### Language restrictions

Do not say:

* “You mastered this.”
* “You fully understand this.”
* “You definitely know async programming.”
* “Your comprehension is complete.”

Use:

* “This answer correctly identified…”
* “This answer did not mention…”
* “This claim is not supported by the analyzed snapshot.”
* “This attempt provides evidence for…”
* “More evidence is needed for…”

---

## F-003 — Personal concept-gap map

### Initial state

Before the learner answers anything:

```text
Repository concepts: visible
Personal concept gaps: empty
Learner state: unknown
```

Recommended empty-state copy:

> **Complete a teach-back to identify demonstrated gaps.**
> These concepts appear in the repository, but convex does not yet have evidence about your understanding.

This distinction is essential to INV-002.

### Repository concept evidence

Start with strong syntax-grounded concepts:

| Concept             | Deterministic evidence                                    |
| ------------------- | --------------------------------------------------------- |
| Async control flow  | `async`, `await`, promise chains                          |
| Module boundaries   | imports and exports                                       |
| API boundaries      | supported route handlers and `fetch` calls                |
| React state         | imported and invoked state hooks                          |
| Error handling      | `try`, `catch`, `throw`                                   |
| Data transformation | `.map`, `.filter`, `.reduce`                              |
| Types and contracts | interfaces, type aliases, annotations                     |
| Validation          | directly observable validation calls and condition checks |

Do not include a concept merely because the model believes it is relevant.

### Learner-state evidence

```ts
type LearnerEvidence = {
  id: string;
  questionId: string;
  conceptId: string;
  observation: "supported" | "missing" | "unsupported";
  answerExcerpt: string;
  repositoryEvidenceRefIds: string[];
};
```

### Gap eligibility

A concept is eligible only when:

```text
repository evidence exists
AND
learner-answer evidence exists
AND
at least one missing or unsupported observation exists
```

### Ranking

For eligible concepts only:

```text
learner_gap =
  weighted missing and unsupported observations
  ÷
  all evaluated observations for that concept

repository_relevance =
  normalized occurrence count and graph-path relevance

gap_score =
  70% learner_gap
+ 30% repository_relevance
```

This is not a psychometric mastery score. It is merely a ranking of where the current answer showed the greatest evidence-supported mismatch.

### Gap card

```ts
type ConceptGap = {
  conceptId: string;
  label: string;
  rank: number;
  score: number;

  repositoryEvidenceRefIds: string[];
  learnerEvidenceIds: string[];

  rationale: string;
  nextAction: {
    symbolId: string;
    pathEdgeIds: string[];
    prompt: string;
  };
};
```

Example:

> **1. Async control flow**
> This concept appears in four functions on the selected request path. In your answer, the second awaited operation was omitted.
>
> **Repository evidence:** `ProjectForm.tsx:34–41`
> **Answer evidence:** “The request runs and then state updates.”
> **Next action:** Reopen `submitProject` and explain which operation must complete before the state update.

Clicking the card must return the user to those exact lines and path.

---

# 8. LLM boundary enforcement

## Allowed model outputs

* Pseudocode steps with evidence IDs
* Module-role prose with evidence IDs
* Question wording derived from fixed question specs
* Learner-claim extraction
* Feedback tied to evidence IDs
* Explicit uncertainty

## Forbidden model outputs

* New symbols
* New graph edges
* New edge types
* Changed source locations
* Generic personal gaps
* Repository mutations
* Claims of mastery

## Validation sequence

Every model response must pass:

1. JSON/Pydantic schema validation.
2. Evidence-ID allowlist validation.
3. Symbol-ID allowlist validation.
4. Concept-ID allowlist validation.
5. Prohibited-language validation.
6. Structural-field rejection.

The model schemas should not contain an `edges` property at all.

For evidence-linked explanation:

```ts
type XRayExplanation = {
  role: {
    text: string;
    evidenceRefIds: string[];
  };

  pseudocode: Array<{
    text: string;
    evidenceRefIds: string[];
  }>;

  concepts: Array<{
    conceptId: string;
    explanation: string;
    evidenceRefIds: string[];
  }>;

  uncertainties: string[];
};
```

If a generated statement references an unknown ID, discard that statement. If no valid statement remains, display:

> “Not enough evidence to provide this explanation.”

---

# 9. Five-hour implementation schedule

Assumption: three builders.

## 0:00–0:20 — Contracts, sample, and deployments

### Everyone

* Create the two repositories.
* Deploy a blank Vercel client.
* Deploy a FastAPI `/health` endpoint to the Docker Space.
* Lock the sample repository.
* Lock the data contracts.
* Lock intake limits.
* Define stable ID formulas.
* Add the invariant test file before feature code.

### Gate at 0:20

* Client deployment opens.
* Backend `/health` responds.
* Both repositories share the same contract version.
* The demo sample and central path are known.

---

## 0:20–1:05 — Parallel foundation

### Builder A — Client explorer

* Render mock symbols and edges.
* Implement Inside/Around/Across controls.
* Add selected-symbol state.
* Add keyboard-focusable graph elements.
* Add text-path placeholder.
* Build the source pane.

### Builder B — Deterministic backend

* Implement sample intake.
* Configure Tree-sitter parsers.
* Extract modules and symbols.
* Create evidence references.
* Return snapshot metadata.

### Builder C — Teaching pipeline

* Define concept registry.
* Define question specs.
* Build LangGraph question pipeline with mocked evidence.
* Define structured model schemas.
* Add prohibited-language validator.

### Gate at 1:05

* Sample source produces symbol records.
* Mock graph can select a symbol.
* Three mock question specs validate.

---

## 1:05–1:55 — F-001 evidence graph

### Builder A

* Connect UI to `/v1/analyses`.
* Render real symbols.
* Add edge evidence drawer.
* Add non-color edge labels.

### Builder B

* Implement direct relative imports.
* Implement same-file calls.
* Implement named imported calls.
* Add module relationships.
* Add unresolved-reference records.
* Add provenance tests.

### Builder C

* Build evidence-linked pseudocode endpoint.
* Validate all returned evidence IDs.
* Add cached sample explanation.

### Gate at 1:55

* A selected call edge exposes:

  * Caller definition
  * Call site
  * Callee definition
* Unsupported calls produce no edge.
* Model output cannot modify the graph.

---

## 1:55–2:35 — F-002 semantic zoom and F-005 public intake

### Builder A

* Complete Inside/Around/Across behavior.
* Preserve selected context across zoom levels.
* Generate graph text alternatives.
* Add reduced-motion behavior.

### Builder B

* Implement bounded public snapshot intake.
* Resolve the commit SHA.
* Add archive-size and source-size guards.
* Reject unsafe extraction paths and symlinks.
* Add timeout handling.

### Builder C

* Implement deterministic concept occurrences.
* Connect concept evidence to selected symbols.
* Complete question selection from actual graph evidence.

### Gate at 2:35

* Bundled sample works from the backend.
* One small public repository can be analyzed.
* Zooming preserves selected symbol and path.
* Repository concepts display without being labeled personal gaps.

---

## 2:35–3:20 — F-004 teach-back

### Builder A

* Build three-question interface.
* Add one-submit evaluation flow.
* Build Supported/Missing/Unsupported feedback sections.
* Make source citations clickable.

### Builder B

* Produce required claims from graph evidence.
* Build evidence packs for questions.
* Add allowlist validation.
* Implement session-local learner-evidence format.

### Builder C

* Complete LangGraph answer-evaluation pipeline.
* Connect GPT-5.6 structured output.
* Add model failure fallback.
* Add wording restrictions.

### Gate at 3:20

* The learner can answer all three questions.
* Every supported/missing feedback item cites source.
* Unsupported claims say “not enough evidence.”
* No mastery wording appears.

---

## 3:20–3:50 — F-003 gap-map update

### Builder A

* Build gap cards.
* Add repository and learner-evidence sections.
* Clicking a gap selects the relevant symbol/path.

### Builder B

* Implement eligibility rules.
* Implement session-local ranking.
* Ensure unknown concepts are omitted.
* Return “no ranking changed” when appropriate.

### Builder C

* Generate concise rationale from validated evidence.
* Add cached evaluation for the demo answers.
* Verify no generic fallback concepts appear.

### Hard MVP gate at 3:50

The complete loop must work:

```text
sample → graph → evidence → three answers
→ feedback → updated gap map → return to code
```

Do not begin F-101 through F-104.

---

## 3:50–4:20 — Invariants and accessibility

Run:

* Edge provenance tests
* Unknown-evidence-ID tests
* No-gap-before-answer tests
* Intake limit tests
* Read-only GitHub-adapter tests
* Keyboard-only graph traversal
* Visible focus check
* Reduced-motion check
* Text-path check
* Model unavailable check

Hide or delete any feature that does not pass.

---

## 4:20–4:40 — Deployment reliability

* Set the backend CORS allowlist.
* Store the model key only in Space secrets.
* Confirm the backend listens on port `7860`.
* Verify the Vercel production environment points to the Space API.
* Test a fresh browser session.
* Test the bundled sample after a backend restart.
* Test cached explanation and cached evaluation.
* Record a backup demo video.
* Capture one full-screen fallback screenshot.

Because Docker Space local storage is not persistent across restarts by default, do not depend on server-side learner history for the MVP. Keep learner state in the active client session and return updated state from each evaluation. ([Hugging Face][1])

---

## 4:40–5:00 — README and rehearsal

Document:

* Product problem
* Invariant spine
* Architecture
* Exact supported scope
* Read-only behavior
* Known limitations
* Codex collaboration
* Main Codex `/feedback` Session ID
* GPT-5.6 runtime responsibilities
* Demo path

Run the sub-three-minute demo twice without stopping.

---

# 10. Invariant-focused test plan

| Invariant or rule | Minimum automated test                                                               |
| ----------------- | ------------------------------------------------------------------------------------ |
| INV-001           | Every rendered edge has source definition, relationship, and target definition refs. |
| INV-001           | A dynamic call appears only under unresolved references.                             |
| INV-001           | A model response containing an unknown edge-like field is rejected.                  |
| INV-002           | Gap-map response is empty before learner-answer evidence exists.                     |
| INV-002           | Every gap includes both repository evidence IDs and learner-evidence IDs.            |
| INV-002           | A generic model-proposed concept is discarded.                                       |
| INV-003           | GitHub adapter issues only read requests.                                            |
| BR-003            | Ambiguous calls return `not enough evidence`.                                        |
| BR-005            | Feedback containing “mastered” or “fully understands” fails validation.              |
| BR-006            | Oversized input is rejected without partial analysis.                                |
| BR-008            | Highlighted path always has a text alternative.                                      |
| AC-005            | Selected symbol remains selected across all zoom levels.                             |
| AC-008            | Evaluation either changes ranking or explicitly reports no change.                   |
| AC-011            | Supported and missing feedback contain clickable evidence refs.                      |
| AC-015            | No route or integration path modifies repository state.                              |

One especially valuable regression fixture:

```ts
function run(handlerName: string) {
  handlers[handlerName]();
}
```

Expected result:

```text
No call edge is created.
An unresolved reference is returned.
Message: "not enough evidence"
```

---

# 11. Demo repository design

Use a small project-submission application:

```text
src/
├── components/
│   └── ProjectForm.tsx
├── lib/
│   ├── validateProject.ts
│   └── projectStore.ts
└── app/
    └── api/
        └── projects/
            └── route.ts
```

Central evidence path:

```text
ProjectForm.submitProject
        │
        ├──calls──▶ validateProject
        │
        └──calls──▶ createProjectRequest
                           │
                           └──module path──▶ POST route
                                                 │
                                                 └──calls──▶ saveProject
```

Concept evidence:

* Async control flow
* Module/API boundaries
* Input validation
* Error handling
* React state

## Prepared partial learner answer

Use an intentionally incomplete answer during the demo:

> “`submitProject` saves the project directly and then updates the UI.”

Expected feedback:

### Supported

* It identifies that UI state is updated after the request path.
* Cite the state-update source line.

### Missing

* It omits the validation call.
* It omits the API module boundary.
* Cite both call sites.

### Unsupported

* There is no direct `submitProject → saveProject` edge.
* Show: **not enough evidence**.

Expected gap-map change:

1. Module and API boundaries
2. Validation flow
3. Async control flow

Each gap should point back to an exact path or source line.

---

# 12. Sub-three-minute demo script

## 0:00–0:25 — Problem

> “AI helps builders ship code before they understand the systems they have assembled. Existing explainers summarize a selected snippet, but they do not prove that the builder understands how the code connects.”

## 0:25–0:50 — Evidence-backed graph

Load the sample.

> “convex first builds a deterministic graph. This edge is not generated by the model. We can open it and see the caller definition, exact call site, and callee definition.”

Open one edge’s evidence drawer.

## 0:50–1:20 — Semantic zoom

Select `submitProject`.

> “Inside shows source-linked pseudocode. Around shows direct callers and callees. Across shows the module path. The selected function stays in context throughout.”

Show the graph’s text alternative briefly.

## 1:20–2:05 — Teach-back

> “Reading an explanation is not proof of comprehension, so convex asks three questions derived from this exact path.”

Submit the prepared answers.

> “The feedback separates what this answer supported, what it missed, and what the repository does not support.”

Open the unsupported direct-save claim.

## 2:05–2:35 — Gap map

> “Only now does convex create a personal gap map. Before the answers, these were merely concepts found in the repository. The ranking now combines repository relevance with demonstrated answer evidence.”

Click the top gap and return to the responsible path.

## 2:35–2:50 — Invariants

> “The model explains and critiques deterministic evidence. It never creates the graph, never invents a personal gap, and never writes to the repository.”

## 2:50–3:00 — Close

> “convex does not generate more code. It turns code you shipped into evidence of what you understand—and what to learn next.”

---

# 13. Release separation after MVP

The proposed Final features are all applicable, but they should be separated into subsequent releases rather than bundled into one large “final” milestone.

## Release 1 — Change awareness

### F-101 Comprehension-delta ledger

Depends on:

* Stable snapshot IDs
* Stable symbol and edge IDs
* Analyzer versioning
* Persistent learner evidence
* Repository diffing

It should answer:

> “What changed in the code, and which new concepts or paths lack demonstrated learner evidence?”

Do not build diffing during the hackathon. Stable IDs are the only preparation needed now.

## Release 2 — Longitudinal learner model

### F-103 Cross-repository learner graph

Requires:

* Authentication
* Explicit learner consent
* Private storage
* Deletion/export controls
* Separation of repository evidence from learner observations
* A policy for evidence aging

This should never merge two repositories’ structural evidence into one ambiguous graph.

## Release 3 — Workflow surfaces

### F-102 In-workflow MCP App or extension

The surface should:

* Open the existing map
* Select the current symbol
* Start the same teach-back flow
* Remain read-only
* Avoid editor, debugger, or code-generation features

It consumes the core API; it does not fork the product into an IDE.

## Release 4 — Agent interoperability

### F-104 Agent teaching contract

Expose only:

* Deterministic repository evidence
* Eligible learner gaps
* Evidence-linked teaching targets
* Read-only queries

It should not allow an agent to rewrite the learner state merely by claiming it taught something. A learner answer or other demonstrated evidence must still update comprehension state.

---

# 14. Codex and GPT-5.6 responsibilities

## Codex — build-time collaborator

Use Codex to help implement and review:

* Parser queries
* Import resolution
* Stable evidence IDs
* Pydantic contracts
* Client API types
* Invariant tests
* Accessibility checks
* Docker configuration
* Vercel/Space integration
* README documentation

Record major Codex decisions and the required feedback session in the README.

## GPT-5.6 — controlled runtime component

Use GPT-5.6 for:

* Evidence-linked pseudocode
* Question wording from deterministic specifications
* Natural-language learner-claim extraction
* Evidence-cited feedback wording

Do not use it for:

* Graph creation
* Symbol resolution
* Concept occurrence detection
* Gap eligibility
* Repository intake
* Repository operations

---

# 15. Final definition of done

The five-hour build is complete only when all of these are true:

* The bundled sample loads through the FastAPI backend.
* A bounded public repository can be accepted or clearly refused.
* The returned snapshot is pinned to a commit SHA.
* Every rendered edge has source, relationship, and target evidence.
* An unresolved relationship never appears as an edge.
* Selecting an edge opens its source provenance.
* Inside, Around, and Across preserve the selected context.
* Pseudocode steps link to source evidence.
* The graph is keyboard traversable.
* The graph has a synchronized text alternative.
* Three questions are generated from repository evidence.
* Feedback distinguishes supported, missing, and unsupported claims.
* Unsupported claims use “not enough evidence.”
* No feedback claims mastery or complete understanding.
* The gap map is empty before teach-back.
* Every displayed gap has repository and learner-answer evidence.
* Clicking a gap returns to the relevant symbol or path.
* The application requests no repository write permission.
* No repository mutation operation exists.
* The complete demo works with cached model responses.
* F-101 through F-104 have not displaced the MVP loop.

The revised plan is stronger than the original one: **F-001 and F-002 establish structural truth, F-004 creates learner evidence, and only then does F-003 earn the right to call something a personal gap.**

[1]: https://huggingface.co/docs/hub/en/spaces-sdks-docker?utm_source=chatgpt.com "Docker Spaces · Hugging Face"
[2]: https://tree-sitter.github.io/tree-sitter/using-parsers/?utm_source=chatgpt.com "Using Parsers - Tree-sitter"
[3]: https://docs.langchain.com/oss/python/langgraph/use-graph-api?utm_source=chatgpt.com "Use the graph API - Docs by LangChain"
[4]: https://developers.openai.com/api/docs/models?utm_source=chatgpt.com "Models | OpenAI API"
[5]: https://fastapi.tiangolo.com/fr/tutorial/cors/?utm_source=chatgpt.com "CORS (Partage des ressources entre origines) - FastAPI"
[6]: https://docs.github.com/en/rest/git/trees?utm_source=chatgpt.com "REST API endpoints for Git trees - GitHub Docs"
[7]: https://reactflow.dev/learn/advanced-use/accessibility?utm_source=chatgpt.com "Accessibility - React Flow"
