# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{torquebox-backstage}
  s.version = "0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
    s.authors = ["Tobias Crawley", "David Glassborow", "Penumbra Shadow"]
  s.date = %q{2011-07-28}
  s.description = %q{BackStage allows you to look behind the TorqueBox curtain, and view information about all of the components you have running. It includes support for remote code execution and log tailing to aid in debugging.}
  s.email = %q{tcrawley@redhat.com}
  s.executables = ["backstage"]
  s.extra_rdoc_files = [
                        "README.md",
                        "TODO"
                       ]
  
  s.files = Dir[
                "backstage.rb",
                "config.ru",
                "[A-Z]*",
                "config/**/*",
                "lib/**/*",
                "public/**/*",
                "views/**/*"
               ]

  s.homepage = %q{http://github.com/torquebox/backstage}
  s.licenses = ["AL"]
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
      s.add_runtime_dependency(%q<torquebox>, ["= 1.1"])
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
      s.add_dependency(%q<torquebox>, ["= 1.1"])
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
    s.add_dependency(%q<torquebox>, ["= 1.1"])
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

