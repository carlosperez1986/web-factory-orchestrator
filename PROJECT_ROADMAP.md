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

## Phase 1 — Define / Specs

> Owner: `@Architect` | Skill: `spec-driven-architecture`
> Depends on: `[✅ GO] @Analyst → @Architect` (issued below after human approval)

- [ ] Define Razor Page spec for `Inicio` (`/`) — template: home | Owner: @Architect | Depends on: NONE
- [ ] Define Razor Page spec for `Productos` (`/productos`) — template: catalog | Owner: @Architect | Depends on: NONE
- [ ] Define Razor Page spec for `Galería` (`/galeria`) — template: services | Owner: @Architect | Depends on: NONE
- [ ] Define Razor Page spec for `Quiénes Somos` (`/nosotros`) — template: about | Owner: @Architect | Depends on: NONE
- [ ] Define Razor Page spec for `Blog / Tips` (`/blog`) — template: blog | Owner: @Architect | Depends on: NONE
- [ ] Define Razor Page spec for `Contáctenos` (`/contacto`) — template: contact | Owner: @Architect | Depends on: NONE
- [ ] Define Razor Page spec for `Legal` (`/legal`) — template: about | Owner: @Architect | Depends on: NONE
- [ ] Define C# content models for all pages (no EF/ORM — JSON/MD only) | Owner: @Architect | Depends on: all page specs above
- [ ] Define API contracts and Git-based CMS collection structure | Owner: @Architect | Depends on: C# models

---

## Phase 2 — Build

> Owner: `@Developer` (models + services), `@FrontendUI` (components + layout)
> Depends on: `[✅ GO] @Architect → @Developer` and `[✅ GO] @Architect → @FrontendUI`

- [ ] Scaffold .NET 9 project via `project-scaffolding` skill | Owner: @Architect | Depends on: Phase 1 DONE
- [ ] Implement `json-content-service` for Git-based content layer | Owner: @Developer | Depends on: project scaffold
- [ ] Implement `contact-form-handler` — contact + distributor forms | Owner: @Developer | Depends on: project scaffold
- [ ] Generate Decap CMS `config.yml` for all 7 pages | Owner: @Developer | Depends on: C# models approved
- [ ] Implement `marketing-seo-pack` — Schema.org + AIO meta | Owner: @Developer | Depends on: Razor Pages defined
- [ ] Assemble UI: Inicio — Hero, product line grid, values, Instagram preview, testimonials | Owner: @FrontendUI | Depends on: content models
- [ ] Assemble UI: Productos — catalog grid + product detail layout (Bootstrap 5 + Swiper.js) | Owner: @FrontendUI | Depends on: content models
- [ ] Assemble UI: Galería — Instagram API feed, UGC grid, video section | Owner: @FrontendUI | Depends on: content models
- [ ] Assemble UI: Quiénes Somos — history, team, eco commitment | Owner: @FrontendUI | Depends on: content models
- [ ] Assemble UI: Blog / Tips — article listing + SEO article template | Owner: @FrontendUI | Depends on: content models
- [ ] Assemble UI: Contáctenos — contact form, distributor map/form, social links | Owner: @FrontendUI | Depends on: contact-form-handler
- [ ] Assemble UI: Legal — static legal text sections | Owner: @FrontendUI | Depends on: Razor Pages defined
- [ ] Implement `dynamic-content-grid` for Productos 4-line catalog | Owner: @FrontendUI | Depends on: json-content-service
- [ ] Global components: Header nav, Footer, floating promo banner, WhatsApp button | Owner: @FrontendUI | Depends on: sitemap finalized

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
[🔄 PENDING APPROVAL] @Analyst → Human Operator
Skill completed: briefing-synthesis
Date: 2026-04-12
Context: PROJECT_ROADMAP.md initialized for Pure Wipe. 7-page sitemap generated.
Action required: Review this roadmap. Reply 'Proceed' to begin Phase 1, or provide corrections.
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
- [ ] Human operator approval pending — prompt issued in Handover Log above

> `@Auditor sign-off`: Pending — skill `briefing-synthesis` output awaits human operator approval before `@Auditor` gate is triggered.

---

*"Review PROJECT_ROADMAP.md. Reply 'Proceed' to begin Phase 1, or provide corrections."*
