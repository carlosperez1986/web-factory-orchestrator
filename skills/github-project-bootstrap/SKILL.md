---
name: github-project-bootstrap
description: >
  Creates GitHub Issues and a GitHub Project board from the approved roadmap and
  implementation spec. Use after spec-driven-architecture is complete and the client
  repository already exists or has been adopted. Produces delivery traceability without
  replacing the roadmap as the architectural source of truth.
phase: "build"
---

# GitHub Project Bootstrap

## Overview
Transforms `PROJECT_ROADMAP-{project-name}.md` and `IMPLEMENTATION_SPEC-{project-name}.md` into executable GitHub delivery tracking.

This skill creates or updates:
- labels,
- issues,
- project board structure,
- roadmap-to-issue mapping.

## When to Use
- `spec-driven-architecture` is complete
- repository exists and has a valid `repo_url`
- the project is ready to move from planning into tracked execution
- **NOT for:** changing architecture, adding scope, or replacing the roadmap

## Handover Requirement

```text
Requires: spec-driven-architecture has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] spec-driven-architecture | architecture spec locked | YYYY-MM-DD
```

## Process

### Remote Execution Contract (Non-Negotiable)
- This skill runs in remote execution mode only.
- Do NOT require local Visual Studio or local VS Code setup to continue.
- Required GitHub auth must be injected in runtime secrets/env (for example `GITHUB_PERSONAL_ACCESS_TOKEN` and/or `GH_TOKEN`).
- If runtime can read but cannot write to GitHub resources, stop with `BLOCKER`.

### Step 0 — GitHub Write Capability Gate (Blocking)
Before any operation, verify the execution environment can perform **write** operations for:
- repository creation (if needed),
- labels,
- issues,
- project board,
- project item updates.

Hard rules:
- Do NOT use ad-hoc `curl` calls to GitHub REST in sandboxed sessions.
- Do NOT fall back to `gh` CLI probing as a substitute for missing write-capable integration.
- If MCP/integration is read-only (list/get/search only), stop immediately.

If write capability is not available, record:
```
BLOCKER: github-project-bootstrap requires write-capable GitHub integration; current session is read-only.

Missing required capabilities (at least one):
- create repository
- create/update labels
- create/update issues
- create/update project board and board items
```

Then stop this skill without attempting partial bootstrap.

### Step 1 — Load Delivery Context
Read:
- `current_state-{project-name}.json`
- `PROJECT_ROADMAP-{project-name}.md`
- `IMPLEMENTATION_SPEC-{project-name}.md`

Confirm these values exist:
- `repo_url`
- implementation batches
- route matrix
- roadmap tasks

If `repo_url` is missing, stop and record a `BLOCKER`.

### Step 2 — Normalize Work Items
Convert roadmap/spec content into execution units.

Each issue candidate must contain:
- title
- phase
- owner label
- scope summary
- acceptance criteria
- dependency notes
- roadmap reference

Group work by:
- Define follow-up
- Build batches
- Deploy preparation
- Risks / decisions if needed

### Step 3 — Prepare Label Model
Ensure the repository has these labels:
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

### Step 4 — Create GitHub Issues
Create one issue per normalized work item.

Each issue body must include:
- summary
- scope
- acceptance criteria
- dependencies
- roadmap reference
- implementation spec reference

Use deterministic titles, for example:
- `[Build] Implement products listing page`
- `[Build] Wire content service for blog posts`
- `[Deploy] Configure shared-domain PATH_BASE deployment`

### Step 5 — Create or Reconcile the GitHub Project Board
Create a project board named:
- `WFO — {project-name}`

Recommended board fields:
- Status
- Phase
- Owner
- Priority
- Blocked By
- Roadmap Ref

Recommended Status values:
- Backlog
- Ready
- In Progress
- Review
- Blocked
- Done

If a board already exists, reconcile it instead of creating a duplicate.

### Step 6 — Add Issues to the Board
Add all created or matched issues to the board and populate core fields:
- Status = `Backlog`
- Phase from roadmap/spec
- Owner from assigned agent role
- Priority from roadmap criticality
- Roadmap Ref as `PROJECT_ROADMAP-{project-name}.md#...`

### Step 7 — Write Traceability Back to the Roadmap
Append a `## Delivery Tracking` section to `PROJECT_ROADMAP-{project-name}.md` containing:
- project board name
- issue count
- issue mapping table
- labels model summary
- note that roadmap remains the design source of truth

### Step 8 — Update State
Update `current_state-{project-name}.json`:

```json
{
  "phase": "build",
  "active_skill": "github-project-bootstrap",
  "active_agent": "@DeliveryManager",
  "last_completed_step": "github-project-bootstrap → Step 7: Delivery tracking created",
  "next_step": "content-model-and-decap-design → Step 1",
  "delivery_board_name": "WFO — {project-name}",
  "issue_tracking_enabled": true
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The roadmap is enough; we don't need issues." | Not for delivery execution. The roadmap is strategic; issues are operational units. |
| "The project board can replace the roadmap." | No. Boards drift. The roadmap remains the design source of truth. |
| "I'll just create tasks manually in GitHub later." | That loses consistency, traceability, and repeatability. WFO should bootstrap them deterministically. |
| "Labels are optional." | Not in a multi-agent factory. Labels are part of execution governance. |

## Red Flags

- issues are created without roadmap references
- the GitHub Project board duplicates an existing board
- labels are inconsistent across repos
- architecture work items are invented beyond the approved spec
- `current_state-{project-name}.json` is not updated after project bootstrap
- delivery board exists but issues are not linked to it

## Verification

- [ ] repository labels exist for phases, owners, types, and priorities
- [ ] issues were created from roadmap/spec artifacts, not invented ad hoc
- [ ] a single delivery board named `WFO — {project-name}` exists or was reconciled
- [ ] all created issues were added to the board
- [ ] `PROJECT_ROADMAP-{project-name}.md` contains a `## Delivery Tracking` section
- [ ] `current_state-{project-name}.json` marks issue tracking as enabled
- [ ] `@Orchestrator` received a structured summary from `@DeliveryManager`
