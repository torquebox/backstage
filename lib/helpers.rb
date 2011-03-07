require 'util'

module Backstage
  class Application < Sinatra::Base
    helpers do
      def home_path
        request.script_name
      end

      def object_path(*objects)
        paths = []
        objects.each do |object|
          paths << "#{simple_class_name( object )}/#{Util.encode_name( object.full_name )}"
        end
        path_to( paths.join( '/' ) )
      end

      def object_action_path(*objects)
        action = objects.pop
        paths = []
        objects.each do |object|
          paths << "#{simple_class_name( object )}/#{Util.encode_name( object.full_name )}"
        end
        paths << action
        path_to( paths.join( '/' ) )
      end

      def collection_path(*objects)
        collection = objects.pop
        paths = []
        objects.each do |object|
          paths << "#{simple_class_name( object )}/#{Util.encode_name( object.full_name )}"
        end
        paths << collection
        path_to( paths.join( '/' ) )
      end

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
end
