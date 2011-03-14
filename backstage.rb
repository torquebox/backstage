require 'rubygems'
require 'sinatra/base'
require 'rack-flash'
require 'rack/accept'
require 'haml'
require 'sass'
require 'jmx'

$:.unshift File.join( File.dirname( __FILE__ ), 'lib' )

require 'torquebox'
require 'resource_helpers'
require 'resource'
require 'helpers'
require 'has_mbean'
require 'torquebox_managed'
require 'apps'
require 'destinations'
require 'message_processors'
require 'jobs'
require 'services'


puts "ENV['USERNAME'] and ENV['PASSWORD'] are not set, *disabling* authentication" unless ENV['USERNAME'] && ENV['PASSWORD']

module Backstage
  class Application < Sinatra::Base
    enable :logging, :sessions
    use Rack::Accept
    use Rack::Flash

    set :views, Proc.new { File.join( File.dirname( __FILE__ ), "views" ) }

    before do
      require_authentication if ENV['USERNAME'] && ENV['PASSWORD']
    end

    get '/api' do
      content_type :json

      {
        :collections => [:apps, :queues, :topics, :message_processors, :jobs, :services].inject({}) do |collections, collection|
          collections[collection] = json_url_for( collection_path( collection ) )
          collections
        end
      }.to_json
    end
    
    get '/' do
      redirect_to collection_path( :apps ) 
    end

    get '/css/style.css' do
      sass :'css/style'
    end

    get '/css/html5reset.css' do
      sass :'css/html5reset'
    end

  end
end
