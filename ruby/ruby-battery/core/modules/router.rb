load 'core/route.rb'

module Router
	def self.feature
		:"message routing"
	end

	def init_module
		register_hook('route_found')
		register_hook('priorize')
		add_hook 'pre_unregister_interface', 'router', lambda { |interface| recheck_routes }
		add_hook 'post_register_interface', 'router', lambda { |interface| recheck_routes }
		add_hook('check_health', 'router', lambda { |status|
			t = HealthTest.new

			@routing_table.each do |route|
				t.fail_on(route.nil?, "Nil route")
				t.fail_on(!route.valid?, "Invalid route: #{route.name}")
			end

			status['Route table integrity'] = t
		})
	end
	
	# Tries to find a proper destination and action for the given message. 
	# If no routes can be found then the message will land in the recycle bin.

	public
	def route(message)
		message.assert_kind Message

		if (!message.kind_of? Message)
			return false
		end

		handled = false

		@routing_table.find_all { |route| route.valid? and route.enabled? and route.match?(message) }.each do |route|
			handled = true

			message.ttl -= 1
			message.append_log(:router) { 'Route found' }
		
			call_hook('route_found', route)

			route.actions.each do |action|
				action.assert_not_nil

				case action.action
				when Action::LOG
					@msglog.info(message.source_connector) { "S#{message.id}@#{message.priority}!#{message.source_connector}/#{message.source_channel}:#{message.date}" }
					@msglog.info(message.source_connector) { "D#{message.id}!#{message.destination_connector}/#{message.destination_channel}:" }
					message.append_log(:router) { 'Logged' }
				when Action::PUSH
					destination = action.args[:dst] unless action.args[:dst].nil?
					dstchan = action.args[:channel]
					target = action.args[:target]

					message.destination = destination
					message.destination_channel = dstchan
					message.destination_connector = target.to_sym

					if (!target.nil?)
						case message.priority
						when Message::PRIORITY_REALTIME
							envelope = Envelope.new(message.destination_connector, [ message ])
							@outbound_queue.enq envelope
							message.append_log(:router) { 'Pushed into outbound queue (REALTIME)' }
						when Message::PRIORITY_LOW..Message::PRIORITY_HIGH
							if (@waiting_queues[message.priority].has_key? target.to_sym)
								@waiting_queues[message.priority][target.to_sym] << message
							else
								@waiting_queues[message.priority][target.to_sym] = [ message ]
							end

							message.append_log(:router) { 'Moved into waiting queue' }
						when Message::PRIORITY_TRASH
							@recycle_bin << message
							message.append_log(:router) { 'Moved into recycle bin (PRIORITY_TRASH)' }
						end
					end
				when Action::PRIORIZE
					message.priority = action.args[:priority].to_i
					message.append_log(:router) { "Priority changed to: #{message.priority}" }
					call_hook('priorize', message)
				when Action::ENCRYPT
				when Action::HIDE
					`java -jar lib/openstego/openstego.jar --embed -a lsb -mf lib/openstego/input.txt -cf \"lib\\openstego\\Wiki.png\" -sf lib/openstego/output.png -e -p lofasz`
				end
			end
		end

		if (!handled)
			@recycle_bin << message 
			message.append_log(:router) { "Moved into recycle bin for it could not be routed" }
		end
	end

		# Iterates over the routing table and checks for rules that are not usable and
	# disables them. 

	def recheck_routes
		@log.debug(:router) { "[recheck routes]" }
		@routing_table.each do |route|
			if (route_valid? route)
				route.valid = true
			else
				route.valid = false
			end
		end
	end

	# Tests a selected route to determine it's filter rules validity. Masked filters (*) 
	# are not tested.

	def route_valid?(route)
		route.assert_kind Route

		if (route.kind_of? Route)
			if (route.f_sifaces.reject { |sif| sif =~ /\*/ }.find_all { |sif| !@interfaces.has_key? sif }.length > 0)
				return false
			end
			
			if (route.f_difaces.reject { |dif| dif =~ /\*/ }.find_all { |dif| !@interfaces.has_key? dif }.length > 0)
				return false
			end

			return true
		end

		return false
	end

	def reroute_all
		total = 0

		messages = @recycle_bin.clone

		messages.each do |message|
			@recycle_bin.delete message
			message.append_log(:router) { "Rerouted" }
			@inbound_queue.enq message
			total += 1
		end

		messages.clear

		@log.info(:router) { "[reroute] #{total} messages rerouted" }
	end

	def add_route(route, position = 0)
		if route.kind_of? Route
			@routing_table << route 
			recheck_routes
		end
	end

	def remove_route(route)
		if route.kind_of? Route
			@routing_table.delete route
			recheck_routes
		end
	end

	# Flushes all queues making the contained messages to be sent out

	def flush
	end

end
