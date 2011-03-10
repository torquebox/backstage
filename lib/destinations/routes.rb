
module Backstage
  class Application < Sinatra::Base
    resource :queue, :topic, :view_path => :destinations, :actions => [:pause, :resume]

    get "/queue/:name/messages" do
      @destination = Queue.find( Util.decode_name( params[:name] ) )
      haml :'messages/index'
    end

    get "/queue/:name/message/:id" do
      @destination = Queue.find( Util.decode_name( params[:name] ) )
      @object = @destination.find { |m| m.jms_id == Util.decode_name( params[:id] ) }
      haml :'messages/show'
    end
  end
end

