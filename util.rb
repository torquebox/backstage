require 'base64'

module Backstage
  module Util
    class << self
      def encode_name(name)
        Base64.encode64( name ).gsub("\n", '')
      end

      def decode_name(name)
        Base64.decode64( name )
      end
    end
  end
end
