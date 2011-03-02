module Backstage
  class Message
    attr_reader :jms_message
    
    def initialize(message)
      @jms_message = message
    end

    def text
      jms_message.get_string_property( 'torquebox_encoding' ) ? Base64.decode64( jms_message.text ) : jms_message.text
    end

    def jms_id
      jms_message.jmsmessage_id
    end

    def delivery_count
      jms_message.get_string_property( 'JMSXDeliveryCount' )
    end
  end
end
