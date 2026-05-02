# Evidence: project-scaffolding-pass — NexoEscolar

**Date:** 2026-05-02  
**Skill:** `project-scaffolding`  
**Project:** nexoescolar  
**TASK-020, TASK-021, TASK-022, TASK-023, TASK-024–029 (scaffold stage)**

---

## Build Verification

```
Build command: dotnet build NexoEscolar.csproj --configuration Release
Result:        Build succeeded.
Warnings:      0
Errors:        0
Time elapsed:  ~11s
```

## Scaffold Contents

| File | Status |
|------|--------|
| `NexoEscolar.csproj` | ✅ Created — net9.0, no EF, no SQL |
| `Program.cs` | ✅ Created — from blueprint; includes OAuth proxy for Decap |
| `appsettings.json` | ✅ Created — GitHub OAuth placeholders; NotificationWebhook key |
| `Services/ContentService.cs` | ✅ Created — GetPage<T> + GetCollection<T> + 10min cache |
| `Models/IOrderedContent.cs` | ✅ Created |
| `Models/HeroBanner.cs` | ✅ Created |
| `Models/DashboardChip.cs` | ✅ Created |
| `Models/ProblemaSection.cs` | ✅ Created |
| `Models/PainPoint.cs` | ✅ Created |
| `Models/FeatureCard.cs` | ✅ Created — implements IOrderedContent |
| `Models/BeneficiosHub.cs` | ✅ Created |
| `Models/RoleHub.cs` | ✅ Created |
| `Models/AppShowcase.cs` | ✅ Created |
| `Models/AppNotification.cs` | ✅ Created |
| `Models/TrustSection.cs` | ✅ Created |
| `Models/TrustBlock.cs` | ✅ Created |
| `Models/FaqItem.cs` | ✅ Created — implements IOrderedContent |
| `Models/FooterContent.cs` | ✅ Created |
| `Models/ContactFormModel.cs` | ✅ Created — 4 validated fields |
| `Pages/_ViewImports.cshtml` | ✅ Created |
| `Pages/_ViewStart.cshtml` | ✅ Created |
| `Pages/Shared/_Layout.cshtml` | ✅ Created — Navbar, AOS init, parallax script, Bootstrap 5 |
| `Pages/Error.cshtml + .cs` | ✅ Created |
| `Pages/Index.cshtml` | ✅ Created — 8 anchor sections: hero, problema, funciones, beneficios, app, trust, demo, faq, footer |
| `Pages/Index.cshtml.cs` | ✅ Created — OnGet + OnPostAsync; DispatchLeadAsync webhook |
| `wwwroot/css/site.css` | ✅ Created — all design tokens + 17 component classes |
| `wwwroot/admin/index.html` | ✅ Created — Decap CMS loader |
| `wwwroot/admin/config.yml` | ✅ Created — 8 collections (pages + funciones + faq) |
| `wwwroot/content/pages/hero.json` | ✅ Seeded |
| `wwwroot/content/pages/problema.json` | ✅ Seeded |
| `wwwroot/content/pages/beneficios.json` | ✅ Seeded |
| `wwwroot/content/pages/app.json` | ✅ Seeded |
| `wwwroot/content/pages/trust.json` | ✅ Seeded |
| `wwwroot/content/pages/footer.json` | ✅ Seeded |
| `wwwroot/content/collections/funciones/*.json` | ✅ 5 files seeded |
| `wwwroot/content/collections/faq/*.json` | ✅ 3 files seeded |
| `wwwroot/robots.txt` | ✅ Created |
| `wwwroot/sitemap.xml` | ✅ Created |
| `.github/workflows/build.yml` | ✅ Created — .NET 9 build CI |
| `.gitignore` | ✅ Created |

## No-SQL Verification

```
grep -r "DbContext\|EntityFramework\|SqlClient" scaffold-output/nexoescolar-web/
→ 0 results ✅
```

## Gate 4 Pre-check (anti-forgery)

- `[ValidateAntiForgeryToken]` is handled via `@Html.AntiForgeryToken()` in form
- `OnPostAsync` in `IndexModel` validates `ModelState` before dispatch
- No hardcoded secrets — `appsettings.json` contains only empty placeholders

## Open Technical Questions (unchanged)

- OTQ-1: GitHub OAuth App credentials (client_id + client_secret) — pending from client
- OTQ-2: NotificationWebhook URL — pending operator decision (SMTP or webhook)
- OTQ-3: Custom domain — pending client
- OTQ-4: Favicon / OG image — pending client asset
