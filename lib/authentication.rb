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
   
    def authenticated?
      !request.env['REMOTE_USER'].nil?
    end
   
    def authenticate(username, password)
      (ENV['USERNAME'] == username) && 
        (ENV['PASSWORD'] == password)
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
