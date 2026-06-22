#!/usr/bin/env bash
# Week 10 AWS Node App  -  Copyright (c) 2026 Dr Shuo Ding <shuoding@outlook.com>
# Licensed under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later).
# Free to use. Any copy, modification, or distribution must retain this author
# copyright notice and remain under the AGPL. See the LICENSE file for full terms.

set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -f ".env" ]; then
  echo ".env was not found. Creating it from .env.example."
  cp .env.example .env
fi

echo "Installing npm dependencies."
npm install

echo "Checking JavaScript syntax."
npm run check

echo "Starting the app with PM2."
pm2 start server.js --name week10-nodeapp

echo
echo "PM2 status:"
pm2 status

echo
echo "Local test commands:"
echo "curl http://127.0.0.1:3000/"
echo "curl http://127.0.0.1:3000/api/health"
echo "curl http://127.0.0.1:3000/api/time"
