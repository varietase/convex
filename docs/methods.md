# Methods & Traceability — Glass-Box Ledger — X-Ray

## The glass-box contract (non-negotiable)
Every displayed count, category, progress value, or priority resolves to an `equation_id`, its `input_dataset_ids`, and confidence. GPT-5.6 may return typed claim classifications with citations; it never originates a score, structural edge, rank weight, or priority. X-Ray never claims mastery or full comprehension.

## 1. Confidence rubric
Confidence is computed from provenance, not guessed:

| Level | Trigger | Rendering |
|---|---|---|
| High | All load-bearing inputs are deterministic, versioned, and validated on the supported language fixture | Exact count/category with derivation link |
| Medium | Deterministic rule but one input mapping or threshold is an unvalidated product assumption | Exact categorical result plus `[assumption]` disclosure |
| Low | Any load-bearing finding comes from model evaluation or an unvalidated method | Qualitative feedback/direction only; no numeric score or precise rank |

Output confidence is the minimum of its load-bearing inputs and method confidence. Model-evaluated findings are Low until human-labeled evaluation validates the method [assumption]. Structural facts remain independent High/Medium outputs from deterministic parsing.

## 2. Categorical definitions
For concept `c` and session `s`:
- `repo_sites(c)`: distinct DS-002 evidence spans linked by DS-003 rules.
- `on_focus_path(c)`: at least one repo site intersects the user-selected symbol/path.
- `gap_attempts(c)`: attempts with at least one cited `missing` or `unsupported` evaluation claim for `c`.
- `eligible(c)`: `repo_sites(c) > 0 AND gap_attempts(c) > 0` (INV-002).
- `learner_signal(c)`: `REPEATED_GAP` when at least two distinct attempts qualify; otherwise `OBSERVED_GAP`. This is an observation about submitted explanations, not knowledge.
- `repository_relevance(c)`: `FOCUS_PATH` when `on_focus_path(c)`; otherwise `REPOSITORY_PRESENT`.

No personal gap item exists when `eligible(c)` is false. Unknown initial learner state stays unknown.


## 3. Equation registry
Stable IDs never renumber; changes increment method version.

| ID | Output | Formula / categorical method | Inputs | Confidence | Features |
|---|---|---|---|---|---|
| **EQ-001** | Intake manifest counts | `file_count=|accepted files|`; `line_count=sum physical lines`; `byte_count=sum fetched accepted bytes` before parsing | DS-001 | High when fetch manifest is complete | F-005 |
| **EQ-002** | Structural graph counts | `symbol_count=|published symbols|`; `edge_count=|published edges where evidence_refs != ∅|`; group by declared edge type | DS-002 | High on validated fixture; otherwise Medium | F-001 |
| **EQ-003** | Concept repository exposure | `repo_sites(c)=|distinct (file_hash, span) in DS-003 for c|`; `repository_relevance=FOCUS_PATH` iff any site intersects selected path, else `REPOSITORY_PRESENT` | DS-002, DS-003, DS-004 | Medium because taxonomy rules are [assumption] |
| **EQ-004** | Question progress | `completed = distinct question_ids with accepted attempt`; `total = 3`; render `completed of 3`, never a comprehension percentage | DS-005, DS-006 | High for progress only; says nothing about understanding | F-004 |
| **EQ-005** | Gap eligibility, learner signal, and priority | Eligibility and matrix below; stable sort by tier then `concept_id`; no numeric score | DS-003, DS-004, DS-006, DS-007 | Low while model evaluation is unvalidated; render categories + evidence, not rank number | F-003, F-004 |
| **EQ-006** | Evidence citation count | `|distinct evidence_span_id|` on an artifact after citation validation | DS-002, DS-005, DS-007 | Same as weakest artifact input | F-002, F-004 |
| **EQ-101** | Future comprehension delta category | For changed concept evidence set `C_new`: `NEW_UNTESTED = C_new - concepts_with_attempt_evidence`; `REOPENED = C_new ∩ prior_gap_concepts`; no magnitude/score | DS-008, future versioned learner data | Low until future method validation | F-101, **future only** |

### EQ-005 priority matrix
Only eligible concepts enter the matrix.

| Repository relevance | Learner signal | `priority_tier` | Reason code |
|---|---|---|---|
| FOCUS_PATH | REPEATED_GAP | NEXT | `focus_path_repeated_gap` |
| FOCUS_PATH | OBSERVED_GAP | NEXT | `focus_path_observed_gap` |
| REPOSITORY_PRESENT | REPEATED_GAP | SOON | `repository_repeated_gap` |
| REPOSITORY_PRESENT | OBSERVED_GAP | LATER | `repository_observed_gap` |

These are product rules [assumption], not empirical learning science and not a claim about the learner. The UI must show the reason code in plain language and links to both evidence classes.

### Evaluation-to-signal boundary
GPT-5.6 returns candidate `EvaluationClaim` objects. Before DS-007 admits them, deterministic validators require: known question, target concept from that question, allowed disposition, and evidence IDs present in the question packet. A `missing` claim means a target claim was absent from this response; `unsupported` means this response asserted something contradicted or not supported by the supplied evidence. Neither means the person lacks knowledge outside the submitted response.

## 4. Dataset / input registry
| ID | Input / dataset | Source | Access & license | Confidence tier |
|---|---|---|---|---|
| **DS-001** | Bounded snapshot manifest: paths, byte/line counts, hashes, revision | Read-only sample/public repository intake | Source repository license; transient processing only [assumption] | High if immutable revision and complete fetch |
| **DS-002** | Symbols, exact edges, source spans | Deterministic Tree-sitter analyzer | Internal derived data; parser/grammar licenses to verify at scaffold | High on supported fixtures; Medium otherwise |
| **DS-003** | Concept evidence and rule IDs | Versioned deterministic taxonomy rules [assumption] | Internal rules | Medium until rules are validated |
| **DS-004** | User-selected symbol/path | Session interaction | User-provided interaction, ephemeral | High as an event; not learner knowledge |
| **DS-005** | Question targets and evidence packet manifest | Validated GPT-5.6 output + deterministic packet builder | Model terms/config to verify [assumption] | Low for pedagogical quality; High for packet membership |
| **DS-006** | Teach-back attempts and completion events | Learner submission | User content, session-confidential, 24h [assumption] | High as submitted text/event; not truth |
| **DS-007** | Validated claim dispositions and citations | GPT-5.6 structured evaluation after deterministic validation | User/model-derived, session-confidential | Low until benchmarked against human labels |
| **DS-008** | Versioned code-change evidence and longitudinal learner records | Future local sidecar + learner graph | Not designed; future consent/privacy decision required | Low / future only |

## 5. Worked examples
### Eligible gap
Concept `async-control-flow` has two DS-003 source spans. One lies on the selected path (DS-004). One validated attempt (DS-006/DS-007) has a cited `missing` claim. EQ-005 produces `FOCUS_PATH + OBSERVED_GAP → NEXT` with Low confidence. UI: “Try this next because it appears on your traced path and your latest explanation did not cover the cited behavior.” It does not show a score or say the learner does not understand async code.

### Ineligible item
A concept exists in DS-003 but there is no teach-back attempt. EQ-005 fails `eligible(c)` and emits no `GapItem`. It may appear as a repository concept, clearly separate from personal gaps.

### Rejected number
“82% understood” has no valid equation or dataset and implies a mastery construct. It must not ship. A model-generated priority number is equally invalid.

## 6. Traceability and tests
| Feature | Displayed derivations | Required checks |
|---|---|---|
| F-001 | EQ-002, EQ-006 | Recompute graph counts; assert every counted edge has file/line evidence |
| F-002 | EQ-006 | All narrative citations resolve; no uncited structural prose |
| F-003 | EQ-003, EQ-005 | Property: no item without DS-003 and DS-006/DS-007; matrix output exact |
| F-004 | EQ-004–EQ-006 | Progress is event count only; evaluation shows categories/citations, no score |
| F-005 | EQ-001 | Manifest counts reproduce from accepted files and enforce bounds |
| F-101 | EQ-101 | Future-only; cannot appear in MVP builds |

Every API response displaying a derived value includes `{equation_id, equation_version, input_dataset_ids, derivation_id, confidence}`. UI snapshot tests forbid `% understood`, `mastery`, `fully understands`, bare ranks, and unregistered counts. Any new number/category requires a new EQ and DS entry before implementation.