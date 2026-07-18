# Architecture and product-surface research — convex

**Status:** researched recommendation, 2026-07-18. The current two-repository implementation remains authoritative for the hackathon; this document recommends what to change only after the demo.

## 1. Current baseline: keep it for this build
A Vercel web client plus a Hugging Face Docker Space running FastAPI/LangChain/LangGraph is a reasonable hackathon split. It separates the polished demo from CPU/model orchestration, lets the backend use a custom Docker image, and leaves a path to GPU hardware. Hugging Face officially supports FastAPI in Docker Spaces, runtime secrets, one externally exposed port, and attached Storage Buckets when persistence is needed. Space-local disk is ephemeral and disappears on restart, so the MVP must treat analysis state as disposable or attach external storage later. [Hugging Face Docker Spaces](https://huggingface.co/docs/hub/spaces-sdks-docker) · [Spaces storage](https://huggingface.co/docs/hub/spaces-storage)

The cost is operational: two deploys, cross-origin API calls, backend cold starts, repository transfer, and no durable learner state by default. For the judged demo, mitigate rather than re-platform: use a bundled/pre-indexed sample, bound public-repository intake, expose one FastAPI port, stream stage progress, and show an honest retry state. Do not host a large custom LLM merely because the backend lives on Hugging Face; call GPT-5.6 for graph-grounded narrative and teach-back while keeping graph extraction deterministic.

## 2. What is already commodity
A semantic code graph is not the durable innovation. CodeGraph already exposes functions, classes, imports, call chains, impact analysis, MCP tools, a VS Code extension, and persistent memory across dozens of languages. CodeGraphContext similarly combines Tree-sitter/SCIP extraction with graph storage, HTTP, CLI, and MCP. A 2026 peer-reviewed Codebase-Memory system reports a persistent Tree-sitter graph over 66 languages, MCP tools, and large token savings. These validate the architecture but erase any claim that “graph + MCP” alone is novel. [CodeGraph](https://github.com/codegraph-ai/CodeGraph) · [CodeGraphContext](https://codegraphcontext.github.io/) · [Codebase-Memory paper](https://arxiv.org/html/2603.27277v1)

Tree-sitter is suitable for fast syntax extraction and `tree-sitter-graph` can construct graph structures, but precise cross-language calls/data flow remain difficult. For the hackathon, support one language family deeply (TypeScript/JavaScript first [assumption]) and omit ambiguous edges rather than advertise broad but weak coverage. [tree-sitter-graph](https://github.com/tree-sitter/tree-sitter-graph)

## 3. Recommended future architecture — suggest only, do not implement now
Move deterministic indexing to a **local-first read-only sidecar** distributed as an MCP server/CLI, with an optional VS Code extension only as a launcher and selection bridge. Keep the existing web app as the zero-install judge/onboarding surface. The local sidecar parses the working tree, stores a portable local graph, and sends only selected evidence slices—not the repository—to the hosted reasoning service. This improves privacy, latency, incremental indexing, and model portability while preserving INV-001 and INV-003.

Expose the interactive graph as an **MCP App**, not a new IDE. The official MCP Apps extension lets tools return sandboxed interactive HTML with bidirectional tool calls inside supported hosts, explicitly covering rich data exploration. Current support includes Claude, Claude Desktop, VS Code GitHub Copilot, Microsoft 365 Copilot, Goose, Postman, MCPJam, and Archestra. This makes convex ambient inside coding conversations without owning editing, terminals, or agent execution. [Official MCP Apps overview](https://modelcontextprotocol.io/extensions/apps/overview)

## 4. Durable innovation as models improve
The moat is a two-graph system: **code evidence graph** (what the repository objectively contains) + **learner-state graph** (what this human has demonstrated they can explain). The second graph cannot be copied from the repository or made obsolete by a stronger coding model. Stronger agents create more code and therefore more comprehension deltas.

Build the progression around four compounding primitives: (1) evidence-backed semantic zoom; (2) active teach-back instead of passive prose; (3) comprehension delta after each agent change; (4) an agent teaching contract that asks what the user needs explained before/after a change. The longitudinal dataset is not “all code”; it is a private history of claims attempted, concepts demonstrated, misconceptions, evidence paths, and change-induced gaps.

## 5. Decision
**Now:** two repos; Cloudflare Workers client; Hugging Face Docker Space; FastAPI + minimal LangChain/LangGraph; deterministic parser; GPT-5.6 only for narrative/question/evaluation; pre-indexed fallback. **Later:** local-first graph sidecar + MCP server + MCP App, with hosted reasoning receiving bounded evidence packets. Do not build a new IDE and do not claim the graph itself as the innovation.

Content from external sources was rephrased for licensing compliance.
