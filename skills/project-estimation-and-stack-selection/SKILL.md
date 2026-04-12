---
name: project-estimation-and-stack-selection
description: >
  Produces execution estimates (tokens, time, effort, and vibe-coding cost)
  and recommends the best .NET target framework for the project while enforcing
  Decap CMS as the admin baseline. Use after briefing-synthesis has generated
  PROJECT_ROADMAP.md and before spec-driven-architecture starts.
owner: "@Architect"
phase: "define"
---

# Project Estimation and Stack Selection

## Overview
Converts the initial roadmap into an execution forecast and stack decision package.
Produces a quantified estimate section in `PROJECT_ROADMAP.md` and locks the recommended .NET target framework plus Decap admin baseline for subsequent phases.

## When to Use
- `briefing-synthesis` is complete and `PROJECT_ROADMAP.md` exists.
- The Orchestrator needs a realistic prediction for token/time/effort before Phase 1 approval.
- **NOT for:** detailed sprint planning of implementation tasks — use `spec-driven-architecture` instead.

## Handover Requirement

```text
Requires: @Analyst has completed `briefing-synthesis`.
GO signal must be present in PROJECT_ROADMAP.md:
[✅ GO] @Analyst → @Architect | briefing-synthesis DONE | YYYY-MM-DD
```

## Process

### Step 1 — Read Scope Signals
Read `PROJECT_ROADMAP.md` and extract these inputs:
- Total navigation items
- Count of dynamic pages/components
- Count of integrations or external dependencies
- Count of blockers or clarifications pending

Write the extracted values under `## Estimation Inputs` in `PROJECT_ROADMAP.md`.

### Step 2 — Estimate Tokens
Estimate token consumption per phase using this baseline model:

- Define phase base: 8,000 tokens
- Build phase base: 22,000 tokens
- Deploy phase base: 7,000 tokens
- Per navigation item: +1,200 tokens
- Per dynamic component: +2,000 tokens
- Per external integration: +1,800 tokens
- Per unresolved blocker: +1,000 tokens contingency

Formula:

```text
total_tokens = 37,000
             + (nav_items * 1,200)
             + (dynamic_components * 2,000)
             + (integrations * 1,800)
             + (blockers * 1,000)
```

Write outputs under `## Token Estimate`:
- Best case (0.85 * total_tokens)
- Expected case (1.00 * total_tokens)
- Worst case (1.25 * total_tokens)

### Step 3 — Estimate Time and Effort
Estimate effort and timeline from roadmap complexity:

- Base timeline: 4 working days
- Per nav item: +0.4 days
- Per dynamic component: +0.7 days
- Per integration: +0.5 days
- Per blocker: +0.5 days

Compute:

```text
time_days = 4
          + (nav_items * 0.4)
          + (dynamic_components * 0.7)
          + (integrations * 0.5)
          + (blockers * 0.5)
```

Effort bands:
- Low: <= 5.5 days
- Medium: > 5.5 and <= 8.0 days
- High: > 8.0 days

Write outputs under `## Time and Effort Estimate`:
- Estimated days
- Effort band (Low/Medium/High)
- Top 3 effort drivers

### Step 4 — Estimate Vibe-Coding Cost
Estimate cost for Copilot-assisted execution using:

- `operator_hour_rate_eur` (default 40 EUR/hour unless user provides another rate)
- `hours_per_day` = 6 productive hours
- `estimated_hours = time_days * hours_per_day`
- `execution_cost_eur = estimated_hours * operator_hour_rate_eur`

Also write a normalized model against delivery price:

```text
delivery_price_eur = 850
gross_margin_percent = ((delivery_price_eur - execution_cost_eur) / delivery_price_eur) * 100
```

Write outputs under `## Cost Estimate (Vibe Coding)`:
- Hour rate used
- Estimated hours
- Estimated execution cost
- Estimated gross margin % vs 850 EUR

If gross margin falls below 85%, add a `RISK` note and list scope cuts.

### Step 5 — Select Best .NET Target Framework
Determine the target framework with this decision order:

1. If project dependencies or hosting constraints are known, choose the newest compatible **LTS**.
2. If constraints are unknown, prefer the latest available LTS SDK detected from `dotnet --list-sdks`.
3. If SDK inspection is unavailable, set `target_framework = pending-confirmation` and propose a safe LTS candidate in roadmap notes.
4. Never recommend preview SDKs for production.

Write under `## Stack Decision`:
- `target_framework`
- `decision_basis` (compatibility, hosting, SDK availability)
- `fallback_framework`

### Step 6 — Enforce Decap Admin Baseline
Write/confirm these baseline requirements under `## Stack Decision`:
- Admin system: `Decap CMS`
- Admin route: `/admin/`
- Required config path: `wwwroot/admin/config.yml`
- Content source: Git-based JSON/MD files

If roadmap tasks are missing Decap setup, append missing tasks in Phase 2 before completion.

### Step 7 — Update current_state.json
Update `current_state.json`:

```json
{
  "phase": "define",
  "active_skill": "project-estimation-and-stack-selection",
  "active_agent": "@Architect",
  "last_completed_step": "project-estimation-and-stack-selection → Step 6: Stack decision locked",
  "next_step": "spec-driven-architecture → Step 1 (awaiting user approval)"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Estimating tokens is pointless; we'll see on the fly." | No estimate means no operational control. Token forecasting is mandatory to prevent context and budget drift. |
| "Let's choose the newest .NET no matter what." | Newest is not always safest. The required rule is newest compatible LTS for production stability. |
| "We'll decide CMS admin later." | Decap is a fixed baseline of the factory model. Delaying this breaks roadmap integrity and content architecture. |
| "Cost is always 850 EUR, no need to calculate." | Delivery price is fixed; execution cost is variable. Margin must be measured, not assumed. |

## Red Flags

- `PROJECT_ROADMAP.md` has no `## Token Estimate` section.
- .NET recommendation references preview or RC versions.
- Stack decision omits Decap admin route `/admin/`.
- Gross margin % is missing or not computed against 850 EUR.
- Effort estimate omits complexity drivers.
- `current_state.json` still points to `briefing-synthesis` after estimation completes.

## Verification

- [ ] `## Estimation Inputs` exists in `PROJECT_ROADMAP.md` with nav/dynamic/integration/blocker counts
- [ ] `## Token Estimate` exists with best/expected/worst scenarios and formula-driven values
- [ ] `## Time and Effort Estimate` exists with days, effort band, and 3 effort drivers
- [ ] `## Cost Estimate (Vibe Coding)` exists with hourly rate, hours, execution cost, and gross margin % vs 850 EUR
- [ ] `## Stack Decision` exists with `target_framework`, `decision_basis`, and `fallback_framework`
- [ ] `## Stack Decision` explicitly states Decap CMS admin, `/admin/`, and `wwwroot/admin/config.yml`
- [ ] Phase 2 roadmap tasks include Decap setup tasks if they were missing before this skill
- [ ] `current_state.json` updated to this skill and `next_step` set to `spec-driven-architecture`
- [ ] Human operator sees the estimate summary and is asked: `"Approve estimation and stack decision? Reply 'Proceed' or provide adjustments."`
