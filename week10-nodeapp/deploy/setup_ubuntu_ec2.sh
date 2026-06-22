#!/usr/bin/env bash
# Week 10 AWS Node App  -  Copyright (c) 2026 Dr Shuo Ding <shuoding@outlook.com>
# Licensed under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later).
# Free to use. Any copy, modification, or distribution must retain this author
# copyright notice and remain under the AGPL. See the LICENSE file for full terms.

set -euo pipefail

echo "Week 10 AWS EC2 setup"
echo "This script installs Nginx, Node.js 24 LTS packages from NodeSource, and PM2."
echo "Run this on an Ubuntu EC2 instance used for the teaching lab."

sudo apt update
sudo apt install -y curl git nginx

if ! command -v node >/dev/null 2>&1; then
  echo "Node.js is not installed. Installing Node.js 24.x package source."
  curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
  sudo apt install -y nodejs
else
  echo "Node.js is already installed:"
  node -v
fi

if ! command -v pm2 >/dev/null 2>&1; then
  echo "Installing PM2 globally."
  sudo npm install -g pm2
else
  echo "PM2 is already installed:"
  pm2 -v
fi

sudo systemctl enable nginx
sudo systemctl start nginx

echo
echo "Installed versions:"
node -v
npm -v
nginx -v
pm2 -v

echo
echo "Next steps:"
echo "1. Copy or unzip the week10-nodeapp project onto the EC2 instance."
echo "2. Run: npm install"
echo "3. Run: cp .env.example .env"
echo "4. Run: pm2 start server.js --name week10-nodeapp"
echo "5. Configure Nginx using deploy/week10-nodeapp.nginx"
