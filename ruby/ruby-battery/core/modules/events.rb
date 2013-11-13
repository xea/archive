module Events
	def self.feature
		:events
	end

	public
	def init_module
		@hooks = Hash.new
		@invalid_hook_calls = 0
		@static_hooks = false

		add_hook('check_health', 'events', lambda { |status| 
			status.assert_kind Hash

			t = HealthTest.new

			t.fail_on(!@hooks.kind_of?(Hash), "Invalid hook vector")
			t.fail_on(@invalid_hook_calls > 0, "#{@invalid_hook_calls} invalid hook calls are registered")

			@hooks.each do |name, hook|
				t.fail_on(!hook.kind_of?(Hash), "Hook #{name} is an invalid vector")
				t.fail_on((hook.find_all { |id, oproc| !oproc.kind_of?(Proc) }.length > 0), "Hook #{name} contains invalid procs")
			end

			status['events array health'] = t
		})

		register_hook('call_hook')
	end

	public
	def register_hook(event)
		event.assert_kind String, Symbol
		
		if !@hooks.has_key? event.to_s
			@hooks[event.to_s] = Hash.new
		end
	end

	public
	def call_hook(event, *args)
		if @hooks.has_key? event
			@hooks[event].each do |id, handler|
				begin
					call_hook('call_hook', event)
					handler.call(*args)
				rescue ArgumentError => exception
					Util.handle_exception(exception)
				end
			end
		else
			@hooks[event] = {}
			@invalid_hook_calls += 1 if @static_hooks
			@log.debug(:events) { "Non-existant hook: #{event}" }
		end
	end

	public
	def add_hook(event, id, handler)
		if (event.kind_of? String or event.kind_of? Symbol) and handler.kind_of? Proc
			if event.to_s =~ /^[a-z_.0-9-]+$/i and id.to_s =~ /^[a-z_.0-9-]+$/i
				if !@hooks.has_key? event.to_s
					register_hook(event.to_s)
				end

				@hooks[event.to_s][id.to_s] = handler 
			end
		end
	end

	public
	def remove_hook(event, id)
		if (event.kind_of? String or event.kind_of? Symbol) and handler.kind_of? Proc
			if event.to_s =~ /^[a-z.0-9-]+$/i and id.to_s =~ /^[a-z_.0-9-]+$/i
				if @hooks.has_key? event.to_s
					@hooks[event.to_s].delete id.to_s
				end
			end
		end
	end

	public
	def hooks
		@hooks.keys
	end
end

class Event < Exception
end

class ShutdownEvent < Event
end
