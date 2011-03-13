require 'rack/test'
require 'backstage'
require 'json'

def app
  Backstage::Application
end

def resource_with_mock_mbean(klass)
  mock_mbean = mock('mbean')
  def mock_mbean.method_missing(method, *args, &block)
    method.to_s
  end
  resource = klass.new('mock_mbean', mock_mbean)
  resource.stub(:name).and_return('name')
  resource.stub(:app_name).and_return('app_name')
  resource.stub(:app).and_return(resource_with_mock_mbean(Backstage::App)) unless klass == Backstage::App
  resource
end

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
