---
layout: posts
title:  "Ansible Trouble shooting guide"
date:   2017-05-11 19:35:00 -0700
categories:  ansible
classes: wide
---
## Ansible Trouble shooting guide

Ansible 테스트 환경을 구축하려다가 겪은 몇가지 트러블 슈팅을 정리 해보았다.

### 1. SSH키로 접속을 하려고 하는 패스워드를 물어볼 때

타켓 노드에 SSH 키 정보를 추가하고 나서 SSH로 접속을 하려고 하는데 아이디의 패스워드를 입력하라고 하면  물어보면 해당 타켓 노드의 리눅스 OS 의 SSH 설정을 변경해야한다.

SSH가 애초에 설치가 되어 있지 않다면 설치부터한다.
```
$ sudo apt-get install openssh-server
```

디폴트  SSH 설정을 백업한다. 읽기 전용으로 만들어놓고 언제든지 참고해서 볼 수 있다.
```
$ sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.factory-defaults
$ sudo chmod a-w /etc/ssh/sshd_config.factory-defaults
```

vi 같은 에디터를 통해서 설정을 변경할수 있다.
```
$ sudo vi /etc/ssh/sshd_config
```

`PasswordAuthentication yes` 의 항목을 찾아서 다음과 같이 설정한다.
```
PasswordAuthentication no
```

설정을 변경했다면 다음의 명령어로 SSH를 재기동하여 새로운 설정을 적용한다.
```
$ sudo restart ssh
```

"Unable to connect to Upstart" 와 같은 에러가 뜬다면 다음의 명령어로 재시작한다.
```
$ sudo systemctl restart ssh
```

SSH에 관련된 자세한 링크는 아래를 참조한다 :

https://help.ubuntu.com/community/SSH/OpenSSH/Configuring

### 2. Ansible을 실행하는 유저와 타켓 노드의 유저가 달라서 SSH 접속이 안되는 문제

위와 같이 SSH 접속문제를 해결했는데 또 이런 에러를 볼 수 있다
```
192.168.33.10 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Permission denied (publickey).\r\n",
    "unreachable": true
}
```
왜 그럴까? 일반적으로는 타켓 노드에 SSH 접속을 하는 마스터 유저와 타겟 노드에 저장되어있는 키 정보가 매칭이 되지 않아 나는 문제이다. 타켓 노드와 마스터 노드의 유저를 맞추고 해당 유저의 루트 디렉토리에 있는  authorized_keys에 다시 한번 SSH 키 정보를 추가해줘야 한다. 타멧 노드의 동일한 이름의 유저가 존재한다면 거기다가 키만 추가하면 끝나지만 아니라면 새롭게 유저를 추가하도록 한다.


타켓 서버에 루트 권한으로 접속해서  유저를 추가하고 권한을 부여한다.
```
$ adduser username # 마스터 노드 -> 타켓 노드에 접속할 때 사용하는 유저명과 동일하도록
```
그럼 다음과 같이 패스워드를 입력하라고 한다
```
Set password prompts:
Enter new UNIX password:
Retype new UNIX password:
passwd: password updated successfully
```

패스워드를 정상적으로 2번 입력하면 다음의 화면으로 넘어간다.
```
User information prompts:
Changing the user information for username
Enter the new value, or press ENTER for the default
    Full Name []:
    Room Number []:
    Work Phone []:
    Home Phone []:
    Other []:
Is the information correct? [Y/n]
```
위의 부가 정보를 입력하고 나면 유저가 생성된다.

```
$ usermod -aG sudo username
```
위와 같이  sudo 그룹에 유저를 포함 시켜 슈퍼 유저 권한을 부여해준다.(ubuntu기준)

참고: https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-ubuntu-quickstart

### 3. module_stdout: "/bin/sh: 1: /usr/bin/python: not found\\r\\n" 와 같은 에러출력

타켓 노드에  다음과 같이 파이썬을 설치하면 된다.
```
$ sudo apt-get -y install python-simplejson
```
참고: https://github.com/ansible/ansible/issues/19605


### 4. 더 쉽게 테스트 환경을 꾸미기 위한 좋은 대안


_** 이 가이드에서는 유저를 직접 추가하는 방법을 선택했는데 ansible 명령어에서 유저를 바꿔서 실행을 할 수 있다. 하지만 이렇게 하지 않고 유저를 굳이 맞추는 건 나중에 K8S 클러스터를 구성할 때 노드 별로 일관된 방식으로 유저를 생성하고 컨트롤하기 위함이다. 개별적인 테스트를 한다면 당연히 ansible 명령어에서 유저를 셋업하고 실행하는 것이 좋다.**_

동일한 설정을 가지고 있고 SSH 설정이 디폴트로 되어있는 Vagrant Linux 이미지로 Vagrant Ubuntu 가상 머신 2대를 띄워서 마스터 노드 및  구축하면 유저 설정을 할 필요없이 바로 테스트가 가능하다. 너무 당연한 소리겠지만...^^;;; 타켓 노드 인스턴스를 직접 생성하고 변경을 해야하는 작업이 필요한 경우가 많이 있을 것 같아서 미리 트러블 슈팅 가이드를 작성해봤다.
