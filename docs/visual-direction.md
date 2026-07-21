# Visual Direction — convex

> **Purpose:** Brand-level visual philosophy for convex. Use this before `design-system.md` when making product screens, demo assets, screenshots, or marketing visuals.
> **Boundary:** This document changes presentation language only. It does not change APIs, data model, architecture, security, business rules, feature scope, or INV-001 through INV-003.

## Visual Philosophy
convex should feel like a premium editorial instrument for understanding code: quiet, exact, and composed. The interface should create the feeling of looking through a calibrated lens rather than entering a playful learning game or sci-fi scanner.

The visual system is inspired by the supplied reference image at the level of principles only: dark-first composition, generous negative space, large typographic moments, thin structure, soft geometry, and a single warm accent used with restraint. Do not copy layout, motifs, or proprietary details from the reference.

## Mood
- Premium, modern, editorial, minimal, and calm.
- Sophisticated rather than playful.
- Trustworthy before impressive: evidence and hierarchy matter more than ornament.
- Dark-first by default, with no light theme required for MVP unless implementation time permits.

## Composition
- Use large, quiet surfaces with visible breathing room around the graph, source, and learning rails.
- Keep the primary product loop visible: intake, focus, trace, teach back, and gap review.
- The current client includes a marketing landing page. Keep it focused on the first action—adding a public GitHub link—and do not let it imply that static preview content is a completed live analysis.
- Prefer editorial hierarchy: one dominant heading, one supporting sentence, then clear controls.
- Keep dense technical areas scan-friendly with aligned columns, stable rails, and predictable spacing.

## Shape Language
- Use rounded cards and panels with thin outlines. Radius should feel intentional, not bubbly.
- Use circles and arcs sparingly for focus indicators, node geometry, progress affordances, and optical/lens cues.
- Use subtle grid or rule-line structure only when it helps alignment or graph comprehension.
- Avoid decorative blobs, bokeh, heavy gradients, cartoon shapes, or faux-3D gloss.

## Motion Language
- Motion should feel smooth, composed, and functional.
- Use short transitions for hover, focus, drawer entry, semantic zoom, and graph selection.
- Prefer opacity, transform, and stroke transitions. Avoid bounce, elastic, confetti, shake, or playful easing.
- Respect `prefers-reduced-motion`; the experience must remain complete with motion minimized.
- Never use motion to imply analysis progress that the backend does not report.

## Photography Direction
Photography is optional for product surfaces. If used in demo or marketing assets, choose quiet editorial imagery: close crops of workspaces, screens, hands, notebooks, or judge/demo environments with real texture and low visual noise. Use natural low-key lighting, neutral grading, and enough darkness for off-white type. Avoid generic stock futurism, glowing server rooms, medical x-ray imagery, and busy classroom scenes.

## Illustration Direction
Use minimal technical illustration only when it clarifies evidence flow. Prefer thin-line diagrams, structured graph marks, code excerpts, and restrained geometric overlays. Illustrations should use neutral strokes with one warm coral accent, not multicolor cartoons.

## Color Philosophy
- Near-black is the default canvas; off-white is the primary typography color.
- Coral/orange is the only primary brand accent and should be used for action, selection, focus, and important learning state changes.
- Neutral grays carry most borders, surfaces, dividers, skeletons, and secondary text.
- Semantic states may use accessible success/warning/error hues, but each state must include text, icon, or shape support.
- Decorative gradients are not part of the core language. If a gradient is unavoidable, keep it local, very low contrast, and non-essential.

## UI Principles
- Evidence is visually primary: source references, edge labels, and proof actions must be more prominent than generated prose.
- Interaction should feel quiet and precise: hover previews are soft, selections are clear, drawers move smoothly, and focus rings are unmistakable.
- Cards should be rounded, outlined, and minimally elevated. Use shadow only for drawers, modals, pinned previews, and overlays.
- Large typography should guide the eye, but dense technical controls must remain compact enough for repeated use.
- Icons should be thin-line, consistent stroke, and paired with text when meaning is not obvious.
- Charts and graph encodings must not rely on hue alone; use labels, shape, line style, and ordering.
- Accessibility is part of the look: AA contrast, visible focus, text equivalents, keyboard traversal, and reduced motion are required.
