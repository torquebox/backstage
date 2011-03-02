module Backstage
  class Queue < Destination
    
    def self.filter
      'org.hornetq:address="jms.queue.*",*,type=Queue'
    end
    
  end
end
