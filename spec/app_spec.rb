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

  describe 'App' do
    before(:each) do
      @app = App.new("app", nil)
      @app_root_path = File.join( TEST_ROOT, 'app' )
      @app.stub( :root_path ).and_return( @app_root_path )
      @log = Log.new(nil)
    end

    describe "logs" do
      it "should call all on Log" do
        Log.should_receive(:all).with( File.join( @app_root_path, 'log' ) ).and_return([@log])
        @app.logs
      end

      it "should set the parent on each log" do
        Log.stub(:all).and_return([@log])
        @log.should_receive(:parent=).with(@app)
        @app.logs
      end
    end

    describe 'has_logs?' do
      before(:each) do
        @log_dir = File.join( @app_root_path, 'log' )
        @app.stub( :log_dir ).and_return( @log_dir )
      end
      it "should be true if a log/ dir exists" do
        File.should_receive(:directory?).with( @log_dir ).and_return( true )
        @app.has_logs?.should be_true
      end
      
      it "should not be true if a log/ dir does not exist" do
        File.should_receive(:directory?).with( @log_dir ).and_return( false )
        @app.has_logs?.should_not be_true
      end
      
    end
  end
end
