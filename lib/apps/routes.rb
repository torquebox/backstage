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

module Backstage
  class Application < Sinatra::Base
    resource :app

    get "/app/:name/logs" do
      @parent = App.find( Util.decode_name( params[:name] ) )
      @collection = @parent.logs
      if html_requested?
        haml :'logs/index'
      else
        content_type :json
        collection_to_json( @collection )
      end
    end

     get "/app/:name/log/:id" do
      @parent = App.find( Util.decode_name( params[:name] ) )
      @object = Log.find( Util.decode_name( params[:id] ) )
      @object.parent = @parent
                          
      if html_requested?
        haml :'logs/show'
      else
        object_to_json( @object )
      end
    end

  end
end

