# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'capistrano-asgroup'
  s.version     = '0.0.1'
  s.authors     = ['Thomas Verbiscer']
  s.date        = '2013-01-17'
  s.email       = ['asgroup@verbiscer.com']
  s.homepage    = 'https://github.com/tverbiscer/capistrano-asgroup'
  s.summary     = 'A Capistrano plugin aimed at easing the pain of deploying to AWS Auto Scale instances.'
  s.description = 'capistrano-asgroup is a Capistrano plugin designed to simplify the task of deploying to infrastructure hosted on Amazon AWS, in particular, within Auto Scaling Groups. It was completely inspired by the capistrano-ec2group and capistrano-ec2tag plugins, to which all credit is due.'

  s.rubyforge_project = 'capistrano-asgroup'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'capistrano', '>=2.1.0'
  s.add_dependency 'right_aws'
end
