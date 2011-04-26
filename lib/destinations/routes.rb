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
    resource :queue, :topic, :view_path => :destinations, :actions => [:pause, :resume]

    get "/queue/:name/messages" do
      @destination = Queue.find( Util.decode_name( params[:name] ) )
      if html_requested?
        haml :'messages/index'
      else
        content_type :json
        collection_to_json( @destination.entries )
      end
    end

    get "/queue/:name/message/:id" do
      @destination = Queue.find( Util.decode_name( params[:name] ) )
      @object = @destination.find { |m| m.jms_id == Util.decode_name( params[:id] ) }
      if html_requested?
        haml :'messages/show'
      else
        object_to_json( @object )
      end
    end

    # we can't implement move until we figure out how to get the
    # actual HQ internal message id on the client side
    # post "/queue/:name/message/:id/move" do
    #   @destination = Queue.find( Util.decode_name( params[:name] ) )
    #   @destination.mbean.move_message( params[:id], params[:queue])
    #   if html_requested?
    #     haml :'messages/show'
    #   else
    #     object_to_json( @destination )
    #   end
    # end

  end
end

