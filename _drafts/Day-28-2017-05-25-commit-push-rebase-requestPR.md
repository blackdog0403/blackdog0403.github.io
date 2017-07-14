---
layout: post
title:  "Samsung-cnct 팀의 일하는 방식"
date:   2017-07-12 19:35:00 -0700
categories:  Agile development
---
##  CNCT common-tools team's how we work

###

### Ticket priorty

P0 Urgent thing like break CI or bug
P1 Something that we should do for this print.
P2 Something is good to do but when we have a time.
P3 Less valuable than P2 ticket. If it is, it might be good.

### Agile activities
- Daily Standup for common-tools team - 15minutes
- Daily Standup for general - 10minutes
- Sprint Planning (every other week)
- Backlog Grooming (every other week)
- P2 Grooming (When we need, usually monthly)
- P3 Grooming (When we need)

**No Sprint Retrostpective (cause we think we don't need to do right now)**


### Look at project dashboard and choose a ticket to work.



###  CNCT github flow

1. Fork repository that you want to work on github

2. Clone repository from your own repository that you want to work
```bash
$ git clone https://github.com/blackdog0403/k2cli.git
```

3. set upstream (samsung-cnct/master) as remote from master
```bash
$ git remote add upstream https://github.com/samsung-cnct/k2cli.git
$ git config pull.ff only
```

4. merge upstream master into local master
```bash
$ git checkout master
$ git pull upstream master
```

5. checkout new branch
```bash
$ git checkout -b new-feature-branch
```
6. work, work, work!

7. Add files and Commit!
```bash
$ git add . or git add <file paths>
$ git commit -m "my awesome commits!"
```

8. push to origin
```bash
$ git push origin new-feature-branch
```

9. Rebase before request Pull Request to upstream
```bash
$  git rebase upstream/master
```

10. If there are some conflicts, solve them and commit and push

11. Submit Pull Request and get reviewed then get it merged!

12. return to the NO.4


### Github review

### Jenkins CI
