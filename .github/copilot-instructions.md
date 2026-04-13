# Web Factory Orchestrator (WFO) — Workspace Instructions

These instructions apply to every Copilot Chat interaction in this workspace.
They are the global constraints that no agent, prompt, or skill may override.

## What This Repository Is

This is the **Web Factory Orchestrator** — a skill-based agentic pipeline for building
and deploying .NET 9 / Decap CMS websites at a fixed 850€/site scope with an 85% margin.

The only human entry point is `@Orchestrator`. It executes all skills directly.
The only specialized subagent is `@Auditor` — invoked by @Orchestrator for the security gate because
its `tools: [read, search, execute]` restriction (no `edit`) cannot be expressed in a skill.

## Technology Stack (Non-Negotiable)

| Layer | Technology | Alternatives |
|---|---|---|
| Backend | .NET 9 / Razor Pages | FORBIDDEN |
| Data | Git-based JSON/MD (Decap CMS) | SQL/ORM/EF — **BANNED** |
| CSS Framework | Bootstrap 5 | Custom CSS — FORBIDDEN for standard components |
| JS | Swiper.js, AOS (whitelisted) | Heavy JS bundles — FORBIDDEN unless @Architect approves |
| Server | Nginx + Systemd on Debian 11 VPS | Anything else — requires explicit approval |

## Global Hard Constraints

- **No SQL.** No Entity Framework. No SQLite. No PostgreSQL. No exceptions.
- **No custom CSS** for any component Bootstrap 5 covers natively.
- **No agent starts a skill** without reading its `SKILL.md` file first.
- **No task is DONE** without evidence written in `PROJECT_ROADMAP-{project-name}.md`.
- **No code is shipped** without `@Auditor` sign-off.
- **No Phase 2** begins without human operator approval of the Phase 1 roadmap.

## Session Resume

Every session in this workspace must begin with:
1. Check if any `current_state-*.json` files exist in the root (one per active project).
2. If yes: list all active projects and ask which to resume, or auto-detect from context.
3. If no: wait for the user to provide a briefing or PDF.

## Skill Loading

Skills are in `skills/<skill-name>/SKILL.md`.  
Load a skill only when the current step requires it. Never load all skills at once.

## Historical Documentation

This repository maintains a step-by-step historical log for future long-form writing.

Rules:
1. After any meaningful change to agents, skills, orchestration rules, architecture, or workflow design, append a new chronological entry to `docs/wfo-process-history.md`.
2. Each entry must record: what changed, why it was needed, architectural impact, files touched, and article notes.
3. Do not write the Medium or LinkedIn article here; only maintain reusable source material and historical traceability.
4. When a new skill is created, update both the chronological log and the `Skill Scope Notes` section in `docs/wfo-process-history.md`.

## File Structure Reference

```
inbox/                    ← Drop client briefings here
current_state-{project-name}.json       ← Live state per project; one file per active client; updated after each skill
PROJECT_ROADMAP-{project-name}.md      ← Auto-generated per project; one file per client; contains GO signal handover log
skills/                   ← One SKILL.md per subdirectory
blueprints/infra/         ← Nginx, Systemd, GitHub Actions templates
blueprints/code/          ← .NET 9 boilerplate, ContentService.cs
blueprints/ui/            ← Bootstrap 5 layout, Swiper.js wrappers
.github/agents/           ← Custom Copilot agent definitions
docs/skill-anatomy.md     ← Spec for writing new skills
docs/wfo-process-history.md ← Editorial source log for future Medium/LinkedIn articles
```
