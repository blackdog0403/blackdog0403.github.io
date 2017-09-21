---
layout: "post"
title: "How to install helm on local server"
date: "2017-09-11 18:32"
categories:  kubernetes
---

# How to install helm on local server

## reference
https://docs.helm.sh/using_helm/#installing-helm

## Installing helm

1. Download your desired version
 https://storage.googleapis.com/kubernetes-helm/helm-v2.6.1-linux-amd64.tar.gz

2. Transfer tar file to kubenetes cluster node
```bash
$ scp helm-v2.6.1-linux-amd64.tar.gz root@<k8sClusterIpURL>:/root/<blackdog>
```
3. SSH to the k8s cluster node.

4. Unpack it
```bash
$ tar -zxvf helm-v2.6.1-linux-amd64.tar.gz
```

5. Move to the directory which is on $PATH
```bash
$ mv linux-amd64/helm /usr/local/bin/helm
```

6. Check whether it's properly installed.
```bash
$ mv linux-amd64/helm /usr/local/bin/helm
```

## Setup helm

0. Before we start, we need to get proper images for tiller pod. it doesn't work cause you cannot access external network!
```bash
$ docker pull gcr.io/kubernetes-helm/tiller:v2.6.1
$ docker tag gcr.io/kubernetes-helm/tiller:v2.6.1 <yourprivateregistry>/<repo>/<imagename>:<tag>
$ docker push <yourprivateregistry>/<repo>/<imagename>:<tag>
```

1. Helm initializing
```bash
$ helm init --tiller-image=<tiller-image-name> --tiller-namespace=<tiller-namespace>
# $ helm init --tiller-image=sds.redii.net/sdspaas/tiller:v2.6.1 --tiller-namespace=jenkins
```

2. Make directory for local helm chart repo
```bash
$ mkdir /home/jenkins/charts
```

3. Start local helm charts repository(It's web server)
```bash
$ helm serve --address <IP>:<PORT> --repo-path <LOCAL_HELM_CHART_PATH> &
# $ helm serve --address 70.121.224.196:8880 --repo-path /home/jenkins/charts &
```

helm serve --address 70.121.224.196:8870--repo-path /home/jenkins/charts &

4. Helm local repo add as 'dev'
```bash
$ helm repo add dev <http://ip:port/charts>
```

5. helm repo update
```bash
$ helm repo update
```

6. Now you can search helm charts
```bash
$ helm search
```

### Repositories.yaml sample
```yaml
apiVersion: v1
generated: 2017-09-18T16:06:28.045868889+09:00
repositories:
- caFile: ""
  cache: /home/jenkins/.helm/repository/cache/dev-index.yaml
  certFile: ""
  keyFile: ""
  name: dev
  url: http:/<ip>:<port>/charts
```

## Add new chart on local helm repo

1. Helm local repo add as 'dev'
```bash
$ helm create mychart
```

2. Lint mychart
```bash
$ helm lint mychart
```

3. index repo
```bash
$ helm repo index
```

4. update repo
```bash
$ helm repo index
```







helm repo index /home/jenkins/charts --url http://70.121.224.196:8880
