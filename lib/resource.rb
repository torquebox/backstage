module Backstage
  module Resource

    def self.included(base)
      base.extend( ClassMethods )
      base.send( :attr_accessor, :parent )
    end

    def association_chain
      chain = []
      chain << parent if parent
      chain << self
      chain
    end
    
    def to_hash
      self.class.to_hash_attributes.inject({ }) do |response, attribute|
        response[attribute] = __send__( attribute )
        response
      end
    end

    def resource
      self
    end

    def available_actions
      []
    end

    module ClassMethods
      def to_hash_attributes
        [:resource]
      end
    end
  end
end
