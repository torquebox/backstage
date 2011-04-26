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

  describe 'Log' do
    describe ".all" do
      it "should default to the jboss.server.log.dir if no log_dir provided" do
        java.lang.System.should_receive( :get_property ).with( 'jboss.server.log.dir' ).and_return( File.join( TEST_ROOT, 'data', 'jbosslogs' ) )
        logs = Log.all
        logs.collect( &:name ).should =~ ['boot.log', 'error.log']
      end

      it "should use the log_dir provided" do
        logs = Log.all( File.join( TEST_ROOT, 'data', 'railsapp', 'log' ) )
        logs.collect( &:name ).should =~ ['development.log', 'production.log']
      end

      it "should return [] if no logs found" do
        Log.all( 'asdfasdf' ).should == []
      end
    end

    describe "#tail" do
      
    end

    describe "#size" do
      it "should return the file size" do
        log_file = File.join( TEST_ROOT, 'data', 'jbosslogs', 'boot.log' )
        log = Log.new( log_file )
        log.size.should == File.size( log_file )
      end
    end

    
  end
end
