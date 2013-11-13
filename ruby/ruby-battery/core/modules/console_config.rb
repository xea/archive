module Console
	@@command_table += [
		{ command: 'connector <name>',	method: :con_connector,		mode: [ :'config-term' ],	visible: true,
			description: 'Allows the user to configure the specified connector',
			help: '' },
		{ command: 'show running-configuration',	method: :con_show_runconf,	mode: [ :'config-term' ],	visible: true,
			description: 'Shows the running configuration',
			help: '' },
	]

	def con_connector(input, args)
		if (@connectors.has_key? args[:name].to_sym)
			console_mode :"connector #{args[:name]}"
		else
			cputs "No such connector exists"
		end
	end

	def con_show_runconf(input, args)
	end
end

