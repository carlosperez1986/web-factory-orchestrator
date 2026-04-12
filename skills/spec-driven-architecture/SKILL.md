---
name: spec-driven-architecture
description: >
  Converts an approved roadmap into an implementation-ready specification pack.
  Produces route contracts, page specs, content contracts, component maps, batch slices,
  and acceptance criteria. Use after Phase 1 approval and once the project repository
  is available or adopted, before delivery planning or execution tracking begins.
phase: "define"
---

# Spec-Driven Architecture

## Overview
Transforms `PROJECT_ROADMAP-{project-name}.md` from a high-level execution outline into a technical specification pack that downstream agents can execute without guessing.

This skill produces `IMPLEMENTATION_SPEC-{project-name}.md` and updates the roadmap with traceable technical references.

## When to Use
- The roadmap and estimation were approved by the human operator
- The project has a working repository context, either newly scaffolded or adopted
- `current_state-{project-name}.json` points to post-approval work
- **NOT for:** changing business scope or re-estimating cost/time

## Handover Requirement

```text
Requires: project-estimation-and-stack-selection has completed and the human operator approved Phase 1.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] @Orchestrator | Phase 1 approved | YYYY-MM-DD
```

## Process

### Step 1 — Load Working Context
Read:
- `current_state-{project-name}.json`
- `PROJECT_ROADMAP-{project-name}.md`
- repository context if available

Confirm these inputs exist before proceeding:
- sitemap
- feature components
- stack decision
- approved repo context

If any are missing, stop and record a `BLOCKER` in the roadmap.

### Step 2 — Build Route and Page Matrix
From the sitemap, create a page-by-page matrix with:
- route/slug
- Razor Page file target
- page purpose
- template type
- data dependencies
- content source
- acceptance criteria

Write this under `## Route Matrix` in `IMPLEMENTATION_SPEC-{project-name}.md`.

### Step 3 — Define Content and Data Contracts
For each page and feature component, define:
- content collection or file source
- required fields
- optional fields
- model ownership
- service ownership
- caching expectations if needed

Write this under `## Content Contracts` and `## Data Contracts`.

### Step 4 — Define Component and Layout Contracts
Map each page to required UI sections and shared components:
- page-level sections
- shared layout dependencies
- nav/footer dependencies
- Bootstrap component expectations
- approved JS dependencies such as Swiper or AOS if needed

Write this under `## Component Map`.

### Step 5 — Create Implementation Batches
Break the work into execution batches that minimize cross-agent blocking.

Each batch must include:
- batch name
- objective
- files likely affected
- owner (`@Developer`, `@FrontendUI`, or both)
- dependencies
- acceptance criteria

Write this under `## Implementation Batches`.

### Step 6 — Define Acceptance and Review Gates
Create explicit gates for:
- technical completeness
- UI completeness
- content completeness
- pre-delivery review

Write this under `## Review Gates`.

### Step 7 — Write the Implementation Spec File
Create or update `IMPLEMENTATION_SPEC-{project-name}.md` with these sections:
- Overview
- Route Matrix
- Content Contracts
- Data Contracts
- Component Map
- Implementation Batches
- Review Gates
- Open Technical Questions

### Step 8 — Update Roadmap and State
In `PROJECT_ROADMAP-{project-name}.md`:
- add a reference to `IMPLEMENTATION_SPEC-{project-name}.md`
- add a summary note: `Architecture spec locked`
- add GO signal for `@DeliveryManager`

Update `current_state-{project-name}.json`:

```json
{
  "phase": "define",
  "active_skill": "spec-driven-architecture",
  "active_agent": "@Architect",
  "last_completed_step": "spec-driven-architecture → Step 7: Implementation spec written",
  "next_step": "github-project-bootstrap → Step 1",
  "implementation_spec_ref": "IMPLEMENTATION_SPEC-{project-name}.md"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The roadmap already has enough detail." | No. The roadmap is a plan, not an implementation contract. Execution agents still need explicit technical guidance. |
| "The developer can infer the models and page structure." | That leads to drift. Contracts must be written before implementation. |
| "We'll define batches while coding." | Batch planning belongs here so delivery planning can trace work cleanly. |
| "UI can be improvised later." | Not in WFO. Shared components, layout dependencies, and acceptance criteria must be known in advance. |

## Red Flags

- `IMPLEMENTATION_SPEC-{project-name}.md` is missing a `## Route Matrix`
- content fields are implied but not written as contracts
- implementation batches do not name owners or dependencies
- shared layout dependencies are omitted
- roadmap is updated without linking the implementation spec
- `current_state-{project-name}.json` does not point to the implementation spec

## Verification

- [ ] `IMPLEMENTATION_SPEC-{project-name}.md` exists in the project context
- [ ] `## Route Matrix` covers every sitemap route
- [ ] `## Content Contracts` defines sources and fields for dynamic content
- [ ] `## Component Map` exists and names shared dependencies
- [ ] `## Implementation Batches` exists with owners and dependencies
- [ ] `## Review Gates` exists with explicit acceptance gates
- [ ] `PROJECT_ROADMAP-{project-name}.md` references the implementation spec
- [ ] `current_state-{project-name}.json` points to `github-project-bootstrap` as next step
- [ ] `@Orchestrator` received a structured summary from `@Architect`
