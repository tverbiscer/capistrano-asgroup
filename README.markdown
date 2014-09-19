## Introduction

Disclaimer:
This a continuation of Thomas Verbiscer project https://github.com/tverbiscer/capistrano-asgroup which seams to be abandonned.

capistrano-asgroup is a [Capistrano](https://github.com/capistrano/capistrano) plugin designed to simplify the
task of deploying to infrastructure hosted on [Amazon EC2](http://aws.amazon.com/ec2/). It was
completely inspired by the [capistrano-ec2group](https://github.com/logandk/capistrano-ec2group) and 
[capistrano-ec2tag](https://github.com/douglasjarquin/capistrano-ec2tag) plugins, to which all credit is due.

Both of the prior plugins gave you "a way" to deploy using Capistrano to AWS Auto Scaling groups but both
required you to do so in a non-straightforward manner by putting your Auto Scaling group in its own
security group or by providing a unique tag for your Auto Scaling group.  This plugin simply takes the 
name of the Auto Scaling group and uses that to find the Auto Scaling instances that it should deploy to.  It will
work with straight up hand created Auto Scaling groups (exact match of the AS group name) or with 
Cloud Formation created Auto Scaling groups (looking for the name in the Cloud Formation format).

## Installation

### Set the Amazon AWS Credentials

In order for the plugin to list out the hostnames of your AWS Auto Scaling instances, it
will need access to the Amazon AWS API.  It is recommended to use IAM to create credentials
with limited capabilities for this type of purpose. Specify the following in your
Capistrano configuration:

```ruby
set :aws_access_key_id, ENV['AWS_ACCESS_KEY_ID']
set :aws_secret_access_key, ENV['AWS_SECRET_ACCESS_KEY']
```

or the less secure option to keep the keys in code:

```ruby
set :aws_access_key_id, '...'
set :aws_secret_access_key, '...'
```


### Get the gem

The plugin is distributed as a Ruby gem.

**Ruby Gems**

```bash
gem install capistrano-asgroup
```

**Bundler**

Using [bundler](http://gembundler.com/)?

```bash
gem install bundler
```

Then add the following to your Gemfile:

```ruby
source 'http://rubygems.org'
gem 'capistrano-asgroup'
```

Install the gems in your manifest using:

```bash
bundle install
```

## Usage

### Configure Capistrano

Instead of manually defining the hostnames to deploy to like this:

```ruby
set :aws_region, 'eu-west-1' # set the region of AWS
role :web, 'mysever1.example.com','myserver2.example.com'
```

Simple do this where <my-autoscale-group-name> is the name of an autoscale group:

```ruby
asgroupname '<my-autoscale-group-name>', :web
```

So instead of:

```ruby
task :production do
  role :web, 'mysever1.example.com','myserver2.example.com'
  logger.info 'Deploying to the PRODUCTION environment!'
end
```

You would do:

```ruby
require 'capistrano/asgroup'

task :production do
  asgroupname 'production-github-web', :web
  logger.info 'Deploying to the PRODUCTION environment!'
end
```

### Additional configuration

In order to deploy through a NAT instance in AWS VPC, you will need the instances private IP address instead of the DNS name

```ruby
set :asgroup_use_private_ips, true
```


## License

capistrano-asgroup is copyright 2013 by [Thomas Verbiscer](http://tom.verbiscer.com/), released under the MIT License (see LICENSE for details).

