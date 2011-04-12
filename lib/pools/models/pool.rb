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
  class Pool
    include HasMBean
    include TorqueBoxManaged
    include Resource
    
    def self.filter
      "torquebox.pools:*"
    end

    def self.to_hash_attributes
      super + [:name, :app, :app_name, :pool_type, :size, :available, :borrowed, :minimum_instances, :maximum_instances]
    end

    def pool_type
      full_name =~ /type=(.*?)(,|$)/ ? $1 : ''
    end

    def size
      shared? ? 1 : mbean.size
    end
    
    %w{ available borrowed minimum_instances maximum_instances }.each do |meth|
      define_method meth do
        shared? ? 0 : mbean.__send__( meth )
      end
    end

    def shared?
      pool_type == 'shared'
    end

  end
end

