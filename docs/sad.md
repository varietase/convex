# SAD — Build-time agent roster

## Rules
Four agents only; each justifies its slot by repeated work, context offload, or guardrail enforcement. They implement the current two-repo MVP and never build F-101–104 without a logged decision.

### graph-engineer
- **model:** deep · **tools:** read, write, shell
- **Purpose:** implement deterministic JS/JSX/TS/TSX extraction, evidence spans, fixtures, and graph APIs.
- **Reads:** PRD, technical design, methods, QA.
- **Guardrails:** never use GPT to create edges; never emit ambiguity; never execute or mutate repo code (INV-001/003).
- **Done:** TC-001–003, TC-010/011, TC-N01/N02/N05 pass.

### product-ui-engineer
- **model:** balanced · **tools:** read, write, shell
- **Purpose:** build semantic zoom, accessible graph/path-list, teach-back, and gap UX.
- **Reads:** PRD, design system, API spec.
- **Guardrails:** never add edit/apply/commit actions; never hide sample/fallback; never show mastery or uncited claims.
- **Done:** TC-004/005/007 and production demo flow pass.

### reasoning-engineer
- **model:** deep · **tools:** read, write, shell
- **Purpose:** implement minimal LangChain/LangGraph typed GPT-5.6 narrative/question/evaluation.
- **Reads:** technical design, methods, API, QA.
- **Guardrails:** model output cannot write graph/concepts/ranks; citation IDs must validate; one retry max; no opaque score (INV-001/002).
- **Done:** TC-006/008/009 and fabricated-citation negatives pass.

### trust-reviewer
- **model:** balanced · **tools:** read, shell
- **Purpose:** repeatedly audit ID traceability, security, copy, logs, and release gates.
- **Reads:** all docs/diffs/tests.
- **Guardrails:** read-only; fail closed; no “looks fine” without named evidence.
- **Done:** every F/INV traces, auth is declared, banned-copy/secret scans pass, sample smoke succeeds.

## Human pairing
Joshua/Farhana own graph/reasoning; Helena/Dia own UI; Abu owns product/demo; Global adds Geinel/Jim for architecture/ops. AI agents assist; named humans make release calls.

## Rejected agents
Separate research, pitch, database, and general agents add coordination cost; their work is bounded and owned by humans/docs.
