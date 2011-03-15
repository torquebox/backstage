#
# Copyright 2011 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if __FILE__ == $0
  puts "Run with: watchr #{__FILE__}. \n\nRequired gems: watchr"
  exit 1
end

# --------------------------------------------------
# Convenience Methods
# --------------------------------------------------
def run(cmd)
  puts(cmd)
  system(cmd)
  puts '-' * 60
end

def run_specs(*specs)
  specs << 'spec' if specs.empty?
  run "jruby -S bundle exec rspec #{specs.join(' ')}"
end

 def run_single_spec *spec
   spec = spec.join(' ')
   if File.exists?(spec)
     run_specs(spec)
   else
     puts "#{spec} does not exist - skipping..."
   end
 end

 def redeploy
   puts "--- Redeploying @ #{Time.now.strftime("%H:%M:%S")}..."
   system "touch #{ENV['JBOSS_HOME']}/server/default/deploy/backstage-knob.yml"
 end
 
# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
#watch( '^spec/.*_spec\.rb' ) { |m| run_single_spec(m[0]) }
 watch( '^(.*)\.rb' ) do |m|
   redeploy
   run_specs
 #  run_single_spec("spec/%s_spec.rb" % m[1])
 end
 
 watch( '^(.*)\.(haml|yml|sass)' ) do |m|
   redeploy
 end

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-Z
Signal.trap('TSTP') do
  puts " --- Running all specs ---\n\n"
  run_specs
end
 
# Ctrl-C
Signal.trap('INT') do
  abort("--- Exiting!\n\n")
  exit
end
puts "--- Watching..."
#run_specs
