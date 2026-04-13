# DESIGN_STYLE_CONTRACT-purewide3.md
**Project:** Pure Wipe 3.0  
**Source:** Stitch with Google — Project "Remix of Pure Wipes Home Page" (ID: 5053646075436783644) · Screen: Pure Wipes Home Page (ID: e3bd25bfcdad46a4bd0a0b6ff75d74c0)  
**Additional source:** Homepage screenshot provided by operator  
**Strictness:** close-match  
**Date locked:** 2026-04-13  
**Skill:** `look-and-feel-ingestion`

---

## Source References

| Type | Reference |
|------|-----------|
| Stitch project | Remix of Pure Wipes Home Page — ID 5053646075436783644 |
| Stitch screen | Pure Wipes Home Page — ID e3bd25bfcdad46a4bd0a0b6ff75d74c0 |
| Screenshot | Homepage desktop — provided in chat session |

---

## Token Dictionary

### Color Palette

| Token | Value | Usage |
|-------|-------|-------|
| `--color-primary` | `#0a4f8c` | Primary buttons, CTA, active nav, brand accent |
| `--color-primary-dark` | `#073a6b` | Button hover, header active state |
| `--color-primary-light` | `#e8f4fb` | Section backgrounds, feature strip |
| `--color-secondary` | `#59a96a` | Eco/biodegradable accents, leaf icons, sustainability section |
| `--color-secondary-light` | `#e8f5ec` | Sustainability badge backgrounds |
| `--color-neutral-50` | `#fafafa` | Alternating section backgrounds |
| `--color-neutral-100` | `#f5f5f5` | Cards, feature item backgrounds |
| `--color-neutral-800` | `#1a1a2e` | Body text, headings |
| `--color-neutral-600` | `#555566` | Secondary text, descriptions |
| `--color-white` | `#ffffff` | Backgrounds, card surfaces |
| `--color-footer-bg` | `#0d1b2a` | Footer dark navy background |
| `--color-footer-text` | `#b0bec5` | Footer secondary text |
| `--color-hero-bg-start` | `#ddf0fb` | Hero section gradient start (light blue) |
| `--color-hero-bg-end` | `#f0faff` | Hero section gradient end (near white) |
| `--color-water-banner` | `#1a7abf` | Sustainability water banner background |

### Typography Scale

| Token | Value | Usage |
|-------|-------|-------|
| `--font-heading` | `'Montserrat', sans-serif` | All headings (h1–h4), eyebrow labels, brand name |
| `--font-body` | `'Inter', sans-serif` | Body text, descriptions, nav links, footers |
| `--font-size-hero` | `clamp(2.2rem, 5vw, 3.8rem)` | Hero h1 headline |
| `--font-size-h2` | `clamp(1.6rem, 3vw, 2.4rem)` | Section titles |
| `--font-size-h3` | `1.25rem` | Card titles, feature titles |
| `--font-size-body` | `1rem` | Default paragraph text |
| `--font-size-small` | `0.875rem` | Captions, footer secondary text |
| `--font-size-eyebrow` | `0.75rem` | Section eyebrow labels (uppercase tracked) |
| `--font-weight-regular` | `400` | Body text |
| `--font-weight-semibold` | `600` | Nav links, card descriptions |
| `--font-weight-bold` | `700` | Headings, button text |
| `--font-weight-extrabold` | `800` | Hero h1 |
| `--line-height-tight` | `1.15` | Headings |
| `--line-height-normal` | `1.6` | Body text |

### Spacing Scale

| Token | Value | Usage |
|-------|-------|-------|
| `--space-xs` | `0.5rem` | Icon padding, tight gaps |
| `--space-sm` | `1rem` | Default inner padding |
| `--space-md` | `1.5rem` | Card padding, section inner gap |
| `--space-lg` | `3rem` | Section top/bottom padding (mobile) |
| `--space-xl` | `5rem` | Section top/bottom padding (desktop) |
| `--space-xxl` | `8rem` | Hero section padding |

### Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | `0.375rem` | Buttons, badges, pills |
| `--radius-md` | `0.75rem` | Cards, feature items |
| `--radius-lg` | `1.25rem` | Hero product cards, product cards |
| `--radius-full` | `9999px` | Retailer pills, tags, circular badges |

### Elevation / Shadows

| Token | Value | Usage |
|-------|-------|-------|
| `--shadow-card` | `0 2px 16px rgba(10,79,140,0.08)` | Default card shadow |
| `--shadow-card-hover` | `0 6px 24px rgba(10,79,140,0.16)` | Card hover state |
| `--shadow-nav` | `0 2px 8px rgba(0,0,0,0.06)` | Sticky nav shadow |
| `--shadow-hero-seal` | `0 4px 20px rgba(0,0,0,0.12)` | Biodegradable seal badge |

### Motion Rules

| Token | Value | Usage |
|-------|-------|-------|
| `--transition-fast` | `150ms ease-in-out` | Button hover, link hover |
| `--transition-normal` | `250ms ease-in-out` | Card hover, nav dropdown |
| `--transition-slow` | `400ms ease-out` | Section fade-in (AOS) |
| `prefers-reduced-motion` | `no transitions` | Respect OS accessibility setting |

---

## Component Style Map

### Header / Navigation
- White background, sticky on scroll with `--shadow-nav`
- Brand: SVG/emoji mark + `Montserrat Bold` brand name + `Inter` small tagline below
- Nav links: `Inter 600`, `--color-neutral-800`, hover `--color-primary`, active underline accent
- Dropdown: white surface, `--radius-md`, `--shadow-card`, products sub-menu
- CTA button: `--color-primary` pill (`--radius-full`), "¿Dónde encontrar?" with pin icon
- Mobile: hamburger toggle, full-width collapse drawer

### Hero / Banner
- Background: linear gradient `--color-hero-bg-start → --color-hero-bg-end`, water/bubble SVG decorations
- Left column: headline `clamp hero-title`, tagline `Inter 1rem --color-neutral-600`, body copy, two CTAs
- Primary CTA: `--color-primary` filled, `--radius-sm`, arrow icon
- Secondary CTA: outline variant, leaf icon `--color-secondary`
- Right column: floating product showcase cards (4 products) + circular "Biodegradable" badge (top-right)
- Product mini-cards: white surface, `--radius-lg`, `--shadow-card`

### Features Strip
- 4-column grid (2×2 on mobile), white background with light blue tint
- Each item: circular icon container `--color-primary-light`, icon `--color-primary`, `h3 Montserrat Bold`, `p Inter`
- No card border — icon + text only, centered alignment

### Product Lines / Solutions Grid
- Left: "NUESTRAS SOLUCIONES" eyebrow + h2 + paragraph + "Conoce toda la línea" text link
- Right: 5-card horizontal scroll grid on mobile, 5-column on desktop
- Cards: product image (square, `object-fit: cover`), category label, "Ver más →" text link
- Card surface: white, `--radius-md`, subtle border `1px solid rgba(0,0,0,0.06)`, hover `--shadow-card-hover`

### Sustainability Banner (Water Banner)
- Full-width section, `--color-water-banner` background, organic water/wave shape
- Text: eyebrow white italic, h2 white bold, 3 icon+text sustainability pillars
- Floating leaf image right side (desktop only)
- SVG icons: custom stroke-only paths, white color

### Retailers Section
- White background, centered title `h3 Montserrat`
- Retailer pills: `--radius-full`, border `2px solid --color-primary`, `--color-primary` text, bold
- Horizontally scrollable row on mobile; centered flex wrap on desktop

### Blog Preview
- Section intro: h2 left + "Ver todos los artículos →" link right
- 3-column card grid (1 on mobile, 2 tablet, 3 desktop)
- Cards: image top (16:9, `object-fit: cover`), category tag overlay (top-left, colored pill), title h3, excerpt p, "Leer más →"
- Card surface: white, `--radius-md`, `--shadow-card`

### Footer
- Background: `--color-footer-bg` dark navy
- 4 columns: brand+tagline+social / Explorar links / Categorías / newsletter form
- Social icons: circular `--color-primary` background, white icon, 32px
- Links: `--color-footer-text`, hover `--color-white`
- Newsletter: input + "Suscribirse" button (same row), `--color-primary` button
- Copyright: centered, small, `--color-footer-text`

---

## Responsive Rules

### Mobile (< 576px)
- Hero: single column, product showcase hidden or shown as 2-column grid below copy
- Features: 2×2 grid
- Products grid: horizontal scroll, 2 visible cards
- Blog: single column
- Footer: single column stack

### Tablet (≥ 576px, < 992px)
- Hero: two columns, reduced image size
- Features: 4 columns
- Products: 3 cards visible
- Blog: 2-column grid
- Footer: 2×2 grid

### Desktop (≥ 992px)
- Hero: 55/45 split
- Products: all 5 cards in row
- Blog: 3 columns
- Footer: 4 columns

---

## Accessibility Constraints

| Check | Requirement |
|-------|-------------|
| Color contrast | All text on backgrounds ≥ 4.5:1 (WCAG AA) |
| Focus visible | `:focus-visible` ring `2px solid --color-primary` on all interactive elements |
| Heading hierarchy | h1 → hero only; h2 → section titles; h3 → card titles |
| Image alt text | All `<img>` elements must have descriptive `alt=""` |
| ARIA labels | Hamburger button, social links, newsletter form must have `aria-label` |
| Reduced motion | All CSS transitions and AOS animations must respect `prefers-reduced-motion: reduce` |

---

## Do and Do Not

### ✅ Do
- Use Bootstrap 5 grid utilities for layout
- Use `Montserrat` for all headings
- Use CSS custom properties from this token dictionary
- Apply `--shadow-card-hover` on card `:hover` via CSS transition
- Use `--radius-full` for pill/tag elements
- Keep the green (`--color-secondary`) exclusively for eco/sustainability signals

### ❌ Do Not
- Do not use custom CSS for spacing or layout components Bootstrap 5 covers
- Do not use any color outside this token dictionary without @Orchestrator approval
- Do not use `Arial` or `sans-serif` directly — always reference `--font-heading` or `--font-body`
- Do not add third-party CSS frameworks (no Tailwind, no Bulma)
- Do not use `background-color: black` — use `--color-footer-bg` for dark surfaces
- Do not place any JS bundles beyond Bootstrap 5, Swiper.js, and AOS (whitelisted)
