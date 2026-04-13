---
name: integrate-ui-component
description: >
  Integrates UI components and page assembly from approved contracts using Bootstrap-first
  implementation rules. Applies shared layouts, section composition, and responsive behavior
  without custom CSS for standard components. Use after content-service-and-data-wiring.
phase: "build"
---

# Integrate UI Component

## Overview
Implements page UI from the approved implementation spec and existing data wiring.

This skill focuses on:
- page assembly
- shared layout integration
- Bootstrap component composition
- responsive behavior
- semantic and accessibility baseline

## When to Use
- `content-service-and-data-wiring` completed successfully
- required services/models/page bindings exist
- implementation spec route/component contracts are available
- **NOT for:** backend data contract changes or deployment

## Handover Requirement

```text
Requires: content-service-and-data-wiring has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] content-service-and-data-wiring | content wiring validated | YYYY-MM-DD
```

## Evidence Output

This skill produces a structured evidence file in JSON format. The @Auditor will verify this file exists and contains acceptable thresholds before issuing the GO signal for deployment.

**Output file:** `evidence/ui-smoke-{project-name}.json`

**Schema:**
```json
{
  "project": "pure-wipe",
  "skill": "integrate-ui-component",
  "date": "2026-04-13T10:30:00Z",
  "pages_implemented": 7,
  "pages_passing": 7,
  "implementation_coverage_percent": 100,
  "layout_renders": true,
  "no_broken_assets": true,
  "responsive_validated": true,
  "a11y_baseline_met": true,
  "bootstrap_compliance_percent": 100,
  "custom_css_violations": 0,
  "pages_checked": ["/", "/productos", "/blog"],
  "critical_issues": 0,
  "warnings": 0,
  "findings": []
}
```

**Auditor verification rules (auto-fail if any):**
- `pages_passing === pages_implemented` ✅
- `layout_renders === true` ✅
- `no_broken_assets === true` ✅
- `responsive_validated === true` ✅
- `a11y_baseline_met === true` ✅
- `bootstrap_compliance_percent >= 90` ✅
- `custom_css_violations === 0` ✅
- `critical_issues === 0` ✅

## Process

### Step 1 — Load UI Contracts
Read:
- `IMPLEMENTATION_SPEC-{project-name}.md`
- route matrix
- component map
- assigned build issues

Extract for each page:
- required sections
- shared dependencies
- component behavior expectations

### Step 2 — Assemble Shared Layout and Navigation
Implement/adjust shared layout artifacts:
- header/navigation
- footer
- base template structure

Rules:
- keep semantic HTML structure
- maintain route coherence with approved matrix
- avoid introducing unapproved design systems

### Step 3 — Integrate Page Sections
For each target page, implement required sections based on spec.

Rules:
- use Bootstrap native components first
- no custom CSS for components Bootstrap already provides
- only use approved JS libraries (e.g., Swiper/AOS) when explicitly required

### Step 4 — Bind UI to Existing Data Contracts
Ensure UI consumes already-wired data structures.

Rules:
- do not rewrite backend contracts in UI layer
- keep null-safe and empty-state rendering
- include graceful fallback blocks for missing optional content

### Step 5 — Responsive and Accessibility Checks
Validate:
- mobile/tablet/desktop layout integrity
- heading hierarchy and landmark semantics
- form labels and navigation usability

Document any residual UX debt as explicit backlog items.

### Step 6 — Validate Build and Render Baseline
Run build and basic render checks where available.

Record:
- pages integrated
- known limitations
- unresolved UI blockers

### Step 7 — Update Roadmap and State
In `PROJECT_ROADMAP-{project-name}.md`:
- append `## UI Integration Evidence`
- add GO signal for `@MarketingSEO` (or `@Auditor` if SEO stage is skipped)

Update `current_state-{project-name}.json`:

```json
{
  "phase": "build",
  "active_skill": "integrate-ui-component",
  "active_agent": "@Orchestrator",
  "last_completed_step": "integrate-ui-component → Step 6: UI baseline validated",
  "next_step": "seo-aio-optimization → Step 1"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll add custom CSS quickly; it's faster." | Bootstrap-first is a hard constraint for standard components. |
| "We can optimize accessibility later." | Baseline accessibility checks are required in this skill. |
| "The UI can redefine route structure if needed." | Route contracts come from architecture spec and cannot be changed ad hoc. |
| "Responsive checks are optional for MVP." | Not in WFO; responsive integrity is required for completion. |

## Red Flags

- custom CSS introduced for Bootstrap-covered components
- page sections do not match component map contracts
- UI depends on fields not provided by data contracts
- mobile layout breaks on key pages
- no evidence written to roadmap

## Verification

- [ ] shared layout and navigation align with route matrix
- [ ] required page sections are integrated
- [ ] Bootstrap-first rule respected
- [ ] responsive baseline validated
- [ ] accessibility baseline validated
- [ ] roadmap contains `## UI Integration Evidence`
- [ ] `current_state-{project-name}.json` points to `seo-aio-optimization` or approved next stage
