module Backstage
  class Job
    include HasMBean
    include TorqueBoxManaged
    include Resource
    
    def self.filter
      "torquebox.jobs:*"
    end

    def self.to_hash_attributes
      super + [:name, :app, :app_name, :ruby_class_name, :status, :cron_expression]
    end

    def available_actions
      status == 'Started' ? %w{stop} : %w{start}
    end
  end
end
