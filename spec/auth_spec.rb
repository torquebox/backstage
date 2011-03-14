require 'spec_helper'

module Backstage
  describe 'with authentication enabled' do
    before(:each) do
      App.stub(:all).and_return([resource_with_mock_mbean(App)])
      ENV['USERNAME'] = 'blah'
      ENV['PASSWORD'] = 'pw'
    end
    
    it "allow access with proper credentials" do
      authorize 'blah', 'pw'
      get '/apps'
      last_response.should be_ok
    end

    it "should 401 w/o credentials" do
      get '/apps'
      last_response.status.should == 401
    end

    it "should 401 with invalid credentials" do
      authorize 'foo', 'bar'
      get '/apps'
      last_response.status.should == 401
    end

    after(:each) do
      ENV['USERNAME'] = nil
      ENV['PASSWORD'] = nil
    end
  end

  describe 'with authentication disabled' do
    before(:each) do
      App.stub(:all).and_return([resource_with_mock_mbean(App)])
      ENV['USERNAME'] = nil
      ENV['PASSWORD'] = nil
    end

    it "should allow access w/o credentials" do
      get '/apps'
      last_response.should be_ok
    end

    it "should allow access with credentials" do
      authorize 'blah', 'pwasfd'
      get '/apps'
      last_response.should be_ok
    end
  end
end

