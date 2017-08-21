---
layout: post
title:  "Docker Basics"
date:   2017-07-11 19:35:00 -0700
categories:  docker
---

# Docker image repository usage

### login & logout
```
$ docker login <URL> # eg) docker login sds.redii.net
$ docker logout sds.redii.net
```

### tagging
```
$ docker tag nginx:1.7.9 sds.redii.net/kwangyoung49-kim/nginx:1.7.9
```
### push
```
$ docker push sds.redii.net/kwangyoung49-kim/nginx:1.7.9
```

### docker image delete (untagging)
```
$ docker rmi sds.redii.net/kwangyoung49-kim/paas/nginx:1.7.9
```
