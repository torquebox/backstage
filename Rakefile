require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require 'torquebox-rake-support'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "torquebox-backstage"
  gem.homepage = "http://github.com/torquebox/backstage"
  gem.license = "MIT"
  gem.summary = %Q{BackStage - Queue/Topic/Job/etc viewer for TorqueBox}
  gem.description = %Q{BackStage allows you to look behind the TorqueBox curtain, and view information about all of the components you have running. It includes support for remote code execution and log tailing to aid in debugging.}
  gem.email = "tcrawley@redhat.com"
  gem.authors = ["Tobias Crawley"]
  gem.files = FileList["[A-Z]*", 'backstage.rb', 'config.ru', 'bin/*.rb', "{config,lib,spec,views,public}/**/*"]
  gem.executables = %w{backstage}
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  gem.add_runtime_dependency 'thor', '> 0.14'
  gem.add_runtime_dependency 'bundler', '>= 1.0.12'
end
Jeweler::RubygemsDotOrgTasks.new


