---
title: Validating hash params in ruby
date: 2015-01-27 00:00 WIB
tags: ruby
---

If compare many arguments vs "options" hash, I usually choose options hash. And I often face problems when I pass wrong key name or what not supported.

`ActiveSupport` already have [Hash#assert_valid_keys](http://apidock.com/rails/Hash/assert_valid_keys), I added one more method `assert_required_keys`:

```ruby
class Hash
  def assert_required_keys(*keys)
    keys.flatten.each do |key|
      raise ArgumentError.new("Required key: #{key.inspect}") unless has_key?(key)
    end
  end
end
```

Here is my solution to validate hash keys:

```ruby
module ValidateOptions
  def validate_options!(params, options)
    options[:optional] ||= []
    options[:required] ||= []

    params = params.deep_symbolize_keys
    params.assert_required_keys(options[:required])
    params.assert_valid_keys(options[:required] + options[:optional])
  end
end
```
Usage example:

```ruby
include ValidateOptions

def method_with_options(options = {})
  validate_options!(options,
    required: [:order_id, :subject, :from, :to, :text_body, :html_body],
    optional: [:cc, :bcc, :template_name]
  )
end
```
