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

