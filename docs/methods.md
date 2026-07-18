# Methods & Traceability — Glass-Box Ledger — convex

## The glass-box contract (non-negotiable)
Every displayed count, category, progress value, or priority resolves to an `equation_id` and its `input_dataset_ids`. GPT-5.6 may return typed claim classifications with citations; it never originates a score, structural edge, rank weight, or priority. convex never claims mastery or full comprehension.

## 1. Evidence and validation model
Structural facts (symbols, edges) are binary, not graded: a relationship is either deterministically established with all three provenance anchors (source definition, relationship site, target definition), or it is omitted entirely as an unresolved reference. There is no `confidence: medium` state for a structural edge — ambiguity is never rendered as a faded or speculative edge.

Model-evaluated content (claim dispositions, narrative prose) is validated, not scored: every model output passes schema validation and an evidence-ID allowlist check before it can be displayed. Output that fails validation is discarded, not down-weighted — there is no partial-confidence rendering of model output either. A discarded statement falls back to "Not enough evidence to provide this explanation."

## 2. Definitions
For concept `c` and session `s`:
- `repo_sites(c)`: distinct DS-002 evidence spans linked by DS-003 rules.
- `on_focus_path(c)`: at least one repo site intersects the user-selected symbol/path.
- `gap_attempts(c)`: attempts with at least one cited `missing` or `unsupported` evaluation claim for `c`.
- `eligible(c)`: `repo_sites(c) > 0 AND gap_attempts(c) > 0` (INV-002).
- `learner_gap(c)`: weighted share of `missing`/`unsupported` observations out of all evaluated observations for `c`, in `[0, 1]`. This is an observation about submitted explanations, not knowledge.
- `repository_relevance(c)`: normalized occurrence count and graph-path relevance for `c`, in `[0, 1]`; higher when `on_focus_path(c)` is true.

No personal gap item exists when `eligible(c)` is false. Unknown initial learner state stays unknown.


## 3. Equation registry
Stable IDs never renumber; changes increment method version.

| ID | Output | Formula / method | Inputs | Features |
|---|---|---|---|---|
| **EQ-001** | Intake manifest counts | `file_count=|accepted files|`; `total_bytes=sum accepted source bytes`; must satisfy the MVP intake bounds (40 files, 750KB total, 60KB/file) before parsing | DS-001 | F-005 |
| **EQ-002** | Structural graph counts | `symbol_count=|published symbols|`; `edge_count=|published edges with all three evidence anchors|`; group by declared edge type. Deterministic and exact — no confidence grading; an edge either has all three anchors or it does not exist | DS-002 | F-001 |
| **EQ-003** | Concept repository exposure | `repo_sites(c)=|distinct (file_hash, span) in DS-003 for c|`; `repository_relevance(c)` normalized from site count and focus-path intersection | DS-002, DS-003, DS-004 | — |
| **EQ-004** | Question progress | `completed = distinct question_ids with accepted attempt`; `total = 3`; render `completed of 3`, never a comprehension percentage | DS-005, DS-006 | F-004 |
| **EQ-005** | Gap eligibility and ranking | Eligibility below; `gap_score(c) = 0.70 * learner_gap(c) + 0.30 * repository_relevance(c)` for eligible concepts only; stable sort by `gap_score` descending, then `concept_id` | DS-003, DS-004, DS-006, DS-007 | F-003, F-004 |
| **EQ-006** | Evidence citation count | `|distinct evidence_span_id|` on an artifact after citation validation | DS-002, DS-005, DS-007 | F-002, F-004 |
| **EQ-101** | Future comprehension delta category | For changed concept evidence set `C_new`: `NEW_UNTESTED = C_new - concepts_with_attempt_evidence`; `REOPENED = C_new ∩ prior_gap_concepts`; no magnitude/score | DS-008, future versioned learner data | F-101, **future only** |

### EQ-005 ranking
Only eligible concepts enter the ranking. `gap_score` is a ranking value, not a mastery percentage — it is not shown as "X% understood," it orders the gap list. The UI must show the plain-language rationale (which observations were missing/unsupported, and where the concept sits in the repository) alongside both evidence classes.

### Evaluation-to-signal boundary
GPT-5.6 returns candidate `EvaluationClaim` objects. Before DS-007 admits them, deterministic validators require: known question, target concept from that question, allowed disposition, and evidence IDs present in the question packet. A `missing` claim means a target claim was absent from this response; `unsupported` means this response asserted something contradicted or not supported by the supplied evidence. Neither means the person lacks knowledge outside the submitted response.

## 4. Dataset / input registry
| ID | Input / dataset | Source | Access & license |
|---|---|---|---|
| **DS-001** | Bounded snapshot manifest: paths, byte counts, hashes, revision | Read-only sample/public repository intake | Source repository license; transient processing only [assumption] |
| **DS-002** | Symbols, exact edges (three provenance anchors each), source spans | Deterministic Tree-sitter analyzer | Internal derived data; parser/grammar licenses to verify at scaffold |
| **DS-003** | Concept evidence and rule IDs | Versioned deterministic taxonomy rules [assumption] | Internal rules |
| **DS-004** | User-selected symbol/path | Session interaction | User-provided interaction, ephemeral |
| **DS-005** | Question targets and evidence packet manifest | Validated GPT-5.6 output + deterministic packet builder | Model terms/config to verify [assumption] |
| **DS-006** | Teach-back attempts and completion events | Learner submission | User content, session-confidential, 24h [assumption] |
| **DS-007** | Validated claim dispositions and citations | GPT-5.6 structured evaluation after deterministic validation | User/model-derived, session-confidential |
| **DS-008** | Versioned code-change evidence and longitudinal learner records | Future local sidecar + learner graph | Not designed; future consent/privacy decision required; future only |

## 5. Worked examples
### Eligible gap
Concept `async-control-flow` has two DS-003 source spans. One lies on the selected path (DS-004), giving it high `repository_relevance`. One validated attempt (DS-006/DS-007) has a cited `missing` claim, giving it a non-zero `learner_gap`. EQ-005 produces `gap_score = 0.70 * learner_gap + 0.30 * repository_relevance`. UI: “This concept appears on your traced path. Your latest explanation did not cover the cited behavior.” It does not say the learner does not understand async code, and the score is never rendered as a percentage of understanding.

### Ineligible item
A concept exists in DS-003 but there is no teach-back attempt. EQ-005 fails `eligible(c)` and emits no `GapItem`. It may appear as a repository concept, clearly separate from personal gaps.

### Rejected number
“82% understood” has no valid equation or dataset and implies a mastery construct. It must not ship. `gap_score` is a ranking value with a documented derivation, not a comprehension percentage — the UI must never label it as one.

## 6. Traceability and tests
| Feature | Displayed derivations | Required checks |
|---|---|---|
| F-001 | EQ-002, EQ-006 | Recompute graph counts; assert every counted edge has all three evidence anchors |
| F-002 | EQ-006 | All narrative citations resolve; no uncited structural prose |
| F-003 | EQ-003, EQ-005 | Property: no item without DS-003 and DS-006/DS-007; `gap_score` reproduces from inputs |
| F-004 | EQ-004–EQ-006 | Progress is event count only; evaluation shows dispositions/citations, no mastery claim |
| F-005 | EQ-001 | Manifest counts reproduce from accepted files and enforce bounds |
| F-101 | EQ-101 | Future-only; cannot appear in MVP builds |

Every API response displaying a derived value includes `{equation_id, equation_version, input_dataset_ids, derivation_id}`. UI snapshot tests forbid `% understood`, `mastery`, `fully understands`, and unregistered counts. Any new number/category requires a new EQ and DS entry before implementation.