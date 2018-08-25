---
layout: "posts"
title: "Spring – Inject value into static variables
"
date: "2018-01-12 10:31"
categories:  java
classes: wide
---

Spring doesn’t allow to inject value into static variables, for example:

## Wrong

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class GlobalValue {

  @Value("${mongodb.db}")
  public static String DATABASE;

}

```

## Right!

```java
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class GlobalValue {

    public static String DATABASE;

    @Value("${mongodb.db}")
    public void setDatabase(String db) {
        DATABASE = db;
    }

}
```
