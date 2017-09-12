---
layout: "post"
title: "How to install helm on local server"
date: "2017-09-11 18:32"
categories:  kubernetes
---

# How to install helm on local server

## reference
https://docs.helm.sh/using_helm/#installing-helm

## Installing helm

1. Download your desired version
 https://storage.googleapis.com/kubernetes-helm/helm-v2.6.1-linux-amd64.tar.gz

2. Transfer tar file to kubenetes cluster node
```bash
$ scp helm-v2.6.1-linux-amd64.tar.gz root@<k8sClusterIpURL>:/root/<blackdog>
```
3. SSH to the k8s cluster node.

4. Unpack it
```bash
$ tar -zxvf helm-v2.6.1-linux-amd64.tar.gz
```

5. Move to the directory which is on $PATH
```bash
$ mv linux-amd64/helm /usr/local/bin/helm
```
