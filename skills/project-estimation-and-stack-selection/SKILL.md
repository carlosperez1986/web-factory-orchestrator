---
name: project-estimation-and-stack-selection
description: >
  Produces execution estimates (tokens, time, effort, and vibe-coding cost)
  and recommends the best .NET target framework for the project while enforcing
  Decap CMS as the admin baseline. Use after briefing-synthesis has generated
  PROJECT_ROADMAP-{project-name}.md and before spec-driven-architecture starts.
phase: "define"
---

# Project Estimation and Stack Selection

## Overview
Converts the initial roadmap into an execution forecast and stack decision package.
Produces a quantified estimate section in `PROJECT_ROADMAP-{project-name}.md` and locks the recommended .NET target framework plus Decap admin baseline for subsequent phases.

## When to Use
- `briefing-synthesis` is complete and `PROJECT_ROADMAP-{project-name}.md` exists.
- The Orchestrator needs a realistic prediction for token/time/effort before Phase 1 approval.
- **NOT for:** detailed sprint planning of implementation tasks — use `spec-driven-architecture` instead.

## Handover Requirement

```text
Requires: briefing-synthesis has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] briefing-synthesis | DONE | YYYY-MM-DD
```

## Process

### Step 1 — Read Scope Signals
Read `current_state-{project-name}.json` to obtain the `project` field (which is `{project-name}`). Then read `PROJECT_ROADMAP-{project-name}.md` and extract these inputs:
- Total navigation items
- Count of dynamic pages/components
- Count of integrations or external dependencies
- Count of blockers or clarifications pending

Write the extracted values under `## Estimation Inputs` in `PROJECT_ROADMAP-{project-name}.md`.

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

Write outputs under `## Token Estimate` in `PROJECT_ROADMAP-{project-name}.md`:
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

Write outputs under `## Time and Effort Estimate` in `PROJECT_ROADMAP-{project-name}.md`:
- Estimated days
- Effort band (Low/Medium/High)
- Top 3 effort drivers

### Step 4 — Estimate Cost (Human Benchmark + Agentic Execution)

This step produces **two separate cost models** under `## Cost Estimate`.
They must never be merged into a single figure.

---

#### A) Human-Developer Benchmark (REFERENCE ONLY)

> ⚠️ **This model does NOT represent the real execution cost under WFO.**
> It is included as a market-rate reference to show the cost a traditional agency would charge.

Use these parameters:
- `human_dev_hour_rate_eur` (default 40 EUR/hour — senior developer market rate)
- `hours_per_day` = 6 productive hours
- `human_estimated_hours = time_days * hours_per_day`
- `human_execution_cost_eur = human_estimated_hours * human_dev_hour_rate_eur`

Write under `### A) Human-Developer Benchmark [REFERENCE — not applicable under WFO]`:
- Hour rate used (label: "senior dev market rate")
- Estimated hours
- Human execution cost
- Note: `[REFERENCE ONLY — this is the cost a traditional developer would incur, NOT the WFO agentic cost]`

---

#### B) Agentic Execution Cost (REAL WFO COST)

> ✅ **This is the real execution cost of this architecture.**
> The WFO pipeline uses AI agents, not human coding hours.

Use these parameters:
- `total_tokens` from Step 2 (expected case)
- `ai_token_cost_eur_per_1k` = 0.004 EUR (GPT-4o / Claude Sonnet blended rate)
- `copilot_monthly_eur` = 10 EUR; `sites_per_month` = 4 (pro-rata)
- `actions_minutes` = 30; `actions_cost_eur_per_min` = 0.008
- `vps_monthly_eur` = 5 EUR; `sites_active` = 4 (pro-rata)
- `operator_supervision_hours` = 3 (default — human reviews/approvals only, NOT coding)
- `operator_hour_rate_eur` (default 40 EUR/hour)

Compute each line:

```text
token_cost_eur          = (total_tokens / 1000) * ai_token_cost_eur_per_1k
copilot_prorata_eur     = copilot_monthly_eur / sites_per_month
actions_cost_eur        = actions_minutes * actions_cost_eur_per_min
vps_prorata_eur         = vps_monthly_eur / sites_active
infra_subtotal_eur      = token_cost_eur + copilot_prorata_eur + actions_cost_eur + vps_prorata_eur

supervision_cost_eur    = operator_supervision_hours * operator_hour_rate_eur

agentic_total_cost_eur  = infra_subtotal_eur + supervision_cost_eur
```

Compute gross margin against delivery price:

```text
delivery_price_eur   = 850
gross_margin_percent = ((delivery_price_eur - agentic_total_cost_eur) / delivery_price_eur) * 100
```

Write under `### B) Agentic Execution Cost [REAL WFO COST]`:
- Itemized table: AI tokens, Copilot pro-rata, CI/CD, VPS pro-rata, operator supervision
- Infra subtotal
- Supervision cost (label clearly: "operator supervision — reviews and approvals only, not coding")
- **Agentic total cost**
- **Gross margin % vs 850 EUR**

If gross margin on the agentic model falls below 85%, add a `RISK` note and list potential scope cuts.

### Step 5 — Select Best .NET Target Framework
Determine the target framework with this decision order:

1. If project dependencies or hosting constraints are known, choose the newest compatible **LTS**.
2. If constraints are unknown, prefer the latest available LTS SDK detected from `dotnet --list-sdks`.
3. If SDK inspection is unavailable, set `target_framework = pending-confirmation` and propose a safe LTS candidate in roadmap notes.
4. Never recommend preview SDKs for production.

Write under `## Stack Decision` in `PROJECT_ROADMAP-{project-name}.md`:
- `target_framework`
- `decision_basis` (compatibility, hosting, SDK availability)
- `fallback_framework`

### Step 6 — Enforce Decap Admin Baseline
Write/confirm these baseline requirements under `## Stack Decision` in `PROJECT_ROADMAP-{project-name}.md`:
- Admin system: `Decap CMS`
- Admin route: `/admin/`
- Required config path: `wwwroot/admin/config.yml`
- Content source: Git-based JSON/MD files

If roadmap tasks are missing Decap setup, append missing tasks in Phase 2 before completion.

### Step 7 — Update current_state-{project-name}.json
Update `current_state-{project-name}.json`:

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
| "The human-dev hours × rate IS the agentic cost." | Wrong. The WFO does not pay for 55 human coding hours. The real cost is AI tokens + infra pro-rata + a few hours of operator supervision. The human benchmark is reference-only. |
| "I'll just show one combined cost number." | Two models are mandatory. Merging them hides the actual margin advantage of the agentic architecture and produces misleading economics. |

## Red Flags

- `PROJECT_ROADMAP-{project-name}.md` has no `## Token Estimate` section.
- .NET recommendation references preview or RC versions.
- Stack decision omits Decap admin route `/admin/`.
- `## Cost Estimate` shows only one cost block (human OR agentic) instead of both.
- Human-developer benchmark is not explicitly labelled `[REFERENCE ONLY]`.
- Gross margin % computed against the human benchmark instead of the agentic total.
- Operator supervision hours conflated with coding hours in the agentic block.
- Agentic cost block missing any of: AI tokens, Copilot pro-rata, CI/CD, VPS pro-rata.
- Effort estimate omits complexity drivers.
- `current_state-{project-name}.json` still points to `briefing-synthesis` after estimation completes.

## Verification

- [ ] `## Estimation Inputs` exists in `PROJECT_ROADMAP-{project-name}.md` with nav/dynamic/integration/blocker counts
- [ ] `## Token Estimate` exists with best/expected/worst scenarios and formula-driven values
- [ ] `## Time and Effort Estimate` exists with days, effort band, and 3 effort drivers
- [ ] `## Cost Estimate` contains **two sub-sections**: `### A) Human-Developer Benchmark` and `### B) Agentic Execution Cost`
- [ ] Sub-section A is explicitly labelled `[REFERENCE ONLY — not applicable under WFO]`
- [ ] Sub-section B contains itemized agentic costs: AI tokens, Copilot pro-rata, CI/CD minutes, VPS pro-rata, operator supervision
- [ ] Operator supervision hours in sub-section B are clearly labelled as reviews/approvals only, NOT coding hours
- [ ] Gross margin % computed against **agentic total** (sub-section B), not human benchmark
- [ ] `## Stack Decision` exists with `target_framework`, `decision_basis`, and `fallback_framework`
- [ ] `## Stack Decision` explicitly states Decap CMS admin, `/admin/`, and `wwwroot/admin/config.yml`
- [ ] Phase 2 roadmap tasks include Decap setup tasks if they were missing before this skill
- [ ] `current_state-{project-name}.json` updated to this skill and `next_step` set to `spec-driven-architecture`
- [ ] Human operator sees the estimate summary and is asked: `"Approve estimation and stack decision? Reply 'Proceed' or provide adjustments."`
