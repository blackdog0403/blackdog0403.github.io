---
layout: post
title:  "CA certificate on linux"
date:   2017-08-23 09:53:00 -0700
categories:  kubernetes
---

# CA certificate on linux

## Centos 7
```bash
$ cp /root/<my-certification-file>.crt /etc/pki/ca-trust/source/anchors/
$ update-ca-trust
```

## Ubuntu 14.04
```bash
$ cp /<my-certification-file>.crt /usr/local/share/ca-certificates/
$ mv /<my-certification-file>.crt /usr/share/ca-certificates/
$ update-ca-certificates --fresh
```

## Alpine 3.6 (especially in docker you need to prepare for this)
```bash
$ cp /<my-certification-file>.crt /usr/local/share/ca-certificates/
$ mv /<my-certification-file>.crt /usr/share/ca-certificates/
$ update-ca-certificates --fresh
```

Same as Ubuntu but if you see the message below

> "WARNING: ca-certificates.crt does not contain exactly one certificate or CRL: skipping"

Looks like it's not done but it's done.
```bash
$cat  /etc/ssl/certs/ca-certificates.crt
```
You can find your new certificates spec on the last of file.
