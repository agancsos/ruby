#!/usr/bin/ruby
###############################################################################
# Name        : diagnostic_helper.rb                                          #
# Author      : Abel Gancsos                                                  #
# Version     : v. 1.0.0.0                                                    #
# Description : Small and quick fixes for Unix.                               #
###############################################################################

class DiagnsoticHelper
    attr_reader :operation; attr_reader :debug; attr_reader :platform
    def initialize(params={})
        @platform = RUBY_PLATFORM;
        @operation = params["--op"] == nil ? "test" : params["--op"];
        @debug = params["--debug"].to_i > 1 ? true : false;
    end
    def invoke()
        case @operation
            when "swapcycle"
                case @platform
                    when /darwin|sunos/
                        print("Command (#{@operation}) not supported on (#{@platform})...\n");
                    else
                        print `swapoff -a`;
                        sleep(30);
                        print `swapon -a`;
                end
            when "swapinfo"
                case @platform
                    when /darwin/
                        print `sysctl vm.swapusage`
                    when /sunos/
                        print `swap -l`;
                    else
                        print `free -m`;
                end
            else
                print("Operation not supported at this time (#{@operation})\n");
        end
    end
end

params = {};
for i in 0..ARGV.length
    params[ARGV[i]] = ARGV[i + 1];
end
session = DiagnsoticHelper::new(params);
session.invoke();
