# Documentation Index — X-Ray for AI Code

**Maintained by:** Abu · **Last updated:** 2026-07-18 · **FMD:** 4.2.0

## 0. Source-of-truth map
| Concern | Canonical owner |
|---|---|
| Live truth, pivots, immutable IDs | [Decision Ledger](DECISION-LEDGER.md) |
| Problem, segment, feature/invariant origin | [idea.md](../idea.md) |
| Build context and rubric | [context.md](../context.md) |
| Brand and voice | [brand.md](../brand.md) |
| Product, journeys, F/BR/INV IDs | [PRD](prd.md) |
| Architecture and topology | [System Design](system-design.md) |
| Algorithms/modules | [Technical Design](technical-design.md) |
| API contracts | [API Spec](api-spec.md) |
| Entities, retention, privacy | [Data Model](data-model.md) |
| Ranking/count equations and confidence | [Methods](methods.md) |
| UI tokens, components, states, copy | [Design System](design-system.md) |
| Tests and traceability | [QA Plan](qa-test-plan.md) |
| Auth, threats, compliance | [Security](security-compliance.md) |
| Build sequence | [Implementation Plan](implementation-plan.md) |
| Build-time agent roster | [SAD](sad.md) |
| Deployment and incidents | [Ops](ops.md) |
| Release and validation | [Release/GTM](release-gtm.md) |
| Demo narrative and Q&A | [Pitch Kit](pitch-kit.md) |
| Contributor orientation | [Onboarding](onboarding.md) |
| Locked-doc changes | [Change Records](change-record.md) |
| Significant technical decisions | [ADRs](adr/) |
| Researched architecture recommendation | [Architecture Research](../architecture-research.md) |

## 1. Suite status
All listed documents are **planning-ready**. Assumptions remain explicitly marked; implementation evidence will move them in the Decision Ledger. Start with the ledger, PRD, implementation plan, and QA plan.

## 2. Health check
- [x] Every F-001–F-005 has tests; F-101–F-104 are traced and deferred.
- [x] INV-001–003 each reach PRD, security, design banned-copy, and QA negative tests.
- [x] API-001–108 declare auth/authz.
- [x] Every displayed rank/count is owned by EQ-### / DS-### methods.
- [x] Current architecture is two repos; local-first MCP App remains proposed only.
- [ ] Replace repository IDs, exact commands, pinned versions, and measured limits during scaffold.
