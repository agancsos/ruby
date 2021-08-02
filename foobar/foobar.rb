#!/usr/bin/ruby
###############################################################################
# Name        : foobar.rb                                                     #
# Author      : Abel Gancsos                                                  #
# Version     : 1.0.0.0                                                       #
# Description : Just something I like to port to all languages                #
###############################################################################

class Foobar
    @max_foobar;
    def initialize(max)
        @max_foobar = max;
    end
    def invoke()
        for i in 1..@max_foobar
            print("#{String(i).rjust(10, "0")} ");
            if (i % 15 == 0)
                puts("FOOBAR");
            elsif (i % 2 == 0)
                puts("FOO");
            elsif (i % 3 == 0)
                puts("BAR");
            else
                puts("BARFOO");
            end
        end
    end
end

## main
max_foobar = ARGV[0] != nil ? ARGV[0] : 17;
session = Foobar::new(max_foobar);
session.invoke();
