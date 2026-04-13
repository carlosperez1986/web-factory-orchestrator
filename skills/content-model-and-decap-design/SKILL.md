---
name: content-model-and-decap-design
description: >
  Defines the Git-based content model and Decap CMS admin configuration from an
  approved implementation spec. Produces collections, field schemas, sample files,
  and editorial layout before content wiring begins.
phase: "build"
---

# Content Model and Decap Design

## Overview
Produces the content contract layer for the project by converting the approved
implementation spec into Decap CMS collection definitions, editorial schemas,
and sample content files. This skill ensures the content admin surface matches
what the Razor Pages and services expect.

## When to Use
- `IMPLEMENTATION_SPEC-{project-name}.md` exists
- `PROJECT_ROADMAP-{project-name}.md` is approved and contains the stack decision
- repository context is available or adopted
- **NOT for:** page UI assembly or deployment configuration

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
- repository context or client repo path
- `blueprints/infra/nginx-config.template` is not required for this skill

If any artifact is missing, stop and record a `BLOCKER`.

## Process

### Step 1 — Load Content Contracts
Read:
- `IMPLEMENTATION_SPEC-{project-name}.md`
- `PROJECT_ROADMAP-{project-name}.md`
- repo structure if available

Extract:
- collection names and types
- page content sources
- required and optional fields
- entity relationships
- editorial workflow needs

If `IMPLEMENTATION_SPEC` is missing any of these, stop and add a blocker note.

### Step 2 — Define Decap Collections
For each content type identified, create a Decap collection definition in:
- `wwwroot/admin/config.yml`
- optionally `content-schemas/{collection-name}.yml`

Collections must map to the content contracts defined in the spec, for example:
- `product-lines`
- `products`
- `posts`
- `distributors`
- `legal-sections`
- `about`
- `team`
- `certifications`
- `contact-settings`
- `gallery-settings`
- `testimonials`

Each collection definition must include:
- field name
- widget type
- required/optional flag
- validation rules
- editorial help text

### Step 3 — Create Sample Content Files
Generate sample content files for each collection type in `content/`.
The sample files must match the field schemas and provide one minimal working
example per page:
- `content/home.json`
- `content/product-lines/*.json`
- `content/products/*.json`
- `content/posts/*.md`
- `content/contact-settings.json`
- `content/distributors.json`
- `content/legal.json`
- `content/about.json`
- `content/team.json`
- `content/certifications.json`
- `content/gallery-settings.json`
- `content/testimonials.json`

Use the sample files to validate that every required field in the contract exists.

### Step 4 — Document Editorial Workflow
Create a short editorial guide in `wwwroot/admin/README.md` or
`content/admin-workflow.md` that explains:
- where content is stored
- how to edit page content
- how to add products, blog posts, distributors, and legal sections
- how to publish changes via Git

### Step 5 — Validate Against Implementation Spec
Cross-check the generated Decap config and sample files against the spec:
- field names match exactly
- required fields are present
- optional fields are documented
- paths and collection names match page data sources

If any mismatch exists, update the config or add a blocking task in the roadmap.

### Step 6 — Commit and Update State
Commit generated content artifacts to the repo if available.

Update `PROJECT_ROADMAP-{project-name}.md`:
- add `[✅ GO] content-model-and-decap-design DONE | YYYY-MM-DD`
- note `Decap content model locked`

Update `current_state-{project-name}.json`:

```json
{
  "phase": "build",
  "active_skill": "content-model-and-decap-design",
  "active_agent": "@Orchestrator",
  "last_completed_step": "content-model-and-decap-design → content contracts locked",
  "next_step": "github-project-bootstrap → Step 1"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Decap can be configured later when the UI is ready." | If Decap collections do not match the UI contract, implementation will drift and require rework. |
| "I can just use JSON files and skip CMS config." | The project explicitly requires Decap CMS baseline; the admin surface is part of deployable deliverables. |
| "Sample content is optional." | Without sample content, page rendering checks cannot reliably validate the contract. |

## Red Flags

- `wwwroot/admin/config.yml` is absent
- collection field names differ from the implementation spec
- required fields are missing in sample content
- no editorial workflow guide is created
- content files are stored in the wrong folder

## Verification

- [ ] `wwwroot/admin/config.yml` exists and defines all collections used by the spec
- [ ] Sample content files exist for every required page type
- [ ] Field names in content files match the spec exactly
- [ ] Editorial runbook exists and is readable
- [ ] `PROJECT_ROADMAP-{project-name}.md` includes GO signal for completion
- [ ] `current_state-{project-name}.json` points to `github-project-bootstrap`
