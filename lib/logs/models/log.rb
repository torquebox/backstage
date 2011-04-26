#
# Copyright 2011 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by loglicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Backstage
  class Log
    include Resource

    attr_reader :file_path

    LOG_GLOB = "*log"
    
    class << self
      def to_hash_attributes
        super + [:name, :file_path, :size]
      end

      def all(log_dir = nil)
        log_dir ||= Backstage.jboss_log_dir
        Dir.glob("#{log_dir}/#{LOG_GLOB}").collect do |path|
          Log.new( File.expand_path( path ) )
        end.sort_by(:name)
      end

      alias_method :find, :new
    end

    def initialize(file_path)
      @file_path = file_path
    end

    alias_method :full_name, :file_path

    def name
      File.basename( file_path )
    end

    def size
      File.size( file_path )
    end
    
    def tail(options)
      num_lines = (options['num_lines'] || 100).to_i
      offset = (options['offset'] || 0).to_i
      File.open(@file_path, 'r') do |file|
        # Set offset to the beginning or end of the file if
        # the value passed in is less than or greather than
        # the min/max allowed
        if offset.abs > file.stat.size
          offset = offset < 0 ? 0 : file.stat.size
        end

        if offset < 0
          file.seek(offset, IO::SEEK_END)
          file.readline # Advance to the next entire line
        else
          file.seek(offset)
        end
        lines = (1..num_lines).map do
          begin
            file.readline
          rescue EOFError => e
            nil
          end
        end
        offset = file.pos
        { :offset => offset, :lines => lines.compact }
      end
    end

  end
end

