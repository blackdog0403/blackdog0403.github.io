---
layout: "posts"
title: "Retrofit2 Samples"
date: "2017-12-22 10:21"
categories:  java
classes: wide
---

# Retrofit2

A type-safe HTTP client for Android and Java

## Reference
[http://square.github.io/retrofit/](http://square.github.io/retrofit/)
[Retrofit2 한글 문서](http://devflow.github.io/retrofit-kr/)

## Basic Sample
### interface
```java
public interface GitHubService {
  @GET("users/{user}/repos")
  Call<List<Repo>> listRepos(@Path("user") String user);
}
```

### builder
```java
Retrofit retrofit = new Retrofit.Builder()
    .baseUrl("https://api.github.com/")
    .addConverterFactory(GsonConverterFactory.create())
    .build();

GitHubService service = retrofit.create(GitHubService.class);
```

### call service
```java
Call<List<Repo>> repos = service.listRepos("octocat");
```

### URL Manipulation

```java
@GET("group/{id}/users")
Call<List<User>> groupList(@Path("id") int groupId);
```

Query parameters can also be added.

```java
@GET("group/{id}/users")
Call<List<User>> groupList(@Path("id") int groupId, @Query("sort") String sort);
```

For complex query parameter combinations a Map can be used.

```java
@GET("group/{id}/users")
Call<List<User>> groupList(@Path("id") int groupId, @QueryMap Map<String, String> options);
```

### Request body

An object can be specified for use as an HTTP request body with the @Body annotation.


```java
@POST("users/new")
Call<User> createUser(@Body User user);
```
### Form Encoded and multipart

Methods can also be declared to send form-encoded and multipart data.

Form-encoded data is sent when @FormUrlEncoded is present on the method. Each key-value pair is annotated with @Field containing the name and the object providing the value.

```java
@FormUrlEncoded
@POST("user/edit")
Call<User> updateUser(@Field("first_name") String first, @Field("last_name") String last);
```

Multipart requests are used when @Multipart is present on the method. Parts are declared using the @Part annotation.
```java
@Multipart
@PUT("user/photo")
Call<User> updateUser(@Part("photo") RequestBody photo, @Part("description") RequestBody description);
```
