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
| build | `github-project-bootstrap` | Ready | Create GitHub Issues, labels, and project board from roadmap/spec |
| build | `content-service-and-data-wiring` | Ready | Implement file-based models/services and page data binding |
| build | `integrate-ui-component` | Ready | Assemble Bootstrap-first page UI from implementation contracts |
| build | `seo-aio-optimization` | Ready | Apply SEO/AIO metadata, schema, and discoverability improvements |
| deploy | `security-audit` | Ready | Execute pre-deploy security gate and go/no-go recommendation |

### Agents

| Agent | Status | Purpose |
|---|---|---|
| `@Orchestrator` | Ready | Main entry point, executes all skills directly, manages project state |
| `@Auditor` | Ready | Security gate only — restricted tools (no edit), go/no-go before deploy |

---

## Missing Core Skills

These are the **required skills** to make WFO operational end-to-end.

### 1. `content-model-and-decap-design`
**Priority:** Critical  
**Owner:** `@ContentArchitect` or `@Architect`

Defines the Decap CMS collections, frontmatter/json schemas, editorial workflow, and file layout.

**Why it is needed:**
Right now Decap is assumed as baseline, but there is no dedicated skill to formalize collection design from the sitemap and feature model.

**Outputs should include:**
- `wwwroot/admin/config.yml` structure,
- collection definitions,
- content field schemas,
- sample content files,
- validation rules.

---

### 2. `implementation-batch-planning`
**Priority:** High  
**Owner:** `@Architect`

Breaks the approved spec into execution batches for `@Developer` and `@FrontendUI`.

**Why it is needed:**
The roadmap contains phases, but not execution sequencing at code-change granularity.

**Outputs should include:**
- batch 1/2/3 slices,
- per-batch dependencies,
- estimated review checkpoints,
- GO signal criteria between batches.

---

### 3. `repo-adoption-assessment`
**Priority:** High  
**Owner:** `@Architect`

Formal assessment skill for existing repositories before WFO adopts them.

**Why it is needed:**
PureWipe proved this is a real scenario. `project-scaffolding` can adopt a repo, but a first-class assessment skill will make the process safer and reusable.

**Outputs should include:**
- architecture summary,
- CI/CD status,
- deployment topology,
- secrets posture,
- modernization backlog,
- adoption recommendation: `adopt`, `adopt-with-remediation`, or `reject`.

---

### 4. `quality-smoke-and-acceptance`
**Priority:** High  
**Owner:** `@QA` or `@Auditor`

Runs smoke checks, route checks, content presence checks, and acceptance verification before security/deploy.

**Why it is needed:**
Security is not the same as functional verification. WFO needs a lightweight QA gate before deployment.

**Outputs should include:**
- route smoke checklist,
- missing asset detection,
- content rendering checks,
- acceptance sign-off.

---

### 5. `vps-provisioning`
**Priority:** Critical  
**Owner:** `@DevOps`

Sets up Nginx, systemd, deployment target directory, shared-domain/subpath topology, and release automation.

---

### 6. `release-and-postdeploy-verification`
**Priority:** Medium  
**Owner:** `@DevOps` + `@QA`

Verifies that the deployed site is alive after the pipeline completes.

**Outputs should include:**
- live URL health check,
- static asset verification,
- CMS admin route verification,
- rollback note if needed.

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

1. Finish the core skill chain:
   - `content-model-and-decap-design`
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
2. Create `vps-provisioning/SKILL.md`
3. Create `release-and-postdeploy-verification/SKILL.md`
4. Create `content-model-and-decap-design/SKILL.md`
5. Create `@ContentArchitect.agent.md`
6. Create `@QA.agent.md`
7. Create `quality-smoke-and-acceptance/SKILL.md`

This gives you the minimum viable end-to-end factory.

---

## PureWipe Implication

PureWipe should become the first real test case for:
- `repo-adoption-assessment`
- `github-project-bootstrap`
- issue history per repo
- adoption-mode execution under WFO

That makes it the ideal reference repo for validating the operating model before scaling to more projects.
