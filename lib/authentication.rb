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

require 'torquebox'
require 'torquebox-security'

module Backstage
  module Authentication

    def auth
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
    end

    def unauthorized!(realm=request.host)
      headers 'WWW-Authenticate' => %(Basic realm="#{realm}")
      throw :halt, [ 401, 'Authentication Required' ]
    end

    def bad_request!
      throw :halt, [ 400, 'Bad Request' ]
    end
    
    def login_path
      "#{request.script_name}/login"
    end

    def authenticated?
      !request.env['REMOTE_USER'].nil?
    end
   
    def authenticate(username, password)
      return false if username.nil? || password.nil?
      authenticator = TorqueBox::Authentication['backstage']
      authenticator.authenticate(username, password)
    end

    def skip_authentication
      request.env['SKIP_AUTH'] = true
    end
   
    def require_authentication
      return if request.env['SKIP_AUTH']
      return if authenticated?
      unauthorized! unless auth.provided?
      bad_request! unless auth.basic?
      unauthorized! unless authenticate(*auth.credentials)
      request.env['REMOTE_USER'] = auth.username
    end

  end
end
