#!/usr/bin/ruby
require "time";

class VBoxPurge
    @vboxPath
    @limit
    def initialize(path, duration)
        @vboxPath = path;
        @limit = duration;
    end
    def invoke()
        if @path == ""
            raise "Path cannot be empty...";
        end
        output = `#@vboxPath list vms`;
        for vm in output.split("\n")
            comps = vm.split(" ");
            vmName = comps[0];
            purged = 0
            puts("> Checking snapshots for: #{vmName}");
            output = `#@vboxPath snapshot #{vmName} list --machinereadable`;
            if output.split("\n").length < @limit
                puts("Not enough snapshots to purge.  Bailing...");
                next;
            end;
            for snapshot in output.split("\n")
                if purged < @limit - 1 &&  snapshot.include?("SnapshotName=")
                    puts(">> Snapshot: #{snapshot}");
                    comps =  snapshot.split("=");
                    snapshotName = comps[1];
                    snapshotInfo = `#@vboxPath snapshot #{vmName} showvminfo #{snapshotName}`;
                    output = `#@vboxPath snapshot #{vmName} delete #{snapshotName}`;
                    purged += 1;
                end
            end
        end
    end
end


path = "VBoxManage";
duration = 20;
for i in 0..ARGV.length
    if ARGV[i] == "-p"
        path = ARGV[i + 1];
    elsif ARGV[i] == "-d"
        duration = ARGV[i + 1];
    end
end

session = VBoxPurge.new(path, duration);
session.invoke();
