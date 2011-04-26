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
    def self.resource(*resources)
      options = resources.pop if resources.last.is_a?(Hash)
      options ||= {}
      resources.each do |resource|
        resource = resource.to_s
        klass = "backstage/#{resource}".constantize
        view_path = options[:view_path] || resource.pluralize
        get "/#{resource.pluralize}" do
          @collection = klass.all
          if html_requested?
            haml :"#{view_path}/index"
          else
            content_type :json
            collection_to_json( @collection )
          end
        end

        get "/#{resource}/:name" do
          @object = klass.find( Util.decode_name( params[:name] ) )
          if html_requested?
            haml :"#{view_path}/show"
          else
            content_type :json
            object_to_json( @object )
          end
        end

        (options[:actions] || []).each do |action|
          post "/#{resource}/:name/#{action}" do
            object = klass.find( Util.decode_name( params[:name] ) )
            send_args = [action]
            send_args << params if object.respond_to?( action ) && object.method( action ).arity == 1
            action_response = object.__send__( *send_args )
            if html_requested?
              flash[:notice] = "'#{action}' called on #{simple_class_name( object ).humanize} #{object.name}"
              redirect_to object_path( object )
            else
              content_type :json
              object_to_json( action_response )
            end
          end

        end
      end
    end
  end
end
