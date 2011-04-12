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
  module HasMBean
    java_import javax.management.ObjectName

    def self.included(base)
      base.send( :attr_accessor, :mbean_name, :mbean )
      base.extend( ClassMethods )
    end

    def initialize(mbean_name, mbean)
      self.mbean_name = mbean_name
      self.mbean = mbean

      # this works around a bug in the jmx gem where method_missing is busted
      # https://github.com/enebo/jmxjr/issues/5
      def mbean.method_missing(meth, *args, &block)
        raise NoMethodError.new( "undefined method '#{meth}' for #{self}", meth, args )
      end
    end
    
    def full_name
      mbean_name.to_s
    end

    def method_missing(method, *args, &block)
      mbean.send( method, *args, &block )
    rescue NoMethodError => ex
      super
    end
    
    module ClassMethods
      def jmx_server
        @jmx_server ||= JMX::MBeanServer.new
      end

      def all(filter_string = filter)
        jmx_server.query_names( filter_string ).collect { |name| new( name, jmx_server[name] ) }
      end

      def find(name)
        name = ObjectName.new( name ) unless name.is_a?( ObjectName )
        new( name, jmx_server[name] )
      rescue JMX::NoSuchBeanError => ex
        nil
      end

    end
  end
end
