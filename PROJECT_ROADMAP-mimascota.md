# PROJECT_ROADMAP-mimascota.md

**Project:** Mi Mascota — Sitio web corporativo
**Client:** Oclara Group · Atención: Aron Levy
**Value:** USD $850.00
**Briefing source:** `inbox/pure_wipe_cotizacion (1).pdf`
**Date initialized:** 2026-04-14
**Skill executed:** `briefing-synthesis` → `project-estimation-and-stack-selection`

---

## Detected Motives

> Evidence: signals extracted verbatim from briefing source. Do not paraphrase.

- **Lead Generation** — Signals: "Formulario de contacto", "Nombre, correo y mensaje", "CTA y formulario para convertirse en distribuidor", "Selector de motivo: consulta, pedido, distribución, PQR"
- **Product Catalog** — Signals: "Grid con las 4 líneas y descripción breve de cada una", "Detalle de producto — ficha individual", "Línea Mascotas — Perros y Gatos", "Descripción, ingredientes y certificaciones"
- **Brand Info** — Signals: "Historia de Pure Wipe", "Misión, visión y valores", "Equipo", "Compromiso ecológico", "Feed de Instagram", "Testimonios y prueba social"

---

## Sitemap

> Rules applied: C (always Inicio), A (Lead Gen → Contacto), B (Catalog → Productos), D (≤ 7 nav items).

```json
{
  "nav": [
    { "label": "Inicio",    "slug": "/",          "template": "home",    "rule": "C — always required" },
    { "label": "Productos", "slug": "/productos",  "template": "catalog", "rule": "B — Product Catalog detected" },
    { "label": "Galería",   "slug": "/galeria",    "template": "services","rule": "Brand Info — visual gallery and Instagram feed" },
    { "label": "Nosotros",  "slug": "/nosotros",   "template": "about",   "rule": "Brand Info — historia, misión, equipo" },
    { "label": "Blog",      "slug": "/blog",       "template": "blog",    "rule": "Brand Info — Tips de uso y contenido SEO" },
    { "label": "Contacto",  "slug": "/contacto",   "template": "contact", "rule": "A — Lead Generation detected" },
    { "label": "Legal",     "slug": "/legal",      "template": "about",   "rule": "Brand Info — políticas y términos legales" }
  ]
}
```

**Nav item count:** 7 — ✅ within Rule D maximum.

### Sitemap Table

| # | Página | Slug | Template | Justificación (evidence from briefing) |
|---|--------|------|----------|----------------------------------------|
| 1 | **Inicio** | `/` | `home` | Rule C — root page. Hero/Banner editable en Decap (user requirement). |
| 2 | **Productos** | `/productos` | `catalog` | Rule B — Product Catalog motive. Grid con líneas: Mascotas (Perros y Gatos), Adultos Mayores, Ecológica, Multiuso Hogar. |
| 3 | **Galería** | `/galeria` | `services` | Brand Info — "Feed de Instagram · Grid dinámico · Contenido de clientes (UGC) · Reels y videos de uso". |
| 4 | **Nosotros** | `/nosotros` | `about` | Brand Info — "Historia, Misión, visión y valores, Equipo, Compromiso ecológico". |
| 5 | **Blog** | `/blog` | `blog` | Brand Info — "Tips de uso por línea de producto · Bienestar e higiene · Eco tips y sostenibilidad". |
| 6 | **Contacto** | `/contacto` | `contact` | Rule A — Lead Generation. "Formulario de contacto · Redes sociales · Distribuidores y puntos de venta". |
| 7 | **Legal** | `/legal` | `about` | Brand Info — "Términos y Condiciones · Política de Privacidad (Ley 1581 de 2012) · Política de Devolución". |

---

## Feature Components

| Component | Required | Trigger |
|-----------|----------|---------|
| `json-content-service` | ✅ Yes | Every project — no exceptions |
| `marketing-seo-pack` | ✅ Yes | Every project — AIO always required |
| `decap-admin-panel` | ✅ Yes | Every project — `/admin/` default |
| `contact-form-handler` | ✅ Yes | Lead Generation motive detected |
| `dynamic-content-grid` | ✅ Yes | Product Catalog motive detected |
| `decap-hero-banner` | ✅ Yes | **User requirement** — banner principal editable en Decap CMS. Content stored in `content/hero.json`. Fields: `title`, `subtitle`, `cta_primary_text`, `cta_primary_url`, `cta_secondary_text`, `cta_secondary_url`, `background_image`. |

---

## Estimation Inputs

> Source: sitemap + feature-components-mimascota.json

| Signal | Count |
|--------|-------|
| Navigation items | 7 |
| Dynamic pages/components | 3 (product catalog grid, Instagram feed, blog grid) |
| External integrations | 3 (Instagram API, WhatsApp Business, Decap hero-banner JSON wire) |
| Unresolved blockers | 0 |

---

## Token Estimate

**Formula:**
```
total_tokens = 37,000
             + (7 nav_items × 1,200)    =  8,400
             + (3 dynamic_components × 2,000) = 6,000
             + (3 integrations × 1,800) =  5,400
             + (0 blockers × 1,000)     =      0
             = 56,800 tokens
```

| Scenario | Tokens |
|----------|--------|
| Best case (×0.85) | 48,280 |
| **Expected case (×1.00)** | **56,800** |
| Worst case (×1.25) | 71,000 |

---

## Time and Effort Estimate

**Formula:**
```
time_days = 4
          + (7 × 0.4) = 2.8
          + (3 × 0.7) = 2.1
          + (3 × 0.5) = 1.5
          + (0 × 0.5) = 0.0
          = 10.4 working days
```

| Item | Value |
|------|-------|
| Estimated days | **10.4** |
| Effort band | **High** (> 8.0 days) |

**Top 3 effort drivers:**
1. 7 navigation pages — each with distinct content models and Razor Pages
2. 3 external integrations (Instagram API, WhatsApp Business, Decap hero-banner wire)
3. 3 dynamic components requiring full content-service wiring (product grid, blog grid, Instagram feed)

---

## Cost Estimate

### A) Human-Developer Benchmark [REFERENCE — not applicable under WFO]

> ⚠️ This model does NOT represent the real execution cost under WFO.
> It is included as a market-rate reference to show the cost a traditional agency would charge.

| Parameter | Value |
|-----------|-------|
| Hour rate | 40 EUR/h (senior dev market rate) |
| Estimated hours | 10.4 days × 6h = **62.4 hours** |
| Human execution cost | 62.4 × 40 = **2,496.00 EUR** |

> [REFERENCE ONLY — this is the cost a traditional developer would incur, NOT the WFO agentic cost]

---

### B) Agentic Execution Cost [REAL WFO COST]

> ✅ This is the real execution cost of this architecture.

| Line item | Calculation | Cost (EUR) |
|-----------|-------------|-----------|
| AI tokens | (56,800 / 1,000) × 0.004 | 0.23 |
| Copilot pro-rata | 10 EUR / 4 sites/month | 2.50 |
| CI/CD Actions | 30 min × 0.008 EUR/min | 0.24 |
| VPS pro-rata | 5 EUR / 4 active sites | 1.25 |
| **Infra subtotal** | | **4.22** |
| Operator supervision *(reviews and approvals only — NOT coding hours)* | 3 h × 40 EUR/h | 120.00 |
| **Agentic total cost** | | **124.22 EUR** |

**Gross margin vs 850 EUR delivery price:**
```
((850 - 124.22) / 850) × 100 = 85.4% ✅
```
> Gross margin is above the 85% threshold — no scope cuts required.

---

## Stack Decision

| Parameter | Value |
|-----------|-------|
| `target_framework` | `net9.0` |
| `decision_basis` | Latest LTS SDK confirmed available: `9.0.312` (from `dotnet --list-sdks`) |
| `fallback_framework` | `net8.0` (previous LTS) |

**Decap CMS Admin Baseline (enforced):**

| Item | Value |
|------|-------|
| Admin system | `Decap CMS` |
| Admin route | `/admin/` |
| Required config path | `wwwroot/admin/config.yml` |
| Content source | Git-based JSON/MD files |

---

## Task Registry

> IDs are permanent. Assign sequentially; do not reuse a deleted ID.
> Column "Evidence Required" holds the path the @Auditor checks before marking a task `done`.

| ID | Task | Phase | Owner | Status | Evidence Required |
|----|------|-------|-------|--------|-------------------|
| TASK-001 | Define Razor Page spec: Inicio (`/`) + Hero Banner schema | Phase 1 | @Orchestrator | pending | `evidence/spec-inicio.md` |
| TASK-002 | Define Razor Page spec: Productos (`/productos`) — catalog grid | Phase 1 | @Orchestrator | pending | `evidence/spec-productos.md` |
| TASK-003 | Define Razor Page spec: Galería (`/galeria`) — Instagram feed + UGC | Phase 1 | @Orchestrator | pending | `evidence/spec-galeria.md` |
| TASK-004 | Define Razor Page spec: Nosotros (`/nosotros`) | Phase 1 | @Orchestrator | pending | `evidence/spec-nosotros.md` |
| TASK-005 | Define Razor Page spec: Blog (`/blog`) — article list + SEO structure | Phase 1 | @Orchestrator | pending | `evidence/spec-blog.md` |
| TASK-006 | Define Razor Page spec: Contacto (`/contacto`) — form + distributors | Phase 1 | @Orchestrator | pending | `evidence/spec-contacto.md` |
| TASK-007 | Define Razor Page spec: Legal (`/legal`) | Phase 1 | @Orchestrator | pending | `evidence/spec-legal.md` |
| TASK-008 | Define Hero Banner content model for Decap (`content/hero.json`) | Phase 1 | @Orchestrator | pending | `evidence/spec-hero-banner.md` |
| TASK-010 | Define C# content models for all approved pages | Phase 1 | @Orchestrator | pending | `evidence/models-review.md` |
| TASK-011 | Define Decap CMS collection schema (`config.yml`) — including hero-banner collection | Phase 1 | @Orchestrator | pending | `wwwroot/admin/config.yml` |
| TASK-020 | Scaffold .NET 9 project from blueprint | Phase 2 | @Orchestrator | pending | `Program.cs` exists in repo |
| TASK-021 | Implement `json-content-service` (reads `content/*.json` and `content/*.md`) | Phase 2 | @Orchestrator | pending | `Services/ContentService.cs` exists |
| TASK-022 | Implement `contact-form-handler` | Phase 2 | @Orchestrator | pending | `evidence/form-handler-smoke.md` |
| TASK-023 | Implement `marketing-seo-pack` (Schema.org + AIO meta tags) | Phase 2 | @Orchestrator | pending | `evidence/seo-audit-pass.md` |
| TASK-024 | Implement `decap-hero-banner` — wire `content/hero.json` → `Index.cshtml` | Phase 2 | @Orchestrator | pending | `content/hero.json` exists and `Pages/Index.cshtml` renders hero from JSON |
| TASK-025 | Assemble UI: Inicio — Hero (Decap-editable), product highlights, values, Instagram preview, social proof | Phase 2 | @Orchestrator | pending | `Pages/Index.cshtml` exists |
| TASK-026 | Assemble UI: Productos — product grid + product detail page | Phase 2 | @Orchestrator | pending | `Pages/Productos/Index.cshtml` exists |
| TASK-027 | Assemble UI: Galería — Instagram feed grid + UGC + Reels section | Phase 2 | @Orchestrator | pending | `Pages/Galeria/Index.cshtml` exists |
| TASK-028 | Assemble UI: Nosotros, Blog, Contacto, Legal | Phase 2 | @Orchestrator | pending | `Pages/Nosotros.cshtml`, `Pages/Blog/Index.cshtml`, `Pages/Contacto.cshtml`, `Pages/Legal.cshtml` exist |
| TASK-029 | Global components: Header, Footer, floating WhatsApp button, promo banner | Phase 2 | @Orchestrator | pending | `Pages/Shared/_Layout.cshtml` exists |
| TASK-030 | Security audit — secrets + dependency scan | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-031 | Security audit — auth/OAuth surface review (Decap GitHub OAuth) | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-032 | Security audit — deploy hardening review | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-040 | VPS provisioning — Nginx + Systemd config | Phase 3 | @Orchestrator | pending | `evidence/nginx-syntax.log` |
| TASK-041 | CI/CD GitHub Actions workflow | Phase 3 | @Orchestrator | pending | `.github/workflows/deploy.yml` exists |
| TASK-042 | Deploy to staging URL (client review) | Phase 3 | @Orchestrator | pending | `evidence/staging-smoke.md` |
| TASK-043 | Final deploy to production URL | Phase 3 | @Orchestrator | pending | `evidence/prod-deploy.md` |

---

## Phase GO Signals

| Signal | Issued By | Date | Condition |
|--------|-----------|------|-----------|
| `[✅ GO] briefing-synthesis` | @Orchestrator | 2026-04-14 | Steps 1–5 complete, sitemap + strategy contract written |
| `[✅ GO] project-estimation-and-stack-selection` | @Orchestrator | 2026-04-14 | Steps 1–7 complete, stack locked at net9.0 |
| `[✅ GO] Phase 1 → Phase 2` | @Orchestrator | YYYY-MM-DD | TASK-001 through TASK-011 all `done` + user approval |
| `[✅ GO] Phase 2 → Phase 3` | @Orchestrator | YYYY-MM-DD | TASK-020 through TASK-029 all `done` + user approval |
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
