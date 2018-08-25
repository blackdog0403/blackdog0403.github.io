---
layout: "posts"
title: "Add labels to PV"
date: "2017-12-26 18:56"
categories:  kubernetes
classes: wide
---

#Add labels to PV

## kubectl command
```bash
kubectl label pv <PV> <key>=<value>
```

## example
```bash
kubectl label pv pv-5g-09 app=gitlab type=data
```
