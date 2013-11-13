module Health
	def self.feature
		:"on-line health checks"
	end

	def init_module
		@health_status = Hash.new
		@health_status['health'] = 100.0

		@exceptions = []

		add_hook 'pre_bootstrap', 'health', lambda {
			scan_health
			s, f, ps = global_health

			[ 10, 33, 50, 75, 100 ].each do |pp|
				if ps < pp 
					@log.warn(:health) { "[initial check] under #{pp}%" }
				end
			end
		}
		add_hook 'check_health', 'health', lambda { |status| }

		register_hook('register_health')
		call_hook('register_health')
	end

	def scan_health
		@health_status.clear

		@log.info(:health) { "[health scan]" }
		call_hook('check_health', @health_status)

		t = HealthTest.new

		@health_status.each { |key, value|
			t.fail_on(!key.kind_of?(String), "[#{key}] Record key is not a string")
			t.fail_on(!value.kind_of?(HealthTest), "[#{key}] Value is not a HealthTest object")
		}

		@health_status['Health table integrity'] = t

		@health_status
	end

	def global_health
		total_successes = 0
		total_failures = 0

		@health_status.each do |probe, test|
			total_successes += test.successes
			total_failures += test.failures
		end
		
		p = 100.0

		if total_successes + total_failures > 0
			p = total_successes * 100.0 / (total_successes + total_failures)
		end

		return [total_successes, total_failures, p]
	end

	public
	def register_exception(exception)
		@exceptions << exception
	end
end

class HealthTest
	attr_accessor :label, :successes, :failures, :weight
	attr_reader :errors

	def initialize(label = 'No label defined', weight = 1.0, s = 0, f = 0)
		@label = label
		@weight = weight
		@successes = s
		@failures = f
		@errors = []
	end
	
	def success
		@successes += 1
	end

	def failure(reason = nil)
		@failures += 1
		@errors << reason unless reason.nil?
	end

	def fail_on(condition, reason = nil)
		if (condition)
			failure(reason)
		else
			success
		end
	end
end
