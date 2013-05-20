# Crunch::Api

[![Gem Version](https://badge.fury.io/rb/crunch-api.png)][gem]
[![Build Status](https://travis-ci.org/achambers/crunch-api.png)][travis]

[gem]: http://badge.fury.io/rb/crunch-api
[travis]: https://travis-ci.org/achambers/crunch-api

A Ruby interface to the Crunch Accounting API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crunch-api'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install crunch-api
```

## Quick Start Guide

Hurry up and show me how to call the service already...

First you need to register your application with Crunch Accounting using OAuth

Next require the gem:

```ruby
require 'crunch-api'
```

Then, copy and paste your OAuth credentials into the configuration:

```ruby
CrunchApi.configure do |config|
  config.consumer_key = YOUR_CONSUMER_KEY
  config.consumer_secret = YOUR_CONSUMER_SECRET
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end
```

And there you, you're all set to access some Crunchy goodness

```ruby
CrunchApi::Supplier.for_id(123)
```

For more examples of how to use this gem, see the [Usage Examples][] below

[Usage Examples]: #usage-examples

## Usage Examples

All examples require OAuth configuration to be set in order to authenticate

**Get all suppliers**

```ruby
CrunchApi::Supplier.all
```

**Get a specific supplier**

```ruby
CrunchApi::Supplier.for_id(123)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
