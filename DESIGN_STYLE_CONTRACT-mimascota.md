# DESIGN_STYLE_CONTRACT-mimascota.md

**Project:** Mi Mascota (mimascota)
**Client:** Oclara Group · Aron Levy
**Date locked:** 2026-04-14
**Skill:** look-and-feel-ingestion
**Source type:** Reference image — Pure Wipes homepage (desktop) · Oclara Group brand family
**Strictness level:** close-match (same brand family; adapted for pet/mascotas focus)

> ⚠️ **SECRET POLICY:** The Stitch MCP API key provided by the operator was used for session analysis only.
> It is **NOT** stored in any file in this repository. Do not add it to config files, env files, or code.

---

## Visual Source Reference

| Asset | Type | Notes |
|-------|------|-------|
| `c1fb7f25-a385-4156-83fd-de0aef5a5efe` (GitHub attachment) | Desktop homepage screenshot | Pure Wipes official site — Oclara Group parent brand |

**Adaptation rule:** mimascota adapts the Pure Wipes visual identity for the Mascotas line (dogs & cats). Color palette and typography are retained from the brand family. Pet imagery replaces multi-line product imagery.

---

## Token Dictionary

### Colors

| Token | Hex | Usage |
|-------|-----|-------|
| `--color-primary` | `#1a6db5` | Nav links, logo accent, links, active states |
| `--color-primary-dark` | `#0d4a8f` | CTA button fill (primary), footer link hover |
| `--color-hero-bg` | `#ddeef8` | Hero section background (light sky-blue wash) |
| `--color-surface` | `#ffffff` | Cards, modals, form backgrounds |
| `--color-surface-alt` | `#f0f7fc` | Alternating section backgrounds, values strip |
| `--color-eco` | `#3a9d5d` | Eco / biodegradable accent, badge backgrounds, leaf icons |
| `--color-eco-dark` | `#2a7444` | Eco hover states |
| `--color-navy` | `#0d1f3c` | Footer background, hero headline text, CTA filled |
| `--color-text-body` | `#2c3e50` | Body copy, card descriptions |
| `--color-text-muted` | `#6b7c93` | Secondary labels, captions |
| `--color-border` | `#d0e4f0` | Card borders, section dividers |
| `--color-badge-pet` | `#e6f4ff` | Pet category badge background |
| `--color-badge-eco` | `#e6f5ec` | Eco category badge background |
| `--color-badge-blog` | `#fff3e0` | Blog category badge (used in cards) |
| `--color-white` | `#ffffff` | Text on dark backgrounds, icon fill on eco banner |

**DO NOT use:** red except for form validation errors; saturated purple/pink; gray backgrounds heavier than `#f5f8fb`.

---

### Typography

> **Licensed system fonts** — no proprietary or paid fonts. Use Google Fonts or system stack.

| Token | Value | Notes |
|-------|-------|-------|
| `--font-primary` | `'Inter', 'Segoe UI', system-ui, sans-serif` | All body, labels, nav |
| `--font-display` | `'Poppins', 'Inter', sans-serif` | Headlines H1–H3; hero title |
| `--font-size-hero` | `clamp(2rem, 5vw, 3.5rem)` | Hero H1 |
| `--font-size-h2` | `clamp(1.5rem, 3vw, 2.25rem)` | Section headings |
| `--font-size-h3` | `1.25rem` | Card titles, subsection headings |
| `--font-size-body` | `1rem` (16px) | Default body |
| `--font-size-small` | `0.875rem` | Captions, meta, legal |
| `--font-weight-bold` | `700` | Display headings, CTA labels |
| `--font-weight-semibold` | `600` | Nav links, card titles |
| `--font-weight-regular` | `400` | Body, captions |
| `--line-height-display` | `1.15` | Hero and section headlines |
| `--line-height-body` | `1.65` | Paragraphs and descriptions |

---

### Spacing and Section Rhythm

| Token | Value | Usage |
|-------|-------|-------|
| `--section-padding-y` | `80px` desktop / `48px` mobile | Vertical padding all full-width sections |
| `--card-gap` | `24px` | Grid gap between cards |
| `--card-padding` | `20px` | Internal card padding |
| `--container-max` | `1200px` | Bootstrap `container-xl` |
| `--hero-min-height` | `520px` desktop / `auto` mobile | Hero section minimum height |
| `--nav-height` | `72px` | Sticky navbar height |

---

### Border Radius and Elevation

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-card` | `12px` | Product cards, blog cards, testimonials |
| `--radius-badge` | `20px` | Category badges, status pills |
| `--radius-btn` | `50px` | All CTA buttons (pill shape — see reference) |
| `--radius-input` | `8px` | Form inputs, textarea |
| `--shadow-card` | `0 2px 12px rgba(13,31,60,0.08)` | Default card shadow |
| `--shadow-card-hover` | `0 6px 24px rgba(13,31,60,0.14)` | Card hover lift |
| `--shadow-nav` | `0 2px 8px rgba(13,31,60,0.10)` | Sticky nav shadow |

---

### Motion Rules

| Token | Value | Usage |
|-------|-------|-------|
| `--transition-base` | `0.2s ease` | Buttons, links, nav states |
| `--transition-card` | `0.3s ease` | Card hover lift |
| `--aos-duration` | `600ms` | AOS fade-in duration |
| `--aos-offset` | `60px` | AOS trigger offset |
| `reduced-motion` | `prefers-reduced-motion: reduce → disable all AOS and transitions` | Accessibility |

---

## Component Style Map

### Nav — `Pages/Shared/_Layout.cshtml` (header)

| Attribute | Implementation |
|-----------|---------------|
| Background | `bg-white` with `shadow-nav` on scroll (add class via JS `IntersectionObserver`) |
| Logo | SVG or PNG, height `40px`, left-aligned in `navbar-brand` |
| Links | `nav-link` · `font-weight: 600` · color `--color-primary` on hover · `font-size: 0.95rem` |
| Dropdown | Bootstrap dropdown · no mega-menu · `border-radius: 8px` · `box-shadow: --shadow-card` |
| CTA button | `btn btn-outline-primary btn-sm rounded-pill` · icon pin-location prepended · right-aligned |
| Mobile | `navbar-toggler` collapses at `lg` breakpoint · hamburger icon · drawer pushes content down |
| Sticky | `position: sticky; top: 0; z-index: 1030;` |

---

### Hero / Banner Principal — `Pages/Index.cshtml` #hero

| Attribute | Implementation |
|-----------|---------------|
| Background | `background-color: var(--color-hero-bg)` with subtle radial water-ripple SVG overlay (optional) |
| Layout | Bootstrap `row` — text col `col-lg-5`, image col `col-lg-7` — reversed on mobile |
| Headline | `<h1>` · `font-family: var(--font-display)` · `font-weight: 700` · color `--color-navy` · `font-size: var(--font-size-hero)` |
| Subtext | `<p>` · `--font-size-body` · `--color-text-muted` · max-width `480px` |
| CTA primary | `btn btn-dark btn-lg rounded-pill px-4` — color `--color-navy` fill · label "Conoce nuestras soluciones" + chevron icon |
| CTA secondary | `btn btn-outline-secondary btn-lg rounded-pill px-4` — label "Nuestro compromiso" + link icon |
| Product image | Right col · `img-fluid` · CSS drop-shadow · AOS `fade-left` on desktop · stacked on mobile |
| Eco badge | Floating stamp badge (top-right of image col) · `border-radius: 50%` · border `--color-eco` · small font |
| AOS | `data-aos="fade-right"` on text block · `data-aos="fade-left"` on image block |
| **Decap-editable** | All content via `content/hero.json` → `HeroBanner` model. `background_image` sets CSS `background-image` on hero section. |

---

### Values Strip — `Pages/Index.cshtml` #values

| Attribute | Implementation |
|-----------|---------------|
| Background | `--color-surface-alt` (`#f0f7fc`) |
| Layout | Bootstrap `row row-cols-2 row-cols-md-4 g-3` |
| Each item | Icon (`svg` 32px · `--color-primary`) + `<h5>` bold + `<p>` small muted · center-aligned · `py-4` |
| Dividers | CSS `border-right` on each col (hidden on last) — use `:not(:last-child)` |

---

### Product Lines Grid — `Pages/Index.cshtml` #product-lines & `Pages/Productos`

| Attribute | Implementation |
|-----------|---------------|
| Section label | Small uppercase label `NUESTRAS SOLUCIONES 🌿` · `--color-eco` · `font-size: 0.75rem` · `letter-spacing: 0.08em` |
| Layout | Left col `col-lg-3` headline + description + "Conoce toda la línea →" link; Right `col-lg-9` scroll row of cards |
| Product card | `card border-0 shadow-card` · `border-radius: var(--radius-card)` · image top `object-fit: cover` `height: 160px` |
| Card body | `<h6>` bold navy + `<p>` small muted · `<a>` "Ver más →" · `--color-primary` · `font-weight: 600` |
| Hover | `transform: translateY(-4px)` · `box-shadow: var(--shadow-card-hover)` · `transition: var(--transition-card)` |
| Card columns | `col-6 col-md-4 col-lg` auto-fit in row, overflow-x scroll on mobile with `flex-nowrap` |

---

### Eco Banner — `Pages/Index.cshtml` #eco-commitment

| Attribute | Implementation |
|-----------|---------------|
| Background | Full-width section · `background: linear-gradient(135deg, #1a6db5 0%, #0d4a8f 100%)` with water/leaf SVG overlay pattern |
| Text | White · left col headline + body · right col 3 icon+label items (`col-lg-4 col-md-6`) |
| Icons | SVG leaf/droplet/recycle · white fill · 48px |
| CTA | `btn btn-outline-light btn-lg rounded-pill` |

---

### Retailers Carousel — `Pages/Index.cshtml` #retailers

| Attribute | Implementation |
|-----------|---------------|
| Background | `--color-surface` (white) |
| Headline | `<h2 class="text-center">` · section rhythm standard |
| Component | Swiper.js · `autoplay: { delay: 3000 }` · `loop: true` · `slidesPerView: 4` (desktop) / `2` (mobile) |
| Logo items | `img-fluid` grayscale by default · `filter: grayscale(100%) opacity(60%)` · hover: full color |

> **Note for mimascota:** replace retailer logos with pet-sector distributors or remove section if not applicable. Use distributors from `content/contact.json`.

---

### Blog / Consejos Cards — `Pages/Blog/Index.cshtml` & `Pages/Index.cshtml` #blog-preview

| Attribute | Implementation |
|-----------|---------------|
| Section header | Left-aligned `<h2>` + right-aligned `<a>` "Ver todos los artículos →" in `d-flex justify-content-between align-items-center` |
| Card layout | `col-12 col-md-6 col-lg-4` — 3-up grid |
| Card style | Background image `object-fit: cover height: 220px` with `<div class="position-relative">` overlay fade at bottom |
| Category badge | `position: absolute top-0 start-0 m-3` · `badge rounded-pill` · color from `--color-badge-*` per category |
| Title | Below image area · `<h5>` `font-weight: 700` · 2-line clamp with CSS |
| Excerpt | `<p class="text-muted small">` · 3-line clamp |
| CTA | `<a>` "Leer más →" · `--color-primary` · `font-weight: 600` |
| Hover | card `box-shadow` lift + image subtle scale `transform: scale(1.03)` on `.card-img-top` |

---

### Contact Form — `Pages/Contacto.cshtml`

| Attribute | Implementation |
|-----------|---------------|
| Layout | 2-col on desktop: form left `col-lg-7`, contact info right `col-lg-5` |
| Inputs | `form-control` · `border-radius: var(--radius-input)` · border `--color-border` · focus ring `--color-primary` |
| Reason selector | `form-select` dropdown — options: Consulta, Pedido, Distribución, PQR |
| Submit CTA | `btn btn-dark btn-lg rounded-pill w-100` or `w-auto` |
| WhatsApp CTA | `btn btn-success rounded-pill` with WhatsApp icon · prominent in right col |
| Validation | Bootstrap 5 native validation classes (`is-invalid`, `invalid-feedback`) |

---

### Footer — `Pages/Shared/_Layout.cshtml` (footer)

| Attribute | Implementation |
|-----------|---------------|
| Background | `--color-navy` (`#0d1f3c`) |
| Text | White primary · `--color-text-muted` slightly lighter for secondary |
| Layout | Bootstrap `row` — logo+tagline col `col-lg-3`; nav col `col-lg-2`; links cols `col-lg-2`; newsletter `col-lg-3` |
| Logo | White version (SVG with `fill: white`) |
| Links | `<a class="text-white-50">` · hover `text-white` · `text-decoration: none` |
| Social icons | Bootstrap icons or SVG: Facebook, Instagram, YouTube · 24px · white fill |
| Newsletter | `input-group` rounded · `form-control` + `btn btn-primary` · label "Suscríbete y recibe consejos" |
| Legal line | `border-top border-white border-opacity-10 mt-4 pt-3 text-center text-white-50 small` |

---

### Floating WhatsApp Button — `Pages/Shared/_Layout.cshtml`

```html
<!-- Rendered on every page from ContactConfig.whatsapp_number + whatsapp_message -->
<a href="https://wa.me/{number}?text={encoded_message}"
   class="btn btn-success rounded-circle shadow position-fixed"
   style="bottom:24px; right:24px; width:56px; height:56px; z-index:1050; display:flex; align-items:center; justify-content:center;"
   target="_blank" rel="noopener noreferrer" aria-label="WhatsApp">
  <svg><!-- WhatsApp SVG icon 28px white --></svg>
</a>
```

---

## Responsive Rules

| Breakpoint | Nav | Hero | Product grid | Blog grid |
|------------|-----|------|--------------|-----------|
| `< 576px` (mobile) | Hamburger; vertical menu drawer | Stacked: text first, image below · min-height: auto | `col-6` 2-up | `col-12` 1-up |
| `≥ 576px` (sm) | Hamburger | Stacked with larger image | `col-6` 2-up | `col-12` 1-up |
| `≥ 768px` (md) | Hamburger | Stacked but side-by-side begins | `col-4` 3-up | `col-6` 2-up |
| `≥ 992px` (lg) | Full horizontal nav | Side-by-side (text left, image right) | `col` auto-fit | `col-4` 3-up |
| `≥ 1200px` (xl) | Full + right-aligned CTA | Full hero height `520px` | `col` 5-up | `col-4` 3-up |

**Mobile-specific rules:**
- Hero CTA buttons: stack vertically `d-grid gap-2` on `< md`
- Product cards: horizontal scroll container `d-flex flex-nowrap overflow-x-auto gap-3` on `< md`
- Swiper carriers (retailers): `slidesPerView: 2` on mobile
- Footer: single-column stacked layout; newsletter below links
- Floating WhatsApp: reduced to `48px` circle on `< sm`

---

## Accessibility Constraints

| Rule | Requirement |
|------|-------------|
| Color contrast | All text on colored backgrounds must meet **WCAG AA 4.5:1** (body) / **3:1** (large text) |
| Focus visibility | All interactive elements: `outline: 3px solid var(--color-primary); outline-offset: 2px;` on `:focus-visible` |
| Headings | Strict hierarchy: `h1` only once per page (hero); `h2` for sections; `h3` for cards |
| Images | Every `<img>` must have `alt=""` (decorative) or descriptive `alt` text |
| Form labels | Every input must have a visible `<label>` linked by `for`/`id` |
| Motion | Wrap all AOS and CSS transitions in `@media (prefers-reduced-motion: no-preference)` |
| Buttons | WhatsApp FAB must have `aria-label="Contactar por WhatsApp"` |
| Links | "Ver más →" and "Leer más →" links must have `aria-label` including context (e.g., `aria-label="Ver más sobre Toallitas para Mascotas"`) |

---

## Internal Page Extrapolation Rules

These rules apply to pages for which no specific visual mockup was provided. Derived from homepage tokens.

### Section Rhythm Defaults

- **Page title block:** Full-width `bg-surface-alt` strip · `py-5` · `<h1>` centered or left-aligned · optional breadcrumb `<nav aria-label="breadcrumb">` below
- **Content sections:** Alternating `bg-white` / `bg-surface-alt` sections · `py-5` each · max-width container
- **CTA placement:** Every page ends with a CTA strip before footer — `bg-primary text-white` · headline + `btn btn-light rounded-pill` OR `bg-surface-alt` + contact card

### Per-Template Extrapolation

| Template | Heading style | Cards | CTA pattern |
|----------|--------------|-------|-------------|
| `catalog` (Productos) | H1 + filter nav-tabs below | `card border-0 shadow-card radius-card` — image top, body below | "Ver detalle" pill button on each card |
| `catalog-detail` (Detalle producto) | H1 left col, image right col (mirror of hero) | Swiper carousel for images; ingredient list-group | Sticky bottom CTA bar on mobile |
| `about` (Nosotros) | H1 + subtitle, then alternating text/image blocks | Team: circular avatar `100px` + name + role | eco badge + "Contactar" CTA at bottom |
| `blog-list` (Blog) | H1 + category pills filter row | 3-up blog cards (same as homepage preview) | "Suscríbete" newsletter card at bottom |
| `blog-post` (Artículo) | H1 · date · category badge · featured image full-width | Related product card · author block | Sticky share bar desktop; bottom share on mobile |
| `contact` (Contacto) | H1 + subtitle, 2-col layout | Contact info card with icon list | WhatsApp btn prominent; form submit rounded-pill |
| `about` reused for `legal` | H1 "Información Legal" + breadcrumb | Bootstrap accordion for each policy section | No primary CTA; footer visible immediately |

### Fallback Image Policy

- If a content file has no image: use SVG placeholder with brand primary color + product category icon
- Hero `background_image` not set: fall back to `--color-hero-bg` solid with brand pattern SVG
- Blog post `featured_image` missing: use category-specific placeholder (`mascotas.jpg`, `ecologia.jpg`, `bienestar.jpg`)
- Team `photo` missing: use circular SVG avatar with initials

### Navigation Continuity Rules

- **Active nav link:** Add `active` class and `aria-current="page"` via Razor `@(ViewData["Page"]?.ToString() == "X" ? "active" : "")` pattern
- **Footer:** Same markup on every page — pulled from `_Layout.cshtml`
- **WhatsApp FAB:** Present on every page — rendered in `_Layout.cshtml` from `ContactConfig`
- **Promo banner:** Shown on every page when `content/promo.json` `active: true` — above nav, dismissible

---

## Do and Do Not List

### ✅ DO

- Use Bootstrap 5 utility classes as the **first choice** for spacing, flex, grid, color, and text
- Apply pill shape (`rounded-pill`) to all CTA buttons and category badges
- Use `--color-navy` (`#0d1f3c`) for primary filled CTA buttons and headlines
- Use `--color-eco` (`#3a9d5d`) only for eco/biodegradable signals
- Wrap all motion in `prefers-reduced-motion` media query
- Use Swiper.js for all carousels (retailers, product image gallery)
- Use AOS for scroll-triggered entrance animations on hero and section entries
- Load Inter + Poppins via Google Fonts `<link>` in `<head>` — `display=swap`
- Add `data-aos` attributes in Razor templates, initialize AOS in site JS

### ❌ DO NOT

- Add custom CSS for anything Bootstrap 5 covers natively (grid, spacing, flex, colors)
- Use square-cornered buttons (all buttons are `rounded-pill`)
- Use red, pink, or purple as brand colors (reserved for error states only)
- Import jQuery (Bootstrap 5 runs vanilla JS)
- Add icon libraries beyond Bootstrap Icons SVGs (no Font Awesome unless already referenced)
- Apply heavy drop-shadows beyond `--shadow-card` and `--shadow-card-hover`
- Use `position: absolute` layout tricks where Bootstrap grid achieves the same result
- Use `!important` in any custom CSS — address specificity properly
- Store the Stitch API key or any secret in source files

---

## CSS Custom Properties File

Create `wwwroot/css/tokens.css` with:

```css
:root {
  --color-primary: #1a6db5;
  --color-primary-dark: #0d4a8f;
  --color-hero-bg: #ddeef8;
  --color-surface: #ffffff;
  --color-surface-alt: #f0f7fc;
  --color-eco: #3a9d5d;
  --color-eco-dark: #2a7444;
  --color-navy: #0d1f3c;
  --color-text-body: #2c3e50;
  --color-text-muted: #6b7c93;
  --color-border: #d0e4f0;
  --color-badge-pet: #e6f4ff;
  --color-badge-eco: #e6f5ec;
  --color-white: #ffffff;

  --font-primary: 'Inter', 'Segoe UI', system-ui, sans-serif;
  --font-display: 'Poppins', 'Inter', sans-serif;
  --font-size-hero: clamp(2rem, 5vw, 3.5rem);
  --font-size-h2: clamp(1.5rem, 3vw, 2.25rem);
  --font-size-h3: 1.25rem;
  --font-size-body: 1rem;
  --font-size-small: 0.875rem;
  --font-weight-bold: 700;
  --font-weight-semibold: 600;
  --font-weight-regular: 400;
  --line-height-display: 1.15;
  --line-height-body: 1.65;

  --section-padding-y: 80px;
  --card-gap: 24px;
  --card-padding: 20px;
  --container-max: 1200px;
  --hero-min-height: 520px;
  --nav-height: 72px;

  --radius-card: 12px;
  --radius-badge: 20px;
  --radius-btn: 50px;
  --radius-input: 8px;
  --shadow-card: 0 2px 12px rgba(13, 31, 60, 0.08);
  --shadow-card-hover: 0 6px 24px rgba(13, 31, 60, 0.14);
  --shadow-nav: 0 2px 8px rgba(13, 31, 60, 0.10);

  --transition-base: 0.2s ease;
  --transition-card: 0.3s ease;
  --aos-duration: 600ms;
  --aos-offset: 60px;
}

@media (max-width: 767.98px) {
  :root {
    --section-padding-y: 48px;
    --hero-min-height: auto;
  }
}

@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Bootstrap 5 Overrides File

Create `wwwroot/css/brand.css` (only overrides not achievable with utilities):

```css
/* Button pill override — ensures all .btn are pill by default in this project */
.btn {
  border-radius: var(--radius-btn);
  font-weight: var(--font-weight-semibold);
  transition: var(--transition-base);
}

/* Card defaults */
.card {
  border-radius: var(--radius-card);
  border: 1px solid var(--color-border);
  box-shadow: var(--shadow-card);
  transition: var(--transition-card);
}
.card:hover {
  box-shadow: var(--shadow-card-hover);
  transform: translateY(-4px);
}

/* Form controls */
.form-control,
.form-select {
  border-radius: var(--radius-input);
  border-color: var(--color-border);
}
.form-control:focus,
.form-select:focus {
  border-color: var(--color-primary);
  box-shadow: 0 0 0 0.2rem rgba(26, 109, 181, 0.25);
}

/* Eco accent badges */
.badge-eco {
  background-color: var(--color-badge-eco);
  color: var(--color-eco-dark);
  border-radius: var(--radius-badge);
}
.badge-pet {
  background-color: var(--color-badge-pet);
  color: var(--color-primary-dark);
  border-radius: var(--radius-badge);
}

/* Section label (NUESTRAS SOLUCIONES style) */
.section-label {
  font-size: 0.75rem;
  font-weight: var(--font-weight-semibold);
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--color-eco);
}

/* Link arrows */
.link-arrow {
  font-weight: var(--font-weight-semibold);
  color: var(--color-primary);
  text-decoration: none;
}
.link-arrow:hover {
  color: var(--color-primary-dark);
  text-decoration: underline;
}

/* Focus visibility (accessibility) */
:focus-visible {
  outline: 3px solid var(--color-primary);
  outline-offset: 2px;
}

/* Product card image */
.card-img-top {
  object-fit: cover;
  height: 160px;
  border-radius: var(--radius-card) var(--radius-card) 0 0;
}

/* Blog card image */
.blog-card-img {
  height: 220px;
  object-fit: cover;
  border-radius: var(--radius-card) var(--radius-card) 0 0;
  transition: transform 0.4s ease;
}
.card:hover .blog-card-img {
  transform: scale(1.03);
}

/* Text clamp utilities */
.clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Retailers grayscale logos */
.retailer-logo {
  filter: grayscale(100%) opacity(60%);
  transition: filter var(--transition-base);
  max-height: 40px;
  object-fit: contain;
}
.retailer-logo:hover {
  filter: grayscale(0%) opacity(100%);
}
```

---

## Google Fonts Link Tag

```html
<!-- In Pages/Shared/_Layout.cshtml <head> -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Poppins:wght@700&display=swap" rel="stylesheet">
```

---

## JS Dependencies (whitelist)

| Library | Version | CDN / npm | Purpose |
|---------|---------|-----------|---------|
| Bootstrap 5 | `5.3.x` | CDN or npm | UI framework (all components) |
| AOS | `2.3.4` | CDN | Scroll-triggered entrance animations |
| Swiper.js | `11.x` | CDN or npm | Carousel: product images, retailer logos |

No other JS libraries are allowed without @Architect approval.

---

## Verification Checklist

- [x] Visual input source documented (Pure Wipes homepage desktop screenshot)
- [x] Token dictionary: color, typography, spacing, radius, shadow, motion
- [x] Component map: nav, hero (Decap-editable), values strip, product grid, eco banner, retailers carousel, blog cards, contact form, footer, WhatsApp FAB
- [x] Responsive rules: mobile / tablet / desktop per component
- [x] Accessibility constraints: contrast, focus, headings, alt text, form labels, motion
- [x] Internal page extrapolation rules for all 7 routes
- [x] CSS token file spec (`wwwroot/css/tokens.css`)
- [x] CSS override file spec (`wwwroot/css/brand.css`)
- [x] Do / Do Not list
- [x] Google Fonts link tag
- [x] JS dependency whitelist
