# Design System / UX Spec — X-Ray for AI Code

> **Purpose:** Implementation contract for the judged F-001–F-005 experience. It translates the PRD flows and INV-001–INV-003 into components, tokens, interactions, responsive layouts, accessibility behavior, and a fixed demo path.
> **Current boundary:** Client framework and graph-rendering library are not selected in supplied sources **[assumption]**. The behavior and CSS tokens below are library-independent and binding.

## Design principles
1. **Evidence is the interface.** A connection is not complete until its exact `file:line` proof can be opened. Prose is secondary.
2. **Keep one focus across altitudes.** Hover previews; selection pins. Source, pseudocode, neighborhood, system path, and concepts preserve the same symbol/path context.
3. **Ask for an explanation; do not judge a person.** Feedback describes supported, missing, or unsupported parts of one submitted response.
4. **Graph and text are peers.** Every graph path has an ordered text representation with identical evidence actions; color is never the only carrier.
5. **Fail visibly and safely.** Omit uncertain edges, retain deterministic views when model features fail, label pre-indexed data, and never imply repository writes.

## Experience architecture
The primary loop is `Intake → Focus → Trace → Teach back → Review changed gap list`. Four persistent landmarks keep it legible: top `AppHeader`, left `RepositoryRail`, center `FocusWorkspace`, right `LearningRail`. A `LiveRegion` announces analysis, selection, submission, and gap-list changes without moving focus.

## Complete component inventory
| Component | Purpose and required variants | States / semantics | Data contract |
|---|---|---|---|
| `AppShell` | Global landmarks and responsive pane orchestration | `<header>`, `<nav>`, `<main>`, complementary learning region | Session status |
| `AppHeader` | Product name, sample/read-only status, session actions | Sticky; status uses icon + text; delete is explicit | session, snapshot |
| `ReadOnlyBadge` | Communicates INV-003 before intake and during exploration | Lock icon + “Read-only analysis”; never color-only | source kind |
| `RepoIntake` | Choose bundled sample or bounded public immutable snapshot | idle, validating, rejected, submitting, disabled | API-002 input/errors |
| `SampleBadge` | Prevent fallback/sample deception | Persistent “Pre-indexed sample · {version}” | sample version |
| `AnalysisStepper` | Named work stages; no percentage or fake ETA | queued, fetching, parsing, indexing, ready, failed; `aria-live=polite` | API-003 events |
| `RepositoryRail` | Search/filter supported modules and symbols | loading, populated, no match, collapsed | symbols/modules |
| `SymbolRow` | Focusable symbol entry with kind and source location | default, hover-preview, selected, unavailable | symbol + declaration span |
| `SemanticZoomRail` | Switch Source / Pseudocode / Connections / System path / Concepts | tablist; disabled view explains missing evidence | selection + available views |
| `FocusWorkspace` | Keeps selection stable while view changes | graph, code, narrative, text-path variants | API-004/API-005 |
| `CodePane` | Bounded cited excerpt, line numbers, active span | loading, highlighted, copy-reference; `<pre><code>` | evidence span |
| `EvidenceGraph` | One-hop exact symbols/edges and selected path | keyboard canvas/list composite; never sole representation | symbols, exact edges |
| `GraphNode` | Symbol type, name, file, state | shape + icon + label; focus/selected are distinct | symbol |
| `GraphEdge` | Exact relationship and evidence action | solid line + relationship label + endpoint marker; selected gets double stroke | edge + non-empty refs |
| `GraphLegend` | Explains shape, stroke, icon, and labels | Always available beside graph | static |
| `PathList` | Ordered text equivalent to the selected visual path | `<ol>`; each step names symbol, relation, file:line, evidence button | API-004 `text_path` |
| `EvidenceButton` | Opens proof without changing path | “Show evidence”; has accessible name with relation and location | evidence ref |
| `EvidenceDrawer` | Inspect exact excerpts and extractor provenance | modal on small screens, side drawer otherwise; focus trap/return | refs + derivation |
| `OmittedNotice` | Explains absent/ambiguous relationships | “Not enough evidence”; neutral info, not error | omitted relationships |
| `NarrativePanel` | Cited pseudocode/module/path explanation | loading, ready, model unavailable, rejected output | API-005 sections |
| `ConceptChip` | Repository concept, never a personal gap by itself | repository-present or focus-path; icon + text | concept evidence |
| `TeachBackLauncher` | Starts three repo-specific prompts from current path | disabled until sufficient evidence; reason visible | API-006 eligibility |
| `TeachBackCard` | Prompt, response field, submit action, progress | question 1–3 labels; 1–4,000 chars **[assumption]**; pending/error | question/attempt |
| `ResponseFindings` | Groups feedback about the response | Supported / Missing / Unsupported headings, each with evidence | API-007 claims |
| `GapList` | Categorical Next / Soon / Later items derived from both graphs | pre-attempt empty, unchanged, changed; no numeric rank | API-008 items |
| `GapItem` | Why it appears and where to revisit | reason sentence + repo evidence + attempt evidence + confidence | EQ-005 derivation |
| `DerivationDrawer` | Glass-box method metadata | equation, datasets, version, confidence; disclosure pattern | derivation |
| `StatePanel` | Reusable empty, error, expired, degraded, unsupported UI | heading, plain reason, one primary recovery action | canonical API error |
| `ToastRegion` | Non-blocking confirmations only | `role=status`; never carries required evidence/errors alone | transient UI event |
| `SkipLinks` | Jump to repository, focus, text path, learning rail | First tabbable controls | static |

## CSS token contract
Use these custom properties directly; do not substitute framework defaults without updating this document and visual/contrast tests.

```css
:root {
  color-scheme: dark;
  --xr-canvas: #08101f;
  --xr-surface-1: #0e192b;
  --xr-surface-2: #15233a;
  --xr-surface-3: #1d2d47;
  --xr-border: #60708a;
  --xr-border-subtle: #33445f;
  --xr-text: #f7f9fc;
  --xr-text-muted: #b7c3d4;
  --xr-structure: #74d0ff;
  --xr-evidence: #64e3ba;
  --xr-selected: #c7b8ff;
  --xr-attention: #ffc66d;
  --xr-danger: #ff929c;
  --xr-disabled: #7d899b;
  --xr-overlay: rgb(3 8 17 / 72%);
  --xr-font-sans: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --xr-font-mono: "JetBrains Mono", "SFMono-Regular", Consolas, "Liberation Mono", monospace;
  --xr-text-xs: 0.75rem;
  --xr-text-sm: 0.875rem;
  --xr-text-md: 1rem;
  --xr-text-lg: 1.25rem;
  --xr-text-xl: 1.5rem;
  --xr-text-2xl: 2rem;
  --xr-leading-tight: 1.25;
  --xr-leading-body: 1.55;
  --xr-space-1: 0.25rem;
  --xr-space-2: 0.5rem;
  --xr-space-3: 0.75rem;
  --xr-space-4: 1rem;
  --xr-space-6: 1.5rem;
  --xr-space-8: 2rem;
  --xr-space-12: 3rem;
  --xr-radius-sm: 0.375rem;
  --xr-radius-md: 0.625rem;
  --xr-radius-lg: 1rem;
  --xr-border-width: 1px;
  --xr-selected-width: 3px;
  --xr-focus-ring: 0 0 0 3px #08101f, 0 0 0 5px #ffc66d;
  --xr-shadow-raised: 0 12px 32px rgb(0 0 0 / 28%);
  --xr-control-height: 2.75rem;
  --xr-header-height: 3.5rem;
  --xr-rail-repo: 17.5rem;
  --xr-rail-learn: 22.5rem;
  --xr-duration-fast: 120ms;
  --xr-duration-base: 180ms;
  --xr-ease: cubic-bezier(.2, .8, .2, 1);
}

*:focus-visible { outline: none; box-shadow: var(--xr-focus-ring); }
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { scroll-behavior: auto !important; transition-duration: 1ms !important; animation-duration: 1ms !important; animation-iteration-count: 1 !important; }
}
```

### Type, spacing, elevation
- Body is `16px/1.55`; supporting labels are at least `12px/1.4`; code is `14px/1.55`. Do not place essential evidence below 12px.
- Use only token spacing. Dense graph labels may use 4/8px; forms and cards use 12/16/24px.
- Use elevation only for drawers, modals, and pinned previews. Selection uses border/stroke, not shadow.
- Control and pointer target minimum is `44×44px`; graph nodes need at least a 44px hit target even when their visual mark is smaller.

## Graph encoding without color
| Meaning | Visual encoding | Text equivalent |
|---|---|---|
| Module | Rounded rectangle + folder icon + “Module” in accessible name | `Module: {name}` |
| Function/method | Rectangle + `ƒ` icon + kind label | `Function: {qualified_name}` |
| Class | Hexagonal end-caps or class icon + kind label | `Class: {qualified_name}` |
| `calls` edge | Solid line, arrowhead, visible “calls” label | `{A} calls {B}` |
| `imports` edge | Dashed line, arrowhead, visible “imports” label | `{A} imports {B}` |
| `contains` edge | Dotted line, bracket endpoint, visible “contains” label | `{A} contains {B}` |
| Hover preview | 2px outline + preview card; no path mutation | “Previewing {name}” live announcement |
| Pinned selection | 3px double outline + pin icon + “Selected” badge | `aria-current=true` on matching row/step |
| Exact evidence | Document icon + `file:line` + “Exact evidence” | Evidence button on the path step |
| Omitted relation | No edge; neutral notice with broken-link icon | “Not enough evidence to connect …” |

Never encode edge type, selection, evidence, or feedback disposition by hue alone. `GraphLegend` and `PathList` must ship whenever `EvidenceGraph` ships.

## Interaction and state patterns
### Hover, selection, and semantic zoom
1. Hover/focus previews a node and its immediate exact edges; it does not change URL, teach-back context, or learner state.
2. Click, `Enter`, or `Space` pins selection. The matching symbol row and text step receive the same selected state.
3. Arrow keys move to spatial neighbors; `Home/End` move to first/last node in the current ordered path; `Esc` returns to the previously focused symbol.
4. Zoom controls change explanatory altitude, not browser zoom. Keep the pinned symbol and selected path visible. Browser zoom through 200% must remain supported.
5. `Show evidence` opens a drawer, focuses its heading, and returns focus to the invoking edge/node on close.

### Analysis and async work
- Stages are `Queued → Fetching → Parsing → Indexing → Ready`; show labels and current stage only. Never invent a percentage or ETA.
- Keep the intake summary visible while running. Disable duplicate submission but keep session deletion available.
- On SSE loss, show “Progress connection lost” with `Reconnect`; do not silently restart analysis.
- On model failure, preserve graph/source/text-path interaction and label narrative or teach-back as temporarily unavailable.

### Teach-back and gap update
- Submit label: **“Check this explanation.”** Pending label: **“Checking against evidence…”** Prevent double submission while retaining entered text.
- Findings order is Supported, Missing, Unsupported. Each group uses an icon, heading, plain description, and evidence link; empty groups are omitted.
- After a valid attempt, update `GapList`, announce “Gap list changed” or “No gap-list change,” and show an inline diff marker: `Added`, `Moved`, `Unchanged`, or `Removed`. The marker is event history, not a judgment of the learner.
- Priority labels are categorical `Next`, `Soon`, `Later`, always followed by “Why this appears” and both evidence classes.
- Before any attempt, show repository concepts separately and state: “Explain a path to create learner evidence.” Do not prefill a personal gap list.

### Empty, error, and degradation states
| Condition | Required copy/action |
|---|---|
| No intake | “Choose the sample or a supported public repository snapshot.” / `Load sample` |
| Unsupported/oversize | State the canonical reason and bounds **[assumption until runtime values are confirmed]** / `Load sample` |
| No exact relation | “Not enough evidence to connect these symbols.” / `View available evidence` |
| Model unavailable | “The evidence map still works. The explanation check is unavailable.” / `Retry` |
| Session expired | “This temporary session expired. Start a new analysis.” / `Start again` |
| Pre-indexed fallback | “Pre-indexed sample · not a live analysis” persists / `Continue with sample` |
| Delete session | Confirmation names temporary graph, response, and gap data / `Delete session` |
