---
layout: post
title:  "Day-13-Microservice?"
date:   2017-04-29 19:35:00 -0700
categories: GEP
---
## GCE

마이크로 서비스 아키텍처

도커 개념 복습

도커 이미지 만들고 앱 실행하기

도커 허브에 이미지 푸쉬하기


Adrian Cockcroft former cloud architect who made micro services mainstream

from Net Flix

make monolithic system into chunks


reason that using microservice is speeding up development
breaking it into micro services is really about freeing up everybody to run at their own speed


each system don't coordinate each other.
If you coordinate them yor're going back to the monolith!

the point really is to let everybody release on their own cycle.
which means you need to make sure hat the interfaces are relatively stable and
you can deploy any piece of it independently of any other piece.
Typically without sort of asking permission but you Typically let people know.

need automation for testing or documentation.


They just let other systems know. -> need more time for interface and documention

-> It help to dev team to release faster.  




Adrian Cockcroft former cloud architect who made micro services mainstream


conway's law

the structure of an organization guides the kind of structure of the code they produce

so what I'm really saying is that you can't build micro services with a waterfall organization.
