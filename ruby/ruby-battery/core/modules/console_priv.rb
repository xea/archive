module Console
	@@command_table += [
		{ command: 'configure terminal',	method: :con_config_term,		mode: [ :priv ],	visible: true,
			description: 'Switches to terminal configuration mode',
			help: '' },
		{ command: 'debug',					method: :con_debug,				mode: [ :priv ],	visible: true,
			description: 'Switches to debug mode',
			help: '' },
		{ command: 'trace',					method: :con_trace,				mode: [ :priv ],	visible: true,
			description: 'Switches to trace mode',
			help: '' },
	]

	def con_config_term(input, args)
		console_mode :"config-term"
	end

	def con_debug(input, args)
		console_mode :debug
	end

	def con_trace(input, args)
		console_mode :trace
	end
end

