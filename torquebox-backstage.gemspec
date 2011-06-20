# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{torquebox-backstage}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
    s.authors = ["Tobias Crawley"]
  s.date = %q{2011-06-06}
  s.default_executable = %q{backstage}
  s.description = %q{BackStage allows you to look behind the TorqueBox curtain, and view information about all of the components you have running. It includes support for remote code execution and log tailing to aid in debugging.}
  s.email = %q{tcrawley@redhat.com}
  s.executables = ["backstage"]
  s.extra_rdoc_files = [
                        "README.md",
                        "TODO"
                       ]
  s.files = [
             "CHANGELOG.md",
             "Gemfile",
             "Gemfile.lock",
             "README.md",
             "TODO",
             "TORQUEBOX_VERSION",
             "VERSION",
             "backstage.rb",
             "config.ru",
             "config/torquebox.yml",
             "lib/apps.rb",
             "lib/apps/models/app.rb",
             "lib/apps/routes.rb",
             "lib/authentication.rb",
             "lib/destinations.rb",
             "lib/destinations/models/destination.rb",
             "lib/destinations/models/message.rb",
             "lib/destinations/models/queue.rb",
             "lib/destinations/models/topic.rb",
             "lib/destinations/routes.rb",
             "lib/has_mbean.rb",
             "lib/helpers.rb",
             "lib/jobs.rb",
             "lib/jobs/models/job.rb",
             "lib/jobs/routes.rb",
             "lib/logs.rb",
             "lib/logs/models/log.rb",
             "lib/logs/routes.rb",
             "lib/message_processors.rb",
             "lib/message_processors/models/message_processor.rb",
             "lib/message_processors/routes.rb",
             "lib/pools.rb",
             "lib/pools/models/pool.rb",
             "lib/pools/routes.rb",
             "lib/resource.rb",
             "lib/resource_helpers.rb",
             "lib/runtimes.rb",
             "lib/runtimes/models/job.rb",
             "lib/runtimes/routes.rb",
             "lib/services.rb",
             "lib/services/models/service.rb",
             "lib/services/routes.rb",
             "lib/torquebox_managed.rb",
             "lib/util.rb",
             "public/ajax-loader.gif",
             "public/app.js",
             "public/jquery.min.js",
             "views/apps/index.haml",
             "views/apps/show.haml",
             "views/css/_mixins.sass",
             "views/css/html5reset.sass",
             "views/css/style.sass",
             "views/dashboard/index.haml",
             "views/destinations/index.haml",
             "views/destinations/show.haml",
             "views/jobs/index.haml",
             "views/jobs/show.haml",
             "views/layout.haml",
             "views/logs/index.haml",
             "views/logs/show.haml",
             "views/message_processors/index.haml",
             "views/message_processors/show.haml",
             "views/messages/index.haml",
             "views/messages/properties.haml",
             "views/messages/show.haml",
             "views/pools/index.haml",
             "views/pools/show.haml",
             "views/services/index.haml",
             "views/services/show.haml"
            ]
  s.homepage = %q{http://github.com/torquebox/backstage}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.1}
  s.summary = %q{BackStage - Queue/Topic/Job/etc viewer for TorqueBox}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, ["= 1.2.6"])
      s.add_runtime_dependency(%q<rack-flash>, ["= 0.1.1"])
      s.add_runtime_dependency(%q<haml>, ["= 3.1.1"])
      s.add_runtime_dependency(%q<sass>, ["= 3.1.2"])
      s.add_runtime_dependency(%q<tobias-jmx>, ["= 0.8"])
      s.add_runtime_dependency(%q<json>, ["= 1.5.1"])
      s.add_runtime_dependency(%q<torquebox>, ["= 1.0.1"])
      s.add_runtime_dependency(%q<tobias-sinatra-url-for>, ["= 0.2.1"])
      s.add_runtime_dependency(%q<rack-accept>, ["= 0.4.4"])
      s.add_development_dependency(%q<thor>, ["= 0.14.6"])
      s.add_development_dependency(%q<watchr>, ["~> 0.7"])
      s.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_development_dependency(%q<rack-test>, ["~> 0.6.0"])
      s.add_runtime_dependency(%q<thor>, ["= 0.14.6"])
      s.add_runtime_dependency(%q<bundler>, ["= 1.0.12"])
    else
      s.add_dependency(%q<sinatra>, ["= 1.2.6"])
      s.add_dependency(%q<rack-flash>, ["= 0.1.1"])
      s.add_dependency(%q<haml>, ["= 3.1.1"])
      s.add_dependency(%q<sass>, ["= 3.1.2"])
      s.add_dependency(%q<tobias-jmx>, ["= 0.8"])
      s.add_dependency(%q<json>, ["= 1.5.1"])
      s.add_dependency(%q<torquebox>, ["= 1.0.1"])
      s.add_dependency(%q<tobias-sinatra-url-for>, ["= 0.2.1"])
      s.add_dependency(%q<rack-accept>, ["= 0.4.4"])
      s.add_dependency(%q<thor>, ["= 0.14.6"])
      s.add_dependency(%q<watchr>, ["~> 0.7"])
      s.add_dependency(%q<rspec>, ["~> 2.6.0"])
      s.add_dependency(%q<rack-test>, ["~> 0.6.0"])
      s.add_dependency(%q<thor>, ["= 0.14.6"])
      s.add_dependency(%q<bundler>, ["= 1.0.12"])
    end
  else
    s.add_dependency(%q<sinatra>, ["= 1.2.6"])
    s.add_dependency(%q<rack-flash>, ["= 0.1.1"])
    s.add_dependency(%q<haml>, ["= 3.1.1"])
    s.add_dependency(%q<sass>, ["= 3.1.2"])
    s.add_dependency(%q<tobias-jmx>, ["= 0.8"])
    s.add_dependency(%q<json>, ["= 1.5.1"])
    s.add_dependency(%q<torquebox>, ["= 1.0.1"])
    s.add_dependency(%q<tobias-sinatra-url-for>, ["= 0.2.1"])
    s.add_dependency(%q<rack-accept>, ["= 0.4.4"])
    s.add_dependency(%q<thor>, ["= 0.14.6"])
    s.add_dependency(%q<watchr>, ["~> 0.7"])
    s.add_dependency(%q<rspec>, ["~> 2.6.0"])
    s.add_dependency(%q<rack-test>, ["~> 0.6.0"])
    s.add_dependency(%q<thor>, ["= 0.14.6"])
    s.add_dependency(%q<bundler>, ["= 1.0.12"])
  end
end

