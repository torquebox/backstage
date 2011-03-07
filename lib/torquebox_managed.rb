module Backstage
  module TorqueBoxManaged
    def name
      return mbean.name if mbean.respond_to?( :name )
      $1 if full_name =~ /name=(.*)$/
    end

    def app_name
      $1.gsub('.trq', '') if full_name =~ /app=(.*?)(,|$)/
    end

    def app
      App.find( "torquebox.apps:app=#{app_name}.trq" )
    end
    
    def status
      mbean.status.downcase.capitalize
    end
  end
end
