require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'sass'
require 'rack-flash'

$:.unshift File.join( File.dirname( __FILE__ ), 'lib' )

require 'torquebox'
require 'config/jmx-connection'
require 'helpers'
require 'destinations'
require 'jobs'
require 'services'

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

  end
end
