---
title: Testing Rails app with drone
date: 2014-07-06 00:00 WIB
tags: ruby, rails, continuous integration, drone, ubuntu, docker
---

Short tutorial about setting up drone to test rails 4 app running on ruby 2.1.

For us who working in payment industry, it's important to keep all source code inside company, because of [PCI-DSS](http://en.wikipedia.org/wiki/Payment_Card_Industry_Data_Security_Standard) requirements (I almost sure about that).

For a long time we use jenkins for auto-running tests, but once I saw codeship.io, I want something same pretty at it. I am trying self-hosted version of [drone.io](https://github.com/drone/drone), it's build in Go and uses Docker inside.

Currently I run it in virtual machine, with ubuntu.

I used this documentation http://drone.readthedocs.org/en/latest/install.html

```
$ wget http://downloads.drone.io/latest/drone.deb
$ dpkg -i drone.deb
$ drone start
# docker is running on http://localhost:80
$ apt-get install docker.io
```

Then it took for me a while to understand how make it build my code, so I cloned it to server and run inside app folder:

```
drone build .
```
 
To test .drone.yml without commit


Drone reads `.drone.yml` as a scenario to run tests, here's what we use:

```
image: bradrydzewski/ruby:2.1.1
script:
  - cp config/database.drone.yml config/database.yml
  - mkdir -p /tmp/bundler
  - sudo chown ubuntu:ubuntu /tmp/bundler
  - bundle install --path=/tmp/bundler --deployment --quiet
  - mysql -u root -h127.0.0.1 -P 3306 -e 'create database rails_app_test;'
  - mysql -u root -h127.0.0.1 -P 3306 -D rails_app_test < ./db/structure.sql
  - bundle exec rspec spec
services:
  - mysql
cache:
  - /tmp/bundler
notify:
  email:
    recipients:
      - our.team.emails@example.com
```

In our project use plain-sql `structure.sql` because some things not working well with `schema.rb`, and it easy to setup testing environment.

Drone use own images for docker to build, most of them are at docker repository, but new versions may be not there.

I cloned [https://github.com/drone/images](https://github.com/drone/images) to server, and run:

```
docker build -rm -t bradrydzewski/ruby:2.1.1  builder/ruby/ruby_2.1.1/
```

This will build image and add it to docker's local catalogue.

This looks pretty easy for me, but I spend couple evenings to figure out. Drone don't have much information in log file before it receive any webhooks. Log file is located here `/var/log/upstart/drone.log`

P.S. If you want to use drone with github for bitbucket, then your drone app should have public url, I used [localtunnel](https://www.npmjs.org/package/localtunnel) for that.

Happy testing.