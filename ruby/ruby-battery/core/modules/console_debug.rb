require 'irb'

module Console
	@@command_table += [
		{ command: 'configuration dump',	method: :con_config_dump,	mode: [ :debug ],	visible: true,
			description: 'Dumps the current configuration object to screen',
			help: '' },
		{ command: 'configuration export',	method: :con_config_export,	mode: [ :debug ],	visible: true,
			description: 'Exports the current configuration to file',
			help: '' },
		{ command: 'configuration import',	method: :con_config_import,	mode: [ :debug ],	visible: true,
			description: 'Imports the running configuration from file',
			help: '' },
		{ command: 'dump oid <oid>',	method: :con_dump_oid,			mode: [ :debug ],	visible: true,
			description: 'Dumps the object with the specified object id',
			help: '' },
		{ command: 'get <key>',			method: :con_get_config,		mode: [ :debug ],	visible: true,
			description: '',
			help: '' },
		{ command: 'irb',				method: :con_irb,				mode: [ :debug ],	visible: true,
			description: '',
			help: '' },
		{ command: 'reload',			method: :con_reload,			mode: [ :debug ],	visible: true,
			description: 'Reloads every core module',
			help: '' },
		{ command: 'reload interfaces',		method: :con_reload_interfaces,			mode: [ :debug ],	visible: true,
			description: 'Reloads every interface',
			help: '' },
		{ command: 'send oid <oid> <message>',	method: :con_send_oid,	mode: [ :debug ],	visible: true,
			description: 'Sends a message to the specified object (DANGEROUS)',
			help: '' },
		{ command: 'set <key> = <value>',	method: :con_set_config,		mode: [ :debug ],	visible: true,
			description: '',
			help: '' },
		{ command: 'show hooks',		method: :con_show_hooks,		mode: [ :debug ],	visible: true,
			description: 'Shows a list of registered hooks',
			help: '' },
		{ command: 'show modules',		method: :con_show_modules,		mode: [ :debug ],	visible: true,
			description: 'Shows a list of loaded modules',
			help: '' },
		{ command: 'show services',		method: :con_show_services,		mode: [ :debug ],	visible: true,
			description: 'Shows a list of running services',
			help: '' },
		{ command: 'start service <service>',	method: :con_start_service,	mode: [ :debug ],	visible: true,
			description: 'Starts the selected service',
			help: '' },
		{ command: 'stop service <service>',	method: :con_stop_service,	mode: [ :debug ],	visible: true,
			description: 'Stops the selected service',
			help: '' },
	]

	def con_config_dump(input, args, node = nil, level = 0)
		if (node.nil?)
			node = Configuration.get_instance.dump
		end

		node.each do |key, value|
			if (value.kind_of? Hash)
				printf "%s[%s]:\n", "  " * level, key
				con_config_dump(input, args, node[key], level + 1)
			else
				printf "%s%s = %s\n", "  " * level, key, value.to_s
			end
		end
	end

	def con_config_import(input, args)
		fb = @console_feedback
		@console_feedback = false
		
		config_import

		@console_feedback = fb
	end

	def con_config_export(input, args)
		config_export
	end

	def con_dump_oid(input, args)
		begin
			obj = ObjectSpace._id2ref args[:oid].to_i
			p obj
		rescue RangeError => exception
			puts "ObjectSpace message: #{exception.message}"
		end
	end

	def con_get_config(input, args)
		cputs "#{args[:key]} = #{@configuration.get(args[:key])}"
	end

	def con_set_config(input, args)
		@configuration.set(args[:key], args[:value])
		con_get_config(input, args)
	end

	def con_irb(input, args)
		IRB.start
	end

	def con_reload(input, args)
		load_modules
	end

	def con_reload_interfaces(input, args)
		reload_interfaces
	end

	def con_send_oid(input, args)
		obj = ObjectSpace._id2ref args[:oid].to_i
		begin
			cp obj.send(args[:message].to_sym)
		rescue NoMethodError => exception
			cputs "That object does not receive this message"
		end
	end

	def con_show_hooks(input, args)
		table = Table.new('-s', 'd', '-s')
		table.set_header('hook', 'count', 'ids')
		
		@hooks.sort.each do |hook, vector|
			table.add_row(hook, vector.to_a.length, vector.keys.join(', ')[0..64])
		end

		table.print
	end

	def con_show_modules(input, args)
		@loaded_modules.each do |mod|
			puts "  #{mod.to_s}"
		end
	end

	def con_show_services(input, args)
		table = Table.new('-s', '-s', 'd')
		table.set_header('service', 'state', 'oid')
		
		th = get_thread('core.router')
		table.add_row('router', (!th.nil? and th.alive?) ? 'running' : 'not running', th.object_id)
		th = get_thread('core.collector')
		table.add_row('collector', (!th.nil? and th.alive?) ? 'running' : 'not running', th.object_id)
		th = get_thread('core.delivery')
		table.add_row('delivery', (!th.nil? and th.alive?) ? 'running' : 'not running', th.object_id)

		table.print
	end

	def con_start_service(input, args)
		start_service(args[:service].to_sym)
	end
	
	def con_stop_service(input, args)
		stop_service(args[:service].to_sym)
	end
end

