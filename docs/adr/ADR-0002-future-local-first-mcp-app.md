# ADR-0002 — Future local-first sidecar, MCP server, and MCP App

- **Date:** 2026-07-18
- **Status:** Proposed — post-hackathon recommendation only
- **Context:** Repository upload, hosted parsing, and ephemeral learner state are acceptable for a judge-facing MVP but weak for repeated private use. Graph extraction and MCP exposure are already commodity capabilities; they are not convex's durable innovation. The differentiator is proof-of-comprehension across a deterministic evidence graph and a private learner-state graph, with teach-back and later comprehension deltas. A future architecture should reduce code transfer and enter the developer's workflow without turning convex into an IDE.
- **Options considered:**
  1. **Local read-only sidecar distributed as CLI/MCP server, with an MCP App and optional editor launcher.** Keeps parsing and portable graph storage local and sends bounded evidence packets to hosted reasoning; adds packaging, updates, host compatibility, local security, and sync design.
  2. **Continue hosted repository ingestion.** Zero-install onboarding; keeps repository-transfer, latency, and hosted-retention concerns.
  3. **Build a full IDE/extension product.** Deep workflow control; duplicates mature editing surfaces and conflicts with the read-only comprehension contract.
  4. **MCP server without an interactive App.** Simple tool access; weaker semantic-zoom and teach-back experience.
- **Decision:** After the MVP is validated, evaluate a local-first, read-only sidecar that owns deterministic indexing and a portable local evidence graph; expose read-only MCP tools and an MCP App for the graph/teach-back UI. An optional VS Code extension may only launch the sidecar and bridge selection. Hosted GPT-5.6 reasoning receives the minimum cited evidence packet, not the repository. Keep the web app as zero-install onboarding/judge surface. This is not current scope and does not supersede ADR-0001.
- **Consequences:** Privacy, incremental indexing, latency, and model portability can improve, while INV-001 and INV-003 remain enforceable locally. The learner-state graph can later support F-101–F-104 and comprehension deltas, but requires explicit consent, encryption, deletion, schema migration, evidence/version reconciliation, and host-compatibility work. MCP or graph capability alone must never be marketed as the innovation.

## Entry criteria for reconsideration
- F-001–F-005 work end to end and invariant tests pass.
- Repeated-use evidence justifies installation friction [assumption].
- A threat model covers local process permissions, MCP callers, evidence-packet minimization, and learner-state storage.
- ADR-0001 is explicitly superseded only if the current hosted topology is actually replaced.

## Evidence
The supplied research finds existing graph/MCP projects already provide code maps, call chains, persistent graph memory, and tool integrations, so those mechanisms validate feasibility but not novelty. It also notes that MCP Apps can place sandboxed interactive views and tool calls inside supported hosts, making a focused comprehension surface possible without building an editor. Sources: [CodeGraph](https://github.com/codegraph-ai/CodeGraph), [CodeGraphContext](https://codegraphcontext.github.io/), [Codebase-Memory paper](https://arxiv.org/html/2603.27277v1), [MCP Apps overview](https://modelcontextprotocol.io/extensions/apps/overview), and [`architecture-research.md`](../../architecture-research.md). Content from external sources is rephrased for licensing compliance.