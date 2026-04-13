# Main Orchestrator Manual

## Purpose

This file is the operator and AI fallback manual for running WFO when user intent is ambiguous.
Use it as a deterministic entrypoint menu.

For cross-domain implementation planning beyond websites, also use:
- `docs/agentic-business-milestones.md`

## Default Rule

At session start, always do this first:
1. Read `current_state-*.json` files.
2. If active projects exist, ask which project to resume.
3. If no state exists, start new project intake.

## Command Menu (Canonical)

Use these exact intents:

1. New project
- Trigger words: `new project`, `new client`, `start factory`, `briefing`
- Action: run `briefing-synthesis` then `project-estimation-and-stack-selection`
- Required artifacts after briefing-synthesis:
  - `STRATEGY_CONTRACT-{project-name}.json`
  - `evidence/sitemap-{project-name}.json`
  - `evidence/feature-components-{project-name}.json`
- Stop at approval gate and wait for `Proceed`

2. Resume project
- Trigger words: `resume {project}`, `status {project}`
- Action: read `current_state-{project}.json` and `PROJECT_ROADMAP-{project}.md`
- Continue from `next_step`

3. Apply roadmap changes
- Trigger words: `change roadmap`, `update scope`, `modify plan`
- Action: patch roadmap, re-validate dependencies and handover log

4. Start build phase
- Trigger words: `proceed`, `go ahead`, `continue build`
- Action order:
  - `project-scaffolding`
  - `spec-driven-architecture`
  - `look-and-feel-ingestion`
  - `github-project-bootstrap`
  - `content-service-and-data-wiring`
  - `integrate-ui-component`
  - `seo-aio-optimization`

5. Start deploy phase
- Trigger words: `deploy`, `ship`, `go production`
- Action order:
  - `quality-smoke-and-acceptance`
  - `security-audit` (delegate to `@Auditor`)
  - `vps-provisioning`
  - `release-and-postdeploy-verification`

6. Assess capability fit
- Trigger words: `is this in scope`, `do we need a new skill`, `do we need a new agent`, `capability gap`
- Action: run `capability-gap-assessment`
- Output: `in-scope` | `in-scope-with-extension` | `out-of-scope` + required new artifacts

## Visual Intake Rule

Before `integrate-ui-component`, the Orchestrator must ask for one visual source:
- image set,
- reference URL,
- Stitch artifacts,
- or Stitch token/session context.

Output required:
- `DESIGN_STYLE_CONTRACT-{project-name}.md`

If visual source is missing, stop with BLOCKER.

## Evidence Rule (Task Completion)

No task may be marked done without explicit evidence.
Minimum evidence types:
- file path evidence,
- build/test command output,
- route smoke check output,
- issue/board URL for tracking steps,
- GO signal entry in roadmap when required.

## Ambiguity Handler (When prompt is weak)

If the user prompt is too vague, ask one menu question only:

"Choose one: 1) new project, 2) resume project, 3) update roadmap, 4) continue build, 5) deploy"

If the user asks for a new domain or unclear capability, add option 6:
"6) assess capability fit"

Do not execute skills until one option is selected.

## Safety Rules

- Never proceed past Phase 1 without explicit `Proceed`.
- Never create a GitHub repo without explicit confirmation.
- Never skip security gate before provisioning.
- Never mark done without evidence.
