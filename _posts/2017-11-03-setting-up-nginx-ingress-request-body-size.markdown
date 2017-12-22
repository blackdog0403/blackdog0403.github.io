---
layout: "post"
title: "Setting up nginx ingress request body size"
date: "2017-11-03 11:16"
---


# Setting up NGINX ingress request body size

When you set up ingress controller for k8s cluster, you could not send http request that has over 10mb size. Then you don't need to change setting for whole ingress controller but just need to set annotations for it.

## Example
-   ingress.yaml
```yaml
...

annotations:
  kubernetes.io/ingress.class: nginx
  ingress.kubernetes.io/proxy-body-size: 100m

...
```

-

## Reference

[https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md](https://github.com/kubernetes/ingress-nginx/blob/master/docs/annotations.md)
