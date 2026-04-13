# WFO Blueprint Inventory

**Source:** `blueprints/`  
**Purpose:** Complete template library for deterministic project scaffolding  
**Last Updated:** April 13, 2026  
**Scope:** Pure Wipe baseline; extensible for other WFO projects

---

## Overview

This inventory catalogs all template files, substitution tokens, and their derivation rules. **The project-scaffolding skill MUST reference this document** as the authoritative source for copy-and-substitute operations.

**Key Principle:** No custom code generation. All templates follow:
```
Template File → Identify Tokens → Collect Input/Auto-Resolve → Substitute → Output
```

---

## Token Reference Table

| Token | Source | Type | Example | Required |
|-------|--------|------|---------|----------|
| `{{PROJECT_NAME}}` | User intake (briefing) | String (PascalCase) | PureWipe | Yes |
| `{{TAGLINE}}` | User intake (briefing) | String (Spanish) | Cuidado puro diario | Yes |
| `{{BRAND_EMOJI}}` | User intake (look-and-feel) | Unicode char | 💧 | Yes |
| `{{DOTNET_VERSION}}` | System detect or user override | String (net9.0, net8.0, etc.) | net9.0 | Yes |
| `{{TARGET_FRAMEWORK}}` | Same as {{DOTNET_VERSION}} | String | net9.0 | Yes |
| `{{CACHE_TTL_MINUTES}}` | User intake (build options) or default | Integer | 10 | No (default: 10) |
| `{{LOCALE}}` | User intake (i18n) or default | Locale string | es-ES | No (default: es-ES) |
| `{{HERO_TITLE}}` | User intake (homepage content) | HTML snippet | Cuidado puro<br/>que se siente bien | Yes |
| `{{HERO_SUBTITLE}}` | User intake (homepage content) | Text block | Toallas y papeles de alta calidad… | Yes |
| `{{SECTION_SOLUTIONS}}` | User intake (Products section) | String | NUESTRAS SOLUCIONES | Yes |
| `{{SECTION_SOLUTIONS_COPY}}` | User intake (Products section) | Text block | Explora productos pensados… | Yes |
| `{{SECTION_BLOG}}` | User intake (Blog section) | String | Consejos para tu bienestar diario | Yes |
| `{{PROJECT_TAGLINE}}` | Derived from `{{PROJECT_NAME}}` + `{{TAGLINE}}` | String (formatted) | Pure Wipe - Cuidado puro diario | Auto |
| `{{GITHUB_CLIENT_ID}}` | User intake (GitHub OAuth setup) | String (hex) | Ov23lizdZ5nRtoEihwBY | If custom OAuth |
| `{{GITHUB_CLIENT_SECRET}}` | User intake (GitHub OAuth setup) | String (masked) | [PAT/secret] | If custom OAuth |
| `{{DOMAIN}}` | VPS provisioning (Stage 1/2) | FQDN | hechoenmargarita.com | Yes (for deploy) |
| `{{GITHUB_ROUTE}}` | VPS provisioning (topology-dependent) | String (URL path prefix) | /purewipe | Topology A only |
| `{{USE_SHARED_DOMAIN}}` | VPS provisioning (Stage 1) | Boolean | true OR false | Yes (for deploy) |

---

## File Manifest

### Code Files

#### 1. **Program.cs.template**
- **Path:** `blueprints/code/Program.cs.template`
- **Purpose:** ASP.NET Core application entry point with OAuth, PathBase, ForwardedHeaders
- **Tokens:** 
  - `{{PROJECT_NAME}}` — Namespace prefix
  - `{{DOTNET_VERSION}}` — Not used in source, but in comments
  - `{{CACHE_TTL_MINUTES}}` — Passed to ContentService config
- **Features:**
  - GitHub OAuth server-side endpoint (`/auth`, `/callback`)
  - PathBase middleware for shared-domain topology  
  - ForwardedHeaders middleware for Nginx reverse proxy
  - ContentService registration as singleton
  - Comment blocks for feature flags (contact-form-handler, decap-custom-oauth)
- **Validation Rules (@Auditor):**
  - Must contain `app.UseForwardedHeaders()`
  - Must contain `ContentService` registration
  - OAuth endpoints present if GitHub:ClientId is set

#### 2. **ContentService.cs.template**
- **Path:** `blueprints/code/Services/ContentService.cs.template`
- **Purpose:** Git-backed content service; loads JSON/Markdown from wwwroot/content
- **Tokens:**
  - `{{PROJECT_NAME}}` — Namespace
  - `{{CACHE_TTL_MINUTES}}` — Cache TTL constant
- **Features:**
  - Generic `GetJsonCollection<T>()` for any JSON collection
  - Markdown parsing (Markdig) with YAML frontmatter support (YamlDotNet)
  - In-memory caching with TTL
  - BlogPost-specific convenience method
- **Dependencies:** Markdig 0.41.0, YamlDotNet 16.3.0
- **Validation Rules:**
  - Must contain `IMemoryCache` injection
  - Must define `CacheTtlMinutes` constant

#### 3. **BlogPost.cs.template**
- **Path:** `blueprints/code/Models/BlogPost.cs.template`
- **Purpose:** Data model for blog content
- **Tokens:**
  - `{{PROJECT_NAME}}` — Namespace
- **Fields:** Slug, Title, Date, Image, SeoDescription, Category, ContentHtml
- **Immutability:** Auto-properties with public get/init
- **Use Case:** Loaded from `wwwroot/content/blog/*.json` via ContentService

#### 4. **appsettings.json.template**
- **Path:** `blueprints/code/appsettings.json.template`
- **Purpose:** Application configuration
- **Tokens:**
  - `{{GITHUB_CLIENT_ID}}` — OAuth app ID
  - `{{GITHUB_CLIENT_SECRET}}` — OAuth app secret
  - `{{DOMAIN}}` — Target domain (from VPS intake)
  - `{{GITHUB_ROUTE}}` — Route prefix (e.g., "/purewipe" or empty)
- **Sections:**
  - `Logging` — DefaultLevel: Information, AspNetCore: Warning (static)
  - `AllowedHosts` — "*" (static)
  - `GitHub` — OAuth endpoints (auto-constructed from {{DOMAIN}} and {{GITHUB_ROUTE}})
- **Validation Rules:**
  - RedirectUri must match GitHub OAuth app configuration
  - BaseUrl must be reachable from browser (for OAuth callback)

#### 5. **PureWipe.csproj.template**
- **Path:** `blueprints/code/PureWipe.csproj.template`
- **Purpose:** Project file; locks dependencies and build config
- **Tokens:**
  - `{{TARGET_FRAMEWORK}}` — TargetFramework (net9.0, net8.0, etc.)
- **Dependencies (locked):**
  - Markdig 0.41.0
  - YamlDotNet 16.3.0
- **Build Options (static):**
  - Nullable: enable
  - ImplicitUsings: enable
  - LangVersion: latest
- **Validation Rules:**
  - Must restore without errors
  - Must compile with no warnings (if possible)

---

### View Files (Razor Pages)

#### 6. **_Layout.cshtml.template**
- **Path:** `blueprints/code/Pages/Shared/_Layout.cshtml.template`
- **Purpose:** Master layout; header, footer, navigation
- **Tokens:**
  - `{{PROJECT_NAME}}` — Site brand name in navbar, footer
  - `{{TAGLINE}}` — Brand tagline under brand name
  - `{{BRAND_EMOJI}}` — Brand emoji in header/footer logo
- **Structure:**
  - Header: Navigation with dropdown (Products → categories)
  - Main: RenderBody()
  - Footer: Links, social, copyright with year
  - Scripts: Bootstrap 5.3.3 bundle
- **Validation Rules:**
  - Must contain `<base href=...>` for PathBase support
  - Must contain Footer copyright with `@DateTime.Now.Year`
  - Navigation must have exactly 4 items (Inicio, Productos, Consejos, Privacidad)

#### 7. **Index.cshtml.template**
- **Path:** `blueprints/code/Pages/Index.cshtml.template`
- **Purpose:** Homepage; hero, features, product showcase, retailers, blog preview
- **Tokens:**
  - `{{PROJECT_NAME}}` — Brand name in retailers section
  - `{{PROJECT_TAGLINE}}` — In meta description
  - `{{HERO_TITLE}}` — Hero headline (with optional `<br/>`)
  - `{{HERO_SUBTITLE}}` — Hero description paragraph
  - `{{SECTION_SOLUTIONS}}` — Product section title
  - `{{SECTION_SOLUTIONS_COPY}}` — Product section description
  - `{{SECTION_BLOG}}` — Blog preview section title (appears twice)
- **Sections:**
  1. Hero (copy + product showcase)
  2. Features grid (4 static cards)
  3. Products by category (model-driven)
  4. Sustainability banner (static SVG)
  5. Retailers section (static pill list)
  6. Blog preview (if Model.LatestPosts not empty)
- **Model Bindings:**
  - `Model.ProductsByCategory` — Dictionary<string, List<Product>>
  - `Model.LatestPosts` — List<BlogPost>
- **Validation Rules:**
  - Must have SEO description in meta tag
  - Must load Hero title/subtitle correctly
  - Hero showcase must render exactly 4 products

#### 8. **Post.cshtml.template**
- **Path:** `blueprints/code/Pages/Blog/Post.cshtml.template`
- **Purpose:** Blog post detail page
- **Tokens:**
  - `{{PROJECT_NAME}}` — Model namespace
  - `{{LOCALE}}` — Date format locale (e.g., es-ES)
- **Route:** `/blog/{slug}`
- **Model:** `{{PROJECT_NAME}}.Pages.Blog.PostModel` with `BlogPost Post` property
- **Features:**
  - Displays Post metadata (category, date, image)
  - Renders Post.ContentHtml as raw HTML
  - Back link to blog index
- **Validation Rules:**
  - Must display post date in specified {{LOCALE}}
  - Must handle missing images gracefully (onerror handler)
  - Must have back button to ~/blog

---

## Derivation Rules & Auto-Resolution

### Rule 1: Domain-Derived Tokens
**Applies to:** `{{GITHUB_ROUTE}}`, `{{GITHUB_BASE_URL}}`, `{{GITHUB_REDIRECT_URI}}`

**Logic:**
```
IF USE_SHARED_DOMAIN == "true" THEN
  GITHUB_ROUTE = "/" + ROUTE_PREFIX  (e.g., "/purewipe")
  GITHUB_BASE_URL = "https://" + SHARED_DOMAIN + GITHUB_ROUTE
  GITHUB_REDIRECT_URI = GITHUB_BASE_URL + "/callback"
ELSE
  GITHUB_ROUTE = ""  (empty)
  GITHUB_BASE_URL = "https://" + DOMAIN
  GITHUB_REDIRECT_URI = GITHUB_BASE_URL + "/callback"
END IF
```

**Source:** VPS provisioning stage (orchestrator)  
**Automated:** Yes, no user input required

### Rule 2: Locale Defaults
**Token:** `{{LOCALE}}`

**Default:** `es-ES` (Spanish - Spain)  
**Auto-resolved:** Yes, applied to all `.template` files during scaffolding unless user overrides in briefing

### Rule 3: Cache TTL Defaults
**Token:** `{{CACHE_TTL_MINUTES}}`

**Default:** 10 minutes  
**Auto-resolved:** Yes, unless user specifies custom value in build options

### Rule 4: Namespace Consistency
**Token:** `{{PROJECT_NAME}}` (appears in all C# files)

**Rule:** Must be consistent across all `*.cs` and `*.template` files  
**Source:** User briefing (PascalCase application name)  
**Validation:** No spaces, no hyphens; alphanumeric only

---

## Copy Instructions (for project-scaffolding skill Step 5)

The project-scaffolding skill MUST execute this sequence:

```
Step 5A: Initialize .NET Project Scaffold
  1. Create directory: wwwroot/content/
  2. Create directory: wwwroot/content/blog/
  3. Create directory: Pages/Blog/
  4. Create directory: Pages/Shared/
  5. Create directory: Services/
  6. Create directory: Models/
  
Step 5B: Copy & Substitute Templates
  7. Copy blueprints/code/PureWipe.csproj.template → {{PROJECT_NAME}}.csproj
     Substitute: {{TARGET_FRAMEWORK}}
     
  8. Copy blueprints/code/Program.cs.template → Program.cs
     Substitute: {{PROJECT_NAME}}, {{CACHE_TTL_MINUTES}}
     
  9. Copy blueprints/code/appsettings.json.template → appsettings.json
     Substitute: {{GITHUB_CLIENT_ID}}, {{GITHUB_CLIENT_SECRET}}, {{DOMAIN}}, {{GITHUB_ROUTE}}
     
  10. Copy blueprints/code/Services/ContentService.cs.template → Services/ContentService.cs
      Substitute: {{PROJECT_NAME}}, {{CACHE_TTL_MINUTES}}
      
  11. Copy blueprints/code/Models/BlogPost.cs.template → Models/BlogPost.cs
      Substitute: {{PROJECT_NAME}}
      
  12. Copy blueprints/code/Pages/Shared/_Layout.cshtml.template → Pages/Shared/_Layout.cshtml
      Substitute: {{PROJECT_NAME}}, {{TAGLINE}}, {{BRAND_EMOJI}}
      
  13. Copy blueprints/code/Pages/Index.cshtml.template → Pages/Index.cshtml
      Substitute: {{PROJECT_NAME}}, {{PROJECT_TAGLINE}}, {{HERO_TITLE}}, {{HERO_SUBTITLE}}, 
                  {{SECTION_SOLUTIONS}}, {{SECTION_SOLUTIONS_COPY}}, {{SECTION_BLOG}}
      
  14. Copy blueprints/code/Pages/Blog/Post.cshtml.template → Pages/Blog/Post.cshtml
      Substitute: {{PROJECT_NAME}}, {{LOCALE}}

Step 5C: Verify Output
  15. Check .csproj syntax (valid XML)
  16. Check C# files for syntax errors (grammar only, no compilation yet)
  17. Check CSHTML files for valid Razor syntax
```

---

## Token Substitution Matrix

| Token | Files | Source | Collection Timing |
|-------|-------|--------|-------------------|
| `{{PROJECT_NAME}}` | Program.cs, ContentService.cs, BlogPost.cs, *.cshtml | briefing-synthesis | Phase 1 (Plan) |
| `{{TAGLINE}}` | _Layout.cshtml | briefing-synthesis | Phase 1 (Plan) |
| `{{BRAND_EMOJI}}` | _Layout.cshtml | integrate-ui-component (look-and-feel) | Phase 2a (Build) |
| `{{DOTNET_VERSION}}` | .csproj, Program.cs comments | System detect / briefing | Phase 1 (Plan) |
| `{{TARGET_FRAMEWORK}}` | .csproj | {{DOTNET_VERSION}} (same) | Phase 1 (Plan) |
| `{{CACHE_TTL_MINUTES}}` | Program.cs, ContentService.cs | build options or default (10) | Phase 2a (Build) |
| `{{LOCALE}}` | Post.cshtml | i18n config or default (es-ES) | Phase 1 (Plan) |
| `{{HERO_TITLE}}` | Index.cshtml | integrate-ui-component (homepage design) | Phase 2a (Build) |
| `{{HERO_SUBTITLE}}` | Index.cshtml | integrate-ui-component (homepage design) | Phase 2a (Build) |
| `{{SECTION_SOLUTIONS}}` | Index.cshtml | integrate-ui-component (homepage design) | Phase 2a (Build) |
| `{{SECTION_SOLUTIONS_COPY}}` | Index.cshtml | integrate-ui-component (homepage design) | Phase 2a (Build) |
| `{{SECTION_BLOG}}` | Index.cshtml | integrate-ui-component (homepage design) | Phase 2a (Build) |
| `{{PROJECT_TAGLINE}}` | Index.cshtml | {{PROJECT_NAME}} + {{TAGLINE}} (derived) | Auto (Phase 1) |
| `{{GITHUB_CLIENT_ID}}` | appsettings.json | user intake or GitHub Secrets | Phase 2a (Build) |
| `{{GITHUB_CLIENT_SECRET}}` | appsettings.json | user intake or GitHub Secrets | Phase 2a (Build) |
| `{{DOMAIN}}` | appsettings.json, deploy.yml | vps-provisioning intake | Phase 3 (Deploy) |
| `{{GITHUB_ROUTE}}` | appsettings.json, deploy.yml | vps-provisioning intake (derived) | Phase 3 (Deploy) |
| `{{USE_SHARED_DOMAIN}}` | deploy.yml | vps-provisioning intake (Stage 1) | Phase 3 (Deploy) |

---

## Extensibility Notes

### Adding New Templates
When extending the blueprint library:
1. Create new `.template` file in appropriate subdirectory
2. Document all tokens in this inventory
3. Add entry to File Manifest section with validation rules
4. Add copy instruction to Step 5B
5. Add token to Substitution Matrix
6. Update project-scaffolding skill Step 5 with new copy instruction

### Future Models
Anticipated templates (not yet provided):
- `Product.cs.template` — Product catalog model
- `Gallery.cs.template` — Image gallery model (if feature-enabled)
- `Products.cshtml.template` — Product listing/filtering page
- `appsettings.Development.json.template` — Development-specific config

### Feature Flags
Some features are optional and should only be copied if enabled:
- `contact-form-handler` — If enabled, copy ContactService.cs and extend Program.cs SMTP registration
- `decap-custom-oauth` — If enabled, activate OAuth endpoints in Program.cs and appsettings

---

## Audit Checklist (@Auditor)

When @Auditor validates the scaffolded project:
- [ ] All `.template` files have been substituted (no `{{` tokens remain except in comments)
- [ ] All C# namespaces match `{{PROJECT_NAME}}`
- [ ] All `.cshtml` files reference correct models and routes
- [ ] appsettings.json is valid JSON
- [ ] .csproj is valid XML with matching project name
- [ ] No hardcoded secrets in any file (GitHub tokens, etc.)
- [ ] All image href attributes handle missing images gracefully

---

## References
- **Skill:** `project-scaffolding/SKILL.md` (Step 5)
- **Orchestrator Intake:** `.github/agents/orchestrator.agent.md` (GitHub Auth Failure Protocol, VPS Deployment Intake)
- **Deploy Template:** `blueprints/infra/deploy.yml.template`
- **Evidence Validation:** `security-audit/SKILL.md` (Step 5 JSON threshold checks)
