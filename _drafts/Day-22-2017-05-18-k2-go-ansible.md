---
layout: post
title:  "studying"
date:   2017-05-11 19:35:00 -0700
categories:  kubenetes
---
## cluster up

Generate config.yaml
```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest ./up.sh --generate
```

Start Cluster up
```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest ./up.sh --config $HOME/.kraken/cappuccino.yaml
```

Verifying Cluster

```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest kubectl --kubeconfig ~/.kraken/cappuccino/admin.kubeconfig get nodes

```

Getting deployment
```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest kubectl --kubeconfig ~/.kraken/cappuccino/admin.kubeconfig get deployments --all-namespaces
```
Searching Helm Packaging
```
docker run $K2OPTS -e HELM_HOME=$HOME/.kraken/cappuccino/.helm -e KUBECONFIG=$HOME/.kraken/cappuccino/admin.kubeconfig quay.io/samsung_cnct/k2:latest helm search kubernetes-dashboard
```

installing kubernetes-dashboard
```
docker run $K2OPTS -e HELM_HOME=$HOME/.kraken/cappuccino/.helm -e KUBECONFIG=$HOME/.kraken/cappuccino/admin.kubeconfig quay.io/samsung_cnct/k2:latest helm --namespace kube-system install --namespace kube-system atlas/kubernetes-dashboard

```

finding DNS name for kubernetes-dashboard
```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest kubectl --kubeconfig ~/.kraken/cappuccino/admin.kubeconfig describe service kubernetes-dashboard --namespace kube-system

```
deploy a app on K8
```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest kubectl --kubeconfig ~/.kraken/cappuccino/admin.kubeconfig run nginx --image=nginx   --namespace="kube-system"
```

Destroy Cluster
```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest ./down.sh --config $HOME/.kraken/cappuccino.yaml
```



TASK [roles/kraken.services : Wait for ELBs to be deleted] *********************
FAILED - RETRYING: TASK: roles/kraken.services : Wait for ELBs to be deleted (120 retries left).


TASK [/kraken/ansible/roles/kraken.provider/kraken.provider.aws : Run terraform destroy] ***
