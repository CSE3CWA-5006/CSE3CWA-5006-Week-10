#!/usr/bin/env bash
# Week 10 AWS Node App  -  Copyright (c) 2026 Dr Shuo Ding <shuoding@outlook.com>
# Licensed under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later).
# Free to use. Any copy, modification, or distribution must retain this author
# copyright notice and remain under the AGPL. See the LICENSE file for full terms.

set -euo pipefail

cd "$(dirname "$0")/.."

echo "Installing Nginx reverse proxy configuration for week10-nodeapp."
sudo cp deploy/week10-nodeapp.nginx /etc/nginx/sites-available/week10-nodeapp
sudo ln -sf /etc/nginx/sites-available/week10-nodeapp /etc/nginx/sites-enabled/week10-nodeapp
sudo rm -f /etc/nginx/sites-enabled/default

echo "Testing Nginx configuration."
sudo nginx -t

echo "Reloading Nginx."
sudo systemctl reload nginx

echo
echo "Nginx now forwards public HTTP traffic on port 80 to http://127.0.0.1:3000."
echo "Test from the EC2 instance:"
echo "curl http://127.0.0.1/api/health"
