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

Backstage::Application.resource :pool


module Backstage
  class Application < Sinatra::Base
    
    post "/pool/:name/evaluate" do
      content_type :json

      object = Pool.find( Util.decode_name( params[:name] ) )
      script = params[:script] || ''
      response = { :script => script }
      begin
        result = object.evaluate( script )
        response[:result] = result
      rescue Exception => ex
        response[:exception] = ex
        response[:backtrace] = ex.backtrace
      end

      JSON.generate( response )
    end

  end
end
