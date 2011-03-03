module Backstage
  class App
    include HasMBean
    include TorqueBoxManaged
    
    def self.filter
      "torquebox.apps:*"
    end

    def name
      super.gsub( '.trq', '' )
    end
  end
end
