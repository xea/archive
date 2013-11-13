module ConfigPump
	def self.feature
		:"configuration pump"
	end

	def init_module
		add_hook 'post_start', 'configpump', lambda { 
			config_import
		}
		add_hook 'pre_stop', 'configpump', lambda { 
			config_export
		}
	end

	def generate_configuration
		config = []

		config << "/priv/debug/set global.nodename = \"#{@configuration.get('global.nodename')}\""

		config << "/priv/debug/set core.scheduler.sleep_high = #{@configuration.get('core.scheduler.sleep_high')}"
		config << "/priv/debug/set core.scheduler.sleep_normal = #{@configuration.get('core.scheduler.sleep_normal')}"
		config << "/priv/debug/set core.scheduler.sleep_low = #{@configuration.get('core.scheduler.sleep_low')}"

		@connectors.each do |name, connector|
			config << "/priv/config-term/create connector #{name}@#{connector.class::INTERFACE_NAME}"

			connector.channels.each do |channel_name, channel|
				config << "/priv/config-term/connector #{connector.name}/add channel \"#{channel.name}\""
				if channel.enabled?
					config << "/priv/config-term/connector #{connector.name}/enable channel \"#{channel.name}\""
				else
					config << "/priv/config-term/connector #{connector.name}/disable channel \"#{channel.name}\""
				end
			end

			connector.configuration.dump.each do |key, value|
				config << "/priv/config-term/connector #{connector.name}/set #{key} = \"#{value}\""
			end
		end

		@routing_table.each do |route|
			config << "/priv/config-term/router/create route \"#{route.name}\""

			route.f_sifaces.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match sif #{filter}" }
			route.f_difaces.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match dif #{filter}" }
			route.f_sconns.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match sconn #{filter}" }
			route.f_dconns.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match dconn #{filter}" }
			route.f_schans.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match schan #{filter}" }
			route.f_dchans.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match dchan #{filter}" }
			route.f_sources.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match source #{filter}" }
			route.f_priorities.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match priority #{filter}" }
			route.f_destinations.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match destination #{filter}" }
			route.f_contents.each { |filter| config << "/priv/config-term/router/route-edit #{route.name}/match content #{filter}" }

			route.actions.each do |action|
				args = action.args.collect { |key, value| "#{key}:#{value}" }.join(';')
				config << "/priv/config-term/router/route-edit #{route.name}/do #{action.action.to_s} #{args}"
			end

			if (route.enabled?)
				config << "/priv/config-term/router/route-edit #{route.name}/enable"
			else
				config << "/priv/config-term/router/route-edit #{route.name}/disable"
			end

		end

		@connectors.each do |name, connector|
			if (connector.state == Interface::STATE_ONLINE)
				config << "/priv/config-term/connector #{connector.name}/start"
			elsif (connector.state == Interface::STATE_SUSPENDED)
				config << "/priv/config-term/connector #{connector.name}/suspend"
			end
		end

		return config
	end

	def config_export
		@log.debug(:pump) { '[export]' }
		configuration = generate_configuration

		pumpfile = File.new('config.pump', 'w')

		configuration.each do |line|
			pumpfile.puts line
		end

		pumpfile.close
	end

	def config_import
		if (File.exists?('config.pump'))
			@log.debug(:pump) { '[import]' }
			cf = @console_feedback
			@console_feedback = false
			pumpfile = File.new('config.pump', 'r')

			i = 1
			pumpfile.each_line do |line|
				begin
					command = lookup_command line
					execute_command command unless command.nil?
				rescue Exception => e
					Util.handle_exception e
					@log.error(:pump) { "[import] at line #{i}: #{line}" }
				end
				i += 1
			end

			@console_feedback = cf
		else
			@log.warn(:pump) { '[import] not exists: config.pump' }
		end
	end
end
