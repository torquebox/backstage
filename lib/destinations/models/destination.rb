require 'json'

module Backstage
  class Destination
    include Enumerable
    include HasMBean

    def self.filter
      'org.hornetq:address=*,*,type=Queue'
    end

    def jms_desination
      @jms_desination ||= TorqueBox::Messaging::Queue.new( jndi_name )
    end
    
    def each(options = { })
      jms_desination.each do |message|
        message = Message.new( message )
        yield message
      end
    end

    def display_name
      display_name = name.gsub( 'jms.queue.', '' )
      display_name = 'Backgroundable' if display_name =~ %r{/queues/torquebox/.*/backgroundable}
      display_name = "#{$1.classify}Task" if display_name =~ %r{/queues/torquebox/.*/tasks/(.*)$}
      display_name
    end

    def jndi_name
      jndi_name = name.gsub( 'jms.queue.', '' )
      jndi_name = "/queue/#{jndi_name}" if %w{ DLQ ExpiryQueue }.include?( jndi_name )
      jndi_name
    end

    def app_name
      name =~ %r{/queues/torquebox/(.*)\.trq} ? $1 : 'n/a'
    end
  end
end
