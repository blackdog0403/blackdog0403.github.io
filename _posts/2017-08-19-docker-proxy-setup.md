---
layout: post
title:  "Docker Proxy Setup"
date:   2017-08-21 19:35:00 -0700
categories:  docker
---

# Docker Proxy Setup

### proxy setup
```
$ cd /etc/systemd/system/docker.service.d
$ vi http-proxy.conf
```
### edit conf file
```
[Service]
Environment="HTTP_PROXY=http://localhost:3128/"
Environment="HTTPS_PROXY=http://localhost:3128/"
```
### reload systemd daemon
```
$ systemctl daemon-reload
```
### restart docker service
```
systemctl restart docker
```
