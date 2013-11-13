module Console
	@@command_table += [
		{ command: 'clear',					method: :con_clear_route,			mode: [ :"route-edit" ],	visible: true,
			description: 'Deletes every rule from the current route',
			help: '' },
		{ command: 'create route <name>',	method: :con_create_route,			mode: [ :router ],			visible: true,
			description: 'Creates a new route and appends it to the end of the routing table',
			help: '' },
		{ command: 'delete route <name>',	method: :con_delete_route,			mode: [ :router ],			visible: true,
			description: 'Deletes the specified route',
			help: '' },
		{ command: 'disable',				method: :con_disable_route,			mode: [ :"route-edit" ],	visible: true,
			description: 'Disables the current route',
			help: '' },
		{ command: 'do <action> <args>',	method: :con_route_set_action,		mode: [ :"route-edit" ],	visible: true,
			description: 'Assigns the specified action to the current route',
			help: '' },
		{ command: 'edit route <name>',		method: :con_edit_route,			mode: [ :router ],			visible: true,
			description: 'Enables route definition mode',
			help: "eg.:\n" +
				  "match scon con01\n" + 
				  "match dchan #chan\n" +
				  "do push target:con02;channel:#chan\n" },
		{ command: 'enable',				method: :con_enable_route,			mode: [ :"route-edit" ],	visible: true,
			description: 'Enables the current route',
			help: '' },
		{ command: 'fetch <id>',			method: :con_fetch_message,			mode: [ :router ],			visible: true,
			description: 'Displays the message with the given id',
			help: '' },
		{ command: 'flush',					method: :con_flush,					mode: [ :router ],			visible: true,
			description: 'Erases all items from the recycle bin and sends out every waiting message',
			help: '' },
		{ command: 'list',					method: :con_list_messages,			mode: [ :router ],			visible: true,
			description: 'Returns a list of queued messages',
			help: '' },
		{ command: 'match <type> <value>',	method: :con_route_match,			mode: [ :"route-edit" ],	visible: true,
			description: 'Defines a new matching rule for the current route',
			help: '' },
		{ command: 'move action <id> to <pos>',	method: :con_move_action,		mode: [ :"route-edit" ],	visible: true,
			description: 'Moves the specified action to a new position',
			help: '' },
		{ command: 'purge',					method: :con_purge_messages,		mode: [ :router ],			visible: true,
			description: 'Deletes every queued message',
			help: '' },
		{ command: 'pull action <action>',	method: :con_pull_action,			mode: [ :"route-edit" ],	visible: true,
			description: 'Moves the selected action one step down in the list',
			help: '' },
		{ command: 'push action <action>',	method: :con_push_action,			mode: [ :"route-edit" ],	visible: true,
			description: 'Moves the selected action one step down in the list',
			help: '' },
		{ command: 'reroute all',			method: :con_reroute_all,			mode: [ :router ],			visible: true,
			description: 'Clears the recycle bin and puts every message found in it into the inbound queue',
			help: '' },
		{ command: 'router',	method: :con_router,							mode: [ :'config-term' ],	visible: true,
			description: 'Enables router configuration mode',
			help: '' },
		{ command: 'show queues',			method: :con_show_queues,			mode: [ :router ],			visible: true,
			description: 'Shows statistics about the message queues',
			help: '' },
		{ command: 'show recycle bin',		method: :con_show_recycle_bin,		mode: [ :router ],			visible: true,
			description: 'Show items in recycle bin',
			help: '' },
		{ command: 'simulate <id>',			method: :con_simulate_route,		mode: [ :router ],			visible: true,
			description: 'Simulates the routing process for the specific message',
			help: '' },
		{ command: 'show actions',			method: :con_show_actions,			mode: [ :"route-edit" ],	visible: true,
			description: 'Shows the list of actions assigned to the current route',
			help: '' },
		{ command: 'show message history',					method: :con_show_msg_history,		mode: [ :router ],			visible: false,
			description: 'Shows all messages (limit and offset are optional)',
			help: '' },
		{ command: 'show message history <limit>',			method: :con_show_msg_history,		mode: [ :router ],			visible: false,
			description: 'Shows all messages (limit and offset are optional)',
			help: '' },
		{ command: 'show message history <limit> <offset>',	method: :con_show_msg_history,		mode: [ :router ],			visible: true,
			description: 'Shows all messages (limit and offset are optional)',
			help: '' },
		{ command: 'show routes',			method: :con_show_routes,			mode: [ :router, :"route-edit" ],	visible: true,
			description: 'Shows the routing table containing routing rules and filters',
			help: '' },
		{ command: 'unmatch <type> <value>', method: :con_route_unmatch,		mode: [ :"route-edit" ],	visible: true,
			description: 'Removes a matching rule from the current route',
			help: '' },
		{ command: 'undo <action>', method: :con_route_unset_action,			mode: [ :"route-edit" ],	visible: true,
			description: 'Deassigns the specified action from the current route',
			help: '' },
	]

	def con_router(input, args)
		console_mode :router
	end

	def con_clear_route(input, args)
		route = @routing_table.find { |rc| rc.name == args[:name] }

		route.clear
		
		puts "Route cleared"
	end

	def con_create_route(input, args)
		if @routing_table.find { |route| route.name == args[:name] }.nil?
			route = Route.new(args[:name])

			add_route route, 1
		else
			puts "A route with the same name already exists"
		end
	end

	def con_delete_route(input, args)
		@routing_table.find_all { |route| route.name == args[:name] }.each do |route|
			remove_route route
		end
	end

	def con_disable_route(input, args)
		@routing_table.find_all { |route| route.name == @context_arg }.each { |route| route.enabled = false }
	end

	def con_edit_route(input, args)
		if @routing_table.find { |route| route.name == args[:name] }.nil?
			puts "No routes exist with the specified name (#{args[:name]})"
		else
			console_mode "route-edit #{args[:name]}".to_sym
		end
	end

	def con_enable_route(input, args)
		@routing_table.find_all { |route| route.name == @context_arg }.each { |route| route.enabled = true }
	end

	def con_fetch_message(input, args)
		id = args[:id].to_i

		messages = @message_pool.find_all { |message| message.id == id }

		if (messages.length == 0)
			puts "No message exists with id ##{id}"
		else
			puts "                 ID: #{messages[0].id}"
			puts "           Priority: #{messages[0].priority}"
			puts "  Source connectors: #{messages[0].source_connector.to_s}"
			puts "     Source channel: #{messages[0].source_channel.to_s}"
			puts "             Source: #{messages[0].source.to_s}"
			puts "        Destination: #{messages[0].destination.to_s}"
			puts "Destination channel: #{messages[0].destination_channel.to_s}"
			puts "          Route log: #{messages[0].route_log[0].to_s}"
			messages[0].route_log[1..-1].each do |text|
				puts "                     #{text}"
			end
			puts "            Content: #{messages[0].content}"
		end
	end
	
	def con_flush(input, args)
		count = @recycle_bin.length

		@recycle_bin.clear

		puts "#{count} items flushed"
	end

	def con_list_messages(input, args)
		table = Table.new('d', '-s', '-s', '-s', '-s', 'd', '-s')
		table.set_header('id', 'sconn', 'schan', 'src', 'dst', 'pri', 'content')

		list = Array.new

		@waiting_queues.each do |priority|
			priority.each do |target, queue|
				queue.each do |message|
					list << message
				end
			end
		end

		list.sort_by { |e| e.id }.each do |message|
			table.add_row(message.id, message.source_connector, message.source_channel, message.source, message.destination, message.priority, message.content[0..32])
		end

		table.print
	end

	def con_show_msg_history(input, args)
		limit = args[:limit].to_i
		offset = args[:offset].to_i
		
		table = Table.new('d', '-s', '-s', '-s', '-s', 'd', '-s')
		table.set_header('id', 'sconn', 'schan', 'src', 'dst', 'pri', 'content')
		table.show_total = true

		@message_pool.each_with_index do |message, i|
			if (i >= offset)
				if i < limit + offset or (limit == 0 and offset == 0)
					table.add_row(message.id, message.source_connector, message.source_channel, message.source, message.destination, message.priority, message.content[0..32])
				end
			end
		end

		table.print
	end

	# ====================== Action moving ===========================

	def con_pull_action(input, args)
		route = @routing_table.find { |r| r.name == @context_arg }

		id = args[:action].to_i
		action = route.actions[id]

		if id >= 1
			route.actions.insert(id - 1, action)
			route.actions.delete_at(id + 1)
		end
	end

	def con_push_action(input, args)
		route = @routing_table.find { |r| r.name == @context_arg }

		id = args[:action].to_i
		action = route.actions[id]
          
		if id < route.actions.length - 1
			route.actions.delete_at(id)
			route.actions.insert(id + 1, action)
		end
	end

	def con_move_action(input, args)
		route = @routing_table.find { |r| r.name == @context_arg }

		id = args[:id].to_i

		if (id < 0 or id >= route.actions.length)
			cputs "Invalid action id"
			return
		end

		action = route.actions[id]

		route.actions.delete action

		pos = args[:pos].to_i

		if (pos < 0)
			pos = 0
		elsif (pos >= route.actions.length)
			pos = -1
		end
			
		route.actions.insert(pos, action)
	end

	def con_purge_messages(input, args)
		i = 0
		@waiting_queues.each do |priority|
			priority.each do |target, queue|
				i += queue.length
				queue.clear
			end
		end

		puts "#{i} messages purged"
	end

	def con_reroute_all(input, args)
		reroute_all
	end
	
	def con_route_match(input, args)
		type = args[:type]

		route = @routing_table.find { |rc| rc.name == @context_arg }

		if type =~ /^sif$/i
			route.match_source_interface(args[:value])
		elsif type =~ /^scon[n]?$/i
			route.match_source_connector(args[:value])
		elsif type =~ /^src|source$/i
			route.match_source(args[:value])
		elsif type =~ /^dst|dest(ination)?$/i
			route.match_destination(args[:value])
		elsif type =~ /^pri|priority$/i
			route.match_priority(args[:value])
		elsif type =~ /^cont(ent)[s]?$/i
			route.match_content(args[:value])
		else 
			puts "Unknown criteria"
			return
		end
	end

	def con_route_unmatch(input, args)
		type = args[:type]

		route = @routing_table.find { |rc| rc.name == @context_arg }

		if type =~ /^sif$/i
			route.unmatch_source_interface(args[:value])
		elsif type =~ /^scon[n]?$/i
			route.unmatch_source_connector(args[:value])
		elsif type =~ /^src|source$/i
			route.unmatch_source(args[:value])
		elsif type =~ /^dst|dest(ination)?$/i
			route.unmatch_destination(args[:value])
		elsif type =~ /^pri|priority$/i
			route.unmatch_priority(args[:value])
		elsif type =~ /^cont(ent)[s]?$/i
			route.unmatch_content(args[:value])
		else 
			puts "Unknown criteria"
		end
	end

	def con_route_set_action(input, args)
		type = args[:action]
		
		route = @routing_table.find { |rc| rc.name == @context_arg }

		if ([Action::LOG, Action::PUSH, Action::PRIORIZE, Action::ENCRYPT, Action::HIDE ].member? type.to_sym)
			params = Hash.new
		
			args[:args].split(';').collect { |p1| p1.split(':') }.each { |p2| params[p2[0].to_sym] = p2[1] }
			
			action = Action.new(type.to_sym, params)

			route.add_action action
		else
			puts "Unknown action type (#{type})"
		end
	end

	def con_route_unset_action(input, args)
		type = args[:action]

		route = @routing_table.find { |rc| rc.name == @context_arg }
			
		params = Hash.new
		
		#args[:args].split(';').collect { |p1| p1.split(':') }.each { |p2| params[p2[0].to_sym] = p2[1] }

		actions = route.actions.find_all do |action|
			action.action == type.to_sym
		end

		i = 0

		actions.each do |action|
			route.remove_action action
			i += 1
		end

		puts "#{i} action(s) removed"
	end

	def con_show_actions(input, args)
		route = @routing_table.find { |r| r.name == @context_arg }

		table = Table.new('-d', '-s', '-s')

		route.actions.each_with_index do |action, i|
			puts "#{i} #{action.action.upcase}"
			action.args.each_with_index do |key, j|
				puts "  #{j} #{key[0].upcase}: #{key[1]}"
			end
		end
	end

	def con_show_queues(input, args)
		puts "  Inbound queue size: #{@inbound_queue.size}"
		puts "  Outbond queue size: #{@outbound_queue.size}"
		puts "  Recycle bin size: #{@recycle_bin.length}"

		ns = [ 'trash', 'low', 'normal', 'high', 'realtime' ]
		now = Time.now.to_i

		(1..3).each do |priority|
			last = @configuration.get("core.scheduler.last_#{ns[priority]}").to_i
			sleep = @configuration.get("core.scheduler.sleep_#{ns[priority]}").to_i

			msgs = @waiting_queues[priority].collect { |target, queue| queue }.flatten.length

			if msgs > 0
				puts "    Level #{priority} queue (next check in #{last + sleep - now} seconds):"
				
				@waiting_queues[priority].each do |target, queue|
					puts "      #{target.to_s} has #{queue.length} messages"
				end
			else
				puts "    Level #{priority} queue (next check in #{last + sleep - now} seconds) is empty"
			end
		end
	end

	def con_show_recycle_bin(input, args)
		puts "There are #{@recycle_bin.length} items in the recycle bin. Showing the first 10:"

		table = Table.new('d', '-s', '-s', '-s', '-s', '-s', '-s')
		table.set_header('id', 'sconn', 'source', 'date', 'dest', 'pri', 'excerpt')

		@recycle_bin[0..9].each do |item|
			table.add_row(item.id, item.source_connector.name, item.source, item.date.to_s, item.destination.to_s, item.priority, item.content.to_s[0...32])
		end

		table.print
	end

	def con_show_routes(input, args)
		route_table = Table.new('d', '-s', '-s', '-s', '-s', '-s')
		route_table.set_header('#', 'name', 'valid', 'enabled', 'filter', 'action')

		@routing_table.each_with_index do |route, i|
			filter = route_filters_str(route)
			actiondesc = route_actions_str(route)

			route_table.add_row(i, route.name, route.valid?.to_s, route.enabled?.to_s, filter, actiondesc)
		end

		route_table.print
	end

	def con_simulate_route(input, args)
		id = args[:id].to_i

	end

end

