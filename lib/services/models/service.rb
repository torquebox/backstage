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
  class Service
    include HasMBean
    include TorqueBoxManaged
    include Resource
    
    def self.filter
      "torquebox.services:*"
    end

    def self.to_hash_attributes
      super + [:name, :app, :app_name, :status]
    end

    def start
      super
      self
    end

    def stop
      super
      self
    end
    
    def available_actions
      status == 'Started' ? %w{ stop } : %w{ start }
    end
  end
end
