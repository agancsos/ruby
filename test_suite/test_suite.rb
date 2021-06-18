#!/usr/bin/ruby

def help_menu()
end

class TestSuite
	@tests;
	def initialize()
		@tests = [];
		self.load_tests();
	end
	def load_tests()
		classes = Dir.entries("./tests");
		for test in classes do
			if (test != ".." && test != "." && test != "UnitTest.rb") 
				require_relative("tests/" + test);
				temp_class = Object.const_get(test.gsub(".rb", ""))
				@tests.push(temp_class.new());
			end
		end 
	end
	def invoke(op, test_name)
		case op
		when "list" 
			for test in @tests do 
				puts test.instance_variable_get("@name");
			end
		when "run"
			if (test_name == "")
				raise "Test name cannot be empty...";
			end
			test;
			for cursor in @tests do
				if (cursor.instance_variable_get("@name") == test_name)
					test = cursor;
					break;
				end
			end
			test.invoke();
		else
			throw "Operation not supported at this time..."
		end
	end
end

if (ARGV.length == 0)
	help_menu();
else
	## Set defaults
	session = TestSuite.new();
	test_name = "";
	op = "";

	## Extract parameters
	for i in 0..ARGV.length
		case ARGV[i]
		when "--op"
			op = ARGV[i + 1];
		when "--test"
			test_name = ARGV[i + 1];
		end
	end

	## Invoke
	session.invoke(op, test_name);
end
exit(0);
