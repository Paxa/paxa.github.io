---
title: Convert ruby time to server timezone
date: 2014-09-29 00:00 WIB
tags: ruby, cron, timezone
---

In web application have to handle about 4 different timezones: 

* application timezone
* user timezone
* server time timezone
* database timezone

---

#### Application timezone

Usually same with timezone of your business location, also usually a default timezone.

```ruby
Rails.configuration.time_zone # => "Jakarta"
# or
MyApp::Application.config.time_zone
```

#### User timezone

Timezone of current user, can be saved in user profile, or defected from javascript, eg http://pellepim.bitbucket.org/jstz/

Usually set as: `Time.zone`

#### Server timezone

It's a system time of current server, mostly UTC but sometimes can be a time of datacenter location. In development it's developer's machine timezone. You may need it if you want to make a cron task. Cron works in server's timezone.

To calculate it I have handy function what I use with [gem whenever](https://github.com/javan/whenever):

```ruby
# Your business timezone 
Time.zone = "Asia/Jakarta"

def to_server_time(time_str)
  time = Time.zone.parse(time_str)
  server_offset = Time.now.getlocal.utc_offset.to_f / 1.hour
  time.in_time_zone(server_offset)
end

to_server_time('00:30') # => Sun, 28 Sep 2014 17:30:00 WET +00:00
to_server_time('00:30').strftime("%H:%M") # => "17:30"

```


#### Database timezone

Mysql don't store timezone in `datetime` format, but Postgresql does. Anyway it better if all dates in database have same timezone. Usually it's UTC, or can be custom:

```ruby
Rails.configuration.active_record.default_timezone
# or
config.active_record.default_timezone
```