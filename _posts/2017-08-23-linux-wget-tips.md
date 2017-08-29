---
layout: post
title:  "Linux wget tips"
date:   2017-08-24 08:47:00 -0700
categories:  linux
---

# WGET

### login & logout
```bash
$ docker login <URL> # eg) docker login sds.redii.net
$ docker logout sds.redii.net
```

### run wget without checking certificate
wget -q --no-check-certificate http://archive.apache.org/dist/ant/binaries/apache-ant-1.9.4-bin.tar.gz
