require 'util'

module Backstage
  class Backstage::App < Sinatra::Base
    helpers do
      def home_path
        request.script_name
      end

      def object_path(*objects)
        paths = []
        objects.each do |object|
          paths << "#{simple_class_name( object )}/#{Util.encode_name( object.full_name )}"
        end
        path_to( paths.join( '/' ) )
      end


      def path_to(location)
        "#{home_path}/#{location}"
      end

      def redirect_to(location)
        redirect path_to(location)
      end

      def link_to(path, text)
        "<a href='#{path}'>#{text}</a>"
      end

      def simple_class_name(object)
        object.class.name.split( "::" ).last.downcase
      end
    end
  end
end
