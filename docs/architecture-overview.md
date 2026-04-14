# WFO Architecture Overview — Multi-Project Agentic Pipeline

## Visual Architecture

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                    WEB FACTORY ORCHESTRATOR (Central Hub)                       │
│                   github.com/user/web-factory-orchestrator                      │
│                                                                                  │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │ Orchestrator Agent (@Orchestrator, @Analyst, @Architect, etc.)           │  │
│  │ - Session Start Protocol (detect active projects)                        │  │
│  │ - Skill execution pipeline                                               │  │
│  │ - Repository detection & creation                                        │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                  │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │ Project State Files (per-client analysis & roadmap)                      │  │
│  │                                                                           │  │
│  │  current_state-pure-wipe.json          ← phase, active_skill, tokens    │  │
│  │  PROJECT_ROADMAP-pure-wipe.md          ← sitemap, phases, tasks          │  │
│  │                                                                           │  │
│  │  current_state-acme-corp.json          ← phase, active_skill, tokens    │  │
│  │  PROJECT_ROADMAP-acme-corp.md          ← sitemap, phases, tasks          │  │
│  │                                                                           │  │
│  │  current_state-client-c.json           ← ...                             │  │
│  │  PROJECT_ROADMAP-client-c.md           ← ...                             │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                  │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │ Skills Library (read-only, shared)                                       │  │
│  │  - briefing-synthesis/SKILL.md                                           │  │
│  │  - project-estimation-and-stack-selection/SKILL.md                       │  │
│  │  - spec-driven-architecture/SKILL.md                                     │  │
│  │  - look-and-feel-ingestion/SKILL.md                                     │  │
│  │  - project-scaffolding/SKILL.md                                          │  │
│  │  ... etc.                                                                │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                  │
│  ┌──────────────────────────────────────────────────────────────────────────┐  │
│  │ Blueprints (templates, read-only)                                        │  │
│  │  - blueprints/code/roadmap-template.md                                   │  │
│  │  - blueprints/code/.NET-project-template/                               │  │
│  │  - blueprints/infra/nginx-config.template                               │  │
│  │  ... etc.                                                                │  │
│  └──────────────────────────────────────────────────────────────────────────┘  │
│                                                                                  │
│  Git: Commit state after each phase milestone                                  │
│  Convention: "Phase N complete: {project-name} — {milestone-name}"             │
│                                                                                  │
└─────────────────────────────────────────────────────────────────────────────────┘
              ↓↓↓ (When Phase 1 approved & ready to scaffold) ↓↓↓


┌───────────────────────────────────┐  ┌───────────────────────────────────┐
│  pure-wipe Repository             │  │  acme-corp Repository             │
│  github.com/user/pure-wipe        │  │  github.com/user/acme-corp        │
│                                   │  │                                   │
│  ├── .NET Project (Program.cs)    │  │  ├── .NET Project (Program.cs)    │
│  ├── Razor Pages (/Pages/)        │  │  ├── Razor Pages (/Pages/)        │
│  ├── Models & Services            │  │  ├── Models & Services            │
│  ├── wwwroot/admin/config.yml     │  │  ├── wwwroot/admin/config.yml     │
│  ├── current_state-pure-wipe.json │  │  ├── current_state-acme-corp.json │
│  ├── PROJECT_ROADMAP-pure*.md     │  │  ├── PROJECT_ROADMAP-acme*.md     │
│  ├── .github/workflows/           │  │  ├── .github/workflows/           │
│  └── README.md (WFO metadata)     │  │  └── README.md (WFO metadata)     │
│                                   │  │                                   │
│ Built from:                       │  │ Built from:                       │
│ · roadmap state from hub          │  │ · roadmap state from hub          │
│ · blueprints/code/*.template      │  │ · blueprints/code/*.template      │
│ · blueprints/infra/*.template     │  │ · blueprints/infra/*.template     │
│                                   │  │                                   │
| CI/CD: GitHub Actions             │  │ CI/CD: GitHub Actions             │
│ Deploy: Debian 11 VPS (Nginx)     │  │ Deploy: Debian 11 VPS (Nginx)     │
│                                   │  │                                   │
└───────────────────────────────────┘  └───────────────────────────────────┘
```

---

## Pipeline Phases

### Phase 1: Define (Analysis + Planning)
**Location:** Central WFO workspace  
**Owner:** @Analyst → @Architect  
**Skills:**
1. `briefing-synthesis` — Extract intent, sitemap, features
2. `project-estimation-and-stack-selection` — Token/time/cost forecast, .NET version
3. `spec-driven-architecture` — Specification document per phase

**Output:**
- `PROJECT_ROADMAP-{project-name}.md` with all phases
- `current_state-{project-name}.json` with phase = "define"
- User approval checkpoint: "Proceed" to go to Phase 2

**Artifacts Left in Hub:**
- Roadmap reference
- State tracking
- Cost/estimation snapshot

---

### Phase 2: Build (Scaffolding + Code Generation)
**Location:** Per-client repository (NEW)  
**Owner:** @Developer, @FrontendUI  
**Skills:**
4. `project-scaffolding` — Detect/adopt existing GitHub repo (manual creation prerequisite)
5. `look-and-feel-ingestion` — Capture style from image/URL/Stitch and generate design style contract
6. `github-project-bootstrap` — Convert roadmap/spec into issues and board tracking
7. `content-service-and-data-wiring` — Implement models/services/PageModel bindings
8. `integrate-ui-component` — Build Razor + Bootstrap sections using style contract
9. `seo-aio-optimization` — Apply Schema.org, AIO meta, and sitemap polish

**Orchestrator Decision Point (NEW):**
```
User initiates Phase 2 from approved roadmap in hub

↓

Orchestrator asks (or auto-detects):
  "Repository for {project-name}?"
  
  Option A: "Use existing repo: github.com/user/{project-name}"
    → Clone it → Assess codebase and CI/CD → Copy state/roadmap → Continue without overwriting working infrastructure
    
  Option B: "Create new repo"
    → User creates repo manually in GitHub Web
    → User provides repo URL to Orchestrator
    → Orchestrator resumes at clone/adoption
    → Continue to Step 5
```

**Output:**
- Live .NET project in repo
- Decap CMS admin schema
- CI/CD pipeline seeded or preserved
- `current_state-{project-name}.json` phase = "build"
- README with setup instructions

### Real Reference Case: PureWipe

PureWipe is the first concrete reference architecture for WFO adoption mode.

Observed characteristics from the analysis:
- ASP.NET Core Razor Pages monolith
- target framework currently `net8.0`
- Decap CMS already integrated under `wwwroot/admin`
- GitHub OAuth flow already implemented with custom `/auth` and `/callback`
- GitHub Actions deploy pipeline already operational
- deployment under shared domain subpath using `PATH_BASE=/purewipe`

Implication for WFO:
- PureWipe should enter WFO through **repo adoption**, not greenfield scaffolding
- WFO must preserve the existing GitHub Actions workflow as the operational truth
- WFO should treat `.NET 8 → .NET 9` as a planned modernization task, not as an implicit scaffold rewrite
- WFO should record operational discrepancies such as legacy deploy files, secrets handling, and placeholder pages in the roadmap

---

### Phase 3: Deploy (Security + Infrastructure)
**Location:** Per-client repository + VPS  
**Owner:** @Auditor, @DevOps  
**Skills:**
8. `security-audit` → CVE scan, secrets check
9. `vps-provisioning` → Nginx, Systemd, domain setup

**Output:**
- Live site on Debian 11 VPS
- Nginx reverse proxy configured
- Systemd service running
- DNS + SSL cert
- Final `current_state-{project-name}.json` phase = "deploy"

---

## Multi-Project Session Management

### Session Start (Orchestrator Entry Point)

```
User:  "@Orchestrator help"

Orchestrator executes Session Start Protocol:

1. Search for current_state-*.json in workspace root
   ├─ current_state-pure-wipe.json             phase: build
   ├─ current_state-acme-corp.json             phase: define
   └─ current_state-client-c.json              phase: deployed

2. List active projects + current step:

   "Three active projects found:
   
   1. pure-wipe        @ Phase 2 Build — last: project-scaffolding
   2. acme-corp        @ Phase 1 Define — last: project-estimation
   3. client-c         @ Phase 3 Deploy — last: security-audit
   
   Which project to resume? (Enter name or 'new' for new project)"

3. User input: "acme-corp"

4. Orchestrator reads:
   - current_state-acme-corp.json (loads phase, active_skill, tokens)
   - PROJECT_ROADMAP-acme-corp.md (loads context)
   - Resumes from: project-estimation-and-stack-selection
   
   "Resuming acme-corp at Phase 1.
   Next: Awaiting user approval of estimation (Cost, .NET version, margin).
   Review roadmap above. Reply 'Proceed' or changes?"
```

---

## File Organization

### Central Hub (Current Workspace)
```
web-factory-orchestrator/
├── README.md                                      # Project overview
├── docs/
│   ├── skill-anatomy.md                          # SKILL.md format spec
│   ├── architecture-overview.md                  # (this file)
│   ├── wfo-quickstart.md                         # (planned)
│   └── wfo-runbook.md                            # (planned)
├── .github/
│   ├── agents/
│   │   ├── orchestrator.agent.md
│   │   ├── analyst.agent.md
│   │   ├── architect.agent.md                    # (planned)
│   │   ├── developer.agent.md                    # (planned)
│   │   └── ... (other agents)
│   └── copilot-instructions.md
├── skills/
│   ├── briefing-synthesis/SKILL.md
│   ├── project-estimation-and-stack-selection/SKILL.md
│   ├── spec-driven-architecture/SKILL.md         # (planned)
│   ├── project-scaffolding/SKILL.md              # (NEXT — requested)
│   └── ... (other skills)
├── blueprints/
│   ├── code/
│   │   ├── Program.cs.template
│   │   ├── Startup.cs.template
│   │   ├── roadmap-template.md
│   │   └── ... (.NET templates)
│   ├── infra/
│   │   ├── nginx.conf.template
│   │   ├── systemd.service.template
│   │   └── ... (infra templates)
│   └── ui/
│       ├── layout.html.template
│       └── ... (Bootstrap templates)
│
├── current_state-pure-wipe.json                  # Live project state
├── PROJECT_ROADMAP-pure-wipe.md                 # Live project roadmap
├── current_state-acme-corp.json
├── PROJECT_ROADMAP-acme-corp.md
└── ... (more project state files)
```

### Per-Project Repository (After Phase 1)
```
github.com/user/pure-wipe/
├── Program.cs
├── Startup.cs
├── /Pages/
│   ├── Index.cshtml
│   ├── Contacto.cshtml
│   └── ... (per sitemap)
├── /Models/
│   ├── ContentService.cs
│   └── ... (domain models)
├── /wwwroot/
│   ├── /admin/config.yml           # Decap CMS config (generated)
│   ├── /css/, /js/, /img/
│   └── ... (static assets)
├── .github/workflows/
│   ├── build.yml                   # CI/CD pipeline
│   └── deploy.yml
├── README.md                        # Setup/deploy instructions
├── current_state-pure-wipe.json    # Copy from hub
├── PROJECT_ROADMAP-pure-wipe.md    # Copy from hub
└── .gitignore
```

---

## State Transitions

```
START (User provides briefing)
  ↓
[briefing-synthesis]  → current_state.phase = "define"
  ↓
[project-estimation-and-stack-selection]  → current_state.phase = "define" (extended)
  ↓
USER APPROVAL GATE
  ↓
[NEW] project-scaffolding → Detect/Create repo, initialize .NET
  ↓
current_state.phase = "build"
  ↓
[spec-driven-architecture] → Generate specs per phase
[look-and-feel-ingestion] → Capture visual DNA from image/URL/Stitch
[github-project-bootstrap] → Create issues and board tracking
[content-service-and-data-wiring] → Implement models/services bindings
[integrate-ui-component] → Build UI components
[seo-aio-optimization] → Apply discoverability and schema
  ↓
USER CHECKPOINT: Code review
  ↓
[security-audit] → Scan dependencies, secrets
  ↓
current_state.phase = "deploy"
  ↓
[vps-provisioning] → Setup Nginx, Systemd, domain
  ↓
DEPLOYED ✅
```

---

## Key Decisions (This Architecture)

### Central Hub vs Distributed
✅ **Central Hub Strategy:**
- Analysis (Define phase) stays in `web-factory-orchestrator/`
- Code (Build/Deploy phases) lives in client repos
- Rationale: Orchestrator has one source of truth; projects don't pollute each other

### File Naming Convention
✅ **Project-Scoped Files:**
- `current_state-{project-name}.json`
- `PROJECT_ROADMAP-{project-name}.md`
- Rationale: Multi-project support, no UUID/hash confusion

### Repo Detection
✅ **Dual-Path Support (NEW):**
1. Existing repo: Clone → copy state/roadmap → continue
2. New repo: User creates manually in GitHub Web → shares URL → orchestrator resumes clone/adoption

### Blueprints as Read-Only Library
✅ **No Dynamic Template Mutations:**
- Blueprints are source; never modified by skills
- Each project gets a **copy** (not reference) from blueprints
- Rationale: Rapid iterations + reproducibility

---

## Next Steps (Immediate)

1. ✅ Keep `look-and-feel-ingestion` mandatory before `integrate-ui-component`
2. ✅ Keep `DESIGN_STYLE_CONTRACT-{project-name}.md` as visual source of truth per project
3. 🔄 Add operator checklist for visual intake (image, URL, Stitch artifacts/token)
4. 🔄 Validate first end-to-end execution with PureWipe as reference project
