require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'sass'
require 'rack-flash'

$: << File.join( File.dirname( __FILE__ ), 'models' )

require 'config/jmx-connection'
require 'queue'
require 'topic'
require 'helpers'

module Backstage
  class Backstage::App < Sinatra::Base
    enable :logging
    
    set :views, Proc.new { File.join( File.dirname( root ), "views" ) }

    get "/" do
      "it works"
    end

    get "/queues" do
      @destinations = Queue.all
      @header = 'Queues'
      haml :'destinations/index'
    end

    get "/queue/:name" do
      @destination = Queue.find( params[:name] )
      haml :'destinations/show'
    end

    get "/queue/:name/messages" do
      @destination = Queue.find( params[:name] )
      @messages = @destination.messages
      haml :'messages/index'
    end
    
    get "/topics" do
      @destinations = Topic.all
      @header = 'Topics'
      haml :'destinations/index'
    end

  end
end
