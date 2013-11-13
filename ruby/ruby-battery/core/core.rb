require 'time'
require 'logger'
require 'set'
require 'thread'
require 'core/util'
require 'core/configuration'

# A minimal core implementation. It controls the application lifecycle, manages 
# system services

class Core

	APPLICATION_SHORT_NAME = "Battery"
	APPLICATION_LONG_NAME = "Battery Message Gateway"

	API_MAJOR_VERSION = 3
	API_MINOR_VERSION = 1

	private_class_method :new

	# Holds the singleton instance

	@@instance = nil

	# Returns the singleton instance of the Core class

	public
	def self.get_instance
		@@instance = new unless @@instance
		@@instance.assert_kind Core
		@@instance
	end

	public
	def self.has_instance?
		!@@instance.nil?
	end

	private
	def initialize
		splash!

		@features = Set.new
		@starting_time = Time.now
		@configuration = Configuration.get_instance
		@log = Logger.new(STDOUT)
		@log.datetime_format = "%y-%m-%d %H:%M:%S"
		@msglog = Logger.new(STDOUT)
		@msglog.datetime_format = "%y-%m-%d %H:%M:%S"

		@interfaces = Hash.new
		@connectors = Hash.new

		@thread_registry = Hash.new
		@routing_table = Array.new
		@loaded_modules = Set.new
		@invariants = Hash.new 

		# Message queues
		@inbound_queue = Queue.new
		@waiting_queues = [ {}, {}, {}, {}, {} ] 
		@outbound_queue = Queue.new

		# @traced holds the expressions to be traced for the tracing functionality
		@traced = Array.new

		# @recycle_bin holds the disposed messages that are not needed (these can be truncated by the flush operation)
		@recycle_bin = Array.new

		# @undelivered_messages holds messages that are not considered as trash but could not be delivered for some reason
		@undelivered_messages = Array.new


		@log.debug(:core) { '[init]' }

		load_modules
		setup_hooks

		call_hook('pre_bootstrap')

		bootstrap

		call_hook('post_bootstrap')
		@log.debug(:core) { '[init] finished' }
		call_hook('post_init')
	end

	# Draws a pretty nice splash logo to the standard output :>

	private
	def splash!
		sf = File.new('core/splash', 'r')
		splash = sf.read
		sf.close

		puts splash
	end

	private
	def setup_hooks
		register_hook("pre_bootstrap")
		register_hook("post_bootstrap")
		register_hook("post_init")
		register_hook("signal_int")
		register_hook("signal_exit")
		register_hook("pre_start")
		register_hook("post_start")
		register_hook("pre_stop")
		register_hook("post_stop")
		register_hook("pre_rehash")
		register_hook("ppost_rehash")
		register_hook("pre_load_module")
		register_hook("post_load_module")
		register_hook("pre_extend_module")
		register_hook("post_extend_module")

		# When a health check is performed, the core checks its basic state. 
		
		add_hook 'check_health', 'core', lambda { |status|
			t = HealthTest.new

			t.fail_on(@features.nil?, 'Features array is not propery initialized')
			t.fail_on(@features.find_all { |item| !item.kind_of? Symbol }.length > 0, 'Garbage data detected in the features list')
			t.fail_on((@starting_time.nil? or !@starting_time.kind_of? Time), 'Starting time is invalid')
			t.fail_on((@connectors.has_value? nil or @connectors.has_key? nil), 'Connector hash contains nil')
			t.fail_on((@interfaces.has_value? nil or @interfaces.has_key? nil), 'Interface hash contains nil')
			t.fail_on((@recycle_bin.find_all { |item| !item.kind_of? Message }.length > 0), 'Recycle bin contains garbage')
			t.fail_on((@undelivered_messages.find_all { |item| !item.kind_of? Message }.length > 0), 'Garbage detected among undelivered messages')
			t.fail_on(@inbound_queue.length > 3, 'More than 3 messages are waiting in the inbound queue')
			t.fail_on(@outbound_queue.length > 3, 'More than 3 messages are waiting in the outbound queue')
			t.fail_on((@routing_table.nil? or @routing_table.find_all { |route| !route.kind_of? Route }.length > 0), 'Garbage detected in the routing table')

			status['Core integrity'] = t
		}
	end

	private
	def bootstrap
		@log.debug(:core) { '[bootstrap]' }
		
		register_thread('core.main', Thread.current )

		@configuration.assert_kind Configuration

		@configuration.add_observer self
		@configuration.load
		@configuration.increase('global.stats.startups')

		trap('INT') do
			call_hook('signal_int')
		end

		trap('EXIT') do
			call_hook('signal_exit')
		end

		@log.debug(:core) { '[bootstrap] finished' }
	end

	public #override
	def update(key)
		@log.level = @configuration.get('global.loglevel') unless @configuration.get('global.loglevel').nil?
		@node_name = @configuration.get('global.nodename') unless @configuration.get('global.nodename').nil?
	end

	# Loads modules that grant additional functionality for the core.

	private
	def load_modules
		load_module('features')
		load_module('events')
		load_module('eventlog')
		load_module('threads')
		load_module('interfaces')
		load_module('connectors')
		load_module('router')
		load_module('services')
		load_module('console')
		load_module('config_pump')
		load_module('httpd')
		load_module('statistics')
		load_module('health')
	end

	# Loads the given module from the core/modules directory. The file name and the module 
	# name must match after capitalizing the words and removing the underscores from the
	# filename. 
	#
	# Eg: testmodule -> Testmodule, test_module -> TestModule
	#
	# This method returns true if the loading was successful otherwise it returns false

	private
	def load_module(file_name)
		
		file_name.assert_kind String, Symbol

		if (file_name.kind_of? String)
			begin
				begin
					c = method(:call_hook)
					c.call('pre_load_module', file_name)
				rescue NameError => exception
				end

				load "core/modules/#{file_name.to_s}.rb"
				
				begin
					c = method(:call_hook)
					c.call('post_load_module', file_name)
				rescue NameError => exception
				end

				module_name = file_name.to_s.sub(/_/, ' ').split.collect { |tag| tag.capitalize }.join('')

				e_module = Kernel.const_get("#{module_name.to_s}")

				verbosity = $VERBOSE
				$VERBOSE = false
				
				begin
					c = method(:call_hook)
					c.call('pre_extend_module', e_module)
				rescue NameError => exception
				end

				@log.info(:core) { "[load module] #{module_name.to_s}" }

				self.extend e_module if e_module.kind_of? Module

				@loaded_modules.add e_module

				begin
					c = method(:call_hook)
					c.call('post_extend_module', e_module)
				rescue NameError => exception
				end

				begin
					init_method = e_module.public_instance_method :init_module
					init_module
				rescue NameError => exception
					@log.warn(:core) { "[init module] missing initializer: #{module_name.to_s}" }
				end

				add_feature e_module.feature

				$VERBOSE = verbosity
			rescue LoadError => exception
				@log.error(:core) { "[load module] load error: #{module_name.to_s}" }
				Util.handle_exception(exception)
			rescue NameError => exception
				@log.error(:core) { "[load module] name error: #{module_name.to_s}" }
				Util.handle_exception(exception)
			else
				return true
			end
		end

		return false
	end

	public
	def method_missing(method, *args, &block)
		puts "TODO: implement method_missing #{method.to_s}"
	end

	public
	def start
		call_hook('pre_start')
		call_hook('post_start')
		call_hook('main')
	end

	public
	def rehash
		call_hook('pre_rehash')
		load_modules
		call_hook('post_rehash')
	end
	
	public
	def stop
		call_hook('pre_stop')

		shutdown

		call_hook('post_stop')
	end

	protected
	def shutdown
		@log.info(:core) { '[shutdown]' }

		call_hook('shutdown')

		@log.info(:core) { '[shutdown] finished' }
	end

	private
	def get_binding
		return binding()
	end
end
