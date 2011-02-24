require 'has_mbean'

module Backstage
  class Destination
    include HasMBean

    def self.filter
      'org.hornetq:address=*,*,type=Queue'
    end

    def messages
      JSON.parse( list_messages_as_json( nil ) )
    end

    def name
      super.gsub('jms.queue.', '')
    end
  end
end
