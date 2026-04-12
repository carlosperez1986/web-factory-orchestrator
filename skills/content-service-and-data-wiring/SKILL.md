---
name: content-service-and-data-wiring
description: >
  Implements file-based data and content wiring from the approved implementation spec.
  Creates or updates models, services, and Razor PageModel bindings for dynamic content.
  Use after spec-driven-architecture and github-project-bootstrap are complete.
phase: "build"
---

# Content Service and Data Wiring

## Overview
Implements backend data wiring for the project using Git-based JSON/Markdown content sources.

This skill turns approved contracts into working code paths:
- models
- content services
- page model bindings
- caching behavior

## When to Use
- `IMPLEMENTATION_SPEC-{project-name}.md` exists
- GitHub issues for build tasks were created
- Repository context is available
- **NOT for:** UI assembly, deployment, or architecture redesign

## Handover Requirement

```text
Requires: github-project-bootstrap has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] github-project-bootstrap | delivery tracking initialized | YYYY-MM-DD
```

## Process

### Step 1 — Load Contracts and Task Scope
Read:
- `IMPLEMENTATION_SPEC-{project-name}.md`
- assigned build issues
- `PROJECT_ROADMAP-{project-name}.md`

Extract for each target page:
- required content source
- required fields
- model contract
- service contract

Stop and raise a blocker if any contract is missing.

### Step 2 — Implement or Update Models
Create/update strongly-typed models for required content structures.

Rules:
- match field names and optionality from contracts
- avoid speculative fields
- ensure naming consistency with existing codebase

Write model summary under roadmap evidence.

### Step 3 — Implement or Update Content Services
Create/update content services that read from file-based content sources.

Rules:
- no SQL/ORM
- use file-based loaders (JSON/Markdown/frontmatter as specified)
- isolate parsing and transformation logic
- handle missing files gracefully with logged warnings

### Step 4 — Wire Page Models to Services
Bind PageModels to services and map outputs to view-ready structures.

Rules:
- no business rule invention outside contracts
- respect route/page matrix from implementation spec
- ensure null-safe loading for optional content

### Step 5 — Apply Caching Strategy
Implement contract-approved caching (if specified).

Rules:
- apply cache at service layer
- document cache keys and durations
- avoid stale critical content for long durations

### Step 6 — Validate Build and Data Flow
Run build and relevant checks:
- project build
- route-level data load smoke checks (where available)

Record evidence and unresolved issues.

### Step 7 — Update Roadmap and State
In `PROJECT_ROADMAP-{project-name}.md`:
- append `## Content Wiring Evidence` summary
- add GO signal for `@FrontendUI`

Update `current_state-{project-name}.json`:

```json
{
  "phase": "build",
  "active_skill": "content-service-and-data-wiring",
  "active_agent": "@Orchestrator",
  "last_completed_step": "content-service-and-data-wiring → Step 6: Build and data flow validated",
  "next_step": "integrate-ui-component → Step 1"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll just infer missing fields from context." | Do not infer contracts. Missing contracts must be escalated to `@Architect`. |
| "A quick DB would be easier." | WFO baseline is file-based content. SQL/ORM is out of scope. |
| "UI can consume raw file data directly." | No. Service and model boundaries are required for maintainability and traceability. |
| "Caching can be added later." | If contracts require it, caching is part of this skill completion criteria. |

## Red Flags

- models contain fields not in contracts
- service logic bypasses file-based source rules
- PageModels embed parser logic directly
- build passes but key pages fail to load required data
- no evidence written in roadmap

## Verification

- [ ] models implemented/updated according to contracts
- [ ] content services implemented without SQL/ORM dependencies
- [ ] PageModels wired to services for all targeted routes
- [ ] build succeeds
- [ ] roadmap contains `## Content Wiring Evidence`
- [ ] `current_state-{project-name}.json` points to `integrate-ui-component`
