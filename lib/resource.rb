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
  module Resource

    def self.included(base)
      base.extend( ClassMethods )
      base.send( :attr_accessor, :parent )
    end

    def association_chain
      chain = []
      chain << parent if parent
      chain << self
      chain
    end
    
    def to_hash
      self.class.to_hash_attributes.inject({ }) do |response, attribute|
        response[attribute] = __send__( attribute )
        response
      end
    end

    def resource
      self
    end

    def available_actions
      []
    end

    module ClassMethods
      def to_hash_attributes
        [:resource]
      end
    end
  end
end
