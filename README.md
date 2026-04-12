# 🤖 Web Factory Orchestrator (WFO)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Web Factory Orchestrator** is a centralized, single-agent entry point for autonomous web ecosystem generation. It uses a master Orchestrator AI to read business requirements (PDFs/briefings), dynamically detect the required skills, and manage a team of specialized sub-agents to build and deploy .NET 9 / Linux VPS platforms.

## tl;dr

You provide a PDF. The **Master Orchestrator** takes over. It reads the requirements, triggers the *Definition Phase* to map out the architecture, creates a step-by-step `PROJECT_ROADMAP.md`, and then delegates tasks to its specialized personas (Developer, UI, DevOps, SEO). It forces strict adherence to established blueprints (Bootstrap 5, Decap CMS, Systemd, Nginx) avoiding hallucinations, zero-coding UI from scratch, and manual server configurations.

## 🧠 The Master Orchestrator & The Agentic Team

You only talk to the **@Orchestrator**. The Orchestrator automatically summons the following personas based on the context and the required skill:

| Persona | Domain | Responsibility |
| :--- | :--- | :--- |
| **🕵️ @Analyst** | Business Intel | Extracts entities, routes, and logic from raw briefings/PDFs. |
| **📐 @Architect** | System Design | Enforces .NET 8 standards, Git-based CMS structures, and API contracts. |
| **💻 @Developer** | Software Eng | Generates clean, modular C# code and Razor components. |
| **🎨 @Designer** | Visual Identity | Bridges Figma/StitchWithGoogle assets into technical UI specs. |
| **🧱 @FrontendUI** | UI Assembly | Integrates Bootstrap 5, Swiper.js, AOS. *Strictly forbidden to write custom CSS for standard components.* |
| **📈 @MarketingSEO**| AIO & Semantics | Implements Schema.org and LLM-friendly content structures. |
| **🛡️ @Auditor** | Quality & Sec | Validates Nginx hardening, SSL integrity, and code security before deployment. |
| **🚀 @DevOps** | Infrastructure | Executes VPS provisioning (Systemd, Nginx) and configures CI/CD. |

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

## 🧠 Core Agentic Design Principles (The WFO Directives)

To prevent AI laziness, hallucination, and token waste, the Master Orchestrator and all sub-agents MUST operate under these strict design choices:

- **Process, not prose:** Skills are actionable workflows that agents follow sequentially, not reference documents they read. Each skill has strict steps, checkpoints, and exit criteria.
- **Anti-rationalization:** AI agents are prone to laziness. Every skill includes a list of common excuses (e.g., "I'll add the UI library later", "I'll assume the Nginx config is fine") with documented counter-arguments forcing immediate execution.
- **Verification is non-negotiable:** Every skill ends with hard evidence requirements. "It seems right" or "The code looks good" is never sufficient. We require proof: CLI output, passing build logs, or exact JSON schema validation.
- **Progressive disclosure:** The Master Orchestrator only loads `SKILL.md` files when explicitly needed. Supporting templates (from `/blueprints`) are fetched only during the execution phase, keeping API token usage minimal and context windows clean.

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


## 🚀 Usage: The "Vibe Coding" Trigger

Open your AI assistant (Cursor / Copilot Chat) inside this repository and fire this exact prompt:

```text
@workspace I have uploaded a new client PDF in `/inbox`. 
You are the Master Orchestrator. 
1. Use `briefing_synthesis` to understand the project.
2. Coordinate with @Architect to use `spec_driven_architecture`.
3. Generate a step-by-step `PROJECT_ROADMAP.md`.
Wait for my approval before moving to Phase 2 (Build).
