---
name: look-and-feel-ingestion
description: >
  Captures visual style from reference images, a live URL, or Stitch with Google
  artifacts and turns it into a reusable style contract for implementation.
  Use before integrate-ui-component to preserve brand look and feel.
phase: "build"
---

# Look and Feel Ingestion

## Overview

Transforms a visual reference into implementation-ready design guidance for WFO.
The source can be:
- screenshot images,
- a reference website URL,
- Stitch with Google export artifacts,
- or a Stitch token/access context provided by the operator.

This skill outputs a style contract that downstream skills can apply consistently.

## When to Use

- `IMPLEMENTATION_SPEC-{project-name}.md` exists
- project has a required visual benchmark (existing website or design direction)
- UI implementation has not started, or style drift must be corrected
- **NOT for:** backend data wiring, SEO metadata, or deploy configuration

## Handover Requirement

```text
Requires: spec-driven-architecture has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] spec-driven-architecture | architecture spec locked | YYYY-MM-DD
```

## Inputs Required

At least one of the following must be present:
- reference image set (desktop and mobile preferred)
- reference site URL
- Stitch with Google output artifacts (screens or layout exports)
- Stitch access context (token/session provided by operator)

Also required:
- `IMPLEMENTATION_SPEC-{project-name}.md`
- `PROJECT_ROADMAP-{project-name}.md`

If no visual source is provided, stop and record a `BLOCKER`.

## Process

### Step 1 - Gather Visual Inputs
Collect from the operator:
- source type: image, URL, Stitch artifacts, or Stitch token context
- pages or sections to match (hero, cards, nav, forms, footer)
- strictness level: exact-match, close-match, or inspired-by
- accessibility constraints (contrast, focus visibility, reduced motion)

Record unresolved items as blockers.

### Step 2 - Extract Design Tokens
Build normalized tokens from the visual source:
- color palette (primary, secondary, neutral, status)
- typography scale (families, sizes, weights, line height)
- spacing scale and section rhythm
- border radius and elevation/shadows
- motion rules (duration, easing, reduced-motion behavior)

Do not copy proprietary assets or paid font files unless licensed and provided.

### Step 3 - Map UI Patterns to WFO Components
Create a mapping table from visual patterns to implementation targets:
- header/navigation
- hero/banner
- product and content cards
- forms and CTAs
- blog/article blocks
- footer and legal links

For each mapping, define Bootstrap-first implementation notes and allowed custom CSS.

### Step 4 - Define Responsive and Accessibility Rules
Specify behavior at minimum breakpoints:
- mobile (<576)
- tablet (>=576)
- desktop (>=992)

Define accessibility checks:
- color contrast targets
- keyboard focus states
- heading hierarchy rules
- image alt-text requirements

### Step 5 - Publish Style Contract
Create `DESIGN_STYLE_CONTRACT-{project-name}.md` with:
- source references (images/URL/Stitch)
- token dictionary
- component style map
- responsive rules
- accessibility constraints
- do and do not list to prevent style drift

### Step 6 - Update Roadmap and Handover
Update `PROJECT_ROADMAP-{project-name}.md`:
- add `[✅ GO] look-and-feel-ingestion DONE | YYYY-MM-DD`
- add note: `Design style contract locked`
- set next step to `integrate-ui-component -> Step 1`

Update `current_state-{project-name}.json`:

```json
{
  "phase": "build",
  "active_skill": "look-and-feel-ingestion",
  "active_agent": "@Orchestrator",
  "last_completed_step": "look-and-feel-ingestion -> style contract documented",
  "next_step": "integrate-ui-component -> Step 1",
  "design_style_contract_ref": "DESIGN_STYLE_CONTRACT-{project-name}.md"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Stitch output is enough; no contract needed." | Without a style contract, UI consistency degrades across pages and rework increases. |
| "One desktop screenshot is enough." | Mobile behavior and responsive spacing cannot be inferred reliably from desktop only. |
| "We can tune styles while coding." | Deferred styling causes drift and breaks deterministic implementation. |

## Red Flags

- no explicit visual source captured
- token set missing typography or spacing scales
- component mapping does not cover forms and navigation
- no responsive rules documented
- no accessibility constraints recorded

## Verification

- [ ] visual input source documented (image/URL/Stitch)
- [ ] `DESIGN_STYLE_CONTRACT-{project-name}.md` exists
- [ ] token dictionary includes color, type, spacing, radius, motion
- [ ] component map includes nav, hero, cards, forms, footer
- [ ] responsive behavior defined for mobile/tablet/desktop
- [ ] roadmap includes GO signal for completion
- [ ] `current_state-{project-name}.json` points to `integrate-ui-component`