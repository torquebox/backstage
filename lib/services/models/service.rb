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

    def available_actions
      status == 'Started' ? %w{ stop } : %w{ start' }
    end
  end
end
