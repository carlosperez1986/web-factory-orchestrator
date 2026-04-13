# PROJECT_ROADMAP-purewide3.md
**Project:** Pure Wipe 3.0 — Sitio Web Corporativo  
**Client:** Pure Wipes · Atención: Carlos Pérez  
**Value:** USD $850  
**Briefing source:** visual reference — Stitch project 5053646075436783644 + homepage screenshot  
**Date initialized:** 2026-04-13  
**Skill executed:** `briefing-synthesis`

---

## Detected Motives

> Evidence: signals extracted from visual reference and Stitch project.

- **Product Catalog** — Signals: "Bienestar para cada momento, para todos", product lines grid (Toallas para Adultos, Mascotas, Ecológica, Multiuso, Bebés)
- **Lead Generation** — Signals: "Contáctenos", "¿Dónde encontrar?", contact CTA in nav
- **Brand Info** — Signals: "Quiénes somos", "Nuestro compromiso", eco/biodegradable mission statements

---

## Sitemap

> Rules applied: C (always Inicio), A (Lead Gen → Contáctenos), B (Catalog → Productos), D (≤ 7 nav items).

```json
{
  "nav": [
    { "label": "Inicio",          "slug": "/",          "template": "home",    "rule": "C — always required" },
    { "label": "Quiénes Somos",   "slug": "/nosotros",  "template": "about",   "rule": "Brand Info detected" },
    { "label": "Productos",       "slug": "/products",  "template": "catalog", "rule": "B — Product Catalog detected" },
    { "label": "Consejos (Blog)", "slug": "/blog",      "template": "blog",    "rule": "content marketing" },
    { "label": "Galería",         "slug": "/galeria",   "template": "gallery", "rule": "visual content" },
    { "label": "Contáctenos",     "slug": "/contacto",  "template": "contact", "rule": "A — Lead Generation detected" }
  ]
}
```

**Nav item count:** 6 — ✅ within Rule D maximum (7).

### Sitemap Table

| # | Página | Slug | Template | Justificación |
|---|--------|------|----------|---------------|
| 1 | **Inicio** | `/` | `home` | Rule C — required root page |
| 2 | **Quiénes Somos** | `/nosotros` | `about` | Brand Info motive |
| 3 | **Productos** | `/products` | `catalog` | Rule B — Product Catalog motive |
| 4 | **Consejos (Blog)** | `/blog` | `blog` | Content marketing section visible in reference |
| 5 | **Galería** | `/galeria` | `gallery` | Galería de Imágenes visible in nav reference |
| 6 | **Contáctenos** | `/contacto` | `contact` | Rule A — Lead Generation motive |

---

## Feature Components

| Component | Required | Trigger |
|-----------|----------|---------|
| `json-content-service` | ✅ Yes | Every project — no exceptions |
| `marketing-seo-pack` | ✅ Yes | Every project — AIO always required |
| `decap-admin-panel` | ✅ Yes | Every project — `/admin/` default |
| `contact-form-handler` | ✅ Yes | Lead Generation motive detected |
| `dynamic-content-grid` | ✅ Yes | Product Catalog motive detected |

---

## Task Registry

| ID | Task | Phase | Owner | Status | Evidence Required |
|----|------|-------|-------|--------|-------------------|
| TASK-001 | Define Razor Page spec: Inicio (`/`) | Phase 1 | @Orchestrator | done | `evidence/spec-inicio.md` |
| TASK-002 | Define Razor Page spec: Quiénes Somos (`/nosotros`) | Phase 1 | @Orchestrator | pending | `evidence/spec-nosotros.md` |
| TASK-003 | Define Razor Page spec: Contáctenos (`/contacto`) | Phase 1 | @Orchestrator | pending | `evidence/spec-contacto.md` |
| TASK-004 | Define Razor Page spec: Productos (`/products`) | Phase 1 | @Orchestrator | pending | `evidence/spec-products.md` |
| TASK-005 | Define Razor Page spec: Blog (`/blog`) | Phase 1 | @Orchestrator | pending | `evidence/spec-blog.md` |
| TASK-006 | Define Razor Page spec: Galería (`/galeria`) | Phase 1 | @Orchestrator | pending | `evidence/spec-galeria.md` |
| TASK-010 | Define C# content models for all approved pages | Phase 1 | @Orchestrator | done | `evidence/models-review.md` |
| TASK-011 | Define Decap CMS collection schema (`config.yml`) | Phase 1 | @Orchestrator | done | `wwwroot/admin/config.yml` |
| TASK-020 | Scaffold .NET net9.0 project from blueprint | Phase 2 | @Orchestrator | done | `Program.cs` exists in repo |
| TASK-021 | Implement `json-content-service` | Phase 2 | @Orchestrator | done | `Services/ContentService.cs` exists |
| TASK-022 | Implement `contact-form-handler` | Phase 2 | @Orchestrator | pending | `evidence/form-handler-smoke.md` |
| TASK-023 | Implement `marketing-seo-pack` (Schema.org + AIO meta) | Phase 2 | @Orchestrator | pending | `evidence/seo-audit-pass.md` |
| TASK-024 | Assemble UI: Inicio | Phase 2 | @Orchestrator | done | `Pages/Index.cshtml` exists |
| TASK-025 | Assemble UI: Quiénes Somos | Phase 2 | @Orchestrator | pending | `Pages/Nosotros/Index.cshtml` exists |
| TASK-026 | Assemble UI: Contáctenos | Phase 2 | @Orchestrator | pending | `Pages/Contacto/Index.cshtml` exists |
| TASK-027 | Global components: Header, Footer | Phase 2 | @Orchestrator | done | `Pages/Shared/_Layout.cshtml` exists |
| TASK-028 | Assemble UI: Productos (catalog + detail) | Phase 2 | @Orchestrator | pending | `Pages/Products/Index.cshtml` exists |
| TASK-029 | Assemble UI: Blog (list + post) | Phase 2 | @Orchestrator | pending | `Pages/Blog/Index.cshtml` exists |
| TASK-030 | Security audit — secrets + dep scan | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-031 | Security audit — auth/OAuth surface review | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-032 | Security audit — deploy hardening review | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-040 | VPS provisioning — Nginx + Systemd config | Phase 3 | @Orchestrator | done | `evidence/nginx-syntax.log` |
| TASK-041 | CI/CD GitHub Actions workflow | Phase 3 | @Orchestrator | done | `.github/workflows/deploy.yml` exists |
| TASK-042 | Deploy to staging URL (client review) | Phase 3 | @Orchestrator | pending | `evidence/staging-smoke.md` |
| TASK-043 | Final deploy to production URL | Phase 3 | @Orchestrator | pending | `evidence/prod-deploy.md` |

---

## Phase GO Signals

| Signal | Issued By | Date | Condition |
|--------|-----------|------|-----------|
| `[✅ GO] briefing-synthesis` | @Orchestrator | 2026-04-13 | Visual reference confirmed, sitemap generated |
| `[✅ GO] project-estimation-and-stack-selection` | @Orchestrator | 2026-04-13 | Stack: .NET 9 / Razor Pages — approved (auto) |
| `[✅ GO] spec-driven-architecture` | @Orchestrator | 2026-04-13 | IMPLEMENTATION_SPEC-purewide3.md written |
| `[✅ GO] look-and-feel-ingestion` | @Orchestrator | 2026-04-13 | DESIGN_STYLE_CONTRACT-purewide3.md written |
| `[✅ GO] project-scaffolding` | @Orchestrator | 2026-04-13 | Scaffold pushed to github.com/carlosperez1986/purewide3.0 |
| `[⏳ PENDING] Phase 2 → Phase 3` | @Orchestrator | — | TASK-022, 023, 025, 026, 028, 029 pending |

---

## Security Audit Findings

> Written by @Auditor during security-audit skill.

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
