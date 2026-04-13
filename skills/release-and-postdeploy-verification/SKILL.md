---
name: release-and-postdeploy-verification
description: >
  Verifies the live production deployment after the first release. Confirms
  that the deployed site is reachable, static assets are served correctly,
  CMS admin access is available, and rollback readiness is documented.
phase: "deploy"
---

# Release and Post-deploy Verification

## Overview

Performs a live production verification after deployment artifacts have been
applied and the site is reachable. This skill confirms that the deployment
pipeline completed successfully, the site is healthy, and the rollback path is
clear before closing the deploy wave.

## When to Use

- `vps-provisioning` has completed and deploy artifacts are committed
- the first production deploy has been executed or a new release is live
- a production URL is available for validation
- `security-audit` has issued a GO signal for release
- **NOT for:** pre-production smoke checks or build-only QA

## Handover Requirement

```text
Requires: vps-provisioning has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] vps-provisioning PASSED | YYYY-MM-DD
```

## Inputs Required

This skill requires:
- `PROJECT_ROADMAP-{project-name}.md`
- `current_state-{project-name}.json`
- the production URL for the deployed site
- `deploy/nginx-{project-name}.conf` or equivalent deploy artifact context

If any required input is missing, stop and record a `BLOCKER`.

## Process

### Step 1 — Load Deployment State
Read:
- `current_state-{project-name}.json` → active skill, project slug, deploy target
- `PROJECT_ROADMAP-{project-name}.md` → deploy plan, release notes
- `deploy/nginx-{project-name}.conf` → expected host and path base

Confirm the production URL and any configured subpath.

### Step 2 — Verify Live Site Availability
Check:
- root URL responds with HTTP 200
- key public pages respond with HTTP 200
- configured subpath routes resolve correctly if the app is hosted under a path base
- the site returns the correct page content type and expected title/metadata

If the site is not reachable, stop and record:
```
BLOCKER: production site unreachable — release verification failed.
```

### Step 3 — Validate Static Asset Delivery
Confirm that the live site serves:
- CSS, JavaScript, and image assets without 404/500 errors
- `favicon.ico` and browser metadata assets
- any hashed or versioned static resources referenced by the HTML

Document any asset failures or caching issues.

### Step 4 — Confirm CMS/Admin Route Access
If Decap CMS is in use:
- verify the CMS admin route responds, such as `/admin/`
- confirm the admin entry point loads without a server error
- verify the `wwwroot/admin/config.yml` file is present in the deployed repo if applicable

If admin login cannot be tested, at least confirm the route is reachable.

### Step 5 — Document Rollback Readiness
Verify that deployment rollback instructions exist in `deploy/README.md` or
another operator runbook. Confirm:
- the systemd service unit name is correct
- the deploy directory path is reachable
- the rollback command or service restart procedure is documented

If rollback guidance is missing, record a warning and add a task to fix it.

### Step 6 — Report and Close the Release
Produce a live verification summary in `PROJECT_ROADMAP-{project-name}.md`:
- production URL health status
- asset delivery summary
- admin/CMS route availability
- rollback readiness
- release verification conclusion

If the live verification passes, transition the next step to the next project
phase or mark the deployment wave complete.
