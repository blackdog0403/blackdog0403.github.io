---
layout: posts
title:  "Jenkinsfile script bugs?"
date:   2017-08-24 08:47:00 -0700
categories:  linux
classes: wide
---

# Jenkinsfile script bugs?

## Jenkinsfile
```groovy
stage('build & packaging') {
  steps {
    container('dockerce') {
      dir('docker') {
          withDockerRegistry([credentialsId: 'rediikky', url: 'https://sds.redii.net']) {
              script {
                  def app = docker.build("sds.redii.net/paascicd/docker:$params.TAG")
                  app.push()
              }
          }
      }
    }
  }
}
```

## Error log
```
[maven] Running shell script
+ docker build -t sds.redii.net/paascicd/maven:3.5.0 --pull .
Sending build context to Docker daemon  8.544MB

Step 1 : FROM sds.redii.net/paascicd/jdk:8u121
Trying to pull repository sds.redii.net/paascicd/jdk ...
Pulling repository sds.redii.net/paascicd/jdk
Error while pulling image: Get https://sds.redii.net/v1/repositories/paascicd/jdk/images: EOF
```

## Changed script

```groovy
pipeline {
    agent { label 'dockerce' }
    stages {
        stage('checkout source') {
            steps {
              git branch: 'development', credentialsId: 'a6aede99-7018-4e8f-8a9e-d30d6d5b57d3', url: 'http://70.121.224.108/gitlab/cicd/jenkins-scalable.git'
            }
        }
        stage('build & packaging') {
            steps {
              container('dockerce') {
                dir('maven') {
                      sh 'docker login sds.redii.net -u kwangyoung49.kim -p ab3t12ba!'
                      sh "docker build -t sds.redii.net/paascicd/maven:$params.TAG --pull ."
                      sh "docker push sds.redii.net/paascicd/maven:$params.TAG"
                }
              }
            }
        }
    }
}
```

## Other error  

https://issues.jenkins-ci.org/browse/JENKINS-32792


```bash
[Pipeline] End of Pipeline
java.lang.IllegalArgumentException: Expecting 64-char full image ID, but got
	at org.jenkinsci.plugins.docker.commons.fingerprint.DockerFingerprints.getFingerprintHash(DockerFingerprints.java:71)
	at org.jenkinsci.plugins.docker.commons.fingerprint.DockerFingerprints.forDockerInstance(DockerFingerprints.java:148)
	at org.jenkinsci.plugins.docker.commons.fingerprint.DockerFingerprints.forImage(DockerFingerprints.java:115)
	at org.jenkinsci.plugins.docker.commons.fingerprint.DockerFingerprints.forImage(DockerFingerprints.java:100)
	at org.jenkinsci.plugins.docker.commons.fingerprint.DockerFingerprints.addFromFacet(DockerFingerprints.java:260)
	at org.jenkinsci.plugins.docker.workflow.FromFingerprintStep$Execution.run(FromFingerprintStep.java:119)
	at org.jenkinsci.plugins.docker.workflow.FromFingerprintStep$Execution.run(FromFingerprintStep.java:75)
	at org.jenkinsci.plugins.workflow.steps.AbstractSynchronousNonBlockingStepExecution$1$1.call(AbstractSynchronousNonBlockingStepExecution.java:47)
	at hudson.security.ACL.impersonate(ACL.java:260)
	at org.jenkinsci.plugins.workflow.steps.AbstractSynchronousNonBlockingStepExecution$1.run(AbstractSynchronousNonBlockingStepExecution.java:44)
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
	at java.lang.Thread.run(Thread.java:745)
Finished: FAILURE

```
