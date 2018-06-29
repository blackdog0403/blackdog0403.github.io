---
layout: "post"
title: "Apache2-utils usage for performance test"
date: "2018-04-29 10:31"
categories:  linux
---
# Introducing apache bench


## install

sudo apt-get install apache2-utils

## instruction
```
Usage: ab [options] [http[s]://]hostname[:port]/path
Options are:
    -n requests     Number of requests to perform
    -c concurrency  Number of multiple requests to make at a time
    -t timelimit    Seconds to max. to spend on benchmarking
                    This implies -n 50000
    -s timeout      Seconds to max. wait for each response
                    Default is 30 seconds
    -b windowsize   Size of TCP send/receive buffer, in bytes
    -B address      Address to bind to when making outgoing connections
    -p postfile     File containing data to POST. Remember also to set -T
    -u putfile      File containing data to PUT. Remember also to set -T
    -T content-type Content-type header to use for POST/PUT data, eg.
                    'application/x-www-form-urlencoded'
                    Default is 'text/plain'
    -v verbosity    How much troubleshooting info to print
    -w              Print out results in HTML tables
    -i              Use HEAD instead of GET
    -x attributes   String to insert as table attributes
    -y attributes   String to insert as tr attributes
    -z attributes   String to insert as td or th attributes
    -C attribute    Add cookie, eg. 'Apache=1234'. (repeatable)
    -H attribute    Add Arbitrary header line, eg. 'Accept-Encoding: gzip'
                    Inserted after all normal header lines. (repeatable)
    -A attribute    Add Basic WWW Authentication, the attributes
                    are a colon separated username and password.
    -P attribute    Add Basic Proxy Authentication, the attributes
                    are a colon separated username and password.
    -X proxy:port   Proxyserver and port number to use
    -V              Print version number and exit
    -k              Use HTTP KeepAlive feature
    -d              Do not show percentiles served table.
    -S              Do not show confidence estimators and warnings.
    -q              Do not show progress when doing more than 150 requests
    -l              Accept variable document length (use this for dynamic pages)
    -g filename     Output collected data to gnuplot format file.
    -e filename     Output CSV file with percentages served
    -r              Don't exit on socket receive errors.
    -m method       Method name
    -h              Display usage information (this message)
    -Z ciphersuite  Specify SSL/TLS cipher suite (See openssl ciphers)
    -f protocol     Specify SSL/TLS protocol
                    (TLS1, TLS1.1, TLS1.2 or ALL)

```



## example
```bash
ab -n 400 -c 1 http://13.125.237.30/  
```

## result
```
This is ApacheBench, Version 2.3 <$Revision: 1706008 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 13.125.237.30 (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requestsCompleted 400 requests
Finished 400 requests


Server Software:        Apache
Server Hostname:        13.125.237.30
Server Port:            80

Document Path:          /
Document Length:        55107 bytes

Concurrency Level:      1
Time taken for tests:   8.129 seconds
Complete requests:      400
Failed requests:        0
Total transferred:      22190800 bytes
HTML transferred:       22042800 bytes
Requests per second:    49.20 [#/sec] (mean)
Time per request:       20.323 [ms] (mean)
Time per request:       20.323 [ms] (mean, across all concurrent requests)
Transfer rate:          2665.76 [Kbytes/sec] received

Connection Times (ms)
Time per request:       20.323 [ms] (mean, across all concurrent requests)
Transfer rate:          2665.76 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max                               devConnect:        0    0   0.1      0       2
Processing:    19   20   1.0     20      37
Waiting:       18   19   1.0     18      36
Total:         19   20   1.0     20      38
WARNING: The median and mean for the waiting time are not within a normal deviation
        These results are probably not that reliable.

Percentage of the requests served within a certain time (ms)
  50%     20
  66%     20
  75%     21
  80%     21
  90%     21
  95%     21
  98%     21
  99%     23
 100%     38 (longest request)
 ```
 

