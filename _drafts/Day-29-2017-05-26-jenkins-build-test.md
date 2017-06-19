---
layout: post
title:  "Ansible Trouble shooting guide"
date:   2017-05-11 19:35:00 -0700
categories:  ansible
---

##  CNCT github flow

set upstream (samsung-cnct/master) as remote from master
```
git checkout master
git remote add upsteam https://github.com/samsung-cnct/k2.git
git pull upstream master
```

```
$ git add .
```

```
$ git commit -m "modified units.kubelet.part.jinja2 for both of master & cluster node"
$ git push origin enabling-node-lable
$ git rebase upstream master
```


```
git config --globals user.name "Kwangyoung Allen Kim"
git config --globals user.email "blackdog0403@gmail.com"
```
```
git push origin enabling-node-lable
```
