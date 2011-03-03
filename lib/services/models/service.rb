module Backstage
  class Service
    include HasMBean
    include TorqueBoxManaged
    
    def self.filter
      "torquebox.services:*"
    end
  end
end
