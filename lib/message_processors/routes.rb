module Backstage
  class Application < Sinatra::Base
    get "/message_processors" do
      @message_processors = MessageProcessor.all
      haml :"message_processors/index"
    end
  end
end
