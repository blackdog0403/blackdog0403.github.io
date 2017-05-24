---
layout: post
title:  "Ansible Trouble shooting guide"
date:   2017-05-11 19:35:00 -0700
categories:  ansible
---
## errora

TASK [/kraken/ansible/roles/kraken.fabric/kraken.fabric.flannel : check kube-networking namespace state] ***
fatal: [localhost]: FAILED! => {"changed": false, "cmd": ["/opt/cnct/kubernetes/v1.5/bin/kubectl", "--kubeconfig=/Users/blackdog/.kraken/cappuccino/admin.kubeconfig", "get", "namespace", "kube-networking"], "delta": "0:00:00.331527", "end": "2017-05-19 17:18:08.099517", "failed": true, "rc": 1, "start": "2017-05-19 17:18:07.767990", "stderr": "Error from server (NotFound): namespaces \"kube-networking\" not found", "stdout": "", "stdout_lines": [], "warnings": []}
...ignoring


TASK [roles/kraken.services : See if tiller rc if present] *********************
fatal: [localhost]: FAILED! => {"changed": true, "cmd": "/opt/cnct/kubernetes/v1.5/bin/kubectl --kubeconfig=/Users/blackdog/.kraken/cappuccino/admin.kubeconfig get deployment tiller-deploy --namespace=kube-system", "delta": "0:00:00.396206", "end": "2017-05-19 17:18:14.909377", "failed": true, "rc": 1, "start": "2017-05-19 17:18:14.513171", "stderr": "Error from server (NotFound): deployments.extensions \"tiller-deploy\" not found", "stdout": "", "stdout_lines": [], "warnings": []}
...ignoring
