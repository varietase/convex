# Data Model / Schema — X-Ray

> **Purpose:** Exact logical data model for ephemeral MVP analysis and learner evidence. Storage technology is not prescribed [assumption].

## Entities & relationships (ERD)
```text
AnalysisSession 1--* RepositorySnapshot
RepositorySnapshot 1--* SourceFile
RepositorySnapshot 1--* Symbol
RepositorySnapshot 1--* EvidenceEdge
RepositorySnapshot 1--* ConceptEvidence
RepositorySnapshot 1--* NarrativeArtifact
SourceFile 1--* SourceSpan
EvidenceEdge *--* SourceSpan
ConceptEvidence *--* SourceSpan
AnalysisSession 1--* TeachBackQuestion
TeachBackQuestion 1--* TeachBackAttempt
TeachBackAttempt 1--* EvaluationClaim
AnalysisSession 1--* LearnerConceptState
AnalysisSession 1--* GapItem
GapItem *--* ConceptEvidence
GapItem *--* TeachBackAttempt
Any derived entity 1--1 DerivationRecord
AnalysisSession 1--* JobEvent
```

Code evidence and learner evidence remain separate. A `GapItem` is a derived join, never a free-standing model opinion.

## Schema / field definitions
Conventions: `uuid` is opaque UUIDv4 [assumption]; `datetime` is RFC 3339 UTC; hashes use SHA-256 [assumption]; line numbers are 1-based and columns 0-based.

### AnalysisSession
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `session_id` | uuid | no | generated | Ephemeral authorization boundary |
| `bff_csrf_hash` | string | yes | null | BFF-only CSRF hash; null in backend session projection [assumption] |
| `created_at` | datetime | no | now | Creation time |
| `expires_at` | datetime | no | +24h | Hard TTL [assumption] |
| `status` | enum | no | active | `active`, `deleting`, `expired` |
| `schema_version` | string | no | — | Data-contract version |


### RepositorySnapshot
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `snapshot_id` | uuid | no | generated | Immutable analysis input ID |
| `session_id` | uuid | no | — | Owner |
| `source_kind` | enum | no | — | `sample`, `public_repo` |
| `canonical_url` | string | yes | null | Public HTTPS URL, stripped of query/user-info |
| `revision` | string | no | — | Sample version or full commit SHA [assumption] |
| `manifest_hash` | sha256 | no | — | Sorted file-path/content-hash manifest |
| `language_family` | string | no | `typescript-javascript` | Only deeply supported MVP family [assumption] |
| `analyzer_version` | string | no | — | Pinned deterministic extractor |
| `status` | enum | no | queued | Lifecycle status |
| `created_at`, `expires_at` | datetime | no | — | TTL boundary |

### SourceFile
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `file_id` | uuid | no | generated | File record ID |
| `snapshot_id` | uuid | no | — | Parent |
| `normalized_path` | string | no | — | Relative POSIX path; no `..` |
| `content_hash` | sha256 | no | — | Binds spans to analyzed bytes |
| `language` | enum | no | — | `typescript`, `tsx`, `javascript`, `jsx` [assumption] |
| `line_count` | integer | no | — | Physical lines, EQ-001 input |
| `parse_status` | enum | no | parsed | `parsed`, `partial`, `unsupported` |

Full source files exist only in the transient workspace. The backend persists only bounded cited excerpts on `SourceSpan` until session TTL [assumption], sufficient to render file/line evidence and build later model packets without re-fetching the repository.

### SourceSpan
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `span_id` | uuid | no | generated | Evidence location ID |
| `file_id` | uuid | no | — | File whose hash validates span |
| `start_line`, `end_line` | integer | no | — | Inclusive 1-based lines |
| `start_column`, `end_column` | integer | no | — | 0-based UTF-8 byte columns [assumption] |
| `span_kind` | enum | no | — | declaration, import, call, concept, context |
| `node_type` | string | no | — | Parser node type |
| `excerpt_text` | string | no | — | Bounded cited lines only; max 2 KiB UTF-8 per span [assumption] |
| `excerpt_hash` | sha256 | no | — | Hash of excerpt bytes for integrity |

### Symbol
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `symbol_id` | uuid | no | generated | Stable within snapshot |
| `snapshot_id` | uuid | no | — | Parent snapshot |
| `qualified_name` | string | no | — | Deterministic path/scope/name |
| `symbol_kind` | enum | no | — | module, function, class, method, variable |
| `declaration_span_id` | uuid | no | — | Concrete source declaration |
| `export_kind` | enum | no | none | none, named, default |

### EvidenceEdge
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `edge_id` | uuid | no | generated | Structural edge ID |
| `snapshot_id` | uuid | no | — | Parent snapshot |
| `edge_type` | enum | no | — | imports, calls, contains |
| `from_symbol_id`, `to_symbol_id` | uuid | no | — | Existing endpoints |
| `evidence_span_ids` | uuid[] | no | — | Non-empty concrete proof (INV-001) |
| `extractor_rule_id` | string | no | — | Deterministic rule/version |
| `resolution` | enum | no | exact | Only `exact` renders; ambiguity is omitted |

### ConceptEvidence
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `concept_evidence_id` | uuid | no | generated | Repository-side concept fact |
| `snapshot_id`, `concept_id` | uuid/string | no | — | Snapshot and stable taxonomy key |
| `symbol_ids`, `evidence_span_ids` | uuid[] | no | — | Both arrays non-empty |
| `rule_id`, `rule_version` | string | no | — | Versioned categorical mapping [assumption] |

### NarrativeArtifact
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `narrative_id` | uuid | no | generated | Model artifact ID |
| `session_id`, `snapshot_id` | uuid | no | — | Authorization and source |
| `kind` | enum | no | — | pseudocode, module_role, path_explanation |
| `text` | string | no | — | Validated output |
| `evidence_span_ids` | uuid[] | no | — | Non-empty `SourceSpan.span_id` citations; API expands to `EvidenceRef` |
| `model_id`, `prompt_version` | string | no | — | GPT-5.6 configuration [assumption] |
| `created_at`, `expires_at` | datetime | no | — | TTL |

### TeachBackQuestion
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `question_id`, `question_set_id` | uuid | no | generated | Question identity/group |
| `session_id`, `snapshot_id` | uuid | no | — | Owner/source |
| `ordinal` | integer | no | — | 1, 2, or 3 |
| `question_type` | enum | no | — | prediction, explanation |
| `prompt` | string | no | — | Repo-specific prompt |
| `target_concept_ids`, `target_evidence_span_ids` | string[]/uuid[] | no | — | Both non-empty; span IDs expand to API evidence refs |
| `model_id`, `prompt_version` | string | no | — | Reproducibility metadata |
| `created_at`, `expires_at` | datetime | no | — | TTL |

### TeachBackAttempt
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `attempt_id`, `question_id`, `session_id` | uuid | no | generated/— | Attempt, question, owner |
| `response_text` | string | no | — | Learner submission; max 4,000 chars [assumption] |
| `submitted_at`, `expires_at` | datetime | no | — | TTL |
| `evaluation_status` | enum | no | pending | pending, validated, unavailable |
| `model_id`, `rubric_version` | string | yes | null | Set when evaluated |

### EvaluationClaim
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `claim_id`, `attempt_id` | uuid | no | generated/— | Finding identity |
| `disposition` | enum | no | — | supported, missing, unsupported |
| `claim_text`, `feedback_text` | string | no | — | Critique of response, not person |
| `concept_ids` | string[] | no | — | Non-empty target concepts |
| `evidence_span_ids` | uuid[] | no | — | Non-empty `SourceSpan.span_id` graph citations; API expands to `EvidenceRef` |
| `confidence` | enum | no | low | Low until method validation [assumption] |

### LearnerConceptState
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `state_id`, `session_id` | uuid | no | generated/— | Session-scoped learner evidence |
| `concept_id` | string | no | — | Taxonomy key |
| `learner_signal` | enum | no | — | observed_gap, repeated_gap; never mastery |
| `repository_relevance` | enum | no | — | focus_path, repository_present |
| `attempt_ids`, `concept_evidence_ids` | uuid[] | no | — | Both non-empty |
| `updated_at`, `expires_at` | datetime | no | — | TTL |
| `derivation_id` | uuid | no | — | EQ-005 resolution |

### GapItem
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `gap_item_id`, `session_id` | uuid | no | generated/— | Personalized item |
| `concept_id` | string | no | — | Eligible concept |
| `priority_tier` | enum | no | — | next, soon, later |
| `repo_evidence_ids`, `attempt_evidence_ids` | uuid[] | no | — | Both non-empty (INV-002) |
| `reason_codes` | string[] | no | — | Transparent categorical causes |
| `derivation_id`, `expires_at` | uuid/datetime | no | — | Method trace and TTL |

### DerivationRecord
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `derivation_id` | uuid | no | generated | Glass-box trace |
| `equation_id`, `equation_version` | string | no | — | `methods.md` method |
| `input_dataset_ids` | string[] | no | — | DS references |
| `input_record_ids` | uuid[] | no | — | Exact records used |
| `confidence` | enum | no | — | high, medium, low by rubric |
| `created_at`, `expires_at` | datetime | no | — | TTL |

### JobEvent
| Field | Type | Null? | Default | Description |
|---|---|---:|---|---|
| `event_id`, `session_id`, `job_id` | uuid | no | generated/— | Stream identity/owner |
| `stage` | enum | no | — | queued, fetching, parsing, indexing, reasoning, ready, failed |
| `message_code` | string | no | — | Client-localizable, no source text |
| `occurred_at`, `expires_at` | datetime | no | — | Replay/TTL |

## Constraints & indexes
- Foreign keys cascade on session deletion. No entity may outlive `AnalysisSession.expires_at` except sanitized aggregate metrics.
- Unique: `(snapshot_id, normalized_path)`, `(snapshot_id, qualified_name, declaration_span_id)`, `(question_set_id, ordinal)`, `(session_id, concept_id)` for current learner state.
- Check: every `EvidenceEdge.evidence_span_ids` is non-empty, each cited span belongs to the same snapshot, and every retained excerpt matches its excerpt hash and 2 KiB bound; enforced before publication and at persistence (INV-001).
- Check: every `GapItem` has non-empty repository and attempt evidence arrays, and referenced attempts belong to the same session/snapshot lineage (INV-002).
- Check: `ordinal BETWEEN 1 AND 3`; exactly three questions per completed set.
- Index: resource ownership `(session_id, id)`, TTL `expires_at`, graph adjacency `(snapshot_id, from_symbol_id, edge_type)` and `(snapshot_id, to_symbol_id, edge_type)`, concept joins `(snapshot_id, concept_id)`.
- No source mutation entity, provider token, write scope, commit, branch, or PR model exists (INV-003).

## Retention & privacy classification
| Records | Classification | Retention [assumption] | Deletion |
|---|---|---|---|
| Transient repository workspace | Public-derived but treated confidential | Until parse completes; hard maximum 15 minutes | `finally` cleanup + periodic sweeper |
| Session, graph, bounded cited excerpts, narratives, questions, responses, learner state, gaps, derivations, events | Session-confidential | 24 hours from session creation | API-009 or TTL cascade |
| Pre-indexed sample graph/questions | Public deployment artifact | Until replaced by a versioned sample | Deployment replacement |
| Sanitized security/operations logs | Internal | 7 days | Platform retention policy |
| Anonymous aggregate counters with no session/repo/answer/source fields | Internal | 30 days | Scheduled deletion |
| Credentials | Secret | Until rotation | Secret-store replacement/revocation |

Repository source, learner response, model prompt packet, cookie, CSRF token, IP address, and URL query strings must not be logged. IP may exist transiently in platform abuse controls; provider defaults must be reviewed [assumption].

## Migration notes
MVP data is disposable. Schema changes increment `schema_version`; incompatible in-memory/session data is expired rather than backfilled. Sample artifacts declare schema/analyzer/rule/equation versions and fail deployment smoke tests if incompatible. Future durable learner state requires a new ADR, explicit migration/rollback, consent, export, and deletion design; it is not implied by this schema.