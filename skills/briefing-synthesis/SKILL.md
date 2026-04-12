---
name: briefing-synthesis
description: >
  Produces a structured PROJECT_ROADMAP.md and a sitemap JSON from a raw client
  briefing (PDF or text). Use when a briefing is provided in chat text, via a
  PDF attachment (when supported), or as /inbox/briefing.md or /inbox/briefing.txt,
  and no PROJECT_ROADMAP.md exists yet in the project root.
owner: "@Analyst"
phase: "define"
---

# Briefing Synthesis

## Overview
Transforms a raw client briefing into a structured, agent-executable project plan.
Produces a sitemap JSON, a feature component list, and a `PROJECT_ROADMAP.md` that
the Orchestrator uses to sequence all subsequent skill executions.

## When to Use
- A PDF briefing is attached in chat (if supported by the client).
- A text briefing is pasted directly into chat.
- A briefing file exists in `/inbox/briefing.md` or `/inbox/briefing.txt`.
- A significant pivot in project scope has occurred and the existing roadmap is invalidated.
- **NOT for:** updating an in-progress roadmap with scope changes — use `spec-driven-architecture` instead.

## Handover Requirement

This is the first skill in the WFO pipeline. There is no previous agent owner.

```text
Requires: Human operator has provided a client briefing as PDF, chat text,
or /inbox/briefing.md|briefing.txt.
No GO signal from a previous agent is needed.
The Orchestrator activates this skill when there is unprocessed briefing input
and PROJECT_ROADMAP.md does not yet exist in the project root.
```

## Process

### Step 1 — Extract Business Intent
Read the full contents of the file in `/inbox`. Scan for the following Business Motive signals:

| Motive | Signal Keywords |
|---|---|
| **Lead Generation** | "contact", "email us", "form", "leads", "get in touch", "quote" |
| **Product Catalog** | "list of products", "catalog", "our work", "portfolio", "services" |
| **Brand Info** | "about us", "mission", "history", "team", "who we are" |

Write the detected motives as a flat list in `PROJECT_ROADMAP.md` under a `## Detected Motives` heading before proceeding to Step 2. Do not infer — only record what is evidenced in the briefing. If the briefing is ambiguous, ask the human operator one focused clarifying question before continuing.

### Step 2 — Define the Navigation Sitemap
Apply these routing rules to the detected motives:

| Rule | Condition | Required Page |
|---|---|---|
| **A** | Lead Generation detected | `Contáctenos` — must include a functional contact form |
| **B** | Product Catalog detected | `Productos` — must render a dynamic content grid |
| **C** | Always | `Inicio` as the root page (slug: `/`) |
| **D** | Always | Maximum 7 navigation items total |

Output the sitemap as a JSON object and write it into `PROJECT_ROADMAP.md` under `## Sitemap`. Example:

```json
{
  "nav": [
    { "label": "Inicio", "slug": "/", "template": "home" },
    { "label": "Nosotros", "slug": "/nosotros", "template": "about" },
    { "label": "Contáctenos", "slug": "/contacto", "template": "contact" }
  ]
}
```

### Step 3 — Map Required Feature Components
Based on the sitemap, produce a feature component manifest. Apply these rules:

| Component | When Required |
|---|---|
| `contact-form-handler` | Lead Generation motive detected |
| `json-content-service` | Every project — no exceptions |
| `decap-admin-panel` | Every project — no exceptions (`/admin/`) |
| `marketing-seo-pack` | Every project — AIO (AI Optimization) is always required |
| `dynamic-content-grid` | Product Catalog motive detected |

Write the manifest under `## Feature Components` in `PROJECT_ROADMAP.md`.

### Step 4 — Initialize the Project Roadmap
Using `blueprints/code/roadmap-template.md` as the base structure, generate
`PROJECT_ROADMAP.md` in the project root with the following phases fully populated:

- **Phase 1 — Define/Specs:** Task-list owned by `@Architect` (one task per Razor Page defined in sitemap).
- **Phase 2 — Build:** Task-list owned by `@Developer` (models + services + Decap schema/admin config) and `@FrontendUI` (components + layout).
- **Phase 3 — Audit/Deploy:** Task-list owned by `@Auditor` (security scan) and `@DevOps` (Nginx + Systemd provisioning).

Each task entry must follow the format:
```text
- [ ] [Task description] | Owner: @AgentRole | Depends on: [previous task or NONE]
```

### Step 5 — Update current_state.json
Write the following fields to `current_state.json` in the project root:

```json
{
  "project": "<client-name-slug>",
  "phase": "define",
  "active_skill": "briefing-synthesis",
  "active_agent": "@Analyst",
  "last_completed_step": "briefing-synthesis → Step 4: Roadmap initialized",
  "next_step": "project-estimation-and-stack-selection → Step 1",
  "token_budget_remaining": null,
  "roadmap_ref": "PROJECT_ROADMAP.md"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The PDF is vague, I'll just create a generic Home/About/Contact." | Vague PDFs require a clarifying question, not a generic template. Ask first, then generate. |
| "I'll create the roadmap after doing some research." | No. `PROJECT_ROADMAP.md` is the prerequisite for every other skill. It must exist before any @Architect or @Developer task begins. |
| "The client mentioned a database, but Git-based CMS can probably handle it." | A SQL or ORM requirement is a project stopper. Flag it immediately in the roadmap as a BLOCKER and notify the human operator. Do not silently work around it. |
| "More than 7 nav items makes the site richer." | A site with more than 7 nav items exceeds the 850€ scope model. Flag it as out-of-scope and propose a Phase 2 expansion instead. |
| "I'll skip current_state.json, it's just metadata." | The Orchestrator reads `current_state.json` on session resume. Skipping it forces re-reading the full chat history, wasting tokens and risking state drift. |
| "We'll decide admin panel later." | Decap CMS admin is mandatory by default. Include `/admin/` and related build tasks in the initial roadmap. |

## Red Flags

- Sitemap JSON contains more than 7 items — scope creep, flag immediately.
- No Lead Generation motive identified on a site for a local business — likely missed a signal, re-scan.
- A page template is listed as `"template": "custom"` — custom templates are prohibited; use only `home`, `about`, `contact`, `services`, `catalog`, `blog`.
- `PROJECT_ROADMAP.md` is generated without the `## Sitemap` JSON block — Step 2 was skipped.
- `PROJECT_ROADMAP.md` is generated without Decap admin/config tasks in Phase 2 — baseline stack is incomplete.
- `current_state.json` is missing or not updated after the skill completes — session resume will fail.
- Any mention of `Entity Framework`, `SQL`, `PostgreSQL`, or `SQLite` in the briefing — hard blocker, do not proceed.

## Verification

After all steps are complete, `@Analyst` writes evidence for each item into
`PROJECT_ROADMAP.md` and updates `current_state.json` before the human operator
is asked to approve the roadmap.

- [ ] `/inbox` file was fully read — evidence: first 3 detected Business Motive signals listed under `## Detected Motives` in `PROJECT_ROADMAP.md`
- [ ] Sitemap JSON is present under `## Sitemap` in `PROJECT_ROADMAP.md` — validate: `nav` array has ≥ 1 and ≤ 7 items
- [ ] All routing rules (A–D) were evaluated — evidence: comment next to each nav item indicating which rule triggered it
- [ ] Feature component manifest is present under `## Feature Components` — confirm `json-content-service` and `marketing-seo-pack` are always included
- [ ] Feature component manifest is present under `## Feature Components` — confirm `json-content-service`, `decap-admin-panel`, and `marketing-seo-pack` are always included
- [ ] `PROJECT_ROADMAP.md` exists in the project root — evidence: `Get-ChildItem PROJECT_ROADMAP.md` output
- [ ] All three phases (Define, Build, Deploy) are populated in `PROJECT_ROADMAP.md` with at least one `- [ ]` task each
- [ ] Phase 2 includes Decap admin tasks — evidence: task lines for `/admin/`, Decap `config.yml`, and content collections
- [ ] `current_state.json` updated with `last_completed_step` pointing to this skill — evidence: paste the JSON block
- [ ] Human operator has been shown the roadmap and asked for approval with the exact prompt: `"Review PROJECT_ROADMAP.md. Reply 'Proceed' to begin Phase 1, or provide corrections."`
