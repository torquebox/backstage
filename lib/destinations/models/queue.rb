module Backstage
  class Queue < Destination

    def self.jms_prefix
      'jms.queue.'
    end
    
    def self.filter
      'org.hornetq:address="jms.queue.*",*,type=Queue'
    end
    
  end
end
