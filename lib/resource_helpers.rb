module Backstage
  class Application < Sinatra::Base
    def self.resource(*resources)
      options = resources.pop if resources.last.is_a?(Hash)
      options ||= {}
      resources.each do |resource|
        resource = resource.to_s
        klass = "backstage/#{resource}".constantize
        view_path = options[:view_path] || resource.pluralize
        get "/#{resource.pluralize}" do
          @collection = klass.all
          if html_requested?
            haml :"#{view_path}/index"
          else
            content_type :json
            collection_to_json( @collection )
          end
        end

        get "/#{resource}/:name" do
          @object = klass.find( Util.decode_name( params[:name] ) )
          if html_requested?
            haml :"#{view_path}/show"
          else
            content_type :json
            object_to_json( @object )
          end
        end

        (options[:actions] || []).each do |action|
          post "/#{resource}/:name/#{action}" do
            object = klass.find( Util.decode_name( params[:name] ) )
            object.__send__( action )
            if html_requested?
              flash[:notice] = "'#{action}' called on #{simple_class_name( object ).humanize} #{object.name}"
              redirect_to object_path( object )
            else
              content_type :json
              object_to_json( @object )
            end
          end

        end
      end
    end
  end
end
