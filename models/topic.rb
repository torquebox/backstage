require 'destination'

module Backstage
  class Topic < Destination

    def self.filter
      'org.hornetq:address="jms.topic.*",*,type=Queue' 
    end

  end
end
