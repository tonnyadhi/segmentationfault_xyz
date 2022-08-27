---
title: DNSCrypt and Pi-Hole on Docker 

date: 2022-08-27
tags: dnscrypt, pi-hole, docker
---

Lately, i bought an [ASUS PN51](https://www.asus.com/Displays-Desktops/Mini-PCs/PN-series/Mini-PC-PN51-S1/) mini pc with Ryzen 7 5700U, 32GB of RAM and 1TB of NVME storage. I planned to use this mini pc for my home server. This home server with become my test bed for virtual kubernetes cluster using [k3s](https://k3s.io/).

I also planned to host some of my home service their, such as OwnCloud, Home Assistant, and of course secondary Pi-Hole server at my home network. This Pi-Hole will run of top Docker / Containerd.

## Docker Deployment of Pi-Hole and DNSCrypt Proxy

Create a docker compose file that will serve us as template to run Pi-Hole and DNSCrypt Proxy. Bridge Pi-Hole network into Host Network using mac-vlan. Here is the docker compose file that i used :

```yaml
version: "3"
services:
  dnscrypt:
    image: klutchell/dnscrypt-proxy:latest
    #cap_add:
    #  - NET_ADMIN
    volumes:
      - './dnscrypt-proxy/:/config'
    environment:
      TZ: Asia/Jakarta
    expose:
      - 6666/udp
      - 6666/tcp
    dns:
      - 1.1.1.1
    networks:
      pihole-internal:
        ipv4_address: '10.0.1.2'
  pihole:
    image: pihole/pihole:latest
    restart: unless-stopped
    #cap_add:
    #    - NET_ADMIN
    dns:
      - 10.0.1.2#5300
      - 10.10.10.224
    environment:
      ServerIP: 10.10.10.231
      DNS1: 10.0.1.2#6666
      DNS2: 10.10.10.224
      VIRTUAL_HOST: pi.hole.secondary
      DNSMASQ_LISTENING: all
      TZ: Asia/Jakarta
      WEBPASSWORD: xyzabc@12345346 
    volumes:
      - './pihole/pihole/:/etc/pihole/'
      - './pihole/dnsmasq.d/:/etc/dnsmasq.d/'
    ports: # expose all pihole ports.
      - 443/tcp
      - 53/tcp
      - 53/udp
      - 67/udp
      - 80/tcp
    depends_on:
      - dnscrypt
    networks:
      backend:
        ipv4_address: '10.10.10.231'
      pihole-internal:
        ipv4_address: '10.0.1.3'

networks:
  backend:
    driver: macvlan
    driver_opts:
      parent: enp2s0 # change this
    ipam:
      config:
        - subnet: "10.10.10.0/24" # change this
          gateway: "10.10.10.1" # change this (optional)
  pihole-internal:
    driver: bridge
    ipam:
      config:
        - subnet: 10.0.1.0/24

```

This is the `dnscrypt-proxy.toml` that i used :

```toml
...
server_names = ['dnswarden-uncensor-sg1-doh', 'doh.tiarap.org', 'cloudflare', 'google']
listen_addresses = ['0.0.0.0:6666']
...
```

After that, just run the docker compose with :

```bash
docker compose up -d
```
Enjoy. You now have secondary Pi-Hole at your home network.

On the primary Pi-Hole that you used as DHCP Server, at the secondary server IP Address on your DHCP configuration :

```bash
sudo vi /etc/dnsmasq.d/02-pihole-dhcp.conf
...
dhcp-option=option:dns-server,10.10.10.224,10.10.10.231
...
```