# IMPLEMENTATION_SPEC-pure-wipe.md
**Project:** Pure Wipe — Sitio Web Corporativo  
**Client:** Oclara Group · Atención: Aron Levy  
**Stack:** ASP.NET Core net9.0 · Razor Pages · Bootstrap 5 · Decap CMS · JSON/MD content  
**Spec date:** 2026-04-13  
**Skill:** `spec-driven-architecture`  
**Source:** `PROJECT_ROADMAP.md`

---

## Overview

This document is the single technical source of truth for Pure Wipe implementation.  
Every downstream skill (`content-service-and-data-wiring`, `integrate-ui-component`, `seo-aio-optimization`, `github-project-bootstrap`) must read this file before executing.

Roadmap reference: [`PROJECT_ROADMAP.md`](PROJECT_ROADMAP.md)

---

## Route Matrix

| # | Page | Slug | Razor Page file | Template | Data dependencies | Content source | Acceptance criteria |
|---|---|---|---|---|---|---|---|
| 1 | Inicio | `/` | `Pages/Index.cshtml` | home | ProductLine[], Values[], Testimonials[], HeroContent | `content/home.json`, `content/product-lines/*.json`, `content/testimonials.json` | All sections render with real content; product line cards link to `/productos?linea={id}` |
| 2 | Productos — Catálogo | `/productos` | `Pages/Productos/Index.cshtml` | catalog | ProductLine[], Product[] | `content/product-lines/*.json`, `content/products/*.json` | Grid shows 4 lines; filter by line works; each card links to detail |
| 3 | Productos — Detalle | `/productos/{slug}` | `Pages/Productos/Detalle.cshtml` | product-detail | Product (single) | `content/products/{slug}.json` | Gallery loads (Swiper.js); ingredients accordion works; CTA present |
| 4 | Galería | `/galeria` | `Pages/Galeria/Index.cshtml` | gallery | InstagramFeed (API), UGCImages[], VideoEmbeds[] | Instagram Graph API + `content/gallery-settings.json` | API feed renders or falls back to configured fallback images; no exposed API token in markup |
| 5 | Quiénes Somos | `/nosotros` | `Pages/Nosotros/Index.cshtml` | about | AboutContent, TeamMember[], Certification[] | `content/about.json`, `content/team.json`, `content/certifications.json` | All sections render; team grid responsive; eco section visible |
| 6 | Blog — Listado | `/blog` | `Pages/Blog/Index.cshtml` | blog-list | PostMeta[] | `content/posts/*.md` (frontmatter) | Article cards render with image, date, category; SEO title correct |
| 7 | Blog — Artículo | `/blog/{slug}` | `Pages/Blog/Articulo.cshtml` | blog-article | Post (single with body) | `content/posts/{slug}.md` | Full article renders; related product CTA present; Schema.org Article applied |
| 8 | Contáctenos | `/contacto` | `Pages/Contacto/Index.cshtml` | contact | ContactSettings, Distributor[] | `content/contact-settings.json`, `content/distributors.json` | Contact form submits; distributor form submits; map renders |
| 9 | Legal | `/legal` | `Pages/Legal/Index.cshtml` | legal | LegalSection[] | `content/legal.json` | All legal sections render; anchor navigation works |

> `/admin/` — Decap CMS admin panel. Served from `wwwroot/admin/`. Config: `wwwroot/admin/config.yml`. Not a Razor Page.

---

## Content Contracts

### `content/home.json`
```json
{
  "hero_title": "string — required",
  "hero_subtitle": "string — required",
  "hero_cta_label": "string — required",
  "hero_cta_url": "string — required",
  "hero_image": "string (path) — required",
  "values": [
    { "title": "string", "description": "string", "icon": "string (Bootstrap icon class)" }
  ]
}
```

### `content/product-lines/{id}.json`
```json
{
  "id": "string — required (slug)",
  "name": "string — required",
  "short_description": "string — required",
  "image": "string (path) — required",
  "icon": "string (Bootstrap icon class) — optional",
  "color_accent": "string (hex) — optional"
}
```
> 4 files required: `adultos-mayores.json`, `mascotas.json`, `ecologica.json`, `multiuso-hogar.json`

### `content/products/{slug}.json`
```json
{
  "id": "string — required",
  "name": "string — required",
  "line_id": "string — required (references product-line id)",
  "slug": "string — required",
  "description": "string (markdown) — required",
  "ingredients": ["string"],
  "instructions": "string (markdown) — required",
  "gallery": ["string (image path)"],
  "cta_label": "string — required",
  "cta_url": "string — required"
}
```

### `content/testimonials.json`
```json
{
  "testimonials": [
    { "name": "string", "role": "string — optional", "text": "string", "image": "string — optional" }
  ]
}
```

### `content/about.json`
```json
{
  "historia": "string (markdown) — required",
  "mision": "string — required",
  "vision": "string — required",
  "valores": [
    { "title": "string", "description": "string", "icon": "string — optional" }
  ],
  "eco_statement": "string (markdown) — required"
}
```

### `content/team.json`
```json
{
  "members": [
    { "name": "string", "role": "string", "bio": "string — optional", "image": "string — optional" }
  ]
}
```

### `content/certifications.json`
```json
{
  "allies": [
    { "name": "string", "logo": "string (path)", "url": "string — optional" }
  ]
}
```

### `content/posts/{slug}.md`
```yaml
---
title: "string — required"
date: "YYYY-MM-DD — required"
slug: "string — required"
excerpt: "string — required"
image: "string (path) — required"
category: "string — required"
related_product_line: "string (product-line id) — optional"
---
Article body in Markdown
```

### `content/contact-settings.json`
```json
{
  "form_email_to": "string (email) — required",
  "whatsapp_number": "string (intl format) — required",
  "whatsapp_message": "string — required",
  "social_links": {
    "instagram": "string (url) — optional",
    "facebook": "string (url) — optional"
  }
}
```

### `content/distributors.json`
```json
{
  "distributors": [
    { "name": "string", "city": "string", "address": "string", "lat": "number", "lng": "number" }
  ]
}
```

### `content/gallery-settings.json`
```json
{
  "fallback_images": ["string (path)"],
  "instagram_account": "string — optional (for display label)"
}
```
> Instagram API token stored in `appsettings.json` under `Instagram:AccessToken`. Never in content files.

### `content/legal.json`
```json
{
  "sections": [
    { "slug": "string", "title": "string", "body": "string (markdown)" }
  ]
}
```
> Required sections: `terminos-condiciones`, `privacidad`, `devolucion-garantia`, `informacion-fiscal`

---

## Data Contracts

### C# Models (namespace: `PureWipe.Models`)

```csharp
// Content/ProductLine.cs
public class ProductLine
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string ShortDescription { get; set; }
    public string Image { get; set; }
    public string? Icon { get; set; }
    public string? ColorAccent { get; set; }
}

// Content/Product.cs
public class Product
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string LineId { get; set; }
    public string Slug { get; set; }
    public string Description { get; set; }       // markdown → rendered by service
    public List<string> Ingredients { get; set; }
    public string Instructions { get; set; }      // markdown → rendered by service
    public List<string> Gallery { get; set; }
    public string CtaLabel { get; set; }
    public string CtaUrl { get; set; }
}

// Content/PostMeta.cs
public class PostMeta
{
    public string Title { get; set; }
    public DateOnly Date { get; set; }
    public string Slug { get; set; }
    public string Excerpt { get; set; }
    public string Image { get; set; }
    public string Category { get; set; }
    public string? RelatedProductLine { get; set; }
}

// Content/Post.cs
public class Post : PostMeta
{
    public string Body { get; set; }    // rendered HTML from markdown
}

// Content/AboutContent.cs
public class AboutContent
{
    public string Historia { get; set; }    // rendered HTML
    public string Mision { get; set; }
    public string Vision { get; set; }
    public List<ValueItem> Valores { get; set; }
    public string EcoStatement { get; set; }
}

// Content/ValueItem.cs
public class ValueItem
{
    public string Title { get; set; }
    public string Description { get; set; }
    public string? Icon { get; set; }
}

// Content/TeamMember.cs
public class TeamMember
{
    public string Name { get; set; }
    public string Role { get; set; }
    public string? Bio { get; set; }
    public string? Image { get; set; }
}

// Content/Certification.cs
public class Certification
{
    public string Name { get; set; }
    public string Logo { get; set; }
    public string? Url { get; set; }
}

// Content/Testimonial.cs
public class Testimonial
{
    public string Name { get; set; }
    public string? Role { get; set; }
    public string Text { get; set; }
    public string? Image { get; set; }
}

// Content/Distributor.cs
public class Distributor
{
    public string Name { get; set; }
    public string City { get; set; }
    public string Address { get; set; }
    public double Lat { get; set; }
    public double Lng { get; set; }
}

// Content/LegalSection.cs
public class LegalSection
{
    public string Slug { get; set; }
    public string Title { get; set; }
    public string Body { get; set; }    // rendered HTML
}

// Content/ContactSettings.cs
public class ContactSettings
{
    public string FormEmailTo { get; set; }
    public string WhatsappNumber { get; set; }
    public string WhatsappMessage { get; set; }
    public string? InstagramUrl { get; set; }
    public string? FacebookUrl { get; set; }
}
```

### Services (namespace: `PureWipe.Services`)

| Interface | Methods | Source |
|---|---|---|
| `IContentService<T>` | `T Load(string path)`, `List<T> LoadAll(string pattern)` | Base service — blueprints/code/Services/ContentService.cs |
| `IProductService` | `Task<List<ProductLine>> GetLinesAsync()`, `Task<List<Product>> GetProductsAsync(string? lineId)`, `Task<Product?> GetProductAsync(string slug)` | `content/product-lines/*.json` + `content/products/*.json` |
| `IBlogService` | `Task<List<PostMeta>> GetPostsAsync(string? category)`, `Task<Post?> GetPostAsync(string slug)` | `content/posts/*.md` |
| `IDistributorService` | `Task<List<Distributor>> GetDistributorsAsync()` | `content/distributors.json` |
| `ILegalService` | `Task<List<LegalSection>> GetSectionsAsync()` | `content/legal.json` |
| `IContactSettingsService` | `Task<ContactSettings> GetAsync()` | `content/contact-settings.json` |

> All services registered as `Singleton` — content is file-based and does not change at request time.

---

## Component Map

### Shared Layout — `Pages/Shared/_Layout.cshtml`

| Component | Type | Notes |
|---|---|---|
| Navbar | Bootstrap 5 `navbar navbar-expand-lg sticky-top` | 7 nav items; active class applied by route |
| Footer | Static Bootstrap grid | Social links from `ContactSettings`; legal links to `/legal#*` anchors |
| WhatsApp Float Button | Fixed-position `<a>` | Number + message from `ContactSettings`; `wa.me` URL format |
| `<head>` SEO block | Razor `@section Head` | Title, meta description injected per page by `marketing-seo-pack` |

### Page: Inicio (`/`)

| Section | Bootstrap component | Data source | Notes |
|---|---|---|---|
| Hero/Banner | `container` + full-width image bg | `home.json` | CTA button → `/productos` |
| Líneas de Producto | `row row-cols-2 row-cols-md-4` card grid | `product-lines/*.json` | `dynamic-content-grid` — each card links to `/productos?linea={id}` |
| Valores de Marca | `row row-cols-1 row-cols-md-3` icon + text | `home.json → values[]` | Bootstrap icons |
| Preview Instagram | Static image grid 3-up | `gallery-settings.json → fallback_images` | Link → `/galeria` |
| Testimonios | Bootstrap Carousel | `testimonials.json` | Accessibility: `aria-label` required |

### Page: Productos — Catálogo (`/productos`)

| Section | Bootstrap component | Data source | Notes |
|---|---|---|---|
| Filtro de líneas | Btn group / tab nav | `product-lines/*.json` | Query param `?linea={id}`; JS filter client-side |
| Grid de productos | `row row-cols-2 row-cols-md-3` card grid | `products/*.json` | `dynamic-content-grid`; link to `/productos/{slug}` |

### Page: Productos — Detalle (`/productos/{slug}`)

| Section | Bootstrap component | Data source | Notes |
|---|---|---|---|
| Galería | Swiper.js carousel | `product.gallery[]` | Swiper CDN; thumbnail navigation |
| Descripción + Ingredientes | Bootstrap `Accordion` | `product.description`, `product.ingredients[]` | First accordion item open by default |
| Instrucciones | `<p>` or list | `product.instructions` | Rendered from markdown |
| CTA | `btn btn-primary` | `product.cta_label`, `product.cta_url` | — |

### Page: Galería (`/galeria`)

| Section | Bootstrap component | Data source | Notes |
|---|---|---|---|
| Instagram Feed | Masonry or `row` grid | Instagram Graph API | **Token in `appsettings.json` only** — never inline. Fallback to `fallback_images` on API failure |
| UGC Grid | Static `row row-cols-2 row-cols-md-4` | `gallery-settings.json → fallback_images` | — |

### Page: Quiénes Somos (`/nosotros`)

| Section | Bootstrap component | Data source | Notes |
|---|---|---|---|
| Historia | Two-column text + image | `about.json → historia` | Rendered markdown |
| Misión / Visión | Two-column cards | `about.json → mision, vision` | — |
| Valores | `row row-cols-1 row-cols-md-3` icon cards | `about.json → valores[]` | — |
| Equipo | `row row-cols-2 row-cols-md-4` person cards | `team.json → members[]` | — |
| Eco Commitment | Full-width text section | `about.json → eco_statement` | Green accent color |
| Aliados / Certificaciones | Logo grid | `certifications.json → allies[]` | — |

### Page: Blog — Listado (`/blog`)

| Section | Bootstrap component | Data source | Notes |
|---|---|---|---|
| Category filter | Btn group | Distinct categories from `posts/*.md` | Query param `?categoria={cat}` |
| Article cards | `row row-cols-1 row-cols-md-3` card grid | `PostMeta[]` | Image, date, title, excerpt, category badge; link → `/blog/{slug}` |

### Page: Blog — Artículo (`/blog/{slug}`)

| Section | Bootstrap component | Data source | Notes |
|---|---|---|---|
| Article header | Full-width image + title + meta | `Post` | Schema.org `Article` applied here |
| Article body | Prose `<article>` | `Post.Body` (rendered HTML) | — |
| Related product CTA | Card / banner | `PostMeta.RelatedProductLine` → lookup in lines | Links to `/productos?linea={id}` |

### Page: Contáctenos (`/contacto`)

| Section | Bootstrap component | Data source | Notes |
|---|---|---|---|
| Contact Form | Bootstrap form | POST to `/contacto` handler | Fields: name, email, reason (select), message; honeypot anti-spam field |
| Distributor Map | Leaflet.js map | `distributors.json → distributors[]` | No Google Maps (avoids billing); Leaflet + OpenStreetMap |
| Distributor Form | Bootstrap form | POST to `/contacto/distribuidor` handler | Fields: business_name, contact_name, city, phone, email, message |
| Social links | Icon links | `ContactSettings → instagram/facebook urls` | — |

### Page: Legal (`/legal`)

| Section | Bootstrap component | Notes |
|---|---|---|
| Left sidebar nav | Bootstrap `list-group` sticky | Anchor links to each section |
| Section bodies | `<article>` per section | Rendered from markdown; each with `id="{slug}"` |

---

## JS Dependencies

| Library | Version | Usage | Source |
|---|---|---|---|
| Bootstrap 5 | 5.3.x | All UI components | CDN |
| Swiper.js | 11.x | Product gallery | CDN |
| Leaflet.js | 1.9.x | Distributor map | CDN |
| Bootstrap Icons | 1.11.x | Icons throughout | CDN |

> AOS (Animate on Scroll) is **not** included — adds complexity for zero SEO benefit. Can be added post-delivery if client requests.

---

## Implementation Batches

### Batch 1 — Foundation and Shared Layout
**Objective:** Project scaffold ready, shared layout working, base content service wired.  
**Skill:** `content-service-and-data-wiring` + `integrate-ui-component`  
**Depends on:** `project-scaffolding` complete  

Files likely affected:
- `Program.cs` — service registration
- `Pages/Shared/_Layout.cshtml` — navbar, footer, WhatsApp button
- `Models/Content/*.cs` — all models defined above
- `Services/IContentService.cs`, `Services/ContentService.cs`
- `Services/IContactSettingsService.cs`, `Services/ContactSettingsService.cs`
- `content/contact-settings.json` — sample data

Acceptance criteria:
- App builds and starts without errors
- Navbar renders on all pages with correct links
- Footer renders with WhatsApp button
- Base `IContentService` reads a JSON file without exceptions

---

### Batch 2 — Static Pages: Legal + Nosotros
**Objective:** Two content-only pages with all sections wired and styled.  
**Skill:** `content-service-and-data-wiring` + `integrate-ui-component`  
**Depends on:** Batch 1 complete  

Files likely affected:
- `Models/Content/LegalSection.cs`, `AboutContent.cs`, `TeamMember.cs`, `Certification.cs`, `ValueItem.cs`
- `Services/ILegalService.cs`, `Services/LegalService.cs`
- `Pages/Legal/Index.cshtml` + `Index.cshtml.cs`
- `Pages/Nosotros/Index.cshtml` + `Index.cshtml.cs`
- `content/legal.json`, `content/about.json`, `content/team.json`, `content/certifications.json`

Acceptance criteria:
- `/legal` renders all 4 sections with anchor navigation
- `/nosotros` renders all 6 sections
- Both pages mobile-responsive at 375px

---

### Batch 3 — Product Catalog
**Objective:** Full product catalog with line filtering and individual product detail page.  
**Skill:** `content-service-and-data-wiring` + `integrate-ui-component`  
**Depends on:** Batch 1 complete  

Files likely affected:
- `Models/Content/ProductLine.cs`, `Product.cs`
- `Services/IProductService.cs`, `Services/ProductService.cs`
- `Pages/Productos/Index.cshtml` + `Index.cshtml.cs`
- `Pages/Productos/Detalle.cshtml` + `Detalle.cshtml.cs`
- `content/product-lines/*.json` (4 files), `content/products/*.json` (sample products)

Acceptance criteria:
- `/productos` renders 4-line grid; `?linea={id}` filter works client-side
- `/productos/{slug}` renders gallery (Swiper), accordion, CTA
- 404 returned for unknown slug

---

### Batch 4 — Homepage + Blog
**Objective:** Homepage with all sections; blog listing and article detail.  
**Skill:** `content-service-and-data-wiring` + `integrate-ui-component`  
**Depends on:** Batch 1 + Batch 3 complete (product lines used on homepage)  

Files likely affected:
- `Models/Content/Testimonial.cs`, `PostMeta.cs`, `Post.cs`
- `Services/IBlogService.cs`, `Services/BlogService.cs`
- `Pages/Index.cshtml` + `Index.cshtml.cs`
- `Pages/Blog/Index.cshtml` + `Index.cshtml.cs`
- `Pages/Blog/Articulo.cshtml` + `Articulo.cshtml.cs`
- `content/home.json`, `content/testimonials.json`, `content/posts/*.md` (2 sample posts)

Acceptance criteria:
- `/` renders hero, 4-line grid, values, testimonial carousel, Instagram preview
- `/blog` renders article cards; category filter works
- `/blog/{slug}` renders full article + related product CTA

---

### Batch 5 — Forms + Galería (integrations)
**Objective:** Contact and distributor forms working; Galería with Instagram API + fallback.  
**Skill:** `content-service-and-data-wiring` + `integrate-ui-component`  
**Depends on:** Batch 1 + Batch 3 complete  

Files likely affected:
- `Models/Content/Distributor.cs`
- `Services/IDistributorService.cs`, `Services/DistributorService.cs`
- `Pages/Contacto/Index.cshtml` + `Index.cshtml.cs`
- `Pages/Galeria/Index.cshtml` + `Index.cshtml.cs`
- `content/distributors.json`, `content/gallery-settings.json`
- `appsettings.json` — `Instagram:AccessToken` key (value in secrets)

Acceptance criteria:
- Contact form submits; server-side validation fires on empty fields
- Distributor form submits
- Both forms show success/error feedback without full page reload
- Honeypot field present and invisible (CSS `display:none`)
- `/galeria` renders fallback images when API token is not configured
- No Instagram token visible in rendered HTML

---

### Batch 6 — SEO and AIO
**Objective:** Schema.org markup, AIO meta, sitemap.xml, robots.txt on all pages.  
**Skill:** `seo-aio-optimization`  
**Depends on:** Batches 1–5 complete  

Files likely affected:
- `Pages/Shared/_Layout.cshtml` — `<head>` SEO block per page
- `Pages/*.cshtml` — `@section Head` with page-specific meta
- `wwwroot/sitemap.xml` — generated or static
- `wwwroot/robots.txt`

Acceptance criteria:
- Every route has unique `<title>` and `<meta name="description">`
- `/blog/{slug}` has `Schema.org/Article` JSON-LD
- `sitemap.xml` includes all 7 routes
- `robots.txt` allows all, disallows `/admin/`

---

## Review Gates

### Gate 1 — Technical (before Batch 4 starts)
- [ ] `dotnet build` passes with 0 errors
- [ ] All registered services resolve via DI
- [ ] Routes 1–3 return HTTP 200 with real content (not lorem ipsum)
- [ ] No hard-coded secrets in any `.cs` or `.cshtml` file

### Gate 2 — UI Completeness (before Batch 6 starts)
- [ ] All 7 routes return HTTP 200
- [ ] All pages render at 375px (mobile) without horizontal scroll
- [ ] WhatsApp float button visible and links correctly
- [ ] Forms on `/contacto` render and show validation

### Gate 3 — Content + CMS (before security-audit)
- [ ] `/admin/` loads Decap CMS login screen
- [ ] All Decap collections writable (at least one save test per collection)
- [ ] No `console.error` in browser on any page

### Gate 4 — Pre-Delivery (before deploy)
- [ ] `security-audit` skill completed — GO issued by `@Auditor`
- [ ] Client has reviewed staging URL
- [ ] Final payment confirmed (per contract terms)

---

## Open Technical Questions

| # | Question | Owner | Status |
|---|---|---|---|
| 1 | Does the existing PureWipe repo (`carlosperez1986/purewipe`) already have product data or only placeholder content? | Human operator | ❓ Open |
| 2 | Instagram API: does the client have an active Meta Developer App and an access token? | Client (Oclara Group) | ❓ Open |
| 3 | Distributor map: is a list of distributors already available, or does it need to be created from scratch? | Client (Oclara Group) | ❓ Open |
| 4 | Legal content: does the client have existing Terms & Privacy Policy text (Ley 1581/2012)? | Client (Oclara Group) | ❓ Open |
| 5 | Blog: does the client have existing article content, or will all blog posts be created during delivery? | Client (Oclara Group) | ❓ Open |
