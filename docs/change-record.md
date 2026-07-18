# Change Records — X-Ray

## CR-001 — Solution spine and FMD suite
- **Status:** Locked for hackathon planning
- **Date:** 2026-07-18
- **Owner:** Abu
- **Change:** Expanded problem-only `idea.md` with F-001–005 MVP, F-101–104 final vision, value proposition, and success metrics; generated the FMD suite.
- **Reason:** FMD required stable feature IDs; the team needed an executable plan before the Manila sprint.
- **Architecture:** Kept the user-provided Vercel client + Hugging Face FastAPI/LangChain/LangGraph backend. Added local-first MCP App architecture only as proposed ADR-0002.
- **Innovation:** Defined X-Ray as proof-of-comprehension—deterministic code evidence joined to demonstrated learner state—not explain-code, graph visualization, MCP, or an IDE alone.
- **Invariants touched:** INV-001 kept; INV-002 kept; INV-003 kept.
- **Docs affected:** `idea.md`, `context.md`, `brand.md`, `architecture-research.md`, and all `/docs` artifacts.
- **Validation required:** F/INV traceability, architecture consistency, API auth, methods transparency, design banned-copy, and QA exit gates.

Future changes append CR-002+. Never rewrite this record; supersede it.
