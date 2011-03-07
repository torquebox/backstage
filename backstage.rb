require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'sass'

$:.unshift File.join( File.dirname( __FILE__ ), 'lib' )

require 'torquebox'
require 'resource'
require 'helpers'
require 'has_mbean'
require 'torquebox_managed'
require 'apps'
require 'destinations'
require 'message_processors'
require 'jobs'
require 'services'

module Backstage
  class Application < Sinatra::Base
    enable :logging

    set :views, Proc.new { File.join( File.dirname( root ), "views" ) }

    get '/css/style.css' do
      sass :'css/style'
    end

    get '/css/html5reset.css' do
      sass :'css/html5reset'
    end

    get "/" do
      redirect collection_path( :apps )
    end
  end
end
