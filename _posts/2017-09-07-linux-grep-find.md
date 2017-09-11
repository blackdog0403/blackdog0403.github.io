---
layout: post
title:  "Mac os sierra dns reset"
date:   2017-09-03 08:47:00 -0700
categories:  linux
---

# file, diff, grep, find

## file
Get info from file
```bash
$ file  <filename>
$ file ~/.bash_profile
```
## diff
Compare two files.
```bash
$ diff <file1> <file2>
```

## GREP
usage: grep [-abcDEFGHhIiJLlmnOoqRSsUVvwxZ] [-A num] [-B num] [-C[num]]
	[-e pattern] [-f file] [--binary-files=value] [--color=when]
	[--context[=num]] [--directories=action] [--label] [--line-buffered]
	[--null] [pattern] [file ...]

### IE
```bash
$ grep root /etc/passwd
$ grep root /etc/*
$ grep ie /usr/share/dict/words | less
```
> less : `space` key for next page, `b` for previous page, `q` for exit

## find
usage: find [-H | -L | -P] [-EXdsx] [-f path] path ... [expression]
       find [-H | -L | -P] [-EXdsx] -f path [path ...] [expression]

### IE
searching file
```bash
$ find <dir> -name <file> -print
$ find /Users/blackdog -name .bash_profile -print
```
