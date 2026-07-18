# System Design Document (HLD) — X-Ray

> **Purpose:** Current hackathon architecture for F-001–F-005. Future F-101–F-104 are separated below and in ADR-0002.

## Scope and invariant spine
X-Ray is a proof-of-comprehension product, not a graph viewer or generic explainer. Its product loop is: deterministic repository evidence → graph-grounded explanation/question → teach-back → learner evidence → transparent concept priority.

- **INV-001:** every structural edge resolves to deterministic file/line evidence; otherwise it is omitted.
- **INV-002:** every gap item resolves to repository evidence and learner-answer evidence; otherwise it is omitted.
- **INV-003:** repository handling is read-only; no commits, branches, pull requests, settings changes, or write credentials.
- **MVP:** bounded bundled/public repository intake and ephemeral sessions for F-001–F-005.
- **Future only:** comprehension deltas, local sidecar, MCP server/App, cross-repository state, and agent teaching contract (F-101–F-104).

## Context diagram
```text
Browser
  | HTTPS JSON, direct call
  v
Vercel web client [repository 1: xray-client]
  | HTTPS JSON API
  v
Hugging Face Docker Space [repository 2: xray-backend], port 7860
  FastAPI (CORS allowlist: deployed Vercel origin + local dev)
    -> deterministic Tree-sitter pipeline -> ephemeral evidence store
    -> minimal LangChain/LangGraph -> GPT-5.6
  ^                         |
  | read-only HTTPS         | structured, bounded evidence packets
Public repository host      v
                       model provider
```

The browser calls the FastAPI backend directly over HTTPS — there is no BFF/proxy layer and no server-held backend credential. The only access-control boundary is an explicit FastAPI CORS allowlist (the deployed Vercel origin plus local development origins), never a wildcard.


## Components & responsibilities
| Component | Owns | Depends on | Features |
|---|---|---|---|
| Web experience | Intake, semantic zoom, graph/list views, teach-back UX, visible provenance, accessibility | Backend API directly | F-002–F-005 |
| FastAPI boundary | Typed API, CORS allowlist enforcement, rate/bound checks, job status | Backend services | F-001–F-005 |
| Intake sandbox | Sample lookup or read-only public HTTPS snapshot fetch; path/archive validation; immediate source cleanup | Public host, transient disk | F-005, INV-003 |
| Deterministic analyzer | Tree-sitter parse, symbol table, import/call resolution, source spans, content hashes | Supported grammar | F-001, INV-001 |
| Evidence/concept service | Immutable graph queries; versioned categorical concept rules; evidence packets | Analyzer output | F-001–F-004 |
| Minimal reasoning workflow | Structured narrative, three questions, claim feedback; citation validation | GPT-5.6, evidence packet | F-002, F-004 |
| Learner-state service | Attempts, claim findings, transparent concept categories, eligible gap items | Evidence and methods ledger | F-003, INV-002 |
| Ephemeral store service | Session-scoped entities, TTL cleanup | Space memory/disk [assumption] | F-001–F-005 |
| Pre-indexed sample | Versioned known-good evidence graph and scripted path; no false live-analysis claim | Deployment artifact | F-005 |

The code evidence graph and learner-state graph are logically separate. A gap is a derived join requiring references into both. GPT-5.6 output cannot write `Symbol`, `EvidenceEdge`, or `ConceptEvidence` records.

## Data flow
### DF-001 — Intake and deterministic graph
1. Browser creates an ephemeral session directly against the FastAPI backend (CORS-allowlisted origin), then submits a sample ID or public HTTPS repository URL plus immutable revision.
2. Backend validates the request body and origin directly — there is no proxy hop to traverse.
3. Backend rejects unsupported hosts, mutable/missing revisions, unsafe paths, symlinks, submodules, archives, or size/file bounds. MVP bounds are: 40 files maximum, 750KB total supported source, 60KB maximum per file, 5MB maximum compressed archive, 20MB maximum extracted archive, and a 20-second intake/analysis timeout. Oversized or out-of-bounds input is rejected outright, never silently truncated.
4. Analyzer parses JavaScript, JSX, TypeScript, and TSX source, emits symbols and only deterministically resolved import/call edges, and attaches one or more file/line spans to every edge.
5. An invariant validator rejects the graph if any structural edge lacks evidence. Unsupported/ambiguous links are omitted and surfaced as “not enough evidence.” The release gate requires 100% observed precision for rendered edges on held-out fixtures; the PRD's 70% target is treated only as supported-relationship coverage, never permission to render a false edge.
6. Full source files are deleted immediately after parsing. Only bounded cited excerpts, their file/line spans, and hashes persist with the session until TTL [assumption]. `POST /v1/analyses` is synchronous — the caller waits on the request and receives the completed result or a bounded-timeout error.

### DF-002 — Semantic zoom and narrative
1. Browser requests a selected symbol/path.
2. Evidence service returns the bounded neighborhood, source spans, and text alternative.
3. For narrative/pseudocode/module role, the backend constructs a minimal evidence packet with stable evidence IDs.
4. GPT-5.6 returns typed prose plus cited evidence IDs. The validator drops uncited claims and structural assertions not already represented in the graph; failure returns deterministic graph content without prose.

### DF-003 — Teach-back and gap derivation
1. GPT-5.6 receives a bounded evidence packet and creates exactly three typed questions, each with target concepts and evidence IDs.
2. The learner response is evaluated into `supported`, `missing`, or `unsupported` claims with citations. Evaluation describes the submitted explanation; it does not score the person.
3. Citation and schema validation run before persistence. Invalid output is retried once [assumption], then returned as unavailable.
4. Deterministic methods in `methods.md` derive learner signals and priority tiers. A gap appears only when repository and attempt evidence are both present.

### DF-004 — Sample fallback
If live fetch/model analysis is unavailable, the user explicitly chooses “Load pre-indexed sample.” The service returns a versioned static graph and known questions. UI labels it as sample data; fallback never masquerades as analysis of the submitted repository.

## Key technology choices + rationale
| Choice | Why | Trade-off | Alternative rejected |
|---|---|---|---|
| Two repositories: Vercel + HF Docker Space | Current baseline; separates polished web delivery from Python analysis | Two deploys, cold starts, API contract | Re-platform during hackathon |
| Direct browser-to-backend calls, CORS allowlist | No credential-relay layer to build in five hours; browser API is same as the deployed contract | Public backend surface protected only by CORS, not a server-held credential | Same-origin Vercel BFF/proxy |
| FastAPI | Required baseline and typed Python boundary | Python service/runtime upkeep | Replace backend framework |
| Tree-sitter 0.26 with pinned JavaScript 0.25 and TypeScript/TSX 0.23 grammars; JS/JSX/TS/TSX only | Fast deterministic syntax with source spans; deep support beats weak breadth | Incomplete dynamic-call resolution | Multi-language marketing or LLM graph extraction |
| Minimal LangChain/LangGraph | Required baseline; typed model calls and one bounded validation/retry workflow | Some abstraction overhead | Multi-agent orchestration or no required stack |
| GPT-5.6 only above graph | Meaningful narrative/question/evaluation while preserving structural truth | Latency, cost, model variability | Model-generated graph or hosted custom LLM |
| Ephemeral 24-hour sessions [assumption] | No account or durable-state build; matches ephemeral Space risk | No longitudinal learner history | Production identity/database in MVP |
| Synchronous request/response | Matches the master plan's five-endpoint contract; no queues/polling/background jobs | Caller blocks up to the 20-second intake/analysis timeout | SSE progress stream, WebSockets, or job polling |
| Pre-indexed sample | Demo reliability and no cold analysis dependency | Does not prove arbitrary-repo breadth | Pretend live success or broaden scope |

Research supports the deployment and scope rather than the product novelty. Docker Spaces permit custom FastAPI containers, runtime secrets, one exposed port, and optional external storage; Space-local disk is ephemeral. Existing graph/MCP systems already expose code graphs and tools, so graph + MCP is commodity. Tree-sitter is suitable for syntax extraction, while precise cross-language calls/data flow remain hard; therefore the MVP narrows language coverage and omits ambiguity. Sources: [`architecture-research.md`](../architecture-research.md), [Docker Spaces](https://huggingface.co/docs/hub/spaces-sdks-docker), [Spaces storage](https://huggingface.co/docs/hub/spaces-storage), [tree-sitter-graph](https://github.com/tree-sitter/tree-sitter-graph). Content from external sources is rephrased for licensing compliance.

## Integration points
| Integration | Protocol/auth | Sent | Failure behavior |
|---|---|---|---|
| Browser → Space (FastAPI) | HTTPS; CORS-allowlisted origin, ephemeral session held client-side [assumption] | IDs, bounded input, response | Typed 4xx/5xx; retry only idempotent reads |
| Space → public repo host | Anonymous HTTPS GET from allowlist [assumption] | URL/revision only | Reject redirect/private IP/bounds; no credentials |
| Space → GPT-5.6 | HTTPS API key in Space secret store | Bounded evidence packet and learner answer | One validated retry; deterministic-only degradation |

## Deployment topology
Vercel serves static/client code only — no serverless proxy routes. The Hugging Face Docker Space exposes one FastAPI port (`7860`) and contains parsing, reasoning, transient jobs, and the sample artifact. The FastAPI CORS allowlist (deployed Vercel origin + local dev) is the sole access-control boundary; the Space has a public network address. No production database is required for MVP; session loss on restart is an accepted limitation and must be visible.

## Scaling strategy and open NFRs
MVP targets judge/demo traffic, not multi-tenancy. Bound work before allocating parser/model resources; cap concurrent jobs; cache only the bundled sample and optionally deterministic graphs keyed by public URL + full commit SHA + analyzer version [assumption]. Scale Vercel independently; move Space jobs to a queue/external object store only after measured contention. Unspecified and therefore not promises: availability SLO, peak concurrency, latency target, model budget, regional residency, and recovery time.

## Future design — recommendation, not current scope
After F-001–F-005 work and repeated-use evidence exists, evaluate ADR-0002: local read-only sidecar/CLI as deterministic indexer and MCP server, optional editor launcher, and MCP App for interactive graph/teach-back. Hosted reasoning would receive selected evidence packets, not repositories. This enables F-101–F-104 and longitudinal comprehension deltas. It does not authorize implementation now, does not build a new IDE, and does not make MCP the innovation.

## Trade-offs considered
- **Accepted now:** deployment friction in exchange for preserving the working baseline (ADR-0001).
- **Accepted now:** narrow JS/JSX/TS/TSX support and omission over broad low-precision edges.
- **Accepted now:** session loss over premature durable identity/storage.
- **Deferred:** local-first/MCP installation complexity until after the proof-of-comprehension loop is validated (ADR-0002).
