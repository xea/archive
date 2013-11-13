# The event log module provides functions to help logging system-wide or
# local events. 

module Eventlog
	def self.feature
		:"event log"
	end

	def init_module
		@eventlog = { system: [], error: []}

		add_hook('check_health', 'eventlog', lambda { |status|
			t = HealthTest.new

			t.fail_on((@eventlog[:system].find_all { |item| !item.kind_of? Event }.length > 0), "Event log contains garbage")

			status['Event log health'] = t
		})
	end

	# Registers a new event in the selected log channel
	# By default an event is categorized as a system event.

	def log_event(type = :system, event)
		if event.kind_of? Event
		end
	end
end

