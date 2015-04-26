---
title: Synchronous Javascript with fibers
date: 2015-03-02 00:00 WIB
tags:
---

I was suprised how nice to get rid of endless nested callbacks in javascript.

I was playing with [node-fibers](https://github.com/laverdet/node-fibers), trying to make it easier to write tests.. One day I came up with idea: what if one function can run asynchronously when we call inside fiber and synchronous when passing a callback function. Here's how I can make it:

```js

var Fiber = require('fibers');

// can be called to convert multiple methods
Fiber.makeSync = function (receiver) {
  for (var n = 1; n < arguments.length; n++) {
    Fiber.makeSyncFn(receiver, arguments[n]);
  }
};

Fiber.makeSyncFn = function(receiver, methodName, errorArgNum) {
  var origFn = receiver[methodName];

  if (origFn == undefined) {
    throw "Object don't have property '" + methodName + "'";
  }

  receiver[methodName] = function () {
    var lastArg = arguments[arguments.length - 1];

    // check if it called inside Fiber
    if (Fiber.current && typeof lastArg != 'function') {
      var fiber = Fiber.current;
      var newValue;
      var args = Array.prototype.slice.call(arguments);
      if (typeof errorArgNum == 'undefined') errorArgNum = 1;
      args.push(function(data) {
        // retrieve error from arguments (optional)
        var error = arguments[errorArgNum];
        if (error) {
          throw error;
        }
        // assign result and resume fiber
        newValue = errorArgNum == 0 ? arguments[1] : data;
        fiber.run();
      });

      // call original function with fiber-aware callback
      origFn.apply(this, args);
      // pause and wait till resume
      Fiber.yield();
      return newValue;
    } else {
      origFn.apply(this, arguments);
    }
  };
};

module.exports = Fiber;
```

-READMORE-

Fibers provide just one simple thing: stop execution and waiting for resume. For every function with callback we can call it, put fiber on pause then when we get callback - unpause and continue execution. Code become not blocking but asynchronous.

Here's how you can use it:

```js

Fiber.makeSyncFn(redisClient, 'get', 0); // 0 is number if error argument passed in callback
Fiber.makeSyncFn(redisClient, 'set', 0);

Fiber(function () {
  var value = redisClient.get('some_key');
  redisClient.get('some_key', value + 1);
}).run();

```

When we call `Fiber.makeSyncFn` it will override original function. If `Fiber.current` present and if last argument is not a function then it will run it in fiber-aware wrapper, otherwise it will run in usual way.

You can also patch prototype in same way:

```js
Fiber.makeSyncFn(redis.RedisClient.prototype, 'set', 0);
Fiber.makeSyncFn(redis.RedisClient.prototype, 'get', 0);
```

I made some benchmarks: simple http server, it reads key from redis, increase by 1 and write to redis, I'm creating new fiber for every request. Then I compare it with same http server written in asynchronous way.

running 5000 times and see:

| name     | time per request |
|----------|------------------|
| w/fibers | 0.751ms          |
| async    | 0.706ms          |

I ran it many times, difference is about 0.1ms - 0.02ms

Other benchmark is a counter, made to eliminate open-close fiber timing: compare with classic-callback code, overhead is about 0.01ms - 0.007ms, that time spent to pause and unpause a fiber.

For me I feel pretty glad to make code more readable and maintainable, even I need to trade some microseconds (or milliseconds).

\* As a bonus it gives us a way to track exceptions with try-catch


When you should NOT use fibers:

* When you want to run some asynchronous things in parallel, for example query db and make http request
* When you want your code run in browser as well
* When your callback function receive more then one argument and you need them

Continue reading: an article about [Generators vs Fibers](http://howtonode.org/generators-vs-fibers)


