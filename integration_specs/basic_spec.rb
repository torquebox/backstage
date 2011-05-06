require 'integration_specs/spec_helper'

describe 'a basic test' do
  
  deploy <<-END.gsub( /^ {4}/, '' )
    application:
      root: #{File.dirname( __FILE__ )}/..
      env: test
    web:
      context: /backstage-test
    ruby:
      version: #{RUBY_VERSION[0,3]}
  END

  it "should work" do
    visit "/backstage-test"
    
    page.should have_content( 'Dashboard' )
  end
end
