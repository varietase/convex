# Prompt — Remove MCP from convex User Flow

You are working in `C:\Users\Helena\varietase`. Read `convex/` for product, architecture, QA, and planning context, then read `client/` for the current Next.js implementation.

## Goal
Remove the MCP repository connection feature from the current system because there is no time to implement or validate it for the hackathon build. The user flow must become public-repository/sample-only.

## Product Decision
- The active build supports only:
  - bundled/pre-indexed demo sample, and
  - bounded public GitHub repository links in the form `https://github.com/{owner}/{repo}`.
- Remove all current user-facing MCP paths, copy, status states, repository selectors, reconnect behavior, private/local repository promises, and MCP placeholder UI.
- Keep the core invariants unchanged:
  - `INV-001`: deterministic structural evidence only.
  - `INV-002`: concept gaps require repository evidence and demonstrated learner evidence.
  - `INV-003`: read-only repository handling.
- Historical/future ADR notes may still mention MCP as deferred architecture, but current product, user flow, QA, and client UI must not present MCP as available.

## Client Scope
Update `client/` so the active app has a single repository intake path:
- Keep `validateGitHubRepositoryUrl` and public repository state.
- Remove `client/lib/mcpClient.ts` if unused.
- Remove `client/components/Mcp/` if unused.
- Replace MCP provider aliases with a public-only `RepositoryProvider`.
- Replace repository onboarding with one modal containing the public GitHub URL form.
- Update dashboard switch flow to reopen the public URL modal only.
- Update landing, hero, CTA, roadmap, preview, and dashboard copy to say public GitHub repository or bundled sample only.
- Confirm `rg -n "MCP|mcp|Mcp|Connect with MCP|local MCP|private/local|private repositories" client -S` returns no active client hits.

## Documentation Scope
Update the user flow and directly affected docs in `convex/docs/`:
- `prd.md`: change UF-000 from hybrid onboarding to public repository onboarding; remove MCP steps and acceptance criteria; state private/local repository access is out of scope for this build.
- `system-design.md`: remove Browser -> local MCP host integration from current architecture/data flow; keep ADR-0002 only as future/historical context if needed.
- `technical-design.md`: remove `lib/mcpClient`, MCP status types, selector states, and MCP handoff algorithm from the current LLD.
- `qa-test-plan.md`: update TC-012 to assert the MCP CTA/placeholder is absent.
- `design-system.md`: remove MCP modal/component states and copy from the current UX spec.
- `implementation-plan.md`, `DECISION-LEDGER.md`, `change-record.md`, and `index.md`: record the scope cut so CR-004 is superseded and future readers do not treat MCP placeholder work as current.

## Acceptance Checks
Run from repo root:
```powershell
rg -n "MCP|mcp|Mcp|Connect with MCP|local MCP|private/local|private repositories" client -S
cd client
npm run typecheck
npm run build
```

Expected result:
- No active client MCP references remain.
- Typecheck passes.
- Build passes or any sandbox-specific build limitation is reported clearly.
- Docs describe a public/sample-only flow for the current build.
