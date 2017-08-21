---
layout: post
title:  "Ansible Trouble shooting guide"
date:   2017-06-08 19:35:00 -0700
categories:  ansible
---

##  CNCT github flow

K8S install in centos7

	1. latest install(kubeadm)
		- single master, single etcd 만 설치 가능
		- HA 구성(multi master)는 아직 진행중

	2. old install(manual)
		- manual 하게 설정을 다 해줘야해서, package, service, port 등의 이해가 필요
		- kube-apiserver, kube-scheduler, kube-controller-manager, kubelet, kube-proxy를 서비스로 제공
		- 위의 서비스들은 systemd 에 의해서 운영되고 설정됨. (/etc/kubernetes)
		- kubernetes master
			- kube-apiserver
			- kube-scheduler
			- kube-contoller-manger
			- etcd
			- flanneld (network)
		- kubernetes worker
			- kubelet
			- kube-proxy
			- cadvisor
			- docker
			- flanneld (network)

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*Referenece document
https://kubernetes.io/docs/getting-started-guides/centos/centos_manual_config/

*AMI ID
dcos-centos7-201703071404 (ami-1251dd72)

*centos-master
	50.112.143.39
*centos-worker-1
	52.11.217.232
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

1. yum repository 수정(ALL)

*********************************************************************************
/etc/yum.repos.d/virt7-docker-common-release.repo
-------------------------------------------------
[virt7-docker-common-release]
name=virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os/
gpgcheck=0
*********************************************************************************



2. k8s packages 설치(ALL)
	sudo yum list installed|grep docker
	sudo yum -y remove docker-engine-selinux
	sudo yum -y remove docker-engine.x86_64

#sudo yum -y install --enablerepo=virt7-docker-common-release kubernetes etcd flannel
sudo yum -y install --skip-broken --enablerepo=virt7-docker-common-release kubernetes etcd flannel
#sudo yum -y remove --skip-broken --enablerepo=virt7-docker-common-release kubernetes etcd flannel


3. hosts file 수정(ALL)
*********************************************************************************
/etc/hosts
----------
50.112.143.39	centos-master
52.11.217.232	centos-worker-1
*********************************************************************************



4. k8s config 수정(ALL)
*********************************************************************************
/etc/kubernetes/config
----------------------
# logging to stderr means we get it in the systemd journal
KUBE_LOGTOSTDERR="--logtostderr=true"

# journal message level, 0 is debug
KUBE_LOG_LEVEL="--v=0"

# Should this cluster be allowed to run privileged docker containers
KUBE_ALLOW_PRIV="--allow-privileged=false"

# How the replication controller and scheduler find the kube-apiserver
KUBE_MASTER="--master=http://centos-master:8080"
*********************************************************************************



5-1. etcd 설정 수정 (Master)
*********************************************************************************
/etc/etcd/etcd.conf
-------------------
# [member]
ETCD_NAME=default
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379"

#[cluster]
ETCD_ADVERTISE_CLIENT_URLS="http://0.0.0.0:2379"
*********************************************************************************



5-2. k8s apiserver 수정 (Master)
*********************************************************************************
/etc/kubernetes/apiserver
-------------------------
# The address on the local server to listen to.
KUBE_API_ADDRESS="--address=0.0.0.0"

# The port on the local server to listen on.
KUBE_API_PORT="--port=8080"

# Port kubelets listen on
KUBELET_PORT="--kubelet-port=10250"

# Comma separated list of nodes in the etcd cluster
KUBE_ETCD_SERVERS="--etcd-servers=http://centos-master:2379"

# Address range to use for services
KUBE_SERVICE_ADDRESSES="--service-cluster-ip-range=10.254.0.0/16"

# Add your own!
KUBE_API_ARGS=""
*********************************************************************************



5-3. etcd 재시작 및 etcd관련 값 추가 (Master)
systemctl start etcd
etcdctl mkdir /kube-centos/network
etcdctl mk /kube-centos/network/config "{ \"Network\": \"172.30.0.0/16\", \"SubnetLen\": 24, \"Backend\": { \"Type\": \"vxlan\" } }"



5-4. flanneld 수정 (Master)
*********************************************************************************
/etc/sysconfig/flanneld
-----------------------
# Flanneld configuration options

# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD_ENDPOINTS="http://centos-master:2379"

# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_PREFIX="/kube-centos/network"

# Any additional options that you want to pass
#FLANNEL_OPTIONS=""
*********************************************************************************




5-5. kubernetes 서비스 시작 (Master)

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler flanneld; do
systemctl restart $SERVICES
systemctl enable $SERVICES
systemctl status $SERVICES
done

kubectl config set-cluster default-cluster --server=http://centos-master:8080
kubectl config set-context default-context --cluster=default-cluster --user=default-admin
kubectl config use-context default-context



6-1. k8s kubelet 파일수정 (Worker)
*********************************************************************************
/etc/kubernetes/kubelet
-----------------------
# The address for the info server to serve on
KUBELET_ADDRESS="--address=0.0.0.0"

# The port for the info server to serve on
KUBELET_PORT="--port=10250"

# You may leave this blank to use the actual hostname
# Check the node number!
KUBELET_HOSTNAME="--hostname-override=centos-minion-n"

# Location of the api-server
KUBELET_API_SERVER="--api-servers=http://centos-master:8080"

# Add your own!
KUBELET_ARGS=""
*********************************************************************************



6-2. flanneld 수정 (Worker)
*********************************************************************************
/etc/sysconfig/flanneld
-----------------------
# Flanneld configuration options

# etcd url location.  Point this to the server where etcd runs
FLANNEL_ETCD_ENDPOINTS="http://centos-master:2379"

# etcd config key.  This is the configuration key that flannel queries
# For address range assignment
FLANNEL_ETCD_PREFIX="/kube-centos/network"

# Any additional options that you want to pass
#FLANNEL_OPTIONS=""
*********************************************************************************



6-3. kubernetes worker

for SERVICES in kube-proxy kubelet flanneld docker; do
systemctl restart $SERVICES
systemctl enable $SERVICES
systemctl status $SERVICES
done

kubectl config set-cluster default-cluster --server=http://centos-master:8080
kubectl config set-context default-context --cluster=default-cluster --user=default-admin
kubectl config use-context default-context




7. k8s 서비스 확인

kubectl get nodes


8. simple test

--------------------------------
$ vi nginx_pod.yaml


apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
--------------------------------

tr#1 kubernetes 설치 후 rc생성 -> containerCreating 상태에서 막힌 경우,

	https://serverfault.com/questions/728727/kubernetes-stuck-on-containercreating

	kubectl describe po <pod name> 이로 조회시 에러메세지추출

	Error syncing pod, skipping: failed to "StartContainer" for "POD" with ErrImagePull:
	"image pull failed for registry.access.redhat.com/rhel7/pod-infrastructure:latest,
	this may be because there are no credentials on this request.  
	details: (Get https://registry.access.redhat.com/v1/_ping: dial tcp 209.132.182.63:443: i/o timeout)"

tr#2 k8s설치 후 rc를 구동하였는데, No API token found for service account "default" 관련 error 발생할 경우

https://github.com/kubernetes/kubernetes/issues/11355#issuecomment-127378691
