# PROJECT_ROADMAP.md
**Project:** Pure Wipe — Sitio Web Corporativo  
**Client:** Oclara Group · Atención: Aron Levy  
**Value:** USD $850.00  
**Briefing source:** `inbox/pure_wipe_cotizacion (1).pdf`  
**Date initialized:** 2026-04-12  
**Skill executed:** `briefing-synthesis`  
**Executed by:** `@Analyst`

---

## Detected Motives

> Evidence: signals extracted verbatim from `/inbox/pure_wipe_cotizacion (1).pdf`

- **Lead Generation** — Signals: "Formulario de contacto", "CTA principal: Ver productos", "formulario para convertirse en distribuidor", "Botón flotante de WhatsApp para contacto rápido", "WhatsApp Business con mensaje predefinido", "CTA de contacto", "Síguenos en Instagram"
- **Product Catalog** — Signals: "catálogo de líneas", "Grid con las 4 líneas", "Detalle de producto — ficha individual", "4 líneas: Adultos Mayores · Mascotas · Ecológica · Multiuso Hogar"
- **Brand Info** — Signals: "Historia de Pure Wipe", "Origen de la marca y motivación fundacional", "Misión, visión y valores", "Equipo", "Compromiso ecológico"

---

## Sitemap

> Rules applied: C (always Inicio), B (Product Catalog → Productos), A (Lead Generation → Contáctenos), D (≤ 7 nav items).

```json
{
  "nav": [
    { "label": "Inicio",        "slug": "/",          "template": "home",     "rule": "C — always required as root page" },
    { "label": "Productos",     "slug": "/productos",  "template": "catalog",  "rule": "B — Product Catalog motive detected" },
    { "label": "Galería",       "slug": "/galeria",    "template": "services", "rule": "B — visual product content + Instagram integration described in PDF p.3" },
    { "label": "Quiénes Somos", "slug": "/nosotros",   "template": "about",    "rule": "Brand Info motive detected — history, mission, team, eco commitment" },
    { "label": "Blog / Tips",   "slug": "/blog",       "template": "blog",     "rule": "SEO content strategy explicitly described in PDF p.3 — tips by product line" },
    { "label": "Contáctenos",   "slug": "/contacto",   "template": "contact",  "rule": "A — Lead Generation motive detected; must include functional contact form + distributor form" },
    { "label": "Legal",         "slug": "/legal",      "template": "about",    "rule": "Regulatory compliance explicitly listed in PDF p.4 — Ley 1581/2012 Colombia" }
  ]
}
```

**Nav item count:** 7 — ✅ within Rule D maximum.

### Sitemap Table

| # | Página | Slug | Template | Justificación (fuente: PDF) |
|---|--------|------|----------|-----------------------------|
| 1 | **Inicio** | `/` | `home` | Página raíz obligatoria (Regla C). El PDF dedica toda la página 2 a describir su contenido: Hero/Banner con propuesta de valor, navegación rápida por línea de producto, tarjetas de líneas destacadas, valores de marca, galería de Instagram, guía de uso y prueba social. |
| 2 | **Productos** | `/productos` | `catalog` | Regla B — motive Product Catalog detectado. El PDF (p.2–3) describe en detalle un catálogo con vista general de las 4 líneas y ficha de producto individual con galería, ingredientes, instrucciones y CTA de compra/contacto. |
| 3 | **Galería** | `/galeria` | `services` | El PDF (p.3) dedica una sección completa a "Galería": feed dinámico de Instagram vía API, contenido UGC de clientes, Reels y videos de uso por línea. Justifica una página independiente por su naturaleza visual y técnica (integración con API externa). |
| 4 | **Quiénes Somos** | `/nosotros` | `about` | Motive Brand Info detectado. El PDF (p.3) describe: Historia de Pure Wipe, Misión/Visión/Valores, presentación del Equipo, Compromiso ecológico y prueba social con aliados/certificaciones. |
| 5 | **Blog / Tips** | `/blog` | `blog` | El PDF (p.3–4) describe una sección "Blog / Tips" con estructura SEO completa: artículos por línea de producto, tips de bienestar e higiene, eco tips. Cada artículo incluye título SEO, imagen destacada y CTA al producto relacionado — clave para `marketing-seo-pack`. |
| 6 | **Contáctenos** | `/contacto` | `contact` | Regla A — Lead Generation motive detectado. El PDF (p.4) describe: formulario de contacto con selector de motivo (consulta, pedido, distribución, PQR), links a redes sociales, listado/mapa de distribuidores y formulario para convertirse en distribuidor. |
| 7 | **Legal** | `/legal` | `about` | El PDF (p.4) lista explícitamente: Términos y Condiciones, Política de Privacidad (Ley 1581/2012 Colombia), Política de Devolución y Garantía, e Información fiscal. Requisito normativo no opcional. |

**Secciones opcionales identificadas (fuera del alcance base — cotización separada):**

| Sección | Motivo de exclusión |
|---------|---------------------|
| FAQ | PDF p.4: explícitamente marcada como "Sección Opcional / Valor Adicional" |
| Landing — Línea Ecológica | PDF p.4: explícitamente marcada como "Sección Opcional / Valor Adicional" |
| Landing — Distribuidores y Mayoristas | PDF p.4: explícitamente marcada como "Sección Opcional / Valor Adicional" |
| Programa de Referidos | PDF p.4: explícitamente marcada como "Sección Opcional / Valor Adicional" |
| Newsletter / Comunidad | PDF p.4: explícitamente marcada como "Sección Opcional / Valor Adicional" |

---

## Feature Components

| Component | Required | Trigger |
|-----------|----------|---------|
| `contact-form-handler` | ✅ Yes | Lead Generation motive detected — contact form + distributor application form |
| `json-content-service` | ✅ Yes | Every project — no exceptions |
| `marketing-seo-pack` | ✅ Yes | Every project — AIO always required; Blog/Tips section reinforces this |
| `dynamic-content-grid` | ✅ Yes | Product Catalog motive detected — 4-line catalog grid + product detail pages |

---

## Estimation Inputs

> Extracted from roadmap sitemap and feature component manifest.

| Input | Value |
|---|---|
| Navigation items | 7 |
| Dynamic components | 4 (`json-content-service`, `contact-form-handler`, `dynamic-content-grid`, `marketing-seo-pack`) |
| External integrations | 1 (Instagram API feed — Galería page) |
| Unresolved blockers | 0 |

---

## Token Estimate

> Formula: 37,000 + (7×1,200) + (4×2,000) + (1×1,800) + (0×1,000)

| Case | Tokens |
|---|---|
| Best case (×0.85) | 46,920 |
| Expected case (×1.00) | **55,200** |
| Worst case (×1.25) | 69,000 |

---

## Time and Effort Estimate

> Formula: 4 + (7×0.4) + (4×0.7) + (1×0.5) + (0×0.5)

| Field | Value |
|---|---|
| Estimated days | **10.1 working days** |
| Effort band | **High** (> 8.0 days) |

**Top 3 effort drivers:**
1. Dynamic components × 4 → +2.8 days
2. Navigation items × 7 → +2.8 days
3. External integration (Instagram API) × 1 → +0.5 days

---

## Cost Estimate

### A) Human-Developer Benchmark [REFERENCE — not applicable under WFO]

> ⚠️ This is the cost a traditional agency would incur. NOT the WFO execution cost.

| Field | Value |
|---|---|
| Hour rate | 40 EUR/hour (senior dev market rate) |
| Estimated hours | 60.6 h (10.1 days × 6 h) |
| Human execution cost | **2,424 EUR** |

### B) Agentic Execution Cost [REAL WFO COST]

| Line item | Value |
|---|---|
| AI tokens (55,200 × 0.004 EUR/1k) | 0.22 EUR |
| Copilot pro-rata (10 EUR / 4 sites) | 2.50 EUR |
| CI/CD Actions (30 min × 0.008 EUR) | 0.24 EUR |
| VPS pro-rata (5 EUR / 4 sites) | 1.25 EUR |
| **Infra subtotal** | **4.21 EUR** |
| Operator supervision — reviews and approvals only, not coding (3 h × 40 EUR) | 120.00 EUR |
| **Agentic total cost** | **124.21 EUR** |
| Delivery price | 850 EUR |
| **Gross margin** | **85.4%** ✅ |

> Margin ≥ 85% — factory model is viable. No scope cuts required.

---

## Stack Decision

| Field | Value |
|---|---|
| `target_framework` | `net9.0` — ASP.NET Core Razor Pages |
| `decision_basis` | Latest LTS stable at project initialization; no hosting constraints identified |
| `fallback_framework` | `net8.0` |
| Admin system | Decap CMS |
| Admin route | `/admin/` |
| Required config path | `wwwroot/admin/config.yml` |
| Content source | Git-based JSON/MD files — no EF/ORM |
| UI framework | Bootstrap 5 + Swiper.js (Productos) |

---

## Phase 1 — Define / Specs

> Skill: `spec-driven-architecture` | Completed: 2026-04-13  
> Output: [`IMPLEMENTATION_SPEC-pure-wipe.md`](IMPLEMENTATION_SPEC-pure-wipe.md)

- [x] Define Razor Page spec for `Inicio` (`/`) — template: home
- [x] Define Razor Page spec for `Productos` (`/productos`) — template: catalog
- [x] Define Razor Page spec for `Galería` (`/galeria`) — template: gallery
- [x] Define Razor Page spec for `Quiénes Somos` (`/nosotros`) — template: about
- [x] Define Razor Page spec for `Blog / Tips` (`/blog`) — template: blog
- [x] Define Razor Page spec for `Contáctenos` (`/contacto`) — template: contact
- [x] Define Razor Page spec for `Legal` (`/legal`) — template: legal
- [x] Define C# content models for all pages (no EF/ORM — JSON/MD only)
- [x] Define API contracts and Git-based CMS collection structure

---

## Phase 2 — Build

> Skill chain: `project-scaffolding` → `github-project-bootstrap` → `content-service-and-data-wiring` → `integrate-ui-component` → `seo-aio-optimization`  
> Spec reference: [`IMPLEMENTATION_SPEC-pure-wipe.md`](IMPLEMENTATION_SPEC-pure-wipe.md)

- [ ] Scaffold .NET 9 project via `project-scaffolding` skill | Depends on: Phase 1 DONE ✅
- [ ] Bootstrap GitHub Issues + Project board via `github-project-bootstrap` | Depends on: project scaffold + IMPLEMENTATION_SPEC
- [ ] Batch 1 — Foundation + shared layout via `content-service-and-data-wiring` + `integrate-ui-component` | Depends on: github-project-bootstrap
- [ ] Batch 2 — Legal + Nosotros pages | Depends on: Batch 1
- [ ] Batch 3 — Product catalog + detail pages | Depends on: Batch 1
- [ ] Batch 4 — Homepage + Blog | Depends on: Batch 1 + Batch 3
- [ ] Batch 5 — Forms + Galería + Instagram API | Depends on: Batch 1 + Batch 3
- [ ] Batch 6 — SEO/AIO via `seo-aio-optimization` | Depends on: Batches 1–5
- [ ] Generate Decap CMS `config.yml` for all collections | Depends on: content models approved

---

## Phase 3 — Audit / Deploy

> Owner: `@Auditor` (security scan), `@DevOps` (Nginx + Systemd provisioning)
> Depends on: `[✅ GO] @Developer → @Auditor` and `[✅ GO] @FrontendUI → @Auditor`

- [ ] Run `security-audit` skill on all Nginx templates and .NET configs | Owner: @Auditor | Depends on: Phase 2 DONE
- [ ] Audit all contact/distributor form handlers for input validation and XSS | Owner: @Auditor | Depends on: contact-form-handler complete
- [ ] Audit Instagram API integration for secrets exposure | Owner: @Auditor | Depends on: Galería component complete
- [ ] @Auditor sign-off on all components — evidence required in this file | Owner: @Auditor | Depends on: all audits above
- [ ] Run `vps-provisioning` skill — generate Nginx/Systemd files for Debian 11 | Owner: @DevOps | Depends on: @Auditor sign-off
- [ ] Configure CI/CD GitHub Actions workflow | Owner: @DevOps | Depends on: vps-provisioning
- [ ] Deploy to temporary URL for client review (2-month timeline per contract) | Owner: @DevOps | Depends on: CI/CD configured
- [ ] Final deployment to official URL — requires 100% payment confirmed | Owner: @DevOps | Depends on: client final payment + approval

---

## Handover Log

```text
[✅ GO] @Analyst → @Architect
Skill completed: briefing-synthesis
Date: 2026-04-12
Context: PROJECT_ROADMAP.md initialized for Pure Wipe. 7-page sitemap generated.
Human operator approved: 2026-04-13

[✅ GO] @Architect | project-estimation-and-stack-selection DONE | 2026-04-13
Stack locked: net9.0 · Decap CMS · Bootstrap 5 · Git-based JSON/MD
Gross margin: 85.4% — viable

[✅ GO] @Orchestrator | Phase 1 approved | 2026-04-13

[✅ GO] @Orchestrator | spec-driven-architecture — architecture spec locked | 2026-04-13
Output: IMPLEMENTATION_SPEC-pure-wipe.md
6 batches defined · 5 open technical questions

[🔄 PENDING] @Orchestrator → project-scaffolding → Step 1
Next: create or adopt client repo, then github-project-bootstrap
```

---

## Verification Evidence (briefing-synthesis)

- [x] `/inbox` file fully read — 3 detected Business Motive signals listed under `## Detected Motives` ✅
- [x] Sitemap JSON present under `## Sitemap` — `nav` array has 7 items (≤ 7, Rule D satisfied) ✅
- [x] All routing rules A–D evaluated — rule noted next to each nav item in JSON ✅
- [x] Feature component manifest present under `## Feature Components` — `json-content-service` and `marketing-seo-pack` included ✅
- [x] `PROJECT_ROADMAP.md` created in project root ✅
- [x] All three phases (Define, Build, Deploy) populated with at least one `- [ ]` task each ✅
- [x] `current_state-pure-wipe.json` updated — see file in project root ✅
- [x] Human operator approval confirmed — 2026-04-13 ✅
- [x] `## Estimation Inputs`, `## Token Estimate`, `## Time and Effort Estimate`, `## Cost Estimate` added — 2026-04-13 ✅
- [x] `## Stack Decision` locked — net9.0, Decap CMS, Bootstrap 5 — 2026-04-13 ✅
- [x] Gross margin verified — 85.4% ≥ 85% threshold ✅

> `@Auditor sign-off`: Pending — awaiting `spec-driven-architecture` completion.
