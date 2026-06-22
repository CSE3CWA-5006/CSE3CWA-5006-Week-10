# Week 10 AWS Node App

This is the complete code package for Week 10 Page 3:

**From Static Page to Real Web App: Deploying Node.js on AWS EC2**

The app demonstrates a small Express backend running on an AWS EC2 Ubuntu server, behind Nginx, managed by PM2.

> **Copyright (c) 2026 Dr Shuo Ding · <shuoding@outlook.com>**
> This project is released under the **GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)** — see [`LICENSE`](LICENSE).
> It is **free to use**. Any **copy, modification, or distribution** (including hosted/network use) **must retain the author copyright notice** and remain under the AGPL.

## Files

- `server.js` - Express application with `/`, `/api/health`, and `/api/time`.
- `package.json` - npm dependencies and scripts.
- `.env.example` - sample environment variables.
- `deploy/week10-nodeapp.nginx` - Nginx reverse proxy configuration.
- `deploy/setup_ubuntu_ec2.sh` - installs Nginx, Node.js 24.x and PM2 on Ubuntu.
- `deploy/start_with_pm2.sh` - installs dependencies, checks syntax and starts the app with PM2.
- `deploy/install_nginx_proxy.sh` - installs the Nginx reverse proxy configuration.
- `deploy/cleanup_lab.sh` - stops PM2 and removes the Nginx site configuration.

## Quick lab sequence on Ubuntu EC2

Run these commands after uploading or unzipping this folder on the EC2 instance:

```bash
cd week10-nodeapp
chmod +x deploy/*.sh
./deploy/setup_ubuntu_ec2.sh
./deploy/start_with_pm2.sh
./deploy/install_nginx_proxy.sh
```

Test inside the EC2 instance:

```bash
curl http://127.0.0.1:3000/api/health
curl http://127.0.0.1/api/health
```

Test from your browser:

```text
http://YOUR_PUBLIC_IPV4_ADDRESS
http://YOUR_PUBLIC_IPV4_ADDRESS/api/health
http://YOUR_PUBLIC_IPV4_ADDRESS/api/time
```

## Cleanup

```bash
./deploy/cleanup_lab.sh
```

Then stop or terminate the EC2 instance according to the AWS Academy lab instructions.

## License

Week 10 AWS Node App is free software, released under the **GNU Affero General Public License, version 3 or later (AGPL-3.0-or-later)** — full text in [`LICENSE`](LICENSE) and at <https://www.gnu.org/licenses/agpl-3.0.html>.

**You are free to** use and run it for any purpose (including commercial and educational use), study how it works and modify it, and share original or modified copies.

**On these conditions:** keep the author copyright and licence notices; if you distribute it — or let users interact with a modified version over a network — make the complete corresponding source available to them under the AGPL; license your changes and any larger work under AGPL-3.0-or-later; and state the changes you made.

The software is provided "as is", without warranty of any kind and without liability, to the extent permitted by law.

**Attribution must be retained.** Any copy, modification, redistribution or network deployment must continue to credit **Dr Shuo Ding** (<shuoding@outlook.com>) as the original author and remain under the AGPL.

Every source file in this project carries an AGPL copyright header (except `package.json`, which is JSON and cannot contain comments). Please do not remove these notices.

Copyright © Dr Shuo Ding 2026 — under the AGPL license.
