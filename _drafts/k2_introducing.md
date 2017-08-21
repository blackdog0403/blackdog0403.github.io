---
layout: post
title:  "K2 introducing"
date:   2017-08-17 19:35:00 -0700
categories:  seminar
---

# K2

https://github.com/samsung-cnct/k2
https://samsung-cnct.github.io

## What is K2
-> Kubernetes를 오케스트레이션 하고 클러스터 레벨의 관리를 하기 위한 툴. 프로덕션 스케일의 Kubernetes 클러스터를 손쉽게 생성이 가능하다.
특히 HA 프로덕션 스케일의 클러스터를 바로 사용해야하는 경우에 매우 유용함.
현재 1.7.1 version을 서포트하고 있으며 1.8대 버전을 위해서 개발중임.  AWS, GKE를 지원하고 있으며 추후 baremetal을 지원할 예정.  ( https://maas.io/ )


## What is K2 for

Kraken은 - ClusterOps라고 알려진 - kubenetes 를 서포트하는 운영팀을 타켓팅해서 만들어진 툴이다. Kraken은 단일 파일을 통해서 클러스터 설정을 드라이브를 하는데 이는 다음의 2가지 잇점을 가진다.

- 기존 클러스터 구성 또는 새로운 클러스터 구성에 대한 변경 사항을 개발환경에서 운영환경으로 반영할때 때 클러스터 구성에 형상을 사용할 수 있다.

- 샌드박스화 되고 일시적인 Kubernetes 클러스터에 대한 개발자 응용 프로그램의 지속적인 통합을 가능하게 한다. K2는 임시적인 인프라를 모두 정리하는 destroy 명령을 제공한다.

- auto-generated docs
https://samsung-cnct.github.io/k2/

### look around config

infrastructure as code! 모든 인프라스트럭처의 설정은 코드로 관리가 되어야함. 휴먼 에러를 줄여야하기 때문임. 6개월동안 멀티클러스터를 지원하기 위한 개발을 할텐데 그전에 컨픽 자체의 검증이나 안정성에 대한 확보를 하고 하기 위해서 노력을 하고 있다.

1. config 파일을 생성.
```
./bin/up.sh --generate
```
2. cluster name

- using k2-tools docker images for convenience
```
./hack/dockerdev -c ~/.kraken/mybabyclusters.yaml
```


3. show a config eval failure
-> make wrong config file

4. update the config, show it works

5. show another error for wrong kubernetes version alert
-> kubenetes version check for helm_override

6. network fabric selection
-> show configs for that

7.  full dry-run

```
export KRAKEN_TAGS=dryrun
./bin/up.sh --config ~/.kraken/mybabyclusters.yaml
```

8. show demo video
1:03
1:05:23
1:17

9. CI show

-
## K2 Crash Data Collection

안정성 증대와 오류 복구기능을 강화하기 위해서 클러스터를 생성, 제거, 업데이트 할 떄의 오류를 수집하여 분석해서 (ELK스택) 내부적으로 data-driven development 를 위하여 사용하는 중. -> 현재 사내망에서는 인증서 문제로 로그를 날리지 못하고 있음.

## K2 supported addons

클러스터를 생성,제거,업데이트 하는 기능외에 다양한 에드온들을 제공합니다.

https://github.com/samsung-cnct/k2-charts
### 로깅
https://github.com/samsung-cnct/k2-charts/tree/master/central-logging
### DEX
https://github.com/samsung-cnct/chart-dex


Show CI for a PR
 - should be broken on a config validation to show a normal error
 - quick show of Jenkinsfile
   - building kubernetes tooling in kubernetes
Full CI setup (just show the page)

Editable cluster (pre-created) -> 동영상으로 대신함

 - add/remove nodepool (small, one node)
 - upgrade one (single node) nodepool's k8s version
 - downgrade one (different, single node) nodepool's k8s version

## 현상황
Design work done
- Logging systems
Design work going on
- Monitoring system
- Etcd hardening
- K2 community defaults work

Operati0nal Issues
- K2-tools build Issues
- K2 CI image push Issues

## 장기계획

- continued support for direct client requests
- heavy and light cluster level logging solutions
- cluster Monitoring solutions
- bare metal provider (MAAS)
- etcd management/hardening
- using kubeADM for node configuration -> K8S community is not replacement for kops or k2, 1.8 부터 kubeadm이 나오면 첫번째로 적용하는 프로젝트가 될 것임.
- participating in community wide platform tooling discussion
- participate in kubernetes beta vetting

## CNCT의 개발 문화 소개

bundle exec jekyll serve

1. slack

2. confluence

3. github

4. Jenkins

5. quay.io

6. MAC+4k


etcd / etcdevent
다른 OS support
gke?
cloud config on aws & gke
rest api plan
