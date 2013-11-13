require 'logger'

class BLogger < Logger

	attr_accessor :splitlevel

	def initialize(logdev, shift_age = 0, shift_size = 1048576)
		super(logdev, shift_age, shift_size)

		@splitlevel = @level
	end

	def debug(progname = nil, &block)
		add(DEBUG, nil, progname, &block)
		if (@splitlevel
	end

end
