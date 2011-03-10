
module Backstage
  class Application < Sinatra::Base
    %w{ queue topic }.each do |model|
      resource model, :view_path => :destinations, :actions => [:pause, :resume]
      
      get "/#{model}/:name/messages" do
        @destination = eval( model.classify ).find( Util.decode_name( params[:name] ) )
        haml :'messages/index'
      end

      get "/#{model}/:name/message/:id" do
        @destination = eval( model.classify ).find( Util.decode_name( params[:name] ) )
        @object = @destination.find { |m| m.jms_id == Util.decode_name( params[:id] ) }
        haml :'messages/show'
      end

    end
  end
end
    
