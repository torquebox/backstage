module Backstage
  class Backstage::App < Sinatra::Base
    get "/jobs" do
      haml :"jobs/index"
    end
  end
end
