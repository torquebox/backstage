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
  class Group
    include HasMBean
    include Resource
    
    def self.filter
      "jgroups:cluster=*,type=channel"
    end

    def self.to_hash_attributes
      super + [:address,
               :cluster_name,
               :connected,
               :name,
               :number_of_tasks_in_timer,
               :open,
               :received_bytes,
               :received_messages,
               :sent_bytes,
               :sent_messages,
               :stats,
               :timer_threads,
               :version,
               :view]
    end

    # this shadows Object#open
    def open
      mbean[:open]
    end
    
    def protocols
      mbean = JMX::MBeanServer.new
      cluster = self.cluster_name
      protocols = [] 

      # find the protocols used by 'cluster' 
      filter_str = 'jboss.jgroups:cluster=' + cluster + ',protocol=*,*'

      mbean.query_names( filter_str ).collect do |name|
        protocols << JMX::MBeanServer.new[ name ]
      end

      protocols 
    end
  end
end
