require 'json'

module Backstage
  class Destination
    include Enumerable
    include HasMBean

    attr_accessor :enumerable_options
    
    def self.filter
      "org.hornetq:address=\"#{jms_prefix}\",*,type=Queue"
    end

    def jms_destination
      TorqueBox::Messaging::Queue.new( jndi_name, nil, enumerable_options )
    end
    
    def each
      jms_destination.each do |message|
        message = Message.new( message )
        yield message
      end
    end
    
    def display_name
      self.class.display_name( name )
    end

    def jndi_name
      jndi_name = name.gsub( self.class.jms_prefix, '' )
      jndi_name = "/queue/#{jndi_name}" if %w{ DLQ ExpiryQueue }.include?( jndi_name )
      jndi_name
    end

    def self.display_name(name)
      display_name = name.gsub( /jms\..*?\./, '' )
      display_name = 'Backgroundable' if display_name =~ %r{/queues/torquebox/.*/backgroundable}
      display_name = "#{$1.classify}Task" if display_name =~ %r{/queues/torquebox/.*/tasks/(.*)$}
      display_name
    end

    def app
      name =~ %r{/queues/torquebox/(.*?)/} ? App.find( "torquebox.apps:app=#{$1}" ) : nil
    end
    
    def app_name
      name =~ %r{/queues/torquebox/(.*)\.trq} ? $1 : 'n/a'
    end

    def status
      mbean.paused ? 'Paused' : 'Running'
    end
  end
end
