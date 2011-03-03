module Backstage
  class MessageProcessor
    include HasMBean
    include TorqueBoxManaged
    
    def self.filter
      "torquebox.messaging.processors:*"
    end

    def destination_name
      name = super
      name =~ /\[(.*)\]/ ? $1 : name
    end
  end
end
