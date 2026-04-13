# PROJECT_ROADMAP-{project-name}.md — Canonical Template
> WFO Blueprint · Read-only · Do not edit per-project roadmaps from this file — copy the structure.
>
> **Skill reference:** `briefing-synthesis` uses this template in Step 4.
> **ID rules:** IDs are immutable once assigned. Never renumber. Skip deleted IDs.
> **Status values:** `pending` | `in-progress` | `done` | `blocked`
> **Evidence Required:** file path relative to the CLIENT REPOSITORY root. `@Auditor` verifies
> each file exists and is non-empty before issuing a GO signal for that task.

---

**Project:** {Project Display Name}
**Client:** {Client Name} · Atención: {Contact Person}
**Value:** USD ${amount}
**Briefing source:** `inbox/{briefing-filename}`
**Date initialized:** {YYYY-MM-DD}
**Skill executed:** `briefing-synthesis`

---

## Detected Motives

> Evidence: signals extracted verbatim from briefing source. Do not paraphrase.

- **{Motive}** — Signals: "{exact quote from briefing}"

---

## Sitemap

> Rules applied: C (always Inicio), A (Lead Gen → Contáctenos), B (Catalog → Productos), D (≤ 7 nav items).

```json
{
  "nav": [
    { "label": "Inicio",    "slug": "/",         "template": "home",    "rule": "C — always required" },
    { "label": "Nosotros",  "slug": "/nosotros",  "template": "about",   "rule": "Brand Info detected" },
    { "label": "Contáctenos","slug": "/contacto", "template": "contact", "rule": "A — Lead Generation detected" }
  ]
}
```

**Nav item count:** N — ✅ within Rule D maximum.

### Sitemap Table

| # | Página | Slug | Template | Justificación (evidence from briefing) |
|---|--------|------|----------|----------------------------------------|
| 1 | **Inicio** | `/` | `home` | Rule C — required root page. |

---

## Feature Components

| Component | Required | Trigger |
|-----------|----------|---------|
| `json-content-service` | ✅ Yes | Every project — no exceptions |
| `marketing-seo-pack` | ✅ Yes | Every project — AIO always required |
| `decap-admin-panel` | ✅ Yes | Every project — `/admin/` default |
| `contact-form-handler` | conditional | Lead Generation motive detected |
| `dynamic-content-grid` | conditional | Product Catalog motive detected |

---

## Task Registry

> IDs are permanent. Assign sequentially; do not reuse a deleted ID.
> Column "Evidence Required" holds the path the @Auditor checks before marking a task `done`.
> For markdown checklist style tasks, append `| Evidence required: ...` on every line.
> A task without explicit evidence cannot be closed.

| ID | Task | Phase | Owner | Status | Evidence Required |
|----|------|-------|-------|--------|-------------------|
| TASK-001 | Define Razor Page spec: Inicio (`/`) | Phase 1 | @Orchestrator | pending | `evidence/spec-inicio.md` |
| TASK-002 | Define Razor Page spec: Nosotros (`/nosotros`) | Phase 1 | @Orchestrator | pending | `evidence/spec-nosotros.md` |
| TASK-003 | Define Razor Page spec: Contáctenos (`/contacto`) | Phase 1 | @Orchestrator | pending | `evidence/spec-contacto.md` |
| TASK-010 | Define C# content models for all approved pages | Phase 1 | @Orchestrator | pending | `evidence/models-review.md` |
| TASK-011 | Define Decap CMS collection schema (`config.yml`) | Phase 1 | @Orchestrator | pending | `wwwroot/admin/config.yml` |
| TASK-020 | Scaffold .NET {{DOTNET_VERSION}} project from blueprint | Phase 2 | @Orchestrator | pending | `Program.cs` exists in repo |
| TASK-021 | Implement `json-content-service` | Phase 2 | @Orchestrator | pending | `Services/ContentService.cs` exists |
| TASK-022 | Implement `contact-form-handler` | Phase 2 | @Orchestrator | pending | `evidence/form-handler-smoke.md` |
| TASK-023 | Implement `marketing-seo-pack` (Schema.org + AIO meta) | Phase 2 | @Orchestrator | pending | `evidence/seo-audit-pass.md` |
| TASK-024 | Assemble UI: Inicio | Phase 2 | @Orchestrator | pending | `Pages/Index.cshtml` exists |
| TASK-025 | Assemble UI: Nosotros | Phase 2 | @Orchestrator | pending | `Pages/Nosotros.cshtml` exists |
| TASK-026 | Assemble UI: Contáctenos | Phase 2 | @Orchestrator | pending | `Pages/Contacto.cshtml` exists |
| TASK-027 | Global components: Header, Footer, WhatsApp button | Phase 2 | @Orchestrator | pending | `Pages/Shared/_Layout.cshtml` exists |
| TASK-030 | Security audit — secrets + dep scan | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-031 | Security audit — auth/OAuth surface review | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-032 | Security audit — deploy hardening review | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-040 | VPS provisioning — Nginx + Systemd config | Phase 3 | @Orchestrator | pending | `evidence/nginx-syntax.log` |
| TASK-041 | CI/CD GitHub Actions workflow | Phase 3 | @Orchestrator | pending | `.github/workflows/deploy.yml` exists |
| TASK-042 | Deploy to staging URL (client review) | Phase 3 | @Orchestrator | pending | `evidence/staging-smoke.md` |
| TASK-043 | Final deploy to production URL | Phase 3 | @Orchestrator | pending | `evidence/prod-deploy.md` |

---

## Phase GO Signals

> A GO signal is written here by the Orchestrator or @Auditor when all tasks in a phase are `done`
> and the user has confirmed. Never issue a GO signal with a `blocked` or `pending` task outstanding.

| Signal | Issued By | Date | Condition |
|--------|-----------|------|-----------|
| `[✅ GO] Phase 1 → Phase 2` | @Orchestrator | YYYY-MM-DD | TASK-001 through TASK-011 all `done` + user approval |
| `[✅ GO] Phase 2 → Phase 3` | @Orchestrator | YYYY-MM-DD | TASK-020 through TASK-027 all `done` + user approval |
| `[✅ GO] security-audit` | @Auditor | YYYY-MM-DD | TASK-030–032 `done`, no unresolved Critical/High findings |
| `[✅ GO] production` | @Orchestrator | YYYY-MM-DD | TASK-040–042 `done` + client final payment confirmed |

---

## Security Audit Findings

> Written by @Auditor during security-audit skill. Required before TASK-040 can start.

### Critical
*(none)*

### High
*(none)*

### Medium
*(none)*

### Low
*(none)*

---

## Delivery Sign-off

| Item | Status | Date |
|------|--------|------|
| Client review of staging URL | pending | — |
| Final payment confirmed | pending | — |
| Production deploy completed | pending | — |
| Post-deploy smoke test | pending | — |
