---
layout: "post"
title: "Timezone for pod"
date: "2017-11-03 11:14"
---

# Setup time zone for helm chart
-   values.yaml
```yaml
...
timezone: Asia/Seoul
"deployment.yaml" 변수 추가
...
```
-   deployment.yaml
```
env:
name: TZ value: {{ .Values.timezone }}
```
