module Backstage
  class Job
    include HasMBean
    include TorqueBoxManaged
    
    def self.filter
      "torquebox.jobs:*"
    end

  end
end
