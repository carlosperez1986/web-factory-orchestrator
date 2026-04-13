---
name: implementation-batch-planning
description: >
  Breaks the approved implementation spec into executable development batches.
  Produces a sequenced execution plan, per-batch dependencies, review checkpoints,
  and GO criteria for the code delivery wave.
phase: "build"
---

# Implementation Batch Planning

## Overview

Creates the execution-level plan for the project by slicing the locked
implementation spec into discrete batches. This skill ensures that the first
code wave is sequenced, reviewable, and aligned with the WFO factory's
specialized skills.

## When to Use

- `IMPLEMENTATION_SPEC-{project-name}.md` exists and is approved
- `PROJECT_ROADMAP-{project-name}.md` is approved and contains stack decisions
- the project repository has been seeded or adopted
- `content-model-and-decap-design` may be in progress or ready
- **NOT for:** low-level coding, deployment, or roadmap-only high-level planning

## Handover Requirement

```text
Requires: spec-driven-architecture has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] spec-driven-architecture | architecture spec locked | YYYY-MM-DD
```

## Inputs Required

This skill requires:
- `IMPLEMENTATION_SPEC-{project-name}.md`
- `PROJECT_ROADMAP-{project-name}.md`
- repository context or local repo structure
- `github-project-bootstrap` if GitHub issue sequencing is desired

If any required input is missing, stop and record a `BLOCKER`.

## Process

### Step 1 — Load the Implementation Spec
Read:
- `IMPLEMENTATION_SPEC-{project-name}.md`
- `PROJECT_ROADMAP-{project-name}.md`
- any existing delivery board or issue backlog if available

Extract:
- page routes and feature bundles
- data contract dependencies
- service and UI ownership per route
- editorial and SEO requirements

If any execution detail is missing from the spec, add a blocker or annotate the
spec with the gap.

### Step 2 — Define Batch Boundaries
Create clear batches that group work by:
- shared content/service dependencies
- UI template families
- deployable progress checkpoints
- review gate feasibility

A typical batch structure for a Pure Wipe-style site is:
1. Foundation and shared layout
2. Static content pages (`Legal`, `Nosotros`)
3. Product catalog and detail pages
4. Homepage and blog
5. Forms, Galería, and integrations
6. SEO/AIO and final polish

### Step 3 — Assign Skill Ownership
For each batch, assign the responsible WFO skill(s):
- `content-service-and-data-wiring` for backend models, services, and page data binding
- `integrate-ui-component` for Razor Page markup, Bootstrap UI, and responsive layout
- `seo-aio-optimization` for metadata, schema, and discoverability work
- `content-model-and-decap-design` for content contract deliverables where required

If a batch spans multiple skills, identify the sequence and any required handoff
artifacts.

### Step 4 — Define Acceptance Criteria and Review Gates
For each batch, document:
- completion criteria for the batch
- required approval checkpoints
- whether a human or `@Auditor` review is needed before proceeding
- any blocked downstream batch if the current batch fails

Examples:
- Batch 1: `dotnet build` passes, shared layout loads, content service returns data
- Batch 3: product filter works, detail page loads with gallery
- Batch 5: forms render and accept input validation

### Step 5 — Map Dependencies and Risks
Record:
- batch dependencies (`Batch 3 depends on Batch 1`)
- cross-skill handoffs (`content-service-and-data-wiring` → `integrate-ui-component`)
- external risk items (Instagram token, legal copy, distributor data)
- staging or preview environment needs per batch

### Step 6 — Publish the Batch Plan
Add a `## Implementation Batches` section to `IMPLEMENTATION_SPEC-{project-name}.md` or
`PROJECT_ROADMAP-{project-name}.md` with:
- batch names and objectives
- files likely affected
- skill owner per batch
- acceptance criteria
- dependencies and review gates

If `github-project-bootstrap` is available, create corresponding issue batches
or milestone groupings.

### Step 7 — Update State and Next Step
Update `PROJECT_ROADMAP-{project-name}.md`:
- add `[✅ GO] implementation-batch-planning DONE | YYYY-MM-DD`
- note `Implementation batches defined`
- set next step to `content-service-and-data-wiring → Step 1`

Update `current_state-{project-name}.json`:

```json
{
  "phase": "build",
  "active_skill": "implementation-batch-planning",
  "active_agent": "@Orchestrator",
  "last_completed_step": "implementation-batch-planning → batch plan documented",
  "next_step": "content-service-and-data-wiring → Step 1"
}
```

## Verification

- [ ] `IMPLEMENTATION_SPEC-{project-name}.md` contains a batch plan section
- [ ] Each batch has a clearly stated objective
- [ ] Skill ownership is assigned for each batch
- [ ] Dependencies are explicit and ordered
- [ ] Acceptance criteria and review checkpoints are documented
- [ ] `PROJECT_ROADMAP-{project-name}.md` includes the batch plan or a roadmap summary
- [ ] `current_state-{project-name}.json` points to `content-service-and-data-wiring`
