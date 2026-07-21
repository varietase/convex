# Design System / UX Spec — convex

> **Purpose:** Implementation contract for the judged F-001–F-005 experience. It translates the PRD flows and INV-001–INV-003 into components, tokens, interactions, responsive layouts, accessibility behavior, and a fixed demo path.
> **Current boundary:** The implemented client uses Next.js App Router, React, TypeScript, Tailwind CSS, and custom CSS tokens in `client/app/globals.css`; the graph-rendering library is not selected. This document is the binding target contract, so components beyond the public-URL intake and dashboard preview remain planned until their owning implementation tasks land.

## Design principles
1. **Evidence is the interface.** A connection is not complete until its exact `file:line` proof can be opened. Prose is secondary.
2. **Keep one focus across altitudes.** Hover previews; selection pins. Source, pseudocode, neighborhood, system path, and concepts preserve the same symbol/path context.
3. **Ask for an explanation; do not judge a person.** Feedback describes supported, missing, or unsupported parts of one submitted response.
4. **Graph and text are peers.** Every graph path has an ordered text representation with identical evidence actions; color is never the only carrier.
5. **Fail visibly and safely.** Omit uncertain edges, retain deterministic views when model features fail, label pre-indexed data, and never imply repository writes.

## Visual language
Use `visual-direction.md` as the visual philosophy layer. The product UI is dark-first, premium, editorial, and restrained: near-black canvas, off-white typography, neutral surfaces, thin borders, rounded cards, generous whitespace, large hierarchy, and a warm coral accent used only for action, focus, selection, and meaningful learning-state changes. Avoid sci-fi scanning effects, decorative gradients, playful illustration, heavy shadows, and color-only meaning.

Composition should feel like an optical instrument for code comprehension. The graph, source evidence, and learning rail can use circular geometry, arcs, and thin rules where they clarify focus or relationship, but every decorative element must earn its place by improving hierarchy or comprehension.

## Experience architecture
The primary loop is `Connect repository → Dashboard → Focus → Trace → Teach back → Review changed gap list`. Landing CTAs open a shared repository connection modal; the full public repository form is not rendered inline on the landing page. Four workspace landmarks keep the dashboard legible: top `AppHeader`, left `RepositoryRail`, center `FocusWorkspace`, right `LearningRail`. A `LiveRegion` announces analysis, selection, submission, and gap-list changes without moving focus.

## Complete component inventory
| Component | Purpose and required variants | States / semantics | Data contract |
|---|---|---|---|
| `AppShell` | Global landmarks and responsive pane orchestration | `<header>`, `<nav>`, `<main>`, complementary learning region | Session status |
| `DashboardShell` | Current post-repository preview with source/status, sidebar or mobile tabs, placeholder panels, and switch-repository action; target primary workspace when data is wired | public source, no repository selected | selected repository |
| `AppHeader` | Product name, sample/read-only status, session actions | Sticky; status uses icon + text; delete is explicit | session, snapshot |
| `ReadOnlyBadge` | Communicates INV-003 before intake and during exploration | Lock icon + “Read-only analysis”; never color-only | source kind |
| `RepositoryConnectionModal` | Shared landing/nav modal for public repository connection | closed, public-form; focus trap/return | repository state |
| `PublicRepositoryForm` | Add public GitHub repository link | empty, invalid URL, invalid GitHub format, valid, disabled; current valid state stores selection and routes without backend submission | `https://github.com/{owner}/{repo}` parser |
| `RepoIntake` | Backend analysis intake for bundled sample or bounded public immutable snapshot | idle, validating, rejected, submitting, disabled | `POST /v1/analyses` input/errors |
| `SampleBadge` | Prevent fallback/sample deception | Persistent “Pre-indexed sample · {version}” | sample version |
| `AnalysisStepper` | Named waiting state while the synchronous `POST /v1/analyses` call is in flight; no percentage or fake ETA | pending, ready, failed; `aria-live=polite` | `POST /v1/analyses` response |
| `RepositoryRail` | Search/filter supported modules and symbols | loading, populated, no match, collapsed | symbols/modules |
| `SymbolRow` | Focusable symbol entry with kind and source location | default, hover-preview, selected, unavailable | symbol + declaration span |
| `SemanticZoomRail` | Switch Source / Pseudocode / Connections / System path / Concepts | tablist; disabled view explains missing evidence | selection + available views |
| `FocusWorkspace` | Keeps selection stable while view changes | graph, code, narrative, text-path variants | `POST /v1/analyses` / `POST /v1/xray` |
| `CodePane` | Bounded cited excerpt, line numbers, active span | loading, highlighted, copy-reference; `<pre><code>` | evidence span |
| `EvidenceGraph` | One-hop exact symbols/edges and selected path | keyboard canvas/list composite; never sole representation | symbols, exact edges |
| `GraphNode` | Symbol type, name, file, state | shape + icon + label; focus/selected are distinct | symbol |
| `GraphEdge` | Exact relationship and evidence action | solid line + relationship label + endpoint marker; selected gets double stroke | edge + non-empty refs |
| `GraphLegend` | Explains shape, stroke, icon, and labels | Always available beside graph | static |
| `PathList` | Ordered text equivalent to the selected visual path | `<ol>`; each step names symbol, relation, file:line, evidence button | `POST /v1/analyses` text path |
| `EvidenceButton` | Opens proof without changing path | “Show evidence”; has accessible name with relation and location | evidence ref |
| `EvidenceDrawer` | Inspect exact excerpts and extractor provenance | modal on small screens, side drawer otherwise; focus trap/return | refs + derivation |
| `OmittedNotice` | Explains absent/ambiguous relationships | “Not enough evidence”; neutral info, not error | omitted relationships |
| `NarrativePanel` | Cited pseudocode/module/path explanation | loading, ready, model unavailable, rejected output | `POST /v1/xray` sections |
| `ConceptChip` | Repository concept, never a personal gap by itself | repository-present or focus-path; icon + text | concept evidence |
| `TeachBackLauncher` | Starts three repo-specific prompts from current path | disabled until sufficient evidence; reason visible | `POST /v1/teachbacks/questions` eligibility |
| `TeachBackCard` | Prompt, response field, submit action, progress | question 1–3 labels; 1–4,000 chars **[assumption]**; pending/error | question/attempt |
| `ResponseFindings` | Groups feedback about the response | Supported / Missing / Unsupported headings, each with evidence | `POST /v1/teachbacks/evaluate` claims |
| `GapList` | Ranked items derived from both graphs, ordered by `gap_score` | pre-attempt empty, unchanged, changed | `POST /v1/teachbacks/evaluate` `conceptGaps` |
| `GapItem` | Why it appears, its rank/score, and where to revisit | reason sentence + repo evidence + attempt evidence + rank + `gap_score` | EQ-005 derivation |
| `DerivationDrawer` | Glass-box method metadata | equation, datasets, version, confidence; disclosure pattern | derivation |
| `StatePanel` | Reusable empty, error, expired, degraded, unsupported UI | heading, plain reason, one primary recovery action | canonical API error |
| `ToastRegion` | Non-blocking confirmations only | `role=status`; never carries required evidence/errors alone | transient UI event |
| `SkipLinks` | Jump to repository, focus, text path, learning rail | First tabbable controls | static |

The current responsive dashboard is a preview rather than an evidence workspace. Desktop graph/tree content uses explicit placeholder copy; the mobile dashboard currently uses illustrative static files, paths, source lines, and teach-back content. Do not present those mobile examples as verified repository evidence, feedback, or learner state until the API-backed components replace them.

## CSS token contract
Use these custom properties directly; do not substitute framework defaults without updating this document and visual/contrast tests. Tokens follow a three-layer model: primitive raw values, semantic purpose aliases, and component tokens. Dark mode is the default product theme.

```css
:root {
  color-scheme: dark;

  /* Primitive color tokens */
  --xr-black-950: #070707;
  --xr-black-900: #0c0c0d;
  --xr-gray-850: #141416;
  --xr-gray-800: #1b1b1e;
  --xr-gray-700: #2a292c;
  --xr-gray-600: #3a383b;
  --xr-gray-500: #6f6a66;
  --xr-gray-400: #9b948d;
  --xr-gray-300: #c7beb5;
  --xr-offwhite-100: #f4efe8;
  --xr-offwhite-200: #e7ded3;
  --xr-coral-500: #ff7a59;
  --xr-coral-600: #ff6b4a;
  --xr-coral-700: #d94f34;
  --xr-amber-400: #f6c76f;
  --xr-red-400: #ff8a8a;
  --xr-green-400: #8fd6a4;
  --xr-bluegray-400: #9eb4c7;

  /* Semantic color tokens */
  --xr-canvas: var(--xr-black-950);
  --xr-surface-1: var(--xr-black-900);
  --xr-surface-2: var(--xr-gray-850);
  --xr-surface-3: var(--xr-gray-800);
  --xr-border: var(--xr-gray-600);
  --xr-border-subtle: var(--xr-gray-700);
  --xr-text: var(--xr-offwhite-100);
  --xr-text-muted: var(--xr-gray-300);
  --xr-text-subtle: var(--xr-gray-400);
  --xr-accent: var(--xr-coral-500);
  --xr-accent-hover: var(--xr-coral-600);
  --xr-accent-active: var(--xr-coral-700);
  --xr-structure: var(--xr-bluegray-400);
  --xr-evidence: var(--xr-amber-400);
  --xr-selected: var(--xr-coral-500);
  --xr-success: var(--xr-green-400);
  --xr-warning: var(--xr-amber-400);
  --xr-danger: var(--xr-red-400);
  --xr-disabled: var(--xr-gray-500);
  --xr-overlay: rgb(7 7 7 / 76%);

  /* Typography tokens */
  --xr-font-display: "Fraunces", "Iowan Old Style", Georgia, serif;
  --xr-font-sans: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  --xr-font-mono: "JetBrains Mono", "SFMono-Regular", Consolas, "Liberation Mono", monospace;
  --xr-text-xs: 0.75rem;
  --xr-text-sm: 0.875rem;
  --xr-text-md: 1rem;
  --xr-text-lg: 1.125rem;
  --xr-text-xl: 1.375rem;
  --xr-text-2xl: 1.75rem;
  --xr-text-3xl: 2.25rem;
  --xr-text-4xl: 3rem;
  --xr-text-5xl: 4rem;
  --xr-leading-tight: 1.25;
  --xr-leading-display: 1.05;
  --xr-leading-body: 1.55;

  /* Spacing tokens */
  --xr-space-1: 0.25rem;
  --xr-space-2: 0.5rem;
  --xr-space-3: 0.75rem;
  --xr-space-4: 1rem;
  --xr-space-5: 1.25rem;
  --xr-space-6: 1.5rem;
  --xr-space-8: 2rem;
  --xr-space-12: 3rem;
  --xr-space-16: 4rem;
  --xr-space-24: 6rem;

  /* Radius and elevation tokens */
  --xr-radius-xs: 0.25rem;
  --xr-radius-sm: 0.5rem;
  --xr-radius-md: 0.75rem;
  --xr-radius-lg: 1rem;
  --xr-radius-xl: 1.5rem;
  --xr-radius-full: 999px;
  --xr-border-width: 1px;
  --xr-selected-width: 3px;
  --xr-focus-ring: 0 0 0 3px var(--xr-canvas), 0 0 0 5px var(--xr-accent);
  --xr-shadow-none: none;
  --xr-shadow-raised: 0 18px 44px rgb(0 0 0 / 32%);
  --xr-shadow-overlay: 0 30px 80px rgb(0 0 0 / 48%);

  /* Component tokens */
  --xr-card-bg: var(--xr-surface-1);
  --xr-card-border: var(--xr-border-subtle);
  --xr-card-radius: var(--xr-radius-lg);
  --xr-card-padding: var(--xr-space-6);
  --xr-button-bg: var(--xr-accent);
  --xr-button-fg: var(--xr-black-950);
  --xr-button-bg-hover: var(--xr-accent-hover);
  --xr-button-radius: var(--xr-radius-full);
  --xr-input-bg: var(--xr-surface-2);
  --xr-input-border: var(--xr-border-subtle);
  --xr-drawer-bg: var(--xr-surface-1);
  --xr-graph-node-bg: var(--xr-surface-2);
  --xr-graph-node-border: var(--xr-border);
  --xr-graph-edge: var(--xr-structure);
  --xr-graph-evidence: var(--xr-evidence);

  --xr-control-height: 2.75rem;
  --xr-header-height: 3.5rem;
  --xr-rail-repo: 17.5rem;
  --xr-rail-learn: 22.5rem;
  --xr-duration-fast: 120ms;
  --xr-duration-base: 180ms;
  --xr-duration-slow: 260ms;
  --xr-ease: cubic-bezier(.2, .8, .2, 1);
}

*:focus-visible { outline: none; box-shadow: var(--xr-focus-ring); }
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { scroll-behavior: auto !important; transition-duration: 1ms !important; animation-duration: 1ms !important; animation-iteration-count: 1 !important; }
}
```

### Typography system
| Role | Token | Font | Size / line height | Usage |
|---|---|---|---|---|
| Display | `--xr-text-5xl` | `--xr-font-display` | `4rem / 1.05` | Hero or first-use empty state headline |
| H1 | `--xr-text-4xl` | `--xr-font-display` | `3rem / 1.05` | Page or workspace title |
| H2 | `--xr-text-3xl` | `--xr-font-display` | `2.25rem / 1.15` | Major panel heading |
| H3 | `--xr-text-2xl` | `--xr-font-sans` | `1.75rem / 1.25` | Card and rail section heading |
| Body | `--xr-text-md` | `--xr-font-sans` | `1rem / 1.55` | Default reading text |
| Body large | `--xr-text-lg` | `--xr-font-sans` | `1.125rem / 1.55` | Intro and important explanatory copy |
| Label | `--xr-text-sm` | `--xr-font-sans` | `0.875rem / 1.4` | Buttons, tabs, metadata |
| Caption | `--xr-text-xs` | `--xr-font-sans` | `0.75rem / 1.4` | Short metadata only |
| Code | `--xr-text-sm` | `--xr-font-mono` | `0.875rem / 1.55` | Source excerpts and IDs |

Use editorial display type for large headings only; do not use it for dense controls, graph labels, code, or long paragraphs. Letter spacing is `0` by default. Do not place essential evidence below `12px`.

### Spacing, radius, and elevation
- Use the spacing scale from `--xr-space-1` through `--xr-space-24`; no ad hoc pixel spacing in components.
- Dense graph labels may use `--xr-space-1` and `--xr-space-2`; forms and cards use `--xr-space-3`, `--xr-space-4`, and `--xr-space-6`; large hero/empty states use `--xr-space-12`, `--xr-space-16`, and `--xr-space-24`.
- Cards use `--xr-radius-lg`; compact controls use `--xr-radius-sm` or `--xr-radius-md`; pills, node focus halos, and circular optical cues use `--xr-radius-full`.
- Use `--xr-shadow-none` for most surfaces. Use `--xr-shadow-raised` only for drawers, modals, pinned previews, and overlays. Selection uses border/stroke, not shadow.
- Control and pointer target minimum is `44x44px`; graph nodes need at least a 44px hit target even when their visual mark is smaller.

### Component styling
- `AppShell`: near-black canvas, thin structural dividers, stable left/center/right layout, no decorative page gradients.
- `AppHeader`: compact dark bar with product name, read-only/sample state, and subdued actions. Use coral only for primary action or active focus.
- `RepositoryConnectionModal`: dark overlay, rounded panel, and public GitHub URL form as the only repository connection action. The modal is opened by landing/nav CTAs; do not leave the full form inline in the page.
- `PublicRepositoryForm`: use the placeholder `https://github.com/owner/repository`, disable submit until valid, and show errors for empty input, invalid URL, and invalid GitHub format.
- `DashboardShell`: use the same dark/coral language as the landing page. Switching a repository reopens the public repository form.
- `RepoIntake`: backend analysis intake may use a large editorial empty state with one primary action and one secondary option. Keep the working intake visible; do not turn it into a marketing hero.
- `RepositoryRail` and `LearningRail`: outlined panels, transparent or surface-1 backgrounds, calm density, sticky headings, and clear selected states.
- `FocusWorkspace`: largest visual area. Graph/source/path views sit on the canvas, with cards only for repeated or framed items.
- `EvidenceGraph`: neutral nodes, thin labeled edges, coral selection, amber evidence affordances, and shape/line-style encoding for edge types.
- `CodePane`: dark surface, subtle line numbers, coral active span outline, amber evidence marks, and no syntax palette that competes with proof actions.
- `TeachBackCard`, `ResponseFindings`, and `GapItem`: rounded outlined cards with restrained elevation, clear headings, evidence actions, and non-color status markers.
- `EvidenceDrawer` and `DerivationDrawer`: elevated overlays with focus trap/return, thin borders, and stable max widths; content must remain readable at 200% browser zoom.

### Iconography
Use thin-line icons with a consistent `1.5px` to `2px` stroke, rounded joins, and no filled decorative sets. Pair unfamiliar icons with text or accessible labels. Required symbolic language:
- lock for read-only state
- document/file for source evidence
- pin for selected path
- folder/module, function, and class/type markers for graph nodes
- broken-link or gap marker for "not enough evidence"
- check, minus, and alert-style icons for Supported, Missing, and Unsupported findings

### Motion principles
- Use motion for state continuity only: hover preview, pinned selection, semantic zoom view swap, drawer/modal entry, and gap-list diff.
- Default transitions use `--xr-duration-fast` or `--xr-duration-base` with `--xr-ease`; larger overlays may use `--xr-duration-slow`.
- Prefer opacity, transform, border, and stroke transitions. Avoid bounce, shake, elastic easing, confetti, and decorative animated backgrounds.
- Reduced-motion mode must keep all state changes perceivable without relying on animation.
- Never show fake progress, staged analysis, or animated certainty for synchronous API calls.

### Chart palette
Charts are secondary evidence aids, not decoration. Use labels, texture, ordering, and direct annotation before relying on hue.

| Role | Token | Hex | Usage |
|---|---|---|---|
| Primary series | `--xr-accent` | `#ff7a59` | Current focus or selected comparison |
| Evidence series | `--xr-evidence` | `#f6c76f` | Evidence count, citation availability |
| Structure series | `--xr-structure` | `#9eb4c7` | Graph/module relationship metrics |
| Neutral series A | `--xr-gray-400` | `#9b948d` | Secondary comparison |
| Neutral series B | `--xr-gray-600` | `#3a383b` | Baseline/grid/reference |
| Success state | `--xr-success` | `#8fd6a4` | Passing validation when text/icon also present |
| Danger state | `--xr-danger` | `#ff8a8a` | Error/blocked state when text/icon also present |

### Accessibility guidance
- Minimum target is WCAG 2.2 AA. Verify contrast for every token pair used in implementation; do not assume compliance after changing opacity.
- Required measured text pairs: `--xr-text` on `--xr-canvas` = 17.61:1, `--xr-text` on `--xr-surface-1` = 17.09:1, `--xr-text-muted` on `--xr-canvas` = 10.99:1, `--xr-button-fg` on `--xr-button-bg` = 7.85:1, and `--xr-accent` on `--xr-canvas` = 7.85:1.
- Do not put normal-size coral text on mid-gray surfaces unless contrast is verified; prefer coral as border, icon, underline, or large text when needed.
- Focus indicators must remain visible on canvas, cards, graph nodes, controls, and drawers.
- Graph, chart, findings, and gap states must include labels, shape, icon, line style, or ordering in addition to color.

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

### Repository connection and analysis
- Public repository connection validates `https://github.com/{owner}/{repo}` in the modal before routing to `/dashboard`; this is not yet the backend analysis call.
- `POST /v1/analyses` is a single synchronous call bounded by the 20-second intake/analysis timeout; show a pending state only, never a multi-stage progress bar, percentage, or fake ETA.
- Keep the intake summary visible while the request is in flight. Disable duplicate submission but keep session deletion available.
- On timeout or failure, show the canonical error reason and a retry/sample-fallback action; do not silently retry.
- On model failure, preserve graph/source/text-path interaction and label narrative or teach-back as temporarily unavailable.

### Teach-back and gap update
- Submit label: **“Check this explanation.”** Pending label: **“Checking against evidence…”** Prevent double submission while retaining entered text.
- Findings order is Supported, Missing, Unsupported. Each group uses an icon, heading, plain description, and evidence link; empty groups are omitted.
- After a valid attempt, update `GapList`, announce “Gap list changed” or “No gap-list change,” and show an inline diff marker: `Added`, `Moved`, `Unchanged`, or `Removed`. The marker is event history, not a judgment of the learner.
- Each gap shows its rank (`1.`, `2.`, …) by `gap_score`, always followed by “Why this appears” and both evidence classes. The score is never rendered as a percentage or mastery claim — it is a ranking value only.
- Before any attempt, show repository concepts separately and state: “Explain a path to create learner evidence.” Do not prefill a personal gap list.

### Empty, error, and degradation states
| Condition | Required copy/action |
|---|---|
| No repository selected | “Add a public GitHub repository link, or continue with the sample.” / `Add Repository Link` |
| No analysis intake | “Choose the sample or a supported public repository snapshot.” / `Load sample` |
| Unsupported/oversize | State the canonical reason and bounds **[assumption until runtime values are confirmed]** / `Load sample` |
| No exact relation | “Not enough evidence to connect these symbols.” / `View available evidence` |
| Model unavailable | “The evidence map still works. The explanation check is unavailable.” / `Retry` |
| Session expired | “This temporary session expired. Start a new analysis.” / `Start again` |
| Pre-indexed fallback | “Pre-indexed sample · not a live analysis” persists / `Continue with sample` |
| Delete session | Confirmation names temporary graph, response, and gap data / `Delete session` |

