---
layout: post
title:  "Samsung-cnct's How we work"
date:   2017-07-11 19:35:00 -0700
categories:  Agile development
---

# Samsung-cnct's How we work

 안녕하세요? 최근 연구소에서 개발 센터로 둥지를 옮긴 개발혁신팀 Devops Lab의 김광영 프로라고 합니다.  저는 CICD 셀에서 배포툴을 개발하던 중 Global Exchange Program(이하  GEP)에 선발되어 현재 미국 Seattle의 Cloud Native Computing Team(이하 CNCT)에서  K2(Kraken2) [https://github.com/samsung-cnct/k2 - (Kraken2)](https://github.com/samsung-cnct/k2) 라는 오픈소스 프로젝트 개발에 참여하고 있습니다.

 지난 2편에서  CNCT (Cloud Natibe Computing Team) 이 어떤식으로 일을 하는지에 대해서 간략하게 알아보았습니다. 오늘은 CNCT 안에 있는 Common-tool team이 일하는 방식과 GIthub에서의 리뷰에 대해서 좀 더 상세하게 소개를 하려고 합니다.  

 +1) 지난 편들 링크도 첨부합니다. 관심 있으신 분들은 찾아보시길 바랍니다.



##  CNCT Common tool team's how we work

CNCT에는 현재 다음과 같은 팀들이 있습니다. 팀 마다 약간의 차이는 있지만 전체적인 일하는 방식은 거의 동일하다고 생각을 하시면 됩니다. 고객지원을 하는 팀들은 어쩔 수 없이 deadline 이 생기기는 하지만 그래도 전체적인 일하는 방식은 애자일 방식을 유지를 하려고 노력을 하고 있습니다. 납기가 있는 애자일(?) 이라고 생각하시면 될 것 같습니다.

현재 CNCT에는 다음과 같은 팀들이 있습니다.

- Client engagements - 실제 고객사들과 프로젝트를 진행합니다. 기존의 시스템을 컨테이너화 해서 Kubernetes 클러스터로 올리는 작업을 하고 있습니다. (몇몇 회사들은 보안 관계상 이니셜만 공개합니다. 현재 공개적으로 프로젝트를 진행하는 회사는 Zonar 밖에 없는 걸로 알고 있습니다.)
   - Zonar
   - C모사 팀
   - R모사 팀
 - Emerging market - 새로운 고객과 컨택하고 기술적인 지원이전에 자문등을 하는 팀입니다.
 - Opensource -  Core Kubernetes 개발에 직접 참여하고 있는 팀입니다. Aaron 의 원맨팀.
 - Common-tool- 제가 일하고 있는 팀입니다.Kubernetes cluster 를 손쉽게 구성할 수 있는 K2 프로젝트에 관련된 모든 개발을 하고 있습니다.

Common-tool 팀은 저같은 익스체인지 엔지니어나 인턴부터 client engagements 팀으로 팀원들이 왔다갔다 하는 매우 유연한 인력구성을 한 팀입니다.  그래서 일을 효율적으로 하기 위해서 가능하한 가벼운 프레임워크를 만들려고 노력하여 팀원들이 여기에 오래 머무르지 않는 경우에 오버헤드를 최소화 하는게 매우 중요합니다.그래서 다음과 같은 방법으로 일을 하고 있습니다.

### Common tool team's Agile activities

[https://github.com/samsung-cnct](https://github.com/samsung-cnct)

현재 CNCT의 모든 팀의 거의 모든 프로젝트는 오픈소스 프로젝트입니다. 그래서 외부로 공개가 되어 있는 Github 을 기본적인 형상으로 사용하고 있으며 개발에 관련된 이슈 역시 Github을 통해서 관리하고 있습니다.  새로운 피처, 버그 픽스, 리서치와 문서 작업등 모든 작업은 Common Tools 프로젝트에 ( 유료로 사용하는 private 공간입니다. 여기는 외부로 공개가 안 됩니다. Github 엔터프라이즈 버전을 사용한다면 아마도 제한없이 사용할 수 있을 걸로 보이네요. ) 반드시 이슈를 등록해서 이루어져야 하고 진행중인 일들은 'In progress' 상태로 프로젝트에 두도록 합니다. ( 문서 공유라던지 리서치 내용 공유, 새로운 피처에 대한 디자인이나 아이디어들, 대외비 자료들 기록이 필요한 모든 것들은 Confluence를 통해서 작업을 합니다. Jira를 사용하긴 하지만 대부분의 이슈들은 Github에서 관리가 됩니다. )

다음은 common-tools에서 하고 있는 애자일 엑티비티 리스트입니다.

- Daily Standup for common-tools team - 15minutes ( 보통 10분 정도면 끝납니다.)
- Daily Standup for general - 10minutes

- Backlog Grooming (every other week) - 1hour -  Backlog Grooming은 프로덕트 오너와 일부 팀원들이 참여하여 Backlog에 적절한 아이템들이 있도록 정리하는 작업을 말합니다. 티켓(이슈)들을 정리해서 우선순위를 정하고 팀원들이 최우선순위에 있는 티켓들을 골라서 선별을 하는 작업입니다. 보통 2주 단위의 스프린트 중간에 해당 s작업을 합니다. 리뷰가 끝난 티켓들은 종료를 시키기도 하고 원래하려고 했던 티켓들도 상황에 따라서 배제를 하기도 합니다. 한국에 있을 때는 Backlog Grooming을 따로 진행한적이 없었는데 실제로 스프린트 중간점검과 같은 성격이라 얼마나 일이 잘 되고 있나 판단하는 좋은 액티비티라고 생각이 들었습니다. (일단 데모처럼 부담스럽지가 않습니다.)

- P2 Grooming (When we need, usually monthly) - 1hour
- P3 Grooming (When we need) - 1hour

- Sprint Planning (every other week) - 1hour  - Sprint Planning은 Backlog Grooming을 포함하여 진행되며 이번 스프린트에 할 일들을   To-do lane으로 다 옮깁니다. 2주안에 할 수 있을 정도의 티켓만  파이프라인에 올리고 나머지는 Backlog에서 추가적으로 골라서 작업을 하거나 중간에 이슈가 생기면 해당하는 이슈에 대한 작업을 하기도 합니다.

![kanban]({{ site.url }}/assets/20170710/kanban.png)

Github의 프로젝트 보드.  jira와 크게 다르지 않습니다.

Sprint Planning은 2주 단위로 진행하고 Sprint Planning이 없는 주에 Backlog Grooming을 하고 있습니다. **위를 보시면 알겠지만 Sprint Planning 이나 Backlog Grooming에 각 1시간 이상을 쓰지 않습니다. 거의 모든 회의는 1시간안에 정리하도록 시간관리를 철저하게 해서 팀원들이 실제로 일을 하는데 집중하도록 도와줍니다.** 일주일에 회의에 사용하는 시간은 1시간에서 2시간 정도라고 생각하면 됩니다.

위의 애자일 액티비티들을 잘 보시면 아시겠지만 따로 Retrostpective를 하지 않습니다. 이 부분에 대해서 궁금해서 Patrick 과 이야기를 해봤는데 스프린트 플래밍과 그루밍 그리고 Slack 채널이나 Github 상의 리뷰에서 충분히 우리가 한 일에 대해서 논의를 하고 있기 때문에 굳이 Retrostpective를 할 필요가 없다고 의견이 모여서 Retrostpective를 하지 않는다고 합니다. 충분히 커뮤니케이션을 하고 있고 무엇보다 개발에 집중을 할 수 있도록 개발자들을 배려하고 있는 모습을 느낄 수 있었습니다.

#### 참고 Common-tool team's  Ticket priorty

깃헙은 기본적으로 티켓(이슈) 에 포함되는 속성인 project, assignees, milestone 이외에 label 기능을 제공하여 이슈를 카테고라이징 할 수 있도록 합니다.  CNCT팀은 용도에 따라서 다양한 레이블을 사용하고 있는데 앞에서 언급한 기본적인 정보 외에는 다음의 우선순위 레이블을 가장 먼저 추가를 합니다.
- priority-p0 : 바로 처리해야할 티켓 - 버그나 CI가 제대로 되지 않는 에러들 Urgent thing like break CI or bug
- priority-p1 : 스프린트 플래닝을 통해서 이번 스프린트에 하기로 한 티켓들 - 주로 새로운 피처들이나 크리티컬하지 않은 버그들.
- priority-p2 : 추가적으로 작업을 하면 좋지만 시간이 허락될 때 해도 좋은 티켓들
- priority-p3 : P2보다 덜 중요한 티켓들 당장 없어도 되지만 좋을 수도 있는 추가적인 기능들. 회의를 통해서 P2나 P1으로 변경을 하기도 한다.

아래와 같이 다양한 레이블을 통해서 티켓들을 관리합니다.

![labels]({{ site.url }}/assets/20170710/labels.png)

### Common Tool's  Work Flow

다음은 커먼툴팀의 기본적인 워크 플로우에 대해서 소개를 하고자 합니다. Samsung CNCT의 내외부 혹은 어떤 개발자든 다음의 단계로 마스터 브랜치로 소스를 올립니다. 눈여겨 볼점은 리뷰없이는 아예 머지를 못하게 하는 정책입니다.

1. 자기 자신의 깃헙 스페이스로 타켓 레포지토리를 포크 fork the target repository into their own github space
2. 새롭게 내려받은 깨끗한 마스터 브랜치(개발자 깃헙 레포지토리)에서 새로운 피처 브랜치를 생성.
3. 타켓 레포지토리에 대해서 자신의 피처브랜치로부터 Pull Request 를 요청.
4. Samsung CNCT 팀 멤버가 리뷰를 할 때까지 대기. 심각한 에러나 버그로 인한 급한 PR이 아닌 경우에는 셀프 머징은 불허. 이 경우에도 포스트 머지 리뷰를 실시함.
5. PR이 리뷰가 오랫동안 되지 않는 다면 직접 @coffeepac 이나 @dwat 리뷰를 어싸인해서 요청을 하도록함

### Common Tool Projects
Common Tool Team 에서 관리하고 있는 형상의 리스트 입니다.
[https://github.com/samsung-cnct/k2](https://github.com/samsung-cnct/k2)
[https://github.com/samsung-cnct/k2cli](https://github.com/samsung-cnct/k2cli)
[https://github.com/samsung-cnct/k2-charts](https://github.com/samsung-cnct/k2-charts)
[https://github.com/samsung-cnct/careen](https://github.com/samsung-cnct/careen])
[https://github.com/samsung-cnct/kraken-ci-jobs](https://github.com/samsung-cnct/kraken-ci-jobs)
[https://github.com/samsung-cnct/k2-tools](https://github.com/samsung-cnct/k2-tools)

###  CNCT github flow
일반적으로 사용하는 깃플로우와 약간 변경된 플로우를 사용합니다. 깃 플로우는 좀 더 파편화가 일어나거나 버전이 세분화되는 어플리케이션에 적합하다면 활발하게 버전업이 이루어지고 있는 이런 오픈소스들은 좀 더 단순화 된 워크 플로우를 사용합니다. Kubernetes 커뮤니티도 매우 흡사한 워크 플로우를 사용을 하고 있습니다.

[Kubernetes deveopment Guide](https://github.com/kubernetes/community/blob/master/contributors/devel/development.md#workflow)

상세하게 알아보도록 하죠.

1. Github에서 자신의 레포지토리로 타켓 레포지토리를 포크.

2. 포크한 자신의 레포지토리를 로컬 머신으로 클론.
```bash
$ git clone https://github.com/blackdog0403/k2cli.git
```

3. 타켓 레포지토리의 마스터 브랜치를 업스트림을 리모트로 설정
```bash
$ git remote add upstream https://github.com/samsung-cnct/k2cli.git
$ git config pull.ff only
```

4. 브랜치를 따기 전에 다시한번 최신 마스터를 로컬 마스터에 머지
```bash
$ git checkout master
$ git pull upstream master
```

5. 새로운 피처 브랜치 생성
```bash
$ git checkout -b new-feature-branch
```
6. 폭풍 코딩!

7. 작업한 파일 커밋하기
```bash
$ git add . or git add <file paths>
$ git commit -m "my awesome commits!"
```

8. origin의 피처 브랜치로 푸쉬하기
```bash
$ git push origin new-feature-branch
```

9. Pull Request(Merge Request)를 요청하기 전에 업스트림의 마스터에 대해서 리베이스
```bash
$  git rebase upstream/master
```

10. 충돌이 일어나면 해결하고 커밋하고 푸쉬하기

11. Pull Request 요청하고 리뷰받고 CI가 완료되고 머지될때까지 기다리기.

12. 4번으로 돌아가서 반복!

크게 다르지 않지요? 여기서 눈여겨 봐야하는 부분은 **Pull Requst와 Review입니다.**

#### Github review

한국에서도 개발을 할 때 리뷰를 하려고 많이 시도를 했지만 여기서 만큼 활발하게 리뷰를 하지는 않았습니다. 일단 위에서도 설명을 했듯이 셀프 머지는 허용되지 않게 때문에 반드시 다른 사람들에 리뷰를 받아야합니다. 따로 리뷰어를 정하는 정책은 없지만 주로 이슈를 추가한 사람이라던지 해당 모듈을 많이 접한 사람 그것도 아니면 그냥 Slack 채널에 링크를 보내고 리뷰를 요청합니다.

기본적으로 Github은 멀티리뷰어를 설정할 수 있게 되어 있으며 리뷰어로 지정이 되지 않더라도 본인이 직접 리뷰어로 자청을 할 수도 있습니다. (당장 어떤 티켓을 해야할지를 모를때는 PR들을 둘러보면서 다른 사람들의 소스 코드를 들여다 보는데 이게 굉장히 도움이 많이 됩니다. 특히 다른 사람이 리뷰를 하는 것을 보면서 어떻게 리뷰를 하는지를 배울 수 도 있고 소스에 대한 이해도를 더 높이기도 합니다. 이건 좀 신선한 경험이었습니다. PR을 훑어봄으로서 누구에게 물어보거나 특정부분을 찾아 볼 필요없이 지금 프로젝트 전체에 일어나는 변화를 추적이 가능합니다.)

리뷰는 코딩 스타일에 대한 리뷰보다는 로직이나 다른 모듈에 영향을 끼칠 수 있는 부분에 대한 이야기가 더 많이 거론됩니다. 기본적으로 K2의 주 코드인 ansible 의 yaml 파일들에 대해서는 pre-commit hook을 걸어서 사용하기도 하지만 스타일에 대한 리뷰는 거의 없고 기능 자체에 주목을 하고 있습니다. 이는 소모적인 리뷰를 막아서 피로감을 줄여주는 역활을 합니다.

무엇보다 흥미로운 점은 여기서는 리뷰도 일의 매우 중요한 부분으로 인정을 하고 충분한 시간을 들여서 진행을 한다는게 제가 기존에 하던 개발과 큰 차이점이라고 할 수 있습니다. 실제로 Github의 액티비티에 리뷰를 했던것에 대한 기록도 다 남아있고 이것들도 중요한 액티비티로 생각을 하게 됩니다. 때때로 피처의 덩어리가 클때는 하나의 PR 리뷰에만 1시간 이상을 쓰는 경우도 있기도 합니다.(이렇게 시간을 많이 소요하기 때문에 이부분에 대해서 논의를 하고 있기도 합니다. 피처가 큰 경우에는 애초에 티켓처럼 취급해서 최대한 시간을 적게 쓸 수 있는 적절한 리뷰어를 배정하자는 의견등이 나오고 있네요.)


제가 요청했던 Pull Request를 하나 예를 들어보겠습니다. 이미지가 작으면 여기로 가서 직접확인하시면 더 좋을 것 같습니다.
[https://github.com/samsung-cnct/k2/pull/557](https://github.com/samsung-cnct/k2/pull/557)


![review1]({{ site.url }}/assets/20170710/review1.png)


클러스터를 올릴 때 파일 2개를 가지고 상태를 체크하는 것은 부적절하다로 리뷰가 시작 됐지만 나중에는 K2 일부 코드에 CoreOS의 버전이 Latest 로 되어 있어서 idempotent(멱등성을 가진) 하지 못하고 또다시 명령어를 실행했을 떄 etcd클러스터를 날려버릴 수 있다고 하는 이야기까지 이야기 진행되서 티켓으로 부터 주제를 분리하기 이르렀습니다^^; 결국 코멘트만 30개가 넘게 달렸네요^^;; 핫한 PR 중 하나긴 했지만 이렇게까지 길게 리뷰가 가는 경우도 있습니다. 기본적으로 리뷰어는 그냥 코멘트만 남기거나 변경을 요청하거나 승인을 할 수 있습니다. 승인이 이루진다고 해도 CI를 통과해야지 머지가 가능합니다. 물론 머지는 다른 사람이 할 수 있습니다. (그냥 스스로 머지를 하면 다른 팀원들이 확인하고 리버트를 시키기도 합니다.)

![review2]({{ site.url }}/assets/20170710/review2.png)

변경을 요청한다음 PR을 요청한 사람이 변경 요청 부분의 소스를 수정하면 Github이 자동으로 해당부분의 소스가 더 이상 유효라지 않다고 표기를 해줘서 순쉽게 변경사항을 확인이 가능합니다. 리뷰어는 변경사항에 대하서 아래와 승인을 할 수 있습니다.

![review3]({{ site.url }}/assets/20170710/review3.png)

##  Conclusion

여기까지 CNCT의 Common-tool팀이 어떻게 일을 하는지 알아봤습니다. 개인적으로는 개발적인 측면에서 가장 인상적이었던 부분이 코드리뷰를 중요시해서 코드의 품질을 유지하려고 노력을 하는 부분이 가장 인상적이었습니다. (물론 CI가 있어서 엔드 투 엔드 테스트도 수행을 합니다. 이런 부분은 코드품질 향상에 기본적인 요건이 아닌가 싶네요) 리뷰에 많은 시간을 쏟더라도 코드하나가 전체에 끼치는 영향을 지속적으로 관찰하고 다른 개발자와 컨센서스를 이루지 못한 코드와 기능들은 형상에 올라가지 못하도록 타이트하게 관리를 하는 부분이 장기적으로 볼 때 더 개발효율을 높이는 과정이라는 공감대가 형성이 되어 있습니다. 앞으로 한국에 돌아가 다시 개발업무를 한다면 이런 부분에 대한 인식을 개선해 나갈 수 있도록 노력을 해보고 싶습니다.

읽어주셔서 감사합니다. 다음 편은 다시 일에서 벗어나서 시애틀 여행기 2편이 될 예정입니다. 그럼 안녕히계세요~^^
