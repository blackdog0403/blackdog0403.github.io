---
layout: "single"
title: "How to install docker-ce on ubuntu Xenial(16.04)"
date: "2017-09-07 23:02"
categories:  docker, kubernetes
classes: wide
---

# How to install docker-ce on ubuntu Xenial(16.04) on x86_64

## Reference

https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository

## Install using the repository

### Preperation, set up the repository

1. Update `apt` page index
```bash
$ sudo apt-get update
```
2. Install packages to allow apt to use a repository over HTTPS:
```bash
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```
3. Add Docker’s official GPG key:

```bash
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

 Verify that the key fingerprint is
> 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88.

```bash
$ sudo apt-key fingerprint 0EBFCD88

pub   4096R/0EBFCD88 2017-02-22
      Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22
```

4. Add repository
```bash
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

*Now we are ready to install docker-ce, woo!*

### Install Docker CE
1. Update the apt package index.
```bash
$ sudo apt-get update
```

2. Install latest version of docker-ce
```bash
$ sudo apt-get install docker-ce
```

3. If you want install specified version of docker-ce
```bash
$ sudo apt-get install docker-ce=<version>
```

Then you can run hello-world docker image and can see the message below

```
$ sudo docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://cloud.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/engine/userguide/

```
