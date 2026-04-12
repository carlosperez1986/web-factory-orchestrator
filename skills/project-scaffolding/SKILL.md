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
- Project state and roadmap files (copied from hub)
- Decap CMS admin schema structure (`wwwroot/admin/config.yml`)
- CI/CD pipeline scaffolding (GitHub Actions)
- Initial commit to bootstrap the build workflow

This skill bridges Phase 1 (analysis in central hub) to Phase 2 (development in client repo).

If the project already has a repository with working code and CI/CD, this skill switches to an adoption mode:
- preserve existing application code,
- preserve existing `.github/workflows/` unless user explicitly approves replacement,
- import the project into WFO by adding `current_state-{project-name}.json` and `PROJECT_ROADMAP-{project-name}.md`,
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

**Confirm with user (required):**

```
"Repository for {project-name}: DOES NOT EXIST YET.

I will run:
  gh repo create {project-name} --private --clone

This will:
1. Create a PRIVATE repository on github.com/{username}/{project-name}
2. Clone it locally to ./{project-name}/

Confirm? (yes/no)"
```

**Only proceed if user replies "yes" or "confirm".**

**Execute creation:**

```bash
gh repo create {project-name} --private --clone
# Waits for repo to be ready on GitHub
# Clones locally
```

**Capture repo URL and update state:**

```json
"repo_url": "https://github.com/{username}/{project-name}.git",
"repo_created_at": "YYYY-MM-DD HH:MM:SS (UTC)"
```

**If `gh repo create` fails:**
- Check GitHub auth: `gh auth status`
- Check network: `gh repo view`
- Ask user to create repo manually and provide clone URL in next session
- Set `repo_status: "pending-manual-creation"`

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

### Step 4 — Copy Project State and Roadmap Files

**Copy from hub (workspace root) to repo:**

```bash
# From workspace root
cp PROJECT_ROADMAP-{project-name}.md ./{project-name}/
cp current_state-{project-name}.json ./{project-name}/
```

**Verify files exist in repo:**

```bash
ls -la ./{project-name}/current_state-{project-name}.json
ls -la ./{project-name}/PROJECT_ROADMAP-{project-name}.json
```

**Expected output:** Both files present and readable.

### Step 5 — Initialize .NET 9 Project Scaffold

**Important:** This step only performs a full scaffold copy for NEW repositories.

If the repository already contains a working application:
- do NOT replace `Program.cs`, `.csproj`, `Pages/`, `Models/`, `Services/`, or `.github/workflows/` by default,
- compare the live structure against WFO blueprints,
- only add missing baseline artifacts,
- record all deviations in the roadmap,
- if modernization is needed (for example .NET 8 to .NET 9), propose it as a later roadmap task instead of silently rewriting the project.

**Copy .NET boilerplate from blueprints:**

```bash
cp -r blueprints/code/Program.cs.template               ./{project-name}/Program.cs
cp -r blueprints/code/Startup.cs.template               ./{project-name}/Startup.cs
mkdir -p ./{project-name}/evidence
echo "# Evidence — see WFO evidence/README.md for convention" > ./{project-name}/evidence/README.md
cp -r blueprints/code/Models/                            ./{project-name}/Models/
cp -r blueprints/code/Services/ContentService.cs        ./{project-name}/Services/
cp -r blueprints/code/Pages/                             ./{project-name}/Pages/
cp    blueprints/code/.gitignore                         ./{project-name}/.gitignore
cp    blueprints/code/.csproj.template                  ./{project-name}/{project-name}.csproj
```

**Template substitutions (required):**

In `.csproj`:
- Replace `{{PROJECT_NAME}}` with `{project-name}` (title-cased for namespace)
- Replace `{{DOTNET_VERSION}}` with target framework from roadmap (e.g., `net9.0`)

In `Program.cs`:
- Replace `{{PROJECT_NAME}}` with namespace
- Ensure `app.MapRazorPages()` is configured

**Verify .NET project structure:**

```bash
cd ./{project-name}/
dotnet --version                # Must satisfy target framework used by the repo or roadmap
dotnet build --dry-run          # Syntax check only
```

If build fails:
- Check .csproj for malformed XML
- Check namespace mismatches
- Run `dotnet clean` and retry

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
- Add project state and roadmap

Ready for Phase 2 (Build)."
```

**Push to GitHub:**

```bash
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

**Also in repo, update `current_state-{project-name}.json`:**

```json
{
  "...same as above...",
  "repo_initialized_at": "YYYY-MM-DD HH:MM:SS",
  "scaffold_location": "github.com/{username}/{project-name}"
}
```

### Step 10 — Verify Repository is Ready

**Checklist:**

```bash
# In workspace root:
cd ./{project-name}/

# 1. .NET project builds
dotnet build

# 2. Files present
ls -la Program.cs Startup.cs
ls -la .github/workflows/
ls -la wwwroot/admin/config.yml

# 3. Git state
git log --oneline  # Should show initial commit
git branch -a      # Should show main

# 4. GitHub Actions status
gh repo view {project-name} --web  # Opens browser to repo
# Manually check: https://github.com/{username}/{project-name}/actions
```

**Success criteria:**
- ✅ Repo exists on GitHub (private)
- ✅ Local clone is up-to-date
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
- `current_state-{project-name}.json` is not updated after scaffold completes — session resume loses phase context
- Repo is created as PUBLIC instead of PRIVATE — security issue
- Build workflow succeeds but deploy workflow fails silently — no notification to user

---

## Verification

The owning agent (@Architect) completes this checklist and writes evidence directly into `PROJECT_ROADMAP-{project-name}.md` before issuing a GO signal to the next agent (@Developer).

- [ ] Repository exists on GitHub — evidence: `gh repo view {project-name}` output or browser screenshot
- [ ] Repository is PRIVATE — evidence: GitHub settings page shows "Private" label
- [ ] Repository is cloned locally — evidence: `ls -la ./{project-name}/` shows .git/ folder and recent commit
- [ ] `.NET 9 project builds locally** — evidence: `dotnet build` output showing ✅ successful build
- [ ] `.csproj` has correct project name — evidence: `grep "<RootNamespace>" ./{project-name}/{project-name}.csproj`
- [ ] `wwwroot/admin/config.yml` exists and is valid YAML — evidence: `cat wwwroot/admin/config.yml` (no parse errors)
- [ ] `current_state.json` is copied to repo — evidence: `head -5 ./{project-name}/current_state-{project-name}.json`
- [ ] `PROJECT_ROADMAP.md` is copied to repo — evidence: `head -10 ./{project-name}/PROJECT_ROADMAP-{project-name}.md`
- [ ] `.github/workflows/build.yml` is present and triggers on push — evidence: `grep "on:" ./{project-name}/.github/workflows/build.yml`
- [ ] If repo existed before WFO adoption, existing CI/CD was assessed and either preserved or changed with explicit approval
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
