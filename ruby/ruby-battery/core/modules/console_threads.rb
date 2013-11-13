module Console
	@@command_table += [
		{ command: 'show threads',	method: :con_show_threads,		mode: [ :debug ],	visible: true,
			description: 'Shows a list of registered threads',
			help: '' },
	]

	def con_show_threads(input, args)
		table = Table.new('-s', '-s', '-s', 'd')
		table.set_header('name', 'state', 'object', 'oid')
		
		threads.sort.each do |name, thread|
			table.add_row(name, thread.status.to_s, thread.to_s, thread.object_id)
		end

		table.print
	end
end

