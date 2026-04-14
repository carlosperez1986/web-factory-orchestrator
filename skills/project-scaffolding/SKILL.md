---
name: project-scaffolding
description: >
  Detects or creates a GitHub repository, initializes .NET 9 project scaffold
  from blueprints, and seeds Decap CMS admin structure. Transitions project from
  analysis phase (hub) to development phase (client repo). Use after user approves
  Phase 1 roadmap and estimation. This is the gateway skill to Phase 2.
phase: "build"
---

# Project Scaffolding

## Overview
Orchestrates the creation of a per-project GitHub repository and populates it with:
- .NET 9 Razor Pages project skeleton from blueprints
- Decap CMS admin schema structure (`wwwroot/admin/config.yml`)
- CI/CD pipeline scaffolding (GitHub Actions)
- Initial commit to bootstrap the build workflow

This skill bridges Phase 1 (analysis in central hub) to Phase 2 (development in client repo).

**Repository scope policy (default, non-negotiable):**
- Client repository is `project-code-only`.
- Do NOT copy WFO hub files into the client repo (no `skills/`, no `.github/agents/`, no orchestrator docs, no `current_state-*.json`, no `PROJECT_ROADMAP-*.md`).
- WFO orchestration/state artifacts remain in the hub repository only.

## Blueprint Enforcement Mode (Non-Negotiable)

When this skill writes scaffold code, it operates in blueprint-only mode:
- **Allowed:** copy from `/blueprints/**` and substitute declared tokens.
- **Allowed:** create empty folders and evidence files.
- **Forbidden:** invent new application logic, new classes, or custom code beyond token substitution.
- **Forbidden:** replacing existing working app logic in adoption mode.

If a required scaffold artifact does not exist in `/blueprints`, stop with `BLOCKER` and
request blueprint completion instead of generating code from scratch.

If the project already has a repository with working code and CI/CD, this skill switches to an adoption mode:
- preserve existing application code,
- preserve existing `.github/workflows/` unless user explicitly approves replacement,
- import the project into WFO by updating hub-side `current_state-{project-name}.json` and `PROJECT_ROADMAP-{project-name}.md` only,
- document any architectural drift between the live repo and WFO standards.

## When to Use
- User has approved `PROJECT_ROADMAP-{project-name}.md` in Phase 1
- Cost/effort estimation is complete and accepted
- `.NET target_framework` is decided and locked in roadmap
- Ready to begin implementation (Phase 2 — Build)
- Existing repository may or may not already exist; this skill handles both cases
- **NOT for:** continuing implementation work after repo import is complete (use `spec-driven-architecture` instead)

## Handover Requirement

```text
Requires: @Architect has completed `project-estimation-and-stack-selection`.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] @Architect → @Architect | project-estimation DONE | YYYY-MM-DD

User approval: "Proceed to Phase 2" in session (USER GATE 1).
```

## Process

### Step 1 — Detect or Create Repository

**Read from `current_state-{project-name}.json`:**
- `project` field (the slug; e.g., `pure-wipe`)
- `repo_url` field (if previously set; null if new project)
- optional `repo_mode` field (`new`, `existing`, `adopted`)

**Decision Logic:**

```
IF repo_url is NULL or empty:
  → Repository does NOT exist yet (NEW PROJECT)
  → Go to Step 2 (Create)
  
ELSE IF repo_url is populated:
  → Repository exists (EXISTING PROJECT or adoption case)
  → Go to Step 3 (Clone)
  
ELSE if repo_url is marked "pending-confirmation":
  → User was uncertain about repo at Phase 1
  → Fall through to Step 2 and ask user confirmation
```

**Additional detection rule:**

If the user explicitly says the repo already has working code or CI/CD, treat it as an **adoption case**. In adoption mode, do not overwrite code, workflows, deployment scripts, or app configuration without first comparing them against WFO expectations.

### Step 2 — Create New Repository (If Missing)

**Credential pre-check (required, blocking):**

Before repository bootstrap, verify GitHub MCP credentials and permissions:
- MCP GitHub server configured and reachable
- PAT present in MCP input
- Minimal token scopes:
  - `repo` (private repo create + push)
  - `workflow` (create/update GitHub Actions workflow files)
- If repository owner is a GitHub Organization, confirm create-repository permission in that org

If any item is missing, set:

```json
"repo_status": "blocked-missing-permissions"
```

Emit `BLOCKER` and stop pipeline until user updates credentials/permissions.

**Confirm with user (required):**

```
"Repository for {project-name}: DOES NOT EXIST YET.

I will run automatic MCP repository bootstrap with the current GitHub account.

This will:
1. Create a PRIVATE repository on github.com/{username}/{project-name}
2. Expose the clone URL for optional human clone

Confirm? (yes/no)"
```

If user confirms but permissions are still missing, ask exactly:

```
GitHub MCP is missing required permissions.

Minimum required scopes:
1. repo
2. workflow

If targeting an organization repo, also ensure your account/token can create repos in that organization.

Reply "updated" once permissions are fixed to retry bootstrap.
```

Fine-grained PAT reference (when user uses fine-grained instead of classic):
- Repository access must be `All repositories` to create a new repository automatically.
- `Selected repositories` only works for existing repos and will fail for new repo bootstrap.
- Minimum repository permissions:
  - `Contents`: Read and write
  - `Administration`: Read and write (needed for repository creation/management flows)
  - `Actions`: Read and write (if workflows/secrets are managed in automation)

**Only proceed if user replies "yes" or "confirm".**

**Execute creation (MCP-only, automatic):**

```bash
# Use MCP GitHub server with current authenticated account
# Create: private repo named {project-name}, empty (no README)
# Return repo_url so a human can clone later if needed
# Agent-side local clone is internal/optional and only used when required by subsequent scaffold steps
```

If MCP server is unavailable/misconfigured/auth-failed, set:

```json
"repo_status": "blocked-github-mcp"
```

Emit `BLOCKER` and stop the pipeline immediately. Do not continue to Step 3+.

**Blocking GitHub Communication Gate (hard stop):**

Immediately after create/clone, verify GitHub communication and push capability.

```bash
cd ./{project-name}/
git remote -v
git ls-remote --heads origin
```

If any command returns network/proxy/auth error (403/401/timeout/DNS), set:

```json
"repo_status": "blocked-github-communication"
```

Then stop the pipeline with `BLOCKER` and do not continue to Step 3+.

Resume only after a successful check:

```bash
git ls-remote --heads origin
```

**Capture repo URL and update state:**

```json
"repo_url": "https://github.com/{username}/{project-name}.git",
"repo_created_at": "YYYY-MM-DD HH:MM:SS (UTC)"
```

**If repository creation fails (MCP path):**
- Set `repo_status: "blocked-github-mcp"`
- Emit `BLOCKER` and stop pipeline (no manual fallback path in this workflow)
- Require MCP connectivity/auth restoration
- Resume only after MCP create succeeds and `git ls-remote` succeeds

### Step 3 — Clone Existing Repository (If Exists)

**If `repo_url` is set:**

```bash
git clone {repo_url} ./{project-name}/
cd ./{project-name}/
```

**Check for existing state file:**

If `current_state-{project-name}.json` already exists in the repo:
- Load it and verify `phase` is not "deployed"
- If `phase` is "build" → ok, continue
- If `phase` is "deployed" → warn user: "This project is deployed. Resume or start new phase?"

**Adoption-mode checks (required):**

After cloning, inspect and record these files before making any changes:
- `.github/workflows/*.yml`
- `Program.cs`
- `*.csproj`
- `wwwroot/admin/config.yml`
- deployment scripts under `deploy/` if present

Write an `## Existing Repo Assessment` section into `PROJECT_ROADMAP-{project-name}.md` with:
- target framework currently used,
- whether Decap CMS is already integrated,
- whether GitHub Actions CI/CD already works,
- whether deployment uses root domain or shared subpath,
- gaps vs WFO baseline.

### Step 4 — Enforce Project-Only Repository Boundary

Client repo must contain only deliverable project code and deployment artifacts.

**Forbidden in client repo:**
- `skills/**`
- `.github/agents/**`
- orchestrator-only documentation
- `current_state-*.json`
- `PROJECT_ROADMAP-*.md`

**Verification (required):**

```bash
cd ./{project-name}/
test ! -d skills
test ! -d .github/agents
ls current_state-*.json 2>/dev/null && exit 1 || true
ls PROJECT_ROADMAP-*.md 2>/dev/null && exit 1 || true
```

If any forbidden artifact is found, stop with `BLOCKER` and remove before continuing.

### Step 5 — Initialize .NET Project Scaffold from Blueprints

**⚠️ Critical:** This step ONLY performs copy-and-substitute using `/blueprints/code/**` templates.  
**No custom code generation allowed.** Every file must be templated at source.

**Adoption-Mode Exception:** If the repository already contains working application code:
- do NOT replace `Program.cs`, `.csproj`, `Pages/`, `Models/`, `Services/`, or `.github/workflows/` by default,
- compare the live structure against WFO blueprints (see `blueprints/BLUEPRINT_INVENTORY.md`),
- only add missing baseline artifacts,
- record all deviations in the roadmap,
- if modernization is needed (e.g., .NET 8 → .NET 9), propose it as a later roadmap task instead of silently rewriting.

**For New Repositories (Standard Path):**

Use `blueprints/BLUEPRINT_INVENTORY.md` as the authoritative copy guide.

**5A - Directory Structure:**

```bash
mkdir -p {project-name}/wwwroot/content/blog
mkdir -p {project-name}/Services
mkdir -p {project-name}/Models
mkdir -p {project-name}/Pages/Blog
mkdir -p {project-name}/Pages/Shared
mkdir -p {project-name}/evidence
```

**5B - Copy Blueprint Templates & Substitute Tokens:**

Reference Table: See `blueprints/BLUEPRINT_INVENTORY.md` § "Token Substitution Matrix" for collection timing per token.

**Token values (must be resolved before substitution):**

| Token | Source | How to Obtain |
|-------|--------|---------------|
| `{{PROJECT_NAME}}` | Roadmap / briefing-synthesis | PascalCase app name (e.g., `PureWipe`) |
| `{{TAGLINE}}` | Roadmap / briefing-synthesis | Brand tagline (Spanish) |
| `{{BRAND_EMOJI}}` | integrate-ui-component output or user intake | Single Unicode emoji (e.g., 💧) |
| `{{TARGET_FRAMEWORK}}` | Roadmap / .NET version decision | Framework ID (net9.0, net8.0, etc.) |
| `{{CACHE_TTL_MINUTES}}` | buildopt.cache_ttl or default 10 | Integer minutes |
| `{{LOCALE}}` | buildopt.locale or default es-ES | Locale string (es-ES, en-US, etc.) |
| `{{HERO_TITLE}}` | integrate-ui-component or user intake | Hero section headline |
| `{{HERO_SUBTITLE}}` | integrate-ui-component or user intake | Hero description paragraph |
| `{{SECTION_SOLUTIONS}}` | integrate-ui-component or user intake | Products section title |
| `{{SECTION_SOLUTIONS_COPY}}` | integrate-ui-component or user intake | Products section description |
| `{{SECTION_BLOG}}` | integrate-ui-component or user intake | Blog section preview title |
| `{{PROJECT_TAGLINE}}` | Derived: {{PROJECT_NAME}} + {{TAGLINE}} | Auto-formatted (no separate intake) |
| `{{GITHUB_CLIENT_ID}}` | GitHub OAuth app setup | OAuth app client ID (if using custom auth) |
| `{{GITHUB_CLIENT_SECRET}}` | GitHub OAuth app setup | OAuth app secret (if using custom auth) |
| `{{DOMAIN}}` | VPS provisioning or user intake | FQDN (e.g., hechoenmargarita.com) |
| `{{GITHUB_ROUTE}}` | Derived from {{DOMAIN}} + {{USE_SHARED_DOMAIN}} | Route prefix (e.g., /purewipe) or empty |

**Copy & Substitute Instructions:**

```bash
# 1. Copy & substitute .csproj (token: TARGET_FRAMEWORK)
cp blueprints/code/PureWipe.csproj.template  {project-name}/{project-name}.csproj
# Then: sed -i 's/{{TARGET_FRAMEWORK}}/net9.0/g' {project-name}/{project-name}.csproj

# 2. Copy & substitute Program.cs (tokens: PROJECT_NAME, CACHE_TTL_MINUTES)
cp blueprints/code/Program.cs.template  {project-name}/Program.cs
# Then: sed -i 's/{{PROJECT_NAME}}/{PROJECT_NAME}/g' {project-name}/Program.cs
# Then: sed -i 's/{{CACHE_TTL_MINUTES}}/{CACHE_TTL_MINUTES}/g' {project-name}/Program.cs

# 3. Copy & substitute appsettings.json (tokens: GITHUB_CLIENT_ID, GITHUB_CLIENT_SECRET, DOMAIN, GITHUB_ROUTE)
cp blueprints/code/appsettings.json.template  {project-name}/appsettings.json
# Then: perform GitHub OAuth token substitution
# Then: perform DOMAIN and GITHUB_ROUTE substitution

# 4. Copy ContentService.cs (tokens: PROJECT_NAME, CACHE_TTL_MINUTES)
cp blueprints/code/Services/ContentService.cs.template  {project-name}/Services/ContentService.cs
# Then: sed -i 's/{{PROJECT_NAME}}/{PROJECT_NAME}/g' {project-name}/Services/ContentService.cs
# Then: sed -i 's/{{CACHE_TTL_MINUTES}}/{CACHE_TTL_MINUTES}/g' {project-name}/Services/ContentService.cs

# 5. Copy BlogPost.cs model (token: PROJECT_NAME)
cp blueprints/code/Models/BlogPost.cs.template  {project-name}/Models/BlogPost.cs
# Then: sed -i 's/{{PROJECT_NAME}}/{PROJECT_NAME}/g' {project-name}/Models/BlogPost.cs

# 6. Copy _Layout.cshtml (tokens: PROJECT_NAME, TAGLINE, BRAND_EMOJI)
cp blueprints/code/Pages/Shared/_Layout.cshtml.template  {project-name}/Pages/Shared/_Layout.cshtml
# Then: perform PROJECT_NAME, TAGLINE, BRAND_EMOJI substitution

# 7. Copy Index.cshtml (tokens: PROJECT_NAME, PROJECT_TAGLINE, HERO_TITLE, HERO_SUBTITLE, SECTION_SOLUTIONS, SECTION_SOLUTIONS_COPY, SECTION_BLOG)
cp blueprints/code/Pages/Index.cshtml.template  {project-name}/Pages/Index.cshtml
# Then: perform all 7 token substitutions

# 8. Copy Post.cshtml (tokens: PROJECT_NAME, LOCALE)
cp blueprints/code/Pages/Blog/Post.cshtml.template  {project-name}/Pages/Blog/Post.cshtml
# Then: sed -i 's/{{PROJECT_NAME}}/{PROJECT_NAME}/g' {project-name}/Pages/Blog/Post.cshtml
# Then: sed -i 's/{{LOCALE}}/{LOCALE}/g' {project-name}/Pages/Blog/Post.cshtml

# 9. Create evidence README
echo "# Evidence — see WFO evidence/README.md for convention" > {project-name}/evidence/README.md
```

**Detailed Token Substitution Locations:**

For exact token locations in each template file, refer to `blueprints/BLUEPRINT_INVENTORY.md` § "File Manifest".

**Verification (Post-Substitution):**

```bash
cd {project-name}/
# 1. Check for remaining template tokens (should be NONE except in comments)
grep -r "{{" . --include="*.cs" --include="*.json" | grep -v "^#\|^//" || echo "✓ No unreplaced tokens found"

# 2. Validate .csproj is well-formed XML
xmllint --noout {project-name}.csproj || { echo "ERROR: .csproj is malformed XML"; exit 1; }

# 3. Validate appsettings.json is valid JSON
jq empty appsettings.json || { echo "ERROR: appsettings.json is invalid"; exit 1; }

# 4. Run dotnet build dry-run (syntax check only)
dotnet --version
dotnet build --dry-run

# 5. Check that all .cshtml files have valid Razor syntax (basic grep for common errors)
grep -r "@model" Pages/ --include="*.cshtml" || { echo "WARNING: @model binding may be missing"; }
```

**If verification fails:**
- Stop immediately and fix all errors before committing
- Check for UTF-8 encoding issues in substituted files
- Check for escaped characters in JSON or XML values
- Manually inspect any binary/encoding differences if sed/awk substitution produced unexpected results

### Step 6 — Create Decap CMS Admin Structure

**Create directory and config template:**

```bash
mkdir -p ./{project-name}/wwwroot/admin/
```

**Generate `config.yml` from roadmap:**

Read `PROJECT_ROADMAP-{project-name}.md` and extract:
- Site title (from Detected Motives or project name)
- Navigation items (from Sitemap)
- Featured image path (default: `/images/`)
- Collections (from Feature Components; e.g., if "dynamic-content-grid", create products collection)

**Template for `wwwroot/admin/config.yml`:**

```yaml
backend:
  name: git-gateway
  branch: main
  base_url: https://example.decapcms.com  # User configures this
  auth_endpoint: admin/auth

media_folder: public/uploads
public_folder: /uploads

site_url: https://{client-domain-placeholder}
display_url: https://{client-domain-placeholder}
logo_url: /logo.png

collections:
  - label: "Pages"
    name: "pages"
    folder: "content/pages"
    format: "frontmatter"
    create: true
    fields:
      - { label: "Title", name: "title", widget: "string" }
      - { label: "Slug", name: "slug", widget: "string" }
      - { label: "Content", name: "body", widget: "markdown" }

  # (If dynamic-content-grid detected):
  - label: "Products"
    name: "products"
    folder: "content/products"
    format: "frontmatter"
    create: true
    fields:
      - { label: "Product Name", name: "name", widget: "string" }
      - { label: "Description", name: "description", widget: "text" }
      - { label: "Price", name: "price", widget: "number" }
```

**Create placeholder content directories:**

```bash
mkdir -p ./{project-name}/content/pages
mkdir -p ./{project-name}/content/products           # if needed
mkdir -p ./{project-name}/public/uploads
```

### Step 7 — Setup GitHub Workflows (CI/CD Template)

**Important:** If `.github/workflows/` already exists and CI/CD is already working, preserve it.

In that case:
- inspect existing workflow names, triggers, and deploy strategy,
- do NOT overwrite workflows automatically,
- only add missing workflow files if the user explicitly approves,
- write a note in the roadmap: `Existing CI/CD preserved`.

**Copy workflow templates from blueprints:**

```bash
mkdir -p ./{project-name}/.github/workflows/
cp blueprints/infra/workflows/build.yml              ./{project-name}/.github/workflows/build.yml
cp blueprints/infra/workflows/deploy.yml             ./{project-name}/.github/workflows/deploy.yml
```

**In `build.yml`, ensure:**
- Trigger: on push to `main` branch
- Steps: dotnet restore → dotnet build → dotnet test
- Artifact: publishes `publish/` folder

**In `deploy.yml`, ensure:**
- Trigger: manual workflow dispatch (for now)
- Steps: pull artifact → upload to VPS via SCP/rsync
- Status: writes to `current_state-{project-name}.json` (optional)

**Configure secrets (prompt user):**

```
⚠️  GitHub Secrets Required for Deploy:

Add these to github.com/{username}/{project-name}/settings/secrets/actions:

VPS_HOST       = your.vps.ip.or.domain
VPS_USER       = debian_user (e.g., 'deploy')
VPS_SSH_KEY    = (private key from your VPS, base64 encoded)
VPS_APP_PATH   = /opt/apps/{project-name}/

USER ACTION REQUIRED:
Go to: https://github.com/{username}/{project-name}/settings/secrets/actions
Add each secret above.

Once done, run:
  git push origin main
  
This will trigger build.yml, which should complete successfully.
```

### Step 8 — Create Initial Commit and Push

**Stage all files:**

```bash
cd ./{project-name}/
git add .
git status  # Verify all files staged
```

**Commit with standard message:**

```bash
git commit -m "chore: init WFO project scaffold — $(date +%Y-%m-%d)

- Initialize .NET 9 Razor Pages project
- Setup Decap CMS admin structure
- Seed GitHub Actions CI/CD pipelines
- Enforce project-code-only repository boundary

Ready for Phase 2 (Build)."
```

**Push to GitHub:**

```bash
# Never embed PAT in remote URL. Use standard remote and authenticated environment.
# Preferred non-interactive push when needed:
# git -c http.extraHeader="Authorization: Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}" push origin main
git push origin main
```

**Monitor GitHub Actions:**

```
Head to: https://github.com/{username}/{project-name}/actions
Should see: build.yml triggered automatically
Expected: ✅ Build succeeded (or ⚠️ warnings only)
```

If build fails in Actions:
- Check build.yml logs
- Common issues: missing SDK version, NuGet restore failure
- Fix locally, commit, and retry push

### Step 9 — Update current_state.json in Hub (Orchestrator Context)

**In workspace root, update `current_state-{project-name}.json`:**

```json
{
  "project": "{project-name}",
  "phase": "build",
  "active_skill": "project-scaffolding",
  "active_agent": "@Architect",
  "last_completed_step": "project-scaffolding → Step 8: Initial commit pushed",
  "next_step": "spec-driven-architecture → Step 1 (awaiting approval)",
  
  "repo_url": "https://github.com/{username}/{project-name}.git",
  "repo_mode": "new | existing | adopted",
  "repo_created_at": "YYYY-MM-DD HH:MM:SS",
  "repo_branch": "main",
  "build_status": "pending-first-run",
  
  "token_budget_remaining": X,
  "roadmap_ref": "PROJECT_ROADMAP-{project-name}.md"
}
```

Do NOT copy `current_state-{project-name}.json` into the client repository.
State files remain in hub/orchestrator workspace only.

### Step 10 — Verify Repository is Ready

**Checklist:**

```bash
# In workspace root:
cd ./{project-name}/

# 1. .NET project builds
dotnet build

# 2. Files present
ls -la Program.cs
ls -la *.csproj
ls -la .github/workflows/
ls -la wwwroot/admin/config.yml

# 3. Git state
git log --oneline  # Should show initial commit
git branch -a      # Should show main

# 4. GitHub Actions status
git ls-remote --heads origin
# Manually check: https://github.com/{username}/{project-name}/actions
```

**Success criteria:**
- ✅ Repo exists on GitHub (private)
- ✅ Git remote is reachable (`git ls-remote --heads origin`)
- ✅ .csproj builds without errors
- ✅ Decap config.yml exists
- ✅ Initial commit present
- ✅ GitHub Actions workflow triggered (at least pending)

---

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll create the repo manually later." | No. Repo creation must happen in this skill to bootstrap CI/CD and ensure the roadmap is version-controlled alongside code. |
| "Decap config can be written later." | Wrong. Decap is a mandatory baseline. Missing it breaks content architecture assumptions. Setup now. |
| "Let's skip the initial commit." | No. A clean initial state is required for diff-based code review and phase transitions. Always commit scaffold. |
| "Blueprints are outdated; I'll rewrite .NET boilerplate." | Don't. Use blueprints as-is. If they're broken, fix them in `blueprints/code/` ONCE, and all future projects benefit. |
| "GitHub Actions workflow is production-only." | Partially right. The workflow is seeded now but not executed until Phase 2 build is ready. That's correct. |
| "I don't need to set GitHub Secrets; deploy can happen later." | Secrets MUST be set before the first deploy workflow runs. Prompt user now, they complete it in a separate session. |
| "User doesn't care which repo URL we use." | Wrong. Repo URL is part of project identity and must match the {project-name} slug for clarity and CI/CD routing. |

---

## Red Flags

- Repository URL does not match `{project-name}` slug — naming conflict will cause confusion
- GitHub auth fails (`gh auth status` shows "not authenticated") — cannot create repos
- `.csproj` file contains unsubstituted template variables (e.g., `{{PROJECT_NAME}}` still in XML) — build will fail
- `wwwroot/admin/config.yml` is missing or empty — Decap setup incomplete
- `.github/workflows/` directory exists but files are empty or lack required steps — CI/CD will not trigger
- Existing repo has working CI/CD but workflow files are overwritten anyway — operational regression
- Existing repo is already deployed and `PathBase`, Nginx route, or service model are changed without explicit migration plan
- Initial commit message does not mention "WFO" or date — hard to track which tool created it in future audits
- Hub `current_state-{project-name}.json` is not updated after scaffold completes — session resume loses phase context
- Repo is created as PUBLIC instead of PRIVATE — security issue
- Build workflow succeeds but deploy workflow fails silently — no notification to user

---

## Verification

The owning agent (@Architect) completes this checklist and writes evidence directly into `PROJECT_ROADMAP-{project-name}.md` before issuing a GO signal to the next agent (@Developer).

- [ ] Repository exists on GitHub — evidence: `gh repo view {project-name}` output or browser screenshot
- [ ] Repository is PRIVATE — evidence: GitHub settings page shows "Private" label
- [ ] Repository is cloned locally — evidence: `ls -la ./{project-name}/` shows .git/ folder and recent commit
- [ ] `.NET 9 project builds locally** — evidence: `dotnet build` output showing ✅ successful build
- [ ] `.NET 9 project builds locally` — evidence: `dotnet build` output showing ✅ successful build
- [ ] `.csproj` has correct project name — evidence: `grep "<RootNamespace>" ./{project-name}/{project-name}.csproj`
- [ ] `wwwroot/admin/config.yml` exists and is valid YAML — evidence: `cat wwwroot/admin/config.yml` (no parse errors)
- [ ] `current_state-{project-name}.json` remains in hub only (not copied to client repo)
- [ ] `PROJECT_ROADMAP-{project-name}.md` remains in hub only (not copied to client repo)
- [ ] `.github/workflows/build.yml` is present and triggers on push — evidence: `grep "on:" ./{project-name}/.github/workflows/build.yml`
- [ ] If repo existed before WFO adoption, existing CI/CD was assessed and either preserved or changed with explicit approval
- [ ] If repo is new, scaffold files were copied from `/blueprints/**` with token substitution only (no generated custom logic)
- [ ] Initial commit is present with WFO signature — evidence: `git log --oneline | head -1` shows "WFO" mention
- [ ] Hub's `current_state-{project-name}.json` updated to `phase: "build"` — evidence: `cat current_state-{project-name}.json | grep "phase"`
- [ ] User has been shown GitHub Secrets requirements — evidence: prompt output shown to user
- [ ] User confirmed repo creation (if new) OR acknowledged existing repo (if resuming) — evidence: user reply in chat

---

## Next Step

Once verification is complete, the GO signal is issued:

```
[✅ GO] @Architect → @Developer | project-scaffolding DONE | YYYY-MM-DD

Repository {project-name} is initialized and ready for build phase.
Next: spec-driven-architecture skill will generate implementation specs per roadmap phase.
```
