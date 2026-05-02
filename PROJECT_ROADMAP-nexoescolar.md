# PROJECT_ROADMAP-nexoescolar.md

**Project:** Nexo Escolar — Landing Page de Alta Conversión  
**Client:** Nexo Escolar · K-12 School Management Platform  
**Value:** 850 EUR  
**Briefing source:** `inbox/briefing-nexoescolar.md`  
**Date initialized:** 2026-05-02  
**Skill executed:** `briefing-synthesis`

---

## Detected Motives

> Evidence: signals extracted verbatim from briefing source.

- **Lead Generation** — Signals: "Quiero mi demo" (CTA button), form fields "Nombre completo, Nombre del colegio, Correo institucional, WhatsApp", microcopy "Te contactamos en menos de 24 horas hábiles."
- **Brand Info** — Signals: "Conectando colegios, docentes y familias" (tagline/footer), trust visuals section "Diseñado para colegios que necesitan orden, velocidad y trazabilidad.", Interactive Hub for Directivos/Docentes/Padres
- **Product Catalog** — Signals: "Funciones" section with bento-grid feature cards (Asistencia, Comunicados, Grupos), mobile app showcase "El colegio en tu bolsillo."

---

## ✅ STACK DECISION — Option A Confirmed (2026-05-02)

> Operator selected **Option A — WFO-Native Stack**.

| Layer | Technology | WFO Mapping from client brief |
|-------|-----------|-------------------------------|
| Framework | **.NET 9 Razor Pages** | React 18+ → Razor Pages |
| CSS | **Bootstrap 5** | Tailwind CSS → Bootstrap 5 utilities |
| Components | **Bootstrap 5 Accordion/Tabs** | shadcn/ui Accordion/Tabs → Bootstrap 5 native |
| Animation | **AOS.js** `data-aos="fade-up"` | Framer Motion whileInView → AOS.js (whitelisted) |
| Parallax | **CSS transform + vanilla JS scroll listener** | Framer Motion parallax → CSS |
| Icons | **Bootstrap Icons (SVG inline)** | Lucide icons → Bootstrap Icons |
| Glassmorphism | **Custom CSS utility class** (Bootstrap 5 gap — allowed) | Tailwind `bg-white/5`, `backdrop-blur-md` → CSS vars |
| Typography clamp() | **Retained as-is** | `clamp(28px, 5vw, 56px)` — pure CSS, no framework dependency |

Scope: **850 EUR standard — full WFO pipeline applies.**

---

## Sitemap

> Rules applied: C (always Inicio), A (Lead Gen → Demo form), B (features catalog → Funciones), D (≤ 7 nav items).
> Architecture: Single-page landing — all nav items are anchor links on `Index.cshtml` (.NET 9 Razor Pages — Option A confirmed).

```json
{
  "nav": [
    { "label": "Inicio",     "slug": "/",           "template": "home", "rule": "C — always required root page" },
    { "label": "Funciones",  "slug": "/#funciones",  "template": "home", "rule": "B — Product/features catalog (Bento Grid)" },
    { "label": "Beneficios", "slug": "/#beneficios", "template": "home", "rule": "Brand Info — Interactive Hub (Directivos/Docentes/Padres)" },
    { "label": "App",        "slug": "/#app",        "template": "home", "rule": "Brand Info — Mobile App Showcase" },
    { "label": "Demo",       "slug": "/#demo",       "template": "home", "rule": "A — Lead Generation (Quiero mi demo form)" }
  ]
}
```

**Nav item count:** 5 — ✅ within Rule D maximum (7).

### Sitemap Table

| # | Sección | Anchor | Template | Justificación |
|---|---------|--------|----------|---------------|
| 1 | **Inicio / Hero** | `#hero` | `home` | Rule C — required root page. Headline: "Gestión escolar en tiempo real para colegios que quieren operar mejor." |
| 2 | **Problema** | `#problema` | `home` | Brand Info — pain-point cards, unlisted from nav (internal section) |
| 3 | **Funciones** | `#funciones` | `home` | Rule B — bento grid of 5 platform feature cards |
| 4 | **Beneficios** | `#beneficios` | `home` | Brand Info — Interactive Hub: Directivos / Docentes / Padres |
| 5 | **App** | `#app` | `home` | Brand Info — Mobile app showcase, "El colegio en tu bolsillo." |
| 6 | **Trust** | `#trust` | `home` | Brand Info — 3 trust blocks (Shield, CheckCircle, Lock) — unlisted from nav |
| 7 | **Demo** | `#demo` | `home` | Rule A — Lead Gen form + FAQ Accordion |
| 8 | **Footer** | `#footer` | `home` | Always — Logo + tagline |

---

## Feature Components

| Component | Required | Trigger |
|-----------|----------|---------|
| `json-content-service` | ✅ Yes | Every project — no exceptions |
| `marketing-seo-pack` | ✅ Yes | Every project — AIO always required |
| `decap-admin-panel` | ✅ Yes | Every project — `/admin/` default |
| `contact-form-handler` | ✅ Yes | Lead Generation motive detected — "Quiero mi demo" form |

---

## Estimation Inputs

> Source: `PROJECT_ROADMAP-nexoescolar.md` sitemap + feature components.

| Signal | Count | Notes |
|--------|-------|-------|
| Navigation items | 5 | Funciones, Beneficios, App, Demo + Inicio |
| Dynamic components | 4 | Hero with parallax, Interactive Hub (SVG+Tabs), Bento Grid, Contact Form |
| External integrations | 0 | No third-party APIs in scope |
| Unresolved blockers | 1 | React stack conflict — pending operator decision |

---

## Token Estimate

> Formula: `total_tokens = 37,000 + (nav_items × 1,200) + (dynamic_components × 2,000) + (integrations × 1,800) + (blockers × 1,000)`

```
total_tokens = 37,000 + (5 × 1,200) + (4 × 2,000) + (0 × 1,800) + (1 × 1,000)
             = 37,000 + 6,000 + 8,000 + 0 + 1,000
             = 52,000 tokens
```

| Scenario | Tokens |
|----------|--------|
| Best case (×0.85) | 44,200 |
| **Expected case (×1.00)** | **52,000** |
| Worst case (×1.25) | 65,000 |

---

## Time and Effort Estimate

> Formula: `time_days = 4 + (nav_items × 0.4) + (dynamic_components × 0.7) + (integrations × 0.5) + (blockers × 0.5)`

```
time_days = 4 + (5 × 0.4) + (4 × 0.7) + (0 × 0.5) + (1 × 0.5)
          = 4 + 2.0 + 2.8 + 0.0 + 0.5
          = 9.3 working days
```

**Effort band:** 🔴 **HIGH** (> 8.0 days)

**Top 3 effort drivers:**
1. **Dynamic components (4)** — Interactive Hub with SVG animations, Bento Grid with hover states, Hero parallax — +2.8 days
2. **Navigation sections (5)** — Single-page with 5 distinct anchored sections each requiring full responsive + animation treatment — +2.0 days
3. **Stack conflict blocker** — Operator decision + potential React scaffold divergence from standard WFO path — +0.5 days contingency

---

## Cost Estimate

### A) Human-Developer Benchmark \[REFERENCE — not applicable under WFO\]

> ⚠️ This model does NOT represent the real execution cost under WFO. It is included as market-rate reference only.

| Parameter | Value |
|-----------|-------|
| Hour rate | 40 EUR/hour (senior dev market rate) |
| Productive hours/day | 6 |
| Estimated hours | 9.3 × 6 = **55.8 hours** |
| **Human execution cost** | **55.8 × 40 = 2,232 EUR** |

> \[REFERENCE ONLY — this is the cost a traditional developer would incur, NOT the WFO agentic cost\]

---

### B) Agentic Execution Cost \[REAL WFO COST\]

> ✅ This is the real execution cost of this architecture.

| Line Item | Calculation | Cost (EUR) |
|-----------|-------------|------------|
| AI tokens (52,000 tokens) | (52,000 / 1,000) × 0.004 | 0.21 |
| Copilot pro-rata (4 sites/month) | 10 / 4 | 2.50 |
| CI/CD Actions (30 min) | 30 × 0.008 | 0.24 |
| VPS pro-rata (4 sites active) | 5 / 4 | 1.25 |
| **Infra subtotal** | | **4.20** |
| Operator supervision (3h — reviews and approvals only, not coding) | 3 × 40 | 120.00 |
| **Agentic total cost** | | **124.20 EUR** |

**Delivery price:** 850 EUR  
**Gross margin:** ((850 − 124.20) / 850) × 100 = **85.4%** ✅ Above 85% floor

---

## Stack Decision

> Locked by: `project-estimation-and-stack-selection` · Confirmed: Option A (2026-05-02)

| Parameter | Value |
|-----------|-------|
| `target_framework` | `net9.0` (.NET 9 LTS) |
| `decision_basis` | Newest compatible LTS; Operator confirmed WFO-native stack (Option A) |
| `fallback_framework` | `net8.0` (.NET 8 LTS) |

**Admin baseline (non-negotiable):**
- Admin system: `Decap CMS`
- Admin route: `/admin/`
- Required config path: `wwwroot/admin/config.yml`
- Content source: Git-based JSON/MD files

---

## Task Registry

> IDs are permanent and immutable. Phase 1: TASK-001–019. Phase 2: TASK-020–029. Phase 3: TASK-030–049.

| ID | Task | Phase | Owner | Status | Evidence Required |
|----|------|-------|-------|--------|-------------------|
| TASK-001 | Define Razor Page spec: Inicio/Hero (`/`) with all anchor sections | Phase 1 | @Orchestrator | **done** | `IMPLEMENTATION_SPEC-nexoescolar.md` § Route Matrix |
| TASK-002 | Define C# content models for all landing sections | Phase 1 | @Orchestrator | **done** | `IMPLEMENTATION_SPEC-nexoescolar.md` § Data Contracts |
| TASK-003 | Define Decap CMS collection schema (`config.yml`) for hero, features, FAQ, trust | Phase 1 | @Orchestrator | **done** | `IMPLEMENTATION_SPEC-nexoescolar.md` § Content Contracts + Batch 1 |
| TASK-004 | Design Style Contract — color palette, typography scale, glassmorphism tokens | Phase 1 | @Orchestrator | **done** | `IMPLEMENTATION_SPEC-nexoescolar.md` § Component Map → CSS Custom Properties |
| TASK-005 | Resolve stack conflict — operator decision A or B | Phase 1 | @Orchestrator | **done** | `current_state-nexoescolar.json` field `stack_decision_confirmed: true` |
| TASK-020 | Scaffold .NET 9 project from WFO blueprint (Option A) | Phase 2 | @Orchestrator | pending | `Program.cs` exists in client repo |
| TASK-021 | Implement `json-content-service` (ContentService.cs with GetPage<T>/GetCollection<T>) | Phase 2 | @Orchestrator | pending | `Services/ContentService.cs` exists |
| TASK-022 | Implement `contact-form-handler` — Demo form (Nombre, Colegio, Correo, WhatsApp) | Phase 2 | @Orchestrator | pending | `evidence/form-handler-smoke.md` |
| TASK-023 | Implement `marketing-seo-pack` (Schema.org JSON-LD + AIO meta, Plus Jakarta Sans font load) | Phase 2 | @Orchestrator | pending | `evidence/seo-audit-pass.md` |
| TASK-024 | Assemble UI: Navbar sticky glass | Phase 2 | @Orchestrator | pending | `Pages/Shared/_Layout.cshtml` exists |
| TASK-025 | Assemble UI: Hero section with coded mockup (admin dashboard + phone frame) | Phase 2 | @Orchestrator | pending | `Pages/Index.cshtml` — section#hero |
| TASK-026 | Assemble UI: Problema section (4 pain-point cards) | Phase 2 | @Orchestrator | pending | `Pages/Index.cshtml` — section#problema |
| TASK-027 | Assemble UI: Beneficios Interactive Hub (SVG + Bootstrap Tabs mobile fallback) | Phase 2 | @Orchestrator | pending | `Pages/Index.cshtml` — section#beneficios |
| TASK-028 | Assemble UI: Funciones Bento Grid (5 feature cards, responsive) | Phase 2 | @Orchestrator | pending | `Pages/Index.cshtml` — section#funciones |
| TASK-029 | Assemble UI: App showcase, Trust visuals, Demo form (Glassmorphism card), FAQ Accordion, Footer | Phase 2 | @Orchestrator | pending | `Pages/Index.cshtml` — sections #app #trust #demo #faq #footer |
| TASK-030 | Security audit — secrets + dependency scan | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-031 | Security audit — auth/OAuth surface (Decap GitHub OAuth) | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-032 | Security audit — deploy hardening review | Phase 3 | @Auditor | pending | `evidence/security-audit-report.md` |
| TASK-040 | VPS provisioning — Nginx + Systemd config | Phase 3 | @Orchestrator | pending | `evidence/nginx-syntax.log` |
| TASK-041 | CI/CD GitHub Actions deploy workflow | Phase 3 | @Orchestrator | pending | `.github/workflows/deploy.yml` exists in client repo |
| TASK-042 | Deploy to staging URL (client review) | Phase 3 | @Orchestrator | pending | `evidence/staging-smoke.md` |
| TASK-043 | Final deploy to production URL | Phase 3 | @Orchestrator | pending | `evidence/prod-deploy.md` |

---

## Phase GO Signals

| Signal | Issued By | Date | Condition |
|--------|-----------|------|-----------|
| `[✅ GO] briefing-synthesis` | @Orchestrator | 2026-05-02 | Steps 1–5 complete; roadmap generated; stack conflict flagged |
| `[✅ GO] project-estimation-and-stack-selection` | @Orchestrator | 2026-05-02 | Token/time/cost/stack written; gross margin 85.4% ✅ |
| `[✅ GO] spec-driven-architecture` | @Orchestrator | 2026-05-02 | `IMPLEMENTATION_SPEC-nexoescolar.md` written; all contracts defined; batches 1–7 planned |
| `[✅ GO] Phase 1 → Phase 2` | @Orchestrator | 2026-05-02 | Option A confirmed; "Proceed" received; client repo `carlosperez1986/nexoescolar` provided |
| `[ ] GO Phase 2 → Phase 3` | @Orchestrator | — | TASK-020–029 all `done` + user approval |
| `[ ] GO security-audit` | @Auditor | — | TASK-030–032 `done`, no unresolved Critical/High findings |
| `[ ] GO production` | @Orchestrator | — | TASK-040–042 `done` + client final payment confirmed |

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
| Operator stack decision (A/B) | ✅ done — Option A | 2026-05-02 |
| Architecture spec locked | ✅ done — `IMPLEMENTATION_SPEC-nexoescolar.md` | 2026-05-02 |
| Client repo provided | ✅ done — `github.com/carlosperez1986/nexoescolar` | 2026-05-02 |
| Client review of staging URL | pending | — |
| Final payment confirmed | pending | — |
| Production deploy completed | pending | — |
| Post-deploy smoke test | pending | — |
