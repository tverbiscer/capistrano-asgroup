## Introduction

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

```ruby
require 'capistrano/asgroup'

task :production do
  tag 'production-github-web', :web
  tag 'production-github-job', :job
  logger.info 'Deploying to the PRODUCTION environment!'
end

task :staging do
  tag 'staging-github-web', :web
  tag 'staging-github-job', :job
  logger.info 'Deploying to the STAGING environment!'
end
```

## License

capistrano-asgroup is copyright 2012 by [Thomas Verbiscer](http://tom.verbiscer.com/), released under the MIT License (see LICENSE for details).

