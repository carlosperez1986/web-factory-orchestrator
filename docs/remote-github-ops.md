# Remote GitHub Ops Fallback (Actions)

This fallback is for remote sessions where Copilot cannot call GitHub write capabilities directly.

## What it does
It uses GitHub Actions (`workflow_dispatch`) plus a PAT secret to execute:
- create repository
- create issue
- create project (Project v2)

## One-time setup
1. Add repository secret `GH_TOKEN` in:
   `Settings -> Secrets and variables -> Actions`
   Backward-compatible fallback: `WFO_GH_PAT` is also accepted.
2. PAT scopes (classic minimum):
   - `repo`
   - `workflow`
   - `project`
   - `read:org` (recommended for org project owner resolution)

## Workflow location
- `.github/workflows/remote-github-ops.yml`

## How to run
1. Open `Actions -> Remote GitHub Ops -> Run workflow`.
2. Choose `operation`.
3. Fill required inputs:

### create-repo
- `repo_name` required
- `owner` optional (`org` if creating in organization)
- `visibility` optional (`private` default)

### create-issue
- `issue_repo` required (`owner/name`)
- `issue_title` required
- `issue_body` optional

### create-project
- `owner` required
- `project_title` required
- `project_owner_type` required (`user` or `org`)

## Outputs
The workflow emits:
- `resource_id`
- `resource_url`

And logs created resource metadata in the Actions run output.

## Notes
- This is a remote-only fallback and does not require local Visual Studio/VS Code tooling.
- If the action fails with 403/401, the PAT scopes or owner permissions are insufficient.
