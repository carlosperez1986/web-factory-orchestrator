---
name: capability-gap-assessment
description: >
  Determines whether a user request is covered by existing skills and agents,
  or requires creating new capabilities. Produces a formal capability-gap decision
  with recommended action and required artifacts.
phase: "define"
---

# Capability Gap Assessment

## Overview

Evaluates incoming requests against current WFO capabilities and returns a deterministic decision:
- in-scope,
- in-scope-with-extension,
- out-of-scope.

This skill prevents accidental execution of work that lacks skills, agents, blueprints, or gates.

## When to Use

- a new request does not map clearly to current skill chain
- user asks for a different business domain
- orchestrator detects ambiguity in required capabilities
- **NOT for:** executing implementation tasks directly

## Inputs Required

- user request summary
- current skill catalog (`skills/*/SKILL.md`)
- current agent map (`.github/agents/*.agent.md`)
- capability index (`docs/capability-index.md`) if available

If any mandatory input is missing, record a BLOCKER.

## Process

### Step 1 - Normalize the Request
Extract:
- business objective
- expected outputs
- constraints
- required integrations
- risk/compliance implications

### Step 2 - Map Existing Capabilities
Match request needs to:
- existing skills
- existing agents
- existing blueprints
- existing gates

Classify each requirement as:
- covered
- partially covered
- not covered

### Step 3 - Identify Gaps
List gaps in four buckets:
- missing skill logic
- missing agent role/tool scope
- missing blueprint/template
- missing assurance gate

### Step 4 - Decision
Return one decision value:
- `in-scope`
- `in-scope-with-extension`
- `out-of-scope`

### Step 5 - Action Plan
Return one action value:
- `use-existing-skill-chain`
- `create-new-skill`
- `create-new-agent`
- `create-agent-and-skill`
- `escalate-to-human`

For each non-covered area, specify required artifacts and ownership.

### Step 6 - Write Evidence
Create:
- `evidence/capability-gap-{request-id}.json`
- update `docs/capability-index.md` if new capability is approved

## Decision Rubric

Use these thresholds:
- `in-scope`: >= 85% requirements covered, no critical compliance gap
- `in-scope-with-extension`: 50% to 84% covered, gaps can be solved by adding reusable capability
- `out-of-scope`: < 50% covered or critical legal/security gap without owner

## Verification

- [ ] request was normalized with objective, outputs, constraints
- [ ] coverage matrix exists for skills, agents, blueprints, gates
- [ ] decision value is one of the three allowed values
- [ ] action value is one of the allowed actions
- [ ] evidence file exists at `evidence/capability-gap-{request-id}.json`
- [ ] if extension approved, required new artifacts are listed with owners
