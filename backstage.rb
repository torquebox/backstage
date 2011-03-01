require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'sass'
require 'rack-flash'

$: << File.join( File.dirname( __FILE__ ), 'models' )

require 'config/jmx-connection'
require 'queue'
require 'topic'
require 'message'
require 'helpers'

module Backstage
  class Backstage::App < Sinatra::Base
    enable :logging
    
    set :views, Proc.new { File.join( File.dirname( root ), "views" ) }

    get '/css/style.css' do
      sass :'css/style'
    end

    get '/css/html5reset.css' do
      sass :'css/html5reset'
    end

    get "/" do
      haml :'root/index'
    end

    %w{ queue topic }.each do |model|
      klass = eval(model.capitalize)
      get "/#{model}s" do
        @destinations = klass.all
        @header = "#{model.capitalize}s"
        haml :'destinations/index'
      end

      get "/#{model}/:name" do
        @destination = klass.find( params[:name] )
        haml :'destinations/show'
      end
      
      get "/#{model}/:name/messages" do
        @destination = klass.find( params[:name] )
        haml :'messages/index'
      end
    end

    get "/jobs" do
      haml :"jobs/index"
    end
  end
end
