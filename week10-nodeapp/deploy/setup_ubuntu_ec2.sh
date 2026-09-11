#!/usr/bin/env bash
# Week 10 AWS Node App  -  Copyright (c) 2026 Dr Shuo Ding <shuoding@outlook.com>
# Licensed under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later).
# Free to use. Any copy, modification, or distribution must retain this author
# copyright notice and remain under the AGPL. See the LICENSE file for full terms.

set -euo pipefail

echo "Week 10 AWS EC2 setup"
echo "This script installs Nginx and Node.js 24.x packages from NodeSource."
echo "Run this on an Ubuntu EC2 instance used for the teaching lab."

sudo apt update
sudo apt install -y ca-certificates curl git nginx

NODE_MAJOR=""
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR="$(node -v | sed -E 's/^v([0-9]+).*/\1/')"
fi

if [ "$NODE_MAJOR" != "24" ]; then
  echo "Installing Node.js 24.x package source."
  curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
  sudo apt install -y nodejs
else
  echo "Node.js 24.x is already installed:"
  node -v
fi

NODE_MAJOR="$(node -v | sed -E 's/^v([0-9]+).*/\1/')"
if [ "$NODE_MAJOR" != "24" ]; then
  echo "Node.js 24.x is required, but this instance is using $(node -v)." >&2
  echo "Use a fresh Ubuntu EC2 instance or remove the conflicting Node.js installation, then run this script again." >&2
  exit 1
fi

sudo systemctl enable nginx
sudo systemctl start nginx

cd "$(dirname "$0")/.."

if [ ! -f ".env" ]; then
  echo ".env was not found. Creating it from .env.example."
  cp .env.example .env
fi

echo "Installing npm dependencies."
npm install

echo "Checking JavaScript syntax."
npm run check

echo
echo "Installed versions:"
node -v
npm -v
nginx -v

echo
echo "Next steps:"
echo "1. Run: ./deploy/install_app_service.sh"
echo "2. Run: ./deploy/install_nginx_proxy.sh"
echo "3. Test: curl http://127.0.0.1/api/health"
