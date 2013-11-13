module Console
	@@command_table += [
		{ command: 'register interface <interface>',	method: :con_register_interface,	mode: [ :'config-term' ],	visible: true,
			description: 'Loads the specified interface',
			help: '' },
		{ command: 'unregister interface <interface>',	method: :con_unregister_interface,	mode: [ :'config-term' ],	visible: true,
			description: 'Disables and unloads the specified interface, making all objects depending on it unavailable',
			help: '' },
		{ command: 'show interfaces',	method: :con_show_interfaces,	mode: [ :'config-term' ],	visible: true,
			description: 'Shows a list of registered interfaces',
			help: '' },
	]

	def con_register_interface(input, args)
		begin
			mod = Kernel.const_get(args[:interface])

			register_interface(mod)
		rescue NameError => exception
			puts "The specified interface does not exist"
		end
	end

	def con_unregister_interface(input, args)
		begin
			mod = Kernel.const_get(args[:interface])

			unregister_interface(mod)
		rescue NameError => exception
			unregister_interface(args[:interface])
		end
	end

	def con_show_interfaces(input, args)
		table = Table.new('-s','-s','-s', 'd')
		table.set_header('name', 'class', 'version', '#CONN')

		@interfaces.each do |name, interface|
			table.add_row(name, interface.to_s, "#{interface::API_MAJOR_VERSION}.#{interface::API_MINOR_VERSION}", @connectors.find_all {|n, c| c.kind_of? interface }.length)
		end

		table.print
	end

end

