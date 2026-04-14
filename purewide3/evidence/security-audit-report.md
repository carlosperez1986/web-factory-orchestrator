# Security Audit Report — Pure Wipe 3.0 (purewide3)

**Auditor:** @Auditor  
**Skill:** security-audit  
**Date:** 2026-04-14  
**Project:** purewide3 — Pure Wipe 3.0 · Sitio Web Corporativo  
**Repository path:** purewide3/  
**Current phase:** Build (Phase 2 in progress, Phase 3 — deploy pending)

---

## Security Audit Findings

### Critical
*(none)*

---

### High

#### HIGH-001 — Unpinned mutable action tag: `appleboy/scp-action@master`
- **Location:** `.github/workflows/deploy.yml`, line 174
- **Risk:** Using `@master` on a third-party GitHub Action is a supply chain risk. The upstream maintainer can push any code to `master` at any time; this code runs in the CI/CD runner with full repository access and deploy credentials in scope. This is the canonical GitHub supply chain attack vector.
- **Remediation:** Pin `appleboy/scp-action` to a specific commit SHA or immutable release tag (e.g., `appleboy/scp-action@v0.1.7`). Run `gh api repos/appleboy/scp-action/releases/latest` to retrieve the current pinnable release.
- **Required owner:** @Orchestrator / DevOps
- **Status:** OPEN — must remediate before production deploy

---

### Medium

#### MED-001 — SSH password-based authentication (vs. SSH key pair)
- **Location:** `.github/workflows/deploy.yml`, lines 19–22, 68, 178, 189
- **Risk:** Deploy workflow authenticates to VPS using a password (`secrets.PASSWORD`) rather than an SSH private key. Password auth exposes a larger attack surface (brute-force susceptibility, no hardware-bound key material). The password is also injected into remote shell sessions via heredoc/`sudo -S`, which may transiently appear in process listings on multi-user systems.
- **Remediation:** Provision an SSH key pair for deployment. Store the private key in `secrets.SSH_PRIVATE_KEY`. Replace `password:` fields in `appleboy/ssh-action` and `appleboy/scp-action` with `key:`. Remove `SSH_PASSWORD` secret and all `sudo -S` password-piping patterns.
- **Required owner:** @Orchestrator / DevOps
- **Status:** OPEN — tracked pre-production remediation

#### MED-002 — `AllowedHosts: "*"` in appsettings.json
- **Location:** `appsettings.json`, line 8
- **Risk:** ASP.NET Core's host filtering middleware is disabled by wildcard, allowing the application to respond to any `Host` header value. This can aid host-header injection attacks. In production behind an Nginx reverse proxy this is mitigated, but the application itself should validate expected hostnames.
- **Remediation:** Override `AllowedHosts` in `appsettings.Production.json` to the actual production domain (e.g., `"AllowedHosts": "yourdomain.com;www.yourdomain.com"` or the shared domain value). The development `appsettings.json` value of `"*"` is acceptable for local dev only.
- **Required owner:** @Orchestrator
- **Status:** OPEN — must configure before production deploy

#### MED-003 — `BaseUrl` placeholder value in appsettings.json
- **Location:** `appsettings.json`, line 11  (`"BaseUrl": "https://purewide3.example.com"`)
- **Risk:** SEO canonical URL and Schema.org metadata will emit `purewide3.example.com` if production config is not overridden. This produces invalid canonical tags pointing to a non-existent domain, degrading SEO and potentially confusing crawlers.
- **Remediation:** Set the real production `BaseUrl` in `appsettings.Production.json` before go-live. The placeholder value in `appsettings.json` is acceptable for scaffold stage.
- **Required owner:** @Orchestrator / Client (domain handoff)
- **Status:** OPEN — acceptable at current stage; must resolve before production deploy

#### MED-004 — Decap CMS loaded from unpkg CDN with floating semver
- **Location:** `wwwroot/admin/index.html`, line 11 (`decap-cms@^3.0.0`)
- **Risk:** Using `^3.0.0` on unpkg resolves to the latest 3.x.x release at load time. Any breaking or malicious change in a 3.x minor/patch release would affect the admin panel without explicit approval. unpkg is a public CDN with no SRI hash validation in the current markup.
- **Remediation:** (a) Pin to a specific version (e.g., `decap-cms@3.4.3`) to control update cadence. (b) Add a `crossorigin` attribute and `integrity` SRI hash for the script tag. Priority: pin first, add SRI when feasible.
- **Required owner:** @Orchestrator
- **Status:** OPEN — tracked hardening item

---

### Low

#### LOW-001 — Netlify Identity widget loaded from CDN (Decap CMS dependency)
- **Location:** `wwwroot/admin/index.html`, line 8
- **Risk:** `https://identity.netlify.com/v1/netlify-identity-widget.js` is loaded from Netlify's CDN. The project uses GitHub backend (`config.yml: backend.name: github`), so the Netlify Identity widget is vestigial and unnecessarily increases the admin page's external dependency surface.
- **Remediation:** Remove the Netlify Identity widget `<script>` tag from `wwwroot/admin/index.html`. It serves no function when using the GitHub backend.
- **Required owner:** @Orchestrator
- **Status:** OPEN — low-impact; clean up before production

#### LOW-002 — No SSH key rotation or deploy key documentation
- **Location:** README.md / deploy documentation
- **Risk:** No documented procedure for rotating deploy credentials (SSH password or future SSH key). If credentials are compromised, there is no playbook for quick rotation.
- **Remediation:** Add a "Credential Rotation" section to README.md documenting which GitHub Secrets to update and what VPS-side steps are required.
- **Required owner:** @Orchestrator
- **Status:** OPEN — documentation gap

---

## Evidence File Verification

### Binary Evidence Checks — Task Registry (Status: done)

| Task | Evidence Required | Exists | Non-Empty | Check Result |
|------|-------------------|--------|-----------|--------------|
| TASK-001 | `evidence/spec-inicio.md` | ❌ MISSING | — | **FAIL** |
| TASK-010 | `evidence/models-review.md` | ❌ MISSING | — | **FAIL** |
| TASK-011 | `wwwroot/admin/config.yml` | ✅ Yes | ✅ Yes (3441 bytes) | PASS |
| TASK-020 | `Program.cs` | ✅ Yes | ✅ Yes (2512 bytes) | PASS |
| TASK-021 | `Services/ContentService.cs` | ✅ Yes | ✅ Yes (6681 bytes) | PASS |
| TASK-024 | `Pages/Index.cshtml` | ✅ Yes | ✅ Yes (12107 bytes) | PASS |
| TASK-027 | `Pages/Shared/_Layout.cshtml` | ✅ Yes | ✅ Yes (9352 bytes) | PASS |
| TASK-040 | `evidence/nginx-syntax.log` | ❌ MISSING | — | **FAIL** |
| TASK-041 | `.github/workflows/deploy.yml` | ✅ Yes | ✅ Yes (7452 bytes) | PASS |

**Evidence failures logged:**
- `EVIDENCE MISSING: TASK-001 — evidence/spec-inicio.md not found or empty` → Status reset to **pending**
- `EVIDENCE MISSING: TASK-010 — evidence/models-review.md not found or empty` → Status reset to **pending**
- `EVIDENCE MISSING: TASK-040 — evidence/nginx-syntax.log not found or empty` → Status reset to **pending**

> Note: TASK-040 is listed as `done` in the Task Registry but the `evidence/nginx-syntax.log` required by the skill does not exist. TASK-040 status has been reset to `pending`.

---

### Evidence Threshold Verification

### Build Phase Artifacts

The following JSON evidence files are required for Phase 2 skills that are currently **pending** (seo-aio-optimization, quality-smoke-and-acceptance, integrate-ui-component have not yet been executed). Their absence is consistent with the project's current build phase status but confirms Phase 2 → Phase 3 gate is blocked.

| Evidence File | Status | Reason |
|---------------|--------|--------|
| `evidence/seo-report-purewide3.json` | ❌ MISSING | `seo-aio-optimization` skill not yet executed (TASK-023 pending) |
| `evidence/quality-smoke-purewide3.json` | ❌ MISSING | `quality-smoke-and-acceptance` skill not yet executed (Phase 2 incomplete) |
| `evidence/ui-smoke-purewide3.json` | ❌ MISSING | `integrate-ui-component` skill not yet executed (Phase 2 incomplete) |

**Threshold verification result:** SKIPPED — prerequisite skills not yet executed. Threshold checks will be enforced when Phase 2 completes and the Phase 2 → Phase 3 gate is re-evaluated.

**Phase 2 → Phase 3 gate: BLOCKED** — Tasks 022, 023, 025, 026, 028, 029 remain pending.

---

## Secrets Handling Review

| Item | Finding | Status |
|------|---------|--------|
| Hard-coded credentials in source | None found | ✅ PASS |
| Hard-coded IPs in source | None found | ✅ PASS |
| `appsettings.Production.json` committed | Not present (gitignored) | ✅ PASS |
| `appsettings.Secrets.json` committed | Not present (gitignored) | ✅ PASS |
| `.gitignore` covers secrets files | `appsettings.Production.json`, `appsettings.Secrets.json`, `secrets/`, `*.pfx`, `*.key`, `*.pem`, `*.priv` all gitignored | ✅ PASS |
| GitHub Secrets used for SSH credentials | `secrets.SERVER_IP`, `secrets.USERNAME`, `secrets.PASSWORD`, `secrets.SHARED_DOMAIN`, `secrets.SHARED_SITE_FILE` | ✅ PASS |
| Secrets validated at workflow start | `Validate deploy secrets` step exits non-zero on missing secrets | ✅ PASS |
| SMTP/email credentials | Contact form handler not yet activated (commented out in Program.cs) — no email secrets needed at this time | ✅ PASS |

---

## Dependency and Supply Chain Risk Review

| Dependency | Version | Source | Risk |
|------------|---------|--------|------|
| `Markdig` | 0.41.0 | NuGet | ✅ Current, widely-used Markdown processor |
| `YamlDotNet` | 16.3.0 | NuGet | ✅ Current, actively maintained |
| `Microsoft.AspNetCore.Mvc.Razor.RuntimeCompilation` | 9.* (Debug only) | NuGet | ✅ First-party, Debug-only — not included in Release builds |
| `actions/checkout` | v4 | GitHub Actions | ✅ Pinned to major version tag |
| `actions/setup-dotnet` | v4 | GitHub Actions | ✅ Pinned to major version tag |
| `appleboy/ssh-action` | v1 | GitHub Actions | ⚠️ Major version tag — acceptable risk (immutable v1 tag) |
| `appleboy/scp-action` | master | GitHub Actions | ❌ **HIGH** — mutable branch tag (see HIGH-001) |
| `decap-cms` | ^3.0.0 | unpkg CDN | ⚠️ Floating semver (see MED-004) |
| `netlify-identity-widget` | v1 | Netlify CDN | ⚠️ Vestigial dependency (see LOW-001) |

**Runtime stack:** .NET 9.0 (net9.0) — current LTS-adjacent release. ✅  
**No database dependencies.** ✅  
**No npm/Node.js runtime dependencies.** ✅

---

## Auth and Surface Review

| Surface | Finding | Status |
|---------|---------|--------|
| OAuth/auth routes | No OAuth implemented — Decap CMS uses GitHub backend (token managed by browser OAuth flow, never server-side) | ✅ No server-side OAuth risk |
| Admin panel access | `/admin/` served as static HTML — authentication handled entirely by Decap CMS GitHub OAuth in-browser | ✅ Acceptable |
| Admin panel noindex | `<meta name="robots" content="noindex">` present | ✅ PASS |
| Contact form handler | Not yet implemented (commented out in Program.cs) | ℹ️ No surface to audit yet |
| Public routes | `/`, `/nosotros`, `/products`, `/blog`, `/galeria`, `/contacto` — all static Razor Pages, no authenticated routes | ✅ No auth surface |
| Reverse proxy assumptions | `X-Forwarded-For`, `X-Forwarded-Proto`, `X-Forwarded-Prefix` headers set in Nginx route config | ✅ PASS |
| PATH_BASE handling | `app.UsePathBase()` reads from `PATH_BASE` env var — matches systemd service `Environment=PATH_BASE=/purewide3` | ✅ Consistent |
| HTTPS redirect | `app.UseHttpsRedirection()` enabled for non-Development environments | ✅ PASS |
| HSTS | `app.UseHsts()` enabled for non-Development environments | ✅ PASS |

---

## Deployment Hardening Review

| Item | Finding | Status |
|------|---------|--------|
| Systemd service runs as deploy user (not root) | `User=$SSH_DEPLOY_USER` in service definition | ✅ PASS |
| App bound to localhost only | `ASPNETCORE_URLS=http://127.0.0.1:$APP_PORT` (not 0.0.0.0) | ✅ PASS |
| ASPNETCORE_ENVIRONMENT set to Production | `Environment=ASPNETCORE_ENVIRONMENT=Production` | ✅ PASS |
| Nginx config validated before reload | `nginx -t` called before `systemctl restart nginx` | ✅ PASS |
| Route prefix consistency | `ROUTE_PREFIX=/purewide3` consistent across systemd `PATH_BASE`, Nginx `location`, and `current_state` `route_prefix` | ✅ PASS |
| PORT consistency | `APP_PORT=5011` consistent across systemd, Nginx proxy_pass, and current_state | ✅ PASS |
| SCP target path matches systemd WorkingDirectory | Both use `/var/www/purewide3` | ✅ PASS |
| SSH action unpinned mutable tag | `appleboy/scp-action@master` | ❌ HIGH-001 |
| SSH auth method | Password-based (see MED-001) | ⚠️ MED-001 |

---

## Files and Configs Reviewed

- `appsettings.json`
- `Program.cs`
- `PureWide3.csproj`
- `.gitignore`
- `.github/workflows/deploy.yml`
- `Services/ContentService.cs`
- `Models/BlogPost.cs`, `Models/Product.cs`, `Models/SeoOptions.cs`
- `wwwroot/admin/config.yml`
- `wwwroot/admin/index.html`
- `Pages/Index.cshtml`, `Pages/Shared/_Layout.cshtml`
- `PROJECT_ROADMAP-purewide3.md` (Task Registry evidence claims)
- `current_state-purewide3.json`

---

## Required Remediations (Before Production Deploy)

| Priority | ID | Action |
|----------|----|--------|
| HIGH | HIGH-001 | Pin `appleboy/scp-action` to a specific immutable version tag or SHA in `deploy.yml` |
| MEDIUM | MED-001 | Replace SSH password auth with SSH key pair authentication in deploy workflow |
| MEDIUM | MED-002 | Set `AllowedHosts` to actual production domain in `appsettings.Production.json` |
| MEDIUM | MED-003 | Set `Seo:BaseUrl` to actual production URL in `appsettings.Production.json` |
| MEDIUM | MED-004 | Pin `decap-cms` CDN script to a specific version (remove `^` floating specifier) |
| LOW | LOW-001 | Remove vestigial Netlify Identity widget script from `wwwroot/admin/index.html` |
| LOW | LOW-002 | Document credential rotation procedure in README.md |
| EVIDENCE | TASK-001 | Create `evidence/spec-inicio.md` (task reset to pending) |
| EVIDENCE | TASK-010 | Create `evidence/models-review.md` (task reset to pending) |
| EVIDENCE | TASK-040 | Run nginx config validation and capture output to `evidence/nginx-syntax.log` (task reset to pending) |

---

## Go/No-Go Decision

**Decision: ✅ GO — Conditional**

**Rationale:**
- **No Critical findings.** No hard-coded secrets, credentials, or tokens found in the repository.
- **No active runtime security vulnerabilities** in the current build scope.
- **One High finding (HIGH-001)** — `appleboy/scp-action@master` is a supply chain risk. This finding is classified as a **required remediation before the first production deploy**, not a blocker for audit completion given the project is still in Phase 2. Per SKILL.md policy, this is logged as a mandatory pre-deploy action.
- **Medium findings** are all configuration items that must be resolved in `appsettings.Production.json` before go-live — none expose active risk in the current staged (non-deployed) state.
- **Phase 2 → Phase 3 gate remains blocked** by pending implementation tasks (TASK-022, 023, 025, 026, 028, 029) and missing JSON evidence files. Security audit GO does not override the Phase gate.

**Conditions attached to GO:**
1. HIGH-001 (`scp-action@master`) must be pinned before workflow is executed against production.
2. MED-002 and MED-003 must be resolved in `appsettings.Production.json` before production deploy.
3. Phase 2 tasks must complete and produce evidence before Phase 3 proceeds.

---

*Report generated by @Auditor · security-audit skill · 2026-04-14*
