---
layout: post
title:  "Kubernetes Kubectl Basics"
date:   2017-08-21 19:35:00 -0700
categories:  kubernetes
---

# Kubernetes kubectl Deployment object usage

### login & logout
```yaml
$ docker login <URL> # eg) docker login sds.redii.net
$ docker logout sds.redii.net
```

### create
```yaml
$ kubectl create -f nginx-deployment.yaml --record
```
Setting the kubectl flag --record to true allows you to record current command in the annotations of the resources being created or updated. It is useful for future introspection: for example, to see the commands executed in each Deployment revision.

### get
```yaml
$ kubectl get deployments
```

### get rollout history
```yaml
$ kubectl rollout history deployment/nginx-deployment
```

### delete
```yaml
$ kubectl delete deployment nginx-deployment
```


### Run command on a pod
```yaml
$ kubectl exec <POD-NAME> cat /var/jenkins_home/secrets/initialAdminPassword
```

### expose pod to external
```yaml
$ kubectl expose deployment jenkins-deployment --port 8080 --type NodePort
```

### create service
```yaml
$ kubectl create -f service.xml
```

### describe service
```yaml
$ kubectl describe service jenkins
```
### delete service
```yaml
$ kubectl delete service jenkins
```
