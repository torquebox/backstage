
module Backstage
  class Application < Sinatra::Base
    resource :queue, :topic, :view_path => :destinations, :actions => [:pause, :resume]

    get "/queue/:name/messages" do
      @destination = Queue.find( Util.decode_name( params[:name] ) )
      if html_requested?
        haml :'messages/index'
      else
        content_type :json
        collection_to_json( @destination.entries )
      end
    end

    get "/queue/:name/message/:id" do
      @destination = Queue.find( Util.decode_name( params[:name] ) )
      @object = @destination.find { |m| m.jms_id == Util.decode_name( params[:id] ) }
      if html_requested?
        haml :'messages/show'
      else
        object_to_json( @object )
      end
    end
    
  end
end

