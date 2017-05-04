
Install docker for mac from this link: [click](https://docs.docker.com/docker-for-mac/install/#where-to-go-next)

Download k2cli from this link:  [https://github.com/samsung-cnct/k2cli/releases. ](https://github.com/samsung-cnct/k2cli/releases)

And then run this command through terminal
```
chmod +x ./k2cli
sudo mv ./k2cli /usr/local/bin/k2cli
```

make directory .ssh in user's root directory  and Add SSH rss Key
```
$ cd ~
$ mkdir .ssh
$ cd .ssh
$ ssh-keygen
```

then you can see the messages below.
```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/blackdog/.ssh/id_rsa.
Your public key has been saved in /Users/blackdog/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:sY/dVShdfJwHPU1XQvBkDx2xG5z/bZ0W7CXJuiK+h50 blackdog@Kwangyoungui-MacBook-Pro.local
The key's randomart image is:
+---[RSA 2048]----+
|            .oBX@|
|             =.O%|
|        .   . +=*|
|         o   o.o+|
|        S     =+o|
|         + . o..B|
|        .oo.o  +=|
|        o E  ... |
|       .o+ ..    |
+----[SHA256]-----+
```

install awscli through brew
```
brew install awscli
```

set credential
```
aws configure
```
