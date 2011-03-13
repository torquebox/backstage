module Backstage
  class Message
    include Resource

    attr_reader :jms_message

    IGNORED_PROPERTIES = %w{ torquebox_encoding JMSXDeliveryCount }
    def initialize(message)
      @jms_message = message
    end

    def text
      jms_message.get_string_property( 'torquebox_encoding' ) ? Base64.decode64( jms_message.text ) : jms_message.text
    end

    def jms_id
      jms_message.jmsmessage_id
    end
    alias_method :full_name, :jms_id
    
    def properties
      @properties ||= jms_message.property_names.inject( {} ) do |properties, name|
        properties[name] = jms_message.get_string_property( name ) unless IGNORED_PROPERTIES.include?( name )
        properties        
      end
    end
    
    def delivery_count
      jms_message.get_string_property( 'JMSXDeliveryCount' )
    end

    def self.to_hash_attributes
      super + [:jms_id, :delivery_count, :properties, :text]
    end
  end
end
