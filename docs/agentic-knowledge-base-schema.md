# Agentic Knowledge Base Schema

## Purpose

Define a reusable schema for documenting operational knowledge in agentic systems.
This schema is designed for cross-domain use and should be applied to skills, agents,
gates, and orchestration decisions.

## Why This Matters

A knowledge base without structure becomes narrative noise.
A structured KB enables deterministic execution, auditability, and capability planning.

## Knowledge Object Types

1. Skill knowledge object
2. Agent knowledge object
3. Gate knowledge object
4. Blueprint knowledge object
5. Incident knowledge object
6. Capability-gap decision object

## Canonical Fields (All Objects)

- `id`: immutable identifier
- `title`: short descriptive name
- `type`: skill | agent | gate | blueprint | incident | capability-gap
- `domain`: business domain (sales, claims, support, etc.)
- `owner`: accountable role
- `status`: draft | active | deprecated
- `version`: semantic version
- `last_updated`: ISO date
- `source_refs`: related files or evidence paths

## Skill Knowledge Schema

Required sections for every skill entry:
- Inputs Required
- Outputs Produced
- Preconditions
- Process Steps
- Red Flags
- Verification
- Escalation Path

Minimum metadata block:

```yaml
id: SKILL-KB-001
type: skill
domain: generic
owner: orchestrator
status: active
version: 1.0.0
last_updated: 2026-04-13
```

## Agent Knowledge Schema

Required sections:
- Role Purpose
- Tool Scope (allowed and forbidden)
- Decision Rights
- Handovers (from/to)
- Failure Modes
- Verification Expectations

## Gate Knowledge Schema

Required sections:
- Gate Name
- Trigger Point
- Pass Criteria
- Fail Criteria
- Required Evidence Files
- GO/BLOCKED signal format

## Capability-Gap Decision Schema

Use this object to decide if a new request is in scope.

Required sections:
- Request summary
- Existing capability matches
- Missing capabilities
- Risk of proceeding without extension
- Decision
- Action

Decision values:
- `in-scope`
- `in-scope-with-extension`
- `out-of-scope`

Action values:
- `use-existing-skill-chain`
- `create-new-skill`
- `create-new-agent`
- `create-agent-and-skill`
- `escalate-to-human`

Example:

```json
{
  "id": "CAP-GAP-2026-04-13-001",
  "request": "Automate claims triage with compliance checks",
  "matches": ["orchestrator", "quality gate"],
  "missing": ["claims policy parser", "fraud scoring adapter"],
  "decision": "in-scope-with-extension",
  "action": "create-new-skill",
  "required_artifacts": [
    "skills/claims-triage/SKILL.md",
    "blueprints/claims/triage-template.json"
  ]
}
```

## Evidence Standards (Hard Rules)

- Every KB object must reference at least one physical artifact.
- Verification cannot be "reviewed in chat".
- Evidence file paths must be workspace-relative.
- Deprecated objects must include replacement references.

## Governance Workflow

1. Propose object.
2. Validate schema completeness.
3. Link evidence.
4. Approve and publish.
5. Add to capability index.
6. Review quarterly or after incidents.

## Capability Index

Maintain a searchable index file:
- `docs/capability-index.md`

Each row should include:
- capability name
- current owner
- mapped skill(s)
- mapped agent(s)
- maturity level
- known gaps
