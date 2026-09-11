#!/usr/bin/env bash
# Week 10 AWS Node App  -  Copyright (c) 2026 Dr Shuo Ding <shuoding@outlook.com>
# Licensed under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later).
# Free to use. Any copy, modification, or distribution must retain this author
# copyright notice and remain under the AGPL. See the LICENSE file for full terms.

set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SERVICE_FILE="/etc/systemd/system/week10-nodeapp.service"
RUN_USER="${SUDO_USER:-$(id -un)}"

if [ ! -f "$APP_DIR/package.json" ] || [ ! -f "$APP_DIR/server.js" ]; then
  echo "This script must be run from the week10-nodeapp project directory." >&2
  echo "Current detected directory: $APP_DIR" >&2
  exit 1
fi

cd "$APP_DIR"

if [ ! -f ".env" ]; then
  echo ".env was not found. Creating it from .env.example."
  cp .env.example .env
fi

echo "Installing npm dependencies."
npm install

echo "Checking JavaScript syntax."
npm run check

echo "Installing systemd service: week10-nodeapp."
sudo tee "$SERVICE_FILE" >/dev/null <<SERVICE
[Unit]
Description=Week 10 Node.js web application
After=network.target

[Service]
Type=simple
User=$RUN_USER
WorkingDirectory=$APP_DIR
Environment=NODE_ENV=production
EnvironmentFile=$APP_DIR/.env
ExecStart=$(command -v node) $APP_DIR/server.js
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
SERVICE

sudo systemctl daemon-reload
sudo systemctl enable week10-nodeapp
sudo systemctl restart week10-nodeapp

echo
echo "Service status:"
sudo systemctl status week10-nodeapp --no-pager

echo
echo "Local test command:"
echo "curl http://127.0.0.1:3000/api/health"
