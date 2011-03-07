
module Backstage
  class Application < Sinatra::Base
    %w{ queue topic }.each do |model|
      resource model, :view_path => :destinations, :actions => [:pause, :resume]
      
      get "/#{model}/:name/messages" do
        @object = eval(model.classify).find( Util.decode_name( params[:name] ) )
        haml :'messages/index'
      end

    end
  end
end
    
