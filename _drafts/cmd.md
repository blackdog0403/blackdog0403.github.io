```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest kubectl --kubeconfig $HOME/.kraken/cappucci/admin.kubeconfig get nodes
```

```
docker run $K2OPTS -e HELM_HOME=$HOME/.kraken/cappuccino/.helm -e KUBECONFIG=$HOME/.kraken/cappuccino/admin.kubeconfig quay.io/samsung_cnct/k2:latest helm list
```

```
ssh master-3 -F ~/.kraken/cappuccino/ssh_config
```

```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest kubectl --kubeconfig ~/.kraken/cappuccino/admin.kubeconfig get deployments --all-namespaces
```

```
docker run $K2OPTS -e HELM_HOME=$HOME/.kraken/cappuccino/.helm -e KUBECONFIG=$HOME/.kraken/cappuccino/admin.kubeconfig quay.io/samsung_cnct/k2:latest helm search kubernetes
```

```
docker run $K2OPTS -e HELM_HOME=$HOME/.kraken/cappuccino/.helm -e KUBECONFIG=$HOME/.kraken/cappuccino/admin.kubeconfig quay.io/samsung_cnct/k2:latest helm list
```
```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest kubectl --kubeconfig ~/.kraken/cappuccino/admin.kubeconfig describe service kubernetes-dashboard --namespace kube-system
```
```
docker run $K2OPTS quay.io/samsung_cnct/k2:latest ./down.sh --config $HOME/.kraken/cappuccino.yaml
```
