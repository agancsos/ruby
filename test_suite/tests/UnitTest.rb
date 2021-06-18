#!/usr/bin/ruby

## To inherit this class
## 1. Require it
## 2. Make sure that the module (file) name matches the class name
## 3. Add a child copy of invoke and call super (standard abstraction)
class UnitTest
	@name;
	def initialize()
	end
	def on_invoke()
		raise "Not Implemented"
	end
	def invoke()
		puts "Running: " + @name;
		self.on_invoke();
		return true;
		rescue
			return false;
	end
end
