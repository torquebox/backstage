if __FILE__ == $0
  puts "Run with: watchr #{__FILE__}. \n\nRequired gems: watchr"
  exit 1
end

# --------------------------------------------------
# Convenience Methods
# --------------------------------------------------
def run(cmd)
  puts(cmd)
  system('gem env')
  system(cmd)
  puts '-' * 60
end

def run_specs(*specs)
  run "jruby target/rspec-runner.rb #{specs.join(' ')}"
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
