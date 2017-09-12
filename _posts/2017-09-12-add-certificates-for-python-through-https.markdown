---
layout: "post"
title: "Add certificates for python through https"
date: "2017-09-12 10:25"
categories:  linux
---

# Add certificates for python through https

## reference
https://stackoverflow.com/questions/19377045/pip-cert-failed-but-curl-works

https://stackoverflow.com/questions/25981703/pip-install-fails-with-connection-error-ssl-certificate-verify-failed-certi

## Using command
```bash
$ Add certificates for python through https
```

If you don't want to use the command line argument, you can set the cert in ~/.pip/pip.conf:

## Add ~/.pip/pip.conf file
```sh
[global]
cert = /etc/ssl/certs/Foo_Rooti[**_CA.pem
```
