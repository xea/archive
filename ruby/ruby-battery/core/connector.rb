require 'core/configuration'
require 'core/interface'
require 'core/message'
require 'logger'
require 'thread'

# A Connector-type object represents one endpoint of communication. 
# A connector may generate message objects and enqueue them to the
# core's inbound queue. A connector must also handle outgoing messages
# and envelopes. 
#
class Connector < Interface

	attr_reader :id, :cfg, :state, :channels, :name, :queue, :inqueue, :enabled

	@@next_id = 0

	def initialize(name = "connector-#{@@next_id + 1}")
		@id = @@next_id += 1
		@name = name.to_s
		@state = Interface::STATE_OFFLINE
		@channels = Hash.new
		@inqueue = Queue.new
		@enabled = true
		
		@log = Logger.new("log/connector-#{@name}.log")
		@log.info(@name) { '[init]' }

		@cfg = Configuration.get_instance "connectors.#{@name.to_s}"
	end

	override
	def class_invariant
		@id.kind_of? Numeric and
		@id >= 0 and
		[ Interface::STATE_ONLINE, Interface::STATE_OFFLINE, Interface::STATE_SUSPENDED, Interface::STATE_CONNECTING ].member? @state and
		@channels.kind_of? Hash
	end

	override
	def test_exceptions
		[ :raw ]
	end

	override(:update)
	def update(key)
		@log.level = @cfg.get('loglevel')
	end

	override
	def connect
		if !@enabled
			@log.error(sym) { '[connect] disabled' }
			return false
		end

		if (@state == Interface::STATE_CONNECTING)
			disconnect
		end

		@state = Interface::STATE_CONNECTING

		@log.info(sym) { '[connect]' }

		main
	end

	override(:suspend)
	def suspend
		if @state == Interface::STATE_CONNECTING or @state == Interface::STATE_ONLINE
			@state = Interface::STATE_SUSPENDED 
			@log.info(sym) { '[suspend] successful' }
		else
			@log.info(sym) { '[suspend] failed' }
		end
	end

	# Descendants should implement their main activity in this method. 
	# It is called when the connect operation was successfully executed.
	
	def main
		@state = Interface::STATE_ONLINE

		@log.info(sym) { '[connect] successful' }
	end

	override
	def disconnect
		@state = Interface::STATE_OFFLINE

		@log.info(sym) { '[disconnect]' }

		return 0
	end

	# Summarizes the current connector in a short string, displaying it's major 
	# settings and state
	
	def infoline
		""
	end

	# Accepts a message or envelope as it's argument and sends out it's content.

	def send(object)
		object.assert_kind Message, Envelope

		if (object.kind_of? Message)
			@log.info(sym) { "[send] message #{object.id}" }
		elsif (object.kind_of? Envelope)
			@log.info(sym) { "[send] envelope #{object.id}" }
		end
	end

	# Adds the specified channel to the connectors channel list

	def add_channel(name)
		name.assert_kind String

		if (name.kind_of? String)
			ch = Channel.new
			ch.name = name
			ch.state = :off
			@channels[name] = ch

			join_channel(name)
			return ch
		end
	end

	# Removes the specified channel from the connectors channel list

	def remove_channel(name)
		name.assert_kind Channel, String

		leave_channel(name)
		@channels.delete name if channel.kind_of? String and @channels.has_key? name
	end
	
	def join_channel(name)
		@channels[name].state = :on if @channels.has_key? name
	end

	def leave_channel(name)
		@channels[name].state = :off if @channels.has_key? name
	end

	def enable_channel(name)
		join_channel(name)
		@channels[name].enable if @channels.has_key? name
	end

	def disable_channel(name)
		leave_channel(name)
		@channels[name].disable if @channels.has_key? name
	end


	def name=(name)
		name.assert_kind String

		if (name.kind_of? String and name.to_s != @name && name.length =~ /^[\w-_.]+$/)
			@name = name.to_s
			@log.close
			@log = Logger.new("log/connector-#{@name}.log")
		end
	end

	def queue=(queue)
		queue.assert_kind Queue

		@queue = queue if queue.kind_of? Queue
	end
	
	def enable
		@enabled = true
	end

	def disable
		@enabled = false

		if (@state == Interface::STATE_ONLINE or @state == Interface::STATE_SUSPENDED)
			disconnect
		end
	end

	def enabled?
		@enabled
	end

	def connected?
		return (@state == Interface::STATE_ONLINE)
	end

	def synchronize_channels
		@channels.assert_kind Hash
	end

	def configuration
		@cfg
	end
	
	private
	def sym
		name.to_sym
	end

end

class Channel
	attr_accessor :name, :state, :infoline
	attr_reader :enabled
	attr_reader :members

	def initialize
		@state = :off
		@enabled = true
		@members = []
		@infoline = ""
	end

	def enabled?
		@enabled
	end

	def enable
		@enabled = true
	end

	def disable
		@enabled = false
	end

end
