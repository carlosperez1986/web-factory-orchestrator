# WFO Skill and Agent Roadmap

## Objective

Define the minimum complete WFO operating model before executing projects at scale.

The current state is strong in **Phase 1 (Define)**, but still incomplete in **Phase 2 (Build)** and **Phase 3 (Deploy)**. This document identifies:
- current skills and agents,
- missing skills and agents,
- what is required to start real execution safely,
- how GitHub Projects should be used per client repository.

---

## Current Coverage

### Existing Skills

| Phase | Skill | Status | Purpose |
|---|---|---|---|
| define | `briefing-synthesis` | Ready | Extract business intent, sitemap, and roadmap skeleton |
| define | `project-estimation-and-stack-selection` | Ready | Estimate cost/time/tokens and lock stack decisions |
| define | `spec-driven-architecture` | Ready | Convert roadmap into implementation-ready technical spec |
| build | `project-scaffolding` | Ready (v1) | Create, detect, or adopt repository and seed project structure |
| build | `repo-adoption-assessment` | Ready | Assess existing repo compatibility and adoption risk |
| build | `content-model-and-decap-design` | Ready | Define Decap CMS collections and Git-based content schemas |
| build | `github-project-bootstrap` | Ready | Create GitHub Issues, labels, and project board from roadmap/spec |
| build | `content-service-and-data-wiring` | Ready | Implement file-based models/services and page data binding |
| build | `integrate-ui-component` | Ready | Assemble Bootstrap-first page UI from implementation contracts |
| build | `seo-aio-optimization` | Ready | Apply SEO/AIO metadata, schema, and discoverability improvements |
| deploy | `security-audit` | Ready | Execute pre-deploy security gate and go/no-go recommendation |
| deploy | `quality-smoke-and-acceptance` | Ready | Validate site health, routes, assets and acceptance criteria before security audit |
| deploy | `release-and-postdeploy-verification` | Ready | Confirm live deployment, asset delivery, admin access and rollback readiness after production deploy |
| deploy | `vps-provisioning` | Ready | Generate Nginx, systemd, GitHub Actions CD artifacts for Debian 11 VPS |

### Agents

| Agent | Status | Purpose |
|---|---|---|
| `@Orchestrator` | Ready | Main entry point, executes all skills directly, manages project state |
| `@Auditor` | Ready | Security gate only — restricted tools (no edit), go/no-go before deploy |

---

## Missing Core Skills

These are the **required skills** still needed to make WFO operational end-to-end.

### 1. `implementation-batch-planning`
**Priority:** High  
**Owner:** `@Architect`

Breaks the approved spec into execution batches for `@Developer` and `@FrontendUI`.

**Why it is needed:**
The roadmap contains phases, but not execution sequencing at code-change granularity.

**Outputs should include:**
- batch slices and order,
- per-batch dependencies,
- estimated review checkpoints,
- GO signal criteria between batches.

---

## Missing Core Agents

### Remaining Agent Gaps

`@Developer`, `@FrontendUI`, and `@Auditor` are now available.

Still recommended/needed:
- `@DevOps` (required for provisioning and release)
- `@ContentArchitect` (recommended for Decap/content contracts)
- `@QA` (recommended for smoke/acceptance checks)

### 1. `@DevOps`
**Status:** Required  
Needed for:
- `vps-provisioning`
- deploy verification

### 2. `@ContentArchitect`
**Status:** Recommended  
Needed for:
- Decap collection design,
- content schemas,
- editorial workflows.

### 3. `@QA`
**Status:** Recommended  
Needed for:
- smoke tests,
- acceptance checks,
- route/content validation before deploy.

---

## What Is Needed Before Real Execution Starts

Once analysis and architecture are stable, WFO still needs these foundations before it should run production work repeatedly.

### Required Before Starting

1. Run the core skill chain on a first project:
   - `content-model-and-decap-design`
   - `quality-smoke-and-acceptance`
   - `security-audit`
   - `vps-provisioning`
   - `release-and-postdeploy-verification`

2. Create the minimum remaining agents:
   - `@DevOps`

3. Define the blueprints that these skills will rely on:
   - .NET project templates
   - page templates
   - Decap config templates
   - GitHub workflow templates
   - Nginx/systemd templates

4. Decide the operational source of truth hierarchy:
   - `PROJECT_ROADMAP-{project-name}.md` = strategic source of truth
   - GitHub Issues = execution units
   - GitHub Project = delivery board and project history
   - `current_state-{project-name}.json` = orchestration runtime state

---

## GitHub Projects Strategy

## Recommendation

**Yes:** each client repository should have its own GitHub Project and issue history.

This is a good fit because each website is effectively its own delivery stream. It gives you:
- execution history,
- accountability,
- status visibility,
- traceability from roadmap to issue to deploy,
- easier audits later.

## Proposed Model

### Per Repo
Each client repo should contain:
- `PROJECT_ROADMAP-{project-name}.md`
- `current_state-{project-name}.json`
- GitHub Issues
- one GitHub Project board

### Mapping

| Artifact | Purpose |
|---|---|
| `PROJECT_ROADMAP-{project-name}.md` | High-level source of truth |
| GitHub Issue | Executable work item |
| GitHub Project card/item | Delivery tracking and history |
| `current_state-{project-name}.json` | Current orchestration pointer |

### Recommended Issue Types

- `Epic` — only for major phase chunks if needed
- `Task` — default implementation item
- `Bug` — defects and regressions
- `Decision` — architecture/infra decisions that must stay visible
- `Risk` — security, infra, secrets, or operational risks

### Recommended Labels

- `phase:define`
- `phase:build`
- `phase:deploy`
- `owner:architect`
- `owner:developer`
- `owner:frontend`
- `owner:auditor`
- `owner:devops`
- `type:task`
- `type:bug`
- `type:risk`
- `priority:high`
- `priority:medium`
- `priority:low`

### Recommended Project Fields

- `Status` → Backlog / Ready / In Progress / Review / Blocked / Done
- `Phase` → Define / Build / Deploy
- `Owner`
- `Priority`
- `Blocked By`
- `Roadmap Ref`

---

## How WFO Should Use GitHub Projects

### Best Practice

WFO should not use GitHub Projects as the primary source of truth.

Instead:
1. Skills generate and update `PROJECT_ROADMAP-{project-name}.md`
2. `github-project-bootstrap` converts roadmap tasks into GitHub Issues
3. Issues are added to the repo's GitHub Project
4. Agents update issue status as work progresses
5. Important outcomes are written back into the roadmap

This prevents the board from drifting away from the design intent.

---

## Recommended Next Build Order

### Order for the next implementation wave

1. Create `@DevOps.agent.md`
2. Create `@ContentArchitect.agent.md`
3. Create `@QA.agent.md`
4. Create `implementation-batch-planning/SKILL.md`
5. Review and finalize `quality-smoke-and-acceptance/SKILL.md` and `release-and-postdeploy-verification/SKILL.md`

This gives you the remaining minimum end-to-end factory.

---

## PureWipe Implication

PureWipe should become the first real test case for:
- `repo-adoption-assessment`
- `github-project-bootstrap`
- issue history per repo
- adoption-mode execution under WFO

That makes it the ideal reference repo for validating the operating model before scaling to more projects.
