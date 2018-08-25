---
layout: "posts"
title: "Add Kubernetes secret"
date: "2017-09-19 08:51"
categories:  kubernetes
classes: wide
---


# How to add secret for image registry
```bash
kubectl create secret docker-registry rediikey --docker-server=<imagerepourl> --docker-username=<username> --docker-password=<password> --docker-email=<email>
```
-   example  
```bash
kubectl create secret docker-registry redii-cicd  \
--docker-server=<URL> \
--docker-username=<USER_ID> \
--docker-password=<PAASWORD> \
--docker-email=<EMAIL>
```
