require 'core/connector'

# Provides functionality for managing endpoint connectors. 
#
# Connector instantiation and registration happens here

module Connectors
	def self.feature
	end

	def init_module

		# When registering or re-registering an interface, previously defined and dependant 
		# connectors are started.
		
		add_hook('post_register_interface', 'connectors', lambda { |interface|
			@connectors.each do |name, connector|
				if connector.kind_of? interface and connector.enabled? and connector.state == Interface::STATE_OFFLINE
					@log.info(:connector) { '[ autoinit connector ]' }
					start_connector(name)
				end
			end
		})
		
		# When an interface is unregistered every depending connector is shut down
		
		add_hook('pre_unregister_interface', 'connectors', lambda { |interface|
			@connectors.each do |name, connector|
				if (connector.kind_of? interface)
					stop_connector name.to_s if connector.state != Interface::STATE_OFFLINE
				end
			end
		})

		# When a system-wide health check is performed every connector gets verified
		
		add_hook('check_health', 'router', lambda { |status| 
			status.assert_kind Hash

			t = HealthTest.new

			@connectors.each do |name, connector|
				t.fail_on((!name.kind_of?(String) and !name.kind_of?(Symbol)), "Connector identifier is invalid" )
				t.fail_on(!connector.kind_of?(Connector), "Connector object is not valid")
				t.fail_on(name.to_s != connector.name.to_s, "Connector id and name does not match")
				t.fail_on((connector.connected? and connector.state == Interface::STATE_OFFLINE), "Connector #{name} has an invalid state")
				t.fail_on((!connector.connected? and connector.state == Interface::STATE_ONLINE), "Connector #{name} has an invalid state")
				t.fail_on(@interfaces.find_all { |name, interface| connector.class == interface}.length == 0, "Connector #{name} derives from an invalid interface")

				connector.channels.each do |cname, channel|
					t.fail_on((![:on, :off].member?(channel.state)), "Channel #{cname} has an invalid state: #{channel.state.to_s}")
					t.fail_on((channel.state == :on and connector.state == Interface::STATE_OFFLINE), "Channel can't be online while connector is offline")
					t.fail_on(!channel.queue.kind_of?(Queue), "Channel #{cname} has an invalid queue object: #{channel.queue.to_s}")
				end
			end
			status['Connector object validity'] = t
		})
	end

	# Creates a new connector with the specified name, based on the given
	# interface

	def create_connector(name, interface_name)
		name.assert_kind String
		interface_name.assert_kind String, Symbol

		if (@interfaces.has_key? interface_name.to_s.to_sym)
			if (@connectors.has_key? name.to_sym)
				@log.error(:core) { "[create connector] already exists: #{name}" }
			else
				call_hook('pre_create_connector', name.to_sym)

				connector = @interfaces[interface_name.to_sym].new(name)
				connector.name = name
				connector.queue = @inbound_queue

				@connectors[name.to_sym] = connector

				loaded_connectors = @configuration.get('core.loaded_connectors')
				loaded_connectors.assert_kind Hash

				loaded_connectors[name.to_sym] = Hash.new
				loaded_connectors[name.to_sym][:interface] = interface_name.to_sym 
				loaded_connectors[name.to_sym][:state] = connector.state

				@configuration.set('core.loaded_connectors', loaded_connectors)

				@log.info(:core) { "[create connector] created: #{name}" }

				call_hook('post_create_connector', name.to_sym)

				return true
			end
		else
			@log.error(:core) { "[create connector] invalid interface: #{interface_name.to_s}" }
		end

		return false
	end

	# Deletes the specified connector if it was previously instantiated

	def delete_connector(name)
		name.assert_kind String, Symbol

		if (!@connectors.has_key? name.to_s.to_sym)
			return false
		end

		call_hook('pre_delete_connector', name.to_sym)

		if (@connectors[name.to_sym].state == Interface::STATE_ONLINE or
			@connectors[name.to_sym].state == Interface::STATE_SUSPENDED)
			@connectors[name.to_sym].stop
		end

		@connectors.delete name.to_sym
		
		loaded_connectors = @configuration.get('core.loaded_connectors')
		loaded_connectors.delete name.to_sym
		@configuration.set('core.loaded_connectors', loaded_connectors)
		
		@log.info(:core) { "[delete connector] deleted: #{name.to_s}" }

		call_hook('post_delete_connector', name.to_sym)

		return true
	end

	def start_connector(name)
		name.assert_kind String, Symbol

		if !@connectors[name.to_s.to_sym].nil?
			call_hook('pre_start_connector', name)

			connector_thread = Thread.new do 
				begin
					@connectors[name.to_sym].connect
				rescue Exception => e
					@log.error(name.to_sym) { '[start connector] unhandled exception: ' + e.message }
					Util.handle_exception(e)
				end
			end

			register_thread("connectors.#{name.to_sym}", connector_thread)
			
			@configuration.set("core.loaded_connectors.#{name.to_s}.state", @connectors[name.to_sym].state);
		
			@log.info(:core) { "[start connector] started: #{name.to_s}" }

			call_hook('post_start_connector', name)
		end
	end


	# Suspends the connector, preventing it from producing or sending messages

	def suspend_connector(name)
		name.assert_kind String, Symbol

		if (!@connectors.has_key? name.to_s.to_sym)
			return false
		end

		call_hook('pre_suspend_connector', name.to_sym)

		@connectors[name.to_sym].suspend
		@log.info(:core) { "[suspend connector] #{name.to_s}" }

		call_hook('post_suspend_connector', name.to_sym)
	end

	def stop_connector(name)
		name.assert_kind String, Symbol

		if @connectors.has_key? name.to_s.to_sym
			if (@connectors[name.to_s.to_sym].state != Interface::STATE_OFFLINE)
				call_hook('pre_stop_connector', name)

				sr = @connectors[name.to_s.to_sym].disconnect

				if (sr.kind_of? Numeric)
					sleep sr
				end

				thread = get_thread("connectors.#{name.to_s}")

				if (!thread.nil? and thread.alive?)
					thread.raise "stop"
					thread.join if thread.alive?
				end

				unregister_thread("connectors.#{name.to_s}")
			
				@configuration.set("core.loaded_connectors.#{name.to_s}.state", Interface::STATE_OFFLINE);

				@log.info(:core) { "[stop connector] stopped: #{name.to_s}" }

				call_hook('post_stop_connector', name)
			else
				@log.error(:core) { "[stop connector] offline: #{name.to_s}" }
			end
		end
			
	end
end
