class Util
	def self.handle_exception(exception)
		if (!exception.kind_of? Exception)
			return false
		end

		exception.date = Time.now

		ef = File.new('log/exceptions.log', 'a')
		ef.puts "#{exception.date.to_s} #{exception.message}"
		ef.puts "  " + exception.backtrace.join("\n  ")
		
		begin
			if (Core.has_instance?)
				Core.get_instance.register_exception(exception)
			else
				ef.puts "Exception registration failed"
			end
		rescue Exception => e
			ef.puts "Exception registration failed"
		end
		ef.flush
		ef.close 

		puts "EXCEPTION THROWN:"
		puts "        Type: #{exception.class.to_s}"
		puts "     Message: #{exception.message}"
		puts "    Location: #{exception.backtrace[0]}"
		puts "          At: #{exception.backtrace[1].to_s}"
	end
end

class Exception
	attr_accessor :date
end

class Class

	# Serves as an annotation (currently used only for code formatting purposes)
	def override(symbol = nil)
	end

end

class AssertionException < Exception
	def initialize(msg = nil)
		super msg
	end
end

class Object
	def class_invariant
		true
	end

	def assertion_error_handler(reason)
		puts "--> ASSERTION Error: #{reason}"
	end

	def assert?(expression)
		if !expression
			begin
				raise AssertionException.new
			rescue AssertionException => e
				Util.handle_exception(e)
			end

			return false
		else
			return true
		end
	end

	def assert(expression, message = "true expression expected")
		assertion_error_handler message unless assert? expression
	end

	def assert!(expression, message = "true expression expected")
		raise AssertionException.new message unless assert? expression
	end

	def assert_kind(*mod)
		assertion_error_handler "#{self.to_s} expected to be kind of #{mod.to_s} instead is a #{self.class.to_s}" unless assert_kind?(*mod)
	end
	
	def assert_kind!(*mod)
		raise AssertionException.new "#{self.to_s} expected to be kind of #{mod.to_s} instead is a #{self.class.to_s}" unless assert_kind?(*mod)
	end

	def assert_kind?(*mod)
		find = mod.find do |type|
			self.kind_of? type
		end
		
		return assert?(!find.nil?)
	end

	def assert_not_nil(object = self)
		assertion_error_handler "#{object.to_s} not expected to be nil" unless assert_not_nil?(object)
	end
	
	def assert_not_nil!(object = self)
		raise AssertionException.new "#{object.to_s} not expected to be nil" unless assert_not_nil?(object)
	end

	def assert_not_nil?(object = self)
		return assert?(!object.nil?)
	end

	def assert_false(object = self)
		assertion_error_handler "#{object.to_s} is expected to be false" unless assert_false?(object)
	end

	def assert_false!(object = self)
		raise AssertionException.new "#{object.to_s} is expected to be false" unless assert_false?(object)
	end

	def assert_false?(object = self)
		return assert?(object == false)
	end
end
