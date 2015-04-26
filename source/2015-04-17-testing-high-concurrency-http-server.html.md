---
title: Testing high concurrency http server
date: 2015-04-17 00:00 WIB
tags: http, ab, nginx, nodejs, boom, benchmark, tools
---

I was making some research for one of upcoming project at my job. I needed to test http server if it can handle 500-1500 concurrent requests.

It's was more hard to make right testing rather then right server. Web server don't have any record in error log and could process requests that I sent with curl while load test is running.

### Setup

First I setup Nginx with [HttpEchoModule](http://wiki.nginx.org/HttpEchoModule), I used [openresty](http://openresty.org/) to easily configure and compile with extra modules.

Next I create config to wait 3 seconds and response with some text.

I choose nginx as example to compare with real application.

```nginx
location / {
    add_header Content-Disposition "inline";
    add_header Content-Type "text/plain";

    echo_sleep 3;
    echo "response text";
}
```
### Testing

Then I start to test how many requests it can process at same time:

```shell
ab -n 100 -c 100 http://127.0.0.1:7080/
# => ok
ab -n 200 -c 200 http://127.0.0.1:7080/
# => ok
ab -n 500 -c 500 http://127.0.0.1:7080/
# => socket: Too many open files (24)
```
Probably we hit system limitation on max open files per process.

-READMORE-

After hours I fine this manual most useful

[http://b.oldhu.com/2012/07/19/increase-tcp-max-connections-on-mac-os-x/](http://b.oldhu.com/2012/07/19/increase-tcp-max-connections-on-mac-os-x/)


I also increase `worker_processes` and `worker_connections`in nginx:

```nginx
worker_processes  2;
events {
  worker_connections  4096;
}
worker_rlimit_nofile    8000;
```

After increase limitations try again 

```shell
ab -n 700 -c 700 http://127.0.0.1:7080/
# => ok
ab -n 900 -c 900 http://127.0.0.1:7080/
# => sometimes ok
# => sometimes "apr_socket_recv: Connection reset by peer (54)"
```

Keep increasing:

```shell
ab -n 1100 -c 1100 http://127.0.0.1:7080/
# => ok or apr_socket_recv error
ab -n 3000 -c 3000 http://127.0.0.1:7080/
# => ok or apr_socket_recv error
ab -n 9000 -c 1000 http://127.0.0.1:7080/
# => apr_socket_recv: Connection reset by peer (54)
# => Total of 455 requests completed

```

So I could make 3000 parallel requests and get a response in 3.183 sec. But sometimes it fails with error in `ab` tool. And it can't process when reqs > conns. I wasn't happy with it, so I try:

* **wrk** - it didn't work before, but after I reboot it seems to work ok
* **httperf** - I could not manage to send as many request as I want
* **siege** - was better but still could not make many requests

What make me happy is a utility called [**boom**](https://github.com/rakyll/boom)

Written in GO and source on github:

[https://github.com/rakyll/boom](https://github.com/rakyll/boom)

There is no binary for mac, so need to compile:

```shell
brew install go
export GOPATH=~/go
go get github.com/rakyll/boom
```

Using boom:

```
~/go/bin/boom -n 8000 -c 1500 -disable-keepalive http://127.0.0.1:7080
```

It has:

* nice progress bar
* can handle many requests (eg 30k reqs with 1500 conns) 
* can handle as much concurrency as I need
* keep going on error
* has nice diagram

Progress bar:

```
~/go/bin/boom -n 9000 -c 1500 -disable-keepalive http://127.0.0.1:7080
4500 / 9000 Boooooooooooooooooooooom                                 ! 50.00 % 9s
```

Output looks like this:

```
% ~/go/bin/boom -n 9000 -c 1500 -disable-keepalive http://127.0.0.1:7080
9000 / 9000 Booooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00 % 

Summary:
  Total:	18.6023 secs.
  Slowest:	3.2399 secs.
  Fastest:	2.9995 secs.
  Average:	3.0652 secs.
  Requests/sec:	483.8105

Status code distribution:
  [200]	9000 responses

Response time histogram:
  2.999 [1]	|
  3.024 [2383]	|∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3.048 [1883]	|∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3.072 [2011]	|∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3.096 [1219]	|∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3.120 [7]	|
  3.144 [188]	|∎∎∎
  3.168 [147]	|∎∎
  3.192 [361]	|∎∎∎∎∎∎
  3.216 [656]	|∎∎∎∎∎∎∎∎∎∎∎
  3.240 [144]	|∎∎

Latency distribution:
  10% in 3.0045 secs.
  25% in 3.0219 secs.
  50% in 3.0493 secs.
  75% in 3.0832 secs.
  90% in 3.1882 secs.
  95% in 3.2031 secs.
  99% in 3.2162 secs.
```
### Node.js app:

Next I write same functionality in Node.js:

```js
const PORT = 7090;
var reqN = 0;

var server = node.http.createServer(function (request, response) {
  console.log("Req", reqN++);
  setTimeout(function () {
    response.setHeader('content-type', 'text/plain');
    response.end("response");
  }, 3000);
});

server.listen(7090, function(){
    console.log("Server listening on: http://localhost:%s", PORT);
});
```

It does same: wait 3 seconds and response with `"response"` body.

I run it with latest iojs (1.7.1). Benchmark result is almost same:

```
~/go/bin/boom -n 15000 -c 1500 -disable-keepalive http://127.0.0.1:7090
# ...
Response time histogram:
  3.000 [1]	|
  3.039 [6930]	|∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎∎
  3.078 [1682]	|∎∎∎∎∎∎∎∎∎
  3.118 [1204]	|∎∎∎∎∎∎
  3.157 [644]	|∎∎∎
  3.196 [1016]	|∎∎∎∎∎
  3.235 [875]	|∎∎∎∎∎
  3.275 [1291]	|∎∎∎∎∎∎∎
  3.314 [890]	|∎∎∎∎∎
  3.353 [262]	|∎
  3.393 [205]	|∎
```

### Bottom line:

For future research and development I prefer to use  _boom_, it's hassle-free, can handle really high number of parallel requests, have nice output.

In this review I skip tool called jMetter, because it have GUI and looks ugly on mac, also because written in Java
