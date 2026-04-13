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

| Variable | Description | Example |
|---|---|---|
| `{{DOMAIN}}` | Primary domain for the site | `purewipe.com` |
| `{{APP_NAME}}` | Project slug — matches service name | `pure-wipe` |
| `{{KESTREL_PORT}}` | Localhost port Kestrel listens on | `5000` |
| `{{SUBPATH}}` | URL subpath or `/` for root domain | `/` or `/purewipe/` |
| `{{VPS_HOST}}` | VPS IP or SSH hostname | `192.168.1.10` |
| `{{VPS_USER}}` | SSH deploy user (non-root) | `deploy` |
| `{{DEPLOY_DIR}}` | App directory on VPS | `/var/www/pure-wipe` |
| `{{DOTNET_VERSION}}` | From stack decision in roadmap | `9.0` |

Read `current_state-{project-name}.json` and `PROJECT_ROADMAP-{project-name}.md` first.  
`{{APP_NAME}}` = `project` field from state. `{{DOTNET_VERSION}}` = `target_framework` stripped of `net` prefix.

Ask the operator for any values not present in those files.

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
Create or update `.github/workflows/deploy.yml`:

```yaml
name: Deploy — {{APP_NAME}}

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: '{{DOTNET_VERSION}}'

      - name: Restore
        run: dotnet restore

      - name: Build
        run: dotnet build --configuration Release --no-restore

      - name: Publish
        run: dotnet publish --configuration Release --output ./publish --no-build

      - name: Deploy to VPS via rsync
        uses: burnett01/rsync-deployments@7.0.1
        with:
          switches: -avzr --delete
          path: publish/
          remote_path: ${{ secrets.DEPLOY_DIR }}
          remote_host: ${{ secrets.VPS_HOST }}
          remote_user: ${{ secrets.VPS_USER }}
          remote_key: ${{ secrets.VPS_SSH_KEY }}

      - name: Restart service
        uses: appleboy/ssh-action@v1.0.3
        with:
          host: ${{ secrets.VPS_HOST }}
          username: ${{ secrets.VPS_USER }}
          key: ${{ secrets.VPS_SSH_KEY }}
          script: sudo systemctl restart {{APP_NAME}}
```

**Required GitHub repository secrets** — record in `deploy/README.md`:

| Secret | Value |
|---|---|
| `VPS_HOST` | VPS IP or hostname |
| `VPS_USER` | SSH deploy user |
| `VPS_SSH_KEY` | Full private key (ed25519 or RSA) — no passphrase |
| `DEPLOY_DIR` | Path on VPS, e.g. `/var/www/pure-wipe` |

> ⚠️ If the repo already has a working `.github/workflows/deploy.yml`, compare it against this template before overwriting. In adoption mode, preserve the existing workflow unless the operator explicitly approves replacement.

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
| `VPS_HOST` | VPS IP or hostname |
| `VPS_USER` | SSH deploy user (non-root) |
| `VPS_SSH_KEY` | Private SSH key — no passphrase |
| `DEPLOY_DIR` | e.g. `/var/www/{project-name}` |

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
