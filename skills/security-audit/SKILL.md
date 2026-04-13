---
name: security-audit
description: >
  Performs a structured pre-deploy security and configuration audit for the project.
  Reviews secrets handling, dependency risk, OAuth/auth configuration, deployment
  assumptions, and critical hardening checks before handoff to DevOps.
phase: "deploy"
---

# Security Audit

## Overview
Applies a pre-deploy security gate to ensure the project is safe to release.

This skill validates:
- secrets posture
- dependency and package risk
- authentication/OAuth safety
- infrastructure/deployment config risks
- release readiness from a security perspective

## When to Use
- build-phase implementation is complete
- project is preparing for deploy
- required artifacts are available in repository and roadmap
- **NOT for:** feature development or architecture planning

## Handover Requirement

```text
Requires: seo-aio-optimization has completed and user approved progression to deploy stage.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] seo-aio-optimization | build review passed | YYYY-MM-DD
```

## Process

### Step 1 — Load Security Scope
Read:
- `PROJECT_ROADMAP-{project-name}.md`
- `current_state-{project-name}.json`
- repository config and workflow files

Identify target areas:
- secrets handling
- auth/OAuth routes/config
- deployment scripts and workflow files
- dependency manifests

### Step 2 — Secrets and Configuration Audit
Check for:
- hard-coded secrets in config files
- exposed tokens/credentials in repository
- unsafe defaults in production settings
- insecure callback/base URL mismatches in OAuth flows

Classify each finding by severity.

### Step 3 — Dependency and Supply Chain Risk Review
Review dependencies and package sources for obvious risk indicators.

Minimum checks:
- outdated critical runtime/package versions
- known risky/deprecated packages where visible
- workflow/package source trust assumptions

### Step 4 — Auth and Surface Review
Validate key auth and externally reachable surfaces:
- OAuth endpoint consistency
- redirect URI sanity
- public/admin route expectations
- reverse proxy assumptions and forwarded headers alignment

### Step 5 — Evidence File Verification

Before reviewing deployment artifacts, validate the Task Registry evidence with both binary and threshold checks:

**Phase 1: Binary file existence checks**

```
For each row in PROJECT_ROADMAP-{project-name}.md ## Task Registry where Status = "done":
  1. Read the "Evidence Required" column value (file path relative to client repo root)
  2. Check: does that file EXIST in the client repo?
  3. Check: is the file NON-EMPTY?
  4. For nginx-syntax.log: does content include the string "syntax is ok"?
  5. For security-audit-report.md: does content include "## Security Audit Findings"?
  6. For staging-smoke.md: does content include "HTTP 200" for all checked routes?
  If any check FAILS:
    - Reset that task's Status to "pending" in the Task Registry
    - Log the failure: "EVIDENCE MISSING: TASK-NNN — {file path} not found or empty"
    - DO NOT proceed to GO signal for the affected phase
```

**Phase 2: Threshold-based JSON validation (new — for build-phase artifacts)**

If the evidence file is JSON-formatted, parse and verify the schema fields according to the skill definition:

| Evidence file | Skill | Min-threshold fields |
|---|---|---|
| `evidence/seo-report-{project}.json` | seo-aio-optimization | `structured_data_score >= 85`, `metadata_completeness_percent >= 90`, `sitemap_exists: true`, `robots_txt_exists: true`, `canonical_consistency: true`, `critical_issues: 0` |
| `evidence/quality-smoke-{project}.json` | quality-smoke-and-acceptance | `all_routes_200: true`, `assets_broken: 0`, `forms_validated: true`, `content_present: true`, `critical_issues: 0`, `route_failures: []`, `broken_assets: []` |
| `evidence/ui-smoke-{project}.json` | integrate-ui-component | `pages_passing === pages_implemented`, `layout_renders: true`, `no_broken_assets: true`, `responsive_validated: true`, `a11y_baseline_met: true`, `bootstrap_compliance_percent >= 90`, `custom_css_violations: 0`, `critical_issues: 0` |

For each JSON file:
1. Parse the JSON. If parsing fails → log as `EVIDENCE_CORRUPTION: {file} is not valid JSON` → flag task as `pending`.
2. Verify all min-threshold fields are present.
3. If any threshold is violated → log as `THRESHOLD_VIOLATION: {file} — {field} does not meet minimum requirement` → flag task as `pending` → **do NOT issue GO signal**.
4. If all thresholds pass → continue to next evidence file.

Write a summary of threshold verification results to `evidence/security-audit-report.md` under a new section:

```markdown
## Evidence Threshold Verification

### Build Phase Artifacts
- [ ] seo-report-{project}.json: structured_data_score >= 85 ✅
- [ ] seo-report-{project}.json: metadata_completeness >= 90 ✅
- [ ] quality-smoke-{project}.json: all_routes_200 ✅
- [ ] ui-smoke-{project}.json: a11y_baseline_met ✅

All build-phase evidence files: PASS
```

### Step 6 — Deployment Hardening Review
Inspect deployment artifacts:
- workflow deploy steps
- service definitions
- Nginx/reverse-proxy assumptions
- path-base and domain/subpath consistency

Flag legacy/conflicting deployment models.

### Step 7 — Produce Findings and Remediation Plan
Write findings to roadmap under `## Security Audit Findings` grouped by:
- Critical
- High
- Medium
- Low

For each finding include:
- location
- risk statement
- remediation action
- required owner

### Step 8 — Go/No-Go Decision and State Update
Decision rule:
- any unresolved Critical finding => `NO-GO`
- unresolved High findings => `NO-GO` unless explicit user exception is recorded
- Medium/Low can proceed with tracked backlog if accepted

Update `current_state-{project-name}.json`:

```json
{
  "phase": "deploy",
  "active_skill": "security-audit",
  "active_agent": "@Auditor",
  "last_completed_step": "security-audit → Step 6: Findings documented",
  "next_step": "vps-provisioning → Step 1",
  "security_gate": "GO | NO-GO"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "We'll fix secrets after deployment." | Secrets exposure is a release blocker, not post-release cleanup. |
| "If CI passes, security is fine." | CI success is not a security audit. |
| "Low effort project means low risk." | Small projects still leak credentials or deploy unsafe defaults. |
| "We'll ignore auth edge cases; users are trusted." | OAuth misconfiguration can break admin access or expose token flows. |

## Red Flags

- credentials or client secrets committed in repository
- conflicting production domain/path assumptions across configs
- deploy workflow and runtime configuration mismatches
- no severity classification in findings
- GO decision issued without evidence

## Verification

- [ ] Evidence file verification ran — `evidence/security-audit-report.md` exists and is non-empty
- [ ] All Task Registry rows with Status `done` have valid, non-empty evidence files
- [ ] Any failed evidence checks are logged and affected tasks reset to `pending`
- [ ] `## Security Audit Findings` exists in roadmap with severity groups
- [ ] secrets/config audit completed with explicit evidence
- [ ] dependency risk review completed
- [ ] auth/OAuth review completed
- [ ] deploy hardening review completed
- [ ] `GO` or `NO-GO` decision documented with rationale
- [ ] `current_state-{project-name}.json` includes `security_gate`
