#!/usr/bin/ruby
###############################################################################
# Name        : boot_creater.rb                                               #
# Author      : Abel Gancsos                                                  #
# Version     : v. 1.0.0.0                                                    #
# Description : Helps to create a bootable USB install driver..               #
###############################################################################

class BootCreater
    @image_path=nil;@dev_path=nil;@debug=nil;@iso=nil;
    def initialize(params={})
        @image_path = params["-i"] != nil ? params["-i"] : "";
        @dev_path   = params["-p"] != nil ? params["-p"] : "";
        @debug      = params["--debug"] != nil and params["--debug"].to_i > 0 ? true : false;
        @iso        = params["--iso"] != nil and params["--iso"].to_i > 0 ? true : false;
    end
    def invoke()
        raise "Dev path cannot be empty..." if @dev_path == "";
        raise "Image path cannot be empty and must exist..." if @image_path == "" or !File.exist?(@image_path);
        raise "Script must be ran as sudo..." if `whoami`.strip != "root";
        image_name = File.basename(@image_path).split(".")[0];
        image_size = (File.size("#{@image_path}/Contents/SharedSupport/SharedSupport.dmg") * 0.000001 / 1024 + 1).to_i;
        if (not @iso)
                puts("Building bootable USB");
                if (not @debug)
                    puts(`diskutil eraseDisk HFS+ "#{image_name}" #{@dev_path}`);
                    puts(`sudo "#{@image_path}/Contents/Resources/createinstallmedia" --volume "/Volume/#{image_name}"`);
                end
        else
            puts("Building bootable ISO");
            if (not @debug)
                puts(`hdiutil create -o "/tmp/#{image_name}" -size #{image_size} -volname #{image_name} -layout SPUD -fs HFS+J`);
                puts(`hdiutil attach "/tmp/#{image_name}.dmg" -noverify -mountpoint "/Volumes/#{image_name}"`);
                puts(`sudo "#{@image_path}/Contents/Resources/createinstallmedia" --volume "/Volume/#{image_name}" --nointeraction`);
                puts(`hdutil detach "/Volumes/#{image_name}"`);
                puts(`hdiutil convert "/tmp/#{image_name}.dmg" -format UDTO -o "/tmp/#{image_name}.iso"`);
                puts(`mv "/tmp/#{image_name}.iso.cdr" "/tmp/#{image_name}.iso"`);
            end
        end
    end
end

params = {};
for i in 0..ARGV.length do params[ARGV[i]] = ARGV[i + 1] end
session = BootCreater.new(params);
session.invoke();

