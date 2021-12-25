#!/usr/bin/ruby
###############################################################################
# Name        : clean_sample_docker.rb                                        #
# Author      : Abel Gancsos                                                  #
# Version     : v. 1.0.0.0                                                    #
# Description : Purges Docker images that are samples or not needed.          #
###############################################################################

class DockerCleaner
	attr_reader :debug; attr_reader :exclude_list; attr_reader :include_list;
	def initialize(params={})
		@exclude_list = []; @include_list = [];
		@debug = (params["--debug"] != nil and params["--debug"].to_i() > 0) ? true : false;
		if params["-f"] != nil then self.read_words_list(params["-f"], @include_list); end
		if params["-F"] != nil then self.read_words_list(params["-F"], @exclude_list); end
		@exclude_list = params["-e"] != nil ? params["-e"].split(",") : @exclude_list;
		@include_list = params["-i"] != nil ? params["-i"].split(",") : @include_list;
		puts("".ljust(80, "#"));
		puts("# Debug   : #{@debug}".ljust(79, " ") + "#");
		puts("# Exclude : #{@exclude_list}".ljust(79, " ") + "#");
		puts("# Include : #{@include_list}".ljust(79, " ") + "#");
		puts("".ljust(80, "#"));
	end
	def read_words_list(path, list)
		if File.exists?(path)
			if list == nil then list = () end
			File.open(path, "r") do |f| 
				f.each_line do [line] 
					list.append(line.trim()); 
				end 
			end
		end
	end
	def invoke()
		## Containers
		containers = `docker container ls -a`.split("\n");
        for container in containers
            comps = container.split(" ");
            if not @exclude_list.include?(comps[comps.length - 1]) and (@include_list.include?(comps[comps.length - 1]) or @include_list.length == 0)
                puts("Removing container: '#{comps[comps.length - 1]}'");
                if not @debug then puts(`docker container rm #{comps[0]}`); end
            end
        end

		## Images
		images = `docker image ls`.split("\n");
		for image in images
			comps = image.split(" ");
			if not @exclude_list.include?(comps[0]) and (@include_list.include?(comps[0]) or @include_list.length == 0)
				puts("Removing image: '#{comps[0]}'");
				if not @debug then puts(`docker image rm #{comps[2]}`); end
			end
		end
	end
end

params = {};
for i in 0..ARGV.length do params[ARGV[i]] = ARGV[i + 1] end;
session = DockerCleaner.new(params);
session.invoke();
