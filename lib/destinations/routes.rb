
module Backstage
  class Application < Sinatra::Base
        %w{ queue topic }.each do |model|
      klass = eval(model.capitalize)
      get "/#{model}s" do
        @destinations = klass.all
        @header = "#{model.capitalize}s"
        haml :'destinations/index'
      end

      get "/#{model}/:name" do
        @destination = klass.find( params[:name] )
        haml :'destinations/show'
      end
      
      get "/#{model}/:name/messages" do
        @destination = klass.find( params[:name] )
        haml :'messages/index'
      end
    end
  end
end

    
