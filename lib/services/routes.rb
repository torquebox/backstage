module Backstage
  class Backstage::App < Sinatra::Base
    get "/services" do
      haml :"services/index"
    end
  end
end
