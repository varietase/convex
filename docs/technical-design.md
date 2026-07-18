# Technical Design Document (LLD) — X-Ray

> **Purpose:** Implementation detail for the current F-001–F-005 hackathon system. See `system-design.md` for boundaries and ADRs for platform decisions.

## Module breakdown
### Vercel repository
| Module | Responsibility | Public interface | Collaborators |
|---|---|---|---|
| `ui/intake` | Sample/public snapshot form and bounds messaging | pages/components | BFF session and analysis routes |
| `ui/explorer` | Graph, source spans, semantic zoom, accessible path list | view model | graph API |
| `ui/teachback` | Questions, response form, feedback, gap list | view model | teach-back APIs |
| `bff/session` | Mint/verify ephemeral session cookie and CSRF token | API-001, API-009 | signed-cookie utility |
| `bff/proxy` | Validate same-origin requests, attach backend credential, forward allowlisted contracts | API-002–API-008 | Space API |
| `bff/health` | Judge-safe dependency health summary | API-010 | Space health |

### Hugging Face repository
| Module | Responsibility | Public interface | Collaborators |
|---|---|---|---|
| `api` | FastAPI request validation and resource authorization | API-101–API-108 | services |
| `intake` | Validate source and bounds; download immutable public snapshot read-only | `materialize_snapshot` | host adapter |
| `analysis` | Parse supported files and build evidence graph | `analyze_snapshot` | Tree-sitter adapter |
| `evidence` | Immutable session-scoped graph and provenance queries | `get_graph`, `slice_evidence` | ephemeral store |
| `concepts` | Apply versioned deterministic concept rules | `map_concepts` | evidence graph |
| `reasoning` | Typed GPT-5.6 narrative/question/evaluation calls | `narrate`, `question`, `evaluate` | LangChain, LangGraph |
| `learner` | Record attempts and derive eligible gap items | `record_attempt`, `derive_gaps` | methods registry |
| `jobs` | Job lifecycle and SSE events | `submit`, `events` | analysis/reasoning |
| `cleanup` | TTL and workspace deletion | scheduled/lazy sweep | ephemeral store |

Dependency versions and concrete SDK method names must be pinned and checked against official docs at scaffold time [assumption].


## Class / function-level design
```python
@dataclass(frozen=True)
class SourceSpan:
    span_id: str
    file_path: str
    start_line: int
    start_column: int
    end_line: int
    end_column: int
    content_hash: str
    excerpt_text: str  # bounded cited lines retained only to session TTL

@dataclass(frozen=True)
class EvidenceEdge:
    edge_id: str
    edge_type: Literal["imports", "calls", "contains"]
    from_symbol_id: str
    to_symbol_id: str
    evidence: tuple[SourceSpan, ...]  # non-empty by construction

def materialize_snapshot(source: RepositoryInput, limits: IntakeLimits) -> SnapshotWorkspace: ...
def extract_graph(workspace: SnapshotWorkspace, analyzer_version: str) -> EvidenceGraph: ...
def validate_graph(graph: EvidenceGraph) -> None: ...
def slice_evidence(graph: EvidenceGraph, selection: Selection, budget: EvidenceBudget) -> EvidencePacket: ...
def derive_gap_items(graph: EvidenceGraph, attempts: list[Attempt]) -> list[GapItem]: ...
```

`validate_graph` fails closed when an edge has no source span, the span is outside its immutable file hash, or either symbol is absent. Model-facing functions accept `EvidencePacket`, never a workspace or unrestricted repository.

```python
class ReasoningState(TypedDict):
    task: Literal["narrative", "questions", "evaluation"]
    packet: EvidencePacket
    learner_response: str | None
    structured_output: dict | None
    validation_errors: list[str]
    attempt: int

# Minimal LangGraph: START -> call_model -> validate -> END
#                                      `-> retry_call (once) -> validate -> END
```

LangGraph coordinates only the typed model call, validation, and one retry [assumption]. Intake, parsing, graph queries, gap derivation, and job control are ordinary deterministic services. LangChain provides the GPT-5.6 client/structured-output adapter [assumption]. There are no planner, researcher, critic, or multi-agent nodes.

### Structured model contracts
- `NarrativeOutput`: `{sections:[{kind, text, evidence_ids:[...]}]}`.
- `QuestionOutput`: `{questions:[{prompt, target_concept_ids, target_evidence_span_ids, question_type}]}` with exactly three entries.
- `EvaluationOutput`: `{claims:[{text, disposition, concept_ids, evidence_span_ids, feedback}]}` where disposition is `supported|missing|unsupported`.

The validator requires every returned evidence ID to exist in the packet. Narrative sentences that assert an import/call relationship must map to an existing edge ID. Unknown fields are rejected. Prompt text explicitly forbids scores and knowledge/mastery claims, but schema validation—not the prompt—is the enforcement boundary.

## Algorithms
### A-001 — Read-only bounded intake (F-005, INV-003)
1. Accept only `sample_id` or an allowlisted HTTPS public repository URL and full commit SHA [assumption].
2. Resolve DNS and reject loopback, link-local, private, metadata, non-HTTPS, user-info, ports outside 443, and redirect to disallowed destination.
3. Fetch an archive/snapshot without repository credentials and without running repository code.
4. Stream with byte cap; normalize paths; reject absolute paths, `..`, symlinks, hardlinks, submodules, archives within archives, and special files.
5. Enforce 5 MiB, 500 files, 100,000 physical lines, TS/JS family, and 60-second bounds [assumption].
6. Mount/use workspace read-only where platform permits [assumption]; never invoke package managers, build scripts, interpreters, or Git mutation commands.
7. Delete the workspace in `finally`, including timeout/error paths.

### A-002 — Deterministic graph construction (F-001, INV-001)
For each supported file, parse once: `O(total source bytes)`. Build module/symbol tables keyed by normalized path and lexical scope. Resolve relative imports only when the target is unique under documented TS/JS resolution rules [assumption]. Resolve calls only for direct identifiers/member references whose declaration is unique in the supported static scope. Emit no edge for dynamic imports, computed property calls, reflection, runtime dependency injection, ambiguous re-exports, or parser errors. Each emitted edge stores the call/import token span and both endpoint declaration spans. During parsing, persist only each cited span plus bounded surrounding lines and its file hash until session TTL [assumption]; delete full files after extraction. Graph storage is `O(V + E + S)` plus bounded excerpt bytes.

### A-003 — Concept evidence (F-003, INV-002)
A versioned rule registry maps deterministic syntax/edge predicates to concept IDs; e.g., a direct function call edge may evidence “function composition,” while an `await` syntax node may evidence “asynchronous control flow” [assumption]. Every mapping stores rule version and source spans. GPT-5.6 may explain a mapped concept but cannot add one.

### A-004 — Evidence packet construction
Start from selected symbols/edges, load only their persisted bounded `SourceSpan.excerpt_text` values, stable IDs, concept rules, and question targets. Never require the deleted full workspace. Deduplicate by excerpt hash and truncate only at whole evidence-record boundaries. Record included IDs in the derivation. Evidence budget/token limits are [assumption] pending scaffold validation.

### A-005 — Gap derivation (F-003, INV-002)
Apply EQ-005 from `methods.md`. Join concept evidence to validated evaluation claims through `concept_id`; require at least one repository evidence ref and one teach-back attempt ref. Derive categorical priority deterministically. Never average model confidence, emit a percentage, or infer learner knowledge from reading/click behavior.

## Sequence diagrams
### Analysis
```text
Browser -> BFF: POST session / analysis
BFF -> FastAPI: authenticated API-101
FastAPI -> Intake: bounded read-only materialize
Intake -> Analyzer: workspace
Analyzer -> Evidence: graph + spans
Evidence -> Validator: INV-001 check
Validator -> Store: immutable session graph
FastAPI --> BFF: job id; SSE stages
BFF --> Browser: ready / clear error / sample option
Intake -> Workspace: delete in finally
```

### Teach-back
```text
Browser -> BFF -> FastAPI: request questions
FastAPI -> Evidence: bounded packet
FastAPI -> ReasoningGraph -> GPT-5.6: typed question request
GPT-5.6 --> ReasoningGraph: structured output
ReasoningGraph -> Validator: schema + citation check (retry once)
FastAPI --> Browser: three questions
Browser -> BFF -> FastAPI: response
FastAPI -> ReasoningGraph -> GPT-5.6: evidence-grounded evaluation
ReasoningGraph -> Validator: dispositions + citations
Validator -> LearnerService: validated claims
LearnerService -> Methods: EQ-005 categories
Methods -> Store: learner state + eligible gaps + derivation
FastAPI --> Browser: feedback and updated gaps
```

## Error-handling strategy
| Error class | Surface | Handling | Log policy |
|---|---|---|---|
| Invalid/unsafe input | 422 | Reject before fetch/parse | Reason code, host category; no URL query/source |
| Bounds exceeded | 413 | Abort stream, delete workspace | Limit name and observed bucket, not content |
| Unsupported/ambiguous relation | 200 with omission | “not enough evidence” | Aggregate count only |
| Session/resource mismatch | 404 | No existence disclosure | Request/session hash |
| Rate limit/concurrency | 429 + `Retry-After` | No queued hidden work | Route and bucket |
| Upstream fetch timeout | 504 | Cleanup; retry CTA/sample | Host category and timing |
| Model/schema/citation failure | 502 | One retry, then deterministic-only response | Model request ID and validation code; no prompt/answer |
| Invariant failure | 500, analysis not published | Quarantine result, alert | Edge/entity IDs and analyzer version |
| Space restart/lost session | 410 | Explain expiration; restart/sample | Restart/session-loss counter |

All cleanup uses `finally`; user messages are plain and non-destructive. Logs never contain source text, learner responses, cookies, credentials, or full model packets.

## Key decisions
- One analyzer adapter and one TS/JS grammar family [assumption]; broad language plugins wait.
- Immutable graph records; learner records cannot mutate graph truth.
- Model output is schema/citation validated and can degrade independently.
- Minimal LangGraph is a bounded retry state machine, not product architecture theater.
- Ephemeral storage and pre-indexed sample are deliberate MVP reliability choices.
- Current platform decision: ADR-0001. Future local-first recommendation only: ADR-0002.