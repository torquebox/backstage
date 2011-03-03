module Backstage
  module TorqueBoxManaged
    def name
      return mbean.name if mbean.respond_to?( :name )
      $1 if full_name =~ /name=(.*)$/
    end

    def app
      $1.gsub('.trq', '') if full_name =~ /app=(.*?)(,|$)/
    end

    def status
      mbean.status.downcase.capitalize
    end
  end
end
