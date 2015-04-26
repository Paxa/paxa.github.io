---
title: Convert mysql database to postgresql
date: 2015-01-29 00:00 WIB
tags: postgres, postgresql, mysql
---

Today I find tool **pgloader** [http://pgloader.io/](http://pgloader.io/) to convert database from Mysql to Postgres.

Precompiled package can be installed from [downloads page](http://pgloader.io/download.html) or you can compile by yourself from lisp source on [github](https://github.com/dimitri/pgloader).

Then run it as:

```shell
psql -c "CREATE DATABASE db_name"
pgloader mysql://user:pass@localhost/db_name postgres:///db_name
```

It shows warning that can't find `libsybdb.dylib`, press 0 to continue and it working well.

At the end you will see statistics table:

```
                    table name       read   imported     errors            time
------------------------------  ---------  ---------  ---------  --------------
               fetch meta data         18         18          0         18.096s
                  create, drop          0         14          0          0.285s
------------------------------  ---------  ---------  ---------  --------------
                   attachments          0          0          0          0.154s
                        emails       1782       1782          0          2.425s
                     email_bcc         20         20          0          0.044s
                      email_cc          0          0          0          0.045s
                      email_to       1847       1847          0          0.242s
            http_notifications       1097       1097          0          0.317s
                     templates          6          6          0          0.171s
        Index Build Completion          0          0          0          0.000s
------------------------------  ---------  ---------  ---------  --------------
                Create Indexes         11         11          0          0.237s
               Reset Sequences          0          0          0          0.361s
                  Primary Keys          7          7          0          0.049s
                  Foreign Keys          4          4          0          0.071s
                      Comments          0          0          0          0.000s
------------------------------  ---------  ---------  ---------  --------------
             Total import time       4752       4752          0         22.260s
```
Done!