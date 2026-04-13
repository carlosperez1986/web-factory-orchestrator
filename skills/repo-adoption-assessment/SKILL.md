---
name: repo-adoption-assessment
description: >
  Assesses an existing repository before WFO adoption. Produces an adoption
  recommendation, gap analysis, CI/CD status, and a safe import plan for the
  project when a client repo already exists.
phase: "build"
---

# Repo Adoption Assessment

## Overview
This skill evaluates an existing client repository before WFO brings it into the
project delivery pipeline. It identifies compatibility, risk, and adaptation
needs so WFO can import the repo safely instead of overwriting or breaking it.

## When to Use
- a client project repo already exists or the project is in adoption mode
- `PROJECT_ROADMAP-{project-name}.md` is approved and the user wants to continue
- `project-scaffolding` will operate in adoption mode
- **NOT for:** new repo creation or pure architecture planning

## Handover Requirement

```text
Requires: spec-driven-architecture has completed and the roadmap is approved.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] spec-driven-architecture | architecture spec locked | YYYY-MM-DD
```

## Inputs Required

- `PROJECT_ROADMAP-{project-name}.md`
- `IMPLEMENTATION_SPEC-{project-name}.md`
- repository URL or local repo path
- existing repo files if available

If the repo is unavailable, stop and record a `BLOCKER`.

## Process

### Step 1 — Load the Existing Repo Context
Read:
- `current_state-{project-name}.json`
- `PROJECT_ROADMAP-{project-name}.md`
- `IMPLEMENTATION_SPEC-{project-name}.md`

Confirm whether the project is in new or adoption mode.

If adoption mode is detected, clone or inspect the existing repo locally before any edits.

### Step 2 — Inventory Key Repository Artifacts
Check for the presence of:
- `Program.cs` / `Startup.cs`
- `*.csproj` and solution files
- `Pages/`, `Models/`, `Services/`
- `wwwroot/admin/config.yml`
- `.github/workflows/*.yml`
- `deploy/` or server provisioning scripts
- `current_state-{project-name}.json`
- `PROJECT_ROADMAP-{project-name}.md`

If any artifact is missing, note it in the assessment report.

### Step 3 — Evaluate Technology Compatibility
For repository files found, determine:
- target framework in `.csproj`
- whether the app is Razor Pages or MVC
- whether the app is already on `.NET 9` or needs migration
- whether Decap CMS is already configured
- whether Kestrel/PathBase settings exist for shared subpath deployment

Write findings as:
- `current_framework`
- `desired_framework` from roadmap
- `adoption_risk` high/medium/low

### Step 4 — Evaluate CI/CD and Deployment Posture
Inspect workflow and deployment files to answer:
- is GitHub Actions already configured?
- does a deploy workflow exist?
- does it deploy to a VPS, Docker, or cloud service?
- are secrets referenced via `${{ secrets.* }}` only?
- is the deploy target root domain or subpath?

Classify the repo as:
- `compatible` — safe to adopt with minimal changes
- `compatible-with-remediation` — needs explicit cleanup or migration tasks
- `incompatible` — should not be imported without major modernization

### Step 5 — Evaluate Decap Baseline
Check `wwwroot/admin/config.yml` and `content/` structure for:
- Decap admin config present
- collections matching the implementation spec
- content source files in JSON/MD format

If Decap is absent, note that the repo is in `adopt-with-remediation` mode and requires `content-model-and-decap-design` before content wiring.

### Step 6 — Document Gap Analysis
Write an `## Existing Repo Assessment` section in `PROJECT_ROADMAP-{project-name}.md` covering:
- repository URL or local path
- detected framework, project type, and deployment type
- CI/CD workflow status
- Decap CMS status
- compatibility classification
- required remediation tasks

Also create a short issue-like gap list in the roadmap:
- `TASK: Migrate from net8.0 to net9.0` if applicable
- `TASK: Preserve existing .github/workflows if working` if actions exist
- `TASK: Add content-model-and-decap-design` if Decap is missing

### Step 7 — Output Adoption Recommendation
Based on findings, choose one:
- `adopt` — repo is safe to bring into WFO with no structural change
- `adopt-with-remediation` — repo can be adopted after explicit fix tasks
- `reject` — repo should not be adopted in current state; propose a new repo instead

Record the recommendation in the roadmap and include a short rationale.

### Step 8 — Update State and Handover
Update `PROJECT_ROADMAP-{project-name}.md` with:
- `[✅ GO] repo-adoption-assessment DONE | YYYY-MM-DD`
- `Adoption recommendation: adopt / adopt-with-remediation / reject`
- next step: `project-scaffolding → Step 1`

Update `current_state-{project-name}.json`:

```json
{
  "phase": "build",
  "active_skill": "repo-adoption-assessment",
  "active_agent": "@Orchestrator",
  "last_completed_step": "repo-adoption-assessment → adoption classification written",
  "next_step": "project-scaffolding → Step 1"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "If the repo compiles, it can be adopted." | Compile success is necessary but not sufficient; CI/CD and deployment posture matter too. |
| "I can replace workflows later." | Existing workflows may already be working; preserving them is safer than overwriting. |
| "If Decap doesn't exist, we can add it after import." | Adding Decap later often requires content model rewrites and breaks traceability. |

## Red Flags

- no `.csproj` found
- `.github/workflows/deploy.yml` exists but uses hard-coded secrets
- existing repo is on `net8.0` while roadmap locks `net9.0` with no migration task
- `wwwroot/admin/config.yml` missing when roadmap requires Decap baseline
- repo contains only frontend assets and no .NET app

## Verification

- [ ] `PROJECT_ROADMAP-{project-name}.md` includes `## Existing Repo Assessment`
- [ ] recommendation is one of `adopt`, `adopt-with-remediation`, or `reject`
- [ ] compatibility classification is documented
- [ ] remediation tasks are listed if needed
- [ ] `current_state-{project-name}.json` points to `project-scaffolding` next
