---
title: Continuous testing for D
date: 2014-07-16 00:00 WIB
tags: D, drone
---


I'm not sure if Travis CI can install packages, but with [drone.io](http://drone.io) it's possible

Here is how I make it:

* Add project
* Choose C/C++ as language
* Add build command which will install D compiler and run tests.

Command:

```shell
# prepare apt repository
sudo wget http://netcologne.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
sudo apt-get update && sudo apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring && sudo apt-get update
# install dmd and dub
sudo apt-get install dmd-bin dub
# build and run tests
dub test
```