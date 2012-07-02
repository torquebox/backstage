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
require 'rack/accept'
require 'torquebox/webconsole'
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
require 'caches'
require 'groups'

Backstage.logger.warn "ENV['REQUIRE_AUTHENTICATION'] is not set, *disabling* authentication" unless ENV['REQUIRE_AUTHENTICATION'] 

module Backstage
  BACKSTAGE_VERSION = File.readlines( File.join( File.dirname( __FILE__ ), 'VERSION' ) ).first.strip
  TORQUEBOX_VERSION = File.readlines( File.join( File.dirname( __FILE__ ), 'TORQUEBOX_VERSION' ) ).first.strip

  class Application < Sinatra::Base
    use TorqueBox::Session::ServletStore
    use Rack::Accept
    use Rack::CommonLogger, Backstage.logger
    use Rack::Webconsole

    include Backstage::Authentication 

    set :views, Proc.new { File.join( File.dirname( __FILE__ ), "views" ) }

    COLLECTIONS = [
                   :apps,
                   :caches,
                   :groups,
                   :jobs,
                   :logs,
                   :message_processors,
                   :pools,
                   :queues,
                   :services,
                   :topics
                  ]
    
    before do
      require_authentication if ENV['REQUIRE_AUTHENTICATION']
    end

    get '/api' do
      content_type :json

      {
        :collections => COLLECTIONS.inject({}) do |collections, collection|
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
