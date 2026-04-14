#!/usr/bin/env bash
# =============================================================================
# WFO · github-project-bootstrap · mimascota
# =============================================================================
# Usage:
#   GH_TOKEN=<your_pat> bash scripts/bootstrap-github-mimascota.sh
#
# Requirements:
#   - gh CLI ≥ 2.30 (https://cli.github.com/)
#   - jq
#
# What this script does:
#   1. Creates private GitHub repository: mimascota-web
#   2. Creates all WFO labels
#   3. Creates GitHub Issues from the Task Registry
#   4. Creates GitHub Project board "WFO — mimascota"
#   5. Adds all issues to the board with Status/Phase/Priority fields
#   6. Outputs a summary for the operator to copy into PROJECT_ROADMAP-mimascota.md
#
# ⚠️  DO NOT commit GH_TOKEN or any PAT into source files.
# =============================================================================

set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────
OWNER="carlosperez1986"
REPO="mimascota-web"
PROJECT_NAME="WFO — mimascota"
ROADMAP_REF="PROJECT_ROADMAP-mimascota.md"
SPEC_REF="IMPLEMENTATION_SPEC-mimascota.md"

if [[ -z "${GH_TOKEN:-}" ]]; then
  echo "❌  GH_TOKEN is not set. Run: GH_TOKEN=<your_pat> bash $0"
  exit 1
fi

export GH_TOKEN

echo "=============================="
echo " WFO github-project-bootstrap"
echo " Project: mimascota"
echo "=============================="

# ─── Step 1: Create repository ───────────────────────────────────────────────
echo ""
echo "▶ Step 1 — Creating repository ${OWNER}/${REPO} (private)..."
gh repo create "${OWNER}/${REPO}" \
  --private \
  --description "Mi Mascota · Sitio web corporativo · Oclara Group" \
  --homepage "https://mimascota.oclara.com" \
  2>&1 || echo "  (repo may already exist — continuing)"

REPO_URL="https://github.com/${OWNER}/${REPO}"
echo "  ✅  Repository: ${REPO_URL}"

# ─── Step 2: Create labels ───────────────────────────────────────────────────
echo ""
echo "▶ Step 2 — Creating labels..."

create_label() {
  local name="$1" color="$2" description="$3"
  gh label create "$name" \
    --color "$color" \
    --description "$description" \
    --repo "${OWNER}/${REPO}" \
    --force 2>/dev/null || true
  echo "  label: ${name}"
}

create_label "phase:define"    "0052CC" "Phase 1 — Define"
create_label "phase:build"     "0075CA" "Phase 2 — Build"
create_label "phase:deploy"    "006B75" "Phase 3 — Deploy"
create_label "owner:architect" "E4E669" "Owner: @Architect"
create_label "owner:developer" "D4C5F9" "Owner: @Developer"
create_label "owner:frontend"  "BFD4F2" "Owner: @Frontend"
create_label "owner:auditor"   "F9D0C4" "Owner: @Auditor"
create_label "owner:devops"    "C2E0C6" "Owner: @DevOps"
create_label "type:task"       "EDEDED" "Type: Task"
create_label "type:bug"        "D73A4A" "Type: Bug"
create_label "type:risk"       "E4E669" "Type: Risk / Decision"
create_label "priority:high"   "B60205" "Priority: High"
create_label "priority:medium" "FBCA04" "Priority: Medium"
create_label "priority:low"    "0E8A16" "Priority: Low"

echo "  ✅  Labels created"

# ─── Step 3: Create issues ───────────────────────────────────────────────────
echo ""
echo "▶ Step 3 — Creating GitHub Issues from Task Registry..."

# Helper function
create_issue() {
  local title="$1" body="$2" labels="$3"
  local number
  number=$(gh issue create \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --repo "${OWNER}/${REPO}" \
    2>/dev/null | grep -oE '[0-9]+$' || echo "?")
  echo "  #${number}: ${title}"
  echo "$number"
}

# ── Phase 1 issues (Define) ──────────────────────────────────────────────────

ISSUE_IDS=()

N=$(gh issue create \
  --title "[Define] Razor Page spec: Inicio (/) + Hero Banner schema" \
  --body "## Summary
TASK-001 from ${ROADMAP_REF}

## Scope
Define the Razor Page specification for the Inicio route (\`/\`) including the Hero Banner Decap-editable schema. The hero content is stored in \`content/hero.json\` with fields: \`title\`, \`subtitle\`, \`cta_primary_text\`, \`cta_primary_url\`, \`cta_secondary_text\`, \`cta_secondary_url\`, \`background_image\`.

## Acceptance Criteria
- [ ] \`evidence/spec-inicio.md\` exists and documents component list for homepage
- [ ] Hero Banner JSON schema is defined and matches \`content/hero.json\` fields
- [ ] All field types, default values, and Decap widget types are specified

## Dependencies
None — first Phase 1 task

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-001
- Spec: \`${SPEC_REF}\`" \
  --label "phase:define,owner:architect,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Inicio spec + Hero Banner schema"

N=$(gh issue create \
  --title "[Define] Razor Page spec: Productos (/productos) — catalog grid" \
  --body "## Summary
TASK-002 from ${ROADMAP_REF}

## Scope
Define the spec for \`/productos\` (catalog grid) and \`/productos/{slug}\` (detail page). Include product lines: Mascotas (Perros y Gatos), Adultos Mayores, Ecológica, Multiuso Hogar. Define content model fields per product.

## Acceptance Criteria
- [ ] \`evidence/spec-productos.md\` exists
- [ ] Catalog grid component and filter nav defined
- [ ] Product detail page spec (image gallery, ingredients, certifications) documented

## Dependencies
TASK-001 must be complete

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-002" \
  --label "phase:define,owner:architect,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Productos spec"

N=$(gh issue create \
  --title "[Define] Razor Page spec: Galería (/galeria) — Instagram feed + UGC" \
  --body "## Summary
TASK-003 from ${ROADMAP_REF}

## Scope
Define spec for \`/galeria\` including Instagram API integration, UGC grid, and Reels section.

## Acceptance Criteria
- [ ] \`evidence/spec-galeria.md\` exists
- [ ] Instagram API integration approach documented (Basic Display API or oEmbed fallback)
- [ ] UGC grid and Reels section layout defined

## Dependencies
TASK-001

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-003" \
  --label "phase:define,owner:architect,type:task,priority:medium" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Galería spec"

N=$(gh issue create \
  --title "[Define] Razor Page spec: Nosotros (/nosotros)" \
  --body "## Summary
TASK-004 from ${ROADMAP_REF}

## Scope
Define spec for \`/nosotros\`: Historia, Misión/Visión/Valores, Equipo (team cards), Compromiso Ecológico section.

## Acceptance Criteria
- [ ] \`evidence/spec-nosotros.md\` exists
- [ ] Team card content model defined
- [ ] Eco-commitment section layout documented

## Dependencies
TASK-001

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-004" \
  --label "phase:define,owner:architect,type:task,priority:medium" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Nosotros spec"

N=$(gh issue create \
  --title "[Define] Razor Page spec: Blog (/blog) — article list + SEO structure" \
  --body "## Summary
TASK-005 from ${ROADMAP_REF}

## Scope
Define spec for \`/blog\` (article list, category filter) and \`/blog/{slug}\` (article detail). Define Markdown front-matter schema for blog posts.

## Acceptance Criteria
- [ ] \`evidence/spec-blog.md\` exists
- [ ] Front-matter schema defined (title, date, category, author, featured_image, excerpt)
- [ ] SEO structure (canonical, OG tags, Schema.org Article) documented

## Dependencies
TASK-001

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-005" \
  --label "phase:define,owner:architect,type:task,priority:medium" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Blog spec"

N=$(gh issue create \
  --title "[Define] Razor Page spec: Contacto (/contacto) — form + distributors" \
  --body "## Summary
TASK-006 from ${ROADMAP_REF}

## Scope
Define spec for \`/contacto\`: contact form (Nombre, correo, asunto, motivo selector, mensaje), WhatsApp CTA, distributor points map/list. Define \`ContactConfig\` JSON schema.

## Acceptance Criteria
- [ ] \`evidence/spec-contacto.md\` exists
- [ ] Form fields and validation rules documented
- [ ] WhatsApp Business number integration documented
- [ ] \`content/contact.json\` schema defined

## Dependencies
TASK-001

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-006" \
  --label "phase:define,owner:architect,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Contacto spec"

N=$(gh issue create \
  --title "[Define] Razor Page spec: Legal (/legal)" \
  --body "## Summary
TASK-007 from ${ROADMAP_REF}

## Scope
Define spec for \`/legal\`: Términos y Condiciones, Política de Privacidad (Ley 1581/2012), Política de Devolución. Use Bootstrap accordion pattern.

## Acceptance Criteria
- [ ] \`evidence/spec-legal.md\` exists
- [ ] Legal section structure documented (3 accordion sections minimum)
- [ ] Content stored in \`content/legal.json\` with markdown body fields

## Dependencies
TASK-001

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-007" \
  --label "phase:define,owner:architect,type:task,priority:low" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Legal spec"

N=$(gh issue create \
  --title "[Define] Hero Banner content model for Decap (content/hero.json)" \
  --body "## Summary
TASK-008 from ${ROADMAP_REF}

## Scope
Define and create the initial \`content/hero.json\` seed file and document its schema for Decap CMS. Fields: \`title\`, \`subtitle\`, \`cta_primary_text\`, \`cta_primary_url\`, \`cta_secondary_text\`, \`cta_secondary_url\`, \`background_image\`.

## Acceptance Criteria
- [ ] \`evidence/spec-hero-banner.md\` exists
- [ ] Initial seed file \`content/hero.json\` created in repository
- [ ] All field types and constraints documented

## Dependencies
TASK-001

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-008" \
  --label "phase:define,owner:architect,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Hero Banner content model"

N=$(gh issue create \
  --title "[Define] C# content models for all approved pages" \
  --body "## Summary
TASK-010 from ${ROADMAP_REF}

## Scope
Define all C# model classes: \`HeroBanner\`, \`Product\`, \`BlogPost\`, \`TeamMember\`, \`ContactConfig\`, \`GalleryItem\`, \`LegalSection\`. Each model must map 1:1 to its JSON/MD content file.

## Acceptance Criteria
- [ ] \`evidence/models-review.md\` exists documenting all models
- [ ] All models have correct property types matching JSON/MD schema
- [ ] ContentService method signatures defined (not implemented yet)

## Dependencies
TASK-001 through TASK-008

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-010
- Spec: \`${SPEC_REF}\` § C# Models" \
  --label "phase:define,owner:architect,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] C# content models"

N=$(gh issue create \
  --title "[Define] Decap CMS collection schema (config.yml) incl. hero-banner collection" \
  --body "## Summary
TASK-011 from ${ROADMAP_REF}

## Scope
Author \`wwwroot/admin/config.yml\` with collections for: hero-banner (singleton), products, blog-posts, gallery, team, contact, legal. Include widget definitions for all fields.

## Acceptance Criteria
- [ ] \`wwwroot/admin/config.yml\` exists in repository
- [ ] All collections defined with correct widget types
- [ ] Hero-banner collection is a singleton file (\`content/hero.json\`)
- [ ] Decap CMS can load the config without errors

## Dependencies
TASK-010

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-011" \
  --label "phase:define,owner:architect,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Define] Decap config.yml"

# ── Phase 2 issues (Build) ───────────────────────────────────────────────────

N=$(gh issue create \
  --title "[Build] Scaffold .NET 9 project from blueprint" \
  --body "## Summary
TASK-020 from ${ROADMAP_REF}

## Scope
Initialize .NET 9 Razor Pages project using WFO blueprint. Configure \`Program.cs\`, \`appsettings.json\`, wwwroot structure, Bootstrap 5 + AOS + Swiper.js references, \`tokens.css\` and \`brand.css\` from DESIGN_STYLE_CONTRACT-mimascota.md.

## Acceptance Criteria
- [ ] \`Program.cs\` exists and project builds successfully (\`dotnet build\`)
- [ ] \`wwwroot/css/tokens.css\` and \`wwwroot/css/brand.css\` created
- [ ] Google Fonts (Inter + Poppins) loaded in \`_Layout.cshtml\`
- [ ] \`wwwroot/admin/\` directory present
- [ ] README.md with local dev instructions

## Dependencies
TASK-011 (defines config.yml)

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-020
- Design: \`DESIGN_STYLE_CONTRACT-mimascota.md\`" \
  --label "phase:build,owner:developer,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Scaffold .NET 9 project"

N=$(gh issue create \
  --title "[Build] Implement ContentService (reads content/*.json and content/*.md)" \
  --body "## Summary
TASK-021 from ${ROADMAP_REF}

## Scope
Implement \`Services/ContentService.cs\` with methods: \`GetHeroBannerAsync()\`, \`GetProductsAsync()\`, \`GetProductAsync(slug)\`, \`GetBlogPostsAsync()\`, \`GetBlogPostAsync(slug)\`, \`GetGalleryItemsAsync()\`, \`GetTeamAsync()\`, \`GetContactConfigAsync()\`, \`GetLegalSectionsAsync()\`. Register as \`Scoped\` in \`Program.cs\`.

## Acceptance Criteria
- [ ] \`Services/ContentService.cs\` exists
- [ ] All methods return typed models (no dynamic/JObject)
- [ ] JSON deserialization uses \`System.Text.Json\`
- [ ] Markdown body fields parsed with Markdig
- [ ] Unit test or smoke evidence in \`evidence/content-service-smoke.md\`

## Dependencies
TASK-020

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-021
- Spec: \`${SPEC_REF}\` § ContentService" \
  --label "phase:build,owner:developer,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Implement ContentService"

N=$(gh issue create \
  --title "[Build] Implement contact form handler (anti-spam + email dispatch)" \
  --body "## Summary
TASK-022 from ${ROADMAP_REF}

## Scope
Implement POST handler on \`/contacto\` using Bootstrap 5 validation. Anti-spam: honeypot field + rate limiting. Email dispatch via SMTP (configurable in \`appsettings.json\`). Fields: Nombre, Correo, Asunto, Motivo (selector), Mensaje.

## Acceptance Criteria
- [ ] POST handler implemented in \`Pages/Contacto.cshtml.cs\`
- [ ] Honeypot field present (hidden, validated server-side)
- [ ] Form validates client-side (Bootstrap 5) and server-side (DataAnnotations)
- [ ] \`evidence/form-handler-smoke.md\` documents test results

## Dependencies
TASK-020, TASK-021

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-022" \
  --label "phase:build,owner:developer,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Contact form handler"

N=$(gh issue create \
  --title "[Build] Implement SEO pack (Schema.org + AIO meta tags + sitemap.xml)" \
  --body "## Summary
TASK-023 from ${ROADMAP_REF}

## Scope
Implement SEO infrastructure: Schema.org structured data (WebSite, Organization, Product, Article), Open Graph + Twitter Card meta tags per page, canonical URLs, \`sitemap.xml\` generation endpoint, \`robots.txt\`.

## Acceptance Criteria
- [ ] Each Razor Page sets \`ViewData[\"Title\"]\`, \`ViewData[\"Description\"]\`, \`ViewData[\"Canonical\"]\`
- [ ] \`_Layout.cshtml\` renders OG + TC + canonical from ViewData
- [ ] Schema.org JSON-LD rendered per template type
- [ ] \`/sitemap.xml\` returns valid XML
- [ ] \`evidence/seo-audit-pass.md\` documents Lighthouse SEO ≥ 90

## Dependencies
TASK-021 (content data needed for structured data)

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-023" \
  --label "phase:build,owner:developer,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] SEO pack"

N=$(gh issue create \
  --title "[Build] Implement decap-hero-banner — wire content/hero.json → Index.cshtml" \
  --body "## Summary
TASK-024 from ${ROADMAP_REF}

## Scope
Wire \`content/hero.json\` → \`HeroBanner\` model → \`Index.cshtml\` hero section. ContentService provides \`GetHeroBannerAsync()\`. Hero section renders: H1 (title), subtitle, two CTA pill buttons, background image via CSS var, eco badge. Style follows DESIGN_STYLE_CONTRACT-mimascota.md hero spec.

## Acceptance Criteria
- [ ] \`content/hero.json\` exists with seed data
- [ ] \`Pages/Index.cshtml\` renders all 7 hero fields from JSON
- [ ] Background image applied as CSS \`background-image\` when set
- [ ] Decap CMS \`hero-banner\` collection edits the file and changes are reflected on reload
- [ ] AOS \`data-aos=\"fade-right\"\` on text block, \`data-aos=\"fade-left\"\` on image block

## Dependencies
TASK-020, TASK-021

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-024
- Design: \`DESIGN_STYLE_CONTRACT-mimascota.md\` § Hero/Banner" \
  --label "phase:build,owner:frontend,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Hero Banner wire-up"

N=$(gh issue create \
  --title "[Build] Assemble UI: Inicio — hero, product highlights, values strip, blog preview" \
  --body "## Summary
TASK-025 from ${ROADMAP_REF}

## Scope
Assemble complete \`Pages/Index.cshtml\`: Hero section (TASK-024), Values strip (4-col icon grid), Product highlights (5-card scroll row), Eco commitment banner, Retailers Swiper carousel, Blog preview (3 cards). All sections use design tokens from \`tokens.css\` and Bootstrap 5 utilities.

## Acceptance Criteria
- [ ] \`Pages/Index.cshtml\` renders all 6 homepage sections
- [ ] AOS scroll animations on section entries
- [ ] Swiper.js carousel working for retailers
- [ ] Fully responsive (mobile/tablet/desktop per DESIGN_STYLE_CONTRACT)
- [ ] Lighthouse performance ≥ 85, accessibility ≥ 90

## Dependencies
TASK-024 (hero), TASK-021 (content service)

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-025
- Design: \`DESIGN_STYLE_CONTRACT-mimascota.md\`" \
  --label "phase:build,owner:frontend,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Inicio UI assembly"

N=$(gh issue create \
  --title "[Build] Assemble UI: Productos — catalog grid + product detail page" \
  --body "## Summary
TASK-026 from ${ROADMAP_REF}

## Scope
Assemble \`Pages/Productos/Index.cshtml\` (product grid with category filter tabs) and \`Pages/Productos/Detail.cshtml\` (product detail: image Swiper, description, ingredients accordion, certifications badges). Wire to ContentService.

## Acceptance Criteria
- [ ] \`Pages/Productos/Index.cshtml\` renders product grid
- [ ] Category filter (Mascotas, Adultos, Ecológica, Hogar) works client-side
- [ ] \`Pages/Productos/Detail.cshtml\` renders full product detail
- [ ] Image Swiper gallery functional on detail page
- [ ] SEO: canonical + Schema.org Product per detail page

## Dependencies
TASK-021, TASK-023, TASK-025

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-026" \
  --label "phase:build,owner:frontend,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Productos UI"

N=$(gh issue create \
  --title "[Build] Assemble UI: Galería — Instagram feed grid + UGC + Reels" \
  --body "## Summary
TASK-027 from ${ROADMAP_REF}

## Scope
Assemble \`Pages/Galeria/Index.cshtml\`. Integrate Instagram Basic Display API or oEmbed fallback (defined in TASK-003). UGC grid (3-up masonry Bootstrap), Reels section with embed iframes. Fallback to static \`content/gallery.json\` if API is unavailable.

## Acceptance Criteria
- [ ] \`Pages/Galeria/Index.cshtml\` renders gallery content
- [ ] Instagram API integration working OR static fallback content renders
- [ ] Reels section present with at least 1 embed placeholder
- [ ] Responsive grid validated on mobile

## Dependencies
TASK-021, TASK-025

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-027" \
  --label "phase:build,owner:frontend,type:task,priority:medium" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Galería UI"

N=$(gh issue create \
  --title "[Build] Assemble UI: Nosotros, Blog, Contacto, Legal" \
  --body "## Summary
TASK-028 from ${ROADMAP_REF}

## Scope
Assemble 4 pages:
- \`Pages/Nosotros.cshtml\`: Historia, Misión/Visión, team cards, eco section
- \`Pages/Blog/Index.cshtml\` + \`Pages/Blog/Post.cshtml\`: article list with category pills, blog post detail
- \`Pages/Contacto.cshtml\`: 2-col layout, contact form (TASK-022), WhatsApp CTA, distributor info
- \`Pages/Legal.cshtml\`: accordion sections for 3 legal policy blocks

## Acceptance Criteria
- [ ] All 4 pages exist and render without errors
- [ ] Blog article detail renders Markdown body correctly
- [ ] Contact form is wired to POST handler (TASK-022)
- [ ] Legal accordion functional on mobile

## Dependencies
TASK-021, TASK-022, TASK-025

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-028" \
  --label "phase:build,owner:frontend,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Nosotros + Blog + Contacto + Legal UI"

N=$(gh issue create \
  --title "[Build] Global components: Header, Footer, WhatsApp FAB, promo banner" \
  --body "## Summary
TASK-029 from ${ROADMAP_REF}

## Scope
Implement \`Pages/Shared/_Layout.cshtml\` global components:
- Sticky nav with active link highlighting, hamburger collapse on mobile
- Footer: 4-col layout (logo, nav, links, newsletter), social icons, legal line
- Floating WhatsApp button (56px circle, fixed bottom-right, from ContactConfig)
- Promo banner: dismissible top strip when \`content/promo.json active: true\`

## Acceptance Criteria
- [ ] \`Pages/Shared/_Layout.cshtml\` renders all 4 components
- [ ] Active nav link detection working on all routes
- [ ] WhatsApp FAB visible on all pages, links to correct number
- [ ] Promo banner dismisses via localStorage key
- [ ] WCAG AA contrast on nav and footer validated

## Dependencies
TASK-020, TASK-021

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-029
- Design: \`DESIGN_STYLE_CONTRACT-mimascota.md\` § Nav + Footer + WhatsApp FAB" \
  --label "phase:build,owner:frontend,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Build] Global components"

# ── Phase 3 issues (Deploy) ──────────────────────────────────────────────────

N=$(gh issue create \
  --title "[Deploy] Security audit — secrets, dependency scan, auth surface" \
  --body "## Summary
TASK-030/031/032 from ${ROADMAP_REF}

## Scope
Full security audit by @Auditor:
- TASK-030: Secrets scan (no PATs/keys in source), dependency vulnerability scan
- TASK-031: Auth/OAuth surface review (Decap GitHub OAuth configuration)
- TASK-032: Deploy hardening review (Nginx headers, HTTPS, CSP, HSTS)

## Acceptance Criteria
- [ ] \`evidence/security-audit-report.md\` written by @Auditor
- [ ] No Critical or High findings unresolved
- [ ] All Medium findings documented with mitigation plan
- [ ] \`[✅ GO] security-audit\` signal added to \`${ROADMAP_REF}\`

## Dependencies
TASK-020 through TASK-029 complete

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-030/031/032" \
  --label "phase:deploy,owner:auditor,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Deploy] Security audit"

N=$(gh issue create \
  --title "[Deploy] VPS provisioning — Nginx + Systemd + HTTPS configuration" \
  --body "## Summary
TASK-040 from ${ROADMAP_REF}

## Scope
Provision production environment on Debian 11 VPS:
- Nginx reverse proxy config with PATH_BASE support
- Systemd service unit for .NET 9 Kestrel process
- Let's Encrypt HTTPS certificate (certbot)
- Security headers (HSTS, CSP, X-Frame-Options, X-Content-Type-Options)

## Acceptance Criteria
- [ ] \`evidence/nginx-syntax.log\` documents \`nginx -t\` passing
- [ ] Site accessible via HTTPS on staging URL
- [ ] HTTP → HTTPS redirect working
- [ ] Security headers verified via securityheaders.com

## Dependencies
TASK-030/031/032 (security audit GO signal)

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-040
- Blueprint: \`blueprints/infra/\`" \
  --label "phase:deploy,owner:devops,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Deploy] VPS provisioning"

N=$(gh issue create \
  --title "[Deploy] CI/CD GitHub Actions workflow (build → publish → deploy)" \
  --body "## Summary
TASK-041 from ${ROADMAP_REF}

## Scope
Create \`.github/workflows/deploy.yml\`:
- Trigger: push to \`main\`
- Steps: checkout → dotnet restore → dotnet build → dotnet publish → rsync to VPS via SSH
- Secrets: \`VPS_HOST\`, \`VPS_USER\`, \`VPS_SSH_KEY\`, \`SMTP_PASSWORD\`
- Deploy notification on success/failure

## Acceptance Criteria
- [ ] \`.github/workflows/deploy.yml\` exists
- [ ] Workflow runs green on push to main
- [ ] No secrets in workflow file (all via GitHub Secrets)
- [ ] Deploy artifact verified on VPS post-run

## Dependencies
TASK-040

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-041
- Blueprint: \`blueprints/infra/github-actions-deploy.yml\`" \
  --label "phase:deploy,owner:devops,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Deploy] CI/CD workflow"

N=$(gh issue create \
  --title "[Deploy] Staging deploy + client review smoke test" \
  --body "## Summary
TASK-042 from ${ROADMAP_REF}

## Scope
Deploy to staging URL, share with client (Aron Levy / Oclara Group) for review. Run smoke tests: all 7 routes return 200, contact form sends test email, Decap CMS accessible at /admin/, hero banner editable and changes reflected.

## Acceptance Criteria
- [ ] Staging URL live and accessible
- [ ] All 7 routes return HTTP 200
- [ ] Contact form delivers test email
- [ ] Decap CMS login and hero edit verified
- [ ] \`evidence/staging-smoke.md\` documents test results
- [ ] Client review confirmed (email/message from Aron Levy)

## Dependencies
TASK-041

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-042" \
  --label "phase:deploy,owner:devops,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Deploy] Staging smoke test"

N=$(gh issue create \
  --title "[Deploy] Final production deploy + post-deploy verification" \
  --body "## Summary
TASK-043 from ${ROADMAP_REF}

## Scope
Deploy to production URL after client sign-off and final payment confirmation. Run post-deploy checklist: DNS propagation, HTTPS certificate, all routes, Lighthouse final scores (Performance ≥ 85, SEO ≥ 90, Accessibility ≥ 90, Best Practices ≥ 90).

## Acceptance Criteria
- [ ] Production URL live on HTTPS
- [ ] DNS A record pointing to VPS
- [ ] Lighthouse scores meet targets
- [ ] \`evidence/prod-deploy.md\` documents all final checks
- [ ] Client final payment confirmed
- [ ] \`[✅ GO] production\` signal added to roadmap

## Dependencies
TASK-042 + client final payment

## References
- Roadmap: \`${ROADMAP_REF}\` TASK-043" \
  --label "phase:deploy,owner:devops,type:task,priority:high" \
  --repo "${OWNER}/${REPO}" 2>/dev/null | grep -oE '[0-9]+$')
ISSUE_IDS+=("$N")
echo "  #${N}: [Deploy] Production deploy"

echo ""
echo "✅  All ${#ISSUE_IDS[@]} issues created"
echo "   Issue numbers: ${ISSUE_IDS[*]}"

# ─── Step 4: Create GitHub Project board ─────────────────────────────────────
echo ""
echo "▶ Step 4 — Creating GitHub Project board: '${PROJECT_NAME}'..."

PROJECT_URL=$(gh project create \
  --owner "${OWNER}" \
  --title "${PROJECT_NAME}" \
  --format json 2>/dev/null | jq -r '.url' 2>/dev/null || echo "")

if [[ -z "$PROJECT_URL" ]]; then
  echo "  ⚠️  Could not auto-create project board. Create manually at:"
  echo "  https://github.com/orgs/${OWNER}/projects/new or https://github.com/users/${OWNER}/projects/new"
  echo "  Title: ${PROJECT_NAME}"
  PROJECT_URL="https://github.com/users/${OWNER}/projects/?"
else
  echo "  ✅  Project board: ${PROJECT_URL}"
fi

# ─── Step 5: Add issues to board ─────────────────────────────────────────────
echo ""
echo "▶ Step 5 — Adding issues to project board..."

PROJECT_NUMBER=$(echo "$PROJECT_URL" | grep -oE '[0-9]+$' || echo "")

if [[ -n "$PROJECT_NUMBER" ]]; then
  for NUM in "${ISSUE_IDS[@]}"; do
    if [[ -n "$NUM" && "$NUM" != "?" ]]; then
      ITEM_ID=$(gh project item-add "$PROJECT_NUMBER" \
        --owner "${OWNER}" \
        --url "https://github.com/${OWNER}/${REPO}/issues/${NUM}" \
        --format json 2>/dev/null | jq -r '.id' 2>/dev/null || echo "")
      echo "  Added issue #${NUM} to board (item: ${ITEM_ID})"
    fi
  done
  echo "  ✅  All issues added to board"
else
  echo "  ⚠️  Skipping — add issues manually to: ${PROJECT_URL}"
fi

# ─── Summary output ──────────────────────────────────────────────────────────
echo ""
echo "=============================="
echo " BOOTSTRAP COMPLETE"
echo "=============================="
echo ""
echo "Copy the following into PROJECT_ROADMAP-mimascota.md:"
echo ""
echo "---"
echo ""
echo "## Delivery Tracking"
echo ""
echo "**Project board:** [${PROJECT_NAME}](${PROJECT_URL})"
echo "**Repository:** [${OWNER}/${REPO}](${REPO_URL})"
echo "**Issue count:** ${#ISSUE_IDS[@]}"
echo "**Board status:** Backlog (all issues)"
echo ""
echo "> Note: The roadmap remains the design source of truth. The project board is the operational execution layer."
echo ""
echo "### Issue Map"
echo ""
echo "| TASK-ID | Issue | Phase | Owner | Status |"
echo "|---------|-------|-------|-------|--------|"

TASK_IDS=("TASK-001" "TASK-002" "TASK-003" "TASK-004" "TASK-005" "TASK-006" "TASK-007" "TASK-008" "TASK-010" "TASK-011" "TASK-020" "TASK-021" "TASK-022" "TASK-023" "TASK-024" "TASK-025" "TASK-026" "TASK-027" "TASK-028" "TASK-029" "TASK-030" "TASK-040" "TASK-041" "TASK-042" "TASK-043")
TASK_PHASES=("Phase 1" "Phase 1" "Phase 1" "Phase 1" "Phase 1" "Phase 1" "Phase 1" "Phase 1" "Phase 1" "Phase 1" "Phase 2" "Phase 2" "Phase 2" "Phase 2" "Phase 2" "Phase 2" "Phase 2" "Phase 2" "Phase 2" "Phase 2" "Phase 3" "Phase 3" "Phase 3" "Phase 3" "Phase 3")
TASK_OWNERS=("@Architect" "@Architect" "@Architect" "@Architect" "@Architect" "@Architect" "@Architect" "@Architect" "@Architect" "@Architect" "@Developer" "@Developer" "@Developer" "@Developer" "@Frontend" "@Frontend" "@Frontend" "@Frontend" "@Frontend" "@Frontend" "@Auditor" "@DevOps" "@DevOps" "@DevOps" "@DevOps")

for i in "${!ISSUE_IDS[@]}"; do
  echo "| ${TASK_IDS[$i]} | #${ISSUE_IDS[$i]} ${REPO_URL}/issues/${ISSUE_IDS[$i]} | ${TASK_PHASES[$i]} | ${TASK_OWNERS[$i]} | Backlog |"
done

echo ""
echo "### Labels Model"
echo ""
echo "| Label | Color | Purpose |"
echo "|-------|-------|---------|"
echo "| \`phase:define\` | #0052CC | Phase 1 tasks |"
echo "| \`phase:build\` | #0075CA | Phase 2 tasks |"
echo "| \`phase:deploy\` | #006B75 | Phase 3 tasks |"
echo "| \`owner:architect\` | #E4E669 | @Architect owned |"
echo "| \`owner:developer\` | #D4C5F9 | @Developer owned |"
echo "| \`owner:frontend\` | #BFD4F2 | @Frontend owned |"
echo "| \`owner:auditor\` | #F9D0C4 | @Auditor owned |"
echo "| \`owner:devops\` | #C2E0C6 | @DevOps owned |"
echo "| \`type:task\` | #EDEDED | Standard task |"
echo "| \`priority:high\` | #B60205 | High priority |"
echo "| \`priority:medium\` | #FBCA04 | Medium priority |"
echo "| \`priority:low\` | #0E8A16 | Low priority |"
echo ""
echo "---"
