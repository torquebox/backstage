require 'util'

module Backstage
  module HasMBean
    def self.included(base)
      base.send( :attr_accessor, :mbean )
      base.extend( ClassMethods )
    end

    def initialize(mbean)
      self.mbean = mbean
    end

    def full_name
      mbean.object_name.to_string
    end
    
    def method_missing(method, *args, &block)
      mbean.send( method, args, block )
    rescue NoMethodError => ex
      super
    end

    module ClassMethods
      def all
        JMX::MBean.find_all_by_name( filter ).collect { |mbean| new( mbean ) }
      end

      def find(name)
        new( JMX::MBean.find_by_name( Util.decode_name( name ) ) )
      end

    end
  end
end
