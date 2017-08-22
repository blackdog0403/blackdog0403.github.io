---
layout: post
title:  "Docker Basics"
date:   2017-07-11 19:35:00 -0700
categories:  docker
---

# Docker image repository usage

### login & logout
```bash
$ docker login <URL> # eg) docker login sds.redii.net
$ docker logout sds.redii.net
```

### tagging
```bash
$ docker tag nginx:1.7.9 sds.redii.net/kwangyoung49-kim/nginx:1.7.9
```
### push
```bash
$ docker push sds.redii.net/kwangyoung49-kim/nginx:1.7.9
```

### docker image delete (untagging)
```bash
$ docker rmi sds.redii.net/kwangyoung49-kim/paas/nginx:1.7.9
```
