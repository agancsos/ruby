#!/usr/bin/ruby

require_relative("UnitTest.rb")

class DummyTest < UnitTest
	def initialize()
		@name = "DummyTest";
	end
	def on_invoke()
		puts "TOTALLY DUDE"
	end
	def invoke()
		super
	end
end
