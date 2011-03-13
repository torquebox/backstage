module Backstage
  class MessageProcessor
    include HasMBean
    include TorqueBoxManaged
    include Resource
    
    def self.filter
      "torquebox.messaging.processors:*"
    end

    def self.to_hash_attributes
      super + [:name, :app, :app_name, :status, :destination_name, :message_selector, :concurrency]
    end
    
    def destination_name
      name = super
      name =~ /\[(.*)\]/ ? $1 : name
    end

    def available_actions
      status == 'Started' ? %w{ stop } : %w{ start }
    end
  end
end
