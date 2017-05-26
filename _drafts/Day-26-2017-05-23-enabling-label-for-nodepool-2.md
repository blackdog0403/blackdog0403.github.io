---
layout: post
title:  "Ansible Trouble shooting guide"
date:   2017-05-11 19:35:00 -0700
categories:  ansible
---
## run k2 container tool image with mounting k2 local repo directory for test

Using Hack/dockerdev
```
$ ./hack/dockerdev -c ~/.kraken/cappuccino.yaml
```
Spin up Cluster using hack
```
$ ./up.sh --config ~/.kraken/cappuccino.yaml
```

run k2-tools dokcer images in interactive mode.
```
$ docker run -v ~:/root -v /Users/blackdog/dev/k2:/workspace -e BUILD_TAG=true --rm -it quay.io/samsung_cnct/k2-tools   "/bin/sh"
```

get pods with labels
```
$ kubectl --kubeconfig=/Users/blackdog/.kraken/cappuccino/admin.kubeconfig get pods --show-labels
```

get nodes
```
$ kubectl --kubeconfig=/Users/blackdog/.kraken/cappuccino/admin.kubeconfig get nodes --show-labels
```

Install kubectl 1.6.0-beta.4 on Mac
```
$ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.6.0-beta.4/bin/darwin/amd64/kubectl
```

Give permisson
```
$ chmod +x ./kubectl
$ sudo mv ./kubectl /usr/local/bin/kubectl
```
