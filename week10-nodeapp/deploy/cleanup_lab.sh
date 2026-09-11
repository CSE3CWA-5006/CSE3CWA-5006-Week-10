#!/usr/bin/env bash
# Week 10 AWS Node App  -  Copyright (c) 2026 Dr Shuo Ding <shuoding@outlook.com>
# Licensed under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later).
# Free to use. Any copy, modification, or distribution must retain this author
# copyright notice and remain under the AGPL. See the LICENSE file for full terms.

set -euo pipefail

echo "Stopping and removing systemd service if it exists."
sudo systemctl stop week10-nodeapp || true
sudo systemctl disable week10-nodeapp || true
sudo rm -f /etc/systemd/system/week10-nodeapp.service
sudo systemctl daemon-reload

echo "Removing Nginx site configuration."
sudo rm -f /etc/nginx/sites-enabled/week10-nodeapp
sudo rm -f /etc/nginx/sites-available/week10-nodeapp

echo "Reloading Nginx."
sudo nginx -t
sudo systemctl reload nginx

echo
echo "Application cleanup complete. Stop or terminate the EC2 instance according to AWS Academy lab instructions."
