---
layout: report
title: "Transit Gateway security group referencing works with security groups for Pods"
title_ko: "Transit Gateway 보안 그룹 참조는 Pod 보안 그룹에서도 동작합니다"
categories: networking
tags: [Transit Gateway, Security group referencing, Amazon EKS, Security groups for Pods, Amazon VPC CNI]
report_src: /assets/reports/tgw-sg-referencing-pods.html
read_time: false
excerpt: "In strict mode, a rule whose only source was the Pod security group allowed the connection across the TGW. In standard mode with AWS_VPC_K8S_CNI_EXTERNALSNAT=false, the traffic left with the node IP and was judged by the node security group instead."
excerpt_ko: "서울 리전에서 직접 테스트해 보니 strict 모드에서는 Pod 보안 그룹 하나만 출발지로 적은 규칙으로 TGW 너머의 접속이 허용됐습니다. standard 모드에 AWS_VPC_K8S_CNI_EXTERNALSNAT=false를 쓰면 트래픽이 노드 IP로 바뀌어 노드 보안 그룹으로 판정됐습니다."
---
