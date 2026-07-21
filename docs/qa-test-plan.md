# QA — Test Plan & Test Cases — convex

## Strategy and environments
Unit-test parser/rules/methods and the client’s public repository URL validation/centralized repository state. Once `TASK-005` implements the client API module, contract-test its direct calls against the five FastAPI endpoints. Use Playwright-style E2E [assumption] for the current public-URL onboarding shell, then extend it to the sample loop after live integration. Manual accessibility, visual-token, and demo rehearsal checks remain required. Run locally, preview, and judging production with synthetic public fixtures only. Secrets never enter fixtures.

## Traceability matrix
| F-ID | Test cases | Type | MVP status |
|---|---|---|---|
| F-001 | TC-001, TC-002, TC-003 | unit/integration | required |
| F-002 | TC-004, TC-005 | e2e/a11y | required |
| F-003 | TC-006, TC-007 | unit/e2e | required |
| F-004 | TC-008, TC-009 | integration/e2e | required |
| F-005 | TC-010, TC-011, TC-012 | security/e2e | required |
| F-101 | TC-101 | contract | deferred |
| F-102 | TC-102 | contract | cut from current build; revisit after public/sample loop |
| F-103 | TC-103 | privacy | deferred |
| F-104 | TC-104 | contract | deferred |

## MVP cases
- **TC-001 / F-001:** parse pinned JS/JSX/TS/TSX fixture; every rendered import/call edge resolves to existing symbols and exactly three source-span provenance anchors (source definition, relationship site, target definition).
- **TC-002 / F-001:** inject ambiguous/dynamic call; edge is omitted with “not enough evidence.” Rendered-edge observed precision must be **100%**; ≥70% is supported-edge recall/coverage only.
- **TC-003 / F-001:** graph counts reproduce EQ-002 and cite DS-002.
- **TC-004 / F-002:** selected symbol persists across source/pseudocode/path/concept zoom; narrative structural sentences cite existing edge/span IDs.
- **TC-005 / F-002:** keyboard-only user traverses graph and equivalent path list; focus, labels, reduced motion, documented dark-token contrast pairs, and non-color graph/status encodings pass manual checks.
- **TC-006 / F-003:** property test: no GapItem unless repo evidence and validated attempt evidence are both non-empty; EQ-005 matrix output is exact.
- **TC-007 / F-003:** UI shows reason/derivation and no mastery, “fully understands,” percentage, or generic top-N copy.
- **TC-008 / F-004:** question generation returns exactly three repo-specific questions with valid concept/span IDs.
- **TC-009 / F-004:** fabricated citation or structural claim is rejected; valid answer returns supported/missing/unsupported claims and updates gaps deterministically.
- **TC-010 / F-005:** bundled sample and one bounded immutable public fixture complete intake→edge→teach-back→gap; sample remains labeled.
- **TC-011 / F-005:** private IP, redirect, traversal, symlink, nested archive, oversize, timeout, and unsupported language fail closed and clean workspace.
- **TC-012 / F-005:** clicking **Add Repository Link** from nav/hero/CTA opens the same modal; invalid/empty/non-GitHub URLs disable submission with visible errors; the modal and dashboard show no MCP, private repository, local workspace, OAuth, token-entry, repository-selector, or reconnect controls.

## Invariant negative tests
| INV-ID | Negative tests | Pass condition |
|---|---|---|
| INV-001 | TC-N01 model invents edge; TC-N02 evidence removed | Edge never renders; analysis quarantined |
| INV-002 | TC-N03 generic concept; TC-N04 attempt evidence missing | Gap never renders |
| INV-003 | TC-N05 scan/runtime probe for writes, tokens, git mutation; TC-012 frontend credential-surface scan | No write path, credential, commit, PR, OAuth token storage, private/local connector, or provider mutation UI exists |

## API/security/ops gates
Two sessions cannot cross-read; CORS origin-allowlist checks pass (disallowed origins rejected before body processing); rate limits return 429; the five documented endpoint schemas match; logs contain no source/answers/prompts/secrets; TTL/delete cascades; backend restart returns honest 410; `/health` and sample smoke test pass after rollback.

## Exit criteria
All MVP and invariant cases pass; no critical/high security defect; public repository onboarding passes TC-012; sample E2E passes three times in production; public fixture succeeds once; fallback rehearsed; dark-first visual/accessibility checks pass; final-feature tests remain skipped with reasons, not falsely green.

