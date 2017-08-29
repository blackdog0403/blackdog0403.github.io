---
layout: post
title:  "Jenkins Kubernetes Plugin tips"
date:   2017-08-24 08:47:00 -0700
categories:  linux
---

# Jenkins Kubernetes Plugin tips

## Container Template name
> do not use '-' or '.' on container template name,  like this "gradle-3.3.0" -> doesn't work!!!

## Do not miss add Secret file for POD Template
