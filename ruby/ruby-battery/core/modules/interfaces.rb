require 'core/interface'

module Interfaces
	def self.feature
	end

	def init_module
		register_hook('pre_register_interface')
		register_hook('post_register_interface')
		register_hook('pre_unregister_interface')
		register_hook('post_unregister_interface')

		add_hook('post_init', 'interfaces', lambda {
			reload_interfaces
		})
		add_hook('shutdown', 'interfaces', lambda {
			@interfaces.each do |name, interface|
				unregister_interface @interfaces[name]
			end
		})
		add_hook('check_health', 'interfaces', lambda { |status|
			t = HealthTest.new
			
			@interfaces.each do |name, interface|
				t.fail_on(!(interface.ancestors.member?(Interface)), "Invalid interface found: #{name}")
				t.fail_on(interface::API_MAJOR_VERSION != Core::API_MAJOR_VERSION, "Major API version error found in interface: #{name}")
				t.fail_on(interface::API_MINOR_VERSION != Core::API_MINOR_VERSION, "Minor API version error found in interface: #{name}")
			end

			status['Interface reference integrity'] = t
		})
	end

	def reload_interfaces
		if (Dir.exists? "connectors")
			Dir.foreach("connectors") do |file|
				if (file =~ /^(.*)\.rb$/i)
					load("connectors/#{file}")
					classname = Kernel.const_get("#{$1.to_s.capitalize}Connector")
					if @interfaces.has_value? classname
						unregister_interface(classname)
					end
					register_interface(classname)
				end
			end
		end
	end

	# Registers a new interface in the core. Only registered interfaces can be
	# instantiated as endpoint connectors. On success this operation returns the
	# registered symbol name

	def register_interface(interface)
		if (interface.nil? or !interface.ancestors.member? Interface)
			return @log.error(:core) { "[register interface] invalid interface: #{interface.to_s}" }
		end

		name = interface::INTERFACE_NAME

		if (@interfaces.has_key? name)
			return @log.error(:core) { "[register interface] duplicate interface: #{name}" }
		end

		if (interface::API_MAJOR_VERSION != Core::API_MAJOR_VERSION)
			return @log.error(:core) { "[register interface] major api version difference, #{name.to_s}: #{interface::API_MAJOR_VERSION}, core: #{Core::API_MAJOR_VERSION}" }
		elsif (interface::API_MINOR_VERSION != Core::API_MINOR_VERSION)
			@log.warn(:core) { "[register interface] minor api version difference, #{name.to_s}: #{interface::API_MINOR_VERSION}, core: #{Core::API_MINOR_VERSION}" }
		else
			@log.info(:core) { "[register interface] registered: #{name.to_s}" }
		end

		call_hook('pre_register_interface', interface)
	
		@interfaces[name.to_sym] = interface

		call_hook('post_register_interface', interface)

		return name.to_sym
	end

	# Unregisters the specified interface in the core thus shutting down the 
	# dependant connectors.

	def unregister_interface(object)
		interface = nil
		interface = object if object.kind_of? Class and object.ancestors.member? Interface
		interface = @interfaces[object.to_sym] if object.kind_of? String

		if (@interfaces.has_value? interface)
			# TODO: destruct affected routes
			call_hook('pre_unregister_interface', interface)
			
			@connectors.each do |conn_name, connector|
				stop_connector(conn_name) if connector.kind_of? interface and connector.state != Interface::STATE_OFFLINE
			end
			
			@interfaces.reject! { |name, int| int == interface }

			@log.info(:core) { "[unregister interface] unregistered: #{interface.to_s}" }

			call_hook('post_unregister_interface', interface)
		else
			@log.error(:core) { "[unregister interface] no such interface: #{object.to_s}" }
		end
	end
end
