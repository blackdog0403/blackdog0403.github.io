# Run a kubernetes cluster on GKE

This guide is very rough and lack of explanation.

### create a cluster on gke
```bash
$ gcloud container clusters create k0
```

## Pod

pod  -> set of containers sharing volumes and network.

### run a container as pods
```
$ kubectl run nginx --image=nginx:1.10.0
```
### get list pods on this cluster
```bash
$ kubectl get pods
```
### get list pods on this cluster
```bash
$ kubectl expose deployment nginx --port 80 --type LoadBalancer
```

## Creating pods through yaml

###monolith.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: monolith
  labels:
    app: monolith
spec:
  containers:
    - name: monolith
      image: udacity/example-monolith:1.0.0
      args:
        - "-http=0.0.0.0:80"
        - "-health=0.0.0.0:81"
        - "-secret=secret"
      ports:
        - name: http
          containerPort: 80
        - name: health
          containerPort: 81
      resources:
        limits:
          cpu: 0.2
          memory: "10Mi"
```

### create monolith pod through kubectl

```bash
$ kubectl create -f pods/monolith.yaml
$ kubectl get pods
```
### Get Information about pods in detail
```bash
$ kubectl describe pods monolith
```


## Interacting with pods

### Set up port forwarding for pods

```bash
$ kubectl port-forward monolith 10080:80
```
### create jwt token for authorized access

[https://jwt.io](https://jwt.io)
```
{"token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ"}
```

### check the app status using new cloud shell session 2

```bash
$ curl http://127.0.0.1:10080
$ curl http://127.0.0.1:10080/secure

$ curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ" http://127.0.0.1:10080/secure
```

### then you can see the log
```bash
$ kubectl logs monolith
```
### sampel healthy-monolith
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: "healthy-monolith"
  labels:
    app: monolith
spec:
  containers:
    - name: monolith
      image: udacity/example-monolith:1.0.0
      ports:
        - name: http
          containerPort: 80
        - name: health
          containerPort: 81
      resources:
        limits:
          cpu: 0.2
          memory: "10Mi"
      livenessProbe:
        httpGet:
          path: /healthz
          port: 81
          scheme: HTTP
        initialDelaySeconds: 5
        periodSeconds: 15
        timeoutSeconds: 5
      readinessProbe:
        httpGet:
          path: /readiness
          port: 81
          scheme: HTTP
        initialDelaySeconds: 5
        timeoutSeconds: 1
```

### connect using interactive mode in new cloud shell session 2
```bash
$ kubectl exec monolith --stdin --tty -c monolith /bin/sh
```

## Secret and Config Map

### cert.pem and key.pem
For secure traffic on a monolith server

### ca.pem
The cert.pem and key.pem files will be used to secure traffic on the monolith server and the ca.pem will be used by HTTP clients as the CA to trust. Since the certs being used by the monolith server where signed by the CA represented by ca.pem, HTTP clients that trust ca.pem will be able to validate the SSL connection to the monolith server.

### create secet through files in tls directory
```bash
$ kubectl create secret generic tls-certs --from-file=tls/
$ kubectl describe secrets tls-certs
```

### create configmap through files in tls directory
```bash
$ kubectl create configmap nginx-proxy-conf --from-file=nginx/proxy.conf
$ kubectl describe configmap nginx-proxy-conf
```

### Create the secure-monolith Pod using kubectl.
```bash

$ kubectl create -f pods/secure-monolith.yaml
$ kubectl get pods secure-monolith

$ kubectl port-forward secure-monolith 10443:443
```
### Connect using interative mode in new cloud shell session 2
```bash
$ curl --cacert tls/ca.pem https://127.0.0.1:10443 # ca.pem has been expired
$ curl -k https://127.0.0.1:10443 # using insecure crul for test
$ kubectl logs -c nginx secure-monolith
```

### Example of multi-container pod
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: "secure-monolith"
  labels:
    app: monolith
spec:
  containers:
    - name: nginx
      image: "nginx:1.9.14"
      lifecycle:
        preStop:
          exec:
            command: ["/usr/sbin/nginx","-s","quit"]
      volumeMounts:
        - name: "nginx-proxy-conf"
          mountPath: "/etc/nginx/conf.d"
        - name: "tls-certs"
          mountPath: "/etc/tls"
    - name: monolith
      image: "udacity/example-monolith:1.0.0"
      ports:
        - name: http
          containerPort: 80
      ports:
        - name: health
          containerPort: 81
      resources:
        limits:
          cpu: 0.2
          memory: "10Mi"
      livenessProbe:
        httpGet:
          path: /healthz
          port: 81
          scheme: HTTP
        initialDelaySeconds: 5
        periodSeconds: 15
        timeoutSeconds: 5
      readinessProbe:
        httpGet:
          path: /readiness
          port: 81
          scheme: HTTP
        initialDelaySeconds: 5
        timeoutSeconds: 1
  volumes:
    - name: "tls-certs"
      secret:
        secretName: "tls-certs"
    - name: "nginx-proxy-conf"
      configMap:
        name: "nginx-proxy-conf"
        items:
          - key: "proxy.conf"
            path: "proxy.conf"
```
## Services
**Persistent Endpoint for Pods**
- Use Labels to Select Pods
- Internal or External IPs

### Types of services
- ClusterIP: Exposes the service on a cluster-internal IP. Choosing this value makes the service only reachable from within the cluster. This is the default ServiceType.

- NodePort: Exposes the service on each Node’s IP at a static port (the NodePort). A ClusterIP service, to which the NodePort service will route, is automatically created. You’ll be able to contact the NodePort service, from outside the cluster, by requesting <NodeIP>:<NodePort>.

- LoadBalancer: Exposes the service externally using a cloud provider’s load balancer. NodePort and ClusterIP services, to which the external load balancer will route, are automatically created.

- ExternalName: Maps the service to the contents of the externalName field (e.g. foo.bar.example.com), by returning a CNAME record with its value. No proxying of any kind is set up. **This requires version 1.7 or higher of kube-dns.**

[http://kubernetes.io/docs/user-guide/services/](http://kubernetes.io/docs/user-guide/services/)


### create a service and expose to external

#### example of services/monolith.yaml
```yaml
kind: Service
apiVersion: v1
metadata:
  name: "monolith"
spec:
  selector:
    app: "monolith"
    secure: "enabled"
  ports:
    - protocol: "TCP"
      port: 443 # containers port?
      targetPort: 443 # service port?
      nodePort: 31000 # node port
  type: NodePort
```

```bash
$ kubectl create -f services/monolith.yaml
```
open the port behind firewall
```bash
$ gcloud compute firewall-rules  create allow-monilith-nodeport --allow=tcp:31000
```
get the  node ip..
```bash
$ gcloud compute instances list
```
then curl the ip:port
```bash
$ curl -k https://35.185.236.60:31000
```

**Doesn't work!!**

check status of pods...
```bash
$ kubectl get pods -l "app=monolith"
$ kubectl get pods -l "app=monolith,secure=enable"
```
Nothings comes out. What happened?

Let's check again with
```bash
$ kubectl describe pods secure-monolith | grep Labels
```
We missed the define 'secure=enable' label for the pods
It seems like there is no proper label for it. Lets add!
```bash
$ kubectl label pods secure-monolith "secure=enabled"
```
Then retry curl

```bash
$ curl -k https://35.185.236.60:31000
```
Bam! it works.
