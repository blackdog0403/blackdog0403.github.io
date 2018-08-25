---
layout: "single"
title: "Create Configmap"
date: "2018-01-12 10:39"
categories:  kubernetes
classes: wide
---

# Create from files
```bash
kubectl create configmap helm-config-data --from-file=/root/.helm/repository/repositories.yaml -n usernamespace
```
