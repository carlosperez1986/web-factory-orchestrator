# Agentic Logic Milestones for Any Business Domain

## Objective

Provide a high-level but operational sequence to implement an agentic factory beyond websites.
This guide is domain-agnostic and can be applied to sales operations, claims processing,
customer support, onboarding, compliance workflows, analytics delivery, or internal automation.

For article-focused framing (concept glossary, layered org chart, and editorial structure), see:
- `docs/agentic-org-chart-article-guide.md`

## Core Principle

Do not start from prompts. Start from contracts, state, blueprints, and evidence.
If any of those four are missing, execution quality degrades and auditability is lost.

## Milestone 0 - Business Boundary and Success Definition

Define what the factory is allowed to do and what it must never do.

Required outputs:
- `BUSINESS_SCOPE-{domain}.md`
- `SUCCESS_METRICS-{domain}.json`

Minimum contents:
- process boundary (in-scope / out-of-scope)
- measurable KPIs (time saved, error rate, SLA, conversion, cost)
- hard constraints (regulatory, privacy, budget, legal)
- decision rights (who can approve phase transitions)

Exit criteria:
- all KPIs are measurable with existing data sources
- one owner is assigned per KPI

## Milestone 1 - Strategy Contract (Machine-Readable)

Convert strategy from prose to data.
This removes interpretation drift between strategist and builder.

Required outputs:
- `STRATEGY_CONTRACT-{initiative}.json`
- `evidence/problem-signals-{initiative}.json`
- `evidence/capability-map-{initiative}.json`

Minimum schema:
- initiative id and business owner
- problem signals with source references
- target capabilities and priority
- constraints and assumptions
- required artifacts for downstream phases

Exit criteria:
- downstream skills can run using only this contract plus state
- no step depends on rereading long briefings

## Milestone 2 - State Model and Resume Logic

Implement deterministic state handling so sessions can resume safely.

Required outputs:
- `current_state-{initiative}.json`
- `STATE_MACHINE-{initiative}.md`

State must include:
- phase
- active skill
- last completed step
- next step
- blocker status
- refs to roadmap and contracts

Exit criteria:
- any operator can resume with zero chat history
- conflicting phase transitions are blocked

## Milestone 3 - Skill Taxonomy and Ownership

Define modular skills by business capability, not by team title.

Required outputs:
- `SKILL_CATALOG.md`
- one `SKILL.md` per capability

Each skill must define:
- trigger conditions
- required inputs
- exact outputs
- red flags
- verification checklist

Exit criteria:
- no overlapping ownership between skills
- each skill has one clear handover target

## Milestone 4 - Blueprint Library (No-Invention Mode)

Create reusable templates for all recurring outputs.
Builders should assemble from blueprints, not invent logic ad hoc.

Required outputs:
- `/blueprints/{domain}/` template set
- token substitution rules document

Blueprint types:
- data schemas
- process templates
- communication templates
- report templates
- automation scripts and runbooks

Exit criteria:
- scaffolding steps are blueprint-only
- missing blueprint raises BLOCKER instead of custom generation

## Milestone 5 - Executable Plan with Hard Evidence

Represent execution as tasks with explicit evidence requirements.

Required outputs:
- `PROJECT_ROADMAP-{initiative}.md`
- `TASK_SCHEMA.json`

Every task must include:
- immutable ID
- owner
- dependencies
- status
- evidence required (file path or command output location)

Exit criteria:
- no task can close without physical evidence artifact
- auditor can validate completion without subjective judgment

## Milestone 6 - Orchestrator Control Plane

Define deterministic start, ambiguity handling, and phase progression.

Required outputs:
- `main-orchestrator.md`
- `.github/agents/orchestrator.agent.md`

Control requirements:
- session start protocol
- command menu for weak prompts
- explicit user gates
- strict sequencing rules

Exit criteria:
- vague prompts route to guided mode
- orchestrator never skips required gates

## Milestone 7 - Build and Integration Wave

Implement the solution in controlled batches with dependency-aware sequencing.

Required outputs:
- `IMPLEMENTATION_SPEC-{initiative}.md`
- batch plan section in roadmap

Batch rules:
- each batch has objective, scope, dependencies, acceptance criteria
- each batch has evidence bundle path
- rollback note for each critical batch

Exit criteria:
- successful smoke checks per batch
- no unresolved blockers before next batch

## Milestone 8 - Quality, Risk, and Compliance Gates

Treat quality and security as mandatory gates, not optional review.

Required outputs:
- `evidence/quality-gate-{initiative}.md`
- `evidence/risk-gate-{initiative}.md`
- `evidence/compliance-gate-{initiative}.md` (if applicable)

Gate rules:
- fail-closed on critical findings
- explicit GO or BLOCKED signal in roadmap
- remediation tasks auto-created when gate fails

Exit criteria:
- no critical or high issues open
- gate owner signs off with timestamp

## Milestone 9 - Release, Verification, and Rollback Readiness

Release only with post-release verification and rollback proof.

Required outputs:
- `RELEASE_PLAN-{initiative}.md`
- `evidence/postrelease-verification-{initiative}.md`
- `ROLLBACK_RUNBOOK-{initiative}.md`

Exit criteria:
- production verification checks pass
- rollback test path documented and executable

## Milestone 10 - Learning Loop and Portfolio Governance

Make improvements systemic, not ad hoc.

Required outputs:
- `RETROSPECTIVE-{initiative}.md`
- updates to skill catalog and blueprints
- governance dashboard entry

Governance checks:
- cycle time trend
- defect leakage trend
- rework causes
- blueprint coverage and reuse ratio

Exit criteria:
- at least one reusable improvement merged into the platform
- measurable KPI movement documented

## Cross-Domain Adaptation Map

| Business domain | Strategy contract focus | Typical evidence artifacts |
|---|---|---|
| Sales operations | lead stages, SLA, qualification rules | funnel snapshots, SLA logs, handoff reports |
| Claims processing | intake quality, fraud checks, payout rules | case audit files, policy match reports, exception logs |
| Customer support | triage taxonomy, escalation policy, resolution SLA | ticket samples, SLA compliance report, KB gap report |
| HR onboarding | policy workflows, approvals, system provisioning | checklist completion logs, account provisioning evidence |
| Procurement | request approvals, vendor controls, spend policy | approval trails, policy conformance report, exception register |
| Finance close | controls, reconciliations, cut-off rules | reconciliation packs, variance evidence, sign-off records |

## Implementation Sequence (High-Level)

1. Define boundary and KPI targets.
2. Publish machine-readable strategy contract.
3. Enable deterministic state and resume logic.
4. Build skill catalog and ownership model.
5. Lock blueprint-only scaffolding.
6. Enforce roadmap task schema with hard evidence.
7. Run orchestrator with guided fallback.
8. Execute build in dependency-aware batches.
9. Enforce quality/risk/compliance gates.
10. Release with post-release verification and rollback proof.
11. Feed learning back into blueprints and skills.

## Non-Negotiables

- No phase transition without GO signal.
- No task closure without evidence artifact.
- No blueprint gap workaround through ad hoc code generation.
- No resume without state file.
- No deploy/release without rollback runbook.
