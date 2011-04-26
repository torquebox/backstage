#
# Copyright 2011 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

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
require 'pools'
require 'apps'
require 'destinations'
require 'message_processors'
require 'jobs'
require 'logs'
require 'services'


Backstage.logger.warn "ENV['REQUIRE_AUTHENTICATION'] is not set, *disabling* authentication" unless ENV['REQUIRE_AUTHENTICATION'] 

module Backstage
  BACKSTAGE_VERSION = File.readlines( File.join( File.dirname( __FILE__ ), 'VERSION' ) ).first.strip
  TORQUEBOX_VERSION = File.readlines( File.join( File.dirname( __FILE__ ), 'TORQUEBOX_VERSION' ) ).first.strip

  class Application < Sinatra::Base
    enable :sessions
    use Rack::Accept
    use Rack::Flash
    use Rack::CommonLogger, Backstage.logger
    
    include Backstage::Authentication 

    set :views, Proc.new { File.join( File.dirname( __FILE__ ), "views" ) }
    
    before do
      require_authentication if ENV['REQUIRE_AUTHENTICATION']
    end

    get '/api' do
      content_type :json

      {
        :collections => [:pools, :apps, :queues, :topics, :message_processors, :jobs, :services, :logs].inject({}) do |collections, collection|
          collections[collection] = json_url_for( collection_path( collection ) )
          collections
        end
      }.to_json
    end
    
    get '/' do
      if html_requested?
        haml :'dashboard/index'
      else
        redirect_to '/url'
      end
    end

    get '/css/style.css' do
      sass :'css/style'
    end

    get '/css/html5reset.css' do
      sass :'css/html5reset'
    end

  end
end
