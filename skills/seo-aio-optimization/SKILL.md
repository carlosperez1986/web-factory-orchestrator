---
name: seo-aio-optimization
description: >
  Applies SEO and AI-optimization improvements to approved pages and content.
  Adds metadata, structured data, internal-linking guidance, and semantic improvements
  to improve discoverability for both search engines and LLM retrieval systems.
phase: "build"
---

# SEO and AIO Optimization

## Overview
Implements semantic discoverability enhancements after UI and content wiring are stable.

This skill covers:
- metadata strategy
- Schema.org structured data
- canonical and indexing rules
- internal linking quality
- LLM-friendly content structure (AIO)

## When to Use
- core UI and content rendering are already working
- page routes and titles are stable
- build-phase execution is in review-hardening mode
- **NOT for:** changing business claims, rewriting architecture, or deployment tasks

## Handover Requirement

```text
Requires: integrate-ui-component has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] integrate-ui-component | UI baseline validated | YYYY-MM-DD
```

## Evidence Output

This skill produces a structured evidence file in JSON format. The @Auditor will verify this file exists and contains acceptable thresholds before issuing the GO signal for the next phase.

**Output file:** `evidence/seo-report-{project-name}.json`

**Schema:**
```json
{
  "project": "pure-wipe",
  "skill": "seo-aio-optimization",
  "date": "2026-04-13T10:30:00Z",
  "pages_optimized": 7,
  "schema_coverage": 6,
  "structured_data_score": 92,
  "metadata_completeness_percent": 95,
  "sitemap_exists": true,
  "robots_txt_exists": true,
  "canonical_consistency": true,
  "internal_linking_quality": "good",
  "aio_readability_score": 88,
  "checked_routes": ["/", "/productos", "/blog"],
  "critical_issues": 0,
  "warnings": 0,
  "findings": []
}
```

**Auditor verification rules (auto-fail if any):**
- `structured_data_score >= 85` ✅
- `metadata_completeness_percent >= 90` ✅
- `sitemap_exists === true` ✅
- `robots_txt_exists === true` ✅
- `canonical_consistency === true` ✅
- `critical_issues === 0` ✅

## Process

### Step 1 — Load Page and Content Context
Read:
- `IMPLEMENTATION_SPEC-{project-name}.md`
- `PROJECT_ROADMAP-{project-name}.md`
- target pages and rendered content structure

Confirm page inventory and intent before optimization.

### Step 2 — Metadata Baseline
Ensure each key page has:
- title strategy
- description strategy
- canonical URL strategy
- social preview basics where applicable

Document coverage and gaps.

### Step 3 — Structured Data Coverage
Define/apply appropriate Schema.org types for page categories.

Examples:
- Organization
- Website
- Product
- BlogPosting
- BreadcrumbList

Avoid over-markup or unverifiable claims.

### Step 4 — Internal Linking and Semantic Structure
Improve discoverability through:
- contextual links between related pages
- consistent heading hierarchy
- meaningful anchor text
- page-topic cohesion

### Step 5 — AIO Readability Pass
Apply AI-discoverability checks:
- concise section labels
- clear entity naming
- FAQ-friendly structuring where relevant
- consistent terminology for core concepts

### Step 6 — Record SEO/AIO Evidence
Append `## SEO and AIO Evidence` in roadmap with:
- page coverage table
- metadata coverage
- schema coverage
- unresolved risks

### Step 7 — Update State
Update `current_state-{project-name}.json`:

```json
{
  "phase": "build",
  "active_skill": "seo-aio-optimization",
  "active_agent": "@Orchestrator",
  "last_completed_step": "seo-aio-optimization → Step 6: SEO/AIO evidence recorded",
  "next_step": "security-audit → Step 1"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "SEO can wait until after launch." | Baseline discoverability should be built before deploy, not retrofitted later. |
| "Schema markup is optional." | Structured data is a core visibility accelerator and should be deliberate. |
| "AIO means stuffing keywords for AI." | AIO is clarity and structure, not keyword spam. |
| "Metadata is enough; internal links don't matter." | Internal linking strongly affects both crawlability and topic understanding. |

## Red Flags

- important pages missing titles or descriptions
- canonical strategy undefined or inconsistent
- schema markup claims unsupported by page content
- no roadmap evidence section for SEO/AIO
- state progression skips security gate

## Verification

- [ ] metadata baseline documented for key pages
- [ ] schema coverage documented and aligned with content
- [ ] internal linking improvements recorded
- [ ] `## SEO and AIO Evidence` exists in roadmap
- [ ] `current_state-{project-name}.json` points to `security-audit`
