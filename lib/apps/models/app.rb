module Backstage
  class App
    include HasMBean
    include TorqueBoxManaged
    include Resource
    
    def self.filter
      "torquebox.apps:*"
    end

    def self.to_hash_attributes
      super + [:name, :environment_name, :root_path, :deployed_at]
    end
    
    def name
      super.gsub( '.trq', '' )
    end
  end
end

