# 🤖 Web Factory Orchestrator (WFO)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Web Factory Orchestrator** is a single-agent, skills-driven system for autonomous web platform generation. One Orchestrator AI reads business requirements (PDFs/briefings), loads skills on demand, and executes the full pipeline — from briefing to deployed .NET 9 / Linux VPS platform — without delegating to agent personas.

## tl;dr

You provide a PDF. The **Master Orchestrator** takes over. It reads the requirements, runs `briefing-synthesis` to map out the architecture, creates a step-by-step `PROJECT_ROADMAP-{project-name}.md`, then executes each skill in sequence (`spec-driven-architecture`, `content-service-and-data-wiring`, `integrate-ui-component`, `seo-aio-optimization`). Only the security gate is delegated to a restricted `@Auditor` subagent. Strict adherence to established blueprints (Bootstrap 5, Decap CMS, Systemd, Nginx) is enforced by the skills themselves — not by agent personas.

## 📖 Documentation

New to WFO? Start here:
- **[Architecture Overview](docs/architecture-overview.md)** — System design, central hub vs distributed repos, Phase 1–3 pipeline
- **[Visual Flowcharts](docs/wfo-flowcharts.md)** — Mermaid diagrams of session start, repo creation, multi-skill pipeline
- **[Internal Agent Diagram (.drawio)](docs/wfo-orchestrator-internal-agents.drawio)** — Draw.io diagram of Orchestrator, Architect, DeliveryManager, and artifact-based collaboration
- **[Full User-Agent Flow (.drawio)](docs/wfo-full-flow-user-agent.drawio)** — End-to-end draw.io flow: user interaction, orchestration, skills, task creation, execution, and deploy
- **[Quickstart & Runbook](docs/wfo-quickstart.md)** — 2-minute intro, multi-project management, troubleshooting
- **[Main Orchestrator Manual](docs/main-orchestrator.md)** — deterministic command menu and fallback behavior for weak prompts
- **[Agentic Business Milestones](docs/agentic-business-milestones.md)** — high-level implementation milestones to reuse this logic in any business domain
- **[Agentic Org Chart Article Guide](docs/agentic-org-chart-article-guide.md)** — concepts, layered org chart, and publication structure for writing the agentic model article
- **[Agentic Knowledge Base Schema](docs/agentic-knowledge-base-schema.md)** — canonical KB schema for skills, agents, gates, and capability-gap decisions
- **[Skill and Agent Roadmap](docs/wfo-skill-agent-roadmap.md)** — Missing skills/agents, execution prerequisites, GitHub Projects model
- **[Process History](docs/wfo-process-history.md)** — Chronological build log for future Medium/LinkedIn writing
- **[Skill Anatomy](docs/skill-anatomy.md)** — How to write new SKILL.md files

For developers:
- Each skill is documented in `skills/<skill-name>/SKILL.md`
  - Current: `briefing-synthesis`, `project-estimation-and-stack-selection`, `project-scaffolding`, `spec-driven-architecture`, `content-model-and-decap-design`, `repo-adoption-assessment`, `implementation-batch-planning`, `look-and-feel-ingestion`, `github-project-bootstrap`, `content-service-and-data-wiring`, `integrate-ui-component`, `seo-aio-optimization`, `security-audit`, `quality-smoke-and-acceptance`, `vps-provisioning`, `release-and-postdeploy-verification`, `capability-gap-assessment`
  - Planned: none (core pipeline complete; execution hardening continues)

Execution history should live in each client repository through GitHub Issues + one GitHub Project board per website. The roadmap remains the design source of truth; the board is the delivery history.

## 🗂️ State Management

An Orchestrator without memory is just a chat window. The WFO maintains a `current_state-{project-name}.json` file at the project root to persist execution context across sessions — no conversation history required. This allows the orchestrator to manage multiple projects concurrently.

```json
{
  "project": "client-name-slug",
  "phase": "build",
  "active_skill": "project_scaffolding",
  "active_agent": "@Orchestrator",
  "last_completed_step": "spec_driven_architecture → DONE",
  "next_step": "project_scaffolding → Step 1: Init GitHub repo",
  "token_budget_remaining": 85000,
  "roadmap_ref": "PROJECT_ROADMAP-client-name-slug.md#step-3"
}
```

**Rules (Multi-Project Support):**
- The Orchestrator **must** update `current_state-{project-name}.json` after every completed skill step.
- On session resume, the Orchestrator **reads `current_state-{project-name}.json` first** before any other action.
- File naming: each project gets one state file, e.g. `current_state-pure-wipe.json`, `current_state-acme-corp.json`.
- The Orchestrator can manage multiple projects concurrently — read all `current_state-*.json` files and ask which project to resume.
- `token_budget_remaining` is a soft ceiling. When < 10 000, the Orchestrator emits a `⚠️ TOKEN WARNING` and suspends non-critical context.

## 🧠 The Master Orchestrator

You only talk to the **@Orchestrator**. The Orchestrator executes every skill directly — loading each `SKILL.md` on demand and following it step by step. There are no intermediate agent personas. The only exception is `@Auditor`, which runs with restricted tools (read + search + execute, no file edits) as a security gate before deployment.

**Skills executed by @Orchestrator:**

| Phase | Skill | Purpose |
| :--- | :--- | :--- |
| define | `briefing-synthesis` | Extract business intent, sitemap, roadmap skeleton |
| define | `project-estimation-and-stack-selection` | Token/time/cost estimate and stack decision |
| define | `spec-driven-architecture` | Convert roadmap into implementation-ready spec |
| build | `project-scaffolding` | Create or adopt repository, .NET scaffold, Decap seed |
| build | `look-and-feel-ingestion` | Capture style from image/URL/Stitch and produce design style contract |
| build | `github-project-bootstrap` | GitHub Issues + Project board from roadmap/spec |
| build | `content-service-and-data-wiring` | File-based models, services, Razor PageModel bindings |
| build | `integrate-ui-component` | Bootstrap-first page assembly from contracts |
| build | `seo-aio-optimization` | Metadata, Schema.org, internal linking, AIO structure |
| deploy | `security-audit` | Pre-deploy security gate (delegated to `@Auditor`) |
| deploy | `vps-provisioning` | Nginx, Systemd, SSL provisioning |

## 🤝 Contributing & Skill Creation

Whether you are a human adding a new capability or the `@Architect` agent generating a new workflow, all new skills added to the `/skills` directory must adhere to the WFO standard.

Skills must be:
- **Specific:** Actionable, deterministic steps. No vague advice.
- **Verifiable:** Clear exit criteria with evidence requirements (e.g., `dotnet build` succeeds).
- **Battle-tested:** Based on proven, real-world Debian 11 / .NET 9 deployments.
- **Minimal:** Only include what the agent strictly needs to execute the task.

See `docs/skill-anatomy.md` for the strict JSON/Markdown format specification required for all new skills.
## ⚙️ How Skills Work (The Anatomy)

To ensure deterministic behavior across the agentic team, every skill in the `/skills` directory follows a strict, standardized anatomy. The `@Orchestrator` relies on this structure to parse instructions and enforce execution.

```text
┌─────────────────────────────────────────────┐
│  SKILL.md                                   │
│                                             │
│  ┌─ Frontmatter ─────────────────────────┐  │
│  │ name: lowercase-hyphen-name           │  │
│  │ description: Use when [trigger]       │  │
│  │ owner: @AgentRole                     │  │
│  └───────────────────────────────────────┘  │
│                                             │
│  Overview         → What this skill does    │
│  When to Use      → Triggering conditions   │
│  Process          → Step-by-step workflow   │
│  Rationalizations → Excuses + rebuttals     │
│  Red Flags        → Signs something's wrong │
│  Verification     → Evidence requirements   │
└─────────────────────────────────────────────┘ 
```

**Handover Requirement:** No agent may begin executing a skill without an explicit `GO` signal written by the previous agent owner into `PROJECT_ROADMAP.md`. The `GO` entry must include: the completed skill name, a one-sentence context summary, and the receiving agent's name. Agents that start work without a `GO` signal are considered to be operating outside the sanctioned workflow and their output is invalid.

```text
 <!-- Example handover entry in PROJECT_ROADMAP.md -->
[✅ GO] @Architect → @Developer
Skill completed: spec_driven_architecture
Context: PRD approved. 3 Razor Pages defined (Home, Services, Contact).
Handover to: @Developer → Begin project_scaffolding
```

## 🧠 Core Agentic Design Principles (The WFO Directives)

To prevent AI laziness, hallucination, and token waste, the Master Orchestrator and all sub-agents MUST operate under these strict design choices:

- **Process, not prose:** Skills are actionable workflows that agents follow sequentially, not reference documents they read. Each skill has strict steps, checkpoints, and exit criteria.
- **Anti-rationalization:** AI agents are prone to laziness. Every skill includes a list of common excuses (e.g., "I'll add the UI library later", "I'll assume the Nginx config is fine") with documented counter-arguments forcing immediate execution.
- **Verification is non-negotiable:** Every skill ends with hard evidence requirements. "It seems right" or "The code looks good" is never sufficient. We require proof: CLI output, passing build logs, or exact JSON schema validation.
- **Progressive disclosure:** The Master Orchestrator only loads `SKILL.md` files when explicitly needed. Supporting templates (from `/blueprints`) are fetched only during the execution phase, keeping API token usage minimal and context windows clean.

### ⛔ Hard Constraints (Non-Negotiable)

These are absolute prohibitions baked into every agent's operating context. Violation is grounds for immediate task rollback.

| Constraint | Rule | Rationale |
|---|---|---|
| **No SQL / No ORM** | `Entity Framework`, `SQLite`, `PostgreSQL` — banned. Git-based JSON/MD files are the only data layer. | Eliminates infra complexity and maintains the 850€/web margin. |
| **No heavy JS** | If Bootstrap 5 or native browser APIs can do it, no external JS library is permitted. | Swiper.js and AOS are whitelisted. Everything else requires explicit `@Architect` approval. |
| **Auditor gate is mandatory** | Every component, page, and config file **must** pass `security_audit` before it is marked `DONE`. | "It looks fine" is not a delivery standard. |
| **No custom CSS for standard components** | `@FrontendUI` is forbidden from writing custom CSS for any component that Bootstrap 5 natively covers. | Prevents brand drift and unmaintainable overrides. |
| **No halted context** | The Orchestrator must never say "I'll continue in the next message." All work for a given step is completed atomically. | Prevents state drift and partial deliverables. |

## 🛠️ Skills Dictionary

The Orchestrator detects the situation and applies the exact skill required.

### Phase 1: Define - Clarify what to build
*Before any code is written, the Orchestrator must clarify the scope.*

| Skill | What It Does | Use When | Owner |
|-------|-------------|----------|-------|
| `briefing_synthesis` | Parses raw client PDFs/notes into structured entities, routes, and business logic. | You drop a new PDF in the `/inbox` and need a project scope. | `@Analyst` |
| `spec_driven_architecture` | Writes a strict PRD (Product Requirements Document) defining .NET 9 models, Razor Pages, and Git-CMS rules. | Starting a new project to ensure the Developer agent doesn't hallucinate databases. | `@Architect` |

### Phase 2: Build - Assemble the platform
*Code generation restricted by standard frameworks and blueprints.*

| Skill | What It Does | Use When | Owner |
|-------|-------------|----------|-------|
| `project_scaffolding` | Generates a new GitHub repository and injects the .NET 9 / Decap CMS Blueprint. | The specs are approved and you need the base code. | `@Architect` |
| `integrate_ui_component` | Maps raw HTML to Bootstrap 5 / Swiper.js standard structures without custom CSS. | Building the visual frontend blocks. | `@FrontendUI` |
| `decap_cms_config` | Generates `config.yml` schemas mapped 1:1 to C# data models and JSON/MD files. | Connecting the UI to the Git-based backend. | `@Developer` |

### Phase 3: Deploy & Audit - Ship to production
*Zero-touch server configuration and quality checks.*

| Skill | What It Does | Use When | Owner |
|-------|-------------|----------|-------|
| `security_audit` | Scans Nginx templates and .NET configs for exposed secrets or misconfigurations. | Before handing off to DevOps. | `@Auditor` |
| `vps_provisioning` | Generates Nginx/Systemd files and pushes the deployment workflow to the target VPS. | The code is ready for the Debian 11 server. | `@DevOps` |


## � Project Structure

```text
web-factory-orchestrator/
├── inbox/                          # Drop client PDFs/briefings here
├── current_state-{project-name}.json        # Live execution state per project (Orchestrator memory)
├── PROJECT_ROADMAP.md              # Auto-generated per project; contains handover log
│
├── skills/                         # One directory per skill, one SKILL.md per dir
│   ├── briefing_synthesis/
│   ├── spec_driven_architecture/
│   ├── project_scaffolding/
│   ├── integrate_ui_component/
│   ├── decap_cms_config/
│   ├── security_audit/
│   └── vps_provisioning/
│
├── blueprints/                     # Read-only reference templates; never edited manually
│   ├── infra/                      #   Nginx vhost templates, Systemd unit files,
│   │                               #   GitHub Actions CI/CD YAMLs
│   ├── code/                       #   .NET 9 Clean Architecture boilerplate,
│   │                               #   ContentService.cs, BaseController.cs
│   └── ui/                         #   Bootstrap 5 base layout, Swiper.js wrappers,
│                                   #   StitchWithGoogle standard section templates
│
├── docs/
│   └── skill-anatomy.md            # Format spec for writing new skills
│
└── agents/                         # Persona definitions for Copilot / Cursor
    ├── orchestrator.md
    ├── analyst.md
    ├── architect.md
    ├── developer.md
    ├── frontend-ui.md
    ├── auditor.md
    └── devops.md
```

**Blueprint loading rule:** Agents reference files in `/blueprints` by path only. They do not read blueprint files until the exact step that requires them. This keeps context windows lean.

## 🚀 Usage: The "Vibe Coding" Trigger

Open your AI assistant (Cursor / Copilot Chat) inside this repository and fire this exact prompt:

```text
@workspace I have uploaded a new client PDF in `/inbox`. 
You are the Master Orchestrator. 
1. Read `current_state-{project-name}.json` — if a project is in progress, resume it. Match by `{project-name}` slug.
2. Otherwise, use `briefing_synthesis` to understand the project.
3. Coordinate with @Architect to use `spec_driven_architecture`.
4. Generate a step-by-step `PROJECT_ROADMAP.md`.
Wait for my approval before moving to Phase 2 (Build).
```
