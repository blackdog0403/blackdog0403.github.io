---
layout: "post"
title: "Add Kubernetes secret"
date: "2017-09-19 08:51"
---


# How to add secret for image registry
```bash
kubectl create secret docker-registry rediikey --docker-server=<imagerepourl> --docker-username=<username> --docker-password=<password> --docker-email=<email>
```
