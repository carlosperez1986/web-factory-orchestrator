# Web Factory Orchestrator (WFO) — Workspace Instructions

These instructions apply to every Copilot Chat interaction in this workspace.
They are the global constraints that no agent, prompt, or skill may override.

## What This Repository Is

This is the **Web Factory Orchestrator** — a skill-based agentic pipeline for building
and deploying .NET 9 / Decap CMS websites at a fixed 850€/site scope with an 85% margin.

The only human entry point is `@Orchestrator`. All other agents (@Analyst, @Architect,
@Developer, @FrontendUI, @Auditor, @DevOps) are invoked internally by the Orchestrator.

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
- **No task is DONE** without evidence written in `PROJECT_ROADMAP.md`.
- **No code is shipped** without `@Auditor` sign-off.
- **No Phase 2** begins without human operator approval of the Phase 1 roadmap.

## Session Resume

Every session in this workspace must begin with:
1. Check if `current_state.json` exists in the root.
2. If yes: read it and report the active project state before doing anything else.
3. If no: wait for the user to provide a briefing or PDF.

## Skill Loading

Skills are in `skills/<skill-name>/SKILL.md`.  
Load a skill only when the current step requires it. Never load all skills at once.

## File Structure Reference

```
inbox/                    ← Drop client briefings here
current_state.json        ← Orchestrator memory, updated after every skill step
PROJECT_ROADMAP.md        ← Auto-generated, contains GO signal handover log
skills/                   ← One SKILL.md per subdirectory
blueprints/infra/         ← Nginx, Systemd, GitHub Actions templates
blueprints/code/          ← .NET 9 boilerplate, ContentService.cs
blueprints/ui/            ← Bootstrap 5 layout, Swiper.js wrappers
.github/agents/           ← Custom Copilot agent definitions
docs/skill-anatomy.md     ← Spec for writing new skills
```
