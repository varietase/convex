# QA — Test Plan & Test Cases — X-Ray

## Strategy and environments
Unit-test parser/rules/methods; contract-test BFF↔FastAPI; integration-test model schema/citations; Playwright-style E2E [assumption] for sample flow; manual accessibility and demo rehearsal. Run locally, preview, and judging production with synthetic public fixtures only. Secrets never enter fixtures.

## Traceability matrix
| F-ID | Test cases | Type | MVP status |
|---|---|---|---|
| F-001 | TC-001, TC-002, TC-003 | unit/integration | required |
| F-002 | TC-004, TC-005 | e2e/a11y | required |
| F-003 | TC-006, TC-007 | unit/e2e | required |
| F-004 | TC-008, TC-009 | integration/e2e | required |
| F-005 | TC-010, TC-011 | security/e2e | required |
| F-101 | TC-101 | contract | deferred |
| F-102 | TC-102 | contract | deferred |
| F-103 | TC-103 | privacy | deferred |
| F-104 | TC-104 | contract | deferred |

## MVP cases
- **TC-001 / F-001:** parse pinned TS/JS fixture; every rendered import/call edge resolves to existing symbols and non-empty exact source spans.
- **TC-002 / F-001:** inject ambiguous/dynamic call; edge is omitted with “not enough evidence.” Rendered-edge observed precision must be **100%**; ≥70% is supported-edge recall/coverage only.
- **TC-003 / F-001:** graph counts reproduce EQ-002 and cite DS-002.
- **TC-004 / F-002:** selected symbol persists across source/pseudocode/path/concept zoom; narrative structural sentences cite existing edge/span IDs.
- **TC-005 / F-002:** keyboard-only user traverses graph and equivalent path list; focus, labels, reduced motion, and contrast pass manual checks.
- **TC-006 / F-003:** property test: no GapItem unless repo evidence and validated attempt evidence are both non-empty; EQ-005 matrix output is exact.
- **TC-007 / F-003:** UI shows reason/derivation and no mastery, “fully understands,” percentage, or generic top-N copy.
- **TC-008 / F-004:** question generation returns exactly three repo-specific questions with valid concept/span IDs.
- **TC-009 / F-004:** fabricated citation or structural claim is rejected; valid answer returns supported/missing/unsupported claims and updates gaps deterministically.
- **TC-010 / F-005:** bundled sample and one bounded immutable public fixture complete intake→edge→teach-back→gap; sample remains labeled.
- **TC-011 / F-005:** private IP, redirect, traversal, symlink, nested archive, oversize, timeout, and unsupported language fail closed and clean workspace.

## Invariant negative tests
| INV-ID | Negative tests | Pass condition |
|---|---|---|
| INV-001 | TC-N01 model invents edge; TC-N02 evidence removed | Edge never renders; analysis quarantined |
| INV-002 | TC-N03 generic concept; TC-N04 attempt evidence missing | Gap never renders |
| INV-003 | TC-N05 scan/runtime probe for writes, tokens, git mutation | No write path, credential, commit, or PR exists |

## API/security/ops gates
Two sessions cannot cross-read; CSRF/origin and BFF credential checks pass; rate limits return 429; API-001–108 schemas match; logs contain no source/answers/prompts/secrets; TTL/delete cascades; backend restart returns honest 410; API-010 and sample smoke test pass after rollback.

## Exit criteria
All MVP and invariant cases pass; no critical/high security defect; sample E2E passes three times in production; public fixture succeeds once; fallback rehearsed; final-feature tests remain skipped with reasons, not falsely green.
