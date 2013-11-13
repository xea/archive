module Console
	@@command_table += [
		{ command: 'add channel <channel>',	method: :con_add_channel,	mode: [ :connector ],	visible: true,
			description: 'Adds a channel to the connectors channel list',
			help: '' },
		{ command: 'create connector <name>@<interface>',	method: :con_create_connector,	mode: [ :"config-term" ],	visible: true,
			description: 'Creates and initializes a new connector',
			help: '' },
		{ command: 'delete connector <name>',	method: :con_delete_connector,	mode: [ :"config-term" ],	visible: true,
			description: 'Disables and deletes the selected connector',
			help: '' },
		{ command: 'disable channel <channel>',	method: :con_disable_channel,	mode: [ :connector ],	visible: true,
			description: 'Disables joining the selected channel',
			help: '' },
		{ command: 'enable channel <channel>',	method: :con_enable_channel,	mode: [ :connector ],	visible: true,
			description: 'Enables joining the selected channel',
			help: '' },
		{ command: 'get', method: :con_conn_get_all,	mode: [ :connector ],	visible: false,
			description: '',
			help: '' },
		{ command: 'get <key>',	method: :con_conn_get,	mode: [ :connector ],	visible: true,
			description: 'Displays a connector specific configuration value',
			help: '' },
		{ command: 'remove channel <channel>',	method: :con_remove_channel,	mode: [ :connector ],	visible: true,
			description: 'Removes a channel from the connectors channel list',
			help: '' },
		{ command: 'set <key> = <value>',	method: :con_conn_set,	mode: [ :connector ],	visible: true,
			description: 'Sets a connector specific configuration value',
			help: '' },
		{ command: 'show channels',		method: :con_show_channels,		mode: [ :connector ],					visible: true,
			description: 'Shows a list of configured channels',
			help: '' },
		{ command: 'show connectors',	method: :con_show_connectors,	mode: [ :"config-term", :connector ],	visible: true,
			description: 'Shows a list of configured connectors',
			help: '' },
		{ command: 'start',	method: :con_start_connector,	mode: [ :connector ], visible: true,
			description: 'Starts the selected connector',
			help: '' },
		{ command: 'stop',	method: :con_stop_connector,	mode: [ :connector ],	visible: true,
			description: 'Stops the selected connector',
			help: '' },
		{ command: 'suspend',	method: :con_suspend_connector,	mode: [ :connector ],	visible: true,
			description: 'Suspends the selected connector',
			help: '' },
		{ command: 'synchronize',	method: :con_synchronize,	mode: [ :connector ],	visible: true,
			description: 'Synchronizes online and offline channels',
			help: '' },
	]

	def con_conn_get_all(input, args)
		@connectors[@context_arg.to_sym].configuration.dump.each do |ckey, value|
			printf "  %s = %s\n", ckey.to_s, value.to_s
		end
	end

	def con_conn_get(input, args)
		key = args[:key]
		connector_name = @context_arg

		if (key.nil?)
			@connectors[connector_name.to_sym].configuration.dump.each do |ckey, value|
				printf "  %s = %s\n", ckey.to_s, value.to_s
			end
		else
			printf "  %s = %s\n", key.to_s, @connectors[connector_name.to_sym].configuration.get(key.to_sym)
		end 
	end

	def con_conn_set(input, args)
		key = args[:key]
		value = args[:value]
		connector_name = @context_arg 
	
		connector = @connectors[connector_name.to_sym]
		connector.configuration.set(key.to_sym, value) 
	end

	def con_create_connector(input, args)
		create_connector(args[:name], args[:interface])
	end

	def con_delete_connector(input, args)
		delete_connector(args[:name])
	end

	def con_show_connectors(input, args)
		table = Table.new('-s', '-s', '-s', 'd')
		table.set_header('name', 'type', 'state', 'oid')

		@connectors.each do |name, connector|
			table.add_row(name, connector.class, connector.state.to_s, connector.object_id)
		end

		table.print
	end

	# (================ Connector control=======================)
	
	def con_start_connector(input, args)
		start_connector(@context_arg)
	end

	def con_stop_connector(input, args)
		stop_connector(@context_arg)
	end

	def con_suspend_connector(input, args)
		suspend_connector(@context_arg)
	end

	# (===================== Channels ===========================)

	def con_show_channels(input, args)
		table = Table.new('-s', '-s', '-s', '-s')
		table.set_header('name', 'state', 'enabled', 'info')

		connector = @connectors[@context_arg.to_sym]
		connector.channels.each do |name, channel|
			table.add_row(name, channel.state.to_s, channel.enabled? ? 'yes' : 'no', channel.infoline.to_s)
		end

		table.print
	end

	def con_add_channel(input, args)
		connector = @connectors[@context_arg.to_sym]

		if !connector.channels.has_key? args[:channel]
			connector.add_channel args[:channel]
		else
			cputs "Channel is already in the channels list"
		end
	end

	def con_remove_channel(input, args)
		connector = @connectors[@context_arg.to_sym]

		connector.remove_channel args[:channel]
	end

	def con_synchronize(input, args)
		connector = @connectors[@context_arg.to_sym]

		connector.synchronize_channels
	end

	def con_disable_channel(input, args)
		channel_name = args[:channel].to_s
		connector = @connectors[@context_arg.to_sym]

		channel = connector.channels[channel_name]
		channel.disable
	end
	
	def con_enable_channel(input, args)
		channel_name = args[:channel].to_s
		connector = @connectors[@context_arg.to_sym]

		channel = connector.channels[channel_name]
		channel.enable
	end
end

