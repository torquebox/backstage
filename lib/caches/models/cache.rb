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
  class Cache
    include HasMBean
    include TorqueBoxManaged
    include Resource
    
    def self.filter
      "org.infinispan:component=CacheManager,*"
    end

    def self.to_hash_attributes
      super + [:name, :cache_manager_status, :created_cache_count, :defined_cache_count, :running_cache_count, :version, :defined_cache_names]
    end

    # for use with show.haml
    alias_method :cache_manager_name, :name

    # reformat the defined_cache_names string
    def cache_names
      names = {}
      dcns = self.defined_cache_names.sub('[', '')

      list = dcns.split(')')
        list.each do |cache_name|
          unless cache_name == "]"
            if cache_name.include? "(not created"
              names.store(cache_name.sub("(not created", ""), "not created")
            else
              names.store(cache_name.sub("(created", ""), "created")
            end
         end
      end

      names
    end
 
    def rpc_caches
      rpc = JMX::MBeanServer.new
      manager = self.name
      rpc_caches = []   # JMX::MBeans::Org::Infinispan::Remoting::Rpc::RpcManagerImpl

      # find the name of the cluster connection control 
      filter_str = 'org.infinispan:component=RpcManager,manager="' + manager + '",*'

      rpc.query_names( filter_str ).collect do |name|
        data = name.to_s.split(',')
        cache_name = data[1].sub('name=', '')
 
        rpc_caches << [ cache_name, JMX::MBeanServer.new[ name ] ]
      end
 
      rpc_caches 
    end
  end
end
