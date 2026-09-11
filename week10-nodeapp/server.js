// Week 10 AWS Node App  -  Copyright (c) 2026 Dr Shuo Ding <shuoding@outlook.com>
// Licensed under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later).
// Free to use. Any copy, modification, or distribution must retain this author
// copyright notice and remain under the AGPL. See the LICENSE file for full terms.

import express from "express";
import "dotenv/config";

const app = express();
const port = Number(process.env.PORT || 3000);
const appName = process.env.APP_NAME || "AWS Node App";

app.get("/", (req, res) => {
  res.type("html").send(`
    <!doctype html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>${appName}</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 3rem; line-height: 1.6; }
          code { background: #eef2ff; padding: 0.15rem 0.35rem; border-radius: 4px; }
        </style>
      </head>
      <body>
        <h1>${appName}</h1>
        <p>This page is served by Express on AWS EC2, behind Nginx.</p>
        <p>Try <code>/api/health</code> or <code>/api/time</code>.</p>
      </body>
    </html>
  `);
});

app.get("/api/health", (req, res) => {
  res.json({
    ok: true,
    app: appName,
    node: process.version,
    uptimeSeconds: Math.round(process.uptime()),
    message: "Express is running behind Nginx on AWS EC2"
  });
});

app.get("/api/time", (req, res) => {
  res.json({
    serverTime: new Date().toISOString(),
    timezone: "UTC"
  });
});

app.listen(port, "127.0.0.1", () => {
  console.log(`${appName} listening on http://127.0.0.1:${port}`);
});
