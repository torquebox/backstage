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

def parse_json_response
  JSON.parse(last_response.body, :symbolize_names => true)
rescue Exception => e
  puts "WARN: json parsing failed"
end

module Backstage

  describe '/api' do
    before(:each) do
      get '/api'
      @response = parse_json_response
    end

    it "should work" do
      last_response.should be_ok
    end


    it "should be a hash" do
      @response.is_a?(Hash).should be_true
    end

    it "should contain a hash of collection urls" do
      collections = [:apps, :queues, :topics, :message_processors, :jobs, :services, :pools, :logs, :caches, :groups]
      @response[:collections].keys.should =~ collections
      collections.each do |collection|
        @response[:collections][collection].should =~ %r{^http://example.org/#{collection}\?format=json$}
      end
    end

  end

  describe 'with authentication enabled' do
    before(:each) do
      ENV['REQUIRE_AUTHENTICATION'] = 'true'
      @authenticator = mock(:authenticator)
      TorqueBox::Authentication.stub(:[]).and_return(@authenticator)
    end

    it "api should work with authentication" do
      @authenticator.should_receive(:authenticate).with('blah', 'pw').and_return(true)
      authorize 'blah', 'pw'
      get '/api'
      last_response.should be_ok
    end

    it "should 401 w/o credentials" do
      get '/api'
      last_response.status.should == 401
    end

    it "should 401 with invalid credentials" do
      @authenticator.should_receive(:authenticate).with('foo', 'bar').and_return(false)
      authorize 'foo', 'bar'
      get '/api'
      last_response.status.should == 401
    end

    after(:each) do
      ENV['REQUIRE_AUTHENTICATION'] = nil
    end
  end

  %w{ app queue topic job message_processor service pool log cache group }.each do |resource|
    klass = "backstage/#{resource}".constantize
    describe resource do
      it "should have hash attributes beyond :resource" do
        klass.to_hash_attributes.size.should > 1
      end

      describe "/#{resource.pluralize}" do
        before(:each) do
          klass.stub(:all).and_return([resource_with_mock_mbean(klass)])
          get "/#{resource.pluralize}", :format => 'json'
          @response = parse_json_response
        end

        it "should work" do
          last_response.should be_ok
        end

        it "should be an array" do
          @response.is_a?(Array).should be_true
        end

        context "each item" do
          it "should include the resource" do
            @response.first[:resource].should =~ %r{/#{resource}/.*format=json$}
          end

          klass.to_hash_attributes.each do |attribute|
            it "should include #{attribute}" do
              @response.first[attribute].should_not be_nil
            end
          end
        end
      end

      describe "/#{resource}" do
        before(:each) do
          klass.stub(:find).and_return(resource_with_mock_mbean(klass))
          get "/#{resource}/somename", :format => 'json'
          @response = parse_json_response
        end

        it "should work" do
          last_response.should be_ok
        end

        it "should include the resource" do
          @response[:resource].should =~ %r{/#{resource}/.*format=json$}
        end

        klass.to_hash_attributes.each do |attribute|
          it "should include #{attribute}" do
            @response[attribute.to_sym].should_not be_nil
          end
        end
      end
    end
  end

  describe "/queue" do
    before(:each) do
      Queue.stub(:find).and_return(resource_with_mock_mbean(Queue))
      get "/queue/somename", :format => 'json'
      @response = parse_json_response
    end

    it "should include a link to its messages" do
      @response[:messages].should =~ %r{/queue/.*/messages.*format=json$}
    end
  end

end
