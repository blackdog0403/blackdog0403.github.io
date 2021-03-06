---
layout: posts
title:  "Kubernetes Kubectl Basics"
date:   2017-08-21 19:35:00 -0700
categories:  kubernetes
classes: wide
---

# Kubernetes kubectl Deployment object usage

### create
```bash
$ kubectl create -f nginx-deployment.yaml --record
```
Setting the kubectl flag --record to true allows you to record current command in the annotations of the resources being created or updated. It is useful for future introspection: for example, to see the commands executed in each Deployment revision.

### get
```bash
$ kubectl get deployments
```

### get rollout history
```bash
$ kubectl rollout history deployment/nginx-deployment
```

### delete
```bash
$ kubectl delete deployment nginx-deployment
```

### Watching pods
```bash
$ kubectl get pods -owide --watch
```
### Run command on a pod
```bash
$ kubectl exec <POD-NAME> cat /var/jenkins_home/secrets/initialAdminPassword
```
### get pod ip
```bash
$ kubectl get pods -o jenkins-deployment-1818597696-2bhtg -o yaml | grep podIP
```
### expose pod to external
```bash
$ kubectl expose deployment jenkins-deployment --port 8080 --type NodePort
```

### create service
```bash
$ kubectl create -f service.xml
```

### describe service
```bash
$ kubectl describe service jenkins
```
### delete service
```bash
$ kubectl delete service jenkins
```

### get service info
```bash
$ kubectl get svc jenkins-deployment -o yaml | grep nodePort -C 5
```
