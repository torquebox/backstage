require 'spec_helper'

module Backstage

  describe '/api' do
    before(:each) do
      get '/api'
      @response = JSON.parse(last_response.body, :symbolize_names => true)
    end

    it "should work" do
      last_response.should be_ok
    end


    it "should be a hash" do
      @response.is_a?(Hash).should be_true
    end

    it "should contain a hash of collection urls" do
      collections = [:apps, :queues, :topics, :message_processors, :jobs, :services]
      @response[:collections].keys.should =~ collections
      collections.each do |collection|
        @response[:collections][collection].should =~ %r{^http://example.org/#{collection}\?format=json$}
      end
    end
  end

  %w{ app queue topic job message_processor service }.each do |resource|
    klass = "backstage/#{resource}".constantize
    describe resource do
      it "should have hash attributes beyond :resource" do
        klass.to_hash_attributes.size.should > 1
      end
      
      describe "/#{resource.pluralize}" do
        before(:each) do
          klass.stub(:all).and_return([resource_with_mock_mbean(klass)])
          get "/#{resource.pluralize}", :format => 'json'
          File.open("/tmp/result#{resource}#{rand}.html", 'w') { |f| f.write(last_response.body)}
          @response = JSON.parse(last_response.body, :symbolize_names => true)
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
          File.open("/tmp/result#{resource}#{rand}.html", 'w') { |f| f.write(last_response.body)}
          @response = JSON.parse(last_response.body, :symbolize_names => true)
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
end
