module Backstage
  class Application < Sinatra::Base
    get "/apps" do
      @apps = App.all
      haml :"apps/index"
    end
  end
end
