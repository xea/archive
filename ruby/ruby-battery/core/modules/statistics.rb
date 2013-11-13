module Statistics
	def self.feature
		:statistics
	end

	def init_module
		@stats = Hash.new

		[ :received_messages, :commands_executed, :messages_priorized, :envelopes_created,
			:failed_deliveries, :delivered_envelopes, :health_checks ].each do |key|
			@stats[key] = 0
		end

		add_hook 'incoming_message', 'stats', lambda { |message| @stats[:received_messages] += 1 }
		add_hook 'execute_console_command', 'stats', lambda { |command| @stats[:commands_executed] += 1 }
		add_hook 'priorize_message', 'stats', lambda { |message| @stats[:messages_priorized] += 1 }
		add_hook 'create_envelope', 'stats', lambda { |envelope| @stats[:envelopes_created] += 1 }
		add_hook 'delivery_failed', 'stats', lambda { |envelope| @stats[:failed_deliveries] += 1 }
		add_hook 'delivery_done', 'stats', lambda { |envelope| @stats[:delivered_envelopes] += 1 }
		add_hook 'check_health', 'stats', lambda { |status| @stats[:health_checks] += 1 }
	end

	def current_uptime_str
		current_time = Time.now.to_i - @starting_time.to_i
		current_days = current_time / 86400 
		current_time -= current_days * 86400

		current_hours = current_time / 3600
		current_time -= current_hours * 3600

		current_minutes = current_time / 60
		current_time -= current_minutes * 60

		current_seconds = current_time % 60

		return "  Current uptime is #{current_days} days #{current_hours} hours #{current_minutes} minutes #{current_seconds} seconds"
	end

	def total_uptime_str
		current_time = Time.now.to_i - @starting_time.to_i
		total_uptime = @configuration.get('global.stats.totaluptime') + (Time.now.to_i - @starting_time.to_i)
		total_days = current_time / 86400 
		total_uptime -= total_days * 86400

		total_hours = total_uptime / 3600
		total_uptime -= total_hours * 3600

		total_minutes = total_uptime / 60
		total_uptime -= total_minutes * 60

		total_seconds = total_uptime % 60

		return "  Total uptime is #{total_days} days #{total_hours} hours #{total_minutes} minutes #{total_seconds} seconds"
	end

	def route_filters_str(route)
		filter = ""

		if (route.f_sifaces.length > 0)
			filter += "SIF( "
			route.f_sifaces.each do |cond|
				filter += "#{cond}; "
			end
			filter += ") "
		end

		if (route.f_sconns.length > 0)
			filter += "SCON( "
			route.f_sconns.each do |cond|
				filter += "#{cond}; "
			end
			filter += ") "
		end
			
		if (route.f_sources.length > 0)
			filter += "SRC( "
			route.f_sources.each do |cond|
				filter += "#{cond}; "
			end
			filter += ") "
		end
		
		if (route.f_destinations.length > 0)
			filter += "DST( "
			route.f_destinations.each do |cond|
				filter += "#{cond}; "
			end
			filter += ") "
		end

		if (route.f_priorities.length > 0)
			filter += "PRI( "
			route.f_priorities.each do |cond|
				filter += "#{cond}; "
			end
			filter += ") "
		end

		if (route.f_contents.length > 0)
			filter += "CONT( "
			route.f_contents.each do |cond|
				filter += "#{cond}; "
			end
			filter += ") "
		end

		filter
	end

	def route_actions_str(route)
		actiondesc = ""

		if (route.actions.length > 0)
			route.actions.each do |action|
				actiondesc += "#{action.action.to_s.upcase}( "
				if (action.args.length > 0)
					action.args.each do |key, value|
						actiondesc += "#{key}:#{value.to_s}; "
					end
				end
				actiondesc += ") "
			end
		end

		actiondesc
	end

	def statistics
		@stats[:features] = @features.length

		@stats
	end

end
