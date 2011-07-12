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
require 'logger'
require 'util'
require 'authentication'
require 'sinatra/url_for'

module Backstage
  def self.jboss_log_dir
    java.lang.System.get_property( 'jboss.server.log.dir' )
  end

  def self.jboss_app_name
    App.find( "torquebox.apps:app=torquebox-backstage" ) ? 'torquebox-backstage' : 'backstage'
  end

  def self.logger
    return @logger if @logger
    
    # log to <jboss log dir>/torquebox/<RACK_ENV>.log if you can,
    # otherwise do <app dir>/log/<RACK_ENV>.log
    if Backstage.jboss_log_dir && File.directory?( Backstage.jboss_log_dir )
      log_dir = File.join( Backstage.jboss_log_dir, Backstage.jboss_app_name )
    else
      log_dir = File.join( File.dirname( __FILE__ ), '..', 'log' )
    end
    FileUtils.mkdir_p( log_dir )
    
    @logger = Logger.new( File.join( log_dir, "#{ENV['RACK_ENV']}.log" ) )
  end
  
  class Application < Sinatra::Base

    helpers do
      include Backstage::Authentication
      include Sinatra::UrlForHelper

      def json_url_for(fragment, options = { })
        options[:format] = 'json'
        url_for( fragment, :full, options )
      end

      def object_path(object)
        object_action_or_collection_path(*(object.association_chain << nil))
      end

      def object_action_or_collection_path(*objects)
        collection_or_action = objects.pop
        paths = []
        objects.each do |object|
          paths << "#{simple_class_name( object )}/#{Util.encode_name( object.full_name )}"
        end
        paths << collection_or_action if collection_or_action
        '/' + paths.join( '/' )
      end

      alias_method :object_action_path, :object_action_or_collection_path
      alias_method :collection_path, :object_action_or_collection_path

      def redirect_to(location)
        redirect url_for(location, :full)
      end

      def link_to(path, text, options = {})
        "<a href='#{url_for path}' class='#{options[:class]}'>#{text}</a>"
      end

      def paginate(total, limit = 100)
        offset = params[:offset].to_i || 0
        current_page = offset/limit
        last_page = (total.to_f/limit).ceil - 1
        
        window = 10
        if current_page < window/2
          window_start = 0
        elsif current_page > total - (window/2)
          window_start = total - (window/2)
        else
          window_start = current_page - (window/2)
        end
        window_end = window_start + window
        
        accum = ''
        accum << link_to( "#{request.path_info}?offset=#{offset - limit}&limit=#{limit}", '<<' ) if offset > 0
        (last_page + 1).times do |page|
          in_window = page >= window_start && page < window_end
          if in_window || (page + 1)%10 == 0 || page == 0 || page == last_page
            if page == current_page
              accum << %Q{<span class="current-page #{in_window ? 'in-window' : ''}">#{page + 1}</span>}
            else
              accum << link_to( "#{request.path_info}?offset=#{page * limit}&limit=#{limit}", page + 1,
                                :class => in_window ? 'in-window' : '' )
            end
          else
            #accum << '.' unless accum[-3,3] == '...'
          end
        end
        accum << link_to( "#{request.path_info}?offset=#{offset + limit}&limit=#{limit}", '>>' ) if offset + limit < total
        %Q{<div class="pagination">#{accum}</div>}
      end
      
      def data_row(name, value)
        dom_class = ['value']
        dom_class << 'status' << value.downcase if name.to_s.downcase == 'status' # hack
        "<tr class='data-row'><td class='label'>#{name}</td><td class='#{dom_class.join(' ')}'>#{value}</td></tr>"
      end

      def simple_class_name(object)
        object.class.name.split( "::" ).last.underscore
      end

      def truncate(text, length = 30)
        text.length > length ? text[0...length] + '...' : text
      end

      def class_for_body
        klass = request.path_info.split('/').reverse.select { |part| part =~ /^[A-Za-z_]*$/ }
        klass.empty? ? 'root' : klass
      end

      def action_button(object, action, text=nil)
        text ||= action.capitalize
        accum = <<-EOF
<form method="post" action="#{url_for object_action_path(object, action)}">
  <input type="submit" value="#{text}"/>
</form>
        EOF
      end

      def html_requested?
        params[:format] != 'json' && env['rack-accept.request'].media_type?( 'text/html' )
      end

      def collection_to_json( collection )
        JSON.generate( collection.collect { |object| object_to_hash( object ) } )
      end

      def object_to_json(object)
        JSON.generate( object_to_hash( object ) )
      end

      def object_to_hash(object)
        response = object.to_hash
        if object.respond_to?( :available_actions )
          response[:actions] = object.available_actions.inject({}) do |actions, action|
            actions[action] = json_url_for( object_action_path( response[:resource], action ) )
            actions
          end
        end
        
        response.each do |key, value|
          if value.kind_of?( Resource )
            response[key] = json_url_for( object_path( value ) )
          end
        end

        if object.respond_to?( :subcollections )
          object.subcollections.each do |collection|
            response[collection] = json_url_for( collection_path( object, collection ) )
          end
        end

        response
      end

      def human_size(size)
        if size > 1024
          size = size.to_f
          if size > 1024*1024
            size /= 1024*1024
            suffix = 'Mb'
          elsif size > 1024
            size /= 1024
            suffix = 'kb'
          end
          size = size.round( 2 )
        else
          suffix = 'b'
        end

        "#{size} #{suffix}"
      end

      def torquebox_version_info
        versions = []
        torquebox = JMX::MBeanServer.new[javax.management.ObjectName.new( 'torquebox:type=system' )]
        versions << ['Version', torquebox.version]
        versions << ['Build Number', torquebox.build_number]
        versions << ['Revision', torquebox.revision]
        versions
      end

      def hornetq_version_info
        versions = []
        hornetq = JMX::MBeanServer.new[javax.management.ObjectName.new( 'org.hornetq:module=Core,type=Server' )]
        versions << ['Version', hornetq.version]
        versions << ['Clustered', hornetq.clustered]
        versions
      end

      def jboss_version_info
        versions = []
        jboss = JMX::MBeanServer.new[javax.management.ObjectName.new( 'jboss.system:type=Server' )]
        versions << ['Version', jboss.version]
        versions
      end

      def infinispan_version_info
        versions = []
        infinispan = JMX::MBeanServer.new
        cm = nil     # JMX::MBeans::Org::Infinispan::Manager::DefaultCacheManager 

        infinispan.query_names( 'org.infinispan:component=CacheManager,name=*,type=CacheManager' ).collect {|name| cm = JMX::MBeanServer.new[ name ] }

        if cm
          versions << ['Version', cm.version ]
        else
          versions << ['Version', 'disabled']
        end
        versions
      end

      def hornetq_cluster_info
        info = []
        ccc = nil   # JMX::MBeans::Org::Hornetq::Core::Management::Impl::ClusterConnectionControlImpl
        hornetq = JMX::MBeanServer.new

        # find the name of the cluster connection control 
        hornetq.query_names( 'org.hornetq:module=Core,name=*,type=ClusterConnection,*' ).collect {|name| ccc = JMX::MBeanServer.new[ name ] }

        if ccc
          ccc.attributes.each do |attr| 
            info << [ attr, ccc[attr] ] unless ((attr == "StaticConnectorNamePairs") || (attr == "StaticConnectorNamePairsAsJSON"))
          end
        end
  
        if info.size == 0 
          info << ['Cluster', 'disabled']
        end
        info
      end

      #def jgroups_cluster_channels
      #  mux_channels = []
      #  jgroups = JMX::MBeanServer.new

        # find the name of the jgroups channels
      #  jgroups.query_names( 'jboss.jgroups:cluster=*,type=channel' ).collect {|name| mux_channels << JMX::MBeanServer.new[ name ] }
      #  mux_channels
      #end
    end
  end
end

class Object
  def blank?
    nil? or (respond_to?( :empty? ) and empty?)
  end
end

class String
  def classify
    if self =~ %r{/}
      split( '/' ).collect( &:classify ).join( '::' )
    elsif self =~ %r{_}
      split( '_' ).collect( &:classify ).join( '' )
    else
      capitalize
    end
  end

  def constantize
    eval( classify )
  end

  def underscore
    gsub(/([a-zA-Z])([A-Z])/, '\1_\2').downcase
  end

  def humanize
    split( '_' ).collect( &:capitalize ).join( ' ' )
  end

  #poor man's...
  def pluralize
    "#{self}s"
  end
end

class Logger
  alias_method :write, :<<
end
