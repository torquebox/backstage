module Backstage
  class Application < Sinatra::Base
    def self.resource(*resources)
      options = resources.pop if resources.last.is_a?(Hash)
      options ||= {}
      resources.each do |resource|
        resource = resource.to_s
        klass = eval(resource.classify)
        view_path = options[:view_path] || "#{resource}s"
        get "/#{resource}s" do
          @collection = klass.all
          haml :"#{view_path}/index"
        end

        get "/#{resource}/:name" do
          @object = klass.find( params[:name] )
          haml :"#{view_path}/show"
        end
      end
    end
  end
end
