# WFO Quickstart & Runbook

## What is WFO?

The **Web Factory Orchestrator** (WFO) is an agentic pipeline that:

1. **Analyzes** client briefs (Phase 1: Define)
2. **Plans** implementation with cost/time estimates
3. **Generates** GitHub repos with .NET scaffolding (Phase 2: Build)
4. **Deploys** to production on Debian VPS (Phase 3: Deploy)

**Key:** Analysis stays in central hub. Code lives in per-client repos.

---

## Quick Start: 2 Minutes

### Step 1: Invoke Orchestrator

```
User (in Copilot Chat):

@Orchestrator new project
```

or

```
@Orchestrator help
```

### Step 2: Provide Briefing (One of These)

**Option A — Paste text:**
```
@Orchestrator

Client: Pure Wipe S.L.
Business: Professional cleaning service
Scope: Website with contact form, services catalog, portfolio gallery
...
(paste full briefing)
```

**Option B — File name:**
```
@Orchestrator new project — use /inbox/briefing.md
```

**Option C — PDF (if supported):**
```
@Orchestrator new project — [attach PDF]
```

### Step 3: Wait for Roadmap

Orchestrator runs `briefing-synthesis` + `project-estimation` internally.  
You'll see:
- Detected motives (lead gen, catalog, etc.)
- Sitemap with 3–7 pages
- Cost forecast & .NET version
- Next: "Proceed or changes?"

### Step 4: Approve

```
Proceed
```

### Step 5: Watch Repo Creation

```
Repository creation starting...
Creating: github.com/user/pure-wipe
...
✅ Repo ready at https://github.com/user/pure-wipe
```

If the repo already exists and is already working:

```
Existing repository detected: github.com/carlosperez1986/purewipe
Assessing current codebase and CI/CD...
✅ Existing workflow preserved
✅ WFO state files imported
✅ Project adopted into WFO governance
```

### Step 6: Next Phase

Orchestrator asks you to verify build or continue with code specs.

---

## Multi-Project Management

### Scenario: You're Working on 3 Clients

```
Session 1 @ 09:00
→ @Orchestrator help
→ Lists: pure-wipe (build), acme-corp (define), zephyr-digital (deploy)
→ User: "Resume acme-corp"
→ Orchestrator resumes acme-corp roadmap approval step

Session 2 @ 14:00 (next day)
→ @Orchestrator help
→ Same list shown
→ Different user OR same user selects different project
→ No context loss — each project has independent state file
```

**Key:** Each project has:
- `current_state-{name}.json` (in hub)
- `PROJECT_ROADMAP-{name}.md` (in hub)
- Matching repo on GitHub (for Phase 2+)

---

## Full Journey: Phase 1 → 3

### Phase 1: Define (in Hub) — ~15 min

```
briefing-synthesis
  ↓
project-estimation-and-stack-selection
  ↓
"Review roadmap. Reply 'Proceed'."
  ↓
(User: Proceed)
  ↓
Hub state: phase = "define" ✅
```

### Phase 2: Build (in Repo) — ~1–2 hours

```
project-scaffolding
  ↓
(Orchestrator creates repo or clones existing)
  ↓
(If repo already works, preserve code + workflows and adopt it)
  ↓
(Copies state/roadmap into repo)
  ↓
(Runs look-and-feel-ingestion from image/URL/Stitch input)
  ↓
(Writes DESIGN_STYLE_CONTRACT-{project-name}.md)
  ↓
(Creates GitHub Issues/workboard via github-project-bootstrap)
  ↓
Hub state: phase = "build" ✅
Repo: Initial commit pushed to main
  ↓
@Developer assumes repo ownership for feature implementation
spec-driven-architecture
  ↓
content-service-and-data-wiring
  ↓
integrate-ui-component
  ↓
seo-aio-optimization
  ↓
(User: Code review complete, ship it)
```

### Phase 3: Deploy (VPS + Repo) — ~30–45 min

```
security-audit
  ↓
(Scans dependencies, secrets, and hardening posture)
  ↓
(vps-provisioning sets up Nginx, Systemd, domain)
  ↓
(Pulls code to VPS)
  ↓
Hub state: phase = "deployed" ✅
Site live: https://client-domain.com
```

---

## Important Commands

### List Active Projects

```
@Orchestrator help
```

Shows all `current_state-*.json` files + current phase.

### Resume Specific Project

```
@Orchestrator resume acme-corp
```

or

```
@Orchestrator
```
then select from list.

### Start New Project

```
@Orchestrator new project
```

### Check Project Status

```
@Orchestrator status pure-wipe
```

Reads `current_state-pure-wipe.json` and shows:
- Current phase
- Active skill
- Last completed step
- Tokens remaining

---

## File Locations

### Central Hub (This Workspace)

📁 `web-factory-orchestrator/`

```
current_state-pure-wipe.json          ← Per-project state
PROJECT_ROADMAP-pure-wipe.md          ← Per-project roadmap
current_state-acme-corp.json
PROJECT_ROADMAP-acme-corp.md
...
/docs/architecture-overview.md        ← This architecture
/docs/wfo-flowcharts.md               ← Diagrams
/skills/briefing-synthesis/SKILL.md   ← Phase 1 analysis
/skills/project-scaffolding/SKILL.md  ← Phase 2 initiation
/blueprints/code/                     ← .NET templates
/blueprints/infra/                    ← Nginx, Systemd templates
```

### Per-Project Repo (GitHub)

📁 `github.com/user/pure-wipe/`

```
Program.cs                            ← .NET entry point
/Pages/                               ← Razor Pages (per sitemap)
/Models/, /Services/
/wwwroot/admin/config.yml             ← Decap CMS configuration
current_state-pure-wipe.json          ← Copy from hub
PROJECT_ROADMAP-pure-wipe.md          ← Copy from hub
.github/workflows/                    ← CI/CD (build.yml, deploy.yml)
```

---

## Decision Tree: "Should I Resume or Start New?"

```
Q: "I've worked on this client before."
   ├─ A1: "I'm continuing from where I left off"
   │      → @Orchestrator resume {project-name}
   │
   └─ A2: "I'm starting over with a new brief"
          → @Orchestrator new project

Q: "I'm not sure if this is a new client or existing."
   ├─ A1: Run @Orchestrator help
   │      Lists all current_state-*.json
   │      If {project-name} appears → resume
   │      If not in list + name is new → new project
   │
   └─ A2: Start fresh anyway (old state stays in hub)

Q: "The repo already exists on GitHub but I don't see state in hub."
   → new project (WFO won't know about it)
  → But in Phase 2, project-scaffolding will detect the GitHub repo
   → You'll be asked: "Use existing repo?" → Confirm
  → Old repo will be cloned, assessed, and updated with state files

Q: "The repo already has CI/CD and is deployed."
  → WFO adopts it instead of recreating it
  → Existing workflows stay as source of truth unless you explicitly approve a change
  → WFO adds governance: roadmap, state tracking, modernization backlog
```

---

## Troubleshooting

### "I don't see my project in the list"

**Cause:** `current_state-{project-name}.json` might be named differently.

**Fix:**
```
Check workspace root:
ls current_state-*.json

If you see: current_state-pure_wipe.json (underscore)
But named it: pure-wipe (dash)
→ File naming convention: use DASHES, not underscores
→ Rename and retry
```

### "GitHub repo creation failed"

**Cause:** Git not authenticated.

**Fix:**
```
gh auth status

If "not authenticated":
  gh auth login
  (Follow prompts to authenticate GitHub account)
  
Then retry @Orchestrator project-scaffolding
```

### "Build workflow in GitHub Actions failed"

**Cause:** Possible issues:
- Missing .csproj substitutions
- NuGet restore timeout
- SDK version mismatch

**Fix:**
```
Check locally first:
cd ./pure-wipe/
dotnet build

If fails locally, fix there first, then:
git add . && git commit -m "fix: .csproj issue"
git push origin main

GitHub Actions will re-trigger on push.
```

### "Decap CMS config.yml has errors"

**Cause:** YAML syntax issue (likely indentation).

**Fix:**
```
cd ./pure-wipe/wwwroot/admin/
cat config.yml | head -20  # Check structure

Use online YAML validator:
https://www.yamllint.com/

Fix indentation, then:
git add config.yml && git commit -m "fix: decap config indentation"
git push origin main
```

### "State file is out of sync (hub ≠ repo)"

**Cause:** Phase 1 was edited in hub but repo wasn't updated.

**Fix:**
```
In hub (workspace root):
Rebuild current_state-{project-name}.json manually or 
ask Orchestrator to re-run last skill step.

Then:
cp current_state-{project-name}.json ./pure-wipe/
cd ./pure-wipe/
git add current_state-{project-name}.json
git commit -m "update: current state from hub"
git push origin main
```

---

## Key Rules to Remember

1. **Phase 1 stays in hub.** Don't commit code to hub; it clutters orchestration state.

2. **Each project gets own repo.** No monorepo. Isolation = repeatability.

3. **State files are the source of truth.** If confused about project status, read `current_state-{project-name}.json`.

4. **Blueprints are read-only.** Don't edit them per-project. They're templates.

5. **GitHub Secrets required for deploy.** Set them BEFORE Phase 3 begins.

6. **Commit messages must mention WFO.** Helps track tool-generated commits later.

7. **Never delete `current_state-*.json` files manually.** Orchestrator relies on them for resume logic.

---

## Next: Create a Project

Ready to create your first WFO project?

```
1. Open Copilot Chat in VS Code
2. Type: @Orchestrator new project
3. Paste your client brief
4. Wait for roadmap
5. Reply: Proceed
6. Watch repo creation
7. repo is ready!
```

**Estimated time:** 5–10 minutes for Phase 1 + Phase 2 scaffolding.

Questions? Check:
- `docs/architecture-overview.md` — System design
- `docs/wfo-flowcharts.md` — Visual decision flows
- `skills/*/SKILL.md` — Skill details
