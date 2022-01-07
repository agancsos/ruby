#!/usr/bin/ruby
###############################################################################
# Name        : read_receipts.rb                                              #
# Author      : Abel Gancsos                                                  #
# Version     : v. 1.0.0.0                                                    #
# Description : Helps enable or disable read receipts on macOS.               #
###############################################################################

class ReceiptReader
	attr_reader :mode; attr_reader :email_address;
	def initialize(params={})
		@mode = params["-m"] != nil ? params["-m"] : "";
		@email_address = params["-e"] != nil ? params["-e"] : ""; 
	end 
	def invoke()
		if @mode == nil or @mode == "" then raise "Mode cannot be empty..."; end
		case (@mode)
			when "show"
				puts(`defaults read com.apple.mail UserHeaders`);
			when "enable"
				if @email_address == nil or @email_address == "" then raise "Email cannot be empty..."; end
				puts(`defaults write com.apple.mail UserHeaders '{"Disposition-Notification-To" = "#{@email_address}";}'`);
			when "disable"
				puts(`defaults delete com.apple.mail UserHeaders`);
		end
	end
end

params = {}
for i in 0..ARGV.length + 1 do params[ARGV[i]] = ARGV[i + 1]; end
session = ReceiptReader.new(params);
session.invoke();
