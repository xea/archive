require 'time'
require 'core/connector'

# Represents one single message that is received by an endpoint connector.
# Depending on the receiver the message may contain headers about the sender
# or the destination of the message. It 

class Message
	PRIORITY_REALTIME = 4
	PRIORITY_HIGH	= 3
	PRIORITY_NORMAL = 2
	PRIORITY_LOW	= 1
	PRIORITY_TRASH	= 0

private
	@@next_id = 0

public 
	attr_reader :id							# 1234
	attr_reader :ttl						# 32
	attr_reader :date						# 13:44
	attr_reader :priority					# REALTIME
	attr_reader :source_connector			# irc01
	attr_reader :source_channel				# #remalomfold
	attr_reader :source						# xea
	attr_reader :destination_connector		# msn01
	attr_reader :destination_channel		# -
	attr_reader :destination				# xea@gentoo.hu
	attr_reader :content					# asdfg
	attr_reader :route_log

	def initialize
		@id = @@next_id += 1
		@date = Time.now
		@priority = PRIORITY_NORMAL
		@source_channel = nil
		@source_connector = nil
		@source = nil
		@destination_channel = nil
		@destination_connector = nil
		@destination = nil
		@ttl = 32
		@route_log = []
	end

	def class_invariant
		@ttl.to_i >= 0 and
		@id >= 0 and
		@date.kind_of? Time and
		@priority >= PRIORITY_TRASH and @priority <= PRIORITY_REALTIME and
		(@source.kind_of? String or 
			@source.nil?) and
		(@source_channel.kind_of? String or 
			@source_channel.nil?) and
		(@source_connector.kind_of? Symbol or
			@source_connector.nil?)
		(@destination.kind_of? String or 
			@destination.nil?) and
		(@destination_channel.kind_of? String or 
			@destination_channel.nil?) and
		(@destination_connector.kind_of? Symbol or
			@destination_connector.nil?)
	end

	def ttl=(value)
		value.assert_kind? Numeric

		@ttl = value.to_i if value.kind_of? Numeric and value >= 0
	end

	def priority=(value)
		value.assert_kind? Numeric, Symbol

		priority = value.to_s.to_i

		if (priority >= PRIORITY_TRASH and priority <= PRIORITY_REALTIME)
			@priority = priority
		elsif (priority < PRIORITY_TRASH)
			@priority = PRIORITY_TRASH
		elsif (priority > PRIORITY_REALTIME)
			@priority = PRIORITY_REALTIME
		end
	end

	def source=(value)
		value.assert_kind String, NilClass

		@source = value.to_s
	end

	def source_channel=(value)
		value.assert_kind String, NilClass

		@source_channel = value.to_s
	end

	def source_connector=(value)
		value.assert_kind Connector

		@source_connector = value if value.kind_of? Connector
	end
	
	def destination=(value)
		value.assert_kind String, NilClass

		@destination = value.to_s
	end

	def destination_channel=(value)
		value.assert_kind String, NilClass

		@destination_channel = value.to_s
	end

	def destination_connector=(value)
		value.assert_kind Symbol, NilClass

		@destination_connector = value if value.kind_of? Symbol
	end

	def content=(value)
		value.assert_kind String, NilClass

		@content = value.to_s
	end

	def append_log(src, &msg)
		if (block_given?)
			@route_log << "#{Time.now.to_s} [#{src.to_s}] #{msg.call.to_s}"
		end
	end
end

# It wraps around one or more messages that are destined to the same route target.

class Envelope

	attr_reader :messages, :id
	attr_reader :destination
	
	@@next_id = 0
	
	def initialize(destination = nil, messages = [])
		messages.assert_kind Array
		@id = @@next_id += 1
		@messages = messages
		@destination = destination
	end

	def destination=(value)
		value.assert_kind Symbol

		@destination = value.to_s.to_sym
	end

	def clear
		@messages.clear
	end

	def class_invariant
		@id >= 0 and 
		@messages.kind_of?(Array) and 
		(@destination.kind_of?(Symbol) or 
			@destination.nil?)
	end
end

