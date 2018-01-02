---
layout: "post"
title: "Add labels to PV and us"
date: "2017-12-26 18:56"
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
