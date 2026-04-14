# Deploy Runbook — purewide3

**App:** Pure Wipe 3.0 · `.NET 9 / Razor Pages`  
**Topology:** Shared domain (route prefix `/purewide3`)  
**VPS:** Debian 11 · Nginx + Systemd · Port 5011  
**Repo:** https://github.com/carlosperez1986/purewide3.0

---

## Required GitHub Repository Secrets

Set these in **Settings → Secrets and variables → Actions** of `carlosperez1986/purewide3.0`:

| Secret | Description | Example |
|---|---|---|
| `SERVER_IP` | VPS IP address or hostname | `203.0.113.50` |
| `USERNAME` | SSH deploy user (must have `sudo` rights) | `deploy` |
| `PASSWORD` | SSH password — also used for `sudo -S` escalation | `••••••••` |
| `PORT` | SSH port (optional — defaults to 22) | `22` |
| `SHARED_DOMAIN` | Base domain hosting all apps | `tudominio.com` |
| `SHARED_SITE_FILE` | Filename in `/etc/nginx/sites-available/` | `tudominio.com` |

> ⚠️ The `USERNAME` user must have `sudo` rights on the VPS. The workflow uses `printf '%s\n' "$PASSWORD" | sudo -S` for all privileged commands.

---

## First Deploy (one-time VPS setup)

```bash
# 1. SSH into VPS as root
ssh root@<SERVER_IP>

# 2. Upload the deploy/ folder
scp -r deploy/ deploy@<SERVER_IP>:~/deploy-purewide3/

# 3. Run the provision script (as root)
cd ~/deploy-purewide3
sudo bash provision.sh

# 4. Set the 6 GitHub Secrets listed above

# 5. Ensure the shared Nginx site-file has the include directive.
#    The CI workflow adds it automatically on first run, but verify:
grep "shared-routes" /etc/nginx/sites-available/<SHARED_SITE_FILE>

# 6. Push to main — GitHub Actions deploys automatically
git push origin main
```

---

## Subsequent Deploys

Push to `main`. The workflow:
1. Validates secrets
2. Builds and publishes the .NET app
3. SSHs into VPS — ensures runtime + Nginx are installed, deploys systemd unit and Nginx route fragment
4. SCPs published files to `/var/www/purewide3`
5. Restarts `purewide3.service` and reloads Nginx

No manual steps required after the first deploy.

---

## Manual Rollback

```bash
# On VPS — stop the service, swap in a previous backup, restart
sudo systemctl stop purewide3

# Restore from a previous publish backup (if maintained)
sudo rsync -a /var/www/purewide3-backup/ /var/www/purewide3/

sudo systemctl start purewide3
sudo systemctl status purewide3 --no-pager
```

---

## Service Management

```bash
# Status
sudo systemctl status purewide3 --no-pager

# Restart
sudo systemctl restart purewide3

# Tail logs
sudo journalctl -u purewide3 -f --no-pager

# Nginx config test
sudo nginx -t

# Reload Nginx (no downtime)
sudo systemctl reload nginx
```

---

## Nginx Route Fragment

The deploy workflow automatically writes the route fragment to:  
`/etc/nginx/shared-routes/<SHARED_DOMAIN>/purewide3.conf`

It proxies `/purewide3/` → `http://127.0.0.1:5011` with correct `X-Forwarded-*` headers.  
The `PATH_BASE=/purewide3` environment variable in the systemd unit ensures ASP.NET Core handles the subpath correctly.

Reference static copy: `deploy/nginx-purewide3.conf`

---

## PathBase Notes

`Program.cs` reads `PATH_BASE` env var and calls `app.UsePathBase()` before `UseRouting()`.  
The systemd unit sets `Environment=PATH_BASE=/purewide3`.  
No code changes needed for the shared-domain topology.

---

## Credential Rotation Procedure

1. Generate a new SSH password for the `deploy` user on the VPS.
2. Update the `PASSWORD` GitHub Secret in repo Settings.
3. Trigger a manual workflow dispatch to verify the new credentials before expiring the old ones.
4. Update any other systems (monitoring, backups) that use the old credential.
5. Document the rotation date in the project log.
