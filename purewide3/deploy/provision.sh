#!/bin/bash
# provision.sh — one-time VPS setup for purewide3
# Usage: sudo bash provision.sh
# Run ONCE on a fresh Debian 11 server before the first GitHub Actions deploy.
set -e

APP_NAME="purewide3"
TARGET_DIR="/var/www/purewide3"
VPS_USER="deploy"
DOTNET_VERSION="9.0"

echo "=== [1/6] Installing .NET ${DOTNET_VERSION} runtime ==="
. /etc/os-release
wget -q "https://packages.microsoft.com/config/$ID/$VERSION_ID/packages-microsoft-prod.deb" -O /tmp/packages-microsoft-prod.deb
dpkg -i /tmp/packages-microsoft-prod.deb || true
rm -f /tmp/packages-microsoft-prod.deb
apt-get update -y
apt-get install -y aspnetcore-runtime-${DOTNET_VERSION}
echo "  .NET runtimes available:"
dotnet --list-runtimes | grep "^Microsoft.NETCore.App ${DOTNET_VERSION}" || true

echo "=== [2/6] Installing Nginx ==="
apt-get install -y nginx
systemctl enable nginx

echo "=== [3/6] Creating deploy user and target directory ==="
id -u "$VPS_USER" &>/dev/null || useradd -m -s /bin/bash "$VPS_USER"
usermod -aG www-data "$VPS_USER"
mkdir -p "$TARGET_DIR"
chown -R "$VPS_USER:www-data" "$TARGET_DIR"
chmod 750 "$TARGET_DIR"

echo "=== [4/6] Creating shared-routes directory for this app ==="
# The shared domain and site file are set by the CI workflow.
# This step creates the include directory structure expected by the deploy.yml.
mkdir -p /etc/nginx/shared-routes
echo "  ✔ /etc/nginx/shared-routes created"

echo "=== [5/6] Installing and enabling systemd service ==="
cp "$(dirname "$0")/purewide3.service" /etc/systemd/system/purewide3.service
chmod 644 /etc/systemd/system/purewide3.service
systemctl daemon-reload
systemctl enable purewide3.service
echo "  ✔ purewide3.service enabled (not yet started — app not deployed)"

echo "=== [6/6] Testing Nginx config ==="
nginx -t

echo ""
echo "========================================================"
echo " provision.sh complete."
echo " Next steps:"
echo "   1. Add GitHub Secrets to carlosperez1986/purewide3.0:"
echo "      SERVER_IP, USERNAME, PASSWORD, SHARED_DOMAIN, SHARED_SITE_FILE"
echo "      (PORT is optional — defaults to 22)"
echo "   2. Ensure SHARED_DOMAIN's Nginx site file includes:"
echo "      include /etc/nginx/shared-routes/<SHARED_DOMAIN>/*.conf;"
echo "   3. Push to main → GitHub Actions will deploy the app."
echo "========================================================"
