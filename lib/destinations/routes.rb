
module Backstage
  class Application < Sinatra::Base
    %w{ queue topic }.each do |model|
      resource model, :view_path => :destinations
      
      get "/#{model}/:name/messages" do
        @object = klass.find( params[:name] )
        haml :'messages/index'
      end

    end
  end
end
    
