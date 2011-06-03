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

module Backstage
  class App
    include HasMBean
    include TorqueBoxManaged
    include Resource
    
    def self.filter
      "torquebox.apps:name=*"
    end

    def self.to_hash_attributes
      super + [:name, :environment_name, :root_path, :deployed_at]
    end

    def has_logs?
      File.directory?( log_dir )
    end
    
    def logs
      logs = Log.all( log_dir )
      logs.each { |log| log.parent = self }
      logs
    end

    def log_dir
      log_dir = File.join( root_path, 'logs' )
      log_dir = File.join( Backstage.jboss_log_dir, name ) if !File.directory?( log_dir ) && Backstage.jboss_log_dir
      log_dir = File.join( root_path, 'log' ) unless File.directory?( log_dir )

      log_dir
    end
  end
end

