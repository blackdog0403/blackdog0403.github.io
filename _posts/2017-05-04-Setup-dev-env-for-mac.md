---
layout: post
title:  "맥용 개발 환경 셋업하기 - iTerm2 + zsh + oh-my-zsh"
date:   2017-05-04 10:51:00 -0700
categories: Tech
---

## 맥용 개발 환경 셋업하기 - iTerm2 + zsh + oh-my-zsh

### brew 설치하기

curl  명령어로 brew 를 설치한다
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

brew 명령어 설치 확인
```
$ brew --help
```

brew 업데이트 확인하고 없으면 설치
```
$ brew update
$ brew install zsh
```

### zsh 설치하기

zsh 버전 확인 (최근의 맥에는 기본 설치가 되어있다.)
```
$ zsh --version
```

현재 쉘 프로그램 및 zsh 위치 확인
```
$ echo $SHELL
/bin/bash

$ which zsh
/usr/local/bin/zsh
```

zsh로 쉘을 설치 변경했더니 다음과 같은 결과가 나온다면
```
$ chsh -s /usr/local/bin/zsh

Changing shell for blackdog.
Password for blackdog:
chsh: /usr/local/bin/zsh: non-standard shell
```

아래의 방법으로 변경한다.
```
$ ls /bim/zsh
/bin/zsh

chsh -s /bin/zsh

brew uninstall zsh
```

터미널 세션을 종료하고 새로 실행시켜서 다음과 같다면 변경완료
```
$ echo $SHELL
/bin/zsh
```

아래의 경로에 bash쉘이 기본이다. bash 쉘로 되 돌리고 싶다면
```
chsh -s /bin/bash
```

### oh-my-zsh 설치

oh-my-zsh 를 설치한다( zsh 용 확장 플러그인)
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

.zshrc 파일을 vi  에디터로 편집한다
```
ZSH_THEME="robbyrussell"
```

```
ZSH_THEME="agnoster" # (this is one of the fancy ones)
# you might need to install a special Powerline font on your console's host for this to work
# see https://github.com/robbyrussell/oh-my-zsh/wiki/Themes#agnoster
```

### zsh 폰트 확인하기
아래의 코드를 붙여넣고 실행했을 때 똑깥이 출력된다며 정상세팅된 것이다.
```
$ echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
 ±  ➦ ✘ ⚡ ⚙
```

폰트가 깨진다면 패치가 됐거나 다른 테마를 덮어서 해결한다.


### iTerm2 폰트 확인하기


세션을 종료하고 다시 쉘을 실행했는데 경로를 나타내는 폰트가 '?' 와 같은 식으로 꺠진다면 아래의 폰트를 설치하고
```
#clone
git clone https://github.com/powerline/fonts.git

#install
cd fonts
./install.sh

#clean-up a bit
cd ..
rm -rf fonts
```

Iterm2 에서  "iTerm > Preferences > Profiles > Text" 로 powerline 이 표기 되어있는 폰트로 변경하여 제대로 표현되는지 확인한다.

zsh을 사용하는데 PATH에 뭔가를 추가하고 싶다면
```
export aaa=file path
export PATH=${PATH}:${aaa}
```

필자는 기본 터미널은 /bin/bash 다시 적용하고 테마만 적용해 놓았다. 복작한 설정을 필요로하거나 디폴트 셋업이 bash로 되어 있는 툴을 설치하고 사용할 때는 기본쉘을 쓰고 싶을 때는 터미널, 다른 기능을 쓰고 싶을 때만 iTerm2사용하는 셋업으로 구성했다.
