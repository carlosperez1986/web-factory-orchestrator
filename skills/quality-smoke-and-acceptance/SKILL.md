---
name: quality-smoke-and-acceptance
description: >
  Defines smoke, route, asset, form, and acceptance checks before the
  pre-deploy security gate. Produces a lightweight QA report and GO/NO-GO
  recommendation for `security-audit`.
phase: "deploy"
---

# Quality Smoke and Acceptance

## Overview

Produces a pre-deploy QA gate that validates the app's live preview or
staging build before security audit and VPS provisioning. The outputs include
route-level smoke checks, static asset delivery verification, editorial content
presence checks, and a review of third-party dependency risks.

## When to Use

- `spec-driven-architecture` has completed and the implementation contract is locked
- `content-model-and-decap-design` has delivered collections and sample content
- a preview or staging environment is available for smoke checks
- the project has not yet been sent to production deploy
- **NOT for:** local-only development without a build preview, feature design, or deployment artifact generation

## Handover Requirement

```text
Requires: content-model-and-decap-design has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] content-model-and-decap-design PASSED | YYYY-MM-DD
```

## Inputs Required

This skill requires:
- `PROJECT_ROADMAP-{project-name}.md`
- `current_state-{project-name}.json`
- `IMPLEMENTATION_SPEC-{project-name}.md` or equivalent sitemap/route list
- a preview URL or staging build to validate
- the content collection definitions and sample content files

If any required input is missing, stop and record a `BLOCKER`.

## Process

### Step 1 — Load QA Context
Read:
- `current_state-{project-name}.json` → project slug, preview URL, active skill
- `PROJECT_ROADMAP-{project-name}.md` → stack decision, QA gate requirements
- `IMPLEMENTATION_SPEC-{project-name}.md` or spec artifact → expected routes and content sources

Resolve the preview or staging URL. If no preview environment exists, record:
```
BLOCKER: preview environment not available — smoke acceptance cannot continue.
```

### Step 2 — Run Route Smoke Checks
Verify the project responds successfully on the core route map:
- `/`
- any important landing pages
- any product, blog, or contact routes specified by the implementation spec
- Decap CMS admin route if configured, such as `/admin/`

For each route, record the HTTP status, title/content presence, and whether
client-side assets load without 404.

### Step 3 — Validate Critical Static Assets
Confirm that the preview build serves:
- CSS and JavaScript without 404/500 errors
- images and fonts used by the main page templates
- `favicon.ico` and any metadata assets referenced in HTML
- published content JSON/Markdown assets if applicable

Document any missing or broken asset requests.

### Step 4 — Check Form and Content Acceptance
If the site includes forms or editorial content:
- exercise the contact form with sample values and confirm the form renders
- verify the privacy/consent notice is present if required
- validate that sample content appears on the expected page
- confirm that published content fields map to the UI labels

If actual form submission is not possible, confirm the form UI is present and
free from obvious validation errors.

### Step 5 — Review Third-Party Dependencies
Inspect the project for third-party assets or external scripts:
- analytics or tracking scripts
- CDNs or external fonts
- payment, chat, or embed providers
- any non-local script or iframe sources

Surface anything that may require additional compliance review,
performance consideration, or security gate attention.

### Step 6 — Report and Next Step
Produce a QA report summary in `PROJECT_ROADMAP-{project-name}.md` or an
adjacent artifact. Include:
- route smoke check status
- static asset validation summary
- content acceptance findings
- dependency review notes
- GO/NO-GO recommendation for `security-audit`

If the QA report passes, set the next step to `security-audit`.
If it fails, record the blockers clearly and stop.
