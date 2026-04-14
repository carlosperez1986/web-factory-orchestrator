# IMPLEMENTATION_SPEC-mimascota.md

**Project:** Mi Mascota (mimascota)
**Client:** Oclara Group · Atención: Aron Levy
**Phase:** Build
**Stack:** .NET 9 Razor Pages · Decap CMS · Bootstrap 5 · Git-based JSON/MD
**Date:** 2026-04-14
**Source:** `PROJECT_ROADMAP-mimascota.md` · `STRATEGY_CONTRACT-mimascota.json`

---

## Overview

This spec converts the approved `PROJECT_ROADMAP-mimascota.md` into a complete, agent-executable technical contract. All page routes, content files, data contracts, UI sections, and implementation batches are defined here. No downstream agent may guess at structure — it must follow this document.

**Special requirement (locked):** The Hero/Banner section on the Inicio page is **fully editable via Decap CMS**. Content is stored in `content/hero.json` and wired into `Pages/Index.cshtml` via `ContentService`. A dedicated Decap collection `hero` is defined in `wwwroot/admin/config.yml`.

---

## Route Matrix

> Every sitemap route is listed with its Razor Page file target, purpose, template, data dependencies, content source, and acceptance criteria.

| # | Route | Razor Page File | Purpose | Template | Data Dependencies | Content Source | Acceptance Criteria |
|---|-------|-----------------|---------|----------|-------------------|----------------|---------------------|
| 1 | `/` | `Pages/Index.cshtml` + `Pages/Index.cshtml.cs` | Home — discovery + conversion | `home` | HeroBanner, ProductLines, Testimonials, InstagramPreview | `content/hero.json`, `content/product-lines.json`, `content/testimonials.json` | Hero renders from `content/hero.json`; all fields editable in `/admin/`; product lines display with CTAs; page passes SEO audit |
| 2 | `/productos` | `Pages/Productos/Index.cshtml` + `.cs` | Product catalog — 4 lines grid | `catalog` | ProductLines, ProductDetails | `content/product-lines.json`, `content/products/*.json` | 4-line grid renders; each card links to detail; detail page shows ingredients, usage, warnings |
| 3 | `/productos/{slug}` | `Pages/Productos/Detalle.cshtml` + `.cs` | Product detail — ficha individual | `catalog` | ProductDetail | `content/products/{slug}.json` | Renders gallery, description, ingredients, instructions, related products |
| 4 | `/galeria` | `Pages/Galeria/Index.cshtml` + `.cs` | Visual gallery — Instagram feed + UGC | `services` | InstagramFeed, GalleryItems | `content/gallery.json` (static fallback) | Grid displays; Instagram integration renders or degrades gracefully; UGC section present |
| 5 | `/nosotros` | `Pages/Nosotros.cshtml` + `.cs` | Brand — history, team, mission | `about` | BrandStory, TeamMembers | `content/about.json` | History, mission/vision/values, team cards, eco-commitment section present |
| 6 | `/blog` | `Pages/Blog/Index.cshtml` + `.cs` | Blog — article list | `blog` | BlogPosts | `content/blog/*.md` | List renders with SEO titles, featured images, category tags, and CTAs to related products |
| 7 | `/blog/{slug}` | `Pages/Blog/Post.cshtml` + `.cs` | Blog — individual article | `blog` | BlogPost | `content/blog/{slug}.md` | Article renders with SEO meta, schema.org Article, CTA to related product |
| 8 | `/contacto` | `Pages/Contacto.cshtml` + `.cs` | Contact — form + distributors | `contact` | ContactForm, Distributors | `content/contact.json` | Form submits via POST (AJAX); reason selector works; distributors list renders; WhatsApp link present |
| 9 | `/legal` | `Pages/Legal.cshtml` + `.cs` | Legal — policies | `about` | LegalContent | `content/legal.json` | Renders T&C, Privacy Policy (Ley 1581), Return Policy sections |
| 10 | `/admin/` | Static Decap CMS (`wwwroot/admin/index.html`) | CMS editor | — | Decap config | `wwwroot/admin/config.yml` | Login via GitHub OAuth; hero collection editable; all content collections visible |

---

## Content Contracts

### `content/hero.json` — Hero Banner (Decap-editable)

> **Required by:** `decap-hero-banner` component · **Owner:** ContentService + Decap CMS  
> **Decap collection:** `hero` (singleton) in `wwwroot/admin/config.yml`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | ✅ | Main headline of the hero section |
| `subtitle` | string | ✅ | Supporting text below the headline |
| `cta_primary_text` | string | ✅ | Label for primary CTA button |
| `cta_primary_url` | string | ✅ | URL for primary CTA (e.g., `/productos`) |
| `cta_secondary_text` | string | optional | Label for secondary CTA button |
| `cta_secondary_url` | string | optional | URL for secondary CTA (e.g., `/nosotros`) |
| `background_image` | string | ✅ | Path to hero background image (relative to `wwwroot/`) |

**Default seed file (`content/hero.json`):**
```json
{
  "title": "Higiene segura para tu mascota",
  "subtitle": "Toallitas biodegradables con ingredientes 100% seguros para perros y gatos.",
  "cta_primary_text": "Ver productos",
  "cta_primary_url": "/productos",
  "cta_secondary_text": "Conocer la marca",
  "cta_secondary_url": "/nosotros",
  "background_image": "images/hero-bg.jpg"
}
```

---

### `content/product-lines.json` — Product Lines

> **Required by:** `dynamic-content-grid` · **Owner:** ContentService

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `lines[]` | array | ✅ | Array of product line objects |
| `lines[].id` | string | ✅ | Slug identifier (e.g., `mascotas`) |
| `lines[].name` | string | ✅ | Display name |
| `lines[].description` | string | ✅ | Brief description for grid card |
| `lines[].image` | string | ✅ | Image path |
| `lines[].cta_url` | string | ✅ | Link to `/productos?linea={id}` |
| `lines[].color_accent` | string | optional | Bootstrap color class for card accent |

---

### `content/products/{slug}.json` — Product Detail

> **Required by:** `dynamic-content-grid` · **Owner:** ContentService

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `slug` | string | ✅ | URL-safe identifier |
| `name` | string | ✅ | Product name |
| `line` | string | ✅ | Parent line id |
| `description` | string | ✅ | Full description |
| `ingredients` | string[] | ✅ | List of ingredients |
| `certifications` | string[] | optional | Certification labels |
| `usage_instructions` | string | ✅ | How to use |
| `warnings` | string | optional | Contra-indications |
| `presentations` | string[] | ✅ | Available formats/sizes |
| `gallery_images` | string[] | ✅ | Image paths |
| `related_products` | string[] | optional | Slugs of related products |
| `cta_text` | string | optional | Override CTA label |
| `cta_url` | string | optional | Where to buy / contact link |

---

### `content/about.json` — Brand Story and Team

> **Owner:** ContentService

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `brand_story` | string | ✅ | Markdown — origin story |
| `mission` | string | ✅ | Brand mission |
| `vision` | string | ✅ | Brand vision |
| `values` | string[] | ✅ | Array of values (e.g., "Higiene", "Sostenibilidad") |
| `eco_commitment` | string | ✅ | Markdown — environmental policy |
| `team[]` | array | optional | Team members |
| `team[].name` | string | ✅ | Member name |
| `team[].role` | string | ✅ | Job title |
| `team[].photo` | string | optional | Photo path |

---

### `content/blog/*.md` — Blog Articles

> **Owner:** ContentService (reads frontmatter + body)

**Frontmatter fields:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | ✅ | SEO title |
| `date` | string | ✅ | ISO 8601 date |
| `category` | string | ✅ | e.g., `mascotas`, `ecologia`, `bienestar` |
| `featured_image` | string | ✅ | Image path |
| `excerpt` | string | ✅ | 160-char summary (used for SEO meta description) |
| `related_product` | string | optional | Product slug for CTA |
| `slug` | string | ✅ | URL-safe identifier |

---

### `content/gallery.json` — Gallery (static fallback)

> **Owner:** ContentService (Instagram API integration is Phase 2 optional enhancement)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `items[]` | array | ✅ | Gallery items |
| `items[].image` | string | ✅ | Image path |
| `items[].caption` | string | optional | Caption text |
| `items[].line` | string | optional | Product line tag for filtering |
| `items[].type` | string | ✅ | `photo` or `video` |

---

### `content/contact.json` — Contact and Distributors

> **Owner:** ContentService

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `whatsapp_number` | string | ✅ | WhatsApp Business number with country code |
| `whatsapp_message` | string | ✅ | Pre-filled message for WhatsApp link |
| `social_links.instagram` | string | optional | Instagram profile URL |
| `social_links.facebook` | string | optional | Facebook URL |
| `social_links.tiktok` | string | optional | TikTok URL |
| `distributors[]` | array | optional | List of distributors |
| `distributors[].city` | string | ✅ | City name |
| `distributors[].name` | string | ✅ | Business name |
| `distributors[].address` | string | optional | Street address |
| `distributors[].phone` | string | optional | Contact phone |

---

### `content/testimonials.json` — Social Proof

> **Owner:** ContentService

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `items[]` | array | ✅ | Testimonial list |
| `items[].author` | string | ✅ | Customer name |
| `items[].rating` | number | ✅ | 1–5 |
| `items[].text` | string | ✅ | Review body |
| `items[].line` | string | optional | Product line referenced |

---

### `content/legal.json` — Legal Content

> **Owner:** ContentService

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `terms` | string | ✅ | Markdown — Términos y Condiciones |
| `privacy` | string | ✅ | Markdown — Política de Privacidad (Ley 1581 de 2012) |
| `returns` | string | ✅ | Markdown — Política de Devolución y Garantía |
| `fiscal_info` | string | optional | Markdown — Información fiscal y legal |

---

## Data Contracts

### C# Models (namespace `MiMascota.Models`)

| Model | Source File | Maps To |
|-------|-------------|---------|
| `HeroBanner` | `Models/HeroBanner.cs` | `content/hero.json` |
| `ProductLine` | `Models/ProductLine.cs` | `content/product-lines.json` → `.lines[]` |
| `Product` | `Models/Product.cs` | `content/products/{slug}.json` |
| `BrandAbout` | `Models/BrandAbout.cs` | `content/about.json` |
| `BlogPost` | `Models/BlogPost.cs` | `content/blog/{slug}.md` frontmatter + body |
| `GalleryItem` | `Models/GalleryItem.cs` | `content/gallery.json` → `.items[]` |
| `ContactConfig` | `Models/ContactConfig.cs` | `content/contact.json` |
| `Testimonial` | `Models/Testimonial.cs` | `content/testimonials.json` → `.items[]` |
| `LegalContent` | `Models/LegalContent.cs` | `content/legal.json` |

### `ContentService` Method Registry (`Services/ContentService.cs`)

| Method | Returns | Description |
|--------|---------|-------------|
| `GetHeroBanner()` | `HeroBanner` | Reads + deserializes `content/hero.json` |
| `GetProductLines()` | `List<ProductLine>` | Reads `content/product-lines.json` |
| `GetProduct(string slug)` | `Product?` | Reads `content/products/{slug}.json` |
| `GetAllProducts()` | `List<Product>` | Reads all files in `content/products/` |
| `GetAbout()` | `BrandAbout` | Reads `content/about.json` |
| `GetBlogPosts()` | `List<BlogPost>` | Reads all `.md` frontmatter in `content/blog/` |
| `GetBlogPost(string slug)` | `BlogPost?` | Reads single `content/blog/{slug}.md` |
| `GetGallery()` | `List<GalleryItem>` | Reads `content/gallery.json` |
| `GetContactConfig()` | `ContactConfig` | Reads `content/contact.json` |
| `GetTestimonials()` | `List<Testimonial>` | Reads `content/testimonials.json` |
| `GetLegalContent()` | `LegalContent` | Reads `content/legal.json` |

All methods throw `FileNotFoundException` if content file is missing (no silent nulls). Blog post body is parsed from Markdown to HTML using `Markdig`.

---

## Component Map

### Shared Layout (`Pages/Shared/_Layout.cshtml`)

| Component | Bootstrap Spec | Notes |
|-----------|---------------|-------|
| Header nav | `navbar navbar-expand-lg` | Brand logo left; nav links right; mobile hamburger |
| Floating WhatsApp button | Fixed `btn` bottom-right | `href` built from `ContactConfig.whatsapp_number` + `ContactConfig.whatsapp_message` |
| Promo banner (global) | `alert alert-dismissible` top | Optional — shown when `content/promo.json` exists with `active: true` |
| Footer | `container` 3-column grid | Links, social icons, legal link, brand credit |

### Page-Level Sections

#### `Pages/Index.cshtml` — Home

| Section | Component | Data | Notes |
|---------|-----------|------|-------|
| Hero / Banner principal | Bootstrap Jumbotron / full-width div | `HeroBanner` from `content/hero.json` | **Decap-editable — TASK-024** · AOS fade-in |
| Quick nav by product line | Bootstrap card grid 4-col | `ProductLines` | Icon + label + CTA per line |
| Featured product lines | Bootstrap card grid | `ProductLines` | Image, description, CTA per line |
| Brand values / differentiators | Bootstrap icon-grid | Static or `content/home-values.json` | 4 values: Higiene, Ingredientes, Ecología, Calidad |
| Instagram preview | Grid 6 thumbnails | Static `gallery.json` or Instagram API | CTA: "Síguenos en Instagram" |
| How-to / Cómo funciona | Step-list with numbered icons | Static content or `content/how-to.json` | 3–4 steps per product line |
| Social proof / Testimonials | Bootstrap carousel or card grid | `Testimonials` | Star ratings + author name |

#### `Pages/Productos/Index.cshtml` — Product Catalog

| Section | Component | Data |
|---------|-----------|------|
| Line grid | Bootstrap 4-col card grid | `ProductLines` |
| Line filter tabs | Bootstrap nav-tabs | Filters by `line` field |
| Product cards per line | Bootstrap card grid | `List<Product>` filtered by line |

#### `Pages/Productos/Detalle.cshtml` — Product Detail

| Section | Component | Data |
|---------|-----------|------|
| Image gallery | Swiper.js carousel | `Product.gallery_images` |
| Product description | Bootstrap prose column | `Product.description` |
| Ingredients + certifications | Bootstrap list-group | `Product.ingredients`, `Product.certifications` |
| Usage instructions | Bootstrap card | `Product.usage_instructions` |
| Warnings | Bootstrap alert | `Product.warnings` (if present) |
| Related products | Bootstrap card row | `Product.related_products` → resolved slugs |
| CTA (contact / buy) | Bootstrap btn-primary | `Product.cta_text` / `Product.cta_url` |

#### `Pages/Galeria/Index.cshtml` — Gallery

| Section | Component | Data |
|---------|-----------|------|
| Instagram feed grid | 3-col responsive grid | Static `gallery.json` (Phase 2: Instagram API) |
| Line filter | Bootstrap badge/pill filter | `GalleryItem.line` values |
| UGC section | Bootstrap masonry-style grid | Tagged `type: photo` items |
| Reels / videos | Bootstrap embed-responsive | Tagged `type: video` items |

#### `Pages/Nosotros.cshtml` — About

| Section | Component | Data |
|---------|-----------|------|
| Brand story | Bootstrap prose | `BrandAbout.brand_story` (Markdown → HTML) |
| Mission / vision / values | Bootstrap 3-col card | `BrandAbout.mission`, `vision`, `values` |
| Team | Bootstrap card grid | `BrandAbout.team[]` |
| Eco commitment | Bootstrap blockquote / section | `BrandAbout.eco_commitment` |
| Social proof | Bootstrap testimonial cards | `Testimonials` (top 3) |

#### `Pages/Blog/Index.cshtml` — Blog List

| Section | Component | Data |
|---------|-----------|------|
| Article grid | Bootstrap card grid | `List<BlogPost>` sorted by date desc |
| Category filter | Bootstrap nav-pills | Post categories |
| Article card | Image + title + excerpt + CTA | `BlogPost` frontmatter |

#### `Pages/Blog/Post.cshtml` — Blog Article

| Section | Component | Data |
|---------|-----------|------|
| Featured image | Full-width responsive img | `BlogPost.featured_image` |
| Article body | Bootstrap prose | `BlogPost.body` (Markdown → HTML) |
| Related product CTA | Bootstrap alert-link card | `BlogPost.related_product` slug → Product name + link |
| Share links | Icon buttons | Static social share URLs |

#### `Pages/Contacto.cshtml` — Contact

| Section | Component | Data |
|---------|-----------|------|
| Contact form | Bootstrap form (POST/AJAX) | Fields: name, email, message, reason selector |
| Social links | Icon button row | `ContactConfig.social_links` |
| WhatsApp CTA | Bootstrap btn-success | `ContactConfig.whatsapp_number` |
| Distributors list | Bootstrap list-group or table | `ContactConfig.distributors[]` |
| Distributor application form | Bootstrap form modal | Name, city, email, volume — sends email |

#### `Pages/Legal.cshtml` — Legal

| Section | Component | Data |
|---------|-----------|------|
| T&C section | Bootstrap accordion | `LegalContent.terms` |
| Privacy policy | Bootstrap accordion | `LegalContent.privacy` |
| Returns policy | Bootstrap accordion | `LegalContent.returns` |
| Fiscal info | Bootstrap collapse | `LegalContent.fiscal_info` (if present) |

---

## Decap CMS Configuration Spec (`wwwroot/admin/config.yml`)

### Required Collections

| Collection | Type | Content File | Editable Fields |
|------------|------|--------------|-----------------|
| `hero` | **singleton** | `content/hero.json` | title, subtitle, cta_primary_text, cta_primary_url, cta_secondary_text, cta_secondary_url, background_image (image widget) |
| `product_lines` | **file** | `content/product-lines.json` | lines[] array |
| `products` | **folder** | `content/products/` | All product detail fields |
| `about` | **singleton** | `content/about.json` | brand_story (markdown), team[], mission, vision, values, eco_commitment |
| `blog` | **folder** | `content/blog/` | frontmatter + body (markdown editor) |
| `gallery` | **singleton** | `content/gallery.json` | items[] array with image widget |
| `contact` | **singleton** | `content/contact.json` | whatsapp_number, social_links, distributors[] |
| `testimonials` | **singleton** | `content/testimonials.json` | items[] array |
| `legal` | **singleton** | `content/legal.json` | terms, privacy, returns (markdown widgets) |

---

## Implementation Batches

### Batch 0 — Foundation

| Attribute | Value |
|-----------|-------|
| **Objective** | Scaffold .NET 9 project, add NuGet dependencies, create ContentService skeleton |
| **Files affected** | `MiMascota.csproj`, `Program.cs`, `Services/ContentService.cs`, `appsettings.json` |
| **Skill owner** | `content-service-and-data-wiring` |
| **Dependencies** | None — this is the foundation |
| **Acceptance criteria** | `dotnet build` passes; `ContentService` registers in DI; all model classes compile |

**NuGet packages required:**
- `Markdig` (Markdown → HTML for blog posts and about body)
- `System.Text.Json` (included in .NET 9 BCL — no extra package needed)

---

### Batch 1 — Decap CMS Hero Banner

| Attribute | Value |
|-----------|-------|
| **Objective** | Wire `content/hero.json` → `HeroBanner` model → `Index.cshtml`; configure Decap `hero` singleton collection |
| **Files affected** | `content/hero.json`, `Models/HeroBanner.cs`, `Services/ContentService.cs` (add `GetHeroBanner()`), `Pages/Index.cshtml`, `wwwroot/admin/config.yml` (hero collection) |
| **Skill owner** | `content-service-and-data-wiring` + `integrate-ui-component` |
| **Dependencies** | Batch 0 |
| **Acceptance criteria** | Hero section on `/` renders title, subtitle, and CTAs from JSON; editing `content/hero.json` via `/admin/` immediately reflects on next page load; `background_image` field controls hero background |

---

### Batch 2 — Product Catalog

| Attribute | Value |
|-----------|-------|
| **Objective** | Wire product lines + products to catalog and detail pages |
| **Files affected** | `content/product-lines.json`, `content/products/*.json`, `Models/ProductLine.cs`, `Models/Product.cs`, `Services/ContentService.cs`, `Pages/Productos/Index.cshtml`, `Pages/Productos/Detalle.cshtml`, `wwwroot/admin/config.yml` (products collections) |
| **Skill owner** | `content-service-and-data-wiring` + `integrate-ui-component` |
| **Dependencies** | Batch 0 |
| **Acceptance criteria** | 4 product lines render in grid; detail page shows all fields; Swiper gallery on detail page works |

---

### Batch 3 — Blog + About + Gallery

| Attribute | Value |
|-----------|-------|
| **Objective** | Wire blog, about, gallery pages |
| **Files affected** | `content/blog/*.md`, `content/about.json`, `content/gallery.json`, related models and pages |
| **Skill owner** | `content-service-and-data-wiring` + `integrate-ui-component` |
| **Dependencies** | Batch 0 |
| **Acceptance criteria** | Blog list renders with SEO metadata; article page renders Markdown; About page renders all sections; Gallery renders 6-up responsive grid |

---

### Batch 4 — Contact + Legal + Global Components

| Attribute | Value |
|-----------|-------|
| **Objective** | Contact form POST handling, distributors list, legal content, layout components |
| **Files affected** | `content/contact.json`, `content/legal.json`, `content/testimonials.json`, `Pages/Contacto.cshtml`, `Pages/Legal.cshtml`, `Pages/Shared/_Layout.cshtml`, `Pages/Index.cshtml` (testimonials + Instagram preview) |
| **Skill owner** | `integrate-ui-component` + `content-service-and-data-wiring` |
| **Dependencies** | Batch 0 |
| **Acceptance criteria** | Form submits POST without page reload; WhatsApp floating button present on all pages; legal accordion renders |

---

### Batch 5 — SEO + AIO Meta Pack

| Attribute | Value |
|-----------|-------|
| **Objective** | Add Schema.org structured data + AIO-optimized meta tags to all pages |
| **Files affected** | `Pages/Shared/_Layout.cshtml`, all page models (add `SeoMeta` properties), `evidence/seo-audit-pass.md` |
| **Skill owner** | `seo-aio-optimization` |
| **Dependencies** | Batches 1–4 |
| **Acceptance criteria** | All pages have `<title>`, `<meta name="description">`, `og:*` tags; homepage has `schema.org/Organization`; product pages have `schema.org/Product`; blog posts have `schema.org/Article` |

---

### Batch 6 — Decap CMS Full Config + Admin Wire-up

| Attribute | Value |
|-----------|-------|
| **Objective** | Complete `wwwroot/admin/config.yml` with all 9 collections; deploy and test `/admin/` |
| **Files affected** | `wwwroot/admin/config.yml`, `wwwroot/admin/index.html`, GitHub OAuth setup guide |
| **Skill owner** | `github-project-bootstrap` |
| **Dependencies** | Batch 0 |
| **Acceptance criteria** | `/admin/` loads; GitHub OAuth login succeeds; all 9 collections visible; hero singleton saves and content updates on next page load |

---

## Review Gates

### Gate 1 — Technical Completeness

- [ ] `dotnet build` passes with 0 errors and 0 warnings
- [ ] All routes respond with HTTP 200 or appropriate redirect
- [ ] `ContentService` returns non-null for all seed data files
- [ ] `GetHeroBanner()` reads `content/hero.json` and binds to `HeroBanner` model
- [ ] `/admin/` loads and hero collection is editable

### Gate 2 — UI Completeness

- [ ] All 7 public pages render on desktop (≥ 1280px) and mobile (≤ 375px)
- [ ] Swiper gallery works on product detail page
- [ ] AOS fade-in animations load on Inicio hero
- [ ] Bootstrap nav collapses correctly to hamburger on mobile
- [ ] Floating WhatsApp button visible on every page

### Gate 3 — Content Completeness

- [ ] `content/hero.json` seed file exists with all required fields
- [ ] At least 4 product line entries in `content/product-lines.json`
- [ ] At least 1 product in `content/products/` per line (4 minimum)
- [ ] At least 1 blog post in `content/blog/`
- [ ] `content/about.json`, `content/contact.json`, `content/legal.json`, `content/testimonials.json` all exist

### Gate 4 — Pre-Delivery Review

- [ ] @Auditor security-audit sign-off (`evidence/security-audit-report.md`)
- [ ] SEO audit pass (`evidence/seo-audit-pass.md`)
- [ ] Staging smoke test pass (`evidence/staging-smoke.md`)
- [ ] Client has reviewed staging URL and approved
- [ ] Final payment confirmed before production deploy

---

## Open Technical Questions

| # | Question | Impact | Resolution |
|---|----------|--------|-----------|
| 1 | Instagram API integration: use official Graph API or embed widget? | Affects gallery and homepage Instagram preview | Default to static `gallery.json` fallback; real API integration is an optional Phase 2 add-on. Unblock now. |
| 2 | Contact form: use SMTP (SendGrid/Mailgun) or static form handler (Formspree)? | Affects `contact-form-handler` implementation | Use Formspree or mailto action for v1 to avoid SMTP secrets; upgrade to SendGrid in Phase 2 if needed. |
| 3 | Decap GitHub OAuth: will the client create a GitHub OAuth App or use the Netlify OAuth proxy? | Required for `/admin/` login | Defer to VPS provisioning skill — ask client for `DECAP_GITHUB_CLIENT_ID` and `DECAP_GITHUB_CLIENT_SECRET`. |
| 4 | Domain for mimascota: custom or shared? | Affects Nginx config | Deferred to VPS provisioning intake. |
