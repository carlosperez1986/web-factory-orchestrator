# Skill Anatomy

This document describes the structure and format of every skill file in the WFO `/skills` directory.  
Skills are **execution workflows** — not checklists, not docs. An agent follows a skill the way a technician follows a maintenance procedure: step by step, with evidence at every checkpoint.

Use this as the authoritative reference when contributing new skills or when `@Architect` generates one automatically. Non-compliant skills are rejected by the Orchestrator without execution.

```text
┌──────────────────────────────────────────────────────────────┐
│  SKILL.md                                                    │
│                                                              │
│  ┌─ Frontmatter ──────────────────────────────────────────┐  │
│  │  name:        lowercase-hyphen-name                    │  │
│  │  description: Use when [trigger condition]             │  │
│  │  owner:       @AgentRole                               │  │
│  │  phase:       define | build | deploy                  │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                              │
│  Overview             →  What this skill produces           │
│  When to Use          →  Trigger conditions + exclusions    │
│  Handover Requirement →  GO signal the agent must receive   │
│  Process              →  Numbered, atomic, verifiable steps │
│  Common Rationalizations → Excuses + hard rebuttals         │
│  Red Flags            →  Signs the skill is being violated  │
│  Verification         →  Evidence checklist before GO out   │
└──────────────────────────────────────────────────────────────┘
```

---

## File Location

Every skill lives in its own directory under `skills/`:

```text
skills/
  skill-name/
    SKILL.md              # Required: The skill definition
    supporting-ref.md     # Optional: Reference material, loaded on demand
```

The directory name must match the `name` frontmatter field exactly.  
The Orchestrator discovers skills by scanning this directory tree — a mismatch between directory name and `name` will cause the skill to be invisible to routing.

---

## SKILL.md Format

### Frontmatter (Required)

```yaml
---
name: skill-name-with-hyphens
description: >
  Brief statement of what the skill produces (third person).
  Use when [specific trigger condition]. Maximum 1024 characters.
owner: "@AgentRole"
phase: "define | build | deploy"
---
```

**Field rules:**

| Field | Rule |
|---|---|
| `name` | Lowercase, hyphen-separated. Must match the directory name exactly. |
| `description` | Starts with what the skill produces; ends with trigger condition. Do **not** embed workflow steps here — agents read this to decide *whether* to load the skill, not *how* to follow it. |
| `owner` | The single agent persona that executes this skill (e.g. `@Developer`, `@DevOps`). One owner per skill — if two agents are involved, split into two skills. |
| `phase` | One of: `define`, `build`, `deploy`. Maps directly to the Skills Dictionary phases in `README.md`. |

**Why `description` discipline matters:** The Orchestrator injects `description` into context to route skills. If the description contains process steps, the agent may follow the summary instead of loading the full skill — defeating the purpose of progressive disclosure.

---

### Standard Sections

Every `SKILL.md` must contain these sections in this order:

```markdown
# Skill Title

## Overview
One or two sentences. What does executing this skill produce, and why does it matter?

## When to Use
- Triggering condition 1 (symptom or task type that signals this skill is needed)
- Triggering condition 2
- **NOT for:** [exclusion scenario] — use [other-skill-name] instead.

## Handover Requirement
What the previous agent must have delivered before this skill may begin.
Exact GO signal format required in `PROJECT_ROADMAP.md`.

## Process

### Step 1 — [Action Verb + Noun]
Exact, unambiguous instruction. Reference blueprint files by relative path:
`blueprints/infra/nginx-vhost.conf`

### Step 2 — [Action Verb + Noun]
...

## Common Rationalizations
| Rationalization | Reality |
|---|---|
| "I can skip this step for a simple site." | Complexity is assessed after the step, not before. Run it. |
| "I'll add the Auditor review at the end." | The Auditor gates every component. Batching creates unfixable debt. |

## Red Flags
- Observable sign that the skill is being short-circuited
- Pattern to catch during @Auditor review

## Verification
After all steps are complete, the owning agent writes evidence for each item
into `PROJECT_ROADMAP.md` before issuing a GO signal to the next agent.

- [ ] [Exit criterion — include the exact evidence type required]
- [ ] [Another criterion]
- [ ] @Auditor sign-off recorded in `PROJECT_ROADMAP.md`
```

---

## Section Purposes

### Overview

The elevator pitch for the skill. Answers: *What tangible artifact or state does completing this skill produce?*  
Two sentences maximum. Do not list steps. Do not explain *why* the technology exists — explain what the agent delivers.

**Good:** "Produces a `config.yml` that maps every C# content model to a Decap CMS collection."  
**Bad:** "Decap CMS is a Git-based headless CMS that allows content editing without a database."

---

### When to Use

Helps the Orchestrator decide if this skill applies to the current context. Include:
- **Positive triggers:** specific symptoms or task states that activate the skill.
- **Negative exclusions:** scenarios this skill does NOT cover, with the name of the skill that does.

Exclusions prevent the Orchestrator from applying the wrong skill when two skills have overlapping descriptions.

---

### Handover Requirement

**WFO-specific. Required in every skill.**

Enforces the Agent Handover Protocol: no agent begins executing a skill without a written GO signal from the previous agent owner. This section states precisely what must exist in `PROJECT_ROADMAP.md` before the current skill may start.

Format:
```text
Requires: @[PreviousAgent] has completed `[previous-skill-name]`.
GO signal must be present in PROJECT_ROADMAP.md:
[✅ GO] @PreviousAgent → @ThisAgent | previous-skill DONE | YYYY-MM-DD
```

If this is the first skill in the chain (e.g. `briefing_synthesis`), write:  
`Requires: Human operator has placed a client PDF in /inbox.`

**Why it matters:** Without this gate, agents start working in parallel or on incomplete inputs. The Handover Requirement is the primary mechanism preventing race conditions in the agentic pipeline.

---

### Process

The heart of the skill. A numbered sequence of steps the agent follows exactly. Each step must be:

- **Specific**: name the exact command, file, or artifact produced.
- **Atomic**: one action per step, one observable outcome.
- **Verifiable**: the outcome can be confirmed with evidence before the next step begins.
- **Blueprint-aware**: if the step uses a template, reference it by exact relative path. Do not inline blueprint content.

| Quality | Good | Bad |
|---|---|---|
| Specific | "Run `dotnet build` — confirm `Build succeeded. 0 Error(s)`." | "Build the project." |
| Atomic | "Open `Models/*.cs` and list all public properties." | "Understand the data model." |
| Verifiable | "Output `ls wwwroot/admin/config.yml` to confirm the file exists." | "The file should be there." |
| Blueprint-aware | "Use `blueprints/code/decap-collection-template.yml` as base." | "Follow the standard template." |

---

### Common Rationalizations

The most important anti-laziness mechanism in the WFO. These are the excuses agents generate to justify skipping steps, alongside factual rebuttals that override them.

Think of every shortcut ever taken — "I'll do it later", "it's too simple to need this step", "the client won't notice" — and add it here with a hard counter-argument.

**WFO baseline rationalizations** (include when relevant to the skill):

| Rationalization | Reality |
|---|---|
| "I'll add the Decap CMS config after the UI is done." | The config is the content model. The UI depends on it. Building without it is building on sand. |
| "Entity Framework would be faster to prototype." | EF is banned — zero exceptions. Git-based JSON/MD is the only data layer. |
| "The @Auditor review can wait until the full feature is done." | The Auditor gates every component individually. Batching creates accumulated unfixable security and quality debt. |
| "I'll assume the Nginx template is fine." | Assumptions don't survive production. Run `security_audit`. It takes 5 minutes. A misconfigured Nginx block costs hours. |
| "Bootstrap 5 doesn't cover this pattern, I'll write custom CSS." | Bootstrap 5 covers this. Verify in the official docs before writing a single line of custom CSS. |
| "I'll complete the verification checklist at the end." | Each verification step confirms the previous step's output is valid before the next depends on it. Deferral breaks the chain. |

---

### Red Flags

Observable signs that the skill is being violated. Used by `@Auditor` during review and by the Orchestrator during self-monitoring.

**Universal WFO red flags** (always watch for these):
- A step is claimed complete with no CLI evidence in `PROJECT_ROADMAP.md`
- A GO signal is written before the Verification checklist is 100% ticked
- An agent references a blueprint "the standard way" without citing the exact file path
- Custom CSS appears in any output from `@FrontendUI`
- A `current_state-{project-name}.json` entry is missing `last_completed_step` after a step transition

Skill-specific red flags belong in each individual `SKILL.md`, not here.

---

### Verification

The exit gate. The owning agent completes this checklist and writes evidence for every item directly into `PROJECT_ROADMAP.md` before issuing a GO signal to the next agent.

Every checkbox must specify its evidence type. "Looks good" and "seems right" are never evidence.

**Accepted evidence types:**

| Type | Format |
|---|---|
| CLI output | Paste the exact relevant lines (trim noise, keep signal) |
| Build log | `Build succeeded. 0 Error(s). 0 Warning(s).` |
| File existence | `Get-ChildItem path/to/file` or `ls -la path/to/file` |
| Schema validation | No errors in browser console at the validated URL |
| @Auditor sign-off | Written sentence in `PROJECT_ROADMAP.md` by `@Auditor` |

---

## Supporting Files

Create a supporting file in the same skill directory only when:

- Reference material exceeds **100 lines** and would bloat the main `SKILL.md`
- A reusable code template or config snippet is needed for a specific step
- A checklist is long enough to be loaded independently

Keep patterns and principles inline in `SKILL.md` when they are under 50 lines.

**Loading rule:** The Orchestrator does **not** load supporting files automatically. A step in the `Process` section must explicitly cite the file path. This preserves the progressive disclosure model and keeps context windows lean.

```text
skills/
  vps-provisioning/
    SKILL.md                        # Entry point — always loaded first
    nginx-hardening-checklist.md    # Loaded only by Step 4 of the Process
```

---

## Writing Principles

1. **Process over knowledge.** Skills are workflows agents execute, not reference documents they read. Write steps, not facts.
2. **Specific over general.** "`dotnet build` → 0 errors" beats "verify the build". Name the command. Name the file. Name the expected output.
3. **Evidence over assertion.** Every verification checkbox requires proof. State the exact form the proof takes, not just the claim.
4. **Anti-rationalization.** Every step that an agent might be tempted to skip needs a counter-argument in the Rationalizations table.
5. **Progressive disclosure.** `SKILL.md` is the entry point. Supporting files and blueprint files are referenced by path and loaded only when the step that requires them is reached.
6. **Token-conscious.** Every section and sentence must justify its presence. If removing it would not change agent behavior, remove it.
7. **One owner.** A skill has exactly one `owner`. If two agents must collaborate, model it as two separate skills with a Handover between them.

---

## Naming Conventions

| Item | Convention | Example |
|---|---|---|
| Skill directory | `lowercase-hyphen-separated` | `vps-provisioning/` |
| Skill file | `SKILL.md` (always uppercase) | `SKILL.md` |
| Supporting files | `lowercase-hyphen-separated.md` | `nginx-hardening-checklist.md` |
| Blueprint files | `lowercase-hyphen-separated` in subdirectory | `blueprints/infra/nginx-vhost.conf` |
| References (shared) | stored in `references/` at the repo root | `references/decap-widget-types.md` |

References are **shared across skills**. They live at the repo root in `references/`, not inside any skill directory. A skill that needs a reference cites it by path — it does not copy the content.

---

## Orchestrator Validation

Before the Orchestrator activates any skill, it runs this quick check. A skill that fails any item is rejected and `@Architect` is notified to fix the skill file before retrying.

- [ ] Frontmatter has `name`, `description`, `owner`, and `phase` — all present and correctly typed
- [ ] `name` matches the skill's directory name exactly
- [ ] `description` does not contain numbered steps or workflow instructions
- [ ] `phase` is one of: `define`, `build`, `deploy`
- [ ] `Handover Requirement` section is present and specifies a GO signal format
- [ ] `Process` section has at least one numbered step
- [ ] Every step references a blueprint or supporting file by path (when applicable), not by inference
- [ ] `Common Rationalizations` table has at least two entries
- [ ] `Verification` has at least one item citing its evidence type
- [ ] Final verification item includes `@Auditor sign-off`

---

## Cross-Skill References

Reference other skills by name, not by file path:

```markdown
If the PRD is not yet written, run `spec-driven-architecture` first.
If the build fails during this step, follow the `debugging-and-error-recovery` skill.
```

Do **not** duplicate content between skills. Reference and link — never copy. Duplication creates maintenance debt and introduces divergence between skill versions.

---

## Minimal Valid Example

A complete, passing `SKILL.md` for reference. Copy this structure when authoring a new skill.

```markdown
---
name: decap-cms-config
description: >
  Generates a Decap CMS config.yml mapped 1:1 to the project's C# content models
  and JSON/MD file structure. Use when Razor Pages are finalized and @Developer
  needs to wire the Git-based content layer before UI assembly begins.
owner: "@Developer"
phase: "build"
---

# Decap CMS Config

## Overview
Produces a valid `config.yml` that maps every C# content model to a Decap CMS
collection, enabling editors to manage content without touching code or running
a database.

## When to Use
- Razor Pages and C# models are approved in the PRD by `@Architect`
- `PROJECT_ROADMAP.md` contains a GO signal from `@Architect` → `@Developer`
- **NOT for:** modifying an existing `config.yml` — use `decap-cms-update` instead.

## Handover Requirement
Requires: `@Architect` has completed `spec-driven-architecture`.  
GO signal must be present in `PROJECT_ROADMAP.md`:
`[✅ GO] @Architect → @Developer | spec-driven-architecture DONE | YYYY-MM-DD`

## Process

### Step 1 — Read the C# content models
Open every file matching `Models/*.cs`. For each class, list all `public`
properties with their CLR types. Do not proceed to Step 2 until the full list
is written out in `PROJECT_ROADMAP.md`.

### Step 2 — Map each model to a Decap collection
For each model, create a `collections` entry in `config.yml` using
`blueprints/code/decap-collection-template.yml` as the base structure.
Collection `name` must exactly match the C# class name (PascalCase → kebab-case).

### Step 3 — Validate all field-to-widget mappings
Confirm: `string` → `widget: string`, `bool` → `widget: boolean`,
`List<T>` → `widget: list`, `DateTime` → `widget: datetime`.
No property may be left without a mapped widget field.

### Step 4 — Write and stage the file
Output to `wwwroot/admin/config.yml`. Run `git diff wwwroot/admin/config.yml`
and confirm all mappings are present before staging.

## Common Rationalizations
| Rationalization | Reality |
|---|---|
| "I'll wire the CMS config after the UI sections are built." | The config defines the content structure the UI depends on. Building without it causes rework. |
| "I'll approximate field names and align them later." | 1:1 mapping is a hard requirement. Approximations silently break the content pipeline at runtime. |
| "The content model is simple, I don't need to reference the template." | Consistency across projects is enforced by the template. Use it. |

## Red Flags
- `config.yml` contains `widget: string` for a property that is `List<T>` in C#
- A collection `name` in `config.yml` does not match its C# model class name
- Step 1 list of properties was never written to `PROJECT_ROADMAP.md`

## Verification
- [ ] `config.yml` passes Decap CMS schema validation — no console errors at `/admin/`
- [ ] Every `public` property in `Models/*.cs` has a matching `widget` in `config.yml`
- [ ] File exists at `wwwroot/admin/config.yml` — evidence: `Get-ChildItem wwwroot/admin/config.yml` output
- [ ] `git diff` shows only intended changes — no stray fields
- [ ] @Auditor sign-off written in `PROJECT_ROADMAP.md`
```
