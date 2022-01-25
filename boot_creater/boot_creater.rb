#!/usr/bin/ruby
###############################################################################
# Name        : boot_creater.rb                                               #
# Author      : Abel Gancsos                                                  #
# Version     : v. 1.0.0.0                                                    #
# Description : Helps to create a bootable USB install driver..               #
###############################################################################

class BootCreater
    attr_accessor :image_path; attr_accessor :dev_path;@debug=nil;
    def initialize(params={})
        @image_path = params["-i"] != nil ? params["-i"] : "";
        @dev_path   = params["-p"] != nil ? params["-p"] : "";
        @debug      = params["--debug"] != nil and params["--debug"].to_i > 0 ? true : false;
    end
    def invoke()
        raise "Dev path cannot be empty..." if @dev_path == "";
        raise "Image path cannot be empty and must exist..." if @image_path == "" or !File.exist?(@image_path);
        raise "Script must be ran as sudo..." if `whoami`.strip != "root";
        image_name = File.basename(@image_path).split(".")[0];
        if (!@debug)
            puts(`diskutil eraseDisk HFS+ "#{image_name}" #{@dev_path}`);
            puts(`sudo "#{@image_path}/Contents/Resources/createinstallmedia" --volume "/Volume/#{image_name}"`);
        end
    end
end

params = {};
for i in 0..ARGV.length do params[ARGV[i]] = ARGV[i + 1] end
session = BootCreater.new(params);
session.invoke();
