module Backstage
  class Application < Sinatra::Base
    def self.resource(*resources)
      options = resources.pop if resources.last.is_a?(Hash)
      options ||= {}
      resources.each do |resource|
        resource = resource.to_s
        klass = eval(resource.classify)
        view_path = options[:view_path] || resource.pluralize
        get "/#{resource.pluralize}" do
          @collection = klass.all
          haml :"#{view_path}/index"
        end

        get "/#{resource}/:name" do
          @object = klass.find( Util.decode_name( params[:name] ) )
          haml :"#{view_path}/show"
        end

        (options[:actions] || []).each do |action|
          post "/#{resource}/:name/#{action}" do
            object = klass.find( Util.decode_name( params[:name] ) )
            object.__send__( action )
            flash[:notice] = "'#{action}' called on #{simple_class_name( object ).humanize} #{object.name}"
            redirect object_path( object )
          end
        end
      end
    end
  end
end
