# Evidence Folder — WFO Convention

This folder (and one in every client repository) holds machine-verifiable proof that
a task in the Task Registry was actually completed, not just marked done.

## Why it exists

The Task Registry in `PROJECT_ROADMAP-{project-name}.md` has an **Evidence Required** column.
Before `@Auditor` issues a GO signal, it reads that column and checks:

1. Does the file at the given path **exist** in the client repository?
2. Is it **non-empty**?
3. For `.log` files — does the content contain the expected **pass string**?

If any check fails, the task stays `pending` and the GO signal is withheld.

## File naming convention

| Task type | File name | Pass string check |
|-----------|-----------|-------------------|
| Nginx config test | `nginx-syntax.log` | must contain `syntax is ok` |
| Security audit report | `security-audit-report.md` | must contain `## Security Audit Findings` |
| Staging smoke test | `staging-smoke.md` | must contain `HTTP 200` on all checked routes |
| Form handler smoke test | `form-handler-smoke.md` | must contain `PASS` |
| SEO audit pass | `seo-audit-pass.md` | must contain `Schema.org: valid` |
| Page spec (Phase 1) | `spec-{page-slug}.md` | non-empty, must contain component list |
| Model review | `models-review.md` | non-empty, lists all approved C# model names |
| Production deploy | `prod-deploy.md` | must contain deployment timestamp + URL |

## Who writes evidence files

| Skill | Evidence file written |
|-------|-----------------------|
| `spec-driven-architecture` | `evidence/spec-{page-slug}.md` (one per page) |
| `content-service-and-data-wiring` | `evidence/models-review.md` |
| `integrate-ui-component` | appends to `evidence/spec-{page-slug}.md` |
| `seo-aio-optimization` | `evidence/seo-audit-pass.md` |
| `security-audit` | `evidence/security-audit-report.md` |
| `vps-provisioning` (Nginx step) | `evidence/nginx-syntax.log` |
| Manual smoke test | `evidence/staging-smoke.md`, `evidence/prod-deploy.md` |

## How @Auditor checks evidence

In `security-audit` skill Step 5a, the Orchestrator passes to @Auditor:

```
For each task in Task Registry where Status = "done":
  1. Read the "Evidence Required" path from the registry row
  2. Check: does that file exist in the client repository?
  3. Check: is the file non-empty?
  4. If the file is a .log: does it contain the expected pass string?
  5. If any check fails → reset task Status to "pending", log FAIL reason
```

## Hub vs Client repo

- This `evidence/` folder in the **WFO hub** is a placeholder and convention reference.
- Each **client repository** gets its own `evidence/` folder created during `project-scaffolding`.
- Evidence files are committed to the client repo along with code — they are build artifacts.

## Git usage

Evidence files should be committed with the message:
```
evidence: TASK-NNN — {brief description of what was verified}
```
