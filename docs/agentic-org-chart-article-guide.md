# Agentic Org Chart - Article Guide

## Purpose

This document helps you write a clear article about how to design an agentic operating model.
It is focused on executive-level decisions: governance, org design, control model, and scaling path.

## Executive Lens

For an executive audience, this is not a technical story first.
It is an operating model story:
- who decides,
- who executes,
- how risk is controlled,
- how scale is achieved without losing quality.

## Article Thesis

An agentic factory is not a prompt trick.
It is an operating system made of:
- contracts,
- state,
- skills,
- blueprints,
- evidence,
- and strict gates.

If one layer is missing, the model becomes inconsistent, non-auditable, or expensive.

## Executive Start Map (Recommended Narrative Order)

Use this exact order in the article so the reader sees organizational logic before technical detail.

1. Start with the operating playbook (`README.md` + `main-orchestrator.md`)
- explain mission, boundaries, and command model
- explain what the organization is trying to standardize

2. Define capability model (what the organization can do today)
- current skill catalog
- current agent roles and decision rights
- known capability gaps

3. Explain skill architecture (modular execution units)
- each skill has Inputs Required, Process, Red Flags, Verification
- skills are capability modules, not team titles

4. Explain `spec-driven-architecture` as the bridge
- strategy intent becomes implementation contract
- this is where ambiguity must collapse into explicit scope

5. Explain blueprint model (no-invention execution)
- builders assemble from templates/contracts
- custom generation without blueprint is a blocker

6. Explain gates and evidence
- evidence comes after execution design, not before
- no done status without physical artifacts

7. Explain scaling loop
- pilot initiative
- governance review
- skill/agent updates
- portfolio rollout

## Organizational Points to Consider

These are the executive checkpoints to include in the article.

1. Decision rights
- who can approve GO/BLOCKED gates
- who can create or deprecate skills/agents

2. Risk ownership
- who owns security, compliance, legal, and operational risk
- how fail-closed behavior is enforced

3. KPI ownership
- one accountable owner per KPI
- KPI linked to initiative-level evidence

4. Cost-to-scale model
- marginal cost per new initiative
- blueprint reuse ratio
- defect leakage trend

5. Change governance
- how new requests are triaged (in-scope vs extension)
- when to create new skill vs new agent

6. Auditability
- where evidence is stored
- how audits are run without chat transcript dependency

## Core Concepts You Should Explain

### 0) Knowledge Base (KB)
The KB is the operational memory of the factory.

What to include:
- every capability should be documented as a typed knowledge object
- skill anatomy sections (`Inputs Required`, `Red Flags`, `Verification`) should be indexed in KB
- KB entries need owner, status, version, and evidence references

Reference:
- `docs/agentic-knowledge-base-schema.md`

### 1) Operating Playbook
The operating playbook is the organization-level contract for how work starts, flows, and stops.

What to include in the article:
- `README.md` as strategic orientation
- `main-orchestrator.md` as deterministic command model
- explicit user/approval gates

### 2) Session Mining (or Session Minning in informal usage)
Session mining means extracting durable state from chat/session context so execution can resume without ambiguity.

What to include:
- session memory is volatile
- state files are persistent
- the orchestrator must reconstruct execution from state first, not from chat history

Key artifact:
- `current_state-{initiative}.json`

### 3) Skills
Skills are deterministic workflows with explicit IO.

What to include:
- each skill has trigger, inputs, outputs, red flags, verification
- skills are modular and composable
- skills should be capability-based, not persona-based

### 4) Agents
Agents are control roles, not job titles.

What to include:
- one orchestrator for flow control
- optional specialist agents with constrained tools
- auditor as independent gatekeeper

What to add for article depth:
- agents are optional unless capability boundaries or tool restrictions require them
- when only workflow logic changes, create/extend a skill first
- create a new agent only when role isolation or tool policy isolation is needed

### 5) Contracts and Spec-Driven Architecture
Contracts connect strategy and execution.

What to include:
- prose strategy is not enough
- machine-readable contracts reduce interpretation drift
- `spec-driven-architecture` is the bridge from business intent to executable scope

Key artifact:
- `STRATEGY_CONTRACT-{initiative}.json`

### 6) Blueprints
Blueprints are reusable implementation templates.

What to include:
- blueprint-first execution prevents reinvention
- token substitution is allowed
- ad hoc logic generation should be blocked when blueprint is missing

### 7) Evidence
Evidence is the physical proof that a task was completed.

What to include in the article:
- evidence is not narrative text
- evidence must be file-based or command-output based
- every task should define evidence before execution starts

Examples:
- `evidence/sitemap-initiative.json`
- `evidence/security-audit-report.md`
- workflow run URL or build log artifact

### 8) Gates
Gates are hard decision points with GO/BLOCKED outcomes.

What to include:
- no phase transition without gate approval
- no task closure without evidence
- quality/security/compliance gates should fail closed

## Agentic Org Chart (Layered Model)

Use this as the high-level organization model in your article.

### Layer A - Control Plane
Role:
- Orchestrator

Responsibility:
- route intent
- activate skills
- enforce sequence and gates
- maintain state transitions

Primary artifacts:
- `main-orchestrator.md`
- `current_state-{initiative}.json`

### Layer B - Strategy Plane
Roles:
- Strategist capability (can be orchestrator-executed skill)

Responsibility:
- convert business intent into machine-readable contract
- define KPIs and constraints

Primary artifacts:
- `STRATEGY_CONTRACT-{initiative}.json`
- `PROJECT_ROADMAP-{initiative}.md`

### Layer C - Build Plane
Roles:
- Builder capabilities (domain-specific skills)

Responsibility:
- execute batches
- produce deliverables from blueprints/contracts

Primary artifacts:
- `IMPLEMENTATION_SPEC-{initiative}.md`
- blueprint outputs
- batch evidence bundles

### Layer D - Assurance Plane
Roles:
- Auditor capability

Responsibility:
- verify evidence
- run quality/risk/compliance checks
- issue GO/BLOCKED signals

Primary artifacts:
- `evidence/quality-gate-{initiative}.md`
- `evidence/risk-gate-{initiative}.md`
- security/compliance reports

### Layer E - Learning Plane
Roles:
- Platform owner / governance capability

Responsibility:
- retrospective analysis
- update skills and blueprints
- track portfolio metrics

Primary artifacts:
- `RETROSPECTIVE-{initiative}.md`
- updated skill and blueprint versions

## High-Level Milestones for Any Business Domain

1. Define business boundary and measurable outcomes.
2. Publish strategy contract and source evidence artifacts.
3. Establish deterministic state and resume model.
4. Define skill taxonomy and ownership boundaries.
5. Build blueprint library and enforce no-invention policy.
6. Encode executable roadmap with evidence-per-task.
7. Enable orchestrator control plane with guided fallback.
8. Execute build in dependency-aware batches.
9. Enforce assurance gates (quality, risk, compliance).
10. Release with post-release verification and rollback readiness.
11. Close loop with retrospective and platform improvements.

## Capability Triage: Do We Need New Skills or Agents?

Include this decision model in the article.

1. Is the request covered by existing skills and blueprints?
- yes -> run existing chain
- no -> go to 2

2. Is the gap workflow logic only?
- yes -> create/extend skill
- no -> go to 3

3. Is there a role/tool-scope isolation need?
- yes -> create new agent (and skill if needed)
- no -> escalate for human decision

Operational artifact:
- `skills/capability-gap-assessment/SKILL.md`
- `evidence/capability-gap-{request-id}.json`

## Anti-Patterns to Call Out

- Prompt-only orchestration with no state file.
- Strategy in long markdown prose only, no contract.
- Task completion based on chat statements without evidence files.
- Builders generating custom logic when blueprint coverage is missing.
- Security review performed as advice instead of a hard gate.

## Suggested Article Structure

1. Executive problem: scale without losing control.
2. Operating playbook first: README and orchestrator command model.
3. Org chart: layered control/strategy/build/assurance/learning planes.
4. Capability model: skills, agents, and ownership boundaries.
5. Spec-driven bridge: how strategy becomes executable scope.
6. Governance model: evidence and gates as control system.
7. Adoption path: pilot, measure, standardize, scale.

## Minimal Diagram Pack for the Article

Ready-to-use versions of these diagrams are available in:
- `docs/agentic-executive-diagrams.md`

- Layered org chart (5 planes)
- Artifact flow (contract -> roadmap -> build -> evidence -> gate)
- State lifecycle (define -> build -> assurance -> release)
- Governance loop (retro -> blueprint update -> next initiative)

## One-Line Summary for Publication

Agentic execution becomes reliable only when prompts are subordinated to contracts, state, blueprints, evidence, and gates.
