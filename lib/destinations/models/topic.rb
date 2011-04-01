#
# Copyright 2011 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
        @consumer_topics = self.class.all( %Q{org.hornetq:address="#{name}",*,type=Queue} )
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
