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

**Visual source — at least one is mandatory (skill will not start without it):**

| Priority | Source | Minimum required |
|---|---|---|
| 1st choice | Stitch with Google MCP | Active MCP session + token/context |
| 2nd choice | Reference images | Homepage desktop screenshot ✅ required; mobile optional |
| 3rd choice | Reference URL | Full URL of live site or design reference |
| Combined | Any mix of the above | At least one must be confirmed before step 1 |

**Stitch with Google — setup check:**
- Verify the MCP server `stitch-with-google` is active in the session.
- If not configured: direct the operator to https://stitch.withgoogle.com and pause until confirmed.
- Never attempt to mock Stitch output — if unavailable, fall back to images or URL.

**Image requirements (when Stitch is not available):**
- `homepage-desktop.*` — **required** — represents primary brand, hero, nav, footer
- `homepage-mobile.*` — recommended — validates responsive breakpoints
- Additional pages (product, contact, blog) — optional but each adds contract precision
- Format: PNG, JPG, or WEBP. Do not accept PDF screenshots without explicit operator confirmation.

**Also required:**
- `IMPLEMENTATION_SPEC-{project-name}.md`
- `PROJECT_ROADMAP-{project-name}.md`
- `look_and_feel` block in `current_state-{project-name}.json` (written by Orchestrator intake)

**Blocker conditions:**
- No visual source of any kind → `BLOCKER: no visual source — operator must provide Stitch context, images, or URL`
- Stitch chosen but MCP server not active → `BLOCKER: Stitch MCP not active — configure server or switch to image/URL source`
- Images chosen but homepage desktop image not provided → `BLOCKER: homepage-desktop image required as minimum input`

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