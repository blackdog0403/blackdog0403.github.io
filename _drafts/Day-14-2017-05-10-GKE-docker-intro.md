---
layout: post
title:  "Day14-Retrospective-GCE-K8S-Docker intro"
date:   2017-04-29 19:35:00 -0700
categories: K8S
---
# Kubernetes 맛보기 1편 -  도커 알아보기

도커는 어플리케이션을 만들고 배포하고 실행하기 쉽게 만들기 위한 오프소스 툴이다. 어플리케이션이 필요로 하는 디펜던시를 모두 포함하는 하나의 컨테이너 이미지들의 집합으로 팩키징 함으로써 그것을 가능하게 한다.

컨테이너 이미지들은 도커가 설치되어있는 어떤 머신 위에서도 실행이 가능하다. 그로 인해서 재생산성과 일관성을 가진다. 컨테이너는 빠르게 실행됐다가 바로 종료가(밀리세컨드 단위로.) 되는 프로세스와 같다고 할 수 있는데 동시에 컨테이너는 같은 머신위에서 돌아가는 어플리케이션간을 고립시킬 수 있는 버추얼 머신의 이점도가지고 있다. 다시 말해 우리는 어플리케이션들이 실행되는 환경의 의존성 충돌에 대해서 전혀 걱정을 할 필요가 없다는 이야기다.

아래의 실습을 통해서 도커의 기본적인 개념을 이해해보도록 하자. 좀 더 자세하게 내용을 읽어보고 싶다면 도커 홈페이지로 가서 확인하도록 한다.

https://www.docker.com/what-docker
https://opensource.com/resources/what-docker

## GCE로 실습하기


구글 계정을 만들고

https://cloud.google.com/free/

에 접속한다. 프로젝트를 생성하고 콘솔에 접속한다.

### 우분투 인스턴스 생성하고 접속하기

compute zone을 확인하고 설정을 한다.

```bash
$ gcloud compute zones list
$ gcloud config set compute/zone <zone>
```

우분트 16.04 이미지를 이용해서 구글 클라우드 컴퓨트 인스턴스를 생성한다.
```bash
$ gcloud compute instances create ubuntu \
--image-project ubuntu-os-cloud \
--image ubuntu-1604-xenial-v20160420c
```

새롭게 만든 우분투 인스턴스에  SSH 로 접속한다.
```bash
$ gcloud compute ssh ubuntu
```

### 우분투 인스턴스에 도커 설치하기

우분투 인스턴스에 도커를 설치한다
```bash
$ sudo apt-get install docker.io
```

도커 이미지 리스트를 확인함으로서 설치가 된 것을 확인하다.
```bash
$ sudo docker run hello-world
```

## 도커를 이용해서 이미지 실행하기

nginx  이미지를 내려받고  이미지를 확인해보자
```bash
$ sudo docker pull nginx:1.10.0
$ sudo docker images
```

nginx 이미지를 실행한다. -d 옵션은 백그라운드로 이미지를 실행한다는 뜻이다.
```bash
$ sudo docker run -d nginx:1.10.0
```

컨테이너가 제대로 실행됐는지 확인한다.
```
$ sudo docker ps
$ sudo ps aux | grep nginx
```

다른 버전의 nginx를 여러개를 동시에 띄워보자.
```bash
$ sudo docker run -d nginx:1.9.3
```
또 다른 버전의 nginx 를 띄워보자
```bash
sudo docker run -d nginx:1.10.0
```

몇개의 인스턴스가 떠 있는지 확인해보자.
```
sudo docker ps
sudo ps aux | grep nginx
```

위에서 볼 수 있듯이 하나의 리눅스 인스턴스 위에서 다른 버전의 nginx 서버를 동시에 실행을 할 수 있다. 일반적인 리눅스 팩키지를 설치하고 실행했었다면 단일 버전의 nginx를 설치하고 필요한 의존관계에 있는 라이브러리까지 다 OS에 설치를 했어야했다. 어플리케이션을 컨테이너화 하는 장점이 바로 이 점이라고 할 수 있다. 도커로 표준화된 이미지를 제작하면 OS나 라이브러리 같은 환경에 구애받지 않고  어느 곳에서나  (도커가 설치되어 있는 ) 사용자가 원하는 어플리케이션을 실행할 수 있다.

이런 컨테이너의 특성은 지속적인 배포를 하는 환경에서 더욱 장점을 발휘하게 된다. 전통적인 방식의 배포환경에서는 배포를 자동화하는데 있어서 배포가 될 타켓 인스턴스에 어플리케이션이 배포되서 실행할 수 있는 환경을 미리 고민을 했어야한다. OS 의 버전이라던지 필요한 라이브러리, 실행환경에 대한 프로비저닝을 수행하고 어플리케이션을 배포해야하는데 그 마저도 해당 OS인스턴스에는 해당 어플리케이션만 배포가 가능했었다(해당환경에서 실행이 가능한 어플리케이션들만). 컨테이너화된 어플리케이션을 배포한다면 도커가 설치되어있는 어느 OS라도 배포가 가능하다. 이는 어플리케이션을 유연성을 높이고 리소스의 재사용성을 높여준다.



## 도커 인스턴스 다루기

### 실행중인 도커 인스턴스 리스트 보기

```bash
$ sudo docker ps
```

다음과 같이 컨테이너 아이디만 출력할 수도 있다. (-a는 모든 인스턴스를 뜻하고 -q 는 quiet 모드를 뜻한다.)
```bash
$  sudo docker ps -aq
```

### 컨테이너 검사하기(inspect)
`sudo docker ps -a`  를 실행하면 다음과 비슷한 결과를 출력할 것이다.
```bash
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS
             PORTS               NAMES
f63e3ae026e1        nginx:1.10.0        "nginx -g 'daemon off"   About an hour ago   Up About an hour    80/tcp, 443/tcp     suspicious_euler
e90a251fcf28         nginx:1.9.3          "nginx -g 'daemon off"   About an hour ago   Up About an hour    80/tcp, 443/tcp     cranky_noyce
92fdc2bb9b61        nginx:1.10.0        "nginx -g 'daemon off"   About an hour ago   Up About an hour    80/tcp, 443/tcp     drunk_shockley
```

다음과 같이 컨테이너를 인스펙션 할 수 있다.
```bash
$ sudo docker inspect f63e3ae026e1
$ sudo docker inspect suspicious_euler
```

### 내부IP를 이용해서 nginx에 접속하기

인스펙션을 통해 나온 결과에서 IP를 복사해서 붙여넣을 수도 있고 다음과 같이 환경변수를 통해서 접근하는 방법도 있다. 각자가 편한 방법으로 접속해보도록 하자

```bash
$ CN="suspicious_euler"
$ CIP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CN)
$ curl  http://$CIP
```

json파일을 -f 옵션과 파라메터를 활용해서 다음과 같이 컨테이너별로 아이피를 출력할 수 도 있다.
```bash
$ sudo docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(sudo docker ps -aq)
```

### 인스턴스 중단하기

```bash
$ sudo docker stop <cid> or <컨테이너명>
```
또는 다음과 같이 모든 컨테이너를 중지 시킬 수 있다.

```bash
$ sudo docker stop $(sudo docker ps -aq)
```
### 실행중인 인스턴스 확인하기
모든 컨테이너를 멈췄다면 다음의 명령어로 확인할 수 있다.
```bash
$ sudo docker ps
```

### 도커 컨테이너 삭제하기

```bash
$ sudo docker rm <cid> or <컨테이너명>
```
또는 다음과 같이 모든 컨테이너를 삭제할 수 있다. 헷갈리지 말아야하는 것은 컨테이너를 삭제하는 것이지 이미지를 삭제하는것이 아니라는 점이다.

```bash
$ sudo docker rm $(sudo docker ps -aq)
```

## 컨테이너 이미지 만들기

### GO 설치하기
```bash
wget https://storage.googleapis.com/golang/go1.6.2.linux-amd64.tar.gz
rm -rf /usr/local/bin/go
sudo tar -C /usr/local -xzf go1.6.2.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export GOPATH=~/go
```

### 소스 코드 다운받기
```bash
mkdir -p $GOPATH/src/github.com/udacity
cd $GOPATH/src/github.com/udacity
git clone https://github.com/udacity/ud615.git
```
### 빌드해서 바이너리 파일만들기
```bash
cd ud615/app/monolith
go get -u
go build --tags netgo --ldflags '-extldflags "-lm -lstdc++ -static"'
```

### 이미지로부터 컨테이너 생성하기
```bash
$ cat docker file
```
monolith앱 이미지를 만든다.
```bash
$ sudo docker build -t monolith:1.0.0 .
```
생성된 이미지 확인하기.
```bash
$ sudo docker images monolith:1.0.0
```
### monolith 컨테이너를 실행해서 IP를 확인하기
```bash
$ sudo docker run -d monolith:1.0.0
$ sudo docker inspect <container name or cid>
```
혹은

```bash
$ CID=$(sudo docker run -d monolith:1.0.0)
$ CIP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CID})
```
### 컨테이너 테스트하기
```bash
$ curl <the container IP>
```

혹은

```bash
$ curl $CIP
```

다음과 같은 결과를 얻을 수 있다
```bash
{"message":"Hello"}
```

## 마이크로 서비스를 위해서 auth 앱과 hello 앱 만들기

### auth 앱 만들기
```bash
$ cd $GOPATH/src/github.com/udacity/ud615/app
$ cd auth
$ go build --tags netgo --ldflags '-extldflags "-lm -lstdc++ -static"'
$ sudo docker build -t auth:1.0.0 .
$ CID2=$(sudo docker run -d auth:1.0.0)
```
### hello 앱 만들기
```bash
$ cd $GOPATH/src/github.com/udacity/ud615/app
$ cd hello
$ go build --tags netgo --ldflags '-extldflags "-lm -lstdc++ -static"'
$ sudo docker build -t hello:1.0.0 .
$ CID3=$(sudo docker run -d hello:1.0.0)
```
다음으로 실행중인 앱들을 확인한다.
```bash
$ sudo docker ps -a
```

## 새롭게 만든 이미지를 도커 허브에 등록하기

### 이미지 확인하고 태그 명령어 알아보기

어떤 이미지가 있는지 다시 한번 확인해보자.
```bash
$ sudo docker images
```
태그 명령어에 대한 설명은 다음 명령어로 볼 수 있다.
```bash
$ docker tag -h
```
### 태그 추가하기

```bash
$ sudo docker tag monolith:1.0.0 <your username>/monolith:1.0.0
```
예를 들면 다음과 같다.( 저장소에 올라가는 이름은 자기 마음대로 바꿀수 있다.)
```bash
$ sudo docker tag monolith:1.0.0 blackdog0403/example-monolith:1.0.0
```

### Dockerhub에 계정 만들기.
Dockerhub 에 이미지를 올리기 위해서는 계정을 생성해야한다. - https://hub.docker.com/register/

### 로그인하고 이미지 push 하기
$ sudo docker login
$ sudo docker push blackdog0403/example-monolith:1.0.0

### auth 앱, hello 앱도 반복해서 도커 허브에 푸쉬하기

```
$ sudo docker tag auth:1.0.0 blackdog0403/example-auth:1.0.0
$ sudo docker tag hello:1.0.0 blackdog0403/example-hello:1.0.0
$ sudo docker push blackdog0403/example-auth:1.0.0
$ sudo docker push blackdog0403/example-hello:1.0.0
```
