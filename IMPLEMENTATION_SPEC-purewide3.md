# IMPLEMENTATION_SPEC-purewide3.md
**Project:** Pure Wipe 3.0 — Sitio Web Corporativo  
**Client:** Pure Wipes · Atención: Carlos Pérez  
**Stack:** ASP.NET Core net9.0 · Razor Pages · Bootstrap 5 · Decap CMS · JSON/MD content  
**Spec date:** 2026-04-13  
**Skill:** `spec-driven-architecture`  
**Source:** `PROJECT_ROADMAP-purewide3.md`

---

## Overview

This document is the single technical source of truth for Pure Wipe 3.0 implementation.  
Every downstream skill must read this file before executing.

Roadmap reference: [`PROJECT_ROADMAP-purewide3.md`](PROJECT_ROADMAP-purewide3.md)  
Design contract reference: [`DESIGN_STYLE_CONTRACT-purewide3.md`](DESIGN_STYLE_CONTRACT-purewide3.md)

---

## Route Matrix

| # | Page | Slug | Razor Page file | Template | Data dependencies | Content source | Acceptance criteria |
|---|---|---|---|---|---|---|---|
| 1 | Inicio | `/` | `Pages/Index.cshtml` | home | ProductsByCategory (Dictionary), LatestPosts (List) | `content/products/*.json`, `content/blog/*.md` | Hero, Features, Products grid, Sustainability banner, Retailers carousel, Blog preview all render |
| 2 | Quiénes Somos | `/nosotros` | `Pages/Nosotros/Index.cshtml` | about | AboutContent | `content/pages/nosotros.json` | Mission, values, eco certifications render |
| 3 | Productos — Catálogo | `/products` | `Pages/Products/Index.cshtml` | catalog | Product[], category filter | `content/products/*.json` | Grid shows all products; category filter works |
| 4 | Consejos — Blog | `/blog` | `Pages/Blog/Index.cshtml` | blog-list | BlogPost[] | `content/blog/*.md` | Article cards render with image, date, category |
| 5 | Blog — Artículo | `/blog/{slug}` | `Pages/Blog/Post.cshtml` | blog-article | BlogPost (single) | `content/blog/{slug}.md` | Full article renders; Schema.org Article applied |
| 6 | Galería | `/galeria` | `Pages/Galeria/Index.cshtml` | gallery | GalleryImage[] | `content/gallery/*.json` | Image grid renders; lightbox works |
| 7 | Contáctenos | `/contacto` | `Pages/Contacto/Index.cshtml` | contact | ContactSettings | `content/pages/contacto.json` | Contact form submits; map renders |
| 8 | Legal | `/privacy` | `Pages/Privacy.cshtml` | legal | — | static | Legal text renders |

> `/admin/` — Decap CMS admin panel. Served from `wwwroot/admin/`. Config: `wwwroot/admin/config.yml`.

---

## Content Contracts

### `content/products/{slug}.json`
```json
{
  "slug": "string — required",
  "name": "string — required",
  "category": "string — required (adultos-mayores | mascotas | ecologica | multiuso | bebes)",
  "short_description": "string — required",
  "description": "string — optional, markdown",
  "image_url": "string — required",
  "features": ["string"],
  "in_stock": "boolean"
}
```

### `content/blog/{slug}.md` (YAML frontmatter)
```yaml
---
title: string — required
date: YYYY-MM-DD — required
image: string — optional
seo_description: string — required
category: string — required
---
Markdown body here
```

### `content/pages/inicio.json`
```json
{
  "hero_title": "string",
  "hero_tagline": "string",
  "hero_subtitle": "string",
  "hero_cta_label": "string",
  "retailers": ["string"]
}
```

### `content/pages/nosotros.json`
```json
{
  "title": "string",
  "subtitle": "string",
  "body": "string — markdown",
  "values": [{ "title": "string", "description": "string", "icon": "string" }]
}
```

---

## Data Contracts

### `Product` model (`Models/Product.cs`)
| Field | Type | Required |
|-------|------|----------|
| `Slug` | string | yes |
| `Name` | string | yes |
| `Category` | string | yes |
| `ShortDescription` | string | yes |
| `ImageUrl` | string | yes |
| `Features` | string[] | no |

### `BlogPost` model (`Models/BlogPost.cs`)
| Field | Type | Required |
|-------|------|----------|
| `Slug` | string | yes |
| `Title` | string | yes |
| `Date` | DateTime | yes |
| `Image` | string | no |
| `SeoDescription` | string | yes |
| `Category` | string | yes |
| `ContentHtml` | string | rendered |

### `IContentService` interface (`Services/ContentService.cs`)
- `GetCollection<T>(string collectionName)` — reads `wwwroot/content/{collectionName}/*.json`
- `GetPage<T>(string slug)` — reads `wwwroot/content/pages/{slug}.json`
- `GetBlogPosts()` — reads `wwwroot/content/blog/*.md`, parses frontmatter
- `GetPostBySlug(string slug)` — single post with body

---

## Component Map

### Shared Layout (`Pages/Shared/_Layout.cshtml`)
- Navbar: logo + brand, nav links, "¿Dónde encontrar?" CTA button
- Footer: logo column, Explorar links, Categorías links, newsletter form, social icons
- Dependencies: Bootstrap 5.3 CDN, Font Awesome 6.5 CDN, Montserrat + Inter Google Fonts

### Index page (`Pages/Index.cshtml`)
| Section | Component | Bootstrap | Custom CSS |
|---------|-----------|-----------|------------|
| Hero | `.hero-section` | grid | `hero-grid`, `hero-copy`, `hero-visual` |
| Features strip | `.features-section` | d-flex/grid | `features-grid`, `feature-item`, `feature-icon` |
| Products | `.product-lines-section` | custom grid | `solutions-grid`, `solution-card` |
| Sustainability banner | `.water-banner` | — | `water-banner-bg`, `water-banner-content` |
| Retailers | `.retailers-section` | — | `retailer-logos`, `retailer-pill` |
| Blog preview | `.blog-preview-section` | — | `blog-grid`, `blog-card` |

---

## Implementation Batches

### Batch 1 — Core scaffold + Homepage
**Objective:** Working .NET 9 app with homepage displaying all sections  
**Files:** `Program.cs`, `PureWide3.csproj`, `Pages/Index.cshtml`, `Pages/Index.cshtml.cs`, `Pages/Shared/_Layout.cshtml`, `wwwroot/css/site.css`, `wwwroot/content/products/*.json`, `wwwroot/content/blog/*.md`  
**Owner:** `project-scaffolding` + `integrate-ui-component`  
**Dependencies:** none  
**Acceptance:** dotnet build passes; homepage renders all 6 sections

### Batch 2 — Content service + Decap CMS
**Objective:** Content fully managed via Decap CMS admin  
**Files:** `Services/ContentService.cs`, `Models/Product.cs`, `Models/BlogPost.cs`, `wwwroot/admin/config.yml`  
**Owner:** `content-service-and-data-wiring`  
**Dependencies:** Batch 1  
**Acceptance:** `/admin/` loads Decap CMS; products and blog editable

### Batch 3 — Remaining pages
**Objective:** All nav pages implemented  
**Files:** `Pages/Nosotros/`, `Pages/Products/`, `Pages/Blog/`, `Pages/Galeria/`, `Pages/Contacto/`, `Pages/Privacy.cshtml`  
**Owner:** `integrate-ui-component`  
**Dependencies:** Batch 2  
**Acceptance:** All routes return 200; design contract applied

### Batch 4 — SEO + Deploy
**Objective:** Schema.org markup, meta tags, CI/CD pipeline live  
**Files:** `wwwroot/sitemap.xml`, `.github/workflows/deploy.yml`, nginx config  
**Owner:** `seo-aio-optimization` + `vps-provisioning`  
**Dependencies:** Batch 3  
**Acceptance:** Lighthouse SEO ≥ 90; deploy workflow green

---

## Review Gates

| Gate | Condition | Checked by |
|------|-----------|------------|
| Technical completeness | All routes return 200; dotnet publish succeeds | @Orchestrator |
| UI completeness | Design contract sections all present in homepage | @Orchestrator |
| Content completeness | All sample content loaded; Decap CMS accessible | @Orchestrator |
| Security | No hardcoded secrets; HSTS enabled; CSP set | @Auditor |
| Pre-delivery | Staging URL reviewed by client | Human operator |

---

## Open Technical Questions

- VPS domain name pending — using `/purewide3` route prefix under shared domain until dedicated domain confirmed.
- Galería page: Instagram Graph API key — to be provided by client or use static image gallery fallback.
- Contact form SMTP credentials — to be provided via GitHub repo secrets (never hardcoded).
