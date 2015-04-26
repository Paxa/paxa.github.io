---
title: Node.js standart libs auto-require
date: 2014-08-26 00:00 WIB
tags: javascript, node
---

I like node.js because it's very fast. But I also like to make a global objects in my application. I think nothing wrong with it. For example I have `global.App` object to keep object-wide things.

It was really annoying for me to write `require('fs')` or `require('util')` in every file, I also think it's not as fast as access global object.

So I come up with this solution:

~~~js
var node = {};

var modules = ['child_process', 'fs', 'http', 'https', 'cluster',
  'crypto', 'dns', 'domain', 'net', 'url', 'util', 'vm', 'path'
];

var loadedModules = {};

modules.forEach(function(moduleName) {
  Object.defineProperty(node, moduleName, {
    get: function() {
      if (!loadedModules[moduleName]) {
        loadedModules[moduleName] = require(moduleName);
      }
      return loadedModules[moduleName];
    }
  });
});

module.exports = node;
global.node = node;
~~~

It make lazy-loading for all standart libraries as getters of global object `node`
Later in my code:

~~~js
node.fs.readFile();
node.util._extend({}, params);
node.url.parse(node.url.resolve(endpoint, filepath));
node.url.format(urlObj);
~~~