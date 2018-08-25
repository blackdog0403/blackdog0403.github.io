---
layout: posts
title:  "Mac os sierra dns reset"
date:   2017-09-03 08:47:00 -0700
categories:  linux
classes: wide
---

# Mac os sierra dns reset
```bash
sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache;
```
