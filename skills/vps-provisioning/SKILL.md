---
name: vps-provisioning
description: >
  Generates Nginx virtual host config, systemd service unit, and GitHub Actions
  deploy workflow for a .NET 9 Razor Pages app on Debian 11 VPS. Use after
  security-audit has issued a GO signal and before the first production deploy.
phase: "deploy"
---

# VPS Provisioning

## Overview
Produces all server-side configuration artifacts required to deploy the project to a Debian 11 VPS running Nginx + Kestrel (reverse proxy). Outputs are committed to the client repo and applied to the VPS by the operator.

This skill generates:
- `deploy/nginx-{project-name}.conf` — Nginx virtual host config (from blueprint)
- `deploy/{project-name}.service` — systemd service unit for the .NET app
- `.github/workflows/deploy.yml` — GitHub Actions CD pipeline
- `deploy/provision.sh` — one-time server setup script (directories, systemd enable)
- `deploy/README.md` — operator runbook for first deploy and subsequent rollbacks

## When to Use
- `security-audit` has completed and `@Auditor` issued a GO signal
- VPS target (IP or hostname) and domain name are known
- Client has confirmed final payment (per contract terms) or staging deploy is explicitly requested
- **NOT for:** local dev setup, Docker/container deployments, or cloud PaaS (Azure App Service, etc.)

## Handover Requirement

```text
Requires: security-audit has completed.
GO signal must be present in PROJECT_ROADMAP-{project-name}.md:
[✅ GO] @Auditor | security-audit PASSED | YYYY-MM-DD
```

## Inputs Required

Before starting, collect these values. If any are missing, stop and record a `BLOCKER`:

**Auto-resolved from state (no need to ask):**

| Variable | Source | Example |
|---|---|---|
| `{{APP_NAME}}` | `project` field in `current_state-{project-name}.json` | `purewipe` |
| `{{DOTNET_VERSION_GA}}` | `target_framework` stripped of `net` + `.x` appended | `9.0.x` |
| `{{DOTNET_RUNTIME_MAJOR}}` | `target_framework` stripped of `net` prefix | `9.0` |
| `{{APP_DLL}}` | Pascal-cased `{{APP_NAME}}` + `.dll` | `PureWipe.dll` |
| `{{PROJECT_PATH}}` | `./` + Pascal-cased `{{APP_NAME}}` + `.csproj` | `./PureWipe.csproj` |

**Collected from Orchestrator VPS intake (already in `current_state vps_config`):**

| Variable | Description | Example |
|---|---|---|
| `{{APP_PORT}}` | Kestrel localhost port | `5010` |
| `{{TARGET_DIR}}` | Absolute deploy path on VPS | `/var/www/purewipe` |
| `{{USE_SHARED_DOMAIN}}` | Topology A — shared domain | `true` or `false` |
| `{{SHARED_DOMAIN}}` | Base domain hosting multiple apps | `hechoenmargarita.com` |
| `{{SHARED_SITE_FILE}}` | Nginx sites-available filename | `hechoenmargarita.com` |
| `{{ROUTE_PREFIX}}` | URL prefix under shared domain | `/purewipe` |
| `{{USE_CUSTOM_DOMAIN}}` | Topology B — dedicated domain | `true` or `false` |
| `{{DOMAIN}}` | Custom domain (Topology B only) | `purewipe.com` |
| `{{CERT_DIR}}` | SSL cert directory (Topology B only) | `/etc/ssl/certs/purewipe` |
| `{{CERT_CRT}}` | SSL cert filename (Topology B only) | `SSL1234.pem` |
| `{{CERT_KEY}}` | SSL key filename (Topology B only) | `SSL1234.priv` |

Note: `USE_SHARED_DOMAIN` and `USE_CUSTOM_DOMAIN` are mutually exclusive. Set one to `true` and the other to `false`.  
If both are `false`, record `BLOCKER: no topology selected`.

## Process

### Step 1 — Load Provisioning Context
Read:
- `current_state-{project-name}.json` → `project`, `repo_url`
- `PROJECT_ROADMAP-{project-name}.md` → `target_framework`, `Stack Decision`
- Confirm `@Auditor` GO signal is present

Resolve all 8 input variables. Record any missing ones as `BLOCKER` with:
```
BLOCKER: {{VARIABLE_NAME}} not found — operator must supply before vps-provisioning can continue.
```

### Step 2 — Generate Nginx Config
Copy `blueprints/infra/nginx-config.template` to `deploy/nginx-{project-name}.conf`.

Apply substitutions:
- `{{DOMAIN}}` → resolved domain
- `{{APP_NAME}}` → project slug
- `{{KESTREL_PORT}}` → resolved port
- `{{SUBPATH}}` → `/` for root domain, or `/subpath/` for shared-server topology

**Subpath topology rules:**
- If `{{SUBPATH}}` is NOT `/`, the Nginx `location` block must proxy to `http://127.0.0.1:{{KESTREL_PORT}}{{SUBPATH}}`.
- The app's `Program.cs` must have `app.UsePathBase("{{SUBPATH}}")` added — record as a task for `@Orchestrator` if not already present.

Write the resolved file to `deploy/nginx-{project-name}.conf`.

Do NOT modify `blueprints/infra/nginx-config.template` — it is the WFO master template.

### Step 3 — Generate Systemd Service Unit
Create `deploy/{project-name}.service` with this template (substitutions applied):

```ini
[Unit]
Description={{APP_NAME}} .NET web application
After=network.target

[Service]
Type=notify
User={{VPS_USER}}
WorkingDirectory={{DEPLOY_DIR}}
ExecStart=/usr/bin/dotnet {{DEPLOY_DIR}}/{{APP_NAME}}.dll
Restart=always
RestartSec=5
KillSignal=SIGINT
SyslogIdentifier={{APP_NAME}}
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://127.0.0.1:{{KESTREL_PORT}}
Environment=DOTNET_ROOT=/usr/share/dotnet

[Install]
WantedBy=multi-user.target
```

Rules:
- `ExecStart` must point to the published `.dll`, not `dotnet run`.
- `ASPNETCORE_URLS` must match `{{KESTREL_PORT}}` exactly.
- `User` must be a non-root user on the VPS. Default: `deploy`. Warn if operator sets `User=root`.

### Step 4 — Generate GitHub Actions Deploy Workflow

Copy `blueprints/infra/deploy.yml.template` to `.github/workflows/deploy.yml`.

Apply all token substitutions from the inputs table above. Auto-resolved values:
- `{{APP_DLL}}` → Pascal-case the `APP_NAME` slug and append `.dll` (e.g., `purewipe` → `PureWipe.dll`)
- `{{PROJECT_PATH}}` → `./` + Pascal-cased name + `.csproj` (e.g., `./PureWipe.csproj`)
- `{{DOTNET_VERSION_GA}}` → from `target_framework` in roadmap, strip `net`, append `.x` (e.g., `net9.0` → `9.0.x`)
- `{{DOTNET_RUNTIME_MAJOR}}` → same as above without `.x` (e.g., `9.0`)

Topology rules:
- If `USE_SHARED_DOMAIN=true`: set `ROUTE_PREFIX`, `SHARED_DOMAIN`, `SHARED_SITE_FILE`; set `USE_CUSTOM_DOMAIN=false`; leave `DOMAIN`/`CERT_*` as empty strings.
- If `USE_CUSTOM_DOMAIN=true`: set `DOMAIN`, `CERT_DIR`, `CERT_CRT`, `CERT_KEY`; set `USE_SHARED_DOMAIN=false`; leave `SHARED_DOMAIN`/`ROUTE_PREFIX` as empty strings.

**GitHub credentials/config required** — record in `deploy/README.md` and instruct the operator to set them in repo Settings → Secrets and variables → Actions:

| Type | Name | Value | Required |
|---|---|---|---|
| Secret | `PASSWORD` | SSH password (also used for sudo escalation) | always |
| Variable (preferred) or Secret | `SERVER_IP` | VPS IP address or hostname | always |
| Variable (preferred) or Secret | `USERNAME` | SSH user with sudo rights | always |
| Variable (preferred) or Secret | `PORT` | SSH port | optional — defaults to 22 |

**Not secrets (topology/deploy context):**

These values are NOT credentials and must not be requested as GitHub Secrets by default.
They are collected in Orchestrator VPS intake (`current_state-{project-name}.json`) and substituted into the generated workflow/template:

| Value | Default storage | Notes |
|---|---|---|
| `USE_SHARED_DOMAIN` | hub state + workflow template | topology flag |
| `SHARED_DOMAIN` | hub state + workflow template | base domain |
| `SHARED_SITE_FILE` | hub state + workflow template | nginx sites-available file |
| `ROUTE_PREFIX` | hub state + workflow template | app path prefix under shared domain |
| `TARGET_DIR` | hub state + workflow template | VPS deploy path |
| `USE_CUSTOM_DOMAIN` | hub state + workflow template | topology flag |
| `DOMAIN` | hub state + workflow template | custom domain |
| `CERT_DIR`, `CERT_CRT`, `CERT_KEY` | hub state + workflow template | custom-domain cert paths/files |

Optional: teams may store non-secret values as GitHub Variables (`vars.*`) if they prefer runtime configurability,
but WFO default is deterministic template substitution from state.

> ⚠️ If the repo already has a working `.github/workflows/deploy.yml`, compare it against the template before overwriting. In adoption mode, preserve the existing workflow unless the operator explicitly approves replacement.

> ⚠️ The PASSWORD secret is used for SSH auth AND sudo escalation inside the provisioning script. The deploy user must have sudo rights on the VPS. If passwordless sudo is configured, the PASSWORD secret is still required for SSH auth.

### Step 5 — Generate One-Time Provision Script
Create `deploy/provision.sh` — operator runs this once on a fresh VPS:

```bash
#!/bin/bash
# provision.sh — one-time VPS setup for {{APP_NAME}}
# Run as: sudo bash provision.sh
set -e

APP_NAME="{{APP_NAME}}"
DEPLOY_DIR="{{DEPLOY_DIR}}"
VPS_USER="{{VPS_USER}}"
DOMAIN="{{DOMAIN}}"

echo "=== 1. Install .NET {{DOTNET_VERSION}} runtime ==="
wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update
apt-get install -y aspnetcore-runtime-{{DOTNET_VERSION}}

echo "=== 2. Install Nginx ==="
apt-get install -y nginx

echo "=== 3. Install Certbot ==="
apt-get install -y certbot python3-certbot-nginx

echo "=== 4. Create deploy user and directory ==="
id -u $VPS_USER &>/dev/null || useradd -m -s /bin/bash $VPS_USER
mkdir -p $DEPLOY_DIR
chown $VPS_USER:$VPS_USER $DEPLOY_DIR

echo "=== 5. Install Nginx config ==="
cp nginx-${APP_NAME}.conf /etc/nginx/sites-available/${APP_NAME}
ln -sf /etc/nginx/sites-available/${APP_NAME} /etc/nginx/sites-enabled/${APP_NAME}
nginx -t

echo "=== 6. Install systemd service ==="
cp ${APP_NAME}.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable $APP_NAME

echo "=== 7. Obtain TLS certificate ==="
echo "Run: certbot --nginx -d $DOMAIN -d www.$DOMAIN"
echo "=== provision.sh complete — run certbot manually to finish TLS ==="
```

### Step 6 — Generate Operator Runbook
Create `deploy/README.md` with:

```markdown
# Deploy Runbook — {project-name}

## First Deploy (one-time)
1. SSH into VPS as root
2. Upload `deploy/` folder: `scp -r deploy/ {vps_user}@{vps_host}:~/deploy-{project-name}/`
3. Run: `sudo bash provision.sh`
4. Set GitHub repository secrets (see table below)
5. Push to `main` — GitHub Actions will deploy automatically

## Subsequent Deploys
Push to `main`. The workflow builds, publishes, rsyncs, and restarts the service.

## Manual Rollback
```bash
# On VPS
cd /var/www/{project-name}
sudo systemctl stop {project-name}
# Restore previous publish dir from backup
sudo systemctl start {project-name}
```

## Required GitHub Secrets
| Secret | Description |
|---|---|
| `SERVER_IP` (Variable preferida, o Secret) | VPS IP o hostname |
| `USERNAME` (Variable preferida, o Secret) | SSH deploy user (non-root) |
| `PASSWORD` (Secret obligatorio) | SSH password (también para sudo) |
| `PORT` (Variable preferida, o Secret) | SSH port (opcional, default 22) |

## Not GitHub Secrets (context values)
| Value | Source |
|---|---|
| `SHARED_DOMAIN`, `SHARED_SITE_FILE`, `ROUTE_PREFIX` | Orchestrator VPS intake (`vps_config`) |
| `DOMAIN`, `CERT_DIR`, `CERT_CRT`, `CERT_KEY` | Orchestrator VPS intake (`vps_config`) |
| `TARGET_DIR`, `APP_PORT` | Orchestrator VPS intake (`vps_config`) |

These are deployment context values, not credentials. WFO writes them into generated files via token substitution.

## TLS Certificate Renewal
Certbot auto-renews. Verify timer: `systemctl status certbot.timer`

## Service Commands
```bash
sudo systemctl status {project-name}
sudo systemctl restart {project-name}
sudo journalctl -u {project-name} -f
```
```

### Step 7 — Verify PathBase if Subpath Topology
If `{{SUBPATH}}` is NOT `/`:

Check `Program.cs` in the client repo for:
```csharp
app.UsePathBase("{{SUBPATH}}");
```

If missing, record a task in `PROJECT_ROADMAP-{project-name}.md`:
```
TASK: Add app.UsePathBase("{{SUBPATH}}") to Program.cs before app.UseRouting()
Owner: @Orchestrator | Priority: BLOCKING for deploy
```

### Step 8 — Commit and Update State
Commit generated files to client repo:

```bash
git add deploy/ .github/workflows/deploy.yml
git commit -m "chore: add vps provisioning artifacts for {{APP_NAME}}"
git push
```

After push, deployment trigger behavior is automatic:
- Primary path: `push` to `main` triggers `.github/workflows/deploy.yml` automatically.
- Fallback path: if no new commit was created but secrets/variables are now available, trigger `workflow_dispatch` automatically via GitHub API/MCP.
- Do not ask the operator to push code manually if repository credentials are valid.

If fallback dispatch fails, record:
```
BLOCKER: deploy workflow_dispatch failed — verify Actions permissions and workflow file path.
```

Update `PROJECT_ROADMAP-{project-name}.md`:
- Add `[✅ GO] @Orchestrator | vps-provisioning DONE | YYYY-MM-DD`
- Add next step: `release-and-postdeploy-verification`

Update `current_state-{project-name}.json`:

```json
{
  "phase": "deploy",
  "active_skill": "release-and-postdeploy-verification",
  "active_agent": "@Orchestrator",
  "last_completed_step": "vps-provisioning → Step 7: all deploy artifacts committed",
  "next_step": "release-and-postdeploy-verification → Step 1",
  "deploy_artifacts_ref": "deploy/"
}
```

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "I'll configure Nginx directly on the server without a config file in the repo." | Config files that live only on the server are unreproducible. Every infrastructure artifact must be in the repo. |
| "The deploy user can be root — it's simpler." | Root SSH deploy access is a critical OWASP misconfiguration. Always use a non-root user. |
| "I'll add TLS later after the first deploy." | `nginx -t` will fail if the cert paths don't exist yet. Document this in the runbook and use the HTTP block only for the first test, then certbot immediately. |
| "The existing workflow is close enough — I'll just edit it manually." | In adoption mode, diff the existing workflow against the template and document every deviation. Silent overwrite is not acceptable. |

## Red Flags

- `ASPNETCORE_URLS` in the systemd unit does not match `{{KESTREL_PORT}}` in the Nginx config
- `deploy/` folder committed with real secrets (tokens, passwords) instead of `${{ secrets.* }}` references
- `User=root` in systemd unit
- Nginx config missing `X-Forwarded-Proto` header (breaks HTTPS detection in ASP.NET Core)
- `UsePathBase()` absent in `Program.cs` when subpath topology is used
- `blueprints/infra/nginx-config.template` modified instead of copying to `deploy/`

## Verification

- [ ] `deploy/nginx-{project-name}.conf` exists with all 4 substitutions applied
- [ ] `deploy/{project-name}.service` exists with `User` set to non-root
- [ ] `.github/workflows/deploy.yml` exists with all 4 secrets referenced (not hard-coded)
- [ ] `deploy/provision.sh` exists and is executable
- [ ] `deploy/README.md` exists with full runbook and secrets table
- [ ] If subpath topology: `UsePathBase()` present in `Program.cs` or BLOCKING task created
- [ ] All files committed and pushed to client repo
- [ ] `current_state-{project-name}.json` points to `release-and-postdeploy-verification`
- [ ] `@Auditor sign-off`: `security-audit` GO signal confirmed present before this skill ran
