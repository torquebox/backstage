require 'util'
require 'authentication'

module Backstage
  class Application < Sinatra::Base
    helpers do
      include Backstage::Authentication
      
      def home_path
        request.script_name
      end

      def object_path(*objects)
        object_action_or_collection_path(*(objects << nil))
      end

      def object_action_or_collection_path(*objects)
        collection_or_action = objects.pop
        paths = []
        objects.each do |object|
          paths << "#{simple_class_name( object )}/#{Util.encode_name( object.full_name )}"
        end
        paths << collection_or_action if collection_or_action
        path_to( paths.join( '/' ) )
      end
      alias_method :object_action_path, :object_action_or_collection_path
      alias_method :collection_path, :object_action_or_collection_path
      
      def path_to(location)
        "#{home_path}/#{location}"
      end

      def redirect_to(location)
        redirect path_to(location)
      end

      def link_to(path, text, options = {})
        "<a href='#{path}' class='#{options[:class]}'>#{text}</a>"
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
<form method="post" action="#{object_action_path(object, action)}">
  <input type="submit" value="#{text}"/>
</form>
        EOF
      end
    end
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
