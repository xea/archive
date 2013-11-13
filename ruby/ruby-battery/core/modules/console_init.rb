module Console
	@@command_table += [
		{ command: 'enable',		method: :con_enable,		mode: [ :init ],	visible: true,
			description: 'Switches to privileged mode, enabling further options',
			help: '' },
		{ command: 'show version',	method: :con_show_version,	mode: [ :init ], visible: true,
			description: 'Shows software version and other information',
			help: '' },
	]

	def con_enable(input, args)
		console_mode :priv
	end
	
	def con_show_version(input, args)
		puts "#{Core::APPLICATION_LONG_NAME} v#{Core::API_MAJOR_VERSION}.#{Core::API_MINOR_VERSION}"
		puts "  System is running since #{@starting_time}"
		puts "  Features: #{@features.sort.join(', ')}"
		puts "  Current uptime is: #{current_uptime_str}"
		puts "  Total uptime is: #{total_uptime_str}"
		puts
	end
end

