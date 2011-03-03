require 'json'

module Backstage
  class Destination
    include Enumerable
    include HasMBean

    def self.filter
      'org.hornetq:address=*,*,type=Queue'
    end

    def jms_desination
      @jms_desination ||= TorqueBox::Messaging::Queue.new( name )
    end
    
    def each(options = { })
      jms_desination.each do |message|
        message = Message.new( message )
        yield message
      end
    end

    def name
      super.gsub( 'jms.queue.', '' )
    end

  end
end
