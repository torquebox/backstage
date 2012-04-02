# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{torquebox-backstage}
  s.version = IO.read(File.join(File.dirname(__FILE__), 'VERSION')).strip
  s.date = Time.now.strftime('%Y-%m-%d')
  s.authors = ["Tobias Crawley", "David Glassborow", "Penumbra Shadow"]
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
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
               ] - %w{ Gemfile.lock }

  s.homepage = %q{http://github.com/torquebox/backstage}
  s.licenses = ["AL"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.1}
  s.summary = %q{BackStage - Queue/Topic/Job/etc viewer for TorqueBox}


  deps = [
          [%q<sinatra>, "= 1.2.6"],
          [%q<haml>, "~> 3.0"],
          [%q<sass>, "~> 3.1.2"],
          [%q<tobias-jmx>, "= 0.8"],
          [%q<json>, "= 1.5.1"],
          [%q<torquebox>, "~> 2.0.0"
          ],
          [%q<tobias-sinatra-url-for>, "= 0.2.1"],
          [%q<rack-accept>, "~> 0.4.4"],
          [%q<thor>, "= 0.14.6"],
          [%q<bundler>, "~> 1.0.12"],
          [%q<thor>, "= 0.14.6", :dev],
          [%q<watchr>, "~> 0.7", :dev],
          [%q<rspec>, "~> 2.6.0", :dev],
          [%q<rack-test>, "~> 0.6.0", :dev]
         ]
  
  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      deps.each do |name, version, dev|
        if dev
          s.add_development_dependency(name, [version])
        else
          s.add_runtime_dependency(name, [version])
        end
      end
    else
      deps.each do |name, version|
        s.add_dependency(name, [version])
      end
    end
  else
    deps.each do |name, version|
      s.add_dependency(name, [version])
    end
  end
end

