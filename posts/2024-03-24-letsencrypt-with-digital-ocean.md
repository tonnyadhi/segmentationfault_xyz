---
title: Enabling LetsEncrypt Auto Renew for Local Domain via Digital Ocean 

date: 2024-03-24
tags: ubuntu, gnu/linux, home server, raspberry pi, letsencrypt, digital ocean
---

I have build home server using Raspberry Pi 4 since a few months ago. This home server host several services for my home network, such as [DNSCrypt](https://github.com/DNSCrypt/dnscrypt-server-docker), [Home Assistant](https://github.com/home-assistant) and [RIPE Atlas Client](https://atlas.ripe.net/docs/). This server is being monitored by Prometheus and Grafana. Docker containers are managed by [Portainer](https://www.portainer.io/).

Within all of the services that mentioned above, i gave them FQDN using my domain segmentationfault.xyz but with local network IPv4. These services also connected via [Zerotier](https://zerotier.com), so i can access and utilized them wherever i go.

All of those FQDN, are bind into LetsEncrypt certificates. Those certificates are created manually, one by one using certbot. They quite make hassle tasks to do.

## Managing LetsEncrypt Certificate with Digital Ocean Certbot Plugin

Well, i forgot that i registered those FQDNs on my Digital Ocean DNS. They can be managed using certbot Digital Ocean Plugin.

- Install Digital Ocean Certbot Plugin
  `sudo apt install certbot`
  `sudo apt install python3-certbot-dns-digitalocean`
- Create Digital Ocean credential config file
  `touch ~/certbot-creds.ini`
  `chmod go-rwx ~/certbot-creds.ini`
- Add your Digital Ocean API Key into credential config file
  ```bash
  vi ~/certbot-creds.ini
  ....
  dns_digitalocean_token = your_digitalocean_access_token
  ....
  ```
- Issue LetsEncrypt Certificates
  ```bash
  sudo certbot certonly --dns-digitalocean --dns-digitalocean-credentials ~/certbot-creds.ini -d pi-portainer.segmentationfault.xyz
  ```
- Renewing LetsEncrypt Certificates
  ```bash
  sudo certbot renew
  ```
- Certbot also carry its own renewal systemd services. 
  ```bash
  sudo systemctl status certbot.timer

  ● certbot.timer - Run certbot twice daily
     Loaded: loaded (/lib/systemd/system/certbot.timer; enabled; vendor preset: enabled)
     Active: active (waiting) since Mon 2024-02-26 19:46:23 WIB; 3 weeks 6 days ago
    Trigger: Mon 2024-03-25 06:55:11 WIB; 10h left
   Triggers: ● certbot.service

  Feb 26 19:46:23 praji-home-server systemd[1]: Started Run certbot twice daily.
  ```