---
layout: "post"
title: "How to add user"
date: "2017-09-08 09:18"
categories:  linux
---

# How to add user

1. Check an user exists
```bash
$ cat /etc/passwd | grep testuser
```
2. Set home directory and shell env
- Ubuntu, SUSE
```bash
$ useradd <username> -m -s /bin/bash
```
-> `-m` option should be declared to make home directory
-> `-s /bin/bash` option should be declared set shell env
- CentOS
```bash
$ useradd <username>
```
-> CentOS or Redhat linux don't need to option for home directory and shell env

3. Make user with giving a group
```bash
$ useradd <username> -G <groupname>
```
4. Make user with UID 
`An UID is number`
```bash
$ useradd <username> -u <uid>
```
