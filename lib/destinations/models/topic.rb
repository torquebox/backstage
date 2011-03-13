module Backstage
  class Topic < Destination
    attr_accessor :consumer_topic
    
    def self.jms_prefix
      'jms.topic.'
    end
    
    def self.filter
      'org.hornetq:address="jms.topic.*",*,name="jms.topic.*",type=Queue' 
    end

    def consumer_topics
      unless @consumer_topics
        @consumer_topics = self.class.all( 'org.hornetq:address="jms.topic.*",*,type=Queue' )
        @consumer_topics = @consumer_topics.reject { |t| t.full_name == full_name }
        @consumer_topics.each { |t| t.consumer_topic = true }
      end
      @consumer_topics
    end

    %w{ message_count delivering_count scheduled_count messages_added }.each do |method|
      define_method method do
        if consumer_topic
          super 
        else
          consumer_topics.collect(&(method.to_sym)).max || 0
        end
      end
    end

    def consumer_count
      consumer_topics.size
    end

    %w{ pause resume }.each do |action|
      define_method action do
        super
        consumer_topics.each { |t| t.__send__( action ) } unless consumer_topic
      end
    end
  end
end
