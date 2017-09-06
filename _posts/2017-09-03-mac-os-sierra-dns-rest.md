---
layout: post
title:  "Mac os sierra dns reset"
date:   2017-08-24 08:47:00 -0700
categories:  linux
---

# Mac os sierra dns reset
```bash
sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache;
```
