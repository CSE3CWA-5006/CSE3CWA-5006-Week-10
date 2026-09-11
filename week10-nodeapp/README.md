# Week 10 AWS Node App

This is the complete code package for Week 10:

**Deploy the Web Application to AWS EC2**

The project contains a small Express web application that runs privately on `127.0.0.1:3000` on an Ubuntu EC2 instance. The public website is served through Nginx on port `80`, and the Node.js application is managed by `systemd` as the `week10-nodeapp` service.

> Copyright (c) 2026 Dr Shuo Ding <shuoding@outlook.com>
>
> This project is released under the GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later). See `LICENSE` for the full terms. Keep the author copyright notice and licence notices in copies, modifications and redistributions.

## What This App Provides

- `/` - HTML page served by Express.
- `/api/health` - JSON health endpoint for deployment checks.
- `/api/time` - JSON endpoint returning the current server time in UTC.

## Files

- `server.js` - Express application with `/`, `/api/health`, and `/api/time`.
- `package.json` - npm metadata, dependencies and scripts.
- `package-lock.json` - locked npm dependency versions.
- `.env.example` - sample environment variables.
- `deploy/setup_ubuntu_ec2.sh` - installs `ca-certificates`, Git, curl, Nginx, Node.js 24.x, npm dependencies, creates `.env` when required and checks JavaScript syntax.
- `deploy/install_app_service.sh` - installs and starts the current app directory as a `systemd` service named `week10-nodeapp`.
- `deploy/install_nginx_proxy.sh` - installs the Nginx reverse proxy configuration.
- `deploy/week10-nodeapp.nginx` - Nginx site configuration that forwards public HTTP traffic to `127.0.0.1:3000`.
- `deploy/cleanup_lab.sh` - stops and removes the `systemd` service and Nginx site configuration.

## 1. Start AWS Academy and Open AWS

1. Sign in to the AWS Academy course provided by the teaching team.
2. Open the required Learner Lab or lab environment.
3. Start the lab session.
4. Wait until the AWS environment is ready.
5. Open the AWS Management Console.
6. Check the Region shown in the AWS console and stay in that Region for the whole lab.

AWS Academy environments may restrict services, instance types and connection methods. Use the options available in your assigned lab.

## 2. Launch an Ubuntu EC2 Instance

In the AWS Management Console:

1. Search for `EC2`.
2. Open the EC2 service.
3. Choose `Launch instance`.
4. Configure the instance:

| Setting | Use for this lab |
| --- | --- |
| Name | `week10-webapp` |
| AMI | A current Ubuntu Server LTS image available in the Academy environment |
| Instance type | A small instance type permitted by AWS Academy |
| Key pair / connection method | Use the method provided or permitted by the Academy lab |

Important: choose Ubuntu Server LTS, not Amazon Linux. This lab uses Ubuntu commands such as `sudo apt update` and `sudo apt install`.

Configure the security group:

| Traffic | Port | Source |
| --- | --- | --- |
| SSH | `22` | Your current IP address where local SSH is permitted; otherwise follow the Academy connection instructions |
| HTTP | `80` | `0.0.0.0/0` for this public teaching website |

Do not add an inbound rule for port `3000`. The Express app listens privately on the EC2 instance, and Nginx is the public entry point.

Launch the instance. Wait until it is `Running` and the status checks have passed. Record the instance's Public IPv4 address.

## 3. Connect to Ubuntu

Select your instance and choose `Connect`. Use the SSH or browser-based connection method available in your AWS Academy environment.

If you use SSH from your own computer, copy the SSH command shown by the EC2 console. Ubuntu EC2 images normally use the username `ubuntu`.

Example:

```bash
ssh -i YOUR_KEY_FILE.pem ubuntu@YOUR_PUBLIC_IPV4_ADDRESS
```

After connecting, confirm that you are on the remote EC2 instance:

```bash
whoami
hostname
```

On a standard Ubuntu EC2 instance, `whoami` should normally return:

```text
ubuntu
```

## 4. Download the Week 10 Project from GitHub

Install Git first, then clone the supplied repository directly to the Ubuntu user's home directory.

```bash
sudo apt update
sudo apt install -y git

cd ~
git clone https://github.com/CSE3CWA-5006/CSE3CWA-5006-Week-10.git
cd CSE3CWA-5006-Week-10/week10-nodeapp
chmod +x deploy/*.sh
ls
```

You should see files including:

```text
package.json
package-lock.json
server.js
.env.example
deploy
```

## 5. Prepare Ubuntu and Install the Application

Run the supplied setup script:

```bash
./deploy/setup_ubuntu_ec2.sh
```

The script:

- installs `ca-certificates`, `curl`, `git` and `nginx`;
- installs Node.js 24.x from NodeSource if Node.js is missing or the installed major version is not 24;
- enables and starts Nginx;
- creates `.env` from `.env.example` when `.env` does not exist;
- installs npm dependencies; and
- checks the JavaScript syntax with `npm run check`.

Confirm the installed versions:

```bash
node -v
npm -v
nginx -v
```

## 6. Test the Node.js Application Locally

Before configuring the public web path, start the application directly:

```bash
npm start
```

The application should report:

```text
Week 10 AWS Node App listening on http://127.0.0.1:3000
```

Keep that terminal running and open a second SSH connection to the same EC2 instance. Run:

```bash
curl http://127.0.0.1:3000/api/health
curl http://127.0.0.1:3000/api/time
```

Both commands should return JSON.

Return to the terminal running `npm start` and press `Ctrl + C`.

## 7. Run the Application as a systemd Service

Install and start the supplied `systemd` service:

```bash
./deploy/install_app_service.sh
```

The script creates:

```text
/etc/systemd/system/week10-nodeapp.service
```

It starts the application from the `week10-nodeapp` directory where you run the script.

Verify the service:

```bash
sudo systemctl status week10-nodeapp --no-pager
curl http://127.0.0.1:3000/api/health
```

The service status should show `active (running)`, and the curl command should return JSON.

## 8. Configure Nginx

Install the supplied Nginx reverse proxy configuration:

```bash
./deploy/install_nginx_proxy.sh
```

The script:

- copies `deploy/week10-nodeapp.nginx` to `/etc/nginx/sites-available/week10-nodeapp`;
- enables it from `/etc/nginx/sites-enabled/week10-nodeapp`;
- removes the default Nginx site from `sites-enabled`;
- validates the configuration with `sudo nginx -t`; and
- reloads Nginx.

Test the complete web path from inside EC2:

```bash
curl http://127.0.0.1/
curl http://127.0.0.1/api/health
curl http://127.0.0.1/api/time
```

## 9. Open the Website in Your Browser

Return to the EC2 console and copy the instance's current Public IPv4 address.

On your own computer, open:

```text
http://YOUR_PUBLIC_IPV4_ADDRESS
http://YOUR_PUBLIC_IPV4_ADDRESS/api/health
http://YOUR_PUBLIC_IPV4_ADDRESS/api/time
```

Replace `YOUR_PUBLIC_IPV4_ADDRESS` with the actual address of your EC2 instance.

Deployment is complete when the main page loads and `/api/health` returns JSON through the public IPv4 address.

## 10. Troubleshooting

Check one layer at a time.

| Problem | Check |
| --- | --- |
| SSH connection fails | Confirm the instance is running, use its current public IPv4 address, and check the SSH security-group rule or Academy connection method. |
| `git clone` fails | Confirm the repository URL and check that the EC2 instance has outbound Internet access. |
| Setup script fails during Node.js installation | Confirm the instance is Ubuntu, has outbound Internet access, and can reach NodeSource. |
| The app does not start with `npm start` | Run `npm install`, then `npm run check`, and read the error output. |
| The service is not running | Run `sudo systemctl status week10-nodeapp --no-pager`. |
| You need application logs | Run `sudo journalctl -u week10-nodeapp -n 50 --no-pager`. |
| Browser shows 502 Bad Gateway | Confirm `sudo systemctl status week10-nodeapp --no-pager` is active and `curl http://127.0.0.1:3000/api/health` succeeds. |
| Nginx configuration fails | Run `sudo nginx -t` and read the reported error. |
| Local curl works but browser times out | Check the public IPv4 address and confirm that the EC2 security group allows inbound TCP port `80`. |

## 11. Evidence and Cleanup

Before ending the lab, capture evidence showing:

- the EC2 instance running in the AWS console;
- `sudo systemctl status week10-nodeapp --no-pager` showing `active (running)`;
- `sudo nginx -t` reporting a successful configuration test;
- the Week 10 application open in your browser; and
- `/api/health` returning a successful JSON response.

Remove the Week 10 application service and Nginx site configuration:

```bash
./deploy/cleanup_lab.sh
```

Finally, stop or terminate the EC2 instance according to the AWS Academy instructions. Do not leave teaching resources running unnecessarily.

This lab intentionally uses HTTP for a controlled teaching deployment. A production Internet-facing application would normally require additional controls such as HTTPS, domain configuration, stronger access restrictions, production secrets management, monitoring, backup and an architecture appropriate to the workload.

## Local Development

For local testing outside EC2:

```bash
npm install
cp .env.example .env
npm run check
npm start
```

Then open:

```text
http://127.0.0.1:3000
http://127.0.0.1:3000/api/health
http://127.0.0.1:3000/api/time
```

## License

Week 10 AWS Node App is free software, released under the GNU Affero General Public License, version 3 or later (AGPL-3.0-or-later). The full text is in `LICENSE` and at <https://www.gnu.org/licenses/agpl-3.0.html>.

You are free to use and run it for any purpose, study how it works, modify it, and share original or modified copies.

Keep the author copyright and licence notices. If you distribute it, or let users interact with a modified version over a network, make the complete corresponding source available under the AGPL and state the changes you made.

The software is provided "as is", without warranty of any kind and without liability, to the extent permitted by law.
