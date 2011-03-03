module Backstage
  class Application < Sinatra::Base
    get "/services" do
      @services = Service.all
      haml :"services/index"
    end
  end
end
